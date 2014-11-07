  <div class="navbar navbar-default" role="navigation">
    <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
        <span class="sr-only">Toggle navigation</span>
      </button>
        <!-- {$host/} or {$site_url} -->
      <a class="navbar-brand" href="${host/}" itemprop="home" rel="home">{$site_name/}</a>

    </div>
    
    <div class="navbar-collapse collapse">
     
       {if isset="$primary_nav"}
            {$primary_nav/}
       {/if}

      {if isset="$secondary_nav"}
          {$secondary_nav/}
      {/if}  
    </div>

  </div>
</div>

