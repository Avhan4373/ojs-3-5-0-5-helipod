{**
 * plugins/themes/academic/templates/frontend/components/academicPrimaryNav.tpl
 *
 * Primary navigation rendered with Bootstrap 5 markup.
 * Adds the journal home link and, for guests, the register/login links that
 * OJS 3.5 keeps in the user menu (the target 3.3 menu showed them inline).
 *}
{if $navigationMenu}
	{* The home URL is captured here because the menu template is rendered in its own scope. *}
	{capture assign="acadHomeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}

	{* Detect links the site manager may already have added manually. *}
	{assign var="acadHasHome" value=false}
	{assign var="acadHasRegister" value=false}
	{assign var="acadHasLogin" value=false}
	{foreach key=acadField item=acadAssignment from=$navigationMenu->menuTree}
		{assign var="acadMenuItem" value=$acadAssignment->navigationMenuItem}
		{assign var="acadMenuItemType" value=$acadMenuItem->getType()}
		{assign var="acadMenuItemUrl" value=$acadMenuItem->getUrl()}
		{if $acadMenuItemType == 'NMI_TYPE_USER_REGISTER'}
			{assign var="acadHasRegister" value=true}
		{/if}
		{if $acadMenuItemType == 'NMI_TYPE_USER_LOGIN'}
			{assign var="acadHasLogin" value=true}
		{/if}
		{if $acadMenuItemUrl == $acadHomeUrl || $acadMenuItemUrl == $acadHomeUrl|cat:"/"}
			{assign var="acadHasHome" value=true}
		{/if}
	{/foreach}

	<ul id="{$id|escape}" class="{$ulClass|escape}">
		{if !$acadHasHome}
			<li class="nav-item menu-item-home{if $requestedPage == 'index' || !$requestedPage} active{/if}">
				<a href="{$acadHomeUrl}" class="nav-link{if $requestedPage == 'index' || !$requestedPage} active{/if}"{if $requestedPage == 'index' || !$requestedPage} aria-current="page"{/if}>
					{translate key="navigation.home"}
				</a>
			</li>
		{/if}

		{foreach key=field item=navigationMenuItemAssignment from=$navigationMenu->menuTree}
			{if !$navigationMenuItemAssignment->navigationMenuItem->getIsDisplayed()}
				{continue}
			{/if}
			{assign var="acadMenuItem" value=$navigationMenuItemAssignment->navigationMenuItem}
			{assign var="acadMenuItemType" value=$acadMenuItem->getType()}
			{assign var="hasChildren" value=$acadMenuItem->getIsChildVisible()}
			{assign var="isActive" value=false}
			{if $acadMenuItemType == 'NMI_TYPE_ARCHIVES' && $requestedPage == 'issue' && $requestedOp == 'archive'}
				{assign var="isActive" value=true}
			{elseif $acadMenuItemType == 'NMI_TYPE_ABOUT' && $requestedPage == 'about'}
				{assign var="isActive" value=true}
			{elseif $acadMenuItemType == 'NMI_TYPE_CURRENT'}
				{if $requestedPage == 'issue' && $requestedOp == 'current'}
					{assign var="isActive" value=true}
				{elseif $requestedPage == 'issue' && $requestedOp == 'view' && $issue && $issue->getId() == $currentContext->getData('currentIssueId')}
					{assign var="isActive" value=true}
				{/if}
			{/if}
			<li class="nav-item menu-item-{$acadMenuItem->getId()|escape}{if $hasChildren} dropdown{/if}{if $isActive} active{/if}">
				<a href="{$acadMenuItem->getUrl()}"
					class="nav-link{if $hasChildren} dropdown-toggle{/if}{if $isActive} active{/if}"
					{if $hasChildren}data-bs-toggle="dropdown" aria-expanded="false" role="button"{/if}
					{if $isActive}aria-current="page"{/if}>
					{$acadMenuItem->getLocalizedTitle()}
				</a>
				{if $hasChildren}
					<ul class="dropdown-menu">
						{foreach from=$navigationMenuItemAssignment->children item=childNavigationMenuItemAssignment}
							{if $childNavigationMenuItemAssignment->navigationMenuItem->getIsDisplayed()}
								<li>
									<a class="dropdown-item" href="{$childNavigationMenuItemAssignment->navigationMenuItem->getUrl()}">
										<i class="bi bi-chevron-right text-muted small me-2"></i>{$childNavigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}
									</a>
								</li>
							{/if}
						{/foreach}
					</ul>
				{/if}
			</li>
		{/foreach}

		{if !$isUserLoggedIn && !$acadHasRegister && !$currentContext->getData('disableUserReg')}
			{assign var="acadRegisterActive" value=($requestedPage == 'user' && $requestedOp == 'register')}
			<li class="nav-item menu-item-register{if $acadRegisterActive} active{/if}">
				<a href="{url page="user" op="register"}" class="nav-link{if $acadRegisterActive} active{/if}"{if $acadRegisterActive} aria-current="page"{/if}>
					{translate key="navigation.register"}
				</a>
			</li>
		{/if}
		{if !$isUserLoggedIn && !$acadHasLogin}
			{assign var="acadLoginActive" value=($requestedPage == 'login')}
			<li class="nav-item menu-item-login{if $acadLoginActive} active{/if}">
				<a href="{url page="login"}" class="nav-link{if $acadLoginActive} active{/if}"{if $acadLoginActive} aria-current="page"{/if}>
					{translate key="navigation.login"}
				</a>
			</li>
		{/if}
	</ul>
{/if}
