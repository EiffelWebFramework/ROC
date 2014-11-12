note
	description: "Describe how to alter a menu before it's rendered."
	date: "$Date: 2014-08-28 08:21:49 -0300 (ju. 28 de ago. de 2014) $"

deferred class
	CMS_HOOK_MENU_ALTER

inherit
	CMS_HOOK

feature -- Hook

	menu_alter (a_menu_system: CMS_MENU_SYSTEM; a_response: CMS_RESPONSE)
		deferred
		end

end
