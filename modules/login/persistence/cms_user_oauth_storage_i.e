note
	description: "Summary description for {CMS_USER_OAUTH_STORAGE_I}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_USER_OAUTH_STORAGE_I

inherit
	SHARED_LOGGER

feature -- Error Handling

	error_handler: ERROR_HANDLER
			-- Error handler.
		deferred
		end

feature -- Access

	user_oauth2_by_id (a_uid: like {CMS_USER}.id; a_consumer_table: READABLE_STRING_32): detachable CMS_USER
			-- CMS User with Oauth credential by id if any.
		deferred
		end

	user_by_oauth2_token (a_token: READABLE_STRING_32; a_consumer_table: READABLE_STRING_32): detachable CMS_USER
			-- -- CMS User with Oauth credential by access token `a_token' if any.
		deferred
		end

	user_by_oauth2_global_token (a_token: READABLE_STRING_32 ): detachable CMS_USER
			--
		deferred
		end

	oauth2_consumers: LIST [STRING]
		deferred
		end

feature -- Change: User Oauth2

	new_user_oauth2 (a_token: READABLE_STRING_32; a_user_profile: READABLE_STRING_32; a_user: CMS_USER; a_consumer_table: READABLE_STRING_32)
			-- Add a new user with oauth2  authentication.
		deferred
		end

	update_user_oauth2 (a_token: READABLE_STRING_32; a_user_profile: READABLE_STRING_32; a_user: CMS_USER; a_consumer_table: READABLE_STRING_32 )
			-- Update user `a_user' with oauth2 authentication.
		deferred
		end

end
