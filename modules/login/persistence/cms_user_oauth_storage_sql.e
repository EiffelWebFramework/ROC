note
	description: "Summary description for {CMS_USER_OAUTH_STORAGE_SQL}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_USER_OAUTH_STORAGE_SQL

inherit
	CMS_USER_OAUTH_STORAGE_I

	CMS_PROXY_STORAGE_SQL

	CMS_USER_OAUTH_STORAGE_I

	CMS_STORAGE_SQL_I

	REFACTORING_HELPER

create
	make

feature -- Access User Outh Gmail

	user_oauth2_gmail_by_id (a_uid: like {CMS_USER}.id): detachable CMS_USER
			-- <Precursor>
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".user_oauth2_gmail_by_id")
			create l_parameters.make (1)
			l_parameters.put (a_uid, "uid")
			sql_query (select_user_oauth2_gmail_by_id, l_parameters)
			if sql_rows_count = 1 then
				Result := fetch_user
			else
				check no_more_than_one: sql_rows_count = 0 end
			end
		end

	user_by_oauth2_gmail_token (a_token: READABLE_STRING_32): detachable CMS_USER
			-- <Precursor>
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".user_by_oauth2_gmail_token")
			create l_parameters.make (1)
			l_parameters.put (a_token, "token")
			sql_query (select_user_by_oauth2_gmail_token, l_parameters)
			if sql_rows_count = 1 then
				Result := fetch_user
			else
				check no_more_than_one: sql_rows_count = 0 end
			end
		end

feature -- Change: User Oauth2 Gmail

	new_user_oauth2_gmail (a_token: READABLE_STRING_32; a_user_profile: READABLE_STRING_32; a_user: CMS_USER)
			-- <Precursor>.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			sql_begin_transaction

			write_information_log (generator + ".new_user_oauth2_gmail")
			create l_parameters.make (4)
			l_parameters.put (a_user.id, "uid")
			l_parameters.put (a_token, "token")
			l_parameters.put (a_user_profile, "profile")
			l_parameters.put (create {DATE_TIME}.make_now_utc, "utc_date")

			sql_change (sql_insert_oauth2_gmail, l_parameters)
			sql_commit_transaction
		end


	update_user_oauth2_gmail (a_token: READABLE_STRING_32; a_user_profile: READABLE_STRING_32; a_user: CMS_USER)
			-- <Precursor>
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			sql_begin_transaction

			write_information_log (generator + ".new_user_oauth2_gmail")
			create l_parameters.make (4)
			l_parameters.put (a_user.id, "uid")
			l_parameters.put (a_token, "token")
			l_parameters.put (a_user_profile, "profile")

			sql_change (sql_update_oauth2_gmail, l_parameters)
			sql_commit_transaction
		end

feature {NONE} -- Implementation: User

	fetch_user: detachable CMS_USER
		local
			l_id: INTEGER_64
			l_name: detachable READABLE_STRING_32
		do
			if attached sql_read_integer_32 (1) as i then
				l_id := i
			end
			if attached sql_read_string_32 (2) as s and then not s.is_whitespace then
				l_name := s
			end

			if l_name /= Void then
				create Result.make (l_name)
				if l_id > 0 then
					Result.set_id (l_id)
				end
			elseif l_id > 0 then
				create Result.make_with_id (l_id)
			end

			if Result /= Void then
				if attached sql_read_string (3) as l_password then
						-- FIXME: should we return the password here ???
					Result.set_hashed_password (l_password)
				end
				if attached sql_read_string (5) as l_email then
					Result.set_email (l_email)
				end
				if attached sql_read_integer_32 (6) as l_status then
					Result.set_status (l_status)
				end
			else
				check expected_valid_user: False end
			end
		end

feature {NONE}-- User Oauth2 Gmail.

	Sql_insert_oauth2_gmail: STRING = "INSERT INTO oauth2_gmail (uid, access_token, details, created) VALUES (:uid, :token, :profile, :utc_date);"

	Sql_update_oauth2_gmail: STRING = "UPDATE oauth2_gmail SET access_token = :token, details = :profile WHERE uid =:uid;"

	Select_user_by_oauth2_gmail_token: STRING = "SELECT u.* FROM users as u JOIN oauth2_gmail as og ON og.uid = u.uid and og.access_token = :token;"

	Select_user_oauth2_gmail_by_id: STRING = "SELECT u.* FROM users as u JOIN oauth2_gmail as og ON og.uid = u.uid and og.uid = :uid;"


end
