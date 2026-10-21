<?php

/**
 * @file plugins/blocks/sidebarCards/SidebarCardsSettingsForm.php
 *
 * Settings form for the Sidebar Cards block.
 *
 * Distributed under the GNU GPL v3.
 */

namespace APP\plugins\blocks\sidebarCards;

use PKP\form\Form;
use PKP\form\validation\FormValidatorCSRF;
use PKP\form\validation\FormValidatorPost;

class SidebarCardsSettingsForm extends Form
{
    private SidebarCardsBlockPlugin $plugin;

    private int $contextId;

    public function __construct(SidebarCardsBlockPlugin $plugin, int $contextId)
    {
        $this->plugin = $plugin;
        $this->contextId = $contextId;

        parent::__construct($plugin->getTemplateResource('settingsForm.tpl'));

        $this->addCheck(new FormValidatorPost($this));
        $this->addCheck(new FormValidatorCSRF($this));
    }

    /**
     * @copydoc Form::initData()
     */
    public function initData()
    {
        $this->_data = [
            'chatEnabled' => $this->plugin->getSetting($this->contextId, 'chatEnabled') ?? true,
            'chatTitle' => $this->plugin->getSetting($this->contextId, 'chatTitle') ?: 'Chat Us',
            'chatUrl' => $this->plugin->getSetting($this->contextId, 'chatUrl') ?? '',
            'chatImage' => $this->plugin->getSetting($this->contextId, 'chatImage') ?? '',
            'chatDescription' => $this->plugin->getSetting($this->contextId, 'chatDescription') ?? '',

            'templateEnabled' => $this->plugin->getSetting($this->contextId, 'templateEnabled') ?? true,
            'templateTitle' => $this->plugin->getSetting($this->contextId, 'templateTitle') ?: 'Journal Template',
            'templateUrl' => $this->plugin->getSetting($this->contextId, 'templateUrl') ?? '',
            'templateImage' => $this->plugin->getSetting($this->contextId, 'templateImage') ?? '',
            'templateDescription' => $this->plugin->getSetting($this->contextId, 'templateDescription') ?? '',

            'toolsEnabled' => $this->plugin->getSetting($this->contextId, 'toolsEnabled') ?? true,
            'toolsTitle' => $this->plugin->getSetting($this->contextId, 'toolsTitle') ?: 'Recommended Tools',
            'tools' => $this->plugin->getSetting($this->contextId, 'tools') ?: SidebarCardsBlockPlugin::defaultTools(),

            'popularEnabled' => $this->plugin->getSetting($this->contextId, 'popularEnabled') ?? true,
            'popularTitle' => $this->plugin->getSetting($this->contextId, 'popularTitle') ?: 'Popular Article',
            'popularCount' => $this->plugin->getSetting($this->contextId, 'popularCount') ?? 5,

            'customCards' => $this->plugin->getSetting($this->contextId, 'customCards') ?: [],
            'displayPages' => $this->plugin->getSetting($this->contextId, 'displayPages') ?? 'all',
        ];

        parent::initData();
    }

    /**
     * @copydoc Form::readInputData()
     */
    public function readInputData()
    {
        $this->readUserVars([
            'chatEnabled',
            'chatTitle',
            'chatUrl',
            'chatImage',
            'chatDescription',
            'templateEnabled',
            'templateTitle',
            'templateUrl',
            'templateImage',
            'templateDescription',
            'toolsEnabled',
            'toolsTitle',
            'tools',
            'popularEnabled',
            'popularTitle',
            'popularCount',
            'customCards',
            'displayPages',
        ]);

        parent::readInputData();
    }

    /**
     * @copydoc Form::fetch()
     *
     * @param null|mixed $template
     */
    public function fetch($request, $template = null, $display = false)
    {
        \APP\template\TemplateManager::getManager($request)->assign('pluginName', $this->plugin->getName());
        return parent::fetch($request, $template, $display);
    }

    /**
     * @copydoc Form::execute()
     */
    public function execute(...$functionArgs)
    {
        $id = $this->contextId;

        foreach (['chat', 'template'] as $prefix) {
            $this->plugin->updateSetting($id, "{$prefix}Enabled", (bool) $this->getData("{$prefix}Enabled"), 'bool');
            $this->plugin->updateSetting($id, "{$prefix}Title", trim((string) $this->getData("{$prefix}Title")), 'string');
            $this->plugin->updateSetting($id, "{$prefix}Url", trim((string) $this->getData("{$prefix}Url")), 'string');
            $this->plugin->updateSetting($id, "{$prefix}Image", trim((string) $this->getData("{$prefix}Image")), 'string');
            $this->plugin->updateSetting($id, "{$prefix}Description", trim((string) $this->getData("{$prefix}Description")), 'string');
        }

        $this->plugin->updateSetting($id, 'toolsEnabled', (bool) $this->getData('toolsEnabled'), 'bool');
        $this->plugin->updateSetting($id, 'toolsTitle', trim((string) $this->getData('toolsTitle')), 'string');
        $this->plugin->updateSetting($id, 'tools', $this->cleanTools($this->getData('tools')), 'object');

        $this->plugin->updateSetting($id, 'popularEnabled', (bool) $this->getData('popularEnabled'), 'bool');
        $this->plugin->updateSetting($id, 'popularTitle', trim((string) $this->getData('popularTitle')), 'string');
        $this->plugin->updateSetting(
            $id,
            'popularCount',
            max(1, min(20, (int) $this->getData('popularCount'))),
            'int'
        );

        $this->plugin->updateSetting($id, 'customCards', $this->cleanCustomCards($this->getData('customCards')), 'object');

        $displayPages = (string) $this->getData('displayPages');
        $this->plugin->updateSetting($id, 'displayPages', $displayPages === 'home' ? 'home' : 'all', 'string');

        parent::execute(...$functionArgs);
    }

    /**
     * Drop empty rows and normalize tool data.
     *
     * @return array<int, array{title: string, url: string, image: string}>
     */
    private function cleanTools(mixed $tools): array
    {
        if (!is_array($tools)) {
            return [];
        }

        $clean = [];
        foreach ($tools as $tool) {
            if (!is_array($tool)) {
                continue;
            }

            $title = trim((string) ($tool['title'] ?? ''));
            $url = trim((string) ($tool['url'] ?? ''));
            $image = trim((string) ($tool['image'] ?? ''));

            if ($title === '' && $url === '' && $image === '') {
                continue;
            }

            $clean[] = [
                'title' => $title,
                'url' => $url,
                'image' => $image,
            ];
        }

        return $clean;
    }

    /**
     * Drop empty custom cards and normalize their data.
     *
     * @return array<int, array{enabled: bool, title: string, url: string, image: string, content: string}>
     */
    private function cleanCustomCards(mixed $cards): array
    {
        if (!is_array($cards)) {
            return [];
        }

        $clean = [];
        foreach ($cards as $card) {
            if (!is_array($card)) {
                continue;
            }

            $title = trim((string) ($card['title'] ?? ''));
            $url = trim((string) ($card['url'] ?? ''));
            $image = trim((string) ($card['image'] ?? ''));
            $content = trim((string) ($card['content'] ?? ''));

            if ($title === '' && $url === '' && $image === '' && $content === '') {
                continue;
            }

            $clean[] = [
                'enabled' => !empty($card['enabled']),
                'title' => $title,
                'url' => $url,
                'image' => $image,
                'content' => $content,
            ];
        }

        return $clean;
    }
}

if (!PKP_STRICT_MODE) {
    class_alias('\APP\plugins\blocks\sidebarCards\SidebarCardsSettingsForm', '\SidebarCardsSettingsForm');
}
