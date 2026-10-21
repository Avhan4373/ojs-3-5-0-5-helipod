{**
 * plugins/blocks/sidebarCards/templates/settingsForm.tpl
 *
 * Admin settings for the Sidebar Cards block.
 *}
<script>
	{literal}
	$(function() {
		$('#sidebarCardsSettingsForm').pkpHandler('$.pkp.controllers.form.AjaxFormHandler');
	});
	{/literal}
</script>

<style>
	.sc-card-section { margin-bottom: 2rem; padding-bottom: 1.5rem; border-bottom: 1px solid #e5e7eb; }
	.sc-card-section:last-of-type { border-bottom: 0; }
	.sc-card-section h3 { margin: 0 0 .35rem; font-size: 1.05rem; }
	.sc-card-hint { color: #6b7280; font-size: .82rem; margin: 0 0 1rem; }
	.sc-row { background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 6px; padding: .85rem; margin-bottom: .75rem; }
	.sc-row-head { display: flex; align-items: center; justify-content: space-between; gap: .75rem; margin-bottom: .6rem; }
	.sc-row-head strong { font-size: .88rem; }
	.sc-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: .65rem; }
	.sc-grid .sc-full { grid-column: 1 / -1; }
	.sc-field label { display: block; font-size: .78rem; font-weight: 600; margin-bottom: .2rem; color: #374151; }
	.sc-field input[type="text"], .sc-field input[type="url"], .sc-field textarea { width: 100%; box-sizing: border-box; }
	.sc-field textarea { min-height: 5rem; resize: vertical; }
	.sc-remove { color: #b91c1c; background: transparent; border: 0; cursor: pointer; font-size: .8rem; padding: .2rem .4rem; }
	.sc-remove:hover { text-decoration: underline; }
	.sc-add { margin-top: .25rem; }
	.sc-upload-row { display: flex; align-items: center; gap: .75rem; flex-wrap: wrap; margin-top: .35rem; }
	.sc-upload-row input[type="file"] { font-size: .8rem; }
	.sc-preview { max-height: 64px; max-width: 160px; border: 1px solid #e5e7eb; border-radius: 4px; padding: 2px; background: #fff; }
	.sc-upload-status { font-size: .78rem; color: #6b7280; }
	.sc-upload-status.is-error { color: #b91c1c; }
	@media (max-width: 640px) { .sc-grid { grid-template-columns: 1fr; } }
</style>

<form class="pkp_form" id="sidebarCardsSettingsForm" method="post" action="{url router=PKP\core\PKPApplication::ROUTE_COMPONENT op="manage" category="blocks" plugin=$pluginName verb="settings" save=true}">
	{csrf}
	{include file="controllers/notification/inPlaceNotification.tpl" notificationId="sidebarCardsSettingsFormNotification"}

	<div id="description">{translate key="plugins.block.sidebarCards.settingsIntro"}</div>

	{fbvFormArea id="sidebarCardsChatArea"}
		<div class="sc-card-section">
			<h3>{translate key="plugins.block.sidebarCards.section.chat"}</h3>
			<p class="sc-card-hint">{translate key="plugins.block.sidebarCards.section.chatHint"}</p>

			{fbvFormSection list=true}
				{fbvElement type="checkbox" id="chatEnabled" name="chatEnabled" value="1" checked=$chatEnabled|compare:true label="plugins.block.sidebarCards.enabled"}
				{fbvElement type="text" id="chatTitle" value=$chatTitle label="plugins.block.sidebarCards.field.title"}
				{fbvElement type="url" id="chatUrl" value=$chatUrl label="plugins.block.sidebarCards.field.url" size=$fbvStyles.size.LARGE}
				{fbvElement type="text" id="chatImage" value=$chatImage label="plugins.block.sidebarCards.field.image" size=$fbvStyles.size.LARGE}
				{fbvElement type="textarea" id="chatDescription" value=$chatDescription label="plugins.block.sidebarCards.field.description"}
			{/fbvFormSection}

			<div class="sc-upload-row">
				<input type="file" class="sc-upload" data-target="chatImage" accept="image/jpeg,image/png,image/gif,image/webp">
				<span class="sc-upload-status" data-for="chatImage"></span>
				{if $chatImage}<img class="sc-preview" data-preview="chatImage" src="{$chatImage|escape}" alt="">{else}<img class="sc-preview" data-preview="chatImage" src="" alt="" style="display:none">{/if}
			</div>
		</div>
	{/fbvFormArea}

	{fbvFormArea id="sidebarCardsTemplateArea"}
		<div class="sc-card-section">
			<h3>{translate key="plugins.block.sidebarCards.section.template"}</h3>
			<p class="sc-card-hint">{translate key="plugins.block.sidebarCards.section.templateHint"}</p>

			{fbvFormSection list=true}
				{fbvElement type="checkbox" id="templateEnabled" name="templateEnabled" value="1" checked=$templateEnabled|compare:true label="plugins.block.sidebarCards.enabled"}
				{fbvElement type="text" id="templateTitle" value=$templateTitle label="plugins.block.sidebarCards.field.title"}
				{fbvElement type="url" id="templateUrl" value=$templateUrl label="plugins.block.sidebarCards.field.url" size=$fbvStyles.size.LARGE}
				{fbvElement type="text" id="templateImage" value=$templateImage label="plugins.block.sidebarCards.field.image" size=$fbvStyles.size.LARGE}
				{fbvElement type="textarea" id="templateDescription" value=$templateDescription label="plugins.block.sidebarCards.field.description"}
			{/fbvFormSection}

			<div class="sc-upload-row">
				<input type="file" class="sc-upload" data-target="templateImage" accept="image/jpeg,image/png,image/gif,image/webp">
				<span class="sc-upload-status" data-for="templateImage"></span>
				{if $templateImage}<img class="sc-preview" data-preview="templateImage" src="{$templateImage|escape}" alt="">{else}<img class="sc-preview" data-preview="templateImage" src="" alt="" style="display:none">{/if}
			</div>
		</div>
	{/fbvFormArea}

	{fbvFormArea id="sidebarCardsToolsArea"}
		<div class="sc-card-section">
			<h3>{translate key="plugins.block.sidebarCards.section.tools"}</h3>
			<p class="sc-card-hint">{translate key="plugins.block.sidebarCards.section.toolsHint"}</p>

			{fbvFormSection list=true}
				{fbvElement type="checkbox" id="toolsEnabled" name="toolsEnabled" value="1" checked=$toolsEnabled|compare:true label="plugins.block.sidebarCards.enabled"}
				{fbvElement type="text" id="toolsTitle" value=$toolsTitle label="plugins.block.sidebarCards.field.title"}
			{/fbvFormSection}

			<div id="toolsRows">
				{foreach from=$tools item=tool name=toolsLoop}
					<div class="sc-row" data-row="tool">
						<div class="sc-row-head">
							<strong>{translate key="plugins.block.sidebarCards.tools.item"}</strong>
							<button type="button" class="sc-remove">{translate key="plugins.block.sidebarCards.remove"}</button>
						</div>
						<div class="sc-grid">
							<div class="sc-field">
								<label>{translate key="plugins.block.sidebarCards.field.title"}</label>
								<input type="text" name="tools[{$smarty.foreach.toolsLoop.index}][title]" value="{$tool.title|escape}">
							</div>
							<div class="sc-field">
								<label>{translate key="plugins.block.sidebarCards.field.url"}</label>
								<input type="url" name="tools[{$smarty.foreach.toolsLoop.index}][url]" value="{$tool.url|escape}">
							</div>
							<div class="sc-field sc-full">
								<label>{translate key="plugins.block.sidebarCards.field.image"}</label>
								<input type="text" name="tools[{$smarty.foreach.toolsLoop.index}][image]" id="toolImage{$smarty.foreach.toolsLoop.index}" value="{$tool.image|escape}">
								<div class="sc-upload-row">
									<input type="file" class="sc-upload" data-target="toolImage{$smarty.foreach.toolsLoop.index}" accept="image/jpeg,image/png,image/gif,image/webp">
									<span class="sc-upload-status" data-for="toolImage{$smarty.foreach.toolsLoop.index}"></span>
									{if $tool.image}<img class="sc-preview" data-preview="toolImage{$smarty.foreach.toolsLoop.index}" src="{$tool.image|escape}" alt="">{/if}
								</div>
							</div>
						</div>
					</div>
				{/foreach}
			</div>
			<button type="button" class="pkp_button sc-add" id="addTool">{translate key="plugins.block.sidebarCards.tools.add"}</button>
		</div>
	{/fbvFormArea}

	{fbvFormArea id="sidebarCardsPopularArea"}
		<div class="sc-card-section">
			<h3>{translate key="plugins.block.sidebarCards.section.popular"}</h3>
			<p class="sc-card-hint">{translate key="plugins.block.sidebarCards.section.popularHint"}</p>

			{fbvFormSection list=true}
				{fbvElement type="checkbox" id="popularEnabled" name="popularEnabled" value="1" checked=$popularEnabled|compare:true label="plugins.block.sidebarCards.enabled"}
				{fbvElement type="text" id="popularTitle" value=$popularTitle label="plugins.block.sidebarCards.field.title"}
				{fbvElement type="text" id="popularCount" value=$popularCount label="plugins.block.sidebarCards.field.popularCount" size=$fbvStyles.size.SMALL}
			{/fbvFormSection}
		</div>
	{/fbvFormArea}

	{fbvFormArea id="sidebarCardsCustomArea"}
		<div class="sc-card-section">
			<h3>{translate key="plugins.block.sidebarCards.section.custom"}</h3>
			<p class="sc-card-hint">{translate key="plugins.block.sidebarCards.section.customHint"}</p>

			<div id="customCardsRows">
				{foreach from=$customCards item=card name=customLoop}
					<div class="sc-row" data-row="custom">
						<div class="sc-row-head">
							<strong>{translate key="plugins.block.sidebarCards.custom.item"}</strong>
							<button type="button" class="sc-remove">{translate key="plugins.block.sidebarCards.remove"}</button>
						</div>
						<div class="sc-grid">
							<div class="sc-field">
								<label>{translate key="plugins.block.sidebarCards.field.title"}</label>
								<input type="text" name="customCards[{$smarty.foreach.customLoop.index}][title]" value="{$card.title|escape}">
							</div>
							<div class="sc-field">
								<label>{translate key="plugins.block.sidebarCards.field.url"}</label>
								<input type="url" name="customCards[{$smarty.foreach.customLoop.index}][url]" value="{$card.url|escape}">
							</div>
							<div class="sc-field sc-full">
								<label>{translate key="plugins.block.sidebarCards.field.image"}</label>
								<input type="text" name="customCards[{$smarty.foreach.customLoop.index}][image]" id="customImage{$smarty.foreach.customLoop.index}" value="{$card.image|escape}">
								<div class="sc-upload-row">
									<input type="file" class="sc-upload" data-target="customImage{$smarty.foreach.customLoop.index}" accept="image/jpeg,image/png,image/gif,image/webp">
									<span class="sc-upload-status" data-for="customImage{$smarty.foreach.customLoop.index}"></span>
									{if $card.image}<img class="sc-preview" data-preview="customImage{$smarty.foreach.customLoop.index}" src="{$card.image|escape}" alt="">{/if}
								</div>
							</div>
							<div class="sc-field sc-full">
								<label>{translate key="plugins.block.sidebarCards.field.content"}</label>
								<textarea name="customCards[{$smarty.foreach.customLoop.index}][content]">{$card.content|escape}</textarea>
							</div>
							<div class="sc-field sc-full">
								<label><input type="checkbox" name="customCards[{$smarty.foreach.customLoop.index}][enabled]" value="1" {if $card.enabled}checked{/if}> {translate key="plugins.block.sidebarCards.enabled"}</label>
							</div>
						</div>
					</div>
				{/foreach}
			</div>
			<button type="button" class="pkp_button sc-add" id="addCustomCard">{translate key="plugins.block.sidebarCards.custom.add"}</button>
		</div>
	{/fbvFormArea}

	{fbvFormArea id="sidebarCardsDisplayArea"}
		<div class="sc-card-section">
			<h3>{translate key="plugins.block.sidebarCards.section.display"}</h3>
			{fbvFormSection list=true}
				{fbvElement type="radio" id="displayPages-all" name="displayPages" value="all" checked=$displayPages|compare:"all" label="plugins.block.sidebarCards.display.all"}
				{fbvElement type="radio" id="displayPages-home" name="displayPages" value="home" checked=$displayPages|compare:"home" label="plugins.block.sidebarCards.display.home"}
			{/fbvFormSection}
		</div>
	{/fbvFormArea}

	{fbvFormButtons submitText="common.save"}
	<p><span class="formRequired">{translate key="common.requiredField"}</span></p>
</form>

<div id="sidebarCardsConfig"
	data-upload-url="{url router=PKP\core\PKPApplication::ROUTE_COMPONENT op="manage" category="blocks" plugin=$pluginName verb="upload" escape=false}"
	data-tool-index="{$tools|@count}"
	data-custom-index="{$customCards|@count}"
	data-msg-uploading="{translate|escape key="plugins.block.sidebarCards.upload.uploading"}"
	data-msg-uploaded="{translate|escape key="plugins.block.sidebarCards.upload.success"}"
	data-msg-tool="{translate|escape key="plugins.block.sidebarCards.tools.item"}"
	data-msg-remove="{translate|escape key="plugins.block.sidebarCards.remove"}"
	data-msg-title="{translate|escape key="plugins.block.sidebarCards.field.title"}"
	data-msg-url="{translate|escape key="plugins.block.sidebarCards.field.url"}"
	data-msg-image="{translate|escape key="plugins.block.sidebarCards.field.image"}"
	data-msg-custom="{translate|escape key="plugins.block.sidebarCards.custom.item"}"
	data-msg-content="{translate|escape key="plugins.block.sidebarCards.field.content"}"
	data-msg-enabled="{translate|escape key="plugins.block.sidebarCards.enabled"}"
></div>

<script>
	{literal}
	(function() {
		var config = document.getElementById('sidebarCardsConfig');
		var uploadUrl = config.dataset.uploadUrl;
		var toolIndex = parseInt(config.dataset.toolIndex || '0', 10);
		var customIndex = parseInt(config.dataset.customIndex || '0', 10);
		var msg = {
			uploading: config.dataset.msgUploading,
			uploaded: config.dataset.msgUploaded,
			tool: config.dataset.msgTool,
			remove: config.dataset.msgRemove,
			title: config.dataset.msgTitle,
			url: config.dataset.msgUrl,
			image: config.dataset.msgImage,
			custom: config.dataset.msgCustom,
			content: config.dataset.msgContent,
			enabled: config.dataset.msgEnabled
		};

		function uploadField(input) {
			var targetId = input.getAttribute('data-target');
			var target = document.getElementById(targetId);
			if (!target || !input.files || !input.files.length) {
				return;
			}

			var status = document.querySelector('.sc-upload-status[data-for="' + targetId + '"]');
			var preview = document.querySelector('.sc-preview[data-preview="' + targetId + '"]');
			var csrf = document.querySelector('input[name="csrfToken"]');

			if (status) {
				status.className = 'sc-upload-status';
				status.textContent = msg.uploading;
			}

			var data = new FormData();
			data.append('image', input.files[0]);
			data.append('csrfToken', csrf ? csrf.value : '');

			fetch(uploadUrl, {method: 'POST', body: data, credentials: 'same-origin'})
				.then(function(response) { return response.json(); })
				.then(function(json) {
					if (!json.status) {
						throw new Error(json.content || 'Upload failed');
					}
					target.value = json.content;
					if (preview) {
						preview.src = json.content;
						preview.style.display = '';
					}
					if (status) {
						status.textContent = msg.uploaded;
					}
				})
				.catch(function(error) {
					if (status) {
						status.className = 'sc-upload-status is-error';
						status.textContent = error.message;
					}
				});
		}

		document.addEventListener('change', function(event) {
			if (event.target.classList && event.target.classList.contains('sc-upload')) {
				uploadField(event.target);
			}
		});

		document.addEventListener('click', function(event) {
			if (event.target.classList && event.target.classList.contains('sc-remove')) {
				var row = event.target.closest('.sc-row');
				if (row) {
					row.parentNode.removeChild(row);
				}
			}
		});

		function toolRow(index) {
			return '' +
				'<div class="sc-row" data-row="tool">' +
					'<div class="sc-row-head"><strong>' + msg.tool + '</strong>' +
						'<button type="button" class="sc-remove">' + msg.remove + '</button></div>' +
					'<div class="sc-grid">' +
						'<div class="sc-field"><label>' + msg.title + '</label>' +
							'<input type="text" name="tools[' + index + '][title]" value=""></div>' +
						'<div class="sc-field"><label>' + msg.url + '</label>' +
							'<input type="url" name="tools[' + index + '][url]" value=""></div>' +
						'<div class="sc-field sc-full"><label>' + msg.image + '</label>' +
							'<input type="text" name="tools[' + index + '][image]" id="toolImage' + index + '" value="">' +
							'<div class="sc-upload-row"><input type="file" class="sc-upload" data-target="toolImage' + index + '" accept="image/jpeg,image/png,image/gif,image/webp">' +
							'<span class="sc-upload-status" data-for="toolImage' + index + '"></span></div></div>' +
					'</div>' +
				'</div>';
		}

		function customRow(index) {
			return '' +
				'<div class="sc-row" data-row="custom">' +
					'<div class="sc-row-head"><strong>' + msg.custom + '</strong>' +
						'<button type="button" class="sc-remove">' + msg.remove + '</button></div>' +
					'<div class="sc-grid">' +
						'<div class="sc-field"><label>' + msg.title + '</label>' +
							'<input type="text" name="customCards[' + index + '][title]" value=""></div>' +
						'<div class="sc-field"><label>' + msg.url + '</label>' +
							'<input type="url" name="customCards[' + index + '][url]" value=""></div>' +
						'<div class="sc-field sc-full"><label>' + msg.image + '</label>' +
							'<input type="text" name="customCards[' + index + '][image]" id="customImage' + index + '" value="">' +
							'<div class="sc-upload-row"><input type="file" class="sc-upload" data-target="customImage' + index + '" accept="image/jpeg,image/png,image/gif,image/webp">' +
							'<span class="sc-upload-status" data-for="customImage' + index + '"></span></div></div>' +
						'<div class="sc-field sc-full"><label>' + msg.content + '</label>' +
							'<textarea name="customCards[' + index + '][content]"></textarea></div>' +
						'<div class="sc-field sc-full"><label><input type="checkbox" name="customCards[' + index + '][enabled]" value="1" checked> ' + msg.enabled + '</label></div>' +
					'</div>' +
				'</div>';
		}

		var addTool = document.getElementById('addTool');
		if (addTool) {
			addTool.addEventListener('click', function() {
				document.getElementById('toolsRows').insertAdjacentHTML('beforeend', toolRow(toolIndex));
				toolIndex++;
			});
		}

		var addCustomCard = document.getElementById('addCustomCard');
		if (addCustomCard) {
			addCustomCard.addEventListener('click', function() {
				document.getElementById('customCardsRows').insertAdjacentHTML('beforeend', customRow(customIndex));
				customIndex++;
			});
		}
	})();
	{/literal}
</script>
