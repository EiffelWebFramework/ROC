note
	description: "Summary description for {CMS_TEMPORAL_USER_STORAGE_SQL}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_TEMPORAL_USER_STORAGE_SQL

inherit
	CMS_TEMPORAL_USER_STORAGE_I

	CMS_PROXY_STORAGE_SQL

	CMS_STORAGE_SQL_I

	REFACTORING_HELPER

create
	make

feature -- Access User

	users_count: INTEGER
			-- Number of items users.
		do
			error_handler.reset
			write_information_log (generator + ".user_count")

			sql_query (select_temporal_users_count, Void)
			if not has_error and then not sql_after then
				Result := sql_read_integer_64 (1).to_integer_32
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end


	user_temp_by_id (a_uid: like {CMS_USER}.id; a_consumer: READABLE_STRING_GENERAL): detachable CMS_USER
			-- <Precursor>
		local
			l_parameters: STRING_TABLE [detachable ANY]
			l_string: STRING
		do
			error_handler.reset
			write_information_log (generator + ".user_temp_by_id")
			create l_parameters.make (1)
			l_parameters.put (a_uid, "uid")
			create l_string.make_from_string (select_user_auth_temp_by_id)
			sql_query (l_string, l_parameters)
			if not has_error and not sql_after then
				Result := fetch_user
				sql_forth
				if not sql_after then
					check no_more_than_one: False end
					Result := Void
				end
			end
			sql_finalize
		end

	user_by_name (a_name: like {CMS_USER}.name): detachable CMS_USER
			-- User for the given name `a_name', if any.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".user_by_name")
			create l_parameters.make (1)
			l_parameters.put (a_name, "name")
			sql_query (select_user_by_name, l_parameters)
			if not sql_after then
				Result := fetch_user
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

	user_by_email (a_email: like {CMS_USER}.email): detachable CMS_USER
			-- User for the given email `a_email', if any.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".user_by_email")
			create l_parameters.make (1)
			l_parameters.put (a_email, "email")
			sql_query (select_user_by_email, l_parameters)
			if not sql_after then
				Result := fetch_user
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

	user_by_activation_token (a_token: READABLE_STRING_32): detachable CMS_USER
			-- User for the given activation token `a_token', if any.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".user_by_activation_token")
			create l_parameters.make (1)
			l_parameters.put (a_token, "token")
			sql_query (select_user_by_activation_token, l_parameters)
			if not sql_after then
				Result := fetch_user
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

	recent_users (a_lower: INTEGER; a_count: INTEGER): LIST [CMS_TEMPORAL_USER]
			-- <Precursor>
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			create {ARRAYED_LIST [CMS_TEMPORAL_USER]} Result.make (0)

			error_handler.reset
			write_information_log (generator + ".recent_users")

			from
				create l_parameters.make (2)
				l_parameters.put (a_count, "rows")
				l_parameters.put (a_lower, "offset")
				sql_query (sql_select_recent_users, l_parameters)
				sql_start
			until
				sql_after
			loop
				if attached fetch_user as l_user then
					Result.force (l_user)
				end
				sql_forth
			end
			sql_finalize
		end

	token_by_user_id (a_id: like {CMS_USER}.id): detachable STRING
			-- Number of items users.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".token_by_user_id")
			create l_parameters.make (1)
			l_parameters.put (a_id, "uid")


			sql_query (select_token_activation_by_user_id, l_parameters)
			if not has_error and then not sql_after then
				Result := sql_read_string (1)
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

feature {NONE} -- Implementation: User

	fetch_user: detachable CMS_TEMPORAL_USER
		local
			l_id: INTEGER_64
			l_name: detachable READABLE_STRING_32
		do
			if attached sql_read_integer_64 (1) as i then
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
					Result.set_hashed_password (l_password)
				end
				if attached sql_read_string (4) as l_salt then
					Result.set_salt (l_salt)
				end
				if attached sql_read_string (5) as l_email then
					Result.set_email (l_email)
				end
				if attached sql_read_string (6) as l_application then
					Result.set_personal_information (l_application)
				end
			else
				check expected_valid_user: False end
			end
		end


feature -- New Temp User

	new_user_from_temporal_user (a_user: CMS_TEMPORAL_USER)
			-- <Precursor>
  		local
  			l_parameters: STRING_TABLE [detachable ANY]
  		do
  			error_handler.reset
  			if
  				attached a_user.hashed_password as l_password_hash and then
  				attached a_user.email as l_email and then
  				attached a_user.salt as l_password_salt
  			then
  				sql_begin_transaction

  				write_information_log (generator  + ".new_user")
  				create l_parameters.make (4)
  				l_parameters.put (a_user.name, "name")
  				l_parameters.put (l_password_hash, "password")
  				l_parameters.put (l_password_salt, "salt")
  				l_parameters.put (l_email, "email")
  				l_parameters.put (create {DATE_TIME}.make_now_utc, "created")
  				l_parameters.put (a_user.status, "status")

  				sql_insert (sql_insert_user, l_parameters)
  				if not error_handler.has_error then
  					a_user.set_id (last_inserted_user_id)
  				end
  				if not error_handler.has_error then
  					sql_commit_transaction
  				else
  					sql_rollback_transaction
  				end
  				sql_finalize
  			else
  				-- set error
  				error_handler.add_custom_error (-1, "bad request" , "Missing password or email")
  			end
  		end

	new_temp_user (a_user: CMS_TEMPORAL_USER)
			-- Add a new temp_user `a_user'.
		local
			l_parameters: STRING_TABLE [detachable ANY]
			l_password_salt, l_password_hash: STRING
			l_security: SECURITY_PROVIDER
		do
			error_handler.reset
			if
				attached a_user.password as l_password and then
				attached a_user.email as l_email and then
				attached a_user.personal_information as l_personal_information
			then

				create l_security
				l_password_salt := l_security.salt
				l_password_hash := l_security.password_hash (l_password, l_password_salt)

				write_information_log (generator + ".new_temp_user")
				create l_parameters.make (4)
				l_parameters.put (a_user.name, "name")
				l_parameters.put (l_password_hash, "password")
				l_parameters.put (l_password_salt, "salt")
				l_parameters.put (l_email, "email")
				l_parameters.put (l_personal_information, "application")

				sql_begin_transaction
				sql_insert (sql_insert_temp_user, l_parameters)
				if not error_handler.has_error then
					a_user.set_id (last_inserted_temp_user_id)
					sql_commit_transaction
				else
					sql_rollback_transaction
				end
				sql_finalize
			else
				-- set error
				error_handler.add_custom_error (-1, "bad request" , "Missing password or email")
			end
		end


