 	<div>
 		{unless isset="$user"}
			<h3>Login or <a href="/account/roc-register">Register</a></h3>
		<div>
			<div>	
			    <form action method="POST">
					<div>
						<input type="text" name="username" required>
						<label>Username</label>
					</div>
										
					<div>
						<input  type="password" name="password" required>
						<label>Password</label>
					</div>
        
					<button type="button" onclick="ROC_AUTH.login();">Login</button>
				</form>
			</div>
    	</div>
		<div>
			<div>
				<p>
					<a href="/account/new-password">Forgot password?</a>
				</p>
			</div>
		</div>	
		<div>
				<a href="/account/login-with-google"><img src="http://qpleple.com/img/post-how-to-make-people-login-into-your-website-with-their-google-account/signin-google-3.png"></a>
		</div>    	
		{/unless}
	</div>