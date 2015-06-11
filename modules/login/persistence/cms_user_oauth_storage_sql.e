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


	user_by_oauth2_global_token (a_token: READABLE_STRING_32 ): detachable CMS_USER
		local
			l_list: LIST[STRING]
		do
			error_handler.reset
			write_information_log (generator + ".user_by_oauth2_global_token")
			l_list := oauth2_consumers
			from
				l_list.start
			until
				l_list.after or attached Result
			loop
				if attached {CMS_USER} user_by_oauth2_token (a_token, "oauth2_"+l_list.item) as l_user then
					Result := l_user
				end
				l_list.forth
			end
		end

	user_oauth2_by_id (a_uid: like {CMS_USER}.id; a_consumer_table: READABLE_STRING_32): detachable CMS_USER
			-- <Precursor>
		local
			l_parameters: STRING_TABLE [detachable ANY]
			l_string: STRING
		do
			error_handler.reset
			write_information_log (generator + ".user_oauth2_by_id")
			create l_parameters.make (1)
			l_parameters.put (a_uid, "uid")
			create l_string.make_from_string (select_user_oauth2_template_by_id)
			l_string.replace_substring_all ("$table_name", a_consumer_table)
			sql_query (l_string, l_parameters)
			if sql_rows_count = 1 then
				Result := fetch_user
			else
				check no_more_than_one: sql_rows_count = 0 end
			end
		end

	user_by_oauth2_token (a_token: READABLE_STRING_32; a_consumer_table: READABLE_STRING_32): detachable CMS_USER
			-- <Precursor>
		local
			l_parameters: STRING_TABLE [detachable ANY]
			l_string: STRING
		do
			error_handler.reset
			write_information_log (generator + ".user_by_oauth2_token")
			create l_parameters.make (1)
			l_parameters.put (a_token, "token")
			create l_string.make_from_string (select_user_by_oauth2_template_token)
			l_string.replace_substring_all ("$table_name", a_consumer_table)
			sql_query (l_string, l_parameters)
			if sql_rows_count = 1 then
				Result := fetch_user
			else
				check no_more_than_one: sql_rows_count = 0 end
			end
		end

	oauth2_consumers: LIST[STRING]
			-- Return a list of consumers, or empty
		do
			error_handler.reset
			create {ARRAYED_LIST[STRING]}Result.make (0)
			write_information_log (generator + ".user_by_oauth2_token")
			sql_query (Sql_oauth_consumers, Void)
			if not has_error then
				from
					sql_start
				until
					sql_after
				loop
					if attached sql_read_string (1) as l_name then
						Result.force (l_name)
					end
					sql_forth
				end
			end
		end

feature -- Change: User Oauth2 Gmail

	new_user_oauth2 (a_token: READABLE_STRING_32; a_user_profile: READABLE_STRING_32; a_user: CMS_USER; a_consumer_table: READABLE_STRING_32)
			-- Add a new user with oauth2  authentication.
		-- <Precursor>.
		local
			l_parameters: STRING_TABLE [detachable ANY]
			l_string: STRING
		do
			error_handler.reset
			sql_begin_transaction

			write_information_log (generator + ".new_user_oauth2")
			create l_parameters.make (4)
			l_parameters.put (a_user.id, "uid")
			l_parameters.put (a_token, "token")
			l_parameters.put (a_user_profile, "profile")
			l_parameters.put (create {DATE_TIME}.make_now_utc, "utc_date")

			create l_string.make_from_string (sql_insert_oauth2_template)
			l_string.replace_substring_all ("$table_name", a_consumer_table)
			sql_change (l_string, l_parameters)
			sql_commit_transaction
		end

	update_user_oauth2 (a_token: READABLE_STRING_32; a_user_profile: READABLE_STRING_32; a_user: CMS_USER; a_consumer_table: READABLE_STRING_32 )
			-- Update user `a_user' with oauth2 authentication.
			-- <Precursor>
		local
			l_parameters: STRING_TABLE [detachable ANY]
			l_string: STRING
		do
			error_handler.reset
			sql_begin_transaction

			write_information_log (generator + ".new_user_oauth2")
			create l_parameters.make (4)
			l_parameters.put (a_user.id, "uid")
			l_parameters.put (a_token, "token")
			l_parameters.put (a_user_profile, "profile")

			create l_string.make_from_string (sql_update_oauth2_template)
			l_string.replace_substring_all ("$table_name", a_consumer_table)
			sql_change (l_string, l_parameters)
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

feature -- {NONE} User OAuth2

	Select_user_by_oauth2_template_token: STRING = "SELECT u.* FROM users as u JOIN $table_name as og ON og.uid = u.uid and og.access_token = :token;"

	Select_user_oauth2_template_by_id: STRING = "SELECT u.* FROM users as u JOIN $table_name as og ON og.uid = u.uid and og.uid = :uid;"


	Sql_insert_oauth2_template: STRING = "INSERT INTO $table_name (uid, access_token, details, created) VALUES (:uid, :token, :profile, :utc_date);"

	Sql_update_oauth2_template: STRING = "UPDATE $table_name SET access_token = :token, details = :profile WHERE uid =:uid;"

	Sql_oauth_consumers: STRING = "SELECT name FROM oauth2_consumers";

end
