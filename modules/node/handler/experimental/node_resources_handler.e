note
	description: "Request handler related to /nodes."
	date: "$Date: 2015-02-13 13:08:13 +0100 (ven., 13 févr. 2015) $"
	revision: "$Revision: 96616 $"

class
	NODE_RESOURCES_HANDLER

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
			l_page: CMS_RESPONSE
			s: STRING
		do
				-- At the moment the template is hardcoded, but we can
				-- get them from the configuration file and load them into
				-- the setup class.

			create {GENERIC_VIEW_CMS_RESPONSE} l_page.make (req, res, api)
			l_page.add_variable (node_api.nodes, "nodes")


				-- NOTE: for development purposes we have the following hardcode output.
			create s.make_from_string ("<p>Nodes:</p>")
			if attached node_api.nodes as lst then
				across
					lst as ic
				loop
					s.append ("<li>")
					s.append ("<a href=%"")
					s.append (req.script_url ("/node/" + ic.item.id.out))
					s.append ("%">")
					s.append (api.html_encoded (ic.item.title))
					s.append (" (")
					s.append (ic.item.id.out)
					s.append (")")
					s.append ("</a>")
					s.append ("</li>%N")
				end
			end

			l_page.set_main_content (s)
			l_page.add_block (create {CMS_CONTENT_BLOCK}.make ("nodes_warning", Void, "/nodes/ is not yet fully implemented<br/>", Void), "highlighted")
			l_page.execute
		end

end
