note
	description: "Summary description for {CMS_MODULE}."
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
		do
			name := "node"
			version := "1.0"
			description := "Service to manage content based on 'node'"
			package := "core"
			config := a_config
			setup_router
			enable
		end

feature -- Access

	router: WSF_ROUTER
		-- Node router.

	config: CMS_SETUP
		-- Node configuration.

feature -- Implementation

	setup_router
			-- Setup `router'.
		local
			fhdl: WSF_FILE_SYSTEM_HANDLER
		do
			create router.make (5)
			configure_api_node
			configure_api_nodes
			configure_api_node_title
			configure_api_node_summary
			configure_api_node_content
		end

feature -- Configure Node Resources Routes

	configure_api_node
		local
			l_node_handler: NODE_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_node_handler.make (config)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			router.handle_with_request_methods ("/node", l_node_handler, l_methods)

			create l_node_handler.make (config)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			l_methods.enable_delete
			router.handle_with_request_methods ("/node/{id}", l_node_handler, l_methods)
		end


	configure_api_nodes
		local
			l_nodes_handler: NODES_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_nodes_handler.make (config)
			create l_methods
			l_methods.enable_get
			router.handle_with_request_methods ("/nodes", l_nodes_handler, l_methods)
		end


	configure_api_node_summary
		local
			l_report_handler: NODE_SUMMARY_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_report_handler.make (config)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			router.handle_with_request_methods ("/node/{id}/summary", l_report_handler, l_methods)
		end


	configure_api_node_title
		local
			l_report_handler: NODE_TITLE_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_report_handler.make (config)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			router.handle_with_request_methods ("/node/{id}/title", l_report_handler, l_methods)
		end


	configure_api_node_content
		local
			l_report_handler: NODE_CONTENT_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_report_handler.make (config)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			router.handle_with_request_methods ("/node/{id}/content", l_report_handler, l_methods)
		end

end
