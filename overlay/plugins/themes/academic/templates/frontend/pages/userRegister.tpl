{**
 * Academic theme override: frontend/pages/userRegister.tpl
 *
 * Card-based registration page. All OJS 3.5 registration fields, consent
 * handling, reviewer opt-in, CSRF token and spam-protection hooks are kept.
 *}
{capture assign="pageTitleTranslated"}{translate key="user.register"}{/capture}
{include file="frontend/components/header.tpl" pageTitle="user.register"}

{assign var="siteContextId" value=PKP\core\PKPApplication::SITE_CONTEXT_ID|intval}

<div class="page page_register acad-auth-page">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="user.register"}

	<div class="acad-auth-card acad-register-card">
		<div class="text-center mb-4 pb-3 border-bottom">
			<span class="acad-auth-icon" aria-hidden="true">
				<i class="bi bi-person-plus-fill"></i>
			</span>
			<h1 class="h3 fw-bold text-primary mb-1">
				{translate key="user.register"}
			</h1>
			{if $currentContext}
				<p class="text-muted small mb-0">
					{$currentContext->getLocalizedName()|escape}
				</p>
			{/if}
		</div>

		<form class="cmp_form register register-form acad-auth-form" id="register" method="post" action="{url op="register"}" role="form">
			{if $orcidEnabled}
				{include file="form/orcidProfile.tpl"}
			{/if}

			{csrf}

			{if $source}
				<input type="hidden" name="source" value="{$source|escape}" />
			{/if}

			{include file="common/formErrors.tpl"}
			{include file="frontend/components/registrationForm.tpl"}

			{* Privacy and notification consent *}
			<div class="card bg-light border p-3 mb-4 acad-auth-privacy">
				<div class="d-flex align-items-center mb-2 pb-1 border-bottom">
					<i class="bi bi-patch-check fs-5 text-primary me-2" aria-hidden="true"></i>
					<h2 class="h6 fw-bold mb-0 text-dark">
						{translate key="plugins.themes.academic.auth.privacyOptions"}
					</h2>
				</div>

				{if $currentContext}
					{if $currentContext->getData('privacyStatement')}
						{assign var="privacyUrl" value=""}
						{capture assign="privacyUrl"}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="privacy"}{/capture}
						<div class="form-check mb-2">
							<input
								class="form-check-input"
								type="checkbox"
								name="privacyConsent"
								id="privacyConsent"
								value="1"
								{if $privacyConsent}checked="checked"{/if}
							>
							<label class="form-check-label small" for="privacyConsent">
								{translate key="user.register.form.privacyConsent" privacyUrl=$privacyUrl}
							</label>
						</div>
					{/if}
				{elseif $siteWidePrivacyStatement}
					{assign var="privacyUrl" value=""}
					{capture assign="privacyUrl"}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="privacy"}{/capture}
					<div class="form-check mb-2">
						<input
							class="form-check-input"
							type="checkbox"
							name="privacyConsent[{$siteContextId}]"
							id="privacyConsent{$siteContextId}"
							value="1"
							{if $privacyConsent[$siteContextId]}checked="checked"{/if}
						>
						<label class="form-check-label small" for="privacyConsent{$siteContextId}">
							{translate key="user.register.form.privacyConsent" privacyUrl=$privacyUrl}
						</label>
					</div>
				{/if}

				<div class="form-check">
					<input
						class="form-check-input"
						type="checkbox"
						name="emailConsent"
						id="emailConsent"
						value="1"
						{if $emailConsent}checked="checked"{/if}
					>
					<label class="form-check-label small" for="emailConsent">
						{translate key="user.register.form.emailConsent"}
					</label>
				</div>
			</div>

			{* Reviewer opt-in for the current journal *}
			{if $currentContext}
				{assign var=contextId value=$currentContext->getId()}
				{assign var=userCanRegisterReviewer value=0}
				{foreach from=$reviewerUserGroups[$contextId] item=userGroup}
					{if $userGroup->permitSelfRegistration}
						{assign var=userCanRegisterReviewer value=$userCanRegisterReviewer+1}
					{/if}
				{/foreach}

				{if $userCanRegisterReviewer}
					<fieldset class="acad-form-section mb-4">
						<legend class="pkp_screen_reader">{translate key="plugins.themes.academic.auth.reviewer"}</legend>

						<div class="acad-form-section-heading">
							<i class="bi bi-clipboard-check fs-5 text-primary me-2" aria-hidden="true"></i>
							<h2 class="h5 fw-bold mb-0 text-dark">{translate key="plugins.themes.academic.auth.reviewer"}</h2>
						</div>

						{if $userCanRegisterReviewer > 1}
							<p class="small text-muted mb-2">{translate key="user.reviewerPrompt"}</p>
							{capture assign="checkboxLocaleKey"}user.reviewerPrompt.userGroup{/capture}
						{else}
							{capture assign="checkboxLocaleKey"}user.reviewerPrompt.optin{/capture}
						{/if}

						<div id="reviewerOptinGroup">
							{foreach from=$reviewerUserGroups[$contextId] item=userGroup}
								{if $userGroup->permitSelfRegistration}
									{assign var="userGroupId" value=$userGroup->id}
									<div class="form-check mb-2">
										<input
											class="form-check-input"
											type="checkbox"
											name="reviewerGroup[{$userGroupId}]"
											id="reviewerGroup{$userGroupId}"
											value="1"
											{if in_array($userGroupId, $userGroupIds)}checked="checked"{/if}
										>
										<label class="form-check-label small" for="reviewerGroup{$userGroupId}">
											{translate key=$checkboxLocaleKey userGroup=$userGroup->getLocalizedData('name')}
										</label>
									</div>
								{/if}
							{/foreach}
						</div>

						<div class="mt-3">
							<label class="form-label fw-semibold" for="interests">
								{translate key="user.interests"}
							</label>
							<input
								type="text"
								class="form-control"
								name="interests"
								id="interests"
								value="{$interests|default:""|escape}"
								placeholder="{translate key="user.interests"}"
							>
						</div>
					</fieldset>
				{/if}
			{/if}

			{* Site-wide role/context selection *}
			{if !$currentContext}
				{include file="frontend/components/registrationFormContexts.tpl"}

				<fieldset class="acad-form-section mb-4">
					<legend class="pkp_screen_reader">{translate key="user.interests"}</legend>
					<div class="acad-form-section-heading">
						<i class="bi bi-clipboard-check fs-5 text-primary me-2" aria-hidden="true"></i>
						<h2 class="h5 fw-bold mb-0 text-dark">{translate key="user.interests"}</h2>
					</div>
					<label class="form-label fw-semibold" for="interests">
						{translate key="user.register.noContextReviewerInterests"}
					</label>
					<input
						type="text"
						class="form-control"
						name="interests"
						id="interests"
						value="{$interests|default:""|escape}"
					>
				</fieldset>
			{/if}

			{* recaptcha spam blocker *}
			{if $recaptchaPublicKey}
				<div class="mb-3">
					<div class="g-recaptcha" data-sitekey="{$recaptchaPublicKey|escape}"></div>
					<label for="g-recaptcha-response" class="pkp_screen_reader">Recaptcha response</label>
				</div>
			{/if}

			{* altcha spam blocker *}
			{if $altchaEnabled}
				<div class="mb-3">
					<altcha-widget challengejson='{$altchaChallenge|@json_encode}' floating></altcha-widget>
				</div>
			{/if}

			<div class="d-grid gap-2 mt-4 pt-3 border-top">
				<button class="btn btn-primary btn-lg shadow-sm" type="submit">
					<i class="bi bi-person-plus me-1"></i>
					{translate key="user.register"}
				</button>
			</div>

			{capture assign="rolesProfileUrl"}{url page="user" op="profile" path="roles"}{/capture}
			<div class="text-center mt-3 pt-3 border-top small text-muted">
				{translate key="plugins.themes.academic.auth.haveAccount"}
				<a class="fw-bold text-primary text-decoration-none ms-1" href="{url page="login" source=$rolesProfileUrl}">
					<i class="bi bi-box-arrow-in-right me-1"></i>
					{translate key="user.login"}
				</a>
			</div>
		</form>
	</div>
</div>

{include file="frontend/components/footer.tpl"}
