note
	description: "Summary description for {USER_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	USER_HANDLER

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
			l_page: ROC_RESPONSE
		do
				-- Existing node
			create l_page.make (req, "modules/register.tpl")
			l_page.set_value (roc_config.is_web, "web")
			l_page.set_value (roc_config.is_html, "html")
			l_page.send_to (res)
		end

	do_post (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			u_node: CMS_NODE
			l_page: ROC_RESPONSE
		do
				-- New user
			api_service.new_user (extract_data_form (req))
			if api_service.successful then
				(create {ROC_RESPONSE}.make (req, "")).new_response_redirect (req, res, req.absolute_script_url (""))
			else

			end
		end

	do_put (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			u_node: CMS_NODE
		do
		end

	do_delete (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		do
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
			if attached current_user_name (req) then
				create l_page.make (req, "modules/node.tpl")
				l_page.send_to (res)
			else
				(create {ROC_RESPONSE}.make (req, "")).new_response_unauthorized (req, res)
			end
		end

feature -- {NONE} Form data

	extract_data_form (req: WSF_REQUEST): CMS_USER
			-- Extract request form data and build a object
			-- user
		do
			create Result.make ("")
			if attached {WSF_STRING} req.form_parameter ("username") as l_username then
				Result.set_name (l_username)
			end
			if
				attached {WSF_STRING} req.form_parameter ("password") as l_password and then
				attached {WSF_STRING} req.form_parameter ("check_password") as l_check_password and then
				l_password.value.is_case_insensitive_equal (l_check_password.value)
			then
				Result.set_password (l_password)
			end
			if attached {WSF_STRING} req.form_parameter ("email") as l_email then
				Result.set_email (l_email)
			end
		end

end
