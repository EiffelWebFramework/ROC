note
	description: "Request handler related to /nodes."
	date: "$Date: 2015-02-13 13:08:13 +0100 (ven., 13 févr. 2015) $"
	revision: "$Revision: 96616 $"

class
	NODES_HANDLER

inherit
	CMS_NODE_HANDLER

	WSF_URI_HANDLER
		rename
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
		end

feature -- HTTP Methods

	do_get (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			l_response: CMS_RESPONSE
			s: STRING
			n: CMS_NODE
			lnk: CMS_LOCAL_LINK
			l_page_helper: CMS_NODE_PAGINATION_HELPER
		do
				-- At the moment the template is hardcoded, but we can
				-- get them from the configuration file and load them into
				-- the setup class.

			create {GENERIC_VIEW_CMS_RESPONSE} l_response.make (req, res, api)
			create l_page_helper.make ("nodes/", req, l_response, node_api.nodes_count)

			create s.make_empty
			l_page_helper.append_pagination_summary_to (s)
			l_page_helper.append_html_pager_to (s)

			if attached node_api.recent_nodes (l_page_helper.pager) as lst then
				s.append ("<ul class=%"cms-nodes%">%N")
				across
					lst as ic
				loop
					n := ic.item
					lnk := node_api.node_link (n)
					s.append ("<li class=%"cms_type_"+ n.content_type +"%">")
					s.append (l_response.link (lnk.title, lnk.location, Void))
					s.append ("</li>%N")
				end
				s.append ("</ul>%N")
			end
			l_page_helper.append_html_pager_to (s)

			l_response.set_main_content (s)
			l_response.add_block (create {CMS_CONTENT_BLOCK}.make ("nodes_warning", Void, "/nodes/ is not yet fully implemented<br/>", Void), "highlighted")
			l_response.execute
		end

end
