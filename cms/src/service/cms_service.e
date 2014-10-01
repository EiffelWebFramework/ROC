note
	description: "[
				This class implements the CMS service

				It could be used to implement the main EWF service, or
				even for a specific handler.
			]"

class
	CMS_SERVICE

inherit
	WSF_ROUTED_SKELETON_SERVICE
		undefine
			requires_proxy
		redefine
			execute_default
		end

	WSF_NO_PROXY_POLICY

	WSF_URI_HELPER_FOR_ROUTED_SERVICE

	WSF_URI_TEMPLATE_HELPER_FOR_ROUTED_SERVICE

	REFACTORING_HELPER

	SHARED_LOGGER

create
	make

feature {NONE} -- Initialization

	make (a_setup: CMS_SETUP)
		do
			setup := a_setup
			configuration := a_setup.configuration
			modules := a_setup.modules
			initialize_auth_engine
			initialize_mailer
			initialize_router
			initialize_modules
		end



	initialize_users
		do
			to_implement ("To Implement initialize users")
		end

	initialize_mailer
		do
			to_implement ("To Implement mailer")
		end

	setup_router
		do
			configure_api_root
		end

	initialize_modules
			-- Intialize modules, import router definitions
			-- from enabled modules.
		do
			log.write_debug (generator + ".initialize_modules")
			across
				modules as m
			loop
				if m.item.is_enabled then
					router.import (m.item.router)
				end
			end
			configure_api_file_handler
		end

	initialize_auth_engine
		do
			to_implement ("To Implement authentication engine")
		end


	configure_api_root
		local
			l_root_handler: CMS_ROOT_HANDLER
			l_methods: WSF_REQUEST_METHODS
		do
			log.write_debug (generator + ".configure_api_root")
			create l_root_handler.make (setup)
			create l_methods
			l_methods.enable_get
			router.handle_with_request_methods ("/", l_root_handler, l_methods)
		end

	configure_api_file_handler
		local
			fhdl: WSF_FILE_SYSTEM_HANDLER
		do
			log.write_debug (generator + ".configure_api_file_handler")
			create fhdl.make_hidden_with_path (setup.layout.www_path)
			fhdl.disable_index
			fhdl.set_not_found_handler (agent  (ia_uri: READABLE_STRING_8; ia_req: WSF_REQUEST; ia_res: WSF_RESPONSE)
				do
					execute_default (ia_req, ia_res)
				end)
			router.handle_with_request_methods ("/", fhdl, router.methods_GET)
		end


feature -- Access	

	setup:  CMS_SETUP
		-- CMS setup.

	configuration: CMS_CONFIGURATION
	   	-- CMS configuration.
	   	-- | Maybe we can compute it (using `setup') instead of using memory.

	modules: LIST [CMS_MODULE]
		-- List of possible modules.
		-- | Maybe we can compute it (using `setup') instead of using memory.

feature -- Logging

feature -- Notification


feature -- Execution

	execute_default (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Default request handler if no other are relevant
		local
		do
			fixme ("To Implement")
		end


note
	copyright: "2011-2014, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
