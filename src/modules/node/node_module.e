note
	description: "CMS module that bring support for NODE management."
	date: "$Date: 2015-02-13 13:08:13 +0100 (ven., 13 févr. 2015) $"
	revision: "$Revision: 96616 $"

class
	NODE_MODULE

inherit

	CMS_MODULE
		redefine
			register_hooks
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

feature -- Access: router

	router (a_api: CMS_API): WSF_ROUTER
			-- Node router.
		local
			l_node_api: CMS_NODE_API
		do
			create l_node_api.make (a_api)
			create Result.make (5)
			configure_api_node (a_api, l_node_api, Result)
			configure_api_nodes (a_api, l_node_api, Result)
			configure_api_node_title (a_api, l_node_api, Result)
			configure_api_node_summary (a_api, l_node_api, Result)
			configure_api_node_content (a_api, l_node_api, Result)
		end

feature {NONE} -- Implementation: routes

	configure_api_node (a_api: CMS_API; a_node_api: CMS_NODE_API; a_router: WSF_ROUTER)
		local
			l_node_handler: NODE_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_node_handler.make (a_api, a_node_api)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			a_router.handle_with_request_methods ("/node", l_node_handler, l_methods)

			create l_node_handler.make (a_api, a_node_api)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			l_methods.enable_delete
			a_router.handle_with_request_methods ("/node/{id}", l_node_handler, l_methods)
--			a_router.handle_with_request_methods ("/nodes/", create {WSF_URI_AGENT_HANDLER}.make (agent do_get_nodes (?,?, a_api, a_node_api)), a_router.methods_get)
		end

	configure_api_nodes (a_api: CMS_API; a_node_api: CMS_NODE_API; a_router: WSF_ROUTER)
		local
			l_nodes_handler: NODES_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_nodes_handler.make (a_api, a_node_api)
			create l_methods
			l_methods.enable_get
			a_router.handle_with_request_methods ("/nodes", l_nodes_handler, l_methods)
		end

	configure_api_node_summary (a_api: CMS_API; a_node_api: CMS_NODE_API; a_router: WSF_ROUTER)
		local
			l_report_handler: NODE_SUMMARY_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_report_handler.make (a_api, a_node_api)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			a_router.handle_with_request_methods ("/node/{id}/field/summary", l_report_handler, l_methods)
		end

	configure_api_node_title (a_api: CMS_API; a_node_api: CMS_NODE_API; a_router: WSF_ROUTER)
		local
			l_report_handler: NODE_TITLE_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_report_handler.make (a_api, a_node_api)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			a_router.handle_with_request_methods ("/node/{id}/field/title", l_report_handler, l_methods)
		end

	configure_api_node_content (a_api: CMS_API; a_node_api: CMS_NODE_API; a_router: WSF_ROUTER)
		local
			l_report_handler: NODE_CONTENT_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_report_handler.make (a_api, a_node_api)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			a_router.handle_with_request_methods ("/node/{id}/field/content", l_report_handler, l_methods)
		end

feature -- Hooks

	register_hooks (a_response: CMS_RESPONSE)
		do
			a_response.subscribe_to_menu_system_alter_hook (Current)
			a_response.subscribe_to_block_hook (Current)
		end

	block_list: ITERABLE [like {CMS_BLOCK}.name]
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
		end

end
