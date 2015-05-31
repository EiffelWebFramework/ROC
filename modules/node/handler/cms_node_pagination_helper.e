note
	description: "Helper class to build the html pagination links and header summary"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_NODE_PAGINATION_HELPER

create
	make

feature {NONE} -- Initialization

	make (a_resource: READABLE_STRING_8; req: WSF_REQUEST; a_response: CMS_RESPONSE; a_nodes_count: INTEGER_64)
			-- Create an object with default values.
		do
			make_size (a_resource, req, a_response, a_nodes_count, 5)
		end

	make_size (a_resource: READABLE_STRING_8; req: WSF_REQUEST; a_response: CMS_RESPONSE; a_nodes_count: INTEGER_64; a_page_size: NATURAL)
			-- Create an object with a pages of size `a_page_size'.
		do
			create resource.make_from_string (a_resource)
			number_of_nodes := a_nodes_count
			create pager.make (0, a_page_size)
			response := a_response
			process (req)
		end

	process (req: WSF_REQUEST)
			-- Process request query paraments to build the pager.
		do
				--TODO: at the moment the code looks for hardcoded parameters
				-- size and page, maybe we can parametrize these names.
				-- Size:limit.
			if
				attached {WSF_STRING} req.query_parameter ("size") as l_size and then
				attached l_size.value as l_value and then
				l_value.is_natural
			then
				pager.set_size (l_value.to_natural_32)
			end

				--Page:offset
			if
				attached {WSF_STRING} req.query_parameter ("page") as l_page and then
				l_page.is_integer
			then
				current_page := l_page.integer_value
				if current_page > 1 then
					pager.set_offset ((current_page - 1).to_natural_32 * pager.size)
				end
			else
				current_page := 1
			end
		end

feature -- Access

	pager: CMS_PAGINATION
			-- Paginator.

	resource: IMMUTABLE_STRING_8

	current_page: INTEGER
			-- current page.

	number_of_pages: INTEGER_64
			-- total number of pages.
		do
			Result := (number_of_nodes // pager.size.as_integer_32) + 1
		end

	number_of_nodes: INTEGER_64
			-- number of nodes.

	response: CMS_RESPONSE
			-- cms response

feature -- Parameters			

	page_parameter: STRING = "page"

	size_parameter: STRING = "size"

feature -- Paginator

	append_pagination_summary_to (a_output: STRING)
			-- Header summary
			-- Current page 1 of n pages.
		do
			a_output.append ("<p>Items:</p>")

			a_output.append ("<p>Current Page:")
			a_output.append_integer (current_page)
			a_output.append (" of ")
			a_output.append_integer_64 (number_of_pages)
			a_output.append (" pages</p>")
		end

	append_html_pager_to (a_output: STRING)
			-- Append html pager to `a_output'.
			-- note: First, [Prev], [Next], Last.
		local
			lnk: CMS_LOCAL_LINK
			s: STRING
		do
				-- NOTE: for development purposes we have the following hardcode output.
				-- pager
			a_output.append ("<ul class=%"pager%">%N")
			create s.make_from_string (resource)
			append_query_parameters_to (s, "1", pager.size.out)
			create lnk.make ("First", s)
			a_output.append ("<li>")
			a_output.append (response.link (lnk.title, lnk.location, Void))
			a_output.append ("</li>")
			if (current_page - 1) > 1 then
				create s.make_from_string (resource)
				append_query_parameters_to (s, (current_page - 1).out, pager.size.out)

				create lnk.make ("Prev", s)
				a_output.append ("<li>")
				a_output.append (response.link (lnk.title, lnk.location, Void))
				a_output.append ("</li>")
			end

			if (current_page + 1) < number_of_pages then
				create s.make_from_string (resource)
				append_query_parameters_to (s, (current_page + 1).out, pager.size.out)
				create lnk.make ("Next", s)
				a_output.append ("<li>")
				a_output.append (response.link (lnk.title, lnk.location, Void))
				a_output.append ("</li>")
			end
			create s.make_from_string (resource)
			append_query_parameters_to (s, number_of_pages.out, pager.size.out)
			create lnk.make ("Last", s)
			a_output.append ("<li>")
			a_output.append (response.link (lnk.title, lnk.location, Void))
			a_output.append ("</li>")

			a_output.append ("</ul>%N")
		end

	append_query_parameters_to (s: STRING; a_page: STRING; a_size: STRING)
		do
			if s.has ('?') then
				s.append ("&")
			else
				s.append ("?")
			end
			s.append (page_parameter)
			s.append_character ('=')
			s.append (a_page)
			s.append_character ('&')
			s.append (size_parameter)
			s.append_character ('=')
			s.append (a_size)
		end

end
