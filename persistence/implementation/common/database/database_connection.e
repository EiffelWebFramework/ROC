note
	description: "Abstract class to handle a database connection"
	date: "$Date: 2014-08-20 15:21:15 -0300 (mi., 20 ago. 2014) $"
	revision: "$Revision: 95678 $"

deferred class
	DATABASE_CONNECTION

inherit

	DATABASE_CONFIG

	SHARED_ERROR_HANDLER

feature {NONE} -- Initialization

	make_common
			-- Create a database handler with common settings.
		deferred
		ensure
			db_application_not_void: db_application /= Void
			db_control_not_void: db_control /= Void
		end

	make_basic ( a_database_name: STRING)
			-- Create a database handler with common settings and
 			-- set database_name with `a_database_name'.
		require
			database_name_not_void: a_database_name /= Void
			database_name_not_empty: not a_database_name.is_empty
		deferred
		ensure
			db_application_not_void: db_application /= Void
			db_control_not_void: db_control /= Void
		end

	make (a_username: STRING; a_password: STRING; a_hostname: STRING; a_database_name: STRING; connection: BOOLEAN)

			-- Create a database handler with user `a_username', password `a_password',
			-- host `a_hostname', database_name `a_database_name', and keep_connection `connection'.
		require
			username_not_void: a_username /= Void
			username_not_empty: not a_username.is_empty
			password_not_void: a_password /= Void
			hostname_not_void: a_hostname /= Void
			hotname_not_empty: not a_hostname.is_empty
			database_name_not_void: a_database_name /= Void
			database_name_not_empty: not a_database_name.is_empty
		deferred
		ensure
			db_application_not_void: db_application /= Void
			db_control_not_void: db_control /= Void
		end

	login_with_connection_string (a_connection_string: STRING)
			-- Login with `a_connection_string'
			-- and immediately connect to database.
		deferred
		ensure
			db_application_not_void: db_application /= Void
			db_control_not_void: db_control /= Void
		end

feature -- Database Setup

	db_application: DATABASE_APPL [DATABASE]
			-- Database application.

	db_control: DB_CONTROL
			-- Database control.

	keep_connection: BOOLEAN
			-- Keep connection alive?

feature -- Transactions

	begin_transaction
			-- Start a transaction which will be terminated by a call to `rollback' or `commit'.
		local
			rescued: BOOLEAN
		do
			if not rescued then
				if db_control.is_ok then
					db_control.begin
				else
					database_error_handler.add_database_error (db_control.error_message_32, db_control.error_code)
				end
			end
		rescue
			rescued := True
			exception_as_error ((create {EXCEPTION_MANAGER}).last_exception)
			db_control.reset
			retry
		end

	commit
			-- Commit updates in the database.
		local
			rescued: BOOLEAN
		do
			if not rescued then
				if db_control.is_ok then
					db_control.commit
				else
					database_error_handler.add_database_error (db_control.error_message_32, db_control.error_code)
				end
			end
		rescue
			rescued := True
			exception_as_error ((create {EXCEPTION_MANAGER}).last_exception)
			db_control.reset
			retry
		end

	rollback
			-- Rollback updates in the database.
		local
			rescued: BOOLEAN
		do
			if not rescued then
				if db_control.is_ok then
					db_control.rollback
				else
					database_error_handler.add_database_error (db_control.error_message_32, db_control.error_code)
				end
			end
		rescue
			rescued := True
			exception_as_error ((create {EXCEPTION_MANAGER}).last_exception)
			db_control.reset
			retry
		end


feature --

	is_connected_to_storage: BOOLEAN
			-- Is connected to the database
		do
			Result := db_control.is_connected
		end

feature -- Transaction Status

	in_transaction_session: BOOLEAN
			-- Is session started?

	transaction_session_depth: INTEGER
			-- Depth in the transaction session

feature -- Transaction Operation

	begin_transaction2
			-- Start session
			-- if already started, increase the `transaction_session_depth'
		require
			in_transaction_session implies transaction_session_depth > 0
			not in_transaction_session implies transaction_session_depth = 0
		local
			l_session_control: like db_control
			l_retried: INTEGER
		do
			if l_retried = 0 then
				if not in_transaction_session then
					database_error_handler.reset

					check transaction_session_depth = 0 end

					debug ("database_session")
						print ("..Start session%N")
					end
					connect -- connect the DB
					if is_connected_to_storage then
						in_transaction_session := True
						db_control.begin -- start transaction
					else
						l_session_control := db_control
						if not l_session_control.is_ok then
							database_error_handler.add_database_error (l_session_control.error_message_32, l_session_control.error_code)
						else
							database_error_handler.add_database_error ("Session_not_started_error_message", 0)
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
					db_control.reset
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

	commit2
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
							db_control.commit -- Commit transaction
						else
							db_control.rollback  -- Rollback transaction
						end
					end
					in_transaction_session := False
				end
			else
				exception_as_error ((create {EXCEPTION_MANAGER}).last_exception)
				in_transaction_session := False
				transaction_session_depth := transaction_session_depth - 1
				db_control.reset
			end
		rescue
			l_retried := True
			retry
		end



	rollback2
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
						db_control.rollback  -- Rollback transaction
					end
					in_transaction_session := False
				end
			else
				exception_as_error ((create {EXCEPTION_MANAGER}).last_exception)
				in_transaction_session := False
				transaction_session_depth := transaction_session_depth - 1
				db_control.reset
			end
		rescue
			l_retried := True
			retry
		end
feature -- Change Element

	not_keep_connection
		do
			keep_connection := False
		end

feature -- Conection

	connect
			-- Connect to the database.
		require else
			db_control_not_void: db_control /= Void
		do
			if not is_connected then
				db_control.connect
			end
		end

	disconnect
			-- Disconnect from the database.
		require else
			db_control_not_void: db_control /= Void
		do
			db_control.disconnect
		end

	is_connected: BOOLEAN
			-- True if connected to the database.
		require else
			db_control_not_void: db_control /= Void
		do
			Result := db_control.is_connected
		end

end
