note
	description: "[
				REST API configuration
				We manage URI and Uri templates using Routers. They are used to delegate calls (to the corresponing handlers) based on a URI template. 
				We define a Rooter and attach handlers to it.
	]"
	date: "$Date: 2014-08-08 16:02:11 -0300 (vi., 08 ago. 2014) $"
	revision: "$Revision: 95593 $"

class
	ROC_REST_API

inherit

	ROC_ABSTRACT_API

create
	make

feature -- Initialization

	setup_router
			-- Setup `router'.
		local
			fhdl: WSF_FILE_SYSTEM_HANDLER
		do
			configure_api_root
			configure_api_node
			configure_api_navigation
			configure_api_login
			configure_api_nodes
			configure_api_node_title
			configure_api_node_summary
			configure_api_node_content
			configure_api_logoff
			configure_api_register


			create fhdl.make_hidden_with_path (layout.www_path)
			fhdl.disable_index
			fhdl.set_not_found_handler (agent  (ia_uri: READABLE_STRING_8; ia_req: WSF_REQUEST; ia_res: WSF_RESPONSE)
				do
					execute_default (ia_req, ia_res)
				end)
			router.handle_with_request_methods ("/", fhdl, router.methods_GET)
		end

feature -- Configure Resources Routes

	configure_api_root
		local
			l_root_handler:ROC_ROOT_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_root_handler.make (roc_config)
			create l_methods
			l_methods.enable_get
			router.handle_with_request_methods ("/", l_root_handler, l_methods)
		end

	configure_api_node
		local
			l_report_handler: NODE_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_report_handler.make (roc_config)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			router.handle_with_request_methods ("/node", l_report_handler, l_methods)

			create l_report_handler.make (roc_config)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			l_methods.enable_delete
			router.handle_with_request_methods ("/node/{id}", l_report_handler, l_methods)
		end

	configure_api_navigation
		local
			l_report_handler: NAVIGATION_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_report_handler.make (roc_config)
			create l_methods
			l_methods.enable_get
			router.handle_with_request_methods ("/navigation", l_report_handler, l_methods)
		end

	configure_api_login
		local
			l_report_handler: ROC_LOGIN_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_report_handler.make (roc_config)
			create l_methods
			l_methods.enable_get
			router.handle_with_request_methods ("/login", l_report_handler, l_methods)
		end

	configure_api_logoff
		local
			l_report_handler: ROC_LOGOFF_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_report_handler.make (roc_config)
			create l_methods
			l_methods.enable_get
			router.handle_with_request_methods ("/logoff", l_report_handler, l_methods)
		end


	configure_api_nodes
		local
			l_report_handler: NODES_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_report_handler.make (roc_config)
			create l_methods
			l_methods.enable_get
			router.handle_with_request_methods ("/nodes", l_report_handler, l_methods)
		end


	configure_api_node_summary
		local
			l_report_handler: NODE_SUMMARY_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_report_handler.make (roc_config)
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
			create l_report_handler.make (roc_config)
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
			create l_report_handler.make (roc_config)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			router.handle_with_request_methods ("/node/{id}/content", l_report_handler, l_methods)
		end


	configure_api_register
		local
			l_report_handler: USER_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_report_handler.make (roc_config)
			create l_methods
			l_methods.enable_get
			l_methods.enable_post
			l_methods.enable_put
			router.handle_with_request_methods ("/user", l_report_handler, l_methods)
		end



end
