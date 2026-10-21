{**
 * plugins/themes/academic/templates/frontend/components/footer.tpl
 *
 * Sidebar, optional usage chart, custom footer and back-to-top button.
 *}
				</main><!-- .pkp_structure_main -->

				{if empty($isFullWidth)}
					{capture assign="sidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
					<aside id="sidebar" class="pkp_structure_sidebar sidebar-container col-12 col-lg-3 order-lg-2" role="complementary" aria-label="{translate|escape key="common.navigation.site"}">
						{include file="frontend/components/academicSidebar.tpl"}
						{if $sidebarCode}
							{$sidebarCode}
						{/if}
					</aside>
				{/if}
			</div><!-- .row -->
		</div><!-- .pkp_structure_content -->

		{* ============ Usage chart ============ *}
		{if $acadChart && $acadStats && (!$activeTheme || $activeTheme->getOption('showChart'))}
			<div class="acad-chart-section-wrapper container mb-4">
				<section class="acad-chart-section mb-0" aria-label="{translate|escape key="plugins.themes.academic.chartTitle"}">
					<div class="acad-chart-card" id="acadJournalChartContainer"
						data-labels='{$acadChart.labels|json_encode|escape:"htmlall"}'
						data-views='{$acadChart.views|json_encode|escape:"htmlall"}'
						data-downloads='{$acadChart.downloads|json_encode|escape:"htmlall"}'>

						<div class="acad-chart-header d-flex flex-wrap justify-content-between align-items-center gap-3">
							<div>
								<h3 class="h5 fw-bold mb-1 d-flex align-items-center text-primary">
									<i class="bi bi-bar-chart-fill me-2 text-primary"></i>
									{translate key="plugins.themes.academic.chartTitle"}
								</h3>
								<p class="text-muted small mb-0">
									{translate key="plugins.themes.academic.chartDescription"}
								</p>
							</div>
							<div class="d-flex flex-wrap align-items-center gap-2">
								<div class="d-flex flex-wrap gap-2">
									<span class="acad-chart-badge acad-chart-badge-views">
										<i class="bi bi-eye-fill"></i> {translate key="plugins.themes.academic.totalViews12"}: <strong class="ms-1">{acad_number value=$acadChart.views|@array_sum}</strong>
									</span>
									<span class="acad-chart-badge acad-chart-badge-downloads">
										<i class="bi bi-download"></i> {translate key="plugins.themes.academic.totalDownloads12"}: <strong class="ms-1">{acad_number value=$acadChart.downloads|@array_sum}</strong>
									</span>
								</div>
								<div class="btn-group btn-group-sm" role="group" aria-label="{translate|escape key="plugins.themes.academic.chartTitle"}">
									<button type="button" class="chart-filter-btn active" id="btnFilterBoth" onclick="filterJournalChart('both')">
										{translate key="plugins.themes.academic.filterAll"}
									</button>
									<button type="button" class="chart-filter-btn" id="btnFilterViews" onclick="filterJournalChart('views')">
										{translate key="plugins.themes.academic.filterViews"}
									</button>
									<button type="button" class="chart-filter-btn" id="btnFilterDownloads" onclick="filterJournalChart('downloads')">
										{translate key="plugins.themes.academic.filterDownloads"}
									</button>
								</div>
							</div>
						</div>

						<div class="acad-chart-body">
							{if $acadChartHasData}
								<div style="position: relative; height: 320px; width: 100%;">
									<canvas id="journal12mBarChart"></canvas>
								</div>
							{else}
								<div class="acad-chart-empty text-center text-muted py-5">
									<i class="bi bi-bar-chart fs-1 d-block mb-2 text-secondary"></i>
									{translate key="plugins.themes.academic.chartEmpty"}
								</div>
							{/if}
						</div>
					</div>
				</section>
			</div>
		{/if}

		{* ============ Footer ============ *}
		<footer class="acad-footer" role="contentinfo">
			<a id="pkp_content_footer"></a>

			<div class="acad-footer-main py-5">
				<div class="container">
					<div class="row g-4">
						<div class="col-lg-5 col-md-6 col-12">
							<h4 class="fw-bold mb-3">{$displayPageHeaderTitle|escape}</h4>

							{if $currentContext && $currentContext->getLocalizedData('description')}
								<div class="text-muted small mb-3">
									{$currentContext->getLocalizedData('description')|strip_tags|truncate:220:"..."}
								</div>
							{/if}

							<div class="journal-meta-footer small d-flex flex-column gap-1">
								{if $currentContext}
									{assign var="onlineIssn" value=$currentContext->getData('onlineIssn')}
									{assign var="printIssn" value=$currentContext->getData('printIssn')}
									{if $onlineIssn}
										<div><span class="badge bg-primary me-1">e-ISSN</span> <span class="fw-semibold">{$onlineIssn|escape}</span></div>
									{/if}
									{if $printIssn}
										<div><span class="badge bg-secondary me-1">p-ISSN</span> <span class="fw-semibold">{$printIssn|escape}</span></div>
									{/if}
									{assign var="publisherInstitution" value=$currentContext->getData('publisherInstitution')}
									{if $publisherInstitution}
										<div class="mt-1 text-secondary">
											<i class="bi bi-building me-1"></i><strong>{translate key="plugins.themes.academic.publisher"}:</strong> {$publisherInstitution|escape}
										</div>
									{/if}
								{/if}
							</div>
						</div>

						<div class="col-lg-4 col-md-6 col-12">
							<h5 class="fw-bold mb-3">{translate key="plugins.themes.academic.siteNavigation"}</h5>
							<ul class="list-unstyled small d-flex flex-column gap-2">
								<li><a href="{$homeUrl}"><i class="bi bi-chevron-right me-1 text-primary"></i>{translate key="navigation.home"}</a></li>
								<li><a href="{url page="issue" op="current"}"><i class="bi bi-chevron-right me-1 text-primary"></i>{translate key="journal.currentIssue"}</a></li>
								<li><a href="{url page="issue" op="archive"}"><i class="bi bi-chevron-right me-1 text-primary"></i>{translate key="navigation.archives"}</a></li>
								<li><a href="{url page="about" op="submissions"}"><i class="bi bi-chevron-right me-1 text-primary"></i>{translate key="about.submissions"}</a></li>
								<li><a href="{url page="about" op="editorialMasthead"}"><i class="bi bi-chevron-right me-1 text-primary"></i>{translate key="common.editorialMasthead"}</a></li>
								<li><a href="{url page="about" op="contact"}"><i class="bi bi-chevron-right me-1 text-primary"></i>{translate key="about.contact"}</a></li>
							</ul>
						</div>

						<div class="col-lg-3 col-md-12 col-12">
							<h5 class="fw-bold mb-3">{translate key="about.aboutThisPublishingSystem"}</h5>
							<p class="small text-muted mb-3">
								{translate key="plugins.themes.academic.aboutPublishingSystem"}
							</p>
							<div class="pkp-brand">
								<a href="{url page="about" op="aboutThisPublishingSystem"}" class="d-inline-block">
									<img src="{$baseUrl}/{$brandImage}" alt="{translate|escape key="about.aboutThisPublishingSystem"}" class="img-fluid" style="max-height: 48px;">
								</a>
							</div>
						</div>
					</div>

					{if $pageFooter}
						<div class="acad-custom-footer border-top pt-3 mt-4 text-center small text-secondary">
							{$pageFooter}
						</div>
					{/if}
				</div>
			</div>

			<div class="acad-footer-bottom py-3">
				<div class="container d-flex justify-content-between align-items-center flex-wrap gap-2 text-center text-md-start small">
					<div>
						&copy; {$displayPageHeaderTitle|escape} {if $acadCurrentYear}{$acadCurrentYear}{else}{$smarty.now|date_format:"%Y"}{/if}. {translate key="plugins.themes.academic.copyright"}
					</div>
					<div>
						{translate key="plugins.themes.academic.credit"}
						{if $activeTheme && $activeTheme->getOption('footerCredit')}
							&bull; {$activeTheme->getOption('footerCredit')|escape}
						{/if}
					</div>
				</div>
			</div>
		</footer>

		<button id="acadBackToTop" class="acad-back-to-top" title="{translate|escape key="plugins.themes.academic.backToTop"}" aria-label="{translate|escape key="plugins.themes.academic.backToTop"}">
			<i class="bi bi-arrow-up"></i>
		</button>

	</div><!-- .pkp_structure_page -->

	{load_script context="frontend"}

	{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>
