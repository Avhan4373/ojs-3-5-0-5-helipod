<?php

/**
 * @file plugins/themes/academic/AcademicThemePlugin.php
 *
 * Academic theme for OJS 3.5 — Bootstrap 5 based journal theme.
 *
 * This is a port of the "Academic Theme for OJS 3.3" (Bootstrap 5.3) to the
 * Open Journal Systems 3.5 frontend. It keeps the original visual language
 * (topbar, branding header, sticky navbar, hero card, statistic cards,
 * 12-month usage chart, article cards, sidebar blocks and custom footer) while
 * rendering the markup that OJS 3.5 actually provides.
 *
 * Distributed under the GNU GPL v3.
 */

namespace APP\plugins\themes\academic;

use APP\core\Application;
use APP\submission\Submission;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use PKP\plugins\Hook;
use PKP\plugins\ThemePlugin;
use Throwable;

class AcademicThemePlugin extends ThemePlugin
{
    /**
     * Get the display name of this plugin.
     */
    public function getDisplayName()
    {
        return __('plugins.themes.academic.name');
    }

    /**
     * Get the description of this plugin.
     */
    public function getDescription()
    {
        return __('plugins.themes.academic.description');
    }

    /**
     * Per-request cache of submission usage statistics.
     *
     * @var array<int, array{views: int, downloads: int}>|null
     */
    private static ?array $submissionStats = null;

    /** @var bool Guard against double Smarty plugin registration in one request */
    private static bool $templateHelpersRegistered = false;

