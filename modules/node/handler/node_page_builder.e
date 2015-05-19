note
	description: "Summary description for {NODE_PAGE_BUILDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NODE_PAGE_BUILDER

inherit

	PAGE_BUILDER [CMS_NODE]
		rename
			make as page_make
		end
create

	make

feature {NONE} -- Initialization

	make (a_api: CMS_API; a_module_api: CMS_NODE_API)
		do
			page_make (a_api, a_module_api)
			limit := 5
			offset := 0
		end

feature -- Pager

	list: LIST[CMS_NODE]
		do
			create {ARRAYED_LIST[CMS_NODE]}Result.make (0)
			Result := node_api.recent_nodes (offset.as_integer_32, limit.as_integer_32)
		end

end
