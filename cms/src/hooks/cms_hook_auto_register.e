note
	description: "[
			Summary description for {CMS_HOOK_AUTO_REGISTER}.
			When inheriting from this class, the declared hooks are automatically
			registered, otherwise, each descendant has to add it to the cms service
			itself.
		]"
	date: "$Date: 2014-08-28 08:21:49 -0300 (ju. 28 de ago. de 2014) $"
	revision: "$Revision: 95708 $"

deferred class
	CMS_HOOK_AUTO_REGISTER

inherit
	CMS_HOOK

feature -- Hook

	hook_auto_register (a_response: CMS_RESPONSE)
		do
			if attached {CMS_HOOK_MENU_ALTER} Current as h_menu_alter then
				debug ("refactor_fixme")
					-- Fixme: CMS_RESPONSE.add_menu_alter_hook : a_response.add_menu_alter_hook (h_menu_alter)
				end
			end
			if attached {CMS_HOOK_BLOCK} Current as h_block then
				debug ("refactor_fixme")
					-- Fixme: CMS_RESPONSE.add_block_hook a_response.add_block_hook (h_block)
				end
			end
			if attached {CMS_HOOK_FORM_ALTER} Current as h_block then
				debug ("refactor_fixme")
					-- CMS_RESPONSE.add_form_alter_hook a_response.add_form_alter_hook (h_block)
				end
			end

		end

end
