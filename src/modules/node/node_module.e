note
	description: "CMS module that bring support for NODE management."
	date: "$Date: 2015-02-13 13:08:13 +0100 (ven., 13 févr. 2015) $"
	revision: "$Revision: 96616 $"

class
	NODE_MODULE

inherit

	CMS_MODULE
		rename
			module_api as node_api
		redefine
			register_hooks,
			initialize,
			is_installed,
			install,
			node_api
		end

	CMS_HOOK_MENU_SYSTEM_ALTER

	CMS_HOOK_BLOCK

create
	make

feature {NONE} -- Initialization

	make (a_setup: CMS_SETUP)
			-- Create Current module, disabled by default.
		do
			name := "node"
			version := "1.0"
			description := "Service to manage content based on 'node'"
			package := "core"
			config := a_setup
		end

	config: CMS_SETUP
			-- Node configuration.

feature {CMS_API} -- Module Initialization			

	initialize (api: CMS_API)
			-- <Precursor>
		local
			p1,p2: CMS_PAGE
			ct: CMS_PAGE_NODE_TYPE
			l_node_api: like node_api
		do
			Precursor (api)
			create l_node_api.make (api)
			node_api := l_node_api

				-- Add support for CMS_PAGE, which requires a storage extension to store the optional "parent" id.
				-- For now, we only have extension based on SQL statement.
			if attached {CMS_NODE_STORAGE_SQL} l_node_api.node_storage as l_sql_node_storage then
				l_sql_node_storage.register_node_storage_extension (create {CMS_NODE_STORAGE_SQL_PAGE_EXTENSION}.make (l_sql_node_storage))

					-- FIXME: the following code is mostly for test purpose/initialization, remove later
				if l_sql_node_storage.sql_table_items_count ("page_nodes") = 0 then
					if attached api.user_api.user_by_id (1) as u then
						create ct
						p1 := ct.new_node (Void)
						p1.set_title ("Welcome")
						p1.set_content ("Welcome, you are using the ROC Eiffel CMS", Void, Void) -- Use default format
						p1.set_author (u)
						l_sql_node_storage.save_node (p1)

						p2 := ct.new_node (Void)
						p2.set_title ("A new page example")
						p2.set_content ("This is the content of a page", Void, Void) -- Use default format
						p2.set_author (u)
						p2.set_parent (p1)
						l_sql_node_storage.save_node (p2)
					end
				end
			else
					-- FIXME: maybe provide a default solution based on file system, when no SQL storage is available.
					-- IDEA: we could also have generic extension to node system, that handle generic addition field.
			end
		end

feature {CMS_API} -- Module management

	is_installed (api: CMS_API): BOOLEAN
			-- Is Current module installed?
		do
			if attached {CMS_STORAGE_SQL_I} api.storage as l_sql_storage then
				Result := l_sql_storage.sql_table_exists ("nodes") and
					l_sql_storage.sql_table_exists ("page_nodes")
			end
		end

	install (api: CMS_API)
		do
				-- Schema
			if attached {CMS_STORAGE_SQL_I} api.storage as l_sql_storage then
				l_sql_storage.sql_execute_file_script (api.setup.layout.path.extended ("scripts").extended (name).appended_with_extension ("sql"))
			end
		end

feature {CMS_API} -- Access: API

	node_api: detachable CMS_NODE_API
			-- <Precursor>

feature -- Access: router

	router (a_api: CMS_API): WSF_ROUTER
			-- Node router.
		local
			l_node_api: like node_api
		do
			l_node_api := node_api
			if l_node_api = Void then
				create l_node_api.make (a_api)
				node_api := l_node_api
			end
			create Result.make (2)
			configure_cms (a_api, l_node_api, Result)
--			configure_api (a_api, l_node_api, Result)
		end

	configure_cms (a_api: CMS_API; a_node_api: CMS_NODE_API; a_router: WSF_ROUTER)
		local
			l_node_handler: NODE_HANDLER
			l_edit_node_handler: NODE_HANDLER
			l_new_node_handler: NODE_HANDLER
			l_nodes_handler: NODES_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_node_handler.make (a_api, a_node_api)
			a_router.handle_with_request_methods ("/node", l_node_handler, a_router.methods_get_post)
			a_router.handle_with_request_methods ("/node/", l_node_handler, a_router.methods_get_post)

			create l_new_node_handler.make (a_api, a_node_api)
			a_router.handle_with_request_methods ("/node/add/{type}", l_new_node_handler, a_router.methods_get_post)
			a_router.handle_with_request_methods ("/node/new", l_new_node_handler, a_router.methods_get)

--			a_router.handle_with_request_methods ("/node/new/{type}", create {WSF_URI_AGENT_HANDLER}.make (agent do_get_node_creation_by_type (?,?, "type", a_node_api)), a_router.methods_get)
--			a_router.handle_with_request_methods ("/node/new", create {WSF_URI_AGENT_HANDLER}.make (agent do_get_node_creation_selection (?,?, a_node_api)), a_router.methods_get)

			create l_edit_node_handler.make (a_api, a_node_api)
			a_router.handle_with_request_methods ("/node/{id}/edit", l_edit_node_handler, a_router.methods_get_post)

			create l_node_handler.make (a_api, a_node_api)
			a_router.handle_with_request_methods ("/node/{id}", l_node_handler, a_router.methods_get_put_delete + a_router.methods_get_post)



				-- Nodes
			create l_nodes_handler.make (a_api, a_node_api)
			create l_methods
			l_methods.enable_get
			a_router.handle_with_request_methods ("/nodes", l_nodes_handler, l_methods)
		end

