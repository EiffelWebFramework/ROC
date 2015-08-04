note
	description: "Summary description for {BAD_REQUEST_ERROR_CMS_RESPONSE}."
	date: "$Date: 2014-12-19 14:17:32 +0100 (ven., 19 déc. 2014) $"
	revision: "$Revision: 96402 $"

class
	BAD_REQUEST_ERROR_CMS_RESPONSE

inherit

	CMS_RESPONSE
		redefine
			custom_prepare
		end

create
	make

feature -- Generation

	custom_prepare (page: CMS_HTML_PAGE)
		do
			page.register_variable (absolute_url (request.percent_encoded_path_info, Void), "request")
			page.set_status_code ({HTTP_STATUS_CODE}.bad_request)
			page.register_variable (page.status_code.out, "code")
		end

feature -- Execution

	process
			-- Computed response message.
		do
			set_title ("Bad request")
			set_page_title ("Bad request")
			set_main_content ("<em>Bad request.</em>")
		end

note
	copyright: "2011-2015, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
