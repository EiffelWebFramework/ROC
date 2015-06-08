note
	description: "Module Logging supporting different authentication strategies"
	date: "$Date: 2015-05-20 06:50:50 -0300 (mi. 20 de may. de 2015) $"
	revision: "$Revision: 97328 $"

class
	LOGIN_MODULE

inherit
	CMS_MODULE
		rename
			module_api as user_oauth_api
		redefine
			filters,
			register_hooks,
			initialize,
			is_installed,
			install,
			user_oauth_api
		end


	CMS_HOOK_BLOCK

	CMS_HOOK_AUTO_REGISTER

	CMS_HOOK_MENU_SYSTEM_ALTER

	CMS_HOOK_VALUE_TABLE_ALTER

	SHARED_EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

	REFACTORING_HELPER

	SHARED_LOGGER

	CMS_REQUEST_UTIL

create
	make

feature {NONE} -- Initialization

	make
			-- Create current module
		do
			name := "login"
			version := "1.0"
			description := "Eiffel login module"
			package := "login"

			create root_dir.make_current
			cache_duration := 0
		end

feature {CMS_API} -- Module Initialization			

	initialize (a_api: CMS_API)
			-- <Precursor>
		local
			l_user_auth_api: like user_oauth_api
			l_user_auth_storage: CMS_USER_OAUTH_STORAGE_I
		do
			Precursor (a_api)

				-- Storage initialization
			if attached {CMS_STORAGE_SQL_I} a_api.storage as l_storage_sql then
				create {CMS_USER_OAUTH_STORAGE_SQL} l_user_auth_storage.make (l_storage_sql)
			else
				-- FIXME: in case of NULL storage, should Current be disabled?
				create {CMS_USER_OAUTH_STORAGE_NULL} l_user_auth_storage
			end

				-- Node API initialization
			create l_user_auth_api.make_with_storage (a_api, l_user_auth_storage)
			user_oauth_api := l_user_auth_api
		ensure then
			user_oauth_api_set: user_oauth_api /= Void
		end

feature {CMS_API} -- Module management

	is_installed (api: CMS_API): BOOLEAN
			-- Is Current module installed?
		do
			Result := attached api.storage.custom_value ("is_initialized", "module-" + name) as v and then v.is_case_insensitive_equal_general ("yes")
		end

	install (api: CMS_API)
		local
			sql: STRING
			l_setup: CMS_SETUP
		do
			l_setup := api.setup

				-- Schema
			if attached {CMS_STORAGE_SQL_I} api.storage as l_sql_storage then
				if not l_sql_storage.sql_table_exists ("oauth2_gmail") then
					--| Schema
					l_sql_storage.sql_execute_file_script (l_setup.environment.path.extended ("scripts").extended ("core.sql"))

					if l_sql_storage.has_error then
						api.logger.put_error ("Could not initialize database for blog module", generating_type)
					end
				end
				api.storage.set_custom_value ("is_initialized", "module-" + name, "yes")
			end
		end

feature {CMS_API} -- Access: API

	user_oauth_api: detachable CMS_USER_OAUTH_API
			-- <Precursor>		


feature -- Filters

	filters (a_api: CMS_API): detachable LIST [WSF_FILTER]
			-- Possibly list of Filter's module.
		do
			create {ARRAYED_LIST [WSF_FILTER]} Result.make (1)
			if attached user_oauth_api as l_user_oauth_api then
				Result.extend (create {OAUTH_GMAIL_FILTER}.make (a_api, l_user_oauth_api))
			end
		end

feature -- Access: docs

	root_dir: PATH

	cache_duration: INTEGER
			-- Caching duration
			--|  0: disable
			--| -1: cache always valie
			--| nb: cache expires after nb seconds.

	cache_disabled: BOOLEAN
		do
			Result := cache_duration = 0
		end

