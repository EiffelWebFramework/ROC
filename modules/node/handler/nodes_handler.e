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
			pager: CMS_NODE_PAGINATION_BUILDER
			number_of_pages: INTEGER_64
			current_page: INTEGER
		do
				-- At the moment the template is hardcoded, but we can
				-- get them from the configuration file and load them into
				-- the setup class.

			create {GENERIC_VIEW_CMS_RESPONSE} l_response.make (req, res, api)
			l_response.add_variable (node_api.nodes, "nodes")

			create pager.make (node_api)
			number_of_pages := (node_api.nodes_count // pager.count) + 1

				-- Size:limit
			if
				attached {WSF_STRING} req.query_parameter ("size") as l_size and then
				l_size.is_integer
			then
				pager.set_count (l_size.integer_value.to_natural_32)
			end



				--Page:offset
			if
				attached {WSF_STRING} req.query_parameter ("page") as l_page and then
				l_page.is_integer
			then
				current_page := l_page.integer_value
				if current_page > 1 then
					pager.set_offset (((current_page-1)*(pager.count.to_integer_32)).to_natural_32)
				end
			else
				current_page := 1
			end



				-- NOTE: for development purposes we have the following hardcode output.
			create s.make_from_string ("<p>Items:</p>")

			s.append ("<p>Current Page:")
			s.append_integer (current_page)
			s.append (" of ")
			s.append_integer_64 (number_of_pages)
			s.append (" pages</p>")

				-- pager
			s.append ("<div class=%"col-xs-12%">%N")
			s.append ("<ul class=%"pager%">%N")
			create lnk.make ("First", "nodes/?page=1&size="+pager.count.out)
			s.append ("<li>")
			s.append (l_response.link (lnk.title, lnk.location, Void))
			s.append ("</li>")
			if (current_page - 1) > 1 then
				create lnk.make ("Prev", "nodes/?page="+ (current_page-1).out +"&size="+pager.count.out)
				s.append ("<li>")
				s.append (l_response.link (lnk.title, lnk.location, Void))
				s.append ("</li>")
			end

			if (current_page + 1) < number_of_pages then
				create lnk.make ("Next", "nodes/?page="+ (current_page+1).out +"&size="+pager.count.out)
				s.append ("<li>")
				s.append (l_response.link (lnk.title, lnk.location, Void))
				s.append ("</li>")
			end
			create lnk.make ("Last", "nodes/?page="+ number_of_pages.out +"&size="+pager.count.out)
			s.append ("<li>")
			s.append (l_response.link (lnk.title, lnk.location, Void))
			s.append ("</li>")


			s.append ("</ul>%N")
			s.append ("<div>%N")

			if attached pager.items as lst then
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

			l_response.set_main_content (s)
			l_response.add_block (create {CMS_CONTENT_BLOCK}.make ("nodes_warning", Void, "/nodes/ is not yet fully implemented<br/>", Void), "highlighted")
			l_response.execute
		end

end
