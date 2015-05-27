note
	description: "Paginator builder for CMS nodes."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_NODE_PAGINATION_BUILDER

inherit

	CMS_PAGINATION_BUILDER [CMS_NODE]

create
	make

feature {NONE} -- Initialization

	make (a_api: CMS_NODE_API)
			-- Create an object.
		do
			node_api := a_api
			count := 5
			offset := 0
		ensure
			node_api_set: node_api = a_api
			limit_set: count = 5
			offset_set: offset = 0
		end

	node_api: CMS_NODE_API
			-- CMS API.

feature -- Pager

	items: ITERABLE [CMS_NODE]
			-- <Precursor>.
		do
				--NOTE: the current implementation does not use
				-- order by and ordering.
			create {ARRAYED_LIST [CMS_NODE]} Result.make (0)
			Result := node_api.recent_nodes (offset.as_integer_32, count.as_integer_32)
		end

end
