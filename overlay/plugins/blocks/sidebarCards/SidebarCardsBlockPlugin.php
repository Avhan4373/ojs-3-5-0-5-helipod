<?php

/**
 * @file plugins/blocks/sidebarCards/SidebarCardsBlockPlugin.php
 *
 * Sidebar Cards block for OJS 3.5.
 *
 * Renders configurable sidebar cards inspired by gudangjurnal.com:
 * Chat Us, Journal Template, Recommended Tools, Popular Articles and
 * any number of custom cards. All content is managed by journal managers
 * from Settings > Website > Plugins > Block Plugins.
 *
 * Distributed under the GNU GPL v3.
 */

namespace APP\plugins\blocks\sidebarCards;

use APP\core\Application;
use APP\file\PublicFileManager;
use APP\submission\Submission;
use Illuminate\Support\Facades\DB;
use PKP\core\JSONMessage;
use PKP\linkAction\LinkAction;
use PKP\linkAction\request\AjaxModal;
use PKP\plugins\BlockPlugin;
use Throwable;

class SidebarCardsBlockPlugin extends BlockPlugin
{
    /** Maximum number of popular articles a manager may request. */
    private const MAX_POPULAR_ARTICLES = 20;

    /**
     * @copydoc Plugin::getDisplayName()
     */
    public function getDisplayName(): string
    {
        return __('plugins.block.sidebarCards.displayName');
    }

    /**
     * @copydoc Plugin::getDescription()
     */
    public function getDescription(): string
    {
        return __('plugins.block.sidebarCards.description');
    }

    /**
     * @copydoc Plugin::getActions()
     */
    public function getActions($request, $verb)
    {
        $router = $request->getRouter();

        return array_merge(
            $this->getEnabled() ? [
                new LinkAction(
                    'settings',
                    new AjaxModal(
                        $router->url($request, null, null, 'manage', null, [
                            'verb' => 'settings',
                            'plugin' => $this->getName(),
                            'category' => 'blocks',
                        ]),
                        $this->getDisplayName()
                    ),
                    __('manager.plugins.settings'),
                    null
                ),
            ] : [],
            parent::getActions($request, $verb)
        );
    }

    /**
     * @copydoc Plugin::manage()
     */
    public function manage($args, $request)
    {
        if ($request->getUserVar('verb') === 'upload') {
            return $this->uploadImage($request);
        }

        $context = $request->getContext();
        if (!$context) {
            return new JSONMessage(false, __('plugins.block.sidebarCards.error.noContext'));
        }

        $form = new SidebarCardsSettingsForm($this, (int) $context->getId());

        if ($request->getUserVar('save')) {
            $form->readInputData();
            if ($form->validate()) {
                $form->execute();
                return new JSONMessage(true);
            }
        } else {
            $form->initData();
        }

        return new JSONMessage(true, $form->fetch($request));
    }

