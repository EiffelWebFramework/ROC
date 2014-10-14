note
	description: "Summary description for {CMS_DEMO_MODULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_DEMO_MODULE

inherit
	CMS_MODULE

create
	make

feature {NONE} -- Initialization

	make (a_config: CMS_SETUP)
		do
			name := "Demo module"
			version := "1.0"
			description := "Service to demonstrate and test cms system"
			package := "demo"
			config := a_config
		end

	config: CMS_SETUP
			-- Node configuration.

feature -- Access: router

	router: WSF_ROUTER
			-- Node router.
		do
			create Result.make (2)

			map_uri_template_agent (Result, "/demo/", agent handle_demo)
			map_uri_template_agent (Result, "/book/{id}", agent handle_demo_entry)
		end

feature -- Handler

	handle_demo,
	handle_demo_entry (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			m: WSF_NOT_FOUND_RESPONSE
		do
			create m.make (req)
			m.set_body ("Not yet implemented!")
			res.send (m)
		end

feature -- Mapping helper: uri template

	map_uri_template (a_router: WSF_ROUTER; a_tpl: STRING; h: WSF_URI_TEMPLATE_HANDLER)
			-- Map `h' as handler for `a_tpl'
		require
			a_tpl_attached: a_tpl /= Void
			h_attached: h /= Void
		do
			map_uri_template_with_request_methods (a_router, a_tpl, h, Void)
		end

	map_uri_template_with_request_methods (a_router: WSF_ROUTER; a_tpl: READABLE_STRING_8; h: WSF_URI_TEMPLATE_HANDLER; rqst_methods: detachable WSF_REQUEST_METHODS)
			-- Map `h' as handler for `a_tpl' for request methods `rqst_methods'.
		require
			a_tpl_attached: a_tpl /= Void
			h_attached: h /= Void
		do
			a_router.map_with_request_methods (create {WSF_URI_TEMPLATE_MAPPING}.make (a_tpl, h), rqst_methods)
		end

feature -- Mapping helper: uri template agent

	map_uri_template_agent (a_router: WSF_ROUTER; a_tpl: READABLE_STRING_8; proc: PROCEDURE [ANY, TUPLE [req: WSF_REQUEST; res: WSF_RESPONSE]])
			-- Map `proc' as handler for `a_tpl'
		require
			a_tpl_attached: a_tpl /= Void
			proc_attached: proc /= Void
		do
			map_uri_template_agent_with_request_methods (a_router, a_tpl, proc, Void)
		end

	map_uri_template_agent_with_request_methods (a_router: WSF_ROUTER; a_tpl: READABLE_STRING_8; proc: PROCEDURE [ANY, TUPLE [req: WSF_REQUEST; res: WSF_RESPONSE]]; rqst_methods: detachable WSF_REQUEST_METHODS)
			-- Map `proc' as handler for `a_tpl' for request methods `rqst_methods'.
		require
			a_tpl_attached: a_tpl /= Void
			proc_attached: proc /= Void
		do
			map_uri_template_with_request_methods (a_router, a_tpl, create {WSF_URI_TEMPLATE_AGENT_HANDLER}.make (proc), rqst_methods)
		end

end