feature -- Remove Activation

	remove_activation (a_token: READABLE_STRING_32)
			-- <Precursor>.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			sql_begin_transaction
			write_information_log (generator + ".remove_activation")
			create l_parameters.make (1)
			l_parameters.put (a_token, "token")
			sql_modify (sql_remove_activation, l_parameters)
			sql_commit_transaction
			sql_finalize
		end

	delete_user (a_user: CMS_USER)
			-- Delete user `a_user'.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			sql_begin_transaction
			write_information_log (generator + ".delete_user")
			create l_parameters.make (1)
			l_parameters.put (a_user.id, "uid")
			sql_modify (sql_delete_temp_user, l_parameters)
			sql_commit_transaction
			sql_finalize
		end
feature  {NONE} -- Implementation

	last_inserted_temp_user_id: INTEGER_64
			-- Last insert user id.
		do
			error_handler.reset
			write_information_log (generator + ".last_inserted_temp_user_id")
			sql_query (sql_last_insert_temp_user_id, Void)
			if not sql_after then
				Result := sql_read_integer_64 (1)
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

	last_inserted_user_id: INTEGER_64
			-- Last insert user id.
		do
			error_handler.reset
			write_information_log (generator + ".last_inserted_user_id")
			sql_query (sql_last_insert_user_id, Void)
			if not sql_after then
				Result := sql_read_integer_64 (1)
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

feature {NONE} -- SQL select

	sql_last_insert_temp_user_id: STRING = "SELECT MAX(uid) FROM auth_temp_users;"


	Select_user_auth_temp_by_id: STRING = "SELECT uid, name, password, salt, email, application FROM auth_temp_users as u where uid=:uid;"


	sql_insert_temp_user: STRING = "INSERT INTO auth_temp_users (name, password, salt, email, application) VALUES (:name, :password, :salt, :email, :application);"
			-- SQL Insert to add a new user.

	Select_user_by_name: STRING = "SELECT uid, name, password, salt, email, application FROM auth_temp_users WHERE name =:name;"
			-- Retrieve user by name if exists.

	Select_user_by_email: STRING = "SELECT uid, name, password, salt, email, application FROM auth_temp_users WHERE email =:email;"
			-- Retrieve user by email if exists.

	Select_user_by_activation_token: STRING = "SELECT u.uid, u.name, u.password, u.salt, u.email, u.application FROM auth_temp_users as u JOIN users_activations as ua ON ua.uid = u.uid and ua.token = :token;"
			-- Retrieve user by activation token if exist.

	Sql_remove_activation: STRING = "DELETE FROM users_activations WHERE token = :token;"
			-- Remove activation token.		

	sql_delete_temp_user: STRING = "DELETE FROM auth_temp_users WHERE uid=:uid;"


	Sql_last_insert_user_id: STRING = "SELECT MAX(uid) FROM users;"

	sql_insert_user: STRING = "INSERT INTO users (name, password, salt, email, created, status) VALUES (:name, :password, :salt, :email, :created, :status);"
			-- SQL Insert to add a new user.		


	Select_temporal_users_count: STRING = "SELECT count(*) FROM auth_temp_users;"
			-- Number of temporal users.			

	Sql_select_recent_users: STRING = "SELECT uid, name, password, salt, email, application FROM auth_temp_users ORDER BY uid DESC LIMIT :rows OFFSET :offset ;"
			-- Retrieve recent users

	select_token_activation_by_user_id: STRING = "SELECT token FROM users_activations WHERE uid = :uid;"

end
