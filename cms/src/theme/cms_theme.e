note
	description: "Summary description for {WSF_CMS_THEME}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_THEME

inherit
	CMS_ENCODERS

	REFACTORING_HELPER


feature {NONE} -- Access

	setup:  CMS_SETUP

feature -- Access

	name: STRING
			-- theme name.
		deferred
		end

	regions: ARRAY [STRING]
			-- theme's regions.
		deferred
		end

	page_template: CMS_TEMPLATE
			-- theme template page.
		deferred
		end

	navigation_template: detachable READABLE_STRING_GENERAL
			-- navigation template name, if any.
		deferred
		end


feature -- Conversion

	menu_html (a_menu: CMS_MENU; is_horizontal: BOOLEAN): STRING_8
			-- Render Menu as HTML.
			-- A theme will define a menu.tpl
		deferred
		end

	block_html (a_block: CMS_BLOCK): STRING_8
			-- Render a block as HTML.
		deferred
		end

	page_html (page: CMS_HTML_PAGE): STRING_8
			-- Render `page' as html.
		deferred
		end

feature {NONE} -- Implementation

	append_cms_link_to (lnk: CMS_LINK; s: STRING_8)
		local
			cl: STRING
		do
			fixme ("Remove HTML from Eiffel")
			create cl.make_empty
			if lnk.is_active then
				cl.append ("active ")
			end
			if lnk.is_expandable then
				cl.append ("expandable ")
			end
			if lnk.is_expanded then
				cl.append ("expanded ")
			end
			if cl.is_empty then
				s.append ("<li>")
			else
				s.append ("<li class=%""+ cl + "%">")
			end
--			s.append ("<a href=%"" + url (lnk.location, lnk.options) + "%">" + html_encoded (lnk.title) + "</a>")
			if
--				(lnk.is_expanded or lnk.is_collapsed) and then
				attached lnk.children as l_children
			then
				s.append ("<ul>%N")
				across
					l_children as c
				loop
					append_cms_link_to (c.item, s)
				end
				s.append ("</ul>")
			end
			s.append ("</li>")
		end

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