    /**
     * @copydoc ThemePlugin::init()
     */
    public function init()
    {
        // Inherit the OJS default theme (base components, jQuery, dropdowns,
        // sidebar, article pages). Our stylesheets are registered after the
        // parent's, so they win in the cascade.
        $this->setParent('default');

        $this->addOption('colourScheme', 'FieldOptions', [
            'type' => 'radio',
            'label' => __('plugins.themes.academic.option.colourScheme.label'),
            'description' => __('plugins.themes.academic.option.colourScheme.description'),
            'options' => [
                ['value' => 'emerald', 'label' => __('plugins.themes.academic.option.colourScheme.emerald')],
                ['value' => 'indigo', 'label' => __('plugins.themes.academic.option.colourScheme.indigo')],
                ['value' => 'teal', 'label' => __('plugins.themes.academic.option.colourScheme.teal')],
                ['value' => 'burgundy', 'label' => __('plugins.themes.academic.option.colourScheme.burgundy')],
                ['value' => 'slate', 'label' => __('plugins.themes.academic.option.colourScheme.slate')],
            ],
            'default' => 'emerald',
        ]);

        $this->addOption('headerStyle', 'FieldOptions', [
            'type' => 'radio',
            'label' => __('plugins.themes.academic.option.headerStyle.label'),
            'description' => __('plugins.themes.academic.option.headerStyle.description'),
            'options' => [
                ['value' => 'light', 'label' => __('plugins.themes.academic.option.headerStyle.light')],
                ['value' => 'dark', 'label' => __('plugins.themes.academic.option.headerStyle.dark')],
                ['value' => 'colored', 'label' => __('plugins.themes.academic.option.headerStyle.colored')],
            ],
            'default' => 'light',
        ]);

        $this->addOption('typography', 'FieldOptions', [
            'type' => 'radio',
            'label' => __('plugins.themes.academic.option.typography.label'),
            'description' => __('plugins.themes.academic.option.typography.description'),
            'options' => [
                ['value' => 'inter', 'label' => __('plugins.themes.academic.option.typography.inter')],
                ['value' => 'lora', 'label' => __('plugins.themes.academic.option.typography.lora')],
                ['value' => 'merriweather', 'label' => __('plugins.themes.academic.option.typography.merriweather')],
                ['value' => 'roboto', 'label' => __('plugins.themes.academic.option.typography.roboto')],
            ],
            'default' => 'inter',
        ]);

        $this->addOption('showStats', 'FieldOptions', [
            'label' => __('plugins.themes.academic.option.showStats.label'),
            'description' => __('plugins.themes.academic.option.showStats.description'),
            'options' => [
                ['value' => true, 'label' => __('plugins.themes.academic.option.showStats.option')],
            ],
            'default' => true,
        ]);

        $this->addOption('showChart', 'FieldOptions', [
            'label' => __('plugins.themes.academic.option.showChart.label'),
            'description' => __('plugins.themes.academic.option.showChart.description'),
            'options' => [
                ['value' => true, 'label' => __('plugins.themes.academic.option.showChart.option')],
            ],
            'default' => true,
        ]);

        $this->addOption('showAboutCover', 'FieldOptions', [
            'label' => __('plugins.themes.academic.option.showAboutCover.label'),
            'description' => __('plugins.themes.academic.option.showAboutCover.description'),
            'options' => [
                ['value' => true, 'label' => __('plugins.themes.academic.option.showAboutCover.option')],
            ],
            'default' => true,
        ]);

        $this->addOption('footerCredit', 'FieldText', [
            'label' => __('plugins.themes.academic.option.footerCredit.label'),
            'description' => __('plugins.themes.academic.option.footerCredit.description'),
            'default' => '',
        ]);

        // Fonts: the same families used by the original theme.
        $this->addStyle(
            'academicGoogleFonts',
            'https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Merriweather:ital,wght@0,300;0,400;0,700;1,300;1,400&family=Lora:ital,wght@0,400;0,600;0,700;1,400&family=Roboto:wght@300;400;500;700&display=swap',
            ['baseUrl' => '']
        );

        // Bootstrap 5.3 + icon font + the ported academic stylesheet.
        // The file mtime busts browser caches whenever the theme is edited.
        $cssVersion = @filemtime(__DIR__ . '/assets/css/academic.css') ?: '1';
        $jsVersion = @filemtime(__DIR__ . '/assets/js/academic.js') ?: '1';
        $this->addStyle('bootstrap', 'assets/css/bootstrap.min.css');
        $this->addStyle('bootstrapIcons', 'assets/css/bootstrap-icons.min.css');
        $this->addStyle('academic', 'assets/css/academic.css?v=' . $cssVersion);

        // Bootstrap bundle (navbar/dropdowns) + Chart.js + theme behaviour.
        $this->addScript('bootstrapBundle', 'assets/js/bootstrap.bundle.min.js');
        $this->addScript('chartjs', 'assets/js/chart.umd.min.js');
        $this->addScript('academic', 'assets/js/academic.js?v=' . $jsVersion);

        // The theme renders both navigation areas.
        $this->addMenuArea(['primary', 'user']);

        $this->registerTemplateHelpers();

        // The homepage statistics are assigned just before the template is
        // rendered, once the request has been routed to the journal index.
        Hook::add('TemplateManager::display', function (string $hookName, array $args): void {
            /** @var \TemplateManager|null $templateMgr */
            $templateMgr = $args[0] ?? null;
            if ($templateMgr) {
                // Used by the footer copyright line on every frontend page.
                $templateMgr->assign('acadCurrentYear', Carbon::now()->year);
            }

            $template = (string) ($args[1] ?? '');
            if (!str_contains($template, 'indexJournal')) {
                return;
            }

            $this->assignHomepageData($templateMgr);
        });
    }

