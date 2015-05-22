note
	description: "Request handler related to /blogs."
	author: "Dario Bösch <daboesch@student.ethz.ch>"
	date: "$Date: 2015-05-18 13:49:00 +0100 (lun., 18 mai 2015) $"
	revision: "$9661667$"

class
	BLOG_HANDLER

inherit
	CMS_BLOG_CONFIG

	CMS_BLOG_HANDLER

	WSF_URI_HANDLER
		rename
			execute as uri_execute,
			new_mapping as new_uri_mapping
		end

	WSF_URI_TEMPLATE_HANDLER
		rename
			execute as uri_template_execute,
			new_mapping as new_uri_template_mapping
		select
			new_uri_template_mapping
		end

	WSF_RESOURCE_HANDLER_HELPER
		redefine
			do_get
		end

	REFACTORING_HELPER

	CMS_API_ACCESS

create
	make

feature -- execute

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler
		do
			execute_methods (req, res)
		end

	uri_execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler
		do
			execute (req, res)
		end

	uri_template_execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler
		do
			execute (req, res)
		end

feature -- Global Variables
	page_number: NATURAL_32

feature -- HTTP Methods	
	do_get (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			l_page: CMS_RESPONSE
		do
				-- At the moment the template is hardcoded, but we can
				-- get them from the configuration file and load them into
				-- the setup class.

			-- Read the page number from get variable
			page_number := page_number_path_parameter (req)

			create {GENERIC_VIEW_CMS_RESPONSE} l_page.make (req, res, api)
			l_page.add_variable (node_api.nodes, "nodes")
			l_page.set_main_content (main_content_html(l_page))
			l_page.execute
		end

feature -- Query


	posts : LIST[CMS_NODE]
			-- The posts to list on the given page
		do
			Result := node_api.blogs_order_created_desc_limited (entries_per_page, (page_number-1) * entries_per_page)
		end
		
	more_than_one_page : BOOLEAN
			-- Checks if all posts fit on one page (FALSE) or if more than one page is needed (TRUE)
		do
			Result := entries_per_page < total_entries
		end


	pages : NATURAL_32
			-- Returns the number of pages needed to display all posts
		require
			entries_per_page > 0
		local
			tmp: REAL_32
		do
			tmp := total_entries.to_real_32 / entries_per_page.to_real_32;
			Result := tmp.ceiling.to_natural_32
		end

	page_number_path_parameter (req: WSF_REQUEST): NATURAL_32
			-- Returns the page number from the path /blogs/{page}. It's an unsigned integer since negative pages are not allowed
		local
			s: STRING
		do
			Result := 1 -- default if not get variable is set
			if attached {WSF_STRING} req.path_parameter ("page") as p_page then
				s := p_page.value
				if s.is_natural_32 then
					if s.to_natural_32 > 1 then
						Result := s.to_natural_32
					end
				end
			end
		end

	total_entries : NATURAL_32
			-- Returns the number of total entries/posts
		do
			Result := node_api.blogs_count.to_natural_32
		end

feature -- HTML Output

	main_content_html (page: CMS_RESPONSE) : STRING
			-- Return the content of the page as a html string
		local
			n: CMS_NODE
			lnk: CMS_LOCAL_LINK
		do
			-- Output the title. If more than one page, also output the current page number
			create Result.make_from_string (page_title_html)

			-- Get the posts from the current page (given by page number and entries per page)
			if attached posts as lst then

					-- List all posts of the blog
					Result.append ("<ul class=%"cms_blog_nodes%">%N")
					across
						lst as ic
					loop
						n := ic.item
						lnk := node_api.node_link (n)
						Result.append ("<li class=%"cms_type_"+ n.content_type +"%">")

						-- Output the creation date
						Result.append (creation_date_html(n))

						-- Output the author of the post
						Result.append (author_html(n))

						-- Output the title of the post as a link (to the detail page)
						Result.append (title_html(n, page))

						-- Output the summary of the post and a more link to the detail page
						Result.append (summary_html(n, page))

						Result.append ("</li>%N")
					end

					-- End of post list
					Result.append ("</ul>%N")

					-- Pagination
					Result.append (pagination_html)

				--end
			end
		end

	page_title_html : STRING
			-- Returns the title of the page as a html string. It shows the current page number
		do
			create Result.make_from_string ("<h2>Blog")
			if more_than_one_page then
				Result.append (" (Page " + page_number.out + " of " + pages.out + ")")
				-- Get the posts from the current page (limited by entries per page)
			end
			Result.append ("</h2>")
		end

	creation_date_html (n: CMS_NODE) : STRING
			-- returns the creation date. At the moment hard coded as html
		local
			hdate: HTTP_DATE
		do
			Result := ""
			if attached n.creation_date as l_modified then
				create hdate.make_from_date_time (l_modified)
				Result.append (hdate.yyyy_mmm_dd_string)
				Result.append (" ")
			end
		end

	author_html (n: CMS_NODE) : STRING
			-- returns a html string with a link to the autors posts
		do
			Result := ""
			if attached n.author as l_author then
				Result.append ("by ")
				Result.append ("<a class=%"blog_user_link%" href=%"/blogs/user/" + l_author.id.out + "%">" + l_author.name + "</a>")
			end
		end

	title_html (n: CMS_NODE;  page : CMS_RESPONSE) : STRING
			-- returns a html string the title of the node that links on the detail page
		local
			lnk: CMS_LOCAL_LINK
		do
			lnk := node_api.node_link (n)
			Result := "<span class=%"blog_title%">"
			Result.append (page.link (lnk.title, lnk.location, Void))
			Result.append ("</span>")
		end

	summary_html (n: CMS_NODE;  page : CMS_RESPONSE) : STRING
			-- returns a html string with the summary of the node and a link to the detail page
		local
			lnk: CMS_LOCAL_LINK
		do
			Result := ""
			lnk := node_api.node_link (n)
			if attached n.summary as l_summary then
				Result.append ("<p class=%"blog_list_summary%">")
				if attached api.format (n.format) as f then
					Result.append (f.formatted_output (l_summary))
				else
					Result.append (page.formats.default_format.formatted_output (l_summary))
				end
				Result.append ("<br />")
				Result.append (page.link ("See more...", lnk.location, Void))
				Result.append ("</p>")
			end
		end

	pagination_html : STRING
			-- returns a html string with the pagination links (if necessary)
		local
			tmp: NATURAL_32
		do
			Result := ""
			if more_than_one_page then

				Result.append ("<div class=%"pagination%">")

				-- If exist older posts show link to next page
				if page_number < pages then
					tmp := page_number + 1
					Result.append (" <a class=%"blog_older_posts%" href=%"/blogs/page/" + tmp.out + "%"><< Older Posts</a> ")
				end

				-- Delmiter
				if page_number < pages AND page_number > 1 then
					Result.append (" | ")
				end

				-- If exist newer posts show link to previous page
				if page_number > 1 then
					tmp := page_number -1
					Result.append (" <a class=%"blog_newer_posts%" href=%"/blogs/page/" + tmp.out + "%">Newer Posts >></a> ")
				end

				Result.append ("</div>")

			end

		end

end
