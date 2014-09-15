<h3> Error: {$code/} </h3>

{assign name="status400" value="400"/}
{assign name="status404" value="404"/}
{assign name="status500" value="500"/}

{if condition="$code ~ $status500"}
	<p>Internal server error,  for the request <strong>{$request/}</string>  </p>
{/if}


{if condition="$code ~ $status404"}
	<p>  Resourse not found,  for the request <strong>{$request/}</string>  </p>
{/if}

{if condition="$code ~ $status400"}
	<p> Bad request, the request <strong>{$request/}</string> is not valid</p>
{/if}	