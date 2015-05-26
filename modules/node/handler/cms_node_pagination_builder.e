note
	description: "Paginator builder for CMS nodes."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_NODE_PAGINATION_BUILDER

inherit

	CMS_PAGINATION_BUILDER [CMS_NODE]

	CMS_NODE_HANDLER
		redefine
			make
		end
create
	make

feature {NONE} -- Initialization

	make (a_api: CMS_API; a_module_api: CMS_NODE_API)
			-- Create an object.
		do
			Precursor (a_api, a_module_api)
			limit := 5
			offset := 0
		ensure then
			limit_set: limit = 5
			offset_set: offset = 0
		end

feature -- Pager

	list: ITERABLE [CMS_NODE]
			-- <Precursor>.
		do
				--NOTE: the current implementation does not use
				-- order by and ordering.
			create {ARRAYED_LIST [CMS_NODE]} Result.make (0)
			Result := node_api.recent_nodes (offset.as_integer_32, limit.as_integer_32)
		end

end
