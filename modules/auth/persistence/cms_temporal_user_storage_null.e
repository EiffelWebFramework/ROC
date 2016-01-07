note
	description: "Summary description for {CMS_TEMPORAL_USER_STORAGE_NULL}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_TEMPORAL_USER_STORAGE_NULL

inherit

	CMS_TEMPORAL_USER_STORAGE_I


feature -- Error handler

	error_handler: ERROR_HANDLER
			-- Error handler.
		do
			create Result.make
		end

feature -- Access: Users

	users_count: INTEGER
			-- <Precursor>
		do
		end

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

	recent_users (a_lower: INTEGER; a_count: INTEGER): LIST [CMS_TEMPORAL_USER]
			-- List of recent `a_count' temporal users with an offset of `lower'.
		do
			create {ARRAYED_LIST[CMS_TEMPORAL_USER]} Result.make (0)
		end

	token_by_user_id (a_id: like {CMS_USER}.id): detachable STRING
			-- <Precursor>
		do
		end

feature -- Temp Users

	new_user_from_temporal_user (a_user: CMS_TEMPORAL_USER)
			-- <Precursor>
		do
  		end


	remove_activation (a_token: READABLE_STRING_32)
			-- <Precursor>.
		do
		end

	new_temp_user (a_user: CMS_TEMPORAL_USER)
			-- <Precursor>
		do
		end

	delete_user (a_user: CMS_USER)
			-- <Precursor>
		do
		end


end
