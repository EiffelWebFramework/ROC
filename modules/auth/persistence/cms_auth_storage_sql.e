note
	description: "Summary description for {CMS_AUTH_STORAGE_SQL}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_AUTH_STORAGE_SQL

inherit
	CMS_AUTH_STORAGE_I

	CMS_PROXY_STORAGE_SQL

	CMS_STORAGE_SQL_I

	REFACTORING_HELPER

create
	make

feature -- Access User Outh


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


feature {NONE} -- Implementation: User

	fetch_user: detachable CMS_USER
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
						-- FIXME: should we return the password here ???
					Result.set_hashed_password (l_password)
				end
				if attached sql_read_string (4) as l_salt then
					Result.set_email (l_salt)
				end
				if attached sql_read_string (5) as l_email then
					Result.set_email (l_email)
				end
				if attached sql_read_string (6) as l_application then
					Result.set_application (l_application)
				end
			else
				check expected_valid_user: False end
			end
		end


feature -- New Temp User	

	new_temp_user (a_user: CMS_USER)
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
				attached a_user.application as l_application
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
				l_parameters.put (l_application, "application")

				sql_begin_transaction
				sql_insert (sql_insert_user, l_parameters)
				if not error_handler.has_error then
					a_user.set_id (last_inserted_user_id)
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
			sql_modify (sql_delete_user, l_parameters)
			sql_commit_transaction
			sql_finalize
		end
feature  {NONE} -- Implementation

	last_inserted_user_id: INTEGER_64
			-- Last insert user id.
		do
			error_handler.reset
			write_information_log (generator + ".last_inserted_user_id")
			sql_query (Sql_last_insert_user_id, Void)
			if not sql_after then
				Result := sql_read_integer_64 (1)
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

feature {NONE} -- SQL select

	Sql_last_insert_user_id: STRING = "SELECT MAX(uid) FROM auth_temp_user;"

	Select_user_auth_temp_by_id: STRING = "SELECT uid, name, password, salt, email, application FROM auth_temp_user as u where uid=:uid;"


	sql_insert_user: STRING = "INSERT INTO auth_temp_user (name, password, salt, email, application) VALUES (:name, :password, :salt, :email, :application);"
			-- SQL Insert to add a new user.

	Select_user_by_name: STRING = "SELECT uid, name, password, salt, email, application FROM auth_temp_user WHERE name =:name;"
			-- Retrieve user by name if exists.

	Select_user_by_email: STRING = "SELECT uid, name, password, salt, email, application FROM auth_temp_user WHERE email =:email;"
			-- Retrieve user by email if exists.

	Select_user_by_activation_token: STRING = "SELECT u.uid, u.name, u.password, u.salt, u.email, u.application FROM auth_temp_user as u JOIN users_activations as ua ON ua.uid = u.uid and ua.token = :token;"
			-- Retrieve user by activation token if exist.

	Sql_remove_activation: STRING = "DELETE FROM users_activations WHERE token = :token;"
			-- Remove activation token.		

	Sql_delete_user: STRING = "DELETE FROM auth_temp_user WHERE uid=:uid;"
end