feature -- Router


	setup_router (a_router: WSF_ROUTER; a_api: CMS_API)
			-- <Precursor>
		do
			if attached user_oauth_api as l_user_oauth_api then
				configure_web (a_api, l_user_oauth_api, a_router)
			end
		end


	configure_web (a_api: CMS_API; a_user_oauth_api: CMS_USER_OAUTH_API; a_router: WSF_ROUTER)
		do
			a_router.handle_with_request_methods ("/roc-login", create {WSF_URI_AGENT_HANDLER}.make (agent handle_login (a_api, ?, ?)), a_router.methods_head_get)
			a_router.handle_with_request_methods ("/roc-register", create {WSF_URI_AGENT_HANDLER}.make (agent handle_register (a_api, ?, ?)), a_router.methods_get_post)
			a_router.handle_with_request_methods ("/activate/{token}", create {WSF_URI_TEMPLATE_AGENT_HANDLER}.make (agent handle_activation (a_api, ?, ?)), a_router.methods_head_get)
			a_router.handle_with_request_methods ("/reactivate", create {WSF_URI_AGENT_HANDLER}.make (agent handle_reactivation (a_api, ?, ?)), a_router.methods_get_post)
			a_router.handle_with_request_methods ("/new-password", create {WSF_URI_AGENT_HANDLER}.make (agent handle_new_password (a_api, ?, ?)), a_router.methods_get_post)
			a_router.handle_with_request_methods ("/reset-password", create {WSF_URI_AGENT_HANDLER}.make (agent handle_reset_password (a_api, ?, ?)), a_router.methods_get_post)
			a_router.handle_with_request_methods ("/roc-logout", create {WSF_URI_AGENT_HANDLER}.make (agent handle_logout (a_api, ?, ?)), a_router.methods_get_post)
			a_router.handle_with_request_methods ("/login-with-google", create {WSF_URI_AGENT_HANDLER}.make (agent handle_login_with_google (a_api, ?, ?)), a_router.methods_get_post)
			a_router.handle_with_request_methods ("/oauthgmail", create {WSF_URI_AGENT_HANDLER}.make (agent handle_callback_gmail (a_api, a_user_oauth_api, ?, ?)), a_router.methods_get_post)

		end


feature -- Hooks configuration

	register_hooks (a_response: CMS_RESPONSE)
			-- Module hooks configuration.
		do
			auto_subscribe_to_hooks (a_response)
			a_response.subscribe_to_block_hook (Current)
			a_response.subscribe_to_value_table_alter_hook (Current)
		end

