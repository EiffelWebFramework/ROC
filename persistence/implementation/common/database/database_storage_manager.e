note
	description: "[
					Manager to initialize data api for database access,
					create database connection and so on
					]"
	date: "$Date: 2013-08-08 16:39:49 -0300 (ju. 08 de ago. de 2013) $"
	revision: "$Revision: 195 $"

class
	DATABASE_STORAGE_MANAGER

inherit
	GLOBAL_SETTINGS

	REFACTORING_HELPER

	SHARED_ERROR_HANDLER

create
	make

feature -- Initialization

	make (a_data_app: like data_app; a_database_name: like database_name; a_name: like name; a_password: like password;
			a_host_name: like host_name; a_role_id: like role_id; a_role_password: like role_password
			a_data_source: like data_source; a_group: like group)
			-- Initialize with login info.
			--
			-- `a_database_name' is used for MySQL
			-- `a_name', the login user name
			-- `a_password', the login user password, unencrypted.
		local
			l_storage: STRING_8
		do
			create l_storage.make (64)
			storage_url := l_storage
			l_storage.append (a_data_app.db_spec.database_handle_name.as_lower)
			l_storage.append ("://")

			data_app := a_data_app
			database_name := a_database_name
			name := a_name
			password := a_password
			host_name := a_host_name
			role_id := a_role_id
			role_password := a_role_password
			data_source := a_data_source
			group := a_group

			set_use_extended_types (True)
			set_map_zero_null_value (False)

			l_storage.append (a_name.as_string_8)
			l_storage.append (":********@")
			if a_host_name /= Void then
				a_data_app.set_hostname (a_host_name)
				l_storage.append (a_host_name)
			end

			if a_database_name /= Void then
				a_data_app.set_application (a_database_name.as_string_8)
				l_storage.append ("/" + a_database_name.as_string_8)
			end

			if a_data_source /= Void then
				a_data_app.set_data_source (a_data_source)
			end
			if a_role_id /= Void and then a_role_password /= Void then
				a_data_app.set_role (a_role_id, a_role_password)
			end
			if a_group /= Void then
				a_data_app.set_group (a_group)
			end

			a_data_app.login (a_name.as_string_8, a_password.as_string_8)
			a_data_app.set_base

			create session_control.make

		end

	report_database_schema_incompatibility (a_output: BOOLEAN)
			-- Report the application code is not compatible with database schema version
			-- if `a_output' is True, write error in io.error as well
		require
--			incompatible_database_schema_version: not is_database_schema_version_compatible
		local
			db_v: READABLE_STRING_8
		do
--			if attached database_schema_version as v then
--				db_v := v.version
--			else
--				db_v := "?.?.?.?"
--			end
--			database_error_handler.add_error_details (0, "MISC Error", "Schema version incompatible (application="
--							+ database_storage_version.version + " database=" + db_v + ")."
--						)
			if a_output then
				io.error.put_string (database_error_handler.as_string_representation)
				io.error.put_new_line
			end
		end

feature -- System Update

	update_system
		do
--			if is_database_schema_version_compatible then
--				misc_manager.initialize_reference_types
--				history_manager.initialize_data
--				user_role_permission_manager.initialize_built_in_user_role_permission
--				user_role_permission_manager.initialize_extra_user_role_permission
--				task_manager.initialize_data
--			else
--				-- If schema incompatible, report it and exit
--				report_database_schema_incompatibility (True)
--				(create {EXCEPTIONS}).die (-1)
--			end

-- [2012-Mars-21] Idea about update system implementation
--			if update_version < 01.00.0012 then
--				if update_version < 01.00.0005 then
--					update_version_01_00_0005
--				end
--				update_version_01_00_0012
--			end			
		end

	reset_storage_manager
		do
--			initialize_managers (Current)
		end

