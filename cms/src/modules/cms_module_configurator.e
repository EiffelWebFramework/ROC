note
	description: "Summary description for {CMS_MODULE_CONFIGURATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_MODULE_CONFIGURATOR

feature -- Access

	modules: LIST[CMS_MODULE]
			-- Possible list of modules.
		deferred
		end

feature -- Add Module

	add_module (a_module: CMS_MODULE)
			-- Add module
		do
			modules.force (a_module)
		end

	remove_module (a_module: CMS_MODULE)
			-- Remove module
		do
			modules.prune (a_module)
		end
end
