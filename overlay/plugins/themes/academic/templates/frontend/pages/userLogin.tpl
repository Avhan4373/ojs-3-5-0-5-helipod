{**
 * Academic theme override: frontend/pages/userLogin.tpl
 *
 * A card-based login page consistent with the journal's academic identity.
 * OJS 3.5 form field names, CSRF token and spam-protection hooks are kept.
 *}
{capture assign="pageTitleTranslated"}{translate key="user.login"}{/capture}
{include file="frontend/components/header.tpl" pageTitle="user.login"}

<div class="page page_login acad-auth-page">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="user.login"}

	<div class="acad-auth-card">
		<div class="text-center mb-4">
			<span class="acad-auth-icon acad-auth-icon--plain" aria-hidden="true">
				<i class="bi bi-person-circle"></i>
			</span>
			<h1 class="h3 fw-bold text-primary mt-2 mb-1">
				{translate key="user.login"}
			</h1>
			<p class="text-muted small mb-0">
				{translate key="common.requiredField"}
			</p>
		</div>

		{if $loginMessage}
			<div class="alert alert-info py-2 small" role="status">
				{translate key=$loginMessage}
			</div>
		{/if}

		{if $error}
			<div class="alert alert-danger py-2 small" role="alert">
				{translate key=$error reason=$reason}
			</div>
		{/if}

		<form class="cmp_form login login-form acad-auth-form" id="login" method="post" action="{$loginUrl}" role="form">
			{csrf}
			<input type="hidden" name="source" value="{$source|default:""|escape}" />

			<div class="mb-3">
				<label class="form-label fw-semibold" for="username">
					<i class="bi bi-person me-1"></i>
					{translate key="user.usernameOrEmail"}
					<span class="text-danger">*</span>
				</label>
				<input
					type="text"
					class="form-control"
					name="username"
					id="username"
					value="{$username|default:""|escape}"
					maxlength="32"
					required
					aria-required="true"
					autocomplete="username"
				>
			</div>

			<div class="mb-3">
				<div class="d-flex justify-content-between align-items-center gap-2">
					<label class="form-label fw-semibold mb-0" for="password">
						<i class="bi bi-key me-1"></i>
						{translate key="user.password"}
						<span class="text-danger">*</span>
					</label>
					<a class="small text-decoration-none" href="{url page="login" op="lostPassword"}">
						{translate key="user.login.forgotPassword"}
					</a>
				</div>
				<input
					type="password"
					class="form-control mt-1"
					name="password"
					id="password"
					value="{$password|default:""|escape}"
					password="true"
					maxlength="32"
					required
					aria-required="true"
					autocomplete="current-password"
				>
			</div>

			<div class="form-check mb-3">
				<input
					class="form-check-input"
					type="checkbox"
					name="remember"
					id="remember"
					value="1"
					{if $remember}checked="checked"{/if}
				>
				<label class="form-check-label small" for="remember">
					{translate key="user.login.rememberUsernameAndPassword"}
				</label>
			</div>

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

			<div class="d-grid gap-2 mt-4">
				<button class="btn btn-primary btn-lg" type="submit">
					<i class="bi bi-box-arrow-in-right me-1"></i>
					{translate key="user.login"}
				</button>
			</div>

			{if !$disableUserReg}
				{capture assign=registerUrl}{url page="user" op="register" source=$source}{/capture}
				<div class="text-center mt-3 pt-3 border-top small text-muted">
					{translate key="plugins.themes.academic.auth.noAccount"}
					<a class="fw-bold text-primary text-decoration-none ms-1" href="{$registerUrl}">
						{translate key="user.login.registerNewAccount"}
					</a>
				</div>
			{/if}
		</form>
	</div>
</div>

{include file="frontend/components/footer.tpl"}