feature -- Hooks

	value_table_alter (a_value: CMS_VALUE_TABLE; a_response: CMS_RESPONSE)
			-- <Precursor>
		do
			if attached current_user (a_response.request) as l_user then
				a_value.force (l_user, "user")
			end
		end

	menu_system_alter (a_menu_system: CMS_MENU_SYSTEM; a_response: CMS_RESPONSE)
			-- Hook execution on collection of menu contained by `a_menu_system'
			-- for related response `a_response'.
		local
			lnk: CMS_LOCAL_LINK
		do
			if attached a_response.current_user (a_response.request) as u then
				create lnk.make (u.name +  " (Logout)", "roc-logout" )
			else
				create lnk.make ("Login", "roc-login")
			end
			a_menu_system.primary_menu.extend (lnk)
			lnk.set_weight (98)
		end

	block_list: ITERABLE [like {CMS_BLOCK}.name]
		local
			l_string: STRING
		do
			Result := <<"login","register","reactivate","new_password", "reset_password">>
			create l_string.make_empty
			across Result as ic loop
					l_string.append (ic.item)
					l_string.append_character (' ')
				end
			write_debug_log (generator + ".block_list:" + l_string )
		end

	get_block_view (a_block_id: READABLE_STRING_8; a_response: CMS_RESPONSE)
		local
			vals: CMS_VALUE_TABLE
		do
			if
				a_block_id.is_case_insensitive_equal_general ("login") and then
				a_response.request.path_info.starts_with ("/roc-login")
			then
				get_block_view_login (a_block_id, a_response)
			elseif
				a_block_id.is_case_insensitive_equal_general ("register") and then
				a_response.request.path_info.starts_with ("/roc-register")
			then
				get_block_view_register (a_block_id, a_response)
			elseif
				a_block_id.is_case_insensitive_equal_general ("reactivate") and then
				a_response.request.path_info.starts_with ("/reactivate")
			then
				get_block_view_reactivate (a_block_id, a_response)
			elseif
				a_block_id.is_case_insensitive_equal_general ("new_password") and then
				a_response.request.path_info.starts_with ("/new-password")
			then
				get_block_view_new_password (a_block_id, a_response)
			elseif
				a_block_id.is_case_insensitive_equal_general ("reset_password") and then
				a_response.request.path_info.starts_with ("/reset-password")
			then
				get_block_view_reset_password (a_block_id, a_response)
			end
		end

	handle_login (api: CMS_API; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			r: CMS_RESPONSE
			br: BAD_REQUEST_ERROR_CMS_RESPONSE
		do
			create {GENERIC_VIEW_CMS_RESPONSE} r.make (req, res, api)
			r.set_value ("Login", "optional_content_type")
			r.execute
		end


	handle_logout (api: CMS_API; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			r: CMS_RESPONSE
			l_url: STRING
			l_oauth_gmail: OAUTH_LOGIN_GMAIL
			l_cookie: WSF_COOKIE
		do
			if
				attached {WSF_STRING} req.cookie ("EWF_ROC_OAUTH_GMAIL_SESSION_") as l_cookie_token and then
				attached {CMS_USER} current_user (req) as l_user
			then
					-- Logout gmail
				create l_oauth_gmail.make (api, req.absolute_script_url (""))
				l_oauth_gmail.sign_out (l_cookie_token.value)
				create l_cookie.make ("EWF_ROC_OAUTH_GMAIL_SESSION_", l_cookie_token.value)
				l_cookie.set_max_age (-1)
				res.add_cookie (l_cookie)
				unset_current_user (req)
				create {GENERIC_VIEW_CMS_RESPONSE} r.make (req, res, api)
				r.set_status_code ({HTTP_CONSTANTS}.found)
				r.set_redirection (req.absolute_script_url (""))
				r.execute
			else
				create {GENERIC_VIEW_CMS_RESPONSE} r.make (req, res, api)
				r.set_status_code ({HTTP_CONSTANTS}.found)
				l_url := req.absolute_script_url ("")
				l_url.append ("/basic_auth_logoff")
				r.set_redirection (l_url)
				r.execute
			end
		end

	handle_register (api: CMS_API; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			r: CMS_RESPONSE
			l_user_api: CMS_USER_API
			u: CMS_USER
			l_roles: LIST [CMS_USER_ROLE]
			l_exist: BOOLEAN
			es: LOGIN_EMAIL_SERVICE
			l_link: STRING
			l_token: STRING
			l_message: STRING
		do
			create {GENERIC_VIEW_CMS_RESPONSE} r.make (req, res, api)
			r.set_value ("Register", "optional_content_type")
			if req.is_post_request_method then
				if
					attached {WSF_STRING} req.form_parameter ("name") as l_name and then
					attached {WSF_STRING} req.form_parameter ("password") as l_password and then
					attached {WSF_STRING} req.form_parameter ("email") as l_email
				then
					l_user_api := api.user_api

					if attached l_user_api.user_by_name (l_name.value) then
							-- Username already exist.
						r.values.force ("The user name exist!", "error_name")
						l_exist := True
					end
					if attached l_user_api.user_by_email (l_email.value) then
							-- Emails already exist.
						r.values.force ("The email exist!", "error_email")
						l_exist := True
					end

					if not l_exist then
							-- New user
						create {ARRAYED_LIST [CMS_USER_ROLE]}l_roles.make (1)
						l_roles.force (l_user_api.authenticated_user_role)

						create u.make (l_name.value)
						u.set_email (l_email.value)
						u.set_password (l_password.value)
						u.set_roles (l_roles)
						l_user_api.new_user (u)

							-- Create activation token
						l_token := new_token
						l_user_api.new_activation (l_token, u.id)
						create l_link.make_from_string (req.server_url)
						l_link.append ("/activate/")
						l_link.append (l_token)

						create l_message.make_from_string (account_activation)
						l_message.replace_substring_all ("$link", l_link)

							-- Send Email
						create es.make (create {LOGIN_EMAIL_SERVICE_PARAMETERS}.make (api))
						write_debug_log (generator + ".handle register: send_contact_email")
						es.send_contact_email (l_email.value, l_message)

					else
						r.values.force (l_name.value, "name")
						r.values.force (l_email.value, "email")
						r.set_status_code ({HTTP_CONSTANTS}.bad_request)
					end
				end
			end

			r.execute
		end

	handle_activation (api: CMS_API; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			r: CMS_RESPONSE
			l_user_api: CMS_USER_API
			l_id: INTEGER_64
			l_ir: INTERNAL_SERVER_ERROR_CMS_RESPONSE
			l_link: CMS_LOCAL_LINK
		do
			l_user_api := api.user_api
			create {GENERIC_VIEW_CMS_RESPONSE} r.make (req, res, api)
			if attached {WSF_STRING} req.path_parameter ("token") as l_token then

				if attached {CMS_USER} l_user_api.user_by_activation_token (l_token.value) as l_user then
					-- Valid user_id
					l_user.mark_active
					l_user_api.update_user (l_user)
					l_user_api.remove_activation (l_token.value)
					r.set_value ("Account activated", "optional_content_type")
					r.set_main_content ("<p> Your account <i>"+ l_user.name +"</i> has been activated</p>")
				else
					-- the token does not exist, or it was already used.
					r.set_status_code ({HTTP_CONSTANTS}.bad_request)
					r.set_value ("Account not activated", "optional_content_type")
					r.set_main_content ("<p>The token <i>"+ l_token.value +"</i> is not valid <a href=%"/reactivate%">Reactivate Account</a></p>"  )

				end
				r.execute
			else
				create l_ir.make (req, res, api)
				l_ir.execute
			end
		end


	handle_reactivation (api: CMS_API; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			r: CMS_RESPONSE
			br: BAD_REQUEST_ERROR_CMS_RESPONSE
			es: LOGIN_EMAIL_SERVICE
			l_user_api: CMS_USER_API
			l_token: STRING
			l_link: STRING
			l_message: STRING
		do
			create {GENERIC_VIEW_CMS_RESPONSE} r.make (req, res, api)
			if req.is_post_request_method then
				if
					attached {WSF_STRING} req.form_parameter ("email") as l_email
				then
					l_user_api := api.user_api
					if 	attached {CMS_USER} l_user_api.user_by_email (l_email.value) as l_user then
							-- User exist create a new token and send a new email.
						if l_user.is_active then
							r.values.force ("The asociated user to the given email " + l_email.value + " , is already active", "is_active")
							r.set_status_code ({HTTP_CONSTANTS}.bad_request)
						else
							l_token := new_token
							l_user_api.new_activation (l_token, l_user.id)
							create l_link.make_from_string (req.server_url)
							l_link.append ("/activate/")
							l_link.append (l_token)

							create l_message.make_from_string (account_activation)
							l_message.replace_substring_all ("$link", l_link)

								-- Send Email
							create es.make (create {LOGIN_EMAIL_SERVICE_PARAMETERS}.make (api))
							write_debug_log (generator + ".handle register: send_contact_email")
							es.send_contact_email (l_email.value, l_message)
						end
					else
						r.values.force ("The email does not exist or !", "error_email")
						r.values.force (l_email.value, "email")
						r.set_status_code ({HTTP_CONSTANTS}.bad_request)
					end
				end
			end

			r.execute
		end

	handle_new_password (api: CMS_API; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			r: CMS_RESPONSE
			br: BAD_REQUEST_ERROR_CMS_RESPONSE
			es: LOGIN_EMAIL_SERVICE
			l_user_api: CMS_USER_API
			l_token: STRING
			l_link: STRING
			l_message: STRING
		do
			create {GENERIC_VIEW_CMS_RESPONSE} r.make (req, res, api)
			if req.is_post_request_method then
				l_user_api := api.user_api
				if attached {WSF_STRING} req.form_parameter ("email") as l_email then
					if 	attached {CMS_USER} l_user_api.user_by_email (l_email.value) as l_user then
								-- User exist create a new token and send a new email.
						l_token := new_token
						l_user_api.new_password (l_token, l_user.id)
						create l_link.make_from_string (req.server_url)
						l_link.append ("/reset-password?token=")
						l_link.append (l_token)

						create l_message.make_from_string (account_new_password)
						l_message.replace_substring_all ("$link", l_link)

								-- Send Email
						create es.make (create {LOGIN_EMAIL_SERVICE_PARAMETERS}.make (api))
						write_debug_log (generator + ".handle register: send_contact_email")
						es.send_contact_email (l_email.value, l_message)
					else
						r.values.force ("The email does not exist !", "error_email")
						r.values.force (l_email.value, "email")
						r.set_status_code ({HTTP_CONSTANTS}.bad_request)
					end
				end
			end
			r.execute
		end


	handle_reset_password (api: CMS_API; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			r: CMS_RESPONSE
			br: BAD_REQUEST_ERROR_CMS_RESPONSE
			es: LOGIN_EMAIL_SERVICE
			l_user_api: CMS_USER_API
			l_link: STRING
			l_message: STRING
		do
			create {GENERIC_VIEW_CMS_RESPONSE} r.make (req, res, api)
			l_user_api := api.user_api
			if	attached {WSF_STRING} req.query_parameter ("token") as l_token then
				r.values.force (l_token.value, "token")
				if l_user_api.user_by_password_token (l_token.value) = Void  then
					r.values.force ("The token " + l_token.value + " is not valid, click <a href=%"/new-password%">here</a> to generate a new token.", "error_token")
					r.set_status_code ({HTTP_CONSTANTS}.bad_request)
				end
			end

			if req.is_post_request_method then

				if
					attached {WSF_STRING} req.form_parameter ("token") as l_token and then
					attached {WSF_STRING} req.form_parameter ("password") as l_password and then
					attached {WSF_STRING} req.form_parameter ("confirm_password") as l_confirm_password
				then
						-- Does the passwords match?	
					if l_password.value.same_string (l_confirm_password.value) then
							-- is the token valid?	
						if attached {CMS_USER} l_user_api.user_by_password_token (l_token.value) as l_user then
							l_user.set_password (l_password.value)
							l_user_api.update_user (l_user)
							l_user_api.remove_password (l_token.value)
						end
					else
						r.values.force ("Passwords Don't Match", "error_password")
						r.values.force (l_token.value, "token")
						r.set_status_code ({HTTP_CONSTANTS}.bad_request)
					end
				end
			end
			r.execute
		end

feature {NONE} -- Helpers

	template_block (a_block_id: READABLE_STRING_8; a_response: CMS_RESPONSE): detachable CMS_SMARTY_TEMPLATE_BLOCK
			-- Smarty content block for `a_block_id'
		local
			p: detachable PATH
		do
			create p.make_from_string ("templates")
			p := p.extended ("block_").appended (a_block_id).appended_with_extension ("tpl")
			p := a_response.module_resource_path (Current, p)
			if p /= Void then
				if attached p.entry as e then
					create Result.make (a_block_id, Void, p.parent, e)
				else
					create Result.make (a_block_id, Void, p.parent, p)
				end
			end
		end

feature {NONE} -- Block views

	get_block_view_login (a_block_id: READABLE_STRING_8; a_response: CMS_RESPONSE)
		local
			vals: CMS_VALUE_TABLE
		do
			if attached template_block (a_block_id, a_response) as l_tpl_block then
				create vals.make (1)
					-- add the variable to the block
				value_table_alter (vals, a_response)
				across
					vals as ic
				loop
					l_tpl_block.set_value (ic.item, ic.key)
				end
					a_response.add_block (l_tpl_block, "content")
			else
				debug ("cms")
					a_response.add_warning_message ("Error with block [" + a_block_id + "]")
				end
			end
		end

	get_block_view_register (a_block_id: READABLE_STRING_8; a_response: CMS_RESPONSE)
		local
			vals: CMS_VALUE_TABLE
		do
			if a_response.request.is_get_request_method then
				if attached template_block (a_block_id, a_response) as l_tpl_block then
					a_response.add_block (l_tpl_block, "content")
				else
					debug ("cms")
						a_response.add_warning_message ("Error with block [" + a_block_id + "]")
					end
				end
			elseif a_response.request.is_post_request_method then
				if a_response.values.has ("error_name") or else a_response.values.has ("error_email") then
					if attached template_block (a_block_id, a_response) as l_tpl_block then
						l_tpl_block.set_value (a_response.values.item ("error_name"), "error_name")
						l_tpl_block.set_value (a_response.values.item ("error_email"), "error_email")
						l_tpl_block.set_value (a_response.values.item ("email"), "email")
						l_tpl_block.set_value (a_response.values.item ("name"), "name")
						a_response.add_block (l_tpl_block, "content")
					else
						debug ("cms")
							a_response.add_warning_message ("Error with block [" + a_block_id + "]")
						end
					end
				else
					if attached template_block ("post_register", a_response) as l_tpl_block then
						a_response.add_block (l_tpl_block, "content")
					else
						debug ("cms")
							a_response.add_warning_message ("Error with block [" + a_block_id + "]")
						end
					end
				end
			end
		end


	get_block_view_reactivate (a_block_id: READABLE_STRING_8; a_response: CMS_RESPONSE)
		local
			vals: CMS_VALUE_TABLE
		do
			if a_response.request.is_get_request_method then
				if attached template_block (a_block_id, a_response) as l_tpl_block then
					a_response.add_block (l_tpl_block, "content")
				else
					debug ("cms")
						a_response.add_warning_message ("Error with block [" + a_block_id + "]")
					end
				end
			elseif a_response.request.is_post_request_method then
				if a_response.values.has ("error_email") or else a_response.values.has ("is_active") then
					if attached template_block (a_block_id, a_response) as l_tpl_block then
						l_tpl_block.set_value (a_response.values.item ("error_email"), "error_email")
						l_tpl_block.set_value (a_response.values.item ("email"), "email")
						l_tpl_block.set_value (a_response.values.item ("is_active"), "is_active")
						a_response.add_block (l_tpl_block, "content")
					else
						debug ("cms")
							a_response.add_warning_message ("Error with block [" + a_block_id + "]")
						end
					end
				else
					if attached template_block ("post_reactivate", a_response) as l_tpl_block then
						a_response.add_block (l_tpl_block, "content")
					else
						debug ("cms")
							a_response.add_warning_message ("Error with block [" + a_block_id + "]")
						end
					end
				end
			end
		end

	get_block_view_new_password (a_block_id: READABLE_STRING_8; a_response: CMS_RESPONSE)
		local
			vals: CMS_VALUE_TABLE
		do
			if a_response.request.is_get_request_method then
				if attached template_block (a_block_id, a_response) as l_tpl_block then
					a_response.add_block (l_tpl_block, "content")
				else
					debug ("cms")
						a_response.add_warning_message ("Error with block [" + a_block_id + "]")
					end
				end
			elseif a_response.request.is_post_request_method then
				if a_response.values.has ("error_email")  then
					if attached template_block (a_block_id, a_response) as l_tpl_block then
						l_tpl_block.set_value (a_response.values.item ("error_email"), "error_email")
						l_tpl_block.set_value (a_response.values.item ("email"), "email")
						a_response.add_block (l_tpl_block, "content")
					else
						debug ("cms")
							a_response.add_warning_message ("Error with block [" + a_block_id + "]")
						end
					end
				else
					if attached template_block ("post_password", a_response) as l_tpl_block then
						a_response.add_block (l_tpl_block, "content")
					else
						debug ("cms")
							a_response.add_warning_message ("Error with block [" + a_block_id + "]")
						end
					end
				end
			end
		end

	get_block_view_reset_password (a_block_id: READABLE_STRING_8; a_response: CMS_RESPONSE)
		local
			vals: CMS_VALUE_TABLE
		do
			if a_response.request.is_get_request_method then
				if attached template_block (a_block_id, a_response) as l_tpl_block then
					l_tpl_block.set_value (a_response.values.item ("token"), "token")
					l_tpl_block.set_value (a_response.values.item ("error_token"), "error_token")
					a_response.add_block (l_tpl_block, "content")
				else
					debug ("cms")
						a_response.add_warning_message ("Error with block [" + a_block_id + "]")
					end
				end
			elseif a_response.request.is_post_request_method then
				if a_response.values.has ("error_token") or else a_response.values.has ("error_password")   then
					if attached template_block (a_block_id, a_response) as l_tpl_block then
						l_tpl_block.set_value (a_response.values.item ("error_token"), "error_token")
						l_tpl_block.set_value (a_response.values.item ("error_password"), "error_password")
						l_tpl_block.set_value (a_response.values.item ("token"), "token")
						a_response.add_block (l_tpl_block, "content")
					else
						debug ("cms")
							a_response.add_warning_message ("Error with block [" + a_block_id + "]")
						end
					end
				else
					if attached template_block ("post_reset", a_response) as l_tpl_block then
						a_response.add_block (l_tpl_block, "content")
					else
						debug ("cms")
							a_response.add_warning_message ("Error with block [" + a_block_id + "]")
						end
					end
				end
			end
		end

feature -- OAuth2 Login with google.

	handle_login_with_google (api: CMS_API; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			r: CMS_RESPONSE
			l_oauth_gmail: OAUTH_LOGIN_GMAIL
		do
			create l_oauth_gmail.make (api, req.absolute_script_url (""))
			if attached  l_oauth_gmail.authorization_url as l_authorization then
				create {GENERIC_VIEW_CMS_RESPONSE} r.make (req, res, api)
				r.set_redirection (l_authorization)
				r.execute
			else
				create {BAD_REQUEST_ERROR_CMS_RESPONSE} r.make (req, res, api)
				r.set_main_content ("Bad request")
				r.execute
			end
		end

	handle_callback_gmail (api: CMS_API; a_user_oauth_api: CMS_USER_OAUTH_API; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			r: CMS_RESPONSE
			l_auth_gmail: OAUTH_LOGIN_GMAIL
			l_user_api: CMS_USER_API
			l_user: CMS_USER
			l_roles: LIST [CMS_USER_ROLE]
			l_cookie: WSF_COOKIE
		do
			if attached {WSF_STRING} req.query_parameter ("code") as l_code then
				create l_auth_gmail.make (api, req.server_url)
				l_auth_gmail.sign_request (l_code.value)
				if
					attached l_auth_gmail.access_token as l_access_token and then
					attached l_auth_gmail.user_profile as l_user_profile
				then
					create {GENERIC_VIEW_CMS_RESPONSE} r.make (req, res, api)
						-- extract user email
						-- check if the user exist
					l_user_api := api.user_api
						-- 1 if the user exit put it in the context
					if
						attached l_auth_gmail.user_email as l_email
					then
						if attached {CMS_USER} l_user_api.user_by_email (l_email) as p_user then
								-- User with email exist
							if	attached {CMS_USER} a_user_oauth_api.user_oauth2_gmail_by_id (p_user.id)	then
									-- Update oauth entry
								a_user_oauth_api.update_user_oauth2_gmail (l_access_token.token, l_user_profile, p_user )
							else
									-- create a oauth entry
								a_user_oauth_api.new_user_oauth2_gmail (l_access_token.token, l_user_profile, p_user )
							end
							create l_cookie.make ("EWF_ROC_OAUTH_GMAIL_SESSION_", l_access_token.token)
							l_cookie.set_max_age (l_access_token.expires_in)
							res.add_cookie (l_cookie)
						else

							create {ARRAYED_LIST [CMS_USER_ROLE]}l_roles.make (1)
							l_roles.force (l_user_api.authenticated_user_role)

								-- Create a new user and oauth entry
							create l_user.make (l_email)
							l_user.set_email (l_email)
							l_user.set_password (new_token) -- generate a random password.
							l_user.set_roles (l_roles)
							l_user.mark_active
							l_user_api.new_user (l_user)

								-- Add oauth entry
							a_user_oauth_api.new_user_oauth2_gmail (l_access_token.token, l_user_profile, l_user )
							create l_cookie.make ("EWF_ROC_OAUTH_GMAIL_SESSION_", l_access_token.token)
							l_cookie.set_max_age (l_access_token.expires_in)
							res.add_cookie (l_cookie)
						end
					else


					end
					r.set_redirection (req.absolute_script_url (""))
					r.execute
				end

			end

		end

feature {NONE} -- Token Generation

	new_token: STRING
			-- Generate a new token activation token
		local
			l_token: STRING
			l_security: SECURITY_PROVIDER
			l_encode: URL_ENCODER
		do
			create l_security
			l_token := l_security.token
			create l_encode
			from until l_token.same_string (l_encode.encoded_string (l_token)) loop
				-- Loop ensure that we have a security token that does not contain characters that need encoding.
			    -- We cannot simply to an encode-decode because the email sent to the user will contain an encoded token
				-- but the user will need to use an unencoded token if activation has to be done manually.
				l_token := l_security.token
			end
			Result := l_token
		end

feature --{NONE} -- Message email

	account_activation: STRING= "[
		<!doctype html>
		<html lang="en">
		<head>
		  <meta charset="utf-8">
		  <title>Eiffel.org Activation</title>
		  <meta name="description" content="Eiffel.org Activation">
		  <meta name="author" content="Eiffel.org">
		</head>

		<body>
			<p>Thank you for registering at <a href="eiffel.org">Eiffel.org</a></p>

			<p>To complete your registration, please click on this link to activate your account:<p>

			<p><a href="$link">$link</a></p>
			<p>Thank you for joining us.</p>
		</body>
		</html>
	]"

	account_new_password: STRING= "[
		<!doctype html>
		<html lang="en">
		<head>
		  <meta charset="utf-8">
		  <title>Eiffel.org New Password</title>
		  <meta name="description" content="Eiffel.org New Password">
		  <meta name="author" content="Eiffel.org">
		</head>

		<body>
			<p>You have required a new password at <a href="eiffel.org">Eiffel.org</a></p>

			<p>To complete your request, please click on this link to genereate a new password:<p>

			<p><a href="$link">$link</a></p>
		</body>
		</html>
	]"

feature {NONE} -- Implementation: date and time

	http_date_format_to_date (s: READABLE_STRING_8): detachable DATE_TIME
		local
			d: HTTP_DATE
		do
			create d.make_from_string (s)
			if not d.has_error then
				Result := d.date_time
			end
		end

	file_date (p: PATH): DATE_TIME
		require
			path_exists: (create {FILE_UTILITIES}).file_path_exists (p)
		local
			f: RAW_FILE
		do
			create f.make_with_path (p)
			Result := timestamp_to_date (f.date)
		end

	timestamp_to_date (n: INTEGER): DATE_TIME
		local
			d: HTTP_DATE
		do
			create d.make_from_timestamp (n)
			Result := d.date_time
		end

note
	copyright: "Copyright (c) 1984-2013, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