    /**
     * Register Smarty helpers used by the theme templates.
     */
    private function registerTemplateHelpers(): void
    {
        if (self::$templateHelpersRegistered) {
            return;
        }

        $request = Application::get()->getRequest();
        if (!$request) {
            return;
        }

        self::$templateHelpersRegistered = true;

        try {
            $templateMgr = \TemplateManager::getManager($request);
        } catch (Throwable $e) {
            return;
        }

        // {acad_article_stats article=$article assign="stats"}
        $templateMgr->registerPlugin('function', 'acad_article_stats', function ($params, $smarty) use ($templateMgr) {
            $article = $params['article'] ?? null;
            $stats = $article
                ? $this->getSubmissionStats((int) $article->getId())
                : ['views' => 0, 'downloads' => 0];

            if (!empty($params['assign'])) {
                $target = $smarty ?? $templateMgr;
                $target->assign($params['assign'], $stats);
                return '';
            }

            return '';
        });

        // {acad_number value=$n} → Indonesian thousands separator ("77.120")
        $templateMgr->registerPlugin('function', 'acad_number', function ($params) {
            $value = (int) ($params['value'] ?? 0);
            return number_format($value, 0, ',', '.');
        });

        // {acad_author_country authorId=$id assign="country"}
        // OJS 3.3 stored the author country in author_settings; OJS 3.5 does
        // not expose it on the Author object anymore. Read the legacy value
        // so the Academic article page can keep the original author card.
        $templateMgr->registerPlugin('function', 'acad_author_country', function ($params, $smarty) use ($templateMgr) {
            $authorId = (int) ($params['authorId'] ?? 0);
            $country = '';

            if ($authorId) {
                try {
                    $code = DB::table('author_settings')
                        ->where('author_id', $authorId)
                        ->where('setting_name', 'country')
                        ->value('setting_value');

                    if ($code) {
                        $record = \PKP\facades\Locale::getCountries()->getByAlpha2(strtoupper((string) $code));
                        $country = $record ? $record->getName() : (string) $code;
                    }
                } catch (Throwable $e) {
                    $country = '';
                }
            }

            if (!empty($params['assign'])) {
                $target = $smarty ?? $templateMgr;
                $target->assign($params['assign'], $country);
                return '';
            }

            return $country;
        });

        // {acad_submission_chart article=$article assign="chart"}
        // OJS 3.5's core download chart reads the raw metrics_submission table.
        // This theme uses the aggregated monthly counter table so the article
        // chart also works when only aggregate usage data is available.
        $templateMgr->registerPlugin('function', 'acad_submission_chart', function ($params, $smarty) use ($templateMgr) {
            $article = $params['article'] ?? null;
            $submissionId = $article ? (int) $article->getId() : 0;

            $labels = [];
            $views = [];
            $downloads = [];
            $rows = [];

            if ($submissionId) {
                try {
                    $start = Carbon::now()->startOfMonth()->subMonths(11);
                    $rows = DB::table('metrics_counter_submission_monthly')
                        ->selectRaw('month, COALESCE(SUM(metric_investigations), 0) as views, COALESCE(SUM(metric_requests), 0) as downloads')
                        ->where('submission_id', $submissionId)
                        ->where('month', '>=', (int) $start->format('Ym'))
                        ->groupBy('month')
                        ->get()
                        ->keyBy('month');
                } catch (Throwable $e) {
                    $rows = [];
                }
            }

            $start = Carbon::now()->startOfMonth()->subMonths(11);
            for ($i = 0; $i < 12; $i++) {
                $month = $start->copy()->addMonths($i);
                $key = (int) $month->format('Ym');
                $row = $rows[$key] ?? null;
                $labels[] = $month->format('M Y');
                $views[] = (int) ($row->views ?? 0);
                $downloads[] = (int) ($row->downloads ?? 0);
            }

            $chart = [
                'labels' => $labels,
                'views' => $views,
                'downloads' => $downloads,
                'hasData' => array_sum($views) + array_sum($downloads) > 0,
            ];
            $chart['json'] = json_encode($chart);

            if (!empty($params['assign'])) {
                $target = $smarty ?? $templateMgr;
                $target->assign($params['assign'], $chart);
                return '';
            }

            return '';
        });
    }

