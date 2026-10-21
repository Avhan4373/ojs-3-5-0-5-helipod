{**
 * plugins/themes/academic/templates/frontend/components/academicSidebar.tpl
 *
 * Sidebar navigation block modelled on gudangjurnal.com's "main menu" block.
 * The links point at the closest built-in OJS pages; replace them with the
 * journal's static-page URLs once those pages exist.
 *}
<div class="pkp_block block_custom acad-sidebar-menu" id="customblock-main-menu">
	<h2 class="title">{translate key="plugins.themes.academic.sidebarTitle"}</h2>
	<div class="content">
		<ul>
			<li>
				<a href="{url page="about"}">
					<i class="bi bi-eye" aria-hidden="true"></i>
					{translate key="plugins.themes.academic.sidebar.focusScope"}
				</a>
			</li>
			<li>
				<a href="{url page="about" op="editorialMasthead"}">
					<i class="bi bi-people" aria-hidden="true"></i>
					{translate key="plugins.themes.academic.sidebar.editorialTeam"}
				</a>
			</li>
			<li>
				<a href="{url page="about" op="editorialMasthead"}">
					<i class="bi bi-mortarboard" aria-hidden="true"></i>
					{translate key="plugins.themes.academic.sidebar.reviewer"}
				</a>
			</li>
			<li>
				<a href="{url page="about"}">
					<i class="bi bi-shield-check" aria-hidden="true"></i>
					{translate key="plugins.themes.academic.sidebar.publicationEthics"}
				</a>
			</li>
			<li>
				<a href="{url page="about" op="submissions"}">
					<i class="bi bi-arrow-repeat" aria-hidden="true"></i>
					{translate key="plugins.themes.academic.sidebar.publicationProcess"}
				</a>
			</li>
			<li>
				<a href="{url page="about" op="submissions"}">
					<i class="bi bi-display" aria-hidden="true"></i>
					{translate key="plugins.themes.academic.sidebar.peerReviewProcess"}
				</a>
			</li>
			<li>
				<a href="{url page="about"}">
					<i class="bi bi-unlock" aria-hidden="true"></i>
					{translate key="plugins.themes.academic.sidebar.openAccessStatement"}
				</a>
			</li>
			<li>
				<a href="{url page="about"}">
					<i class="bi bi-c-circle" aria-hidden="true"></i>
					{translate key="plugins.themes.academic.sidebar.copyrightLicense"}
				</a>
			</li>
			<li>
				<a href="{url page="about"}">
					<i class="bi bi-files" aria-hidden="true"></i>
					{translate key="plugins.themes.academic.sidebar.plagiarism"}
				</a>
			</li>
			<li>
				<a href="{url page="about"}">
					<i class="bi bi-bar-chart" aria-hidden="true"></i>
					{translate key="plugins.themes.academic.sidebar.indexing"}
				</a>
			</li>
			<li>
				<a href="{url page="about" op="submissions"}">
					<i class="bi bi-pencil-square" aria-hidden="true"></i>
					{translate key="plugins.themes.academic.sidebar.authorGuidelines"}
				</a>
			</li>
			<li>
				<a href="{url page="issue" op="archive"}">
					<i class="bi bi-archive" aria-hidden="true"></i>
					{translate key="plugins.themes.academic.sidebar.archivePolicy"}
				</a>
			</li>
			<li>
				<a href="{url page="about" op="submissions"}">
					<i class="bi bi-cash-coin" aria-hidden="true"></i>
					{translate key="plugins.themes.academic.sidebar.authorFees"}
				</a>
			</li>
			<li>
				<a href="{url page="about" op="contact"}">
					<i class="bi bi-telephone" aria-hidden="true"></i>
					{translate key="plugins.themes.academic.sidebar.contactUs"}
				</a>
			</li>
		</ul>
	</div>
</div>
