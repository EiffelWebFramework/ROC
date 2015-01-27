note
	description: "[
			Hook providing a way to alter the CMS menu system.
		]"
	date: "$Date: 2014-11-13 16:23:47 +0100 (jeu., 13 nov. 2014) $"

deferred class
	CMS_HOOK_MENU_SYSTEM_ALTER

inherit
	CMS_HOOK

feature -- Hook

	menu_system_alter (a_menu_system: CMS_MENU_SYSTEM; a_response: CMS_RESPONSE)
			-- Hook execution on collection of menu contained by `a_menu_system'
			-- for related response `a_response'.
		deferred
		end

end
