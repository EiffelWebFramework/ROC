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


<div class="container-fluid">
    <div class="col-xs-12" itemscope itemtype="http://schema.org/Person">	
		<form class="form-inline well" action="{$host/}/user" data-rel="user-register" method="POST" >
			<fieldset>
				<legend>Register</legend>
				<div class="span3">
                    <p>Register new user</p>
                </div>

				<div class="row">
                     <div class="col-xs-2">
                        <label><span itemprop="name">Username:</span> </label>
                      </div>  
                      <div class="col-xs-7">
					       <input id="username" type="text" name="username" placeholder="Username" required/>
					  </div>
				 </div>
	
				<div class="row" itemscope itemtype="http://schema.org/Text">
                    <div class="col-xs-2">
				       <label><span itemprop="accessCode">Password:</span> </label>
				    </div>  
				    <div class="col-xs-7">
					    <input id="password" type="password" name="password" placeholder="Password" required/>
				    </div>
				</div>

				<div class="row" itemscope itemtype="http://schema.org/Text">
                    <div class="col-xs-2">
                        <label><span itemprop="accessCode">Re-type Password:</span> </label>
				     </div>   
				     <div class="col-xs-7">
					   	<input id="check_password" type="password" name="check_password" placeholder="Password" required/>
					</div>
				</div>

				<div class="row">
                    <div class="col-xs-2">
				       <label><span itemprop="email">Email:</span> </label>
				    </div>   
				    <div class="col-xs-7">
					    <input id="email" type="email" name="email" placeholder="Email" required/>
				    </div>
				s</div>
				
			   <div>
				    <label>
				        <span>&nbsp;</span> 
				        <input type="Submit" value="Send" /> 
				    </label>
				</div>    
			</fieldset>      
		</form>
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