    /**
     * @copydoc BlockPlugin::getContents()
     *
     * @param null|mixed $request
     */
    public function getContents($templateMgr, $request = null)
    {
        $request = $request ?? Application::get()->getRequest();
        $context = $request?->getContext();
        if (!$context) {
            return '';
        }

        $contextId = (int) $context->getId();

        $chatEnabled = $this->boolSetting($contextId, 'chatEnabled', true);
        $templateEnabled = $this->boolSetting($contextId, 'templateEnabled', true);
        $toolsEnabled = $this->boolSetting($contextId, 'toolsEnabled', true);
        $popularEnabled = $this->boolSetting($contextId, 'popularEnabled', true);

        $displayPages = (string) ($this->getSetting($contextId, 'displayPages') ?? 'all');
        if ($displayPages === 'home' && !in_array($request->getRequestedPage(), ['', 'index'], true)) {
            return '';
        }

        $contactUrl = $request->getDispatcher()->url(
            $request,
            Application::ROUTE_PAGE,
            $context->getPath(),
            'about',
            'contact'
        );
        $submissionsUrl = $request->getDispatcher()->url(
            $request,
            Application::ROUTE_PAGE,
            $context->getPath(),
            'about',
            'submissions'
        );

        $chatUrl = $this->getSetting($contextId, 'chatUrl');
        $templateUrl = $this->getSetting($contextId, 'templateUrl');

        $tools = $this->getSetting($contextId, 'tools');
        if (!is_array($tools)) {
            $tools = self::defaultTools();
        }

        $customCards = $this->getSetting($contextId, 'customCards');
        if (!is_array($customCards)) {
            $customCards = [];
        }

        $popularCount = (int) ($this->getSetting($contextId, 'popularCount') ?? 5);
        $popularCount = max(1, min(self::MAX_POPULAR_ARTICLES, $popularCount));

        $templateMgr->assign([
            'sidebarCardsChatEnabled' => $chatEnabled,
            'sidebarCardsChatTitle' => $this->getSetting($contextId, 'chatTitle') ?: 'Chat Us',
            'sidebarCardsChatUrl' => $chatUrl === null ? $contactUrl : (string) $chatUrl,
            'sidebarCardsChatImage' => $this->normalizeImage($request, $contextId, $this->getSetting($contextId, 'chatImage')),
            'sidebarCardsChatDescription' => $this->getSetting($contextId, 'chatDescription') ?: __('plugins.block.sidebarCards.default.chatDescription'),

            'sidebarCardsTemplateEnabled' => $templateEnabled,
            'sidebarCardsTemplateTitle' => $this->getSetting($contextId, 'templateTitle') ?: 'Journal Template',
            'sidebarCardsTemplateUrl' => $templateUrl === null ? $submissionsUrl : (string) $templateUrl,
            'sidebarCardsTemplateImage' => $this->normalizeImage($request, $contextId, $this->getSetting($contextId, 'templateImage')),
            'sidebarCardsTemplateDescription' => $this->getSetting($contextId, 'templateDescription') ?: __('plugins.block.sidebarCards.default.templateDescription'),

            'sidebarCardsToolsEnabled' => $toolsEnabled,
            'sidebarCardsToolsTitle' => $this->getSetting($contextId, 'toolsTitle') ?: 'Recommended Tools',
            'sidebarCardsTools' => $this->normalizeTools($request, $contextId, $tools),

            'sidebarCardsPopularEnabled' => $popularEnabled,
            'sidebarCardsPopularTitle' => $this->getSetting($contextId, 'popularTitle') ?: 'Popular Article',
            'sidebarCardsPopular' => $popularEnabled ? $this->getPopularArticles($request, $context, $popularCount) : [],

            'sidebarCardsCustom' => $this->normalizeCustomCards($request, $contextId, $customCards),
        ]);

        return parent::getContents($templateMgr, $request);
    }

    /**
     * Read a boolean plugin setting with a default for new installs.
     */
    private function boolSetting(int $contextId, string $name, bool $default): bool
    {
        $value = $this->getSetting($contextId, $name);
        return $value === null ? $default : (bool) $value;
    }

    /**
     * Turn a stored relative filename into a public URL.
     */
    private function normalizeImage($request, int $contextId, mixed $value): string
    {
        $value = trim((string) $value);
        if ($value === '') {
            return '';
        }

        if (preg_match('#^https?://#i', $value)) {
            return $value;
        }

        $publicFileManager = new PublicFileManager();
        return rtrim($request->getBaseUrl(), '/')
            . '/'
            . $publicFileManager->getContextFilesPath($contextId)
            . '/'
            . ltrim($value, '/');
    }

    /**
     * Normalize the tools list and resolve uploaded images.
     *
     * @return array<int, array{title: string, url: string, image: string}>
     */
    private function normalizeTools($request, int $contextId, array $tools): array
    {
        $normalized = [];
        foreach ($tools as $tool) {
            if (!is_array($tool)) {
                continue;
            }
            $title = trim((string) ($tool['title'] ?? ''));
            $url = trim((string) ($tool['url'] ?? ''));
            $image = $this->normalizeImage($request, $contextId, $tool['image'] ?? '');

            if ($title === '' && $url === '' && $image === '') {
                continue;
            }

            $normalized[] = [
                'title' => $title,
                'url' => $url,
                'image' => $image,
            ];
        }

        return $normalized;
    }

    /**
     * Normalize custom cards.
     *
     * @return array<int, array{title: string, image: string, url: string, content: string}>
     */
    private function normalizeCustomCards($request, int $contextId, array $cards): array
    {
        $normalized = [];

        foreach ($cards as $card) {
            if (!is_array($card) || empty($card['enabled'])) {
                continue;
            }

            $title = trim((string) ($card['title'] ?? ''));
            $url = trim((string) ($card['url'] ?? ''));
            $content = (string) ($card['content'] ?? '');
            $image = $this->normalizeImage($request, $contextId, $card['image'] ?? '');

            if ($title === '' && $url === '' && $content === '' && $image === '') {
                continue;
            }

            $normalized[] = [
                'title' => $title,
                'image' => $image,
                'url' => $url,
                'content' => $content,
            ];
        }

        return $normalized;
    }

