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


<div class="bs-docs-example">
    {if condition="$web"}
      <ul id="myTab" class="nav nav-tabs" role="tablist">
        <li class=""><a href="#view" role="tab" data-toggle="tab">View</a></li>
        <li class="active"><a href="#edit" role="tab" data-toggle="tab">Edit</a></li>
        <li class=""><a href="#delete" role="tab" data-toggle="tab">Delete</a></li>
      </ul>
     {/if}
     {if condition="$html"}
      <ul id="myTab" class="nav nav-tabs" role="tablist">
        <li class=""><a href="#view" role="tab" data-toggle="tab">View</a></li>
        <li class="active"><a href="#edit" role="tab" data-toggle="tab">Edit</a></li>
        <li class=""><a href="#delete" role="tab" data-toggle="tab">Delete</a></li>
      </ul>
     {/if}  
    <div id="myTabContent" class="tab-content">
      <div class="tab-pane" id="view">
          {if isset="$node"}
          <hr>
          <div class="container-fluid">
            <div class="row" itemscope itemtype="http://schema.org/Article">
              <div class="row"> 
                <div class="col-sm-6 col-md-4 col-lg-3"><h1><span itemprop="name">{$node.title/}</span></h1></div>
              </div>  
              <div class="row">
                <div class="col-sm-6 col-md-4 col-lg-3"><span itemprop="text">{$node.content/}<span></div> 
              </div>
            </div>
          </div>  
          {/if}
      </div>
      
      <div class="tab-pane fade active in" id="edit">
          {if isset="$user"}
          <hr>
          <div class="container-fluid">
            <div class="col-xs-12" itemscope itemtype="http://schema.org/Article">
            {if isset="$node"}
              <form class="form-inline well" action="{$host/}/node/{$node.id/}" itemprop="url" method="POST">
              <input type="hidden" name="method" value="PUT"> 
            {/if}
            {unless isset="$node"}
              <form class="form-inline well" action="{$host/}/node" itemprop="url" method="POST">
            {/unless/}
                  <fieldset>
                    <legend>Edit Node</legend>
                    <div class="span3">
                      <p>Add or Edit a Node</p>
                    </div>

                    <div class="row">
                      <div class="col-xs-1">
                        {if isset="$node"}
                          <label><span itemprop="name"><a href="{$host/}/node/{$node.id/}/title" rel="node">Title:</a></span></label>
                        {/if}
                        {unless isset="$node"}    
                          <label><span itemprop="name">Title:</span> </label>
                        {/unless} 
                      </div>
                      <div class="col-xs-7">
                              <input id="title" type="text" class="form-control" name="title" placeholder="Title" required value="{$node.title/}"/>
                        </div>
                    </div>

                    <div class="row">
                      <div class="col-xs-1">
                        {if isset="$node"}
                          <label> <span itemprop="description"><a href="{$host/}/node/{$node.id/}/summary" rel="node">Summary:</a></span></label>
                        {/if}
                        {unless isset="$node"}
                          <label> <span itemprop="description">Summary:</span></label>
                        {/unless} 
                      </div>
                      <div class="col-xs-7">
                              <textarea id="summary" rows="3" class="form-control" cols="100" name="summary" placeholder="Node summary" required>{$node.summary/}</textarea>  
                        </div>
                    </div>

                    <div class="row">
                      <div class="col-xs-1">
                        {if isset="$node"}
                          <label> <span itemprop="text"><a href="{$host/}/node/{$node.id/}/content" rel="node">Content</a></span>   </label>
                        {/if}
                        {unless isset="$node"}
                          <label> <span itemprop="text">Content:</span>   </label>
                        {/unless} 
                      </div>
                      <div class="col-xs-7">
                              <textarea id="content" rows="25" cols="100" class="form-control" name="content" placeholder="Node content" required>{$node.content/}</textarea>     
                        </div>
                    </div>

                     <div>
                        <label>
                            <span>&nbsp;</span> 
                            <input type="Submit" value="Send" /> 
                        </label>
                    </div>    
                  </fieldset>
              </form>
          </div>    
          {/if}                  
      </div>  
    </div>    
      <div class="tab-pane" id="delete">
          {if isset="$user"}
          <hr>
          <div class="container-fluid">
      
          {if isset="$node"}
            <form action="{$host/}/node/{$node.id/}" method="POST" class="">
              <input type="hidden" name="method" value="DELETE">
              <fieldset>
                <legend>Delete Node</legend>

                <div>
                      <label>
                          <span>&nbsp;</span> 
                          <input type="Submit" value="Delete" /> 
                      </label>
                </div>
              </fieldset>     
            </form> 
            {/if}
          </div>
         {/if}   
      </div>   
    </div>
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