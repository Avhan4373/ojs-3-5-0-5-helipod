{**
 * plugins/themes/academic/templates/frontend/objects/article_summary.tpl
 *
 * Article card: usage badges, title, authors, date, pages, DOI and galleys.
 *}
{assign var=publication value=$article->getCurrentPublication()}
{assign var=articlePath value=$publication->getData('urlPath')|default:$article->getId()}
{assign var="articleUrl" value=""}
{capture assign="articleUrl"}{url page="article" op="view" path=$articlePath}{/capture}

{if !$heading}
	{assign var="heading" value="h4"}
{/if}

{if (!$section.hideAuthor && $publication->getData('hideAuthor') == APP\submission\Submission::AUTHOR_TOC_DEFAULT) || $publication->getData('hideAuthor') == APP\submission\Submission::AUTHOR_TOC_SHOW}
	{assign var="showAuthor" value=true}
{/if}

{acad_article_stats article=$article assign="acadArticleStats"}

<article class="obj_article_summary card mb-3 border">
	<div class="card-body p-3">
		<div class="row align-items-center">
			<div class="col-12">

				{if ($acadArticleStats.views > 0 || $acadArticleStats.downloads > 0)}
					<div class="article-summary-stats d-flex align-items-center flex-wrap gap-2 mb-2">
						<span class="acad-stat-badge" title="{translate|escape key="plugins.themes.academic.views"}">
							<i class="bi bi-eye me-1"></i><strong>{acad_number value=$acadArticleStats.views}</strong> {translate key="plugins.themes.academic.views"}
						</span>
						<span class="acad-stat-badge" title="{translate|escape key="plugins.themes.academic.downloads"}">
							<i class="bi bi-download me-1"></i><strong>{acad_number value=$acadArticleStats.downloads}</strong> {translate key="plugins.themes.academic.downloads"}
						</span>
					</div>
				{/if}

				<{$heading} class="title card-title mb-2">
					<a id="article-{$article->getId()}" href="{$articleUrl}">
						{$publication->getLocalizedTitle(null, 'html')|strip_unsafe_html}
						{assign var=localizedSubtitle value=$publication->getLocalizedSubtitle(null, 'html')|strip_unsafe_html}
						{if $localizedSubtitle}
							<span class="subtitle">{$localizedSubtitle}</span>
						{/if}
					</a>
				</{$heading}>

				{if $showAuthor || $publication->getData('pages') || $publication->getData('datePublished')}
					{if $showAuthor}
						<div class="authors mb-2">
							{$publication->getAuthorString($authorUserGroups)|escape}
						</div>
					{/if}

					<div class="meta-row d-flex justify-content-between align-items-center flex-wrap gap-2 pt-2 border-top">
						<div class="d-flex align-items-center flex-wrap gap-3 small text-muted">
							{assign var=submissionDatePublished value=$publication->getData('datePublished')}
							{if $submissionDatePublished}
								<span><i class="bi bi-calendar3 me-1"></i>{$submissionDatePublished|date_format:$dateFormatShort}</span>
							{/if}

							{assign var=submissionPages value=$publication->getLocalizedData('pages')}
							{if $submissionPages}
								<span><i class="bi bi-file-earmark-text me-1"></i>{translate key="plugins.themes.academic.pages"}: {$submissionPages|escape}</span>
							{/if}

							{assign var="doiObject" value=$publication->getData('doiObject')}
							{if $doiObject}
								{assign var="doiUrl" value=$doiObject->getResolvingUrl()}
								<a href="{$doiUrl|escape}" target="_blank" rel="noopener" class="acad-doi-badge">
									<i class="bi bi-link-45deg"></i> DOI: {$doiObject->getDoi()|escape}
								</a>
							{/if}
						</div>

						<div class="galleys_links">
							{foreach from=$publication->getData('galleys') item=galley}
								{assign var="file" value=$galley->getFile()}
								{if $primaryGenreIds && !$galley->getData('urlRemote') && !($file && in_array($file->getGenreId(), $primaryGenreIds))}
									{continue}
								{/if}
								{assign var="hasArticleAccess" value=$hasAccess}
								{if $currentContext->getSetting('publishingMode') == APP\journal\Journal::PUBLISHING_MODE_OPEN || $publication->getData('accessStatus') == APP\submission\Submission::ARTICLE_ACCESS_OPEN}
									{assign var="hasArticleAccess" value=1}
								{/if}
								{assign var="id" value="article-{$article->getId()}-galley-{$galley->getId()}"}
								{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication id=$id labelledBy="{$id} article-{$article->getId()}" hasAccess=$hasArticleAccess purchaseFee=$currentJournal->getData('purchaseArticleFee') purchaseCurrency=$currentJournal->getData('currency')}
							{/foreach}
						</div>
					</div>
				{/if}
			</div>
		</div>
	</div>
	{call_hook name="Templates::Issue::Issue::Article"}
</article>
