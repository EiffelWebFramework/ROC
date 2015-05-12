note
	description: "[
			Objects that ...
		]"
	author: "$Author: jfiat $"
	date: "$Date: 2015-02-13 13:08:13 +0100 (ven., 13 févr. 2015) $"
	revision: "$Revision: 96616 $"

class
	CMS_STORAGE_SQLITE_BUILDER

inherit
	CMS_STORAGE_SQL_BUILDER

	GLOBAL_SETTINGS

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
			if attached (create {APPLICATION_JSON_CONFIGURATION_HELPER}).new_database_configuration (a_setup.environment.application_config_path) as l_database_config then
				s := "Driver=SQLite3 ODBC Driver;Database="
				if attached l_database_config.database_name as db_name then
					s.append (db_name)
				end
				s.append (";LongNames=0;Timeout=1000;NoTXN=0;SyncPragma=NORMAL;StepAPI=0;")
				create Result.make (create {DATABASE_CONNECTION_ODBC}.login_with_connection_string (s))
				set_map_zero_null_value (False)
					-- This way we map 0 to 0, instead of Null as default.
				--create Result.make (create {DATABASE_CONNECTION_ODBC}.login_with_connection_string (l_database_config.connection_string))
				if Result.is_available then
					if not Result.is_initialized then
						initialize (a_setup, Result)
					end
				end
			end
		end

	initialize (a_setup: CMS_SETUP; a_storage: CMS_STORAGE_STORE_SQL)
		local
			u: CMS_USER
			l_anonymous_role, l_authenticated_role, r: CMS_USER_ROLE
			l_roles: LIST [CMS_USER_ROLE]
		do
				--| Schema
			a_storage.sql_execute_file_script (a_setup.environment.path.extended ("scripts").extended ("core.sql"))

				--| Roles
			create l_anonymous_role.make ("anonymous")
			a_storage.save_user_role (l_anonymous_role)

			create l_authenticated_role.make ("authenticated")
			a_storage.save_user_role (l_authenticated_role)

				--| Users
			create u.make ("admin")
			u.set_password ("istrator#")
			u.set_email (a_setup.site_email)
			a_storage.new_user (u)

				--| Node			
				-- FIXME: move that initialization to node module
			l_anonymous_role.add_permission ("view any page")
			a_storage.save_user_role (l_anonymous_role)

			l_authenticated_role.add_permission ("create page")
			l_authenticated_role.add_permission ("view any page")
			l_authenticated_role.add_permission ("edit own page")
			l_authenticated_role.add_permission ("delete own page")
			a_storage.save_user_role (l_authenticated_role)


			--| For testing purpose, to be removed later.

				-- Roles, view role for testing.
			create r.make ("view")
			r.add_permission ("view page")
			a_storage.save_user_role (r)

			create {ARRAYED_LIST [CMS_USER_ROLE]} l_roles.make (1)
			l_roles.force (r)

			create u.make ("auth")
			u.set_password ("enticated#")
			u.set_email (a_setup.site_email)
			a_storage.new_user (u)

			create u.make ("test")
			u.set_password ("test#")
			u.set_email (a_setup.site_email)
			a_storage.new_user (u)

			create u.make ("view")
			u.set_password ("only#")
			u.set_email (a_setup.site_email)
			u.set_roles (l_roles)
			a_storage.new_user (u)
		end

end
