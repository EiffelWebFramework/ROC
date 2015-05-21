note
	description: "Request handler related to /blogs."
	author: "Dario Bösch <daboesch@student.ethz.ch"
	date: "$Date: 2015-05-18 13:49:99 +0100 (lun., 18 mai 2015) $"
	revision: "$966167$"

class
	BLOG_HANDLER

inherit
	NODES_HANDLER
		redefine
			do_get
		end

create
	make

feature -- HTTP Methods	
	do_get (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			l_page: CMS_RESPONSE
			s: STRING
			n: CMS_NODE
			lnk: CMS_LOCAL_LINK
			hdate: HTTP_DATE
		do
				-- At the moment the template is hardcoded, but we can
				-- get them from the configuration file and load them into
				-- the setup class.

			create {GENERIC_VIEW_CMS_RESPONSE} l_page.make (req, res, api)
			l_page.add_variable (node_api.nodes, "nodes")


				-- NOTE: for development purposes we have the following hardcode output.
			create s.make_from_string ("<h2>Blog entries:</h2>")
			if attached node_api.nodes_order_created_desc as lst then
				-- Filter out blog entries from all nodes
				--if n.content_type.is_equal ("blog") then
					s.append ("<ul class=%"cms-blog-nodes%">%N")
					across
						lst as ic
					loop
						n := ic.item
						if n.content_type.is_equal ("blog") then
							lnk := node_api.node_link (n)
							s.append ("<li class=%"cms_type_"+ n.content_type +"%">")

							-- Post date (creation)
							if attached n.creation_date as l_modified then
								create hdate.make_from_date_time (l_modified)
								s.append (hdate.yyyy_mmm_dd_string)
								s.append (" ")
							end

							-- Author
							if attached n.author as l_author then
								s.append ("by ")
								s.append (l_author.name)
							end

							-- Title with link
							s.append (l_page.link (lnk.title, lnk.location, Void))

							-- Summary
							if attached n.summary as l_summary then
								s.append ("<p class=%"blog_list_summary%">")
								if attached api.format (n.format) as f then
									s.append (f.formatted_output (l_summary))
								else
									s.append (l_page.formats.default_format.formatted_output (l_summary))
								end
								s.append ("<br />")
								s.append (l_page.link ("More...", lnk.location, Void))
								s.append ("</p>")
							end

							s.append ("</li>%N")
						end
					end
					s.append ("</ul>%N")
				--end
			end

			l_page.set_main_content (s)
			l_page.add_block (create {CMS_CONTENT_BLOCK}.make ("nodes_warning", Void, "/blogs/ is not yet fully implemented<br/>", Void), "highlighted")
			l_page.execute
		end


end
