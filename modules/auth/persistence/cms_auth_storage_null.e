note
	description: "Summary description for {CMS_AUTH_STORAGE_NULL}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_AUTH_STORAGE_NULL

inherit

	CMS_AUTH_STORAGE_I


feature -- Error handler

	error_handler: ERROR_HANDLER
			-- Error handler.
		do
			create Result.make
		end

feature -- Access: Users

	user_temp_by_id (a_uid: like {CMS_USER}.id; a_consumer_table: READABLE_STRING_GENERAL): detachable CMS_USER
			-- <Precursor>
		do
		end

	user_by_name (a_name: like {CMS_USER}.name): detachable CMS_USER
			-- <Precursor>
		do
		end

	user_by_email (a_email: like {CMS_USER}.email): detachable CMS_USER
			-- <Precursor>
		do
		end

	user_by_activation_token (a_token: READABLE_STRING_32): detachable CMS_USER
			-- <Precursor>
		do
		end

feature -- Temp Users

	remove_activation (a_token: READABLE_STRING_32)
			-- <Precursor>.
		do
		end

	new_temp_user (a_user: CMS_USER)
			-- <Precursor>
		do
		end

	delete_user (a_user: CMS_USER)
			-- <Precursor>
		do
		end


end
