note
	description: "Summary description for {NODES_HANDLER}."
	date: "$Date$"
	revision: "$Revision$"

class
	NODES_HANDLER

inherit
	APP_ABSTRACT_HANDLER
		rename
			set_esa_config as make
		end

	WSF_FILTER

	WSF_URI_HANDLER
		rename
			execute as uri_execute,
			new_mapping as new_uri_mapping
		end

	WSF_RESOURCE_HANDLER_HELPER
		redefine
			do_get
		end

	REFACTORING_HELPER

create
	make

feature -- execute

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler
		do
			execute_methods (req, res)
			execute_next (req, res)
		end

	uri_execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler
		do
			execute_methods (req, res)
		end

feature -- HTTP Methods

	do_get (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			l_page: ROC_RESPONSE
		do

			create l_page.make (req, "modules/nodes.tpl")
			l_page.set_value (api_service.nodes, "nodes")
			l_page.set_value (roc_config.is_web, "web")
			l_page.set_value (roc_config.is_html, "html")
			l_page.send_to (res)
		end
end
