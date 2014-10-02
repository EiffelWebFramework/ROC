note
	description: "Summary description for {BASIC_AUTH_MODULE}."
	date: "$Date$"
	revision: "$Revision$"

class
	BASIC_AUTH_MODULE

inherit

	CMS_MODULE

create
	make

feature {NONE} -- Initialization

	make (a_config: CMS_SETUP)
		do
			name := "basic auth"
			version := "1.0"
			description := "Service to manage basic authentication"
			package := "core"
			config := a_config
			setup_router
			setup_filter
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
		do
			create router.make (2)
			configure_api_login
			configure_api_logoff
		end

	setup_filter
			-- Setup `filter'.
		do
			add_filter (create {CORS_FILTER})
			add_filter (create {BASIC_AUTH_FILTER}.make (config))
		end

feature -- Configure Node Resources Routes

	configure_api_login
		local
			l_bal_handler: BASIC_AUTH_LOGIN_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_bal_handler.make (config)
			create l_methods
			l_methods.enable_get
			router.handle_with_request_methods ("/basic_auth/login", l_bal_handler, l_methods)
		end

	configure_api_logoff
		local
			l_bal_handler: BASIC_AUTH_LOGOFF_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_bal_handler.make (config)
			create l_methods
			l_methods.enable_get
			router.handle_with_request_methods ("/basic_auth/logoff", l_bal_handler, l_methods)
		end

end
