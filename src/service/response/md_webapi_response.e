note
	description: "Summary description for Microdata {MD_WEBAPI_RESPONSE}."
	date: "$Date$"
	revision: "$Revision$"

class
	MD_WEBAPI_RESPONSE

inherit
	HM_WEBAPI_RESPONSE
		redefine
			initialize
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create resource.make
		end

feature -- Access

	resource: MD_DOCUMENT

feature -- Element change

	add_self (a_href: READABLE_STRING_8)
		do
			add_field ("self", a_href)
		end

	add_field (a_name: READABLE_STRING_GENERAL; a_value: READABLE_STRING_GENERAL)
		local
			p: MD_PROPERTY
		do
			create p.make ("self", a_value, Void)
			resource.put (p)
		end

	add_link (rel: READABLE_STRING_8; a_attname: READABLE_STRING_8 ; a_att_href: READABLE_STRING_8)
		local
			i: MD_ITEM
		do
			-- TODO
		end

feature -- Execution

	execute
		local
			m: WSF_PAGE_RESPONSE
		do
				-- TODO
			create m.make_with_body ("NOT IMPLEMENTED")
			m.set_status_code ({HTTP_STATUS_CODE}.not_implemented)
			m.header.put_content_type ("application/xhtml+xml")
			response.send (m)
		end

invariant

note
	copyright: "2011-2017, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
