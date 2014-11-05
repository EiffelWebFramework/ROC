note
	description: "Summary description for {SMARTY_CMS_THEME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SMARTY_CMS_THEME

inherit
	CMS_THEME

create
	make

feature {NONE} -- Initialization

	make (a_setup: like setup; a_info: like information;)
		do
			setup := a_setup
			information := a_info
			if attached a_info.item ("template_dir") as s then
				templates_directory := a_setup.theme_location.extended (s)
			else
				templates_directory := a_setup.theme_location
			end
		ensure
			setup_set: setup = a_setup
			information_set: information = a_info
		end

feature -- Access

	name: STRING = "smarty-CMS"

	templates_directory: PATH

	information: CMS_THEME_INFORMATION

	regions: ARRAY [STRING]
		local
			i: INTEGER
			utf: UTF_CONVERTER
			l_regions: like internal_regions
		do
			l_regions := internal_regions
			if l_regions = Void then
				if attached information.regions as tb and then not tb.is_empty then
					i := 1
					create l_regions.make_filled ("", i, i + tb.count - 1)
					across
						tb as ic
					loop
						l_regions.force (utf.utf_32_string_to_utf_8_string_8 (ic.key), i) -- NOTE: UTF-8 encoded !
						i := i + 1
					end
				else
					l_regions := <<"top","header", "content", "footer", "first_sidebar", "second_sidebar","bottom">>
				end
				internaL_regions := l_regions
			end
			Result := l_regions
		end

	page_template: SMARTY_CMS_PAGE_TEMPLATE
		local
			tpl: like internal_page_template
		do
			tpl := internal_page_template
			if tpl = Void then
				create tpl.make ("page", Current)
				internal_page_template := tpl
			end
			Result := tpl
		end

feature -- Conversion

	menu_html (a_menu: CMS_MENU; is_horizontal: BOOLEAN): STRING_8
			-- Render Menu as HTML.
			-- A theme will define a menu.tpl
		local
			tpl: SMARTY_CMS_PAGE_TEMPLATE
			l_page: CMS_HTML_PAGE
		do
			to_implement ("Proof of concept to load a Menu from a tpl/menu.tpl.")
			to_implement ("In this case the template only take care of links.")
			to_implement ("Maybe we need a SMARTY_CMS_REGION_TEMPLATE")
			to_implement ("Provide a default Menu using HTML hardcoded, maybe using the Default or providing a default implementation in CMS_THEME.menu_html")
				-- Use the similar pattern to SMARTY_CMS_PAGE_TEMPLATE, with a different prepare
				-- feature.
			create tpl.make ("tpl/menu", Current)
			create l_page.make
			l_page.register_variable (a_menu, "menu")
			tpl.prepare (l_page)
			Result := tpl.to_html (l_page)
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

	prepare (page: CMS_HTML_PAGE)
		do
		end

	page_html (page: CMS_HTML_PAGE): STRING_8
		do
			prepare (page)
			page_template.prepare (page)
			Result := page_template.to_html (page)
		end

feature {NONE} -- Internal

	internal_regions: detachable like regions

	internal_page_template: detachable like page_template

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
