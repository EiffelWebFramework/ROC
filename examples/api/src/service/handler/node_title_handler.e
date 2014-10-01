note
	description: "Summary description for {NODE_TITLE_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NODE_TITLE_HANDLER

inherit

	APP_ABSTRACT_HANDLER
		rename
			set_esa_config as make
		end

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
			l_page: ROC_RESPONSE
		do
			if attached current_user_name (req) as l_user then
					-- Existing node
				if attached {WSF_STRING} req.path_parameter ("id") as l_id then
					if l_id.is_integer and then attached {CMS_NODE} api_service.node (l_id.integer_value) as l_node then
						create l_page.make (req, "modules/node_title.tpl")
						l_page.set_value (l_node.title, "title")
						l_page.set_value (l_id.value, "id")
						l_page.set_value (roc_config.is_web, "web")
						l_page.set_value (roc_config.is_html, "html")
						l_page.send_to (res)
					else
						do_error (req, res, l_id)
					end
				else
					create l_page.make (req, "master2/error.tpl")
					l_page.set_value ("500", "code")
					l_page.set_value (req.absolute_script_url (req.path_info), "request")
					l_page.send_to (res)
				end
			else
				(create {ROC_RESPONSE}.make(req,"")).new_response_unauthorized (req, res)
			end
		end

	do_post (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			u_node: CMS_NODE
			l_page: ROC_RESPONSE
		do
			if attached current_user_name (req) as l_user then
				if attached {WSF_STRING} req.path_parameter ("id") as l_id then
					if l_id.is_integer and then attached {CMS_NODE} api_service.node (l_id.integer_value) as l_node then
						if attached {WSF_STRING} req.form_parameter ("method") as l_method then
							if l_method.is_case_insensitive_equal ("PUT") then
								do_put (req, res)
							else
								create l_page.make (req, "master2/error.tpl")
								l_page.set_value ("500", "code")
								l_page.set_value (req.absolute_script_url (req.path_info), "request")
								l_page.send_to (res)
							end
						end
					else
						do_error (req, res, l_id)
					end
				else
					create l_page.make (req, "master2/error.tpl")
					l_page.set_value ("500", "code")
					l_page.set_value (req.absolute_script_url (req.path_info), "request")
					l_page.send_to (res)
				end
			else
				(create {ROC_RESPONSE}.make(req,"")).new_response_unauthorized (req, res)
			end
		end

	do_put (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			u_node: CMS_NODE
			l_page: ROC_RESPONSE
		do
			to_implement ("Check if user has permissions")
			if attached current_user (req) as l_user then
				if attached {WSF_STRING} req.path_parameter ("id") as l_id then
					if l_id.is_integer and then attached {CMS_NODE} api_service.node (l_id.integer_value) as l_node then
						u_node := extract_data_form (req)
						u_node.set_id (l_id.integer_value)
						api_service.update_node_title (l_user.id,u_node.id, u_node.title)
						(create {ROC_RESPONSE}.make (req, "")).new_response_redirect (req, res, req.absolute_script_url (""))
					else
						do_error (req, res, l_id)
					end
				else
					create l_page.make (req, "master2/error.tpl")
					l_page.set_value ("500", "code")
					l_page.set_value (req.absolute_script_url (req.path_info), "request")
					l_page.send_to (res)
				end
			else
				(create {ROC_RESPONSE}.make(req,"")).new_response_unauthorized (req, res)
			end
		end

feature -- Error

	do_error (req: WSF_REQUEST; res: WSF_RESPONSE; a_id: WSF_STRING)
			-- Handling error.
		local
			l_page: ROC_RESPONSE
		do
			create l_page.make (req, "master2/error.tpl")
			if a_id.is_integer then
					-- resource not found
				l_page.set_value ("404", "code")
			else
					-- bad request
				l_page.set_value ("400", "code")
			end
			l_page.set_value (req.absolute_script_url (req.path_info), "request")
			l_page.send_to (res)
		end

feature {NONE} -- Node

	new_node (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_page: ROC_RESPONSE
		do
			create l_page.make (req, "modules/node.tpl")
			l_page.send_to (res)
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
		end

end
