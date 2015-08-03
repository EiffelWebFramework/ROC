note
	description: "Summary description for {CMS_ADMIN_MODULE}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_ADMIN_MODULE

inherit

	CMS_MODULE
		redefine
			register_hooks
		end

	CMS_HOOK_MENU_SYSTEM_ALTER

	CMS_HOOK_RESPONSE_ALTER

	CMS_HOOK_BLOCK

	CMS_REQUEST_UTIL

create
	make

feature {NONE} -- Initialization

	make (a_setup: CMS_SETUP)
			-- Create Current module, disabled by default.
		do
			version := "1.0"
			description := "Service to Administrate CMS (users, modules, etc)"
			package := "core"
			config := a_setup
		end

	config: CMS_SETUP
			-- Node configuration.

feature -- Access

	name: STRING = "admin"

feature {CMS_API} -- Module Initialization			

feature -- Access: router

	setup_router (a_router: WSF_ROUTER; a_api: CMS_API)
			-- <Precursor>
		do
			configure_web (a_api, a_router)
		end

	configure_web (a_api: CMS_API; a_router: WSF_ROUTER)
		local
			l_admin_handler: CMS_ADMIN_HANDLER
			l_users_handler: CMS_ADMIN_USERS_HANDLER
			l_roles_handler: CMS_ADMIN_ROLES_HANDLER

			l_user_handler: CMS_USER_HANDLER
			l_role_handler:	CMS_ROLE_HANDLER

			l_uri_mapping: WSF_URI_MAPPING
		do
			create l_admin_handler.make (a_api)
			create l_uri_mapping.make_trailing_slash_ignored ("/admin", l_admin_handler)
			a_router.map (l_uri_mapping, a_router.methods_get_post)

			create l_users_handler.make (a_api)
			create l_uri_mapping.make_trailing_slash_ignored ("/admin/users", l_users_handler)
			a_router.map (l_uri_mapping, a_router.methods_get_post)

			create l_roles_handler.make (a_api)
			create l_uri_mapping.make_trailing_slash_ignored ("/admin/roles", l_roles_handler)
			a_router.map (l_uri_mapping, a_router.methods_get_post)

			create l_user_handler.make (a_api)
			a_router.handle ("/admin/add/user", l_user_handler, a_router.methods_get_post)
			a_router.handle ("/admin/user/{id}", l_user_handler, a_router.methods_get)
			a_router.handle ("/admin/user/{id}/edit", l_user_handler, a_router.methods_get_post)
			a_router.handle ("/admin/user/{id}/delete", l_user_handler, a_router.methods_get_post)

			create l_role_handler.make (a_api)
			a_router.handle ("/admin/add/role", l_role_handler, a_router.methods_get_post)
			a_router.handle ("/admin/role/{id}", l_role_handler, a_router.methods_get)
			a_router.handle ("/admin/role/{id}/edit", l_role_handler, a_router.methods_get_post)
			a_router.handle ("/admin/role/{id}/delete", l_role_handler, a_router.methods_get_post)
		end

feature -- Hooks

	register_hooks (a_response: CMS_RESPONSE)
			-- <Precursor>
		do
			a_response.subscribe_to_menu_system_alter_hook (Current)
			a_response.subscribe_to_block_hook (Current)
			a_response.subscribe_to_response_alter_hook (Current)
		end

	response_alter (a_response: CMS_RESPONSE)
			-- <Precursor>
		do
			a_response.add_style (a_response.url ("/module/" + name + "/files/css/admin.css", Void), Void)
		end

	block_list: ITERABLE [like {CMS_BLOCK}.name]
			-- <Precursor>
		do
			Result := <<"admin-info">>
		end

	get_block_view (a_block_id: READABLE_STRING_8; a_response: CMS_RESPONSE)
		local
--			b: CMS_CONTENT_BLOCK
		do
--			create b.make (a_block_id, "Block::node", "This is a block test", Void)
--			a_response.add_block (b, "sidebar_second")
		end

	menu_system_alter (a_menu_system: CMS_MENU_SYSTEM; a_response: CMS_RESPONSE)
		local
			lnk: CMS_LOCAL_LINK
		do
			if
				attached current_user (a_response.request) as l_user and then
				a_response.api.user_api.is_admin_user (l_user)
			then
				create lnk.make ("Admin", "admin")
				a_menu_system.primary_menu.extend (lnk)
			end
		end

note
	copyright: "2011-2015, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
