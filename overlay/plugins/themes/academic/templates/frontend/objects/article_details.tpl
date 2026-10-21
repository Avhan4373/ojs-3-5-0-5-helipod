{**
 * plugins/themes/academic/templates/frontend/objects/article_details.tpl
 *
 * Article landing page for the Academic theme.
 *
 * The markup follows the article page of the original Academic Theme
 * (Gudang Jurnal) while using the data OJS 3.5 provides:
 *  - header badges, author cards with affiliation and country
 *  - abstract, keywords, download chart and references
 *  - sidebar cards: downloads, issue cover, how to cite, metrics,
 *    issue/section, license and social sharing
 *}
{if !$heading}
	{assign var="heading" value="h3"}
{/if}

{acad_article_stats article=$article assign="acadArticleStats"}
{acad_submission_chart article=$article assign="acadArticleChart"}
{capture assign="acadArticleUrl"}{url page="article" op="view" path=$article->getBestId()}{/capture}
{assign var="acadShareTitle" value=$publication->getLocalizedTitle(null, 'text')}

<article class="obj_article_details">

	{* Preview / outdated version notices *}
	{if $publication->getData('status') !== PKP\submission\PKPSubmission::STATUS_PUBLISHED}
		<div class="cmp_notification notice">
			{capture assign="submissionUrl"}{url page="dashboard" op="editorial" workflowSubmissionId=$article->getId()}{/capture}
			{translate key="submission.viewingPreview" url=$submissionUrl}
		</div>
	{elseif $currentPublication->getId() !== $publication->getId()}
		<div class="cmp_notification notice">
			{capture assign="latestVersionUrl"}{url page="article" op="view" path=$article->getBestId()}{/capture}
			{translate key="submission.outdatedVersion"
				datePublished=$publication->getData('datePublished')|date_format:$dateFormatShort
				urlRecentVersion=$latestVersionUrl|escape
			}
		</div>
	{/if}

	<header class="article-header">
		<div class="article-header-badges d-flex flex-wrap gap-2 align-items-center mb-3">
			{if $section && !$section->getHideTitle()}
				<span class="badge badge-section">
					{$section->getLocalizedTitle()|escape}
				</span>
			{/if}
			{if $issue}
				<a class="badge badge-issue" href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
					{$issue->getIssueIdentification()|escape}
				</a>
			{/if}
			<span class="badge bg-success">
				{translate key="reader.openAccess"}
			</span>
		</div>

		<h1 class="page_title">
			{$publication->getLocalizedTitle(null, 'html')|strip_unsafe_html}
		</h1>

		{if $publication->getLocalizedData('subtitle')}
			<h2 class="subtitle">
				{$publication->getLocalizedSubTitle(null, 'html')|strip_unsafe_html}
			</h2>
		{/if}

		{if $publication->getData('authors')}
			<div class="article-authors-list d-flex flex-column gap-2 my-3">
				{foreach from=$publication->getData('authors') item=author}
					{assign var=authorUserGroup value=$userGroupsById[$author->getData('userGroupId')]}
					{acad_author_country authorId=$author->getId() assign="acadAuthorCountry"}
					<div class="article-author-item">
						<div class="d-flex align-items-center gap-2 flex-wrap">
							<span class="author-name fw-bold">
								<i class="bi bi-person-fill text-primary me-1"></i>
								{$author->getFullName()|escape}
							</span>
							{if $authorUserGroup && $authorUserGroup->showTitle}
								<span class="badge bg-light text-dark border">
									{$authorUserGroup->getLocalizedData('name')|escape}
								</span>
							{/if}
							{if $author->getData('orcid')}
								<span class="author-orcid">
									{if $author->hasVerifiedOrcid()}
										{$orcidIcon}
									{else}
										{$orcidUnauthenticatedIcon}
									{/if}
									<a href="{$author->getData('orcid')|escape}" target="_blank" rel="noopener">
										{$author->getOrcidDisplayValue()|escape}
									</a>
								</span>
							{/if}
						</div>

						{if count($author->getAffiliations()) > 0}
							<div class="author-affiliation small mt-1">
								<i class="bi bi-building me-1 text-muted"></i>
								{assign var="renderedAffiliation" value=false}
								{foreach from=$author->getAffiliations() item="affiliation"}
									{if $affiliation->getLocalizedName() || $affiliation->getRor()}
										{if $renderedAffiliation}{translate key="common.commaListSeparator"}{/if}
										{if $affiliation->getLocalizedName()}
											{$affiliation->getLocalizedName()|escape}
										{/if}
										{if $affiliation->getRor()}
											<a href="{$affiliation->getRor()|escape}" target="_blank" rel="noopener" class="ms-1">{$rorIdIcon}</a>
										{/if}
										{assign var="renderedAffiliation" value=true}
									{/if}
								{/foreach}
							</div>
						{/if}

						{if $acadAuthorCountry}
							<div class="author-country small mt-1">
								<i class="bi bi-geo-alt me-1 text-danger"></i>
								{$acadAuthorCountry|escape}
							</div>
						{/if}
					</div>
				{/foreach}
			</div>
		{/if}

		<div class="article-meta d-flex flex-wrap align-items-center gap-3 small text-muted">
			{if $publication->getData('datePublished')}
				<span class="article-meta-item">
					<i class="bi bi-calendar3 me-1"></i>
					{translate key="plugins.themes.academic.publishedOn"}:
					{$publication->getData('datePublished')|date_format:$dateFormatShort}
				</span>
			{/if}

			{assign var=doiObject value=$publication->getData('doiObject')}
			{if $doiObject}
				<span class="article-meta-item">
					<i class="bi bi-link-45deg me-1"></i>
					DOI:
					<a href="{$doiObject->getResolvingUrl()|escape}" target="_blank" rel="noopener">
						{$doiObject->getDoi()|escape}
					</a>
				</span>
			{/if}

			<span class="article-meta-item">
				<i class="bi bi-eye me-1"></i>
				<strong>{acad_number value=$acadArticleStats.views}</strong>
				{translate key="plugins.themes.academic.views"}
			</span>
			<span class="article-meta-item">
				<i class="bi bi-download me-1"></i>
				<strong>{acad_number value=$acadArticleStats.downloads}</strong>
				{translate key="plugins.themes.academic.downloads"}
			</span>
		</div>
	</header>

	<div class="row">
		<div class="main_entry article-main-column">

			{* Abstract *}
			{if $publication->getLocalizedData('abstract')}
				<section class="article-card-section">
					<h3>
						<i class="bi bi-file-text"></i>
						{translate key="article.abstract"}
					</h3>
					<div class="article-abstract">
						{$publication->getLocalizedData('abstract')|strip_unsafe_html}
					</div>
				</section>
			{/if}

			{* Keywords *}
			{if !empty($publication->getLocalizedData('keywords'))}
				<section class="article-card-section">
					<h3>
						<i class="bi bi-tags"></i>
						{translate key="article.subject"}
					</h3>
					<div class="article-keywords-pills">
						{foreach from=$publication->getLocalizedData('keywords') item="keyword"}
							<span class="article-keyword-pill">{$keyword.name|escape}</span>
						{/foreach}
					</div>
				</section>
			{/if}

			{call_hook name="Templates::Article::Main"}

			{* Usage statistics chart *}
			<section class="article-card-section article-downloads-chart">
				<h3>
					<i class="bi bi-graph-up"></i>
					{translate key="plugins.themes.default.displayStats.downloads"}
				</h3>
				{if $acadArticleChart.hasData}
					<div class="downloads-chart-inner">
						<canvas id="acadArticleDownloadsChart" data-chart="{$acadArticleChart.json|escape}"></canvas>
					</div>
				{else}
					<p class="text-muted small mb-0">
						{translate key="plugins.themes.default.displayStats.noStats"}
					</p>
				{/if}
			</section>

			{* References *}
			{if count($parsedCitations) || (string) $publication->getData('citationsRaw')}
				<section class="article-card-section">
					<h3>
						<i class="bi bi-book"></i>
						{translate key="submission.citations"}
					</h3>
					<div class="value references-list">
						{if count($parsedCitations)}
							<ol class="references-list">
								{foreach from=$parsedCitations item="parsedCitation"}
									<li>
										{$parsedCitation->getCitationWithLinks()|strip_unsafe_html}
										{call_hook name="Templates::Article::Details::Reference" citation=$parsedCitation}
									</li>
								{/foreach}
							</ol>
						{else}
							{$publication->getData('citationsRaw')|escape|nl2br}
						{/if}
					</div>
				</section>
			{/if}

			{* Author biographies *}
			{assign var="hasBiographies" value=0}
			{foreach from=$publication->getData('authors') item=author}
				{if $author->getLocalizedData('biography')}
					{assign var="hasBiographies" value=$hasBiographies+1}
				{/if}
			{/foreach}
			{if $hasBiographies}
				<section class="article-card-section">
					<h3>
						<i class="bi bi-person-lines-fill"></i>
						{if $hasBiographies > 1}
							{translate key="submission.authorBiographies"}
						{else}
							{translate key="submission.authorBiography"}
						{/if}
					</h3>
					<ul class="author-bios list-unstyled mb-0">
						{foreach from=$publication->getData('authors') item=author}
							{if $author->getLocalizedData('biography')}
								<li class="mb-3">
									<div class="fw-bold text-primary">
										{if $author->getLocalizedAffiliationNamesAsString()}
											{capture assign="authorName"}{$author->getFullName()|escape}{/capture}
											{capture assign="authorAffiliations"} {$author->getLocalizedAffiliationNamesAsString(null, ', ')|escape} {/capture}
											{translate key="submission.authorWithAffiliation" name=$authorName affiliation=$authorAffiliations}
										{else}
											{$author->getFullName()|escape}
										{/if}
									</div>
									<div class="small text-muted">
										{$author->getLocalizedData('biography')|strip_unsafe_html}
									</div>
								</li>
							{/if}
						{/foreach}
					</ul>
				</section>
			{/if}

		</div><!-- .main_entry -->

		<div class="entry_details article-side-column">

			{* Downloads *}
			{if $primaryGalleys || $supplementaryGalleys}
				<div class="card mb-4 border shadow-sm">
					<div class="card-header py-2 px-3 fw-bold">
						<i class="bi bi-download me-1"></i>
						{translate key="submission.downloads"}
					</div>
					<div class="card-body p-3">
						<div class="d-grid gap-2">
							{foreach from=$primaryGalleys item=galley}
								{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley purchaseFee=$currentJournal->getData('purchaseArticleFee') purchaseCurrency=$currentJournal->getData('currency')}
							{/foreach}
							{if $supplementaryGalleys}
								{foreach from=$supplementaryGalleys item=galley}
									{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley isSupplementary="1" purchaseFee=$currentJournal->getData('purchaseArticleFee') purchaseCurrency=$currentJournal->getData('currency')}
								{/foreach}
							{/if}
						</div>
					</div>
				</div>
			{/if}

			{* Issue cover *}
			{if $issue}
				{if $issue->getLocalizedCoverImage()}
					<div class="card mb-4 border shadow-sm">
						<div class="card-body p-2 text-center">
							<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
								<img class="img-fluid rounded" src="{$issue->getLocalizedCoverImageUrl()|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}">
							</a>
						</div>
					</div>
				{else}
					<div class="card mb-4 border shadow-sm article-cover-placeholder">
						<div class="card-body p-3 text-center">
							<div class="article-cover-placeholder-inner">
								<div class="small text-uppercase fw-semibold mb-1">
									{$currentContext->getLocalizedName()|escape}
								</div>
								<div class="display-6 fw-bold lh-1">
									{$issue->getData('volume')|escape}
								</div>
								<div class="small mt-2">
									Vol. {$issue->getData('volume')|escape} No. {$issue->getData('number')|escape} ({$issue->getData('year')|escape})
								</div>
							</div>
						</div>
					</div>
				{/if}
			{/if}

			{* How to Cite *}
			{if $citation}
				<div class="card mb-4 border shadow-sm citation-card">
					<div class="card-header py-2 px-3 fw-bold d-flex justify-content-between align-items-center gap-2">
						<span>
							<i class="bi bi-bookmark-check me-1"></i>
							{translate key="submission.howToCite"}
						</span>
						<button type="button" id="copyCitationBtn" class="btn btn-sm btn-outline-primary">
							<i class="bi bi-clipboard me-1"></i>
							{translate key="plugins.themes.academic.copyCitation"}
						</button>
					</div>
					<div class="card-body p-3 citation_display">
						<div id="citationOutput" class="citation-output" role="region" aria-live="polite">
							{$citation}
						</div>

						<div class="citation_formats">
							<button type="button" class="citation_formats_button label" aria-controls="cslCitationFormats" aria-expanded="false" data-csl-dropdown="true">
								<span>{translate key="submission.howToCite.citationFormats"}</span>
								<i class="bi bi-chevron-down ms-1"></i>
							</button>
							<div id="cslCitationFormats" class="citation_formats_list" aria-hidden="true">
								<ul class="citation_formats_styles">
									{foreach from=$citationStyles item="citationStyle"}
										<li>
											<a rel="nofollow" aria-controls="citationOutput"
												href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgs}"
												data-load-citation
												data-json-href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgsJson}">
												{$citationStyle.title|escape}
											</a>
										</li>
									{/foreach}
								</ul>

								{if count($citationDownloads)}
									<div class="label">
										{translate key="submission.howToCite.downloadCitation"}
									</div>
									<ul class="citation_formats_styles">
										{foreach from=$citationDownloads item="citationDownload"}
											<li>
												<a href="{url page="citationstylelanguage" op="download" path=$citationDownload.id params=$citationArgs}">
													<i class="bi bi-download me-1"></i>
													{$citationDownload.title|escape}
												</a>
											</li>
										{/foreach}
									</ul>
								{/if}
							</div>
						</div>
					</div>
				</div>
			{/if}

			{* Metrics *}
			<div class="card mb-4 border shadow-sm acad-metrics-card">
				<div class="card-header py-2 px-3 fw-bold">
					<i class="bi bi-bar-chart-line me-1"></i>
					{translate key="plugins.themes.academic.articleStatistics"}
				</div>
				<div class="card-body p-3">
					<div class="row g-2 text-center">
						<div class="col-6">
							<div class="stat-box-primary p-2 h-100">
								<div class="stat-number fs-4">{acad_number value=$acadArticleStats.views}</div>
								<div class="small text-muted">{translate key="plugins.themes.academic.abstractViews"}</div>
							</div>
						</div>
						<div class="col-6">
							<div class="stat-box-primary p-2 h-100">
								<div class="stat-number fs-4">{acad_number value=$acadArticleStats.downloads}</div>
								<div class="small text-muted">{translate key="plugins.themes.academic.pdfDownloads"}</div>
							</div>
						</div>
					</div>

					{assign var=doiObject value=$publication->getData('doiObject')}
					{if $doiObject}
						<div class="dimensions-badge-box mt-3">
							<a class="btn btn-sm btn-outline-primary w-100"
								href="https://badge.dimensions.ai/details/doi/{$doiObject->getDoi()|escape:'url'}"
								target="_blank" rel="noopener">
								<i class="bi bi-bar-chart me-1"></i>
								{translate key="plugins.themes.academic.dimensionsCitations"}
							</a>
						</div>
					{/if}
				</div>
			</div>

			{* Issue and section *}
			{if $issue || $section}
				<div class="card mb-4 border shadow-sm">
					<div class="card-header py-2 px-3 fw-bold">
						<i class="bi bi-journal-bookmark me-1"></i>
						{translate key="issue.issue"}
					</div>
					<div class="card-body p-3 small">
						{if $issue}
							<div class="mb-2">
								<span class="text-muted">{translate key="issue.issue"}:</span>
								<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}" class="fw-semibold">
									{$issue->getIssueIdentification()|escape}
								</a>
							</div>
						{/if}
						{if $section}
							<div>
								<span class="text-muted">{translate key="section.section"}:</span>
								{$section->getLocalizedTitle()|escape}
							</div>
						{/if}
					</div>
				</div>
			{/if}

			{* License *}
			{if $currentContext->getLocalizedData('licenseTerms') || $publication->getData('licenseUrl')}
				<div class="card mb-4 border shadow-sm">
					<div class="card-header py-2 px-3 fw-bold">
						<i class="bi bi-shield-check me-1"></i>
						{translate key="submission.license"}
					</div>
					<div class="card-body p-3 small">
						{if $publication->getData('licenseUrl')}
							{if $publication->getLocalizedData('copyrightHolder')}
								<p class="mb-2">
									{translate key="submission.copyrightStatement" copyrightHolder=$publication->getLocalizedData('copyrightHolder') copyrightYear=$publication->getData('copyrightYear')}
								</p>
							{/if}
							{if $ccLicenseBadge}
								{$ccLicenseBadge}
							{else}
								<a href="{$publication->getData('licenseUrl')|escape}" class="copyright" target="_blank" rel="noopener">
									{translate key="submission.license"}
								</a>
							{/if}
						{/if}
						{if $currentContext->getLocalizedData('licenseTerms')}
							<div class="text-muted mt-2">
								{$currentContext->getLocalizedData('licenseTerms')}
							</div>
						{/if}
					</div>
				</div>
			{/if}

			{* Share *}
			<div class="card mb-4 border shadow-sm">
				<div class="card-header py-2 px-3 fw-bold">
					<i class="bi bi-share me-1"></i>
					{translate key="plugins.themes.academic.shareArticle"}
				</div>
				<div class="card-body p-3">
					<div class="acad-share-buttons">
						<a class="acad-share-btn acad-share-facebook" href="https://www.facebook.com/sharer/sharer.php?u={$acadArticleUrl|escape:'url'}" target="_blank" rel="noopener noreferrer" aria-label="Facebook" title="Facebook">
							<i class="bi bi-facebook"></i>
						</a>
						<a class="acad-share-btn acad-share-x" href="https://twitter.com/intent/tweet?url={$acadArticleUrl|escape:'url'}&amp;text={$acadShareTitle|escape:'url'}" target="_blank" rel="noopener noreferrer" aria-label="X / Twitter" title="X / Twitter">
							<i class="bi bi-twitter-x"></i>
						</a>
						<a class="acad-share-btn acad-share-linkedin" href="https://www.linkedin.com/shareArticle?mini=true&amp;url={$acadArticleUrl|escape:'url'}&amp;title={$acadShareTitle|escape:'url'}" target="_blank" rel="noopener noreferrer" aria-label="LinkedIn" title="LinkedIn">
							<i class="bi bi-linkedin"></i>
						</a>
						<a class="acad-share-btn acad-share-whatsapp" href="https://wa.me/?text={$acadShareTitle|escape:'url'}%20{$acadArticleUrl|escape:'url'}" target="_blank" rel="noopener noreferrer" aria-label="WhatsApp" title="WhatsApp">
							<i class="bi bi-whatsapp"></i>
						</a>
						<a class="acad-share-btn acad-share-telegram" href="https://t.me/share/url?url={$acadArticleUrl|escape:'url'}&amp;text={$acadShareTitle|escape:'url'}" target="_blank" rel="noopener noreferrer" aria-label="Telegram" title="Telegram">
							<i class="bi bi-telegram"></i>
						</a>
						<a class="acad-share-btn acad-share-reddit" href="https://www.reddit.com/submit?url={$acadArticleUrl|escape:'url'}&amp;title={$acadShareTitle|escape:'url'}" target="_blank" rel="noopener noreferrer" aria-label="Reddit" title="Reddit">
							<i class="bi bi-reddit"></i>
						</a>
						<a class="acad-share-btn acad-share-pinterest" href="https://pinterest.com/pin/create/button/?url={$acadArticleUrl|escape:'url'}&amp;description={$acadShareTitle|escape:'url'}" target="_blank" rel="noopener noreferrer" aria-label="Pinterest" title="Pinterest">
							<i class="bi bi-pinterest"></i>
						</a>
						<a class="acad-share-btn acad-share-email" href="mailto:?subject={$acadShareTitle|escape:'url'}&amp;body={$acadArticleUrl|escape:'url'}" aria-label="Email" title="Email">
							<i class="bi bi-envelope-fill"></i>
						</a>
					</div>
				</div>
			</div>

		</div><!-- .entry_details -->
	</div><!-- .row -->

</article>
