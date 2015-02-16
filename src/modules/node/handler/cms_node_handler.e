note
	description: "Summary description for {CMS_NODE_HANDLER}."
	author: ""
	date: "$Date: 2015-02-13 13:08:13 +0100 (ven., 13 févr. 2015) $"
	revision: "$Revision: 96616 $"

deferred class
	CMS_NODE_HANDLER

inherit
	CMS_MODULE_HANDLER [CMS_NODE_API]
		rename
			module_api as node_api
		end

end
