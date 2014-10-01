
<div itemscope itemtype="http://schema.org/ItemList">
  <h2 itemprop="name">Top most recent nodes</h2><br>
  <meta itemprop="itemListOrder" content="Descending" />

	{foreach from="$nodes" item="item"}
	<div class="page-header">
	    <h3><span itemprop="itemListElement"><a href="{$host/}/node/{$item.id/}" rel="node"><strong>{$item.title/}</strong></a></span> <small>{$item.summary/} - {$item.publication_date_output/} </small></h3>
	</div>
	{/foreach}
</div>
