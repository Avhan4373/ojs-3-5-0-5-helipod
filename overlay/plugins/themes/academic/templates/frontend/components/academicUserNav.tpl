{**
 * plugins/themes/academic/templates/frontend/components/academicUserNav.tpl
 *
 * User navigation rendered with Bootstrap 5 markup.
 *}
{if $navigationMenu}
	<ul id="{$id|escape}" class="{$ulClass|escape}">
		{foreach key=field item=navigationMenuItemAssignment from=$navigationMenu->menuTree}
			{if !$navigationMenuItemAssignment->navigationMenuItem->getIsDisplayed()}
				{continue}
			{/if}
			{assign var="hasChildren" value=$navigationMenuItemAssignment->navigationMenuItem->getIsChildVisible()}
			<li class="nav-item menu-item-{$navigationMenuItemAssignment->navigationMenuItem->getId()|escape}{if $hasChildren} dropdown{/if}">
				<a href="{$navigationMenuItemAssignment->navigationMenuItem->getUrl()}"
					class="{if $ulClass == 'navbar-nav'}nav-link{else}dropdown-item{/if}{if $hasChildren} dropdown-toggle{/if}"
					{if $hasChildren}data-bs-toggle="dropdown" aria-expanded="false" role="button"{/if}>
					{$navigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}
				</a>
				{if $hasChildren}
					<ul class="dropdown-menu dropdown-menu-end">
						{foreach from=$navigationMenuItemAssignment->children item=childNavigationMenuItemAssignment}
							{if $childNavigationMenuItemAssignment->navigationMenuItem->getIsDisplayed()}
								<li>
									<a class="dropdown-item" href="{$childNavigationMenuItemAssignment->navigationMenuItem->getUrl()}">
										{$childNavigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}
									</a>
								</li>
							{/if}
						{/foreach}
					</ul>
				{/if}
			</li>
		{/foreach}
	</ul>
{/if}
