{**
 * plugins/themes/academic/templates/frontend/pages/indexJournal.tpl
 *
 * Journal homepage: hero (about + cover), statistics cards, current issue TOC
 * and any additional homepage content. The usage chart is rendered by the
 * theme footer.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<div class="page_index_journal" data-acad-template="1">

	{call_hook name="Templates::Index::journal"}

	{if $highlights && $highlights->count()}
		{include file="frontend/components/highlights.tpl" highlights=$highlights}
	{/if}

	{* ============ Hero: about + journal cover ============ *}
	{if !$activeTheme || $activeTheme->getOption('showAboutCover')}
		{assign var="acadDescription" value=$currentContext->getLocalizedData('description')}
		{assign var="acadThumbnail" value=$currentContext->getLocalizedData('journalThumbnail')}
		{if $acadDescription || $acadThumbnail}
			<section class="acad-about-cover-section mb-4">
				<div class="row g-4">
					{if $acadDescription}
						<div class="{if $acadThumbnail}col-lg-8 col-md-7{else}col-12{/if} col-12">
							<div class="acad-hero-card h-100 mb-0">
								<div class="acad-section-heading">
									<h2><i class="bi bi-info-circle text-primary"></i> {translate key="plugins.themes.academic.aboutJournal"}</h2>
								</div>
								<div class="lead-text text-secondary acad-hero-text">
									{$acadDescription}
								</div>
							</div>
						</div>
					{/if}

					{if $acadThumbnail}
						<div class="{if $acadDescription}col-lg-4 col-md-5{else}col-12{/if} col-12">
							<div class="acad-hero-card h-100 mb-0 text-center d-flex flex-column">
								<div class="acad-section-heading justify-content-center">
									<h2><i class="bi bi-journal-album text-primary"></i> {translate key="plugins.themes.academic.journalCover"}</h2>
								</div>
								<div class="journal-cover-body my-auto py-2">
									<img src="{$publicFilesDir}/{$acadThumbnail.uploadName|escape:"url"}"
										alt="{translate|escape key="plugins.themes.academic.journalCover"}"
										class="img-fluid rounded shadow journal-cover-img" />
								</div>
								<div class="mt-2">
									<span class="badge bg-primary text-wrap">
										<i class="bi bi-journal-bookmark me-1"></i>{$currentContext->getLocalizedName()|escape}
									</span>
								</div>
							</div>
						</div>
					{/if}
				</div>
			</section>
		{/if}
	{/if}

	{* ============ Statistics cards ============ *}
	{if $acadStats && (!$activeTheme || $activeTheme->getOption('showStats'))}
		<section class="journal-stats-section my-4" aria-label="{translate|escape key="plugins.themes.academic.publishedArticles"}">
			<div class="journal-stats-grid">

				<div class="stat-card stat-card-blue">
					<div class="stat-icon-wrapper stat-icon-blue">
						<svg class="stat-icon-svg" viewBox="0 0 24 24" aria-hidden="true">
							<path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
						</svg>
					</div>
					<div class="stat-content">
						<div class="stat-number">{acad_number value=$acadStats.articles}</div>
						<div class="stat-label" title="{translate|escape key="plugins.themes.academic.publishedArticles"}">
							{translate key="plugins.themes.academic.publishedArticles"}
						</div>
						<div class="stat-sublabel">{translate key="plugins.themes.academic.publishedArticles"}</div>
					</div>
				</div>

				<div class="stat-card stat-card-green">
					<div class="stat-icon-wrapper stat-icon-green">
						<svg class="stat-icon-svg" viewBox="0 0 24 24" aria-hidden="true">
							<path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/>
						</svg>
					</div>
					<div class="stat-content">
						<div class="stat-number">{acad_number value=$acadStats.authors}</div>
						<div class="stat-label" title="{translate|escape key="plugins.themes.academic.contributorAuthors"}">
							{translate key="plugins.themes.academic.contributorAuthors"}
						</div>
						<div class="stat-sublabel">{translate key="plugins.themes.academic.contributorAuthors"}</div>
					</div>
				</div>

				<div class="stat-card stat-card-amber">
					<div class="stat-icon-wrapper stat-icon-amber">
						<svg class="stat-icon-svg" viewBox="0 0 24 24" aria-hidden="true">
							<path d="M4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm16-4H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-1 9H9V9h10v2zm-4 4H9v-2h6v2zm4-8H9V5h10v2z"/>
						</svg>
					</div>
					<div class="stat-content">
						<div class="stat-number">{acad_number value=$acadStats.issues}</div>
						<div class="stat-label" title="{translate|escape key="plugins.themes.academic.publishedIssues"}">
							{translate key="plugins.themes.academic.publishedIssues"}
						</div>
						<div class="stat-sublabel">{translate key="plugins.themes.academic.publishedIssuesSub"}</div>
					</div>
				</div>

				<div class="stat-card stat-card-teal">
					<div class="stat-icon-wrapper stat-icon-teal">
						<svg class="stat-icon-svg" viewBox="0 0 24 24" aria-hidden="true">
							<path d="M19.35 10.04C18.67 6.59 15.64 4 12 4 9.11 4 6.6 5.64 5.35 8.04 2.34 8.36 0 10.91 0 14c0 3.31 2.69 6 6 6h13c2.76 0 5-2.24 5-5 0-2.64-2.05-4.78-4.65-4.96zM17 13l-5 5-5-5h3V9h4v4h3z"/>
						</svg>
					</div>
					<div class="stat-content">
						<div class="stat-number">{acad_number value=$acadStats.downloads}</div>
						<div class="stat-label" title="{translate|escape key="plugins.themes.academic.totalDownloads"}">
							{translate key="plugins.themes.academic.totalDownloads"}
						</div>
						<div class="stat-sublabel">{translate key="plugins.themes.academic.totalDownloadsSub"}</div>
					</div>
				</div>

			</div>
		</section>
	{/if}

	{* ============ Current issue ============ *}
	{if $issue}
		<section class="acad-current-issue mb-5">
			<div class="acad-section-heading">
				<h2><i class="bi bi-journal-check text-primary"></i> {translate key="plugins.themes.academic.currentIssue"}</h2>
				<a href="{url page="issue" op="archive"}" class="btn btn-sm btn-outline-primary">
					{translate key="plugins.themes.academic.viewAllIssues"} &raquo;
				</a>
			</div>
			{include file="frontend/objects/issue_toc.tpl" heading="h2"}
		</section>
	{/if}

	{* ============ Additional homepage content ============ *}
	{if $additionalHomeContent}
		<section class="acad-additional-content card shadow-sm mb-5">
			<div class="acad-additional-content-body card-body">
				{$additionalHomeContent}
			</div>
		</section>
	{/if}
</div><!-- .page_index_journal -->

{include file="frontend/components/footer.tpl"}
