note
	description: "Summary description for {CMS_THEME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEFAULT_CMS_THEME

inherit
	CMS_THEME

create
	make

feature {NONE} -- Initialization

	make (a_setup: like setup; a_info: like information)
		do
			setup := a_setup
			information := a_info
		end

	information: CMS_THEME_INFORMATION

feature -- Access

	name: STRING = "CMS"

	regions: ARRAY [STRING]
		once
			Result := <<"header", "content", "footer", "first_sidebar", "second_sidebar">>
		end

	html_template: DEFAULT_CMS_HTML_TEMPLATE
		local
			tpl: like internal_html_template
		do
			tpl := internal_html_template
			if tpl = Void then
				create tpl.make (Current)
				internal_html_template := tpl
			end
			Result := tpl
		end

	page_template: DEFAULT_CMS_PAGE_TEMPLATE
		local
			tpl: like internal_page_template
		do
			tpl := internal_page_template
			if tpl = Void then
				create tpl.make (Current)
				internal_page_template := tpl
			end
			Result := tpl
		end

feature -- Conversion

	prepare (page: CMS_HTML_PAGE)
		do
		end

	menu_html (a_menu: CMS_MENU; is_horizontal: BOOLEAN): STRING_8
		do
			create Result.make_from_string ("<div id=%""+ a_menu.name +"%" class=%"menu%">")
			if is_horizontal then
				Result.append ("<ul class=%"horizontal%" >%N")
			else
				Result.append ("<ul class=%"vertical%" >%N")
			end
			across
				a_menu as c
			loop
				append_cms_link_to (c.item, Result)
			end
			Result.append ("</ul>%N")
			Result.append ("</div>")
		end

	block_html (a_block: CMS_BLOCK): STRING_8
		local
			s: STRING
		do
			if attached {CMS_CONTENT_BLOCK} a_block as l_content_block and then l_content_block.is_raw then
				create s.make_empty
				if attached l_content_block.title as l_title then
					s.append ("<div class=%"title%">" + html_encoded (l_title) + "</div>")
				end
				s.append (l_content_block.to_html (Current))
			else
				create s.make_from_string ("<div class=%"block%" id=%"" + a_block.name + "%">")
				if attached a_block.title as l_title then
					s.append ("<div class=%"title%">" + html_encoded (l_title) + "</div>")
				end
				s.append ("<div class=%"inside%">")
				s.append (a_block.to_html (Current))
				s.append ("</div>")
				s.append ("</div>")
			end
			Result := s
		end

	page_html (page: CMS_HTML_PAGE): STRING_8
		local
			l_content: STRING_8
		do
			prepare (page)
			page_template.prepare (page)
			l_content := page_template.to_html (page)
			html_template.prepare (page)
			html_template.register (l_content, "page")
			Result := html_template.to_html (page)
		end

feature {NONE} -- Internal

	internal_page_template: detachable like page_template

	internal_html_template: detachable like html_template

invariant
	attached internal_page_template as inv_p implies inv_p.theme = Current
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