--	configure_api (a_api: CMS_API; a_node_api: CMS_NODE_API; a_router: WSF_ROUTER)
--		do
--			configure_api_node (a_api, a_node_api, a_router)
--			configure_api_nodes (a_api, a_node_api, a_router)
--			configure_api_node_title (a_api, a_node_api, a_router)
--			configure_api_node_summary (a_api, a_node_api, a_router)
--			configure_api_node_content (a_api, a_node_api, a_router)
--		end

feature {NONE} -- Implementation: routes

--	configure_api_node (a_api: CMS_API; a_node_api: CMS_NODE_API; a_router: WSF_ROUTER)
--		local
--			l_node_handler: NODE_RESOURCE_HANDLER
--			l_methods: WSF_REQUEST_METHODS
--		do
--			create l_node_handler.make (a_api, a_node_api)
--			create l_methods
--			l_methods.enable_get
--			l_methods.enable_post
--			l_methods.lock
--			a_router.handle_with_request_methods ("/api/node", l_node_handler, l_methods)

--			create l_node_handler.make (a_api, a_node_api)
--			a_router.handle_with_request_methods ("/api/node/{id}", l_node_handler, a_router.methods_get_put_delete + a_router.methods_get_post)
--		end

--	configure_api_nodes (a_api: CMS_API; a_node_api: CMS_NODE_API; a_router: WSF_ROUTER)
--		local
--			l_nodes_handler: NODE_RESOURCES_HANDLER
--			l_methods: WSF_REQUEST_METHODS
--		do
--			create l_nodes_handler.make (a_api, a_node_api)
--			create l_methods
--			l_methods.enable_get
--			a_router.handle_with_request_methods ("/api/nodes", l_nodes_handler, l_methods)
--		end

--	configure_api_node_summary (a_api: CMS_API; a_node_api: CMS_NODE_API; a_router: WSF_ROUTER)
--		local
--			l_report_handler: NODE_SUMMARY_HANDLER
--			l_methods: WSF_REQUEST_METHODS
--		do
--			create l_report_handler.make (a_api, a_node_api)
--			create l_methods
--			l_methods.enable_get
--			l_methods.enable_post
--			l_methods.enable_put
--			a_router.handle_with_request_methods ("/node/{id}/field/summary", l_report_handler, l_methods)
--		end

--	configure_api_node_title (a_api: CMS_API; a_node_api: CMS_NODE_API; a_router: WSF_ROUTER)
--		local
--			l_report_handler: NODE_TITLE_HANDLER
--			l_methods: WSF_REQUEST_METHODS
--		do
--			create l_report_handler.make (a_api, a_node_api)
--			create l_methods
--			l_methods.enable_get
--			l_methods.enable_post
--			l_methods.enable_put
--			a_router.handle_with_request_methods ("/node/{id}/field/title", l_report_handler, l_methods)
--		end

--	configure_api_node_content (a_api: CMS_API; a_node_api: CMS_NODE_API; a_router: WSF_ROUTER)
--		local
--			l_report_handler: NODE_CONTENT_HANDLER
--			l_methods: WSF_REQUEST_METHODS
--		do
--			create l_report_handler.make (a_api, a_node_api)
--			create l_methods
--			l_methods.enable_get
--			l_methods.enable_post
--			l_methods.enable_put
--			a_router.handle_with_request_methods ("/node/{id}/field/content", l_report_handler, l_methods)
--		end

feature -- Hooks

	register_hooks (a_response: CMS_RESPONSE)
			-- <Precursor>
		do
			a_response.subscribe_to_menu_system_alter_hook (Current)
			a_response.subscribe_to_block_hook (Current)
		end

	block_list: ITERABLE [like {CMS_BLOCK}.name]
			-- <Precursor>
		do
			Result := <<"node-info">>
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
--			perms: detachable ARRAYED_LIST [READABLE_STRING_8]
		do
			create lnk.make ("List of nodes", a_response.url ("/nodes", Void))
			a_menu_system.primary_menu.extend (lnk)
			create lnk.make ("Create ..", a_response.url ("/node/", Void))
			a_menu_system.primary_menu.extend (lnk)
		end

--feature -- Handler

--	do_get_node_creation_selection (req: WSF_REQUEST; res: WSF_RESPONSE; a_node_api: CMS_NODE_API)
--		local
--			l_page: GENERIC_VIEW_CMS_RESPONSE
--			s: STRING
--		do
--			create l_page.make (req, res, a_node_api.cms_api)

--			create s.make_empty
--			s.append ("<ul>")
--			across
--				a_node_api.content_types as ic
--			loop
--				s.append ("<li>")
--				s.append (l_page.link (ic.item.title, a_node_api.new_content_path (ic.item), Void))
--				if attached ic.item.description as l_description then
--					s.append ("<p class=%"description%">")
--					s.append (l_page.html_encoded (l_description))
--					s.append ("</p>")
--				end
--				s.append ("</li>")
--			end
--			s.append ("</ul>")
--			l_page.set_title ("Create new content ...")
--			l_page.set_main_content (s)
--			l_page.execute
--		end

--	do_get_node_creation_by_type (req: WSF_REQUEST; res: WSF_RESPONSE; a_type_varname: READABLE_STRING_8; a_node_api: CMS_NODE_API)
--		local
--			l_page: NOT_IMPLEMENTED_ERROR_CMS_RESPONSE
--			l_node: detachable CMS_NODE
--		do
--			create l_page.make (req, res, a_node_api.cms_api)
--			if
--				attached {WSF_STRING} req.path_parameter (a_type_varname) as p_type and then
--				attached a_node_api.content_type (p_type.value) as ct
--			then
--				l_node := ct.new_node (Void)
--				l_page.set_main_content (l_node.out)
--			end
--			l_page.execute
--		end

end