    /**
     * Assign the homepage statistics (cards + 12 month chart).
     */
    private function assignHomepageData(?object $templateMgr = null): void
    {
        $request = Application::get()->getRequest();
        if (!$request) {
            return;
        }

        $context = $request->getContext();
        if (!$context) {
            return;
        }

        if (!$templateMgr) {
            try {
                $templateMgr = \TemplateManager::getManager($request);
            } catch (Throwable $e) {
                return;
            }
        }

        $contextId = (int) $context->getId();

        $stats = [
            'articles' => 0,
            'authors' => 0,
            'issues' => 0,
            'views' => 0,
            'downloads' => 0,
        ];

        try {
            $stats['articles'] = (int) DB::table('submissions')
                ->where('context_id', $contextId)
                ->where('status', Submission::STATUS_PUBLISHED)
                ->count();

            $stats['authors'] = (int) DB::table('authors as a')
                ->join('publications as p', 'p.publication_id', '=', 'a.publication_id')
                ->join('submissions as s', 's.submission_id', '=', 'p.submission_id')
                ->where('s.context_id', $contextId)
                ->where('s.status', Submission::STATUS_PUBLISHED)
                ->distinct()
                ->count('a.email');

            $stats['issues'] = (int) DB::table('issues')
                ->where('journal_id', $contextId)
                ->where('published', 1)
                ->count();

            $totals = DB::table('metrics_counter_submission_monthly')
                ->selectRaw('COALESCE(SUM(metric_investigations), 0) as views, COALESCE(SUM(metric_requests), 0) as downloads')
                ->where('context_id', $contextId)
                ->first();

            $stats['views'] = (int) ($totals->views ?? 0);
            $stats['downloads'] = (int) ($totals->downloads ?? 0);
        } catch (Throwable $e) {
            // Never break the frontend because of statistics.
        }

        $chart = $this->getMonthlyChartData($contextId);

        $templateMgr->assign([
            'acadStats' => $stats,
            'acadChart' => $chart,
            'acadChartHasData' => array_sum($chart['views']) + array_sum($chart['downloads']) > 0,
            'acadCurrentYear' => Carbon::now()->year,
        ]);
    }

    /**
     * Build the last-12-months views/downloads series.
     *
     * @return array{labels: array<int, string>, views: array<int, int>, downloads: array<int, int>}
     */
    private function getMonthlyChartData(int $contextId): array
    {
        $labels = [];
        $views = [];
        $downloads = [];

        $start = Carbon::now()->startOfMonth()->subMonths(11);

        $rows = [];
        try {
            $rows = DB::table('metrics_counter_submission_monthly')
                ->selectRaw('month, COALESCE(SUM(metric_investigations), 0) as views, COALESCE(SUM(metric_requests), 0) as downloads')
                ->where('context_id', $contextId)
                ->where('month', '>=', (int) $start->format('Ym'))
                ->groupBy('month')
                ->get()
                ->keyBy('month');
        } catch (Throwable $e) {
            // Usage statistics may be unavailable; the chart will render empty.
        }

        for ($i = 0; $i < 12; $i++) {
            $month = $start->copy()->addMonths($i);
            $key = (int) $month->format('Ym');
            $row = $rows[$key] ?? null;

            $labels[] = $month->format('M Y');
            $views[] = (int) ($row->views ?? 0);
            $downloads[] = (int) ($row->downloads ?? 0);
        }

        return [
            'labels' => $labels,
            'views' => $views,
            'downloads' => $downloads,
        ];
    }

    /**
     * Usage totals for a single submission (cached per request).
     *
     * @return array{views: int, downloads: int}
     */
    private function getSubmissionStats(int $submissionId): array
    {
        if (self::$submissionStats === null) {
            self::$submissionStats = [];

            try {
                $rows = DB::table('metrics_counter_submission_monthly')
                    ->selectRaw('submission_id, COALESCE(SUM(metric_investigations), 0) as views, COALESCE(SUM(metric_requests), 0) as downloads')
                    ->groupBy('submission_id')
                    ->get();
                foreach ($rows as $row) {
                    self::$submissionStats[(int) $row->submission_id] = [
                        'views' => (int) $row->views,
                        'downloads' => (int) $row->downloads,
                    ];
                }
            } catch (Throwable $e) {
                // Statistics unavailable.
            }
        }

        return self::$submissionStats[$submissionId] ?? ['views' => 0, 'downloads' => 0];
    }
}
