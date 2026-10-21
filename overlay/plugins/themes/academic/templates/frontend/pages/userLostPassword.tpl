{**
 * Academic theme override: frontend/pages/userLostPassword.tpl
 *
 * Card-based password reset request page, consistent with login/register.
 * OJS 3.5 CSRF token, error handling and spam-protection hooks are kept.
 *}
{capture assign="pageTitleTranslated"}{translate key="user.login.resetPassword"}{/capture}
{include file="frontend/components/header.tpl" pageTitle="user.login.resetPassword"}

<div class="page page_lost_password acad-auth-page">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="user.login.resetPassword"}

	<div class="acad-auth-card">
		<div class="text-center mb-4">
			<span class="acad-auth-icon acad-auth-icon--plain" aria-hidden="true">
				<i class="bi bi-shield-lock"></i>
			</span>
			<h1 class="h3 fw-bold text-primary mt-2 mb-1">
				{translate key="user.login.resetPassword"}
			</h1>
			<p class="text-muted small mb-0">
				{translate key="user.login.resetPasswordInstructions"}
			</p>
		</div>

		{if $error}
			<div class="alert alert-danger py-2 small" role="alert">
				{translate key=$error reason=$reason}
			</div>
		{/if}

		<form class="cmp_form lost_password acad-auth-form" id="lostPasswordForm" action="{url page="login" op="requestResetPassword"}" method="post" role="form">
			{csrf}

			<div class="mb-3">
				<label class="form-label fw-semibold" for="email">
					<i class="bi bi-envelope me-1"></i>
					{translate key="user.login.registeredEmail"}
					<span class="text-danger" aria-hidden="true">*</span>
					<span class="pkp_screen_reader">{translate key="common.required"}</span>
				</label>
				<div class="input-group">
					<span class="input-group-text" aria-hidden="true"><i class="bi bi-envelope"></i></span>
					<input
						type="email"
						class="form-control"
						name="email"
						id="email"
						value="{$email|default:""|escape}"
						placeholder="name@example.com"
						required
						aria-required="true"
						autocomplete="email"
					>
				</div>
			</div>

			{* altcha spam blocker *}
			{if $altchaEnabled}
				<div class="mb-3">
					<altcha-widget challengejson='{$altchaChallenge|@json_encode}' floating></altcha-widget>
				</div>
			{/if}

			<div class="d-grid gap-2 mt-4">
				<button class="btn btn-primary btn-lg" type="submit">
					<i class="bi bi-send me-1"></i>
					{translate key="user.login.resetPassword"}
				</button>
			</div>

			<div class="text-center mt-3 pt-3 border-top small text-muted">
				<a class="fw-semibold text-decoration-none" href="{url page="login"}">
					{translate key="user.login"}
				</a>
				<span class="mx-1" aria-hidden="true">•</span>
				{if !$disableUserReg}
					{capture assign=registerUrl}{url page="user" op="register" source=$source}{/capture}
					<a class="fw-semibold text-decoration-none" href="{$registerUrl}">
						{translate key="user.login.registerNewAccount"}
					</a>
				{/if}
			</div>
		</form>
	</div>
</div>

{include file="frontend/components/footer.tpl"}
