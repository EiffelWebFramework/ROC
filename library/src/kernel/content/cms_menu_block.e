note
	description: "Summary description for {CMS_MENU_BLOCK}."
	date: "$Date: 2014-08-28 08:21:49 -0300 (ju. 28 de ago. de 2014) $"

class
	CMS_MENU_BLOCK

inherit
	CMS_BLOCK

create
	make

feature {NONE} -- Initialization

	make (a_menu: like menu)
		do
			is_enabled := True
			menu := a_menu
			name := a_menu.name
			title := a_menu.title
		end

feature -- Access

	menu: CMS_MENU

	name: READABLE_STRING_8

	title: detachable READABLE_STRING_32

	is_horizontal: BOOLEAN

feature -- Conversion

	to_html (a_theme: CMS_THEME): STRING_8
		do
			Result := a_theme.menu_html (menu, is_horizontal)
		end

end
