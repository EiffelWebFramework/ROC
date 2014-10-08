note
	description: "Summary description for {NODE_HANDLER}."
	date: "$Date$"
	revision: "$Revision$"

class
	NODE_HANDLER

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
				-- Existing node
			if attached {WSF_STRING} req.path_parameter ("id") as l_id then
				if l_id.is_integer and then attached {CMS_NODE} api_service.node (l_id.integer_value) as l_node then
					create {GENERIC_VIEW_CMS_RESPONSE} l_page.make (req, res, setup,"modules/node")
					l_page.add_variable (l_node, "node")
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
			l_page: CMS_RESPONSE
		do
			to_implement ("Check user permissions!!!")
			if attached current_user (req) as l_user then
				if attached {WSF_STRING} req.path_parameter ("id") as l_id then
					if l_id.is_integer and then attached {CMS_NODE} api_service.node (l_id.integer_value) as l_node then
						if attached {WSF_STRING} req.form_parameter ("method") as l_method then
							if l_method.is_case_insensitive_equal ("DELETE") then
								do_delete (req, res)
							elseif l_method.is_case_insensitive_equal ("PUT") then
								do_put (req, res)
							else
								(create {ERROR_500_CMS_RESPONSE}.make (req, res, setup, "master2/error")).execute
							end
						end
					else
						do_error (req, res, l_id)
					end
				else
						-- New node
					u_node := extract_data_form (req)
					u_node.set_author (l_user)
					api_service.new_node (u_node)
					(create {CMS_GENERIC_RESPONSE}).new_response_redirect (req, res, req.absolute_script_url (""))
				end
			else
				(create {CMS_GENERIC_RESPONSE}).new_response_unauthorized (req, res)
			end
		end

	do_put (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			u_node: CMS_NODE
		do

			if attached current_user (req) as l_user then
				if attached {WSF_STRING} req.path_parameter ("id") as l_id then
					if l_id.is_integer and then attached {CMS_NODE} api_service.node (l_id.integer_value) as l_node then
						u_node := extract_data_form (req)
						u_node.set_id (l_id.integer_value)
						api_service.update_node (l_user.id,u_node)
						(create {CMS_GENERIC_RESPONSE}).new_response_redirect (req, res, req.absolute_script_url (""))
					else
						do_error (req, res, l_id)
					end
				else
					(create {ERROR_500_CMS_RESPONSE}.make (req, res, setup, "master2/error")).execute
				end
			else
				(create {CMS_GENERIC_RESPONSE}).new_response_unauthorized (req, res)
			end

		end

	do_delete (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		do
			if attached current_user_name (req) then
				if attached {WSF_STRING} req.path_parameter ("id") as l_id then
					if l_id.is_integer and then attached {CMS_NODE} api_service.node (l_id.integer_value) as l_node then
						api_service.delete_node (l_id.integer_value)
						(create {CMS_GENERIC_RESPONSE}).new_response_redirect (req, res, req.absolute_script_url (""))
					else
						do_error (req, res, l_id)
					end
				else
					(create {ERROR_500_CMS_RESPONSE}.make (req, res, setup, "master2/error")).execute
				end
			else
				(create {CMS_GENERIC_RESPONSE}).new_response_unauthorized (req, res)
			end
		end

feature -- Error

	do_error (req: WSF_REQUEST; res: WSF_RESPONSE; a_id: WSF_STRING)
			-- Handling error.
		local
			l_page: CMS_RESPONSE
		do
			create {GENERIC_VIEW_CMS_RESPONSE} l_page.make (req, res, setup, "master2/error")
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
			if attached current_user_name (req) then
				create {GENERIC_VIEW_CMS_RESPONSE} l_page.make (req, res, setup, "modules/node")
				l_page.add_variable (setup.is_html, "html")
				l_page.add_variable (setup.is_web, "web")
				l_page.execute

			else
				(create {CMS_GENERIC_RESPONSE}).new_response_unauthorized (req, res)
			end
		end

feature -- {NONE} Form data

	extract_data_form (req: WSF_REQUEST): CMS_NODE
			-- Extract request form data and build a object
			-- Node
		do
			create Result.make ("", "", "")
			if attached {WSF_STRING} req.form_parameter ("title") as l_title then
				Result.set_title (l_title.value)
			end
			if attached {WSF_STRING} req.form_parameter ("summary") as l_summary then
				Result.set_summary (l_summary.value)
			end
			if attached {WSF_STRING} req.form_parameter ("content") as l_content then
				Result.set_content (l_content.value)
			end
		end

end