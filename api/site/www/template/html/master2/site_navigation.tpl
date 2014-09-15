<nav id="" class="navbar navbar-default navbar-inverse navbar-fixed-top" role="navigation">
	  <div class="container">
	  	<div class="navbar-header">
	  	      <a class="navbar-brand" href="{$host/}" rel="home">Rest on CMS</a>
	  	</div>	

		 <div class="collapse navbar-collapse" id="navbarCollapse">
	         <ul class="nav navbar-nav">
	        	<li class="ListOfNodes"><a title="Nodes" href="{$host/}/nodes" rel="node">List of Nodes</a></li>
		        
	      		{if isset="$user"}
		      		<li><a title="Node" href="{$host/}/node" rel="node">New Node</a></li>
					<li><a title="Logoff" href="{$host/}/logoff" rel="logoff">Logoff</a></li>
				{/if}	
				{unless isset="$user"}
					<li><a title="Login" href="{$host/}/login" rel="login">Login</a></li>
					<li><a title="Register" href="{$host/}/user" rel="register">Register</a></li>
				{/unless}
	      	</ul>
	     </div>
	  </div>   
</nav>


   