note
	description: "Summary description for {BASIC_AUTH_MODULE}."
	date: "$Date$"
	revision: "$Revision$"

class
	BASIC_AUTH_MODULE

inherit

	CMS_MODULE
		redefine
			filters
		end

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
		end

	config: CMS_SETUP
		-- Node configuration.

feature -- Access: router

	router: WSF_ROUTER
			-- Node router.
		do
			create Result.make (2)
			configure_api_login (Result)
			configure_api_logoff (Result)
		end

feature -- Access: filter

	filters: detachable LIST [WSF_FILTER]
			-- Possibly list of Filter's module.
		do
			create {ARRAYED_LIST [WSF_FILTER]} Result.make (2)
			Result.extend (create {CORS_FILTER})
			Result.extend (create {BASIC_AUTH_FILTER}.make (config))
		end

feature {NONE} -- Implementation: routes

	configure_api_login (a_router: WSF_ROUTER)
		local
			l_bal_handler: BASIC_AUTH_LOGIN_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_bal_handler.make (config)
			create l_methods
			l_methods.enable_get
			a_router.handle_with_request_methods ("/basic_auth_login", l_bal_handler, l_methods)
		end

	configure_api_logoff (a_router: WSF_ROUTER)
		local
			l_bal_handler: BASIC_AUTH_LOGOFF_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			create l_bal_handler.make (config)
			create l_methods
			l_methods.enable_get
			a_router.handle_with_request_methods ("/basic_auth_logoff", l_bal_handler, l_methods)
		end


feature -- Hooks

	register_hooks (a_response: CMS_RESPONSE)
		do
		end

end
