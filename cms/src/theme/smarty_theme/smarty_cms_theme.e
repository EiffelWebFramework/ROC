note
	description: "Summary description for {SMARTY_CMS_THEME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SMARTY_CMS_THEME

inherit
	CMS_THEME

	REFACTORING_HELPER

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
		do
		    to_implement ("Add implementation")
			Result := "to be implemented"
		end


	block_html (a_block: CMS_BLOCK): STRING_8
		do
			to_implement ("Add implementation")
			Result := "to be implemented"
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
