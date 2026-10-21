{**
 * plugins/themes/academic/templates/frontend/components/header.tpl
 *
 * Bootstrap 5 journal header for the academic theme:
 * top bar → branding header → sticky navbar → page content wrapper.
 *}
{assign var="homeUrl" value=""}
{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}

{assign var="acadColour" value="emerald"}
{assign var="acadHeaderStyle" value="light"}
{assign var="acadTypography" value="inter"}
{if $activeTheme}
	{assign var="acadColour" value=$activeTheme->getOption('colourScheme')|default:"emerald"}
	{assign var="acadHeaderStyle" value=$activeTheme->getOption('headerStyle')|default:"light"}
	{assign var="acadTypography" value=$activeTheme->getOption('typography')|default:"inter"}
{/if}

{include file="frontend/components/headerHead.tpl"}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $displayPageHeaderLogo} has_site_logo{/if} theme-{$acadColour|escape} header-style-{$acadHeaderStyle|escape} typo-{$acadTypography|escape}" dir="{$currentLocaleLangDir|escape|default:"ltr"}">

	<div class="pkp_structure_page">

		{include file="frontend/components/skipLinks.tpl"}

		{* ============ Top bar ============ *}
		<div class="acad-topbar d-none d-lg-block">
			<div class="container d-flex justify-content-between align-items-center">
				<div class="acad-topbar-left">
					<span class="me-3">
						<i class="bi bi-journal-bookmark me-1"></i>{$displayPageHeaderTitle|escape}
					</span>
				</div>
				<div class="acad-topbar-right">
					{if $isUserLoggedIn}
						<nav aria-label="{translate|escape key="common.navigation.site"}">
							{load_menu name="user" path="frontend/components/academicTopbarNav.tpl" id="navigationUserTopbar" ulClass="pkp_nav_list"}
						</nav>
					{/if}
				</div>
			</div>
		</div>

		{* ============ Journal branding ============ *}
		<header class="acad-header" id="headerNavigationContainer" role="banner">
			<div class="container">
				<div class="row align-items-center gy-3">
					<div class="col-12">
						<div class="d-flex align-items-center">
							{if $displayPageHeaderLogo}
								<a href="{$homeUrl}" class="acad-brand-logo me-3">
									<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}"
										width="{$displayPageHeaderLogo.width|escape}"
										height="{$displayPageHeaderLogo.height|escape}"
										alt="{$displayPageHeaderTitle|escape}"
										class="img-fluid" />
								</a>
							{/if}

							<div class="acad-brand-text">
								<h1 class="acad-journal-title">
									<a href="{$homeUrl}">{$displayPageHeaderTitle|escape}</a>
								</h1>

								{if $currentContext}
									{assign var="onlineIssn" value=$currentContext->getData('onlineIssn')}
									{assign var="printIssn" value=$currentContext->getData('printIssn')}
									{if $onlineIssn || $printIssn}
										<div class="journal-issn">
											{if $onlineIssn}
												<span><span class="badge bg-primary me-1">e-ISSN</span> {$onlineIssn|escape}</span>
											{/if}
											{if $printIssn}
												<span class="ms-3"><span class="badge bg-secondary me-1">p-ISSN</span> {$printIssn|escape}</span>
											{/if}
										</div>
									{/if}
								{/if}
							</div>
						</div>
					</div>
				</div>
			</div>
		</header>

		{* ============ Navigation ============ *}
		<nav class="navbar navbar-expand-lg acad-navbar sticky-top" id="main-navigation" aria-label="{translate|escape key="common.navigation.site"}">
			<div class="container">
				<span class="navbar-brand d-lg-none text-white fw-bold">{translate key="plugins.themes.academic.openMenu"}</span>
				<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#academicNavbarContent" aria-controls="academicNavbarContent" aria-expanded="false" aria-label="{translate|escape key="plugins.themes.academic.toggleNavigation"}">
					<i class="bi bi-list fs-4"></i>
				</button>

				<div class="collapse navbar-collapse" id="academicNavbarContent">
					{load_menu name="primary" path="frontend/components/academicPrimaryNav.tpl" id="navigationPrimary" ulClass="navbar-nav me-auto mb-2 mb-lg-0"}

					{if $currentContext}
						<div class="acad-nav-search ms-lg-3">
							<form class="d-flex" role="search" method="get" action="{url page="search"}">
								<div class="input-group input-group-sm">
									<input class="form-control" name="query" value="{$searchQuery|escape|default:""}" type="search" aria-label="{translate|escape key="plugins.themes.academic.search"}" placeholder="{translate|escape key="plugins.themes.academic.search"}">
									<button class="btn btn-outline-light" type="submit" aria-label="{translate|escape key="common.search"}">
										<i class="bi bi-search"></i>
									</button>
								</div>
							</form>
						</div>
					{/if}

					{* User navigation on small screens (guests get register/login in the primary list) *}
					{if $isUserLoggedIn}
						<div class="d-lg-none border-top mt-2 pt-2">
							{load_menu name="user" path="frontend/components/academicUserNav.tpl" id="navigationUser" ulClass="navbar-nav"}
						</div>
					{/if}
				</div>
			</div>
		</nav>

		{* ============ Page wrapper ============ *}
		<div class="pkp_structure_content container py-4">
			<a id="main-content"></a>
			<div class="row g-4">
				<main class="pkp_structure_main col-12{if empty($isFullWidth)} col-lg-9 order-lg-1{/if}" role="main">
					<a id="pkp_content_main"></a>
