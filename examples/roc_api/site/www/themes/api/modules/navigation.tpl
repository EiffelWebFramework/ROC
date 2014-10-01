{if isset="$user"}
	<a title="Logoff" class="" href="{$host/}/logoff">Logoff</a>
{/if}	
{unless isset="$user"}
	<a title="Login" class="" href="{$host/}/login">Login</a>
	<a title="Register" class="" href="{$host/}/Register">Register</a>
{/unless}
<a title="Nodes" class="" href="{$host/}/nodes">List of Nodes</a>	
