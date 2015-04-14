note
	description: "CMS handler for a node."
	date: "$Date: 2015-02-13 13:08:13 +0100 (ven., 13 févr. 2015) $"
	revision: "$Revision: 96616 $"

class
	NODE_HANDLER

inherit
	CMS_NODE_HANDLER

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
			do_get,
			do_post,
			do_put,
			do_delete
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

feature -- HTTP Methods

	do_get (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			l_page: CMS_RESPONSE
			s: STRING
			hdate: HTTP_DATE
		do
				-- Existing node
			if attached {WSF_STRING} req.path_parameter ("id") as l_id then
				if
					l_id.is_integer and then
					attached {CMS_NODE} node_api.node (l_id.value.to_integer_64) as l_node
				then
						-- FIXME: there is a mix between CMS interface and API interface here.
					create {GENERIC_VIEW_CMS_RESPONSE} l_page.make (req, res, api)
					l_page.add_variable (l_node, "node")

					create s.make_empty
					s.append ("<div class=%"info%"> ")
					if attached l_node.author as l_author then
						s.append (" by ")
						s.append (l_author.name)
					end
					if attached l_node.modification_date as l_modified then
						s.append (" (modified: ")
						create hdate.make_from_date_time (l_modified)
						s.append (hdate.yyyy_mmm_dd_string)
						s.append (")")
					end
					s.append ("</div>")
					if attached l_node.content as l_content then
						s.append ("<p class=%"content%">")
						s.append (api.formats.item (l_node.format).formatted_output (l_content))
						s.append ("</p>")
					end
					if attached {CMS_PAGE} l_node as l_node_page then
						if attached l_node_page.parent as l_parent_node then
							s.append ("<div>Parent page is ")
							s.append (l_page.link (l_parent_node.title + " (#" + l_parent_node.id.out + ")", node_api.node_path (l_parent_node), Void))
							s.append ("</div>")
						end
					end
					l_page.set_title (l_node.title)
					l_page.set_main_content (s)
					l_page.execute
				else
					do_error (req, res, l_id)
				end
			else
					-- Factory
				new_node (req, res)
			end
		end

	do_post (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			u_node: CMS_NODE
		do
			to_implement ("Check user permissions!!!")
			if attached current_user (req) as l_user then
				if attached {WSF_STRING} req.path_parameter ("id") as l_id then
					if
						l_id.is_integer and then
						attached node_api.node (l_id.value.to_integer_64) as l_node
					then
						if attached {WSF_STRING} req.form_parameter ("method") as l_method then
							if l_method.is_case_insensitive_equal ("DELETE") then
								do_delete (req, res)
							elseif l_method.is_case_insensitive_equal ("PUT") then
								do_put (req, res)
							else
								(create {INTERNAL_SERVER_ERROR_CMS_RESPONSE}.make (req, res, api)).execute
							end
						end
					else
						do_error (req, res, l_id)
					end
				else
						-- New node
						-- FIXME !!!
					if attached {WSF_STRING} req.form_parameter ("type") as p_type then
						if attached node_api.content_type (p_type.value) as ct then
						end
						create {CMS_PARTIAL_NODE} u_node.make_empty (p_type.url_encoded_value)
					else
						create {CMS_PARTIAL_NODE} u_node.make_empty ("")
					end

					update_node_from_data_form (req, u_node)
					u_node.set_author (l_user)
					node_api.new_node (u_node)
					redirect_to (req.absolute_script_url (""), res)
				end
			else
				send_access_denied (res)
			end
		end

	do_put (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		do

			if attached current_user (req) as l_user then
				if attached {WSF_STRING} req.path_parameter ("id") as l_id then
					if
						l_id.is_integer and then
						attached node_api.node (l_id.value.to_integer_64) as l_node
					then
						update_node_from_data_form (req, l_node)
						l_node.set_author (l_user)
						node_api.update_node (l_node)
						redirect_to (req.absolute_script_url (""), res)
					else
						do_error (req, res, l_id)
					end
				else
					(create {INTERNAL_SERVER_ERROR_CMS_RESPONSE}.make (req, res, api)).execute
				end
			else
				send_access_denied (res)
			end
		end

	do_delete (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		do
			if attached current_user_name (req) then
				if attached {WSF_STRING} req.path_parameter ("id") as l_id then
					if
						l_id.is_integer and then
						attached node_api.node (l_id.integer_value) as l_node
					then
						node_api.delete_node (l_node)
						res.send (create {CMS_REDIRECTION_RESPONSE_MESSAGE}.make (req.absolute_script_url ("")))
					else
						do_error (req, res, l_id)
					end
				else
					(create {INTERNAL_SERVER_ERROR_CMS_RESPONSE}.make (req, res, api)).execute
				end
			else
				send_access_denied (res)
			end
		end

feature -- Error

	do_error (req: WSF_REQUEST; res: WSF_RESPONSE; a_id: WSF_STRING)
			-- Handling error.
		local
			l_page: CMS_RESPONSE
		do
			create {GENERIC_VIEW_CMS_RESPONSE} l_page.make (req, res, api)
			l_page.add_variable (req.absolute_script_url (req.path_info), "request")
			if a_id.is_integer then
					-- resource not found
				l_page.add_variable ("404", "code")
				l_page.set_status_code (404)
			else
					-- bad request
				l_page.add_variable ("400", "code")
				l_page.set_status_code (400)
			end
			l_page.execute
		end

feature {NONE} -- Node

	new_node (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_page: CMS_RESPONSE
		do
			if api.user_has_permission (current_user (req), "create node") then
				create {GENERIC_VIEW_CMS_RESPONSE} l_page.make (req, res, api)
				l_page.execute
			else
				send_access_denied (res)
			end
		end

feature -- {NONE} Form data

	update_node_from_data_form (req: WSF_REQUEST; a_node: CMS_NODE)
			-- Extract request form data and build a object
			-- Node
		local
			l_title: detachable READABLE_STRING_32
			l_summary, l_content, l_format: detachable READABLE_STRING_8
		do
			if attached {WSF_STRING} req.form_parameter ("title") as p_title then
				l_title := p_title.value
				a_node.set_title (l_title)
			end
			if attached {WSF_STRING} req.form_parameter ("summary") as p_summary then
				l_summary := html_encoded (p_summary.value)
			end
			if attached {WSF_STRING} req.form_parameter ("content") as p_content then
				l_content := html_encoded (p_content.value)
			end
			if attached {WSF_STRING} req.form_parameter ("format") as p_format then
				l_format := p_format.url_encoded_value
			end
			if l_format = Void then
				l_format := a_node.format
			end
			a_node.set_content (l_content, l_summary, l_format)
		end

end
