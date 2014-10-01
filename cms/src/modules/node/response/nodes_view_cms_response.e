note
	description: "Summary description for {NODE_VIEW_CMS_RESPONSE}."
	date: "$Date$"
	revision: "$Revision$"

class
	NODES_VIEW_CMS_RESPONSE

inherit

	CMS_RESPONSE
		redefine
			custom_prepare
		end

create
	make

feature -- Generation

	custom_prepare (page: CMS_HTML_PAGE)
		do
			page.register_variable (setup.api_service.nodes, "nodes")
		end

feature -- Execution

	process
			-- Computed response message.
		do
			set_title ("List of Nodes")
			set_page_title (Void)
		end
end

