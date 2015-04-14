note
	description: "CMS handler specific for a module api"
	date: "$Date: 2015-02-13 13:08:13 +0100 (ven., 13 févr. 2015) $"
	revision: "$Revision: 96616 $"

deferred class
	CMS_MODULE_HANDLER [G -> CMS_MODULE_API]

inherit
	CMS_HANDLER
		rename
			make as cms_make
		end

feature {NONE} -- Initialization

	make (a_api: CMS_API; a_module_api: G)
		do
			cms_make (a_api)
			module_api := a_module_api
		end

	module_api: G
			-- Node api	

end
