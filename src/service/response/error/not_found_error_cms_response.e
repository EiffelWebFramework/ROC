note
	description: "Summary description for {NOT_FOUND_ERROR_CMS_RESPONSE}."
	date: "$Date: 2014-11-13 19:34:00 +0100 (jeu., 13 nov. 2014) $"
	revision: "$Revision: 96086 $"

class
	NOT_FOUND_ERROR_CMS_RESPONSE

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
			page.register_variable (absolute_url (request.path_info, Void), "request")
			page.set_status_code ({HTTP_STATUS_CODE}.not_found)
			page.register_variable (page.status_code.out, "code")
		end

feature -- Execution

	process
			-- Computed response message.
		do
			set_title ("Not Found")
			set_page_title ("Not Found")
			set_main_content ("<em>The requested page could not be found.</em>")
		end
end

