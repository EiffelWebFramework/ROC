note
	description: "Summary description for {ROC_RESPONSE}."
	date: "$Date$"
	revision: "$Revision$"

class
	ROC_RESPONSE

inherit

	APP_HANDLER

	TEMPLATE_SHARED

create
	make

feature {NONE} -- Initialization

	make (a_request: WSF_REQUEST; a_template: READABLE_STRING_32)
		do
			request := a_request
			-- Set template to HTML
			set_template_folder (html_path)
				-- Build Common Template
			set_template_file_name (a_template)
					-- Process the current tempate.
			set_value (a_request.absolute_script_url (""), "host")
			if attached current_user_name (request) as l_user then
				set_value (l_user, "user")
			end
		end

feature -- Access

	request: WSF_REQUEST

feature -- Access

	values: STRING_TABLE [detachable ANY]
		do
			Result := template.values
		end

	value (a_key: READABLE_STRING_GENERAL): detachable ANY
		do
			Result := template.values.item (a_key)
		end

feature -- Element change

	set_value (a_value: detachable ANY; a_key: READABLE_STRING_GENERAL)
		do
			template.add_value (a_value, a_key)
		end


feature -- Output

	send_to (res: WSF_RESPONSE)
		do
			process
			if attached representation as l_output then
				new_response (res, l_output, {HTTP_STATUS_CODE}.ok)
			end
		end

	new_response_redirect (req: WSF_REQUEST; res: WSF_RESPONSE; a_location: READABLE_STRING_32)
			-- Redirect to `a_location'
		local
			h: HTTP_HEADER
		do
			create h.make
			h.put_content_type_text_html
			h.put_current_date
			h.put_location (a_location)
			res.set_status_code ({HTTP_STATUS_CODE}.see_other)
			res.put_header_text (h.string)
		end

	new_response_authenticate (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Handle forbidden.
		local
			h: HTTP_HEADER
		do
			create h.make
			h.put_content_type_text_html
			h.put_current_date
			h.put_header_key_value ({HTTP_HEADER_NAMES}.header_www_authenticate, "Basic realm=%"CMS-User%"")
			res.set_status_code ({HTTP_STATUS_CODE}.unauthorized)
			res.put_header_text (h.string)
		end

	new_response_denied (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Handle forbidden.
		local
			h: HTTP_HEADER
		do
			process
			create h.make
			if attached representation as l_output then
				h.put_content_length (l_output.count)
			end

			h.put_content_type_text_html
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.unauthorized)
			res.put_header_text (h.string)
			if attached representation as l_output then
				res.put_string (l_output)
			end
		end


	new_response_unauthorized (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			h: HTTP_HEADER
			output: STRING
		do
			create h.make
			h.put_content_type_text_html
			h.put_current_date
			res.set_status_code ({HTTP_STATUS_CODE}.forbidden)
			res.put_header_text (h.string)
		end


feature {NONE} -- Implemenation

	new_response (res: WSF_RESPONSE; output: STRING; status_code: INTEGER)
		local
			h: HTTP_HEADER
		do
			create h.make
			h.put_content_type_text_html
			h.put_content_length (output.count)
			h.put_current_date
			res.set_status_code (status_code)
			res.put_header_text (h.string)
			res.put_string (output)
		end

end