feature -- Storage

	storage_url: READABLE_STRING_8
			-- Associated storage URL

	storage_connection_kept_alive: BOOLEAN
			-- Keep storage connection alive?
			-- i.e: never disconnect between 2 transactions.

	keep_storage_connection_alive (b: BOOLEAN)
		do
			storage_connection_kept_alive := b
		end

	connect_storage
			-- Connect the database
		do
			if not session_control.is_connected then
				session_control.connect
			end
		end

	disconnect_from_storage
			-- Disconnect from the storage
		require
			is_connected_to_storage: is_connected_to_storage
		do
			if not storage_connection_kept_alive then
				session_control.disconnect
			end
		end

	force_disconnect_from_storage
			-- Force disconnection from the storage
			-- i.e ignore any `storage_connection_kept_alive'
		do
			if session_control.is_connected then
				session_control.disconnect
			end
		end

	is_connected_to_storage: BOOLEAN
			-- Is connected to the database
		do
			Result := session_control.is_connected
		end

feature -- Transaction Status

	in_transaction_session: BOOLEAN
			-- Is session started?

	transaction_session_depth: INTEGER
			-- Depth in the transaction session

feature -- Transaction Operation

	start_transaction_session
			-- Start session
			-- if already started, increase the `transaction_session_depth'
		require
			in_transaction_session implies transaction_session_depth > 0
			not in_transaction_session implies transaction_session_depth = 0
		local
			l_session_control: like session_control
			l_retried: INTEGER
		do
			if l_retried = 0 then
				if not in_transaction_session then
					database_error_handler.reset

					check transaction_session_depth = 0 end

					debug ("database_session")
						print ("..Start session%N")
					end
					connect_storage -- connect the DB
					if is_connected_to_storage then
						in_transaction_session := True
						session_control.begin -- start transaction
					else
						l_session_control := session_control
						if not l_session_control.is_ok then
							database_error_handler.add_database_error (l_session_control.error_message_32, l_session_control.error_code)
						else
							database_error_handler.add_database_error (Session_not_started_error_message, 0)
						end
						l_session_control.reset
					end
				end
				transaction_session_depth := transaction_session_depth + 1
			else
				if l_retried = 1 then
					transaction_session_depth := transaction_session_depth + 1
					if attached (create {EXCEPTION_MANAGER}).last_exception as e then
						if attached {ASSERTION_VIOLATION} e then
							--| Ignore for now with MYSQL ...
						else
							exception_as_error (e)
						end
					end

					in_transaction_session := False
					session_control.reset
				else
					in_transaction_session := False
				end
			end
		ensure
			transaction_session_depth = (old transaction_session_depth) + 1
		rescue
			l_retried := l_retried + 1
			retry
		end

	end_transaction_session
			-- End session
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				transaction_session_depth := transaction_session_depth - 1
				if transaction_session_depth = 0 then
					debug ("database_session")
						print ("..End session%N")
					end
					if is_connected_to_storage then
						if not database_error_handler.has_error then
							session_control.commit -- Commit transaction
						else
							session_control.rollback  -- Rollback transaction
						end
						disconnect_from_storage
					end
					in_transaction_session := False
				end
			else
				exception_as_error ((create {EXCEPTION_MANAGER}).last_exception)
				in_transaction_session := False
				transaction_session_depth := transaction_session_depth - 1
				session_control.reset
			end
		rescue
			l_retried := True
			retry
		end

	execute_query (a_query: STRING_32)
			-- Execute `a_q'
		require
			is_session_started: in_transaction_session
		local
			rescued: BOOLEAN
			l_change: like new_database_change
		do
			if not rescued then
				session_control.reset
				l_change := new_database_change
				l_change.set_query (a_query)
				l_change.execute_query
			else
				database_error_handler.add_error_details (0, "Unexpected Error", "Unexpected Error when executing query")
			end
		rescue
			rescued := True
			retry
		end

feature -- Element Change

	set_last_inserted_id_function (a_f: like last_inserted_id_function)
			-- Set `last_inserted_id_function' with `a_f'
		do
			last_inserted_id_function := a_f
		ensure
			last_inserted_id_function_set: last_inserted_id_function = a_f
		end

feature -- Access

	database_name: detachable READABLE_STRING_GENERAL
			-- Database to access

	name: READABLE_STRING_GENERAL
			-- Login user name

	password: READABLE_STRING_8
			-- Password

	host_name: detachable READABLE_STRING_8
			-- Host name, and port if needed

	role_id: detachable READABLE_STRING_8
			-- Role id

	role_password: detachable READABLE_STRING_8
			-- Role password

	data_source: detachable READABLE_STRING_8
			-- Data source

	group: detachable READABLE_STRING_8
			-- Group

	data_app: DATABASE_APPL [DATABASE]
			-- Database application

	last_inserted_id_function: detachable FUNCTION [ANY, TUPLE, NATURAL_64]
			-- Function to get last inserted id.

feature -- Factory

	new_database_change: DB_CHANGE
			-- Database change
		do
			create Result.make
		end

	new_database_selection: DB_SELECTION
			-- Database selection
		do
			create Result.make
		end

	new_procedure (a_name: like {DB_PROC}.name): DB_PROC
			-- Database procedure
		do
			create Result.make (a_name)
		end

feature {NONE} -- Implementation

	session_not_started_error_message: STRING_32 = "Session could not be started for unknown reason"

	session_control: DB_CONTROL
			-- Session

end
