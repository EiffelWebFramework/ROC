note
	description: "Generic OAUTH2 API"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_OAUTH_20_GENERIC_API

inherit

	OAUTH_20_API
		redefine
			access_token_extractor,
			access_token_verb
		end

create
	make

feature {NONE} -- Initialize

	make (a_endpoint: READABLE_STRING_32; a_authorize_url: READABLE_STRING_32; a_extractor: READABLE_STRING_32)
		do
			endpoint := a_endpoint
			authorize_url := a_authorize_url
			extractor := a_extractor
		ensure
			endpoint_set: endpoint = a_endpoint
			authorize_url_set: authorize_url = a_authorize_url
			extractor_set: extractor = a_authorize_url
		end

	endpoint: READABLE_STRING_32
			-- 	Url that receives the access token request.

	authorize_url: READABLE_STRING_32
			--

	extractor: READABLE_STRING_32
			-- text, json		

feature -- Access

	access_token_extractor: ACCESS_TOKEN_EXTRACTOR
			-- Return token extractor, by default TOKEN_EXTRACTOR_20.
		do
			if extractor.is_case_insensitive_equal_general ("json") then
				create {JSON_TOKEN_EXTRACTOR} Result
			else
				create {TOKEN_EXTRACTOR_20} Result
			end
		end

	access_token_verb: STRING_32
		do
			Result := "POST"
		end

	access_token_endpoint: STRING_32
			-- Url that receives the access token request
		do
			create {STRING_32} Result.make_from_string (endpoint)
		end

	authorization_url (config: OAUTH_CONFIG): detachable STRING_32
			-- Url where you should redirect your users to authneticate
		local
			l_result: STRING_32
		do
			if attached config.scope as l_scope then
				create {STRING_32} l_result.make_from_string (authorize_url + SCOPED_AUTHORIZE_URL)
				l_result.replace_substring_all ("$CLIENT_ID", config.api_key.as_string_8)
				if attached config.callback as l_callback then
					l_result.replace_substring_all ("$REDIRECT_URI", (create {OAUTH_ENCODER}).encoded_string (l_callback.as_string_32))
				end
				if attached config.callback as l_callback then
					l_result.replace_substring_all ("$SCOPE", (create {OAUTH_ENCODER}).encoded_string (l_scope.as_string_32))
					Result := l_result
				end
			else
				create {STRING_32} l_result.make_from_string (authorize_url + SCOPED_AUTHORIZE_URL)
				l_result.replace_substring_all ("$CLIENT_ID", config.api_key.as_string_8)
				if attached config.callback as l_callback then
					l_result.replace_substring_all ("$REDIRECT_URI", (create {OAUTH_ENCODER}).encoded_string (l_callback.as_string_32))
				end
			end
		end

feature -- Implementation

	Scoped_authorize_url: STRING = "&scope=$SCOPE";


end
