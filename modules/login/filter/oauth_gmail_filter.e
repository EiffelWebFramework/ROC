note
	description: "Summary description for {OAUTH_GMAIL_FILTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OAUTH_GMAIL_FILTER

inherit
	WSF_URI_TEMPLATE_HANDLER
	CMS_HANDLER
		rename
			make as make_handler
		end

	WSF_FILTER

create
	make

feature {NONE} -- Initialization

	make (a_api: CMS_API; a_user_oauth_api: CMS_USER_OAUTH_API)
		do
			make_handler (a_api)
			user_oauth_api := a_user_oauth_api
		end

	user_oauth_api: CMS_USER_OAUTH_API

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the filter.
		local
			utf: UTF_CONVERTER
		do
			api.logger.put_debug (generator + ".execute ", Void)
			if attached req.raw_header_data as l_raw_data then
			   api.logger.put_debug (generator + ".execute " + utf.escaped_utf_32_string_to_utf_8_string_8 (l_raw_data), Void)
			end
				-- A valid user
			if
				attached {WSF_STRING} req.cookie ("EWF_ROC_OAUTH_GMAIL_SESSION_") as l_roc_auth_session_token
			then
				if attached {CMS_USER} user_oauth_api.user_by_oauth2_gmail_token (l_roc_auth_session_token.value) as l_user then
					set_current_user (req, l_user)
					execute_next (req, res)
				else
					api.logger.put_error (generator + ".execute login_valid failed for: " + l_roc_auth_session_token.value , Void)
					execute_next (req, res)
				end
			else
				api.logger.put_debug (generator + ".execute without authentication", Void)
				execute_next (req, res)
			end
		end

end