    /**
     * Most-viewed published articles in this journal.
     *
     * @return array<int, array{title: string, url: string, views: int}>
     */
    private function getPopularArticles($request, $context, int $limit): array
    {
        try {
            $rows = DB::table('metrics_counter_submission_monthly as m')
                ->join('submissions as s', 's.submission_id', '=', 'm.submission_id')
                ->join('publications as p', 'p.publication_id', '=', 's.current_publication_id')
                ->join('publication_settings as ps', function ($join) {
                    $join->on('ps.publication_id', '=', 'p.publication_id')
                        ->where('ps.setting_name', '=', 'title');
                })
                ->where('m.context_id', (int) $context->getId())
                ->where('s.status', Submission::STATUS_PUBLISHED)
                ->selectRaw('s.submission_id, MAX(ps.setting_value) AS title, SUM(m.metric_investigations) AS views')
                ->groupBy('s.submission_id')
                ->orderByDesc('views')
                ->limit($limit)
                ->get();
        } catch (Throwable $e) {
            return [];
        }

        $dispatcher = $request->getDispatcher();
        $articles = [];

        foreach ($rows as $row) {
            $articles[] = [
                'title' => (string) $row->title,
                'url' => $dispatcher->url(
                    $request,
                    Application::ROUTE_PAGE,
                    $context->getPath(),
                    'article',
                    'view',
                    [(int) $row->submission_id]
                ),
                'views' => (int) $row->views,
            ];
        }

        return $articles;
    }

    /**
     * Default tool links shown before a manager customizes them.
     *
     * @return array<int, array{title: string, url: string, image: string}>
     */
    public static function defaultTools(): array
    {
        return [
            ['title' => 'Turnitin', 'url' => 'https://www.turnitin.com/', 'image' => ''],
            ['title' => 'Mendeley', 'url' => 'https://www.mendeley.com/', 'image' => ''],
            ['title' => 'Zotero', 'url' => 'https://www.zotero.org/', 'image' => ''],
            ['title' => 'Grammarly', 'url' => 'https://www.grammarly.com/', 'image' => ''],
            ['title' => 'QuillBot', 'url' => 'https://quillbot.com/', 'image' => ''],
            ['title' => 'iThenticate', 'url' => 'https://www.ithenticate.com/', 'image' => ''],
        ];
    }

    /**
     * Handle an AJAX image upload from the settings form.
     */
    private function uploadImage($request): JSONMessage
    {
        if (!$request->checkCSRF()) {
            return new JSONMessage(false, __('plugins.block.sidebarCards.error.csrf'));
        }

        $context = $request->getContext();
        if (!$context) {
            return new JSONMessage(false, __('plugins.block.sidebarCards.error.noContext'));
        }

        $file = $_FILES['image'] ?? null;
        if (!$file || ($file['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
            return new JSONMessage(false, __('plugins.block.sidebarCards.error.upload'));
        }

        if (($file['size'] ?? 0) > 4 * 1024 * 1024) {
            return new JSONMessage(false, __('plugins.block.sidebarCards.error.uploadSize'));
        }

        $extension = strtolower(pathinfo((string) $file['name'], PATHINFO_EXTENSION));
        $allowed = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

        if (!in_array($extension, $allowed, true)) {
            return new JSONMessage(false, __('plugins.block.sidebarCards.error.uploadType'));
        }

        $mime = '';
        if (class_exists(\finfo::class)) {
            $finfo = new \finfo(FILEINFO_MIME_TYPE);
            $mime = (string) $finfo->file((string) $file['tmp_name']);
        }

        $allowedMimes = [
            'image/jpeg',
            'image/png',
            'image/gif',
            'image/webp',
        ];

        if ($mime !== '' && !in_array($mime, $allowedMimes, true)) {
            return new JSONMessage(false, __('plugins.block.sidebarCards.error.uploadType'));
        }

        $contextId = (int) $context->getId();
        $destination = 'sidebar-cards/' . uniqid('card-', true) . '.' . $extension;

        $publicFileManager = new PublicFileManager();
        if (!$publicFileManager->uploadContextFile($contextId, 'image', $destination)) {
            return new JSONMessage(false, __('plugins.block.sidebarCards.error.upload'));
        }

        $url = rtrim($request->getBaseUrl(), '/')
            . '/'
            . $publicFileManager->getContextFilesPath($contextId)
            . '/'
            . $destination;

        return new JSONMessage(true, $url);
    }
}

if (!PKP_STRICT_MODE) {
    class_alias('\APP\plugins\blocks\sidebarCards\SidebarCardsBlockPlugin', '\SidebarCardsBlockPlugin');
}
