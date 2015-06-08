note
	description: "OAuth workflow for Gmails."
	date: "$Date$"
	revision: "$Revision$"

class
	OAUTH_LOGIN_GMAIL

inherit

	SHARED_LOGGER

create
	make

feature {NONE} -- Initialization

	make (a_cms_api:CMS_API a_host: READABLE_STRING_32)
			-- Create an object with the host `a_host'.
		do
			cms_api := a_cms_api
			initilize
			create config.make_default (api_key, api_secret)
			config.set_callback (a_host + "/oauthgmail")
			config.set_scope (scope)
			create goauth
			api_service := goauth.create_service (config)
		ensure
			cms_api_set: cms_api = a_cms_api
		end

	initilize
		local
			utf: UTF_CONVERTER
		do
				--Use configuration values if any if not defaul
			api_key := "KEY"
			api_secret := "SECRET"
			scope := "email"

			api_revoke := "[https://accounts.google.com/o/oauth2/revoke?token=$ACCESS_TOKEN]"
			protected_resource_url := "https://www.googleapis.com/plus/v1/people/me"


			if attached {CONFIG_READER} cms_api.module_configuration ("login", "oauth2_gmail") as cfg then
				if attached cfg.text_item ("api_secret") as l_api_secret then
					api_secret := utf.utf_32_string_to_utf_8_string_8 (l_api_secret)
				end
				if attached cfg.text_item ("api_key") as l_api_key then
					api_key := utf.utf_32_string_to_utf_8_string_8 (l_api_key)
				end
				if attached cfg.text_item ("scope") as l_scope then
					scope := utf.utf_32_string_to_utf_8_string_8 (l_scope)
				end
				if attached cfg.text_item ("api_revoke") as l_api_revoke then
					api_revoke := utf.utf_32_string_to_utf_8_string_8 (l_api_revoke)
				end
				if attached cfg.text_item ("protected_resource_url") as l_resource_url then
					protected_resource_url := utf.utf_32_string_to_utf_8_string_8 (l_resource_url)
				end
			end

		end

feature -- Access

	authorization_url: detachable READABLE_STRING_32
			-- Obtain the Authorization URL.
		do
				-- Obtain the Authorization URL
			write_debug_log (generator + ".authorization_url Fetching the Authorization URL..!")
			if attached api_service.authorization_url (empty_token) as l_authorization_url then
				write_debug_log (generator + ".authorization_url: Got the Authorization URL!")
				write_debug_log (generator + ".authorization_url:" + l_authorization_url)
				Result := l_authorization_url.as_string_32
			end
		end

	sign_request (a_code: READABLE_STRING_32)
			-- Sign request with code `a_code'.
			--! To get the code `a_code' you need to do a request
			--! using the authorization_url
		local
			request: OAUTH_REQUEST
		do
				-- Get the access token.
			write_debug_log (generator + ".sign_request Fetching the access token with code [" + a_code + "]")
			access_token := api_service.access_token_post (empty_token, create {OAUTH_VERIFIER}.make (a_code))
			if attached access_token as l_access_token then
				write_debug_log (generator + ".sign_request Got the Access Token [" + l_access_token.debug_output + "]")
					-- Get the user email
					--! at the moment the scope is mail, but we can change it to get more information.
				create request.make ("GET", protected_resource_url)
				request.add_header ("Authorization", "Bearer " + l_access_token.token)
				api_service.sign_request (l_access_token, request)
				if attached {OAUTH_RESPONSE} request.execute as l_response then
						write_debug_log (generator + ".sign_request Sign_request response [" + l_response.status.out + "]")
					if attached l_response.body as l_body then
						user_profile := l_body
						write_debug_log (generator + ".sign_request User profile [" + l_body + "]")
					end
				end
			end
		end

	sign_out (a_code: READABLE_STRING_32)
			-- Invalidate the current OAuth access token `a_code'.
		local
			l_revoke: STRING
			request: OAUTH_REQUEST
		do
			create l_revoke.make_from_string (api_revoke)
			l_revoke.replace_substring_all ("$ACCESS_TOKEN", a_code)
			create request.make ("POST", l_revoke)
			if attached {OAUTH_RESPONSE} request.execute as l_response then
					-- do nothing
				write_debug_log (generator + ".sign_out response [" + l_response.status.out + "]")
				check invalidate_ok: l_response.status = {HTTP_CONSTANTS}.ok end
			end
		end

	user_email: detachable READABLE_STRING_32
			-- Retrieve user email if any.
		local
			l_json: JSON_CONFIG
		do
			if attached user_profile as l_profile then
				create l_json.make_from_string (l_profile)
				if
					attached {JSON_ARRAY} l_json.item ("emails") as l_array and then
					attached {JSON_OBJECT} l_array.i_th (1) as l_object and then
					attached {JSON_STRING} l_object.item ("value") as l_email
				then
					Result := l_email.item
				end
			end
		end

feature -- Access

	access_token: detachable OAUTH_TOKEN
			-- JSON representing the access token.

	user_profile: detachable READABLE_STRING_32
			-- JSON representing the user profiles.

feature {NONE} -- Implementation

	goauth: OAUTH_20_GOOGLE_API
		-- OAuth 2.0 Google API.

	config: OAUTH_CONFIG
		-- configuration.

	api_service: OAUTH_SERVICE_I
		-- Service.

	api_key: STRING
		-- public key.

	api_secret: STRING
		-- secret key.

	scope: STRING
		-- api scope to access protected resources.

	api_revoke: STRING
		-- Revoke url

	protected_resource_url: STRING
		-- Resource url.

	empty_token: detachable OAUTH_TOKEN
		-- fake token.

	cms_api: CMS_API
		-- CMS API.

end
