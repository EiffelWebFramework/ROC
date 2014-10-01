note
	description: "Summary description for {WSF_CMS_THEME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_THEME

feature {NONE} -- Access

	setup:  CMS_SETUP

feature -- Access

	name: STRING
		deferred
		end

	regions: ARRAY [STRING]
		deferred
		end

	page_template: CMS_TEMPLATE
		deferred
		end

feature -- Conversion

	page_html (page: CMS_HTML_PAGE): STRING_8
			-- Render `page' as html.
		deferred
		end

feature {NONE} -- Implementation


note
	copyright: "2011-2014, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
