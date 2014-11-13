{if condition="html"}
	<!DOCTYPE html>
	<html lang="en">
	<head>
		{include file="master2/head.tpl"/}
	</head>
	<body>
{/if}
	
{unless condition="$web"}	
		<!-- Site Navigation -->
	{include file="master2/site_navigation.tpl"/}	
{/unless}

{if condition="html"}

<div class="container">
		<hr>
		<div class="row">
			<main class="main">
{/if}
				<div itemscope itemtype="http://schema.org/ItemList">
				  <h2 itemprop="name">List nodes</h2><br>	
				  <meta itemprop="itemListOrder" content="Descending" />

					{foreach from="$nodes" item="item"}
					<div class="page-header">
					    <h3><span itemprop="itemListElement"><a href="{$host/}/node/{$item.id/}" rel="node"><strong>{$item.title/}</strong></a></span> <small>{$item.summary/} -{$item.publication_date_output/} </small></h3>
					</div>
					{/foreach}
				</div>

{if condition="html"}
			</main>
		</div>
	</div>
{/if}


{if condition="html"}
	<div id="footer">
			<footer class="site-footer">
				{include file="master2/footer.tpl"/}			
			</footer>
		</div>


			{include file="master2/optional_enhancement_js.tpl"/}
		
	</body>
	</html>
{/if}