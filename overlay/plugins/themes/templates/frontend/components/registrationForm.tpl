{**
 * Academic theme override: frontend/components/registrationForm.tpl
 *
 * Bootstrap input-group layout for the OJS 3.5 registration fields.
 * All original field names, values and validation attributes are preserved.
 *}
<fieldset class="acad-form-section mb-4">
	<legend class="pkp_screen_reader">{translate key="user.profile"}</legend>

	<div class="acad-form-section-heading">
		<i class="bi bi-person-badge fs-5 text-primary me-2" aria-hidden="true"></i>
		<h2 class="h5 fw-bold mb-0 text-dark">{translate key="user.profile"}</h2>
	</div>

	<div class="row g-3">
		<div class="col-md-6">
			<label class="form-label fw-semibold" for="givenName">
				{translate key="user.givenName"}
				<span class="text-danger" aria-hidden="true">*</span>
				<span class="pkp_screen_reader">{translate key="common.required"}</span>
			</label>
			<div class="input-group">
				<span class="input-group-text" aria-hidden="true"><i class="bi bi-person"></i></span>
				<input
					type="text"
					class="form-control"
					name="givenName"
					autocomplete="given-name"
					id="givenName"
					value="{$givenName|default:""|escape}"
					maxlength="255"
					placeholder="{translate key="user.givenName"}"
					required
					aria-required="true"
				>
			</div>
		</div>

		<div class="col-md-6">
			<label class="form-label fw-semibold" for="familyName">
				{translate key="user.familyName"}
			</label>
			<div class="input-group">
				<span class="input-group-text" aria-hidden="true"><i class="bi bi-person"></i></span>
				<input
					type="text"
					class="form-control"
					name="familyName"
					autocomplete="family-name"
					id="familyName"
					value="{$familyName|default:""|escape}"
					maxlength="255"
					placeholder="{translate key="user.familyName"}"
				>
			</div>
		</div>

		<div class="col-md-6">
			<label class="form-label fw-semibold" for="affiliation">
				{translate key="user.affiliation"}
				<span class="text-danger" aria-hidden="true">*</span>
				<span class="pkp_screen_reader">{translate key="common.required"}</span>
			</label>
			<div class="input-group">
				<span class="input-group-text" aria-hidden="true"><i class="bi bi-building"></i></span>
				<input
					type="text"
					class="form-control"
					name="affiliation"
					autocomplete="organization"
					id="affiliation"
					value="{$affiliation|default:""|escape}"
					placeholder="{translate key="user.affiliation"}"
					required
					aria-required="true"
				>
			</div>
		</div>

		<div class="col-md-6">
			<label class="form-label fw-semibold" for="country">
				{translate key="common.country"}
				<span class="text-danger" aria-hidden="true">*</span>
				<span class="pkp_screen_reader">{translate key="common.required"}</span>
			</label>
			<div class="input-group">
				<span class="input-group-text" aria-hidden="true"><i class="bi bi-globe"></i></span>
				<select name="country" id="country" class="form-select" autocomplete="country-name" required aria-required="true">
					<option value="">{translate key="common.chooseOne"}</option>
					{html_options options=$countries selected=$country}
				</select>
			</div>
		</div>
	</div>
</fieldset>

<fieldset class="acad-form-section mb-4">
	<legend class="pkp_screen_reader">{translate key="plugins.themes.academic.auth.account"}</legend>

	<div class="acad-form-section-heading">
		<i class="bi bi-shield-lock fs-5 text-primary me-2" aria-hidden="true"></i>
		<h2 class="h5 fw-bold mb-0 text-dark">{translate key="plugins.themes.academic.auth.account"}</h2>
	</div>

	<div class="row g-3">
		<div class="col-md-6">
			<label class="form-label fw-semibold" for="email">
				{translate key="user.email"}
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
					maxlength="90"
					placeholder="name@example.com"
					required
					aria-required="true"
					autocomplete="email"
				>
			</div>
		</div>

		<div class="col-md-6">
			<label class="form-label fw-semibold" for="username">
				{translate key="user.username"}
				<span class="text-danger" aria-hidden="true">*</span>
				<span class="pkp_screen_reader">{translate key="common.required"}</span>
			</label>
			<div class="input-group">
				<span class="input-group-text" aria-hidden="true"><i class="bi bi-at"></i></span>
				<input
					type="text"
					class="form-control"
					name="username"
					id="username"
					value="{$username|default:""|escape}"
					maxlength="32"
					placeholder="{translate key="user.username"}"
					required
					aria-required="true"
					autocomplete="username"
				>
			</div>
		</div>

		<div class="col-md-6">
			<label class="form-label fw-semibold" for="password">
				{translate key="user.password"}
				<span class="text-danger" aria-hidden="true">*</span>
				<span class="pkp_screen_reader">{translate key="common.required"}</span>
			</label>
			<div class="input-group">
				<span class="input-group-text" aria-hidden="true"><i class="bi bi-lock"></i></span>
				<input
					type="password"
					class="form-control"
					name="password"
					id="password"
					password="true"
					maxlength="32"
					placeholder="••••••••"
					required
					aria-required="true"
					autocomplete="new-password"
				>
				<button
					class="btn btn-outline-secondary toggle-password-btn"
					type="button"
					data-target="#password"
					aria-label="{translate key="plugins.themes.academic.auth.passwordToggle"}"
					aria-pressed="false"
					title="{translate key="plugins.themes.academic.auth.passwordToggle"}"
				>
					<i class="bi bi-eye" aria-hidden="true"></i>
				</button>
			</div>
		</div>

		<div class="col-md-6">
			<label class="form-label fw-semibold" for="password2">
				{translate key="user.repeatPassword"}
				<span class="text-danger" aria-hidden="true">*</span>
				<span class="pkp_screen_reader">{translate key="common.required"}</span>
			</label>
			<div class="input-group">
				<span class="input-group-text" aria-hidden="true"><i class="bi bi-shield-check"></i></span>
				<input
					type="password"
					class="form-control"
					name="password2"
					id="password2"
					password="true"
					maxlength="32"
					placeholder="••••••••"
					required
					aria-required="true"
					autocomplete="new-password"
				>
				<button
					class="btn btn-outline-secondary toggle-password-btn"
					type="button"
					data-target="#password2"
					aria-label="{translate key="plugins.themes.academic.auth.passwordToggle"}"
					aria-pressed="false"
					title="{translate key="plugins.themes.academic.auth.passwordToggle"}"
				>
					<i class="bi bi-eye" aria-hidden="true"></i>
				</button>
			</div>
		</div>
	</div>
</fieldset>
