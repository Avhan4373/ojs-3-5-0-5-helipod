{**
 * plugins/blocks/sidebarCards/templates/block.tpl
 *
 * Frontend markup for the configurable sidebar cards.
 *}
{if $sidebarCardsChatEnabled}
	<div class="pkp_block block_custom acad-card-block acad-card-chat" id="customblock-chat-us">
		<h2 class="title">{$sidebarCardsChatTitle|escape}</h2>
		<div class="content">
			{if $sidebarCardsChatImage}
				<a href="{$sidebarCardsChatUrl|escape}" class="acad-card-image-link"{if $sidebarCardsChatUrl} target="_blank" rel="noopener"{/if}>
					<img src="{$sidebarCardsChatImage|escape}" alt="{$sidebarCardsChatTitle|escape}" loading="lazy">
				</a>
			{else}
				<div class="acad-card-icon" aria-hidden="true"><i class="bi bi-whatsapp"></i></div>
			{/if}

			{if $sidebarCardsChatDescription}
				<p class="acad-card-description">{$sidebarCardsChatDescription|escape}</p>
			{/if}

			{if $sidebarCardsChatUrl}
				<a href="{$sidebarCardsChatUrl|escape}" class="acad-card-button" target="_blank" rel="noopener">
					<i class="bi bi-chat-dots" aria-hidden="true"></i>
					{translate key="plugins.block.sidebarCards.button.chat"}
				</a>
			{/if}
		</div>
	</div>
{/if}

{if $sidebarCardsTemplateEnabled}
	<div class="pkp_block block_custom acad-card-block acad-card-template" id="customblock-journal-template">
		<h2 class="title">{$sidebarCardsTemplateTitle|escape}</h2>
		<div class="content">
			{if $sidebarCardsTemplateImage}
				<a href="{$sidebarCardsTemplateUrl|escape}" class="acad-card-image-link"{if $sidebarCardsTemplateUrl} target="_blank" rel="noopener"{/if}>
					<img src="{$sidebarCardsTemplateImage|escape}" alt="{$sidebarCardsTemplateTitle|escape}" loading="lazy">
				</a>
			{else}
				<div class="acad-card-icon" aria-hidden="true"><i class="bi bi-file-earmark-word"></i></div>
			{/if}

			{if $sidebarCardsTemplateDescription}
				<p class="acad-card-description">{$sidebarCardsTemplateDescription|escape}</p>
			{/if}

			{if $sidebarCardsTemplateUrl}
				<a href="{$sidebarCardsTemplateUrl|escape}" class="acad-card-button" target="_blank" rel="noopener">
					<i class="bi bi-download" aria-hidden="true"></i>
					{translate key="plugins.block.sidebarCards.button.template"}
				</a>
			{/if}
		</div>
	</div>
{/if}

{if $sidebarCardsToolsEnabled && $sidebarCardsTools}
	<div class="pkp_block block_custom acad-card-block acad-card-tools" id="customblock-recommended-tools">
		<h2 class="title">{$sidebarCardsToolsTitle|escape}</h2>
		<div class="content">
			<div class="acad-tools-grid">
				{foreach from=$sidebarCardsTools item=tool}
					<a href="{$tool.url|escape}" class="acad-tool-item" target="_blank" rel="noopener">
						{if $tool.image}
							<img src="{$tool.image|escape}" alt="{$tool.title|escape}" loading="lazy">
						{else}
							<span class="acad-tool-icon" aria-hidden="true"><i class="bi bi-box-arrow-up-right"></i></span>
						{/if}
						<span class="acad-tool-title">{$tool.title|escape}</span>
					</a>
				{/foreach}
			</div>
		</div>
	</div>
{/if}

{if $sidebarCardsPopularEnabled}
	<div class="pkp_block block_developed_by acad-card-block acad-card-popular" id="customblock-popular-article">
		<h2 class="title">{$sidebarCardsPopularTitle|escape}</h2>
		<div class="content">
			{if $sidebarCardsPopular}
				<ul class="most_read">
					{foreach from=$sidebarCardsPopular item=article}
						<li class="most_read_article">
							<div class="most_read_article_title">
								<a href="{$article.url|escape}">{$article.title|escape}</a>
							</div>
							<div class="most_read_article_journal">
								<span class="bi bi-eye" aria-hidden="true"></span> {$article.views}
							</div>
						</li>
					{/foreach}
				</ul>
			{else}
				<p class="acad-card-empty">{translate key="plugins.block.sidebarCards.popular.empty"}</p>
			{/if}
		</div>
	</div>
{/if}

{foreach from=$sidebarCardsCustom item=card}
	<div class="pkp_block block_custom acad-card-block acad-card-custom" id="customblock-custom-{$card.title|escape:"url"}">
		{if $card.title}
			<h2 class="title">{$card.title|escape}</h2>
		{/if}
		<div class="content">
			{if $card.image}
				{if $card.url}
					<a href="{$card.url|escape}" class="acad-card-image-link" target="_blank" rel="noopener">
						<img src="{$card.image|escape}" alt="{$card.title|escape}" loading="lazy">
					</a>
				{else}
					<img src="{$card.image|escape}" alt="{$card.title|escape}" loading="lazy">
				{/if}
			{/if}

			{if $card.content}
				{$card.content}
			{/if}

			{if $card.url}
				<a href="{$card.url|escape}" class="acad-card-button" target="_blank" rel="noopener">
					<i class="bi bi-arrow-right" aria-hidden="true"></i>
					{translate key="plugins.block.sidebarCards.button.more"}
				</a>
			{/if}
		</div>
	</div>
{/foreach}
