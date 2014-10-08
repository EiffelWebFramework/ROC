note
	description: "CMS module that bring support for NODE management."
	date: "$Date$"
	revision: "$Revision$"

class
	NODE_MODULE

inherit

	CMS_MODULE

create
	make

feature {NONE} -- Initialization

	make (a_config: CMS_SETUP)
			-- Create Current module, disabled by default.
		do
			name := "node"
			version := "1.0"
			description := "Service to manage content based on 'node'"
			package := "core"
			config := a_config
		end

	config: CMS_SETUP
			-- Node configuration.

feature -- Access: router

	router: WSF_ROUTER
			-- Node router.
		do
			create Result.make (5)
			configure_api_node (Result)
			configure_api_nodes (Result)
			configure_api_node_title (Result)
			configure_api_node_summary (Result)
			configure_api_node_content (Result)
		end

feature {NONE} -- Implementation: routes

	configure_api_node (a_router: WSF_ROUTER)
		local
			l_node_handler: NODE_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_node_handler.make (config)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			a_router.handle_with_request_methods ("/node", l_node_handler, l_methods)

			create l_node_handler.make (config)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			l_methods.enable_delete
			a_router.handle_with_request_methods ("/node/{id}", l_node_handler, l_methods)
		end

	configure_api_nodes (a_router: WSF_ROUTER)
		local
			l_nodes_handler: NODES_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_nodes_handler.make (config)
			create l_methods
			l_methods.enable_get
			a_router.handle_with_request_methods ("/nodes", l_nodes_handler, l_methods)
		end

	configure_api_node_summary (a_router: WSF_ROUTER)
		local
			l_report_handler: NODE_SUMMARY_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_report_handler.make (config)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			a_router.handle_with_request_methods ("/node/{id}/summary", l_report_handler, l_methods)
		end


	configure_api_node_title (a_router: WSF_ROUTER)
		local
			l_report_handler: NODE_TITLE_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_report_handler.make (config)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			a_router.handle_with_request_methods ("/node/{id}/title", l_report_handler, l_methods)
		end

	configure_api_node_content (a_router: WSF_ROUTER)
		local
			l_report_handler: NODE_CONTENT_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_report_handler.make (config)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			a_router.handle_with_request_methods ("/node/{id}/content", l_report_handler, l_methods)
		end

end
