note
	description: "[
		API to manage CMS User OAuth authentication.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_USER_OAUTH_API

inherit
	CMS_MODULE_API

	REFACTORING_HELPER

create {LOGIN_MODULE}
	make_with_storage

feature {NONE} -- Initialization

	make_with_storage (a_api: CMS_API; a_user_oauth_storage: CMS_USER_OAUTH_STORAGE_I)
		do
			user_oauth_storage := a_user_oauth_storage
			make (a_api)
		end

feature {CMS_MODULE} -- Access user oauth storage.

	user_oauth_storage: CMS_USER_OAUTH_STORAGE_I


feature -- Access: OAuth2 Gmail

	user_oauth2_gmail_by_id	(a_uid: like {CMS_USER}.id): detachable CMS_USER
		do
			Result := user_oauth_storage.user_oauth2_gmail_by_id (a_uid)
		end

	user_by_oauth2_gmail_token (a_token: READABLE_STRING_32): detachable CMS_USER
		do
			Result := user_oauth_storage.user_by_oauth2_gmail_token (a_token)
		end


feature	-- Change: OAuth2 Gmail

	new_user_oauth2_gmail (a_token: READABLE_STRING_32; a_user_profile: READABLE_STRING_32; a_user: CMS_USER)
			-- Add a new user with oauth2 gmail authentication.
		require
			has_id: a_user.has_id
		do
			user_oauth_storage.new_user_oauth2_gmail (a_token, a_user_profile, a_user)
		end


	update_user_oauth2_gmail (a_token: READABLE_STRING_32; a_user_profile: READABLE_STRING_32; a_user: CMS_USER)
			-- Updaate user `a_user' with oauth2 gmail authentication.
		require
			has_id: a_user.has_id
		do
			user_oauth_storage.update_user_oauth2_gmail (a_token, a_user_profile, a_user)
		end

end
