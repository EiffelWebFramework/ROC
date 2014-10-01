<!DOCTYPE html>
<html lang="en">
<head>
	{include file="master2/head.tpl"/}
</head>
<body>
	
		<!-- Site Navigation -->
	{include file="master2/site_navigation.tpl"/}	
	
	<!--<header class="main-navi">
		{include file="master2/header.tpl"/}	
	</header> -->

	<div class="container">
		<hr>
		<div class="row">
			<main class="main">
				{include file="master2/content.tpl"/}		
			</main>
		</div>
	</div>

	<div id="footer">
		<footer class="site-footer">
			{include file="master2/footer.tpl"/}			
		</footer>
	</div>

	{if condition="$web"}	
		{include file="master2/optional_enhancement_js.tpl"/}
	{/if}

	{if condition="$html"}	
		{include file="master2/optional_enhancement_js.tpl"/}
	{/if}
	
</body>

</html>