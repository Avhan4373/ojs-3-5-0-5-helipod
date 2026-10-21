{**
 * Academic theme override: frontend/pages/issueArchive.tpl
 *
 * Issue archive rendered as a responsive card grid. The OJS pagination,
 * empty state and page-title logic are preserved.
 *}
{capture assign="pageTitle"}
	{if $prevPage}
		{translate key="archive.archivesPageNumber" pageNumber=$prevPage+1}
	{else}
		{translate key="archive.archives"}
	{/if}
{/capture}
{include file="frontend/components/header.tpl" pageTitleTranslated=$pageTitle}

<div class="page page_issue_archive">
	<nav class="acad-breadcrumbs mb-4" role="navigation">
		<ol class="breadcrumb mb-0">
			<li class="breadcrumb-item">
				<a href="{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}">
					<i class="bi bi-house-door me-1" aria-hidden="true"></i>
					{translate key="common.homepageNavigationLabel"}
				</a>
			</li>
			<li class="breadcrumb-item active" aria-current="page">
				{$pageTitle|escape}
			</li>
		</ol>
	</nav>

	<div class="acad-section-heading">
		<h1>
			<i class="bi bi-archive text-primary" aria-hidden="true"></i>
			{$pageTitle|escape}
		</h1>
	</div>

	{* No issues have been published *}
	{if empty($issues)}
		<div class="acad-archive-empty">
			<i class="bi bi-archive" aria-hidden="true"></i>
			<p class="mb-0">{translate key="current.noCurrentIssueDesc"}</p>
		</div>
	{* List issues *}
	{else}
		<div class="row row-cols-1 row-cols-sm-2 row-cols-md-2 row-cols-lg-3 g-4 mb-4">
			{foreach from=$issues item="issue"}
				<div class="col">
					{include file="frontend/objects/issue_summary.tpl"}
				</div>
			{/foreach}
		</div>

		{* Pagination *}
		{if $prevPage > 1}
			{capture assign=prevUrl}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive" path=$prevPage}{/capture}
		{elseif $prevPage === 1}
			{capture assign=prevUrl}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}{/capture}
		{/if}
		{if $nextPage}
			{capture assign=nextUrl}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive" path=$nextPage}{/capture}
		{/if}
		{include
			file="frontend/components/pagination.tpl"
			prevUrl=$prevUrl
			nextUrl=$nextUrl
			showingStart=$showingStart
			showingEnd=$showingEnd
			total=$total
		}
	{/if}
</div>

{include file="frontend/components/footer.tpl"}
