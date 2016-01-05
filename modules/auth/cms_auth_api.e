note
	description: "Summary description for {CMS_AUTH_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_AUTH_API

inherit
	CMS_MODULE_API

	REFACTORING_HELPER

create {CMS_AUTHENTICATION_MODULE}
	make_with_storage

feature {NONE} -- Initialization

	make_with_storage (a_api: CMS_API; a_auth_storage: CMS_AUTH_STORAGE_I)
			-- Create an object with api `a_api' and storage `a_auth_storage'.
		do
			auth_storage := a_auth_storage
			make (a_api)
		ensure
			auht_storage_set:  auth_storage = a_auth_storage
		end

feature -- Access

	user_by_name (a_username: READABLE_STRING_32): detachable CMS_USER
			-- User by name `a_user_name', if any.
		do
			Result := auth_storage.user_by_name (a_username)
		end

	user_by_email (a_email: READABLE_STRING_32): detachable CMS_USER
			-- User by email `a_email', if any.
		do
			Result := auth_storage.user_by_email (a_email)
		end

	user_by_activation_token (a_token: READABLE_STRING_32): detachable CMS_USER
			-- User by activation token `a_token'.
		do
			Result := auth_storage.user_by_activation_token (a_token)
		end


feature -- Temp User

	new_temp_user (a_user: CMS_USER)
			-- Add a new user `a_user'.
		require
			no_id: not a_user.has_id
			no_hashed_password: a_user.hashed_password = Void
		do
			reset_error
			if
				attached a_user.password as l_password and then
				attached a_user.email as l_email
			then
				auth_storage.new_temp_user (a_user)
				error_handler.append (storage.error_handler)
			else
				error_handler.add_custom_error (0, "bad new user request", "Missing password or email to create new user!")
			end
		end

	remove_activation (a_token: READABLE_STRING_32)
			-- Remove activation token `a_token', from the storage.
		do
			auth_storage.remove_activation (a_token)
		end

	delete_user (a_user: CMS_USER)
			-- Delete user `a_user'.
		require
			has_id: a_user.has_id
		do
			reset_error
			auth_storage.delete_user (a_user)
			error_handler.append (storage.error_handler)
		end

feature {CMS_MODULE} -- Access: User auth storage.

	auth_storage: CMS_AUTH_STORAGE_I
			-- storage interface.

feature -- Access: User Temp

end
