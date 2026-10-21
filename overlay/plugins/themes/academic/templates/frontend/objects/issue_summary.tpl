{**
 * Academic theme override: frontend/objects/issue_summary.tpl
 *
 * Issue card used by the archive grid. Cover, title, series, publication date
 * and the "view issue" action are retained.
 *}
{if $issue->getShowTitle()}
	{assign var=issueTitle value=$issue->getLocalizedTitle()}
{/if}
{assign var=issueSeries value=$issue->getIssueSeries()}
{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}
{assign var=issueDisplayTitle value=$issueSeries}
{if $issueTitle}
	{assign var=issueDisplayTitle value=$issueTitle}
{/if}
{if !$issueDisplayTitle}
	{assign var=issueDisplayTitle value=$issue->getIssueIdentification()}
{/if}
{capture assign=issueUrl}{url page="issue" op="view" path=$issue->getBestIssueId()}{/capture}
{assign var=issuePublished value=$issue->getDatePublished()}

<div class="acad-issue-card card h-100 border shadow-sm">
	<div class="acad-issue-card-cover text-center">
		<a class="p-2" href="{$issueUrl|escape}">
			{if $issueCover}
				<img
					src="{$issueCover|escape}"
					alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}"
					class="img-fluid rounded"
					loading="lazy"
					decoding="async"
				>
			{else}
				<span class="acad-issue-cover-placeholder">
					<i class="bi bi-journal-bookmark" aria-hidden="true"></i>
					<span>{translate key="issue.issue"}</span>
				</span>
			{/if}
		</a>
	</div>

	<div class="acad-issue-card-body card-body p-3 d-flex flex-column justify-content-between">
		<div>
			<h2 class="acad-issue-card-title h6 fw-bold mb-2">
				<a class="text-primary text-decoration-none" href="{$issueUrl|escape}">
					{$issueDisplayTitle|escape}
				</a>
			</h2>

			{if $issueTitle && $issueSeries}
				<div class="text-secondary small fw-medium mb-2">
					{$issueSeries|escape}
				</div>
			{/if}

			{if $issuePublished}
				<div class="small text-muted mb-2">
					<i class="bi bi-calendar3 me-1 text-primary" aria-hidden="true"></i>
					<time datetime="{$issuePublished|date_format:'Y-m-d'}">
						{$issuePublished|date_format:'Y-m-d'}
					</time>
				</div>
			{/if}
		</div>

		<div class="mt-3 pt-2 border-top">
			<a class="btn btn-sm btn-primary w-100 shadow-sm" href="{$issueUrl|escape}">
				<i class="bi bi-eye me-1" aria-hidden="true"></i>
				{translate key="issue.viewIssue"}
			</a>
		</div>
	</div>
</div>
