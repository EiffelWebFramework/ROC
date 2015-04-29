note
	description: "[
			handler for CMS node in the CMS interface.
			
			TODO: implement REST API.		
			]"
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
			l_node: detachable CMS_NODE
			l_nid: INTEGER_64
			edit_response: NODE_FORM_RESPONSE
			view_response: NODE_VIEW_RESPONSE
		do
			if req.path_info.ends_with_general ("/edit") then
				create edit_response.make (req, res, api, node_api)
				edit_response.execute
			else
					-- Existing node
				if attached {WSF_STRING} req.path_parameter ("id") as l_id then
					if l_id.is_integer then
						l_nid := l_id.value.to_integer_64
					end
				end
				if l_nid > 0 then
					l_node := node_api.node (l_nid)
				end
				if l_node /= Void then
					create view_response.make (req, res, api, node_api)
					view_response.set_node (l_node)
					view_response.execute
				elseif l_nid > 0 then --| i.e: l_node = Void
					send_not_found (req, res)
				else
--					send_bad_request (req, res)
						-- FIXME: should not be accepted
						-- Factory
					create_new_node (req, res)
				end
			end
		end

	do_post (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			edit_response: NODE_FORM_RESPONSE
		do
			if req.path_info.ends_with_general ("/edit") then
				create edit_response.make (req, res, api, node_api)
				edit_response.execute
			elseif req.path_info.starts_with_general ("/node/add/") then
				create edit_response.make (req, res, api, node_api)
				edit_response.execute
			else
				handle_not_implemented ("REST API not yet implemented", req, res)
--				to_implement ("Check user permissions!!!")
--				if attached current_user (req) as l_user then
--					if attached {WSF_STRING} req.path_parameter ("id") as l_id then
--						if
--							l_id.is_integer and then
--							attached node_api.node (l_id.value.to_integer_64) as l_node
--						then
--							if attached {WSF_STRING} req.form_parameter ("method") as l_method then
--								if l_method.is_case_insensitive_equal ("DELETE") then
--									do_delete (req, res)
--								elseif l_method.is_case_insensitive_equal ("PUT") then
--									do_put (req, res)
--								else
--									process_node_update (req, res, l_user, l_node)
--										-- Accept this, even if this is not proper usage of POST
--	--								(create {INTERNAL_SERVER_ERROR_CMS_RESPONSE}.make (req, res, api)).execute
--								end
--							end
--						else
--							do_error (req, res, l_id)
--						end
--					else
--						process_node_creation (req, res, l_user)
--					end
--				else
--					send_access_denied (req, res)
--				end
			end
		end

	do_put (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		do
			handle_not_implemented ("REST API not yet implemented", req, res)
--			if attached current_user (req) as l_user then
--				if attached {WSF_STRING} req.path_parameter ("id") as l_id then
--					if
--						l_id.is_integer and then
--						attached node_api.node (l_id.value.to_integer_64) as l_node
--					then
--						process_node_update (req, res, l_user, l_node)
--					else
--						do_error (req, res, l_id)
--					end
--				else
--					(create {INTERNAL_SERVER_ERROR_CMS_RESPONSE}.make (req, res, api)).execute
--				end
--			else
--				send_access_denied (req, res)
--			end
		end

	do_delete (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		do
			if attached current_user (req) as l_user then
				if attached {WSF_STRING} req.path_parameter ("id") as l_id then
					if
						l_id.is_integer and then
						attached node_api.node (l_id.integer_value) as l_node
					then
						if api.user_has_permission (l_user, "delete " + l_node.content_type) then
							node_api.delete_node (l_node)
							res.send (create {CMS_REDIRECTION_RESPONSE_MESSAGE}.make (req.absolute_script_url ("")))
						else
							send_access_denied (req, res)
						end
					else
						do_error (req, res, l_id)
					end
				else
					(create {INTERNAL_SERVER_ERROR_CMS_RESPONSE}.make (req, res, api)).execute
				end
			else
				send_access_denied (req, res)
			end
		end

	process_node_creation (req: WSF_REQUEST; res: WSF_RESPONSE; a_user: CMS_USER)
		local
--			u_node: CMS_NODE
		do
				-- New node
				-- FIXME !!!
			handle_not_implemented ("REST API not yet implemented", req, res)
--			if
--				attached {WSF_STRING} req.form_parameter ("type") as p_type and then
--				attached node_api.node_type (p_type.value) as ct  -- should be string 8 value.
--			then
--				if api.user_has_permission (a_user, "create " + ct.name) then
--					u_node := ct.new_node (Void)
--	--						create {CMS_PARTIAL_NODE} u_node.make_empty (p_type.url_encoded_value)
--					update_node_from_data_form (req, u_node)
--					u_node.set_author (a_user)
--					node_api.new_node (u_node)
--					if attached {WSF_STRING} req.item ("destination") as p_destination then
--						redirect_to (req.absolute_script_url (p_destination.url_encoded_value), res)
--					else
--						redirect_to (req.absolute_script_url (""), res)
--					end
--				else
--					send_access_denied (req, res)
--				end
--			else
--				do_error (req, res, Void)
--			end
		end

--	process_node_update (req: WSF_REQUEST; res: WSF_RESPONSE; a_user: CMS_USER; a_node: CMS_NODE)
--		do
--			if api.user_has_permission (a_user, "modify " + a_node.content_type) then
--				update_node_from_data_form (req, a_node)
--				a_node.set_author (a_user)
--				node_api.update_node (a_node)
--				if attached {WSF_STRING} req.item ("destination") as p_destination then
--					redirect_to (req.absolute_script_url (p_destination.url_encoded_value), res)
--				else
--					redirect_to (req.absolute_script_url (""), res)
--				end
--			else
--				send_access_denied (req, res)
--			end
--		end

feature -- Error

	do_error (req: WSF_REQUEST; res: WSF_RESPONSE; a_id: detachable WSF_STRING)
			-- Handling error.
		local
			l_page: CMS_RESPONSE
		do
			create {GENERIC_VIEW_CMS_RESPONSE} l_page.make (req, res, api)
			l_page.add_variable (req.absolute_script_url (req.path_info), "request")
			if a_id /= Void and then a_id.is_integer then
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

	create_new_node (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_gen_page: GENERIC_VIEW_CMS_RESPONSE
			edit_response: NODE_FORM_RESPONSE
			s: STRING
		do
			if req.path_info.starts_with_general ("/node/add/") then
				create edit_response.make (req, res, api, node_api)
				edit_response.execute
			elseif req.is_get_request_method then
				redirect_to (req.absolute_script_url ("/node/add/"), res)
			else
				send_bad_request (req, res)
			end
		end

feature -- {NONE} Form data

--	update_node_from_data_form (req: WSF_REQUEST; a_node: CMS_NODE)
--			-- Extract request form data and build a object
--			-- Node
--		local
--			l_title: detachable READABLE_STRING_32
--			l_summary, l_content, l_format: detachable READABLE_STRING_8
--		do
--			if attached {WSF_STRING} req.form_parameter ("title") as p_title then
--				l_title := p_title.value
--				a_node.set_title (l_title)
--			end
--			if attached {WSF_STRING} req.form_parameter ("summary") as p_summary then
--				l_summary := html_encoded (p_summary.value)
--			end
--			if attached {WSF_STRING} req.form_parameter ("content") as p_content then
--				l_content := html_encoded (p_content.value)
--			end
--			if attached {WSF_STRING} req.form_parameter ("format") as p_format then
--				l_format := p_format.url_encoded_value
--			end
--			if l_format = Void then
--				l_format := a_node.format
--			end
--			a_node.set_content (l_content, l_summary, l_format)
--		end


end
