note
	description: "[
			Objects that ...
		]"
	author: "$Author: jfiat $"
	date: "$Date: 2015-01-27 19:15:02 +0100 (mar., 27 janv. 2015) $"
	revision: "$Revision: 96542 $"

class
	CMS_STORAGE_SQLITE_BUILDER

inherit
	CMS_STORAGE_BUILDER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
		end

feature -- Factory

	storage (a_setup: CMS_SETUP): detachable CMS_STORAGE_SQLITE
		local
			s: STRING
		do
			if attached (create {APPLICATION_JSON_CONFIGURATION_HELPER}).new_database_configuration (a_setup.layout.application_config_path) as l_database_config then
				s := "Driver=SQLite3 ODBC Driver;Database="
				if attached l_database_config.database_name as db_name then
					s.append (db_name)
				end
				s.append (";LongNames=0;Timeout=1000;NoTXN=0;SyncPragma=NORMAL;StepAPI=0;")
				create Result.make (create {DATABASE_CONNECTION_ODBC}.login_with_connection_string (s))
				--create Result.make (create {DATABASE_CONNECTION_ODBC}.login_with_connection_string (l_database_config.connection_string))
			end
		end


end
