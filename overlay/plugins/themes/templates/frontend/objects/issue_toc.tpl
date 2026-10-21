{**
 * plugins/themes/academic/templates/frontend/objects/issue_toc.tpl
 *
 * Current issue banner + table of contents rendered as cards.
 *}
{if !$heading}
	{assign var="heading" value="h2"}
{/if}
{assign var="articleHeading" value="h4"}

<div class="obj_issue_toc">

	{if !$issue->getPublished()}
		{include file="frontend/components/notification.tpl" type="warning" messageKey="editor.issues.preview"}
	{/if}

	{assign var="issueCover" value=$issue->getLocalizedCoverImageUrl()}
	{assign var="issueUrl" value=$issue->getBestIssueId()}

	{* ============ Issue banner ============ *}
	<div class="current-issue-banner card mb-4 border shadow-sm">
		<div class="card-body p-4">
			<div class="row align-items-center g-4">

				{if $issueCover}
					<div class="col-md-3 col-12 text-center">
						<a href="{url page="issue" op="view" path=$issueUrl}">
							<img src="{$issueCover|escape}"
								alt="{translate key="issue.viewIssueIdentification" identification=$issue->getIssueIdentification()|escape}"
								class="current-issue-cover img-fluid rounded shadow" />
						</a>
					</div>
				{/if}

				<div class="{if $issueCover}col-md-9{else}col-12{/if} col-12">
					<h3 class="h4 fw-bold text-primary mb-2">
						<a href="{url page="issue" op="view" path=$issueUrl}">{$issue->getIssueIdentification()|escape}</a>
					</h3>

					<div class="current-issue-meta small text-muted mb-3 d-flex flex-wrap gap-3">
						{if $issue->getDatePublished()}
							<span><i class="bi bi-calendar3 me-1 text-primary"></i><strong>{translate key="plugins.themes.academic.publishedOn"}:</strong> {$issue->getDatePublished()|date_format:$dateFormatShort}</span>
						{/if}

						{foreach from=$pubIdPlugins item=pubIdPlugin}
							{assign var=pubId value=$issue->getStoredPubId($pubIdPlugin->getPubIdType())}
							{if $pubId}
								{assign var="resolvingUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)}
								<span>
									{$pubIdPlugin->getPubIdDisplayType()|escape}:
									{if $resolvingUrl}<a href="{$resolvingUrl|escape}">{$resolvingUrl|escape}</a>{else}{$pubId|escape}{/if}
								</span>
							{/if}
						{/foreach}

						{assign var=issueDoiObject value=$issue->getData('doiObject')}
						{if $issueDoiObject}
							<span><i class="bi bi-link-45deg me-1 text-primary"></i>DOI: <a href="{$issueDoiObject->getResolvingUrl()|escape}" target="_blank" rel="noopener">{$issueDoiObject->getDoi()|escape}</a></span>
						{/if}
					</div>

					{if $issue->hasDescription()}
						<div class="issue-description text-muted small mb-3">
							{$issue->getLocalizedDescription()|strip_unsafe_html}
						</div>
					{/if}

					{if $issueGalleys}
						<ul class="galleys_links issue-galleys">
							{foreach from=$issueGalleys item=galley}
								<li>
									{include file="frontend/objects/galley_link.tpl" parent=$issue labelledBy="issueTocGalleyLabel" purchaseFee=$currentJournal->getData('purchaseIssueFee') purchaseCurrency=$currentJournal->getData('currency')}
								</li>
							{/foreach}
						</ul>
					{/if}
				</div>
			</div>
		</div>
	</div>

	{* ============ Sections ============ *}
	<div class="issue-sections mt-4">
		{foreach name=sections from=$publishedSubmissions item=section}
			{if $section.articles}
				<div class="issue-section-group mb-4">
					{if $section.title}
						<div class="issue-section-title">
							<h3 class="h5 mb-0 text-primary fw-bold">
								<i class="bi bi-folder2-open me-2"></i>{$section.title|escape}
							</h3>
						</div>
					{/if}

					<div class="issue-section-articles">
						{foreach from=$section.articles item=article}
							{include file="frontend/objects/article_summary.tpl" heading=$articleHeading}
						{/foreach}
					</div>
				</div>
			{/if}
		{/foreach}
	</div><!-- .issue-sections -->

</div><!-- .obj_issue_toc -->
