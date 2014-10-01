note
	description: "Summary description for {NEW_CONTENT_HANDLER}."
	date: "$Date$"
	revision: "$Revision$"

class
	NODE_CONTENT_HANDLER

inherit

	CMS_HANDLER

	WSF_FILTER

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
			do_put
		end

	REFACTORING_HELPER

create
	make

feature -- execute

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler
		do
			execute_methods (req, res)
			execute_next (req, res)
		end

	uri_execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler
		do
			execute_methods (req, res)
		end

	uri_template_execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler
		do
			execute_methods (req, res)
		end

feature -- HTTP Methods

	do_get (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			l_page: CMS_RESPONSE
		do
			if attached current_user_name (req) then
					-- Existing node
				if attached {WSF_STRING} req.path_parameter ("id") as l_id then
					if l_id.is_integer and then attached {CMS_NODE} api_service.node (l_id.integer_value) as l_node then
						create {NODE_VIEW_CMS_RESPONSE} l_page.make (req, res, setup, "modules/node_content")
						l_page.add_variable (l_node.content, "content")
						l_page.add_variable (l_id.value, "id")
						l_page.execute
					else
						do_error (req, res, l_id)
					end
				else
						-- Todo extract method
					to_implement ("Check how to implemet API error")
--					create l_page.make (req, "master2/error.tpl")
--					l_page.set_value ("500", "code")
--					l_page.set_value (req.absolute_script_url (req.path_info), "request")
--					l_page.send_to (res)
				end
			else
				(create {CMS_GENERIC_RESPONSE}).new_response_unauthorized (req, res)
			end
		end


	do_post (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			u_node: CMS_NODE
		do
			if attached current_user_name (req) then
				if attached {WSF_STRING} req.path_parameter ("id") as l_id then
					if l_id.is_integer and then attached {CMS_NODE} api_service.node (l_id.integer_value) as l_node then
						if attached {WSF_STRING} req.form_parameter ("method") as l_method then
							if l_method.is_case_insensitive_equal ("PUT") then
								do_put (req, res)
							else
								to_implement ("Check how to implement API error")
--								create l_page.make (req, "master2/error.tpl")
--								l_page.set_value ("500", "code")
--								l_page.set_value (req.absolute_script_url (req.path_info), "request")
--								l_page.send_to (res)
							end
						end
					else
						do_error (req, res, l_id)
					end
				else
					to_implement ("Check how to implement API error")
--					create l_page.make (req, "master2/error.tpl")
--					l_page.set_value ("500", "code")
--					l_page.set_value (req.absolute_script_url (req.path_info), "request")
--					l_page.send_to (res)
				end
			else
				(create {CMS_GENERIC_RESPONSE}).new_response_unauthorized (req, res)
			end
		end

	do_put (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			u_node: CMS_NODE
--			l_page: ROC_RESPONSE
		do
			to_implement ("Check if user has permissions")
			if attached current_user (req) as l_user then
				if attached {WSF_STRING} req.path_parameter ("id") as l_id then
					if l_id.is_integer and then attached {CMS_NODE} api_service.node (l_id.integer_value) as l_node then
						u_node := extract_data_form (req)
						u_node.set_id (l_id.integer_value)
						api_service.update_node_content (l_user.id, u_node.id, u_node.content)
						(create {CMS_GENERIC_RESPONSE}).new_response_redirect (req, res, req.absolute_script_url (""))
					else
						do_error (req, res, l_id)
					end
				else
					to_implement ("Check how to implement API error")
--					create l_page.make (req, "master2/error.tpl")
--					l_page.set_value ("500", "code")
--					l_page.set_value (req.absolute_script_url (req.path_info), "request")
--					l_page.send_to (res)
				end
			else
				(create {CMS_GENERIC_RESPONSE}).new_response_unauthorized (req, res)
			end
		end
feature -- Error

	do_error (req: WSF_REQUEST; res: WSF_RESPONSE; a_id: WSF_STRING)
			-- Handling error.
		local
		do
			to_implement ("Check how to implement API error")
--			create l_page.make (req, "master2/error.tpl")
--			if a_id.is_integer then
--				-- resource not found
--				l_page.set_value ("404", "code")
--			else
--				-- bad request
--				l_page.set_value ("400", "code")
--			end
--			l_page.set_value (req.absolute_script_url (req.path_info), "request")
--			l_page.send_to(res)
		end


feature -- {NONE} Form data


	extract_data_form (req: WSF_REQUEST): CMS_NODE
			-- Extract request form data and build a object
			-- Node
		do
			create Result.make ("", "", "")
			if attached {WSF_STRING}req.form_parameter ("content") as l_content then
				Result.set_content (l_content.value)
			end
		end

end
