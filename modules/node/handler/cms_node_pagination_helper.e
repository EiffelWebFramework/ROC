note
	description: "Helper class to build the html pagination links and header summary"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_NODE_PAGINATION_HELPER


create
	make

feature {NONE} -- Initialization

	make (a_req: WSF_REQUEST; a_response: CMS_RESPONSE; a_nodes_count: INTEGER_64)
			-- Create an object with default values.
		do
			make_size (a_req, a_response, a_nodes_count, 5)
		end

	make_size (a_req: WSF_REQUEST; a_response: CMS_RESPONSE; a_nodes_count: INTEGER_64; a_size: NATURAL)
			-- Create an object with a pages of size `a_size'.
		do
			req := a_req
			number_of_nodes := a_nodes_count
			create pager
			pager.set_count (a_size)
			response := a_response
			process
		end

	req: WSF_REQUEST
		-- Current request.

	process
			-- Process request query paraments to build the pager.
		do
				--TODO: at the moment the code looks for hardcoded parameters
				-- sie and page, maybe we can parametrize these names.
				-- Size:limit.
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
		end

feature -- Access

	pager: CMS_PAGINATION_BUILDER
			-- Paginator.

	current_page: INTEGER
			-- current page.

	number_of_pages: INTEGER_64
			-- total number of pages.
		do
			Result := (number_of_nodes // pager.count.as_integer_32) + 1
		end

	number_of_nodes: INTEGER_64
			-- number of nodes.

	response: CMS_RESPONSE
			-- cms response

feature -- Paginator

	paging_summary: STRING
			-- Header summary
			-- Current page 1 of n pages.
		do
			create Result.make_from_string ("<p>Items:</p>")

			Result.append ("<p>Current Page:")
			Result.append_integer (current_page)
			Result.append (" of ")
			Result.append_integer_64 (number_of_pages)
			Result.append (" pages</p>")
		end


	build_html_node_paging: STRING
			-- First, [Prev], [Next], Last.
		local
			s: STRING
			lnk: CMS_LOCAL_LINK

		do
				-- NOTE: for development purposes we have the following hardcode output.
			create s.make_empty

				-- pager
			s.append ("<div class=%"col-xs-12%">%N")
			s.append ("<ul class=%"pager%">%N")
			create lnk.make ("First", "nodes/?page=1&size="+pager.count.out)
			s.append ("<li>")
			s.append (response.link (lnk.title, lnk.location, Void))
			s.append ("</li>")
			if (current_page - 1) > 1 then
				create lnk.make ("Prev", "nodes/?page="+ (current_page-1).out +"&size="+pager.count.out)
				s.append ("<li>")
				s.append (response.link (lnk.title, lnk.location, Void))
				s.append ("</li>")
			end

			if (current_page + 1) < number_of_pages then
				create lnk.make ("Next", "nodes/?page="+ (current_page+1).out +"&size="+pager.count.out)
				s.append ("<li>")
				s.append (response.link (lnk.title, lnk.location, Void))
				s.append ("</li>")
			end
			create lnk.make ("Last", "nodes/?page="+ number_of_pages.out +"&size="+pager.count.out)
			s.append ("<li>")
			s.append (response.link (lnk.title, lnk.location, Void))
			s.append ("</li>")


			s.append ("</ul>%N")
			s.append ("<div>%N")
			Result := s
		end
end
