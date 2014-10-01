note
	description: "Abstract API service"
	date: "$Date: 2014-08-20 15:21:15 -0300 (mi., 20 ago. 2014) $"
	revision: "$Revision: 95678 $"

deferred class
	ROC_ABSTRACT_API

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

	SHARED_CONNEG_HELPER

	SHARED_LOGGER

feature {NONE} -- Initialization

	make (a_esa_config: ROC_CONFIG; a_server: ROC_SERVER)
		do
			roc_config := a_esa_config
			server := a_server
			initialize_router
		end

feature -- ESA

	roc_config: ROC_CONFIG
		-- Configuration

	server: ROC_SERVER
		-- Server

feature -- Router setup

	setup_router
			-- Setup `router'
		deferred
		end

	layout: APPLICATION_LAYOUT
		do
			Result := roc_config.layout
		end

feature -- Access

	handle_debug (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			s: STRING_8
			h: HTTP_HEADER
		do
			if req.is_get_request_method then
				s := "debug"
				create h.make_with_count (1)
				h.put_content_type_text_html
				h.put_content_length (s.count)
				res.put_header_lines (h)
				res.put_string (s)
			else
				create s.make (30_000)
				across
					req.form_parameters as c
				loop
					s.append (c.item.url_encoded_name)
					s.append ("=")
					s.append (c.item.string_representation)
					s.append ("<br/>")
				end
				if s.is_empty then
					req.read_input_data_into (s)
				end
				create h.make_with_count (1)
				h.put_content_type_text_html
				h.put_content_length (s.count)
				res.put_header_lines (h)
				res.put_string (s)
			end
		end

feature -- Handler

	not_yet_implemented_uri_template_handler (msg: READABLE_STRING_8): WSF_URI_TEMPLATE_HANDLER
		do
			create {WSF_URI_TEMPLATE_AGENT_HANDLER} Result.make (agent not_yet_implemented(?, ?, msg))
		end

	not_yet_implemented (req: WSF_REQUEST; res: WSF_RESPONSE; msg: detachable READABLE_STRING_8)
		local
			m: WSF_NOT_IMPLEMENTED_RESPONSE
		do
			create m.make (req)
			if msg /= Void then
				m.set_body (msg)
			end
			res.send (m)
		end


feature -- Default Execution

	execute_default (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Dispatch requests without a matching handler.
		local
		do

		end

end
