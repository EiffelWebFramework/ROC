note
	description: "Summary description for {CMS_USER_OAUTH_STORAGE_NULL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_USER_OAUTH_STORAGE_NULL

inherit

	CMS_USER_OAUTH_STORAGE_I


feature -- Error handler

	error_handler: ERROR_HANDLER
			-- Error handler.
		do
			create Result.make
		end

feature -- Access

	user_oauth2_gmail_by_id (a_uid: like {CMS_USER}.id): detachable CMS_USER
			-- CMS User with Oauth gmail credential by id if any.
		do
		end

	user_by_oauth2_gmail_token (a_token: READABLE_STRING_32): detachable CMS_USER
			-- -- CMS User with Oauth gmail credential by access token `a_token' if any.
		do
		end

feature -- Change: User Oauth2

	new_user_oauth2_gmail (a_token: READABLE_STRING_32; a_user_profile: READABLE_STRING_32; a_user: CMS_USER)
			-- Add a new user with oauth2 gmail authentication.
		do
		end

	update_user_oauth2_gmail (a_token: READABLE_STRING_32; a_user_profile: READABLE_STRING_32; a_user: CMS_USER)
			-- Update user `a_user' with oauth2 gmail authentication.
		do
		end


end
