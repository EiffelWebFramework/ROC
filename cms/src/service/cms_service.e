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
		rename
			execute as execute_service
		undefine
			requires_proxy
		redefine
			execute_default
		end

	WSF_FILTERED_SERVICE

	WSF_FILTER
		rename
			execute as execute_filter
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
			-- Build a CMS service with `a_setup' configuration.
		do
			setup := a_setup
			configuration := a_setup.configuration
			initialize
		end

	initialize
			-- Initialize various parts of the CMS service.
		do
			initialize_modules
			initialize_users
			initialize_auth_engine
			initialize_mailer
			initialize_router
			initialize_filter
		end

	initialize_modules
			-- Intialize modules and keep only enabled modules.
		local
			l_module: CMS_MODULE
			l_available_modules: CMS_MODULE_COLLECTION
		do
			log.write_debug (generator + ".initialize_modules")
			l_available_modules := setup.modules
			create modules.make (l_available_modules.count)
			across
				l_available_modules as ic
			loop
				l_module := ic.item
				if l_module.is_enabled then
					modules.extend (l_module)
				end
			end
		ensure
			only_enabled_modules: across modules as ic all ic.item.is_enabled end
		end

	initialize_users
			-- Initialize users.
		do
		end

	initialize_mailer
			-- Initialize mailer engine.
		do
			to_implement ("To Implement mailer")
		end

	initialize_auth_engine
		do
			to_implement ("To Implement authentication engine")
		end

feature -- Settings: router

	setup_router
			-- <Precursor>
		local
			l_module: CMS_MODULE
		do
			log.write_debug (generator + ".setup_router")
				-- Configure root of api handler.
			configure_api_root

				-- Include routes from modules.
			across
				modules as ic
			loop
				l_module := ic.item
				router.import (l_module.router)
			end
				-- Configure files handler.
			configure_api_file_handler
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
			router.handle_with_request_methods ("", l_root_handler, l_methods)
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

feature -- Execute Filter

	execute_filter (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the filter.
		do
			res.put_header_line ("Date: " + (create {HTTP_DATE}.make_now_utc).string)
			execute_service (req, res)
		end

feature -- Filters

	create_filter
			-- Create `filter'.
		local
			f, l_filter: detachable WSF_FILTER
			l_module: CMS_MODULE
		do
			log.write_debug (generator + ".create_filter")
			l_filter := Void
				-- Maintenance
			create {WSF_MAINTENANCE_FILTER} f
			f.set_next (l_filter)
			l_filter := f

				-- Include filters from modules
			across
				modules as ic
			loop
				l_module := ic.item
				if
					l_module.is_enabled and then
					attached l_module.filters as l_m_filters
				then
					across l_m_filters as f_ic loop
						f := f_ic.item
						f.set_next (l_filter)
						l_filter := f
					end
				end
			end

			filter := l_filter
		end

	setup_filter
			-- Setup `filter'.
		local
			f: WSF_FILTER
		do
			log.write_debug (generator + ".setup_filter")

			from
				f := filter
			until
				not attached f.next as l_next
			loop
				f := l_next
			end
			f.set_next (Current)
		end


feature -- Access	

	setup:  CMS_SETUP
			-- CMS setup.

	configuration: CMS_CONFIGURATION
		   	-- CMS configuration.
		   	--| Maybe we can compute it (using `setup') instead of using memory.

	modules: CMS_MODULE_COLLECTION
			-- Configurator of possible modules.

feature -- Execution

	execute_default (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Default request handler if no other are relevant
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
