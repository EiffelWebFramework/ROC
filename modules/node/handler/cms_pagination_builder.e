note
	description: "Generic Pagination Builder Interface"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_PAGINATION_BUILDER

inherit

	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			count := 5
			offset := 0
		ensure then
			limit_set: count = 5
			offset_set: offset = 0
		end

feature -- Access

	set_count (a_count: NATURAL)
			-- Set `count' with `a_count'.
		do
			count := a_count
		ensure
			count_set: count = a_count
		end

	set_offset (a_offset: NATURAL)
			-- Set offset with `a_offset'.
		do
			offset := a_offset
		ensure
			limit_set: offset = a_offset
		end

	set_ascending_order (a_field: READABLE_STRING_32)
			-- Pager with a order_by `a_field' asc.	
		do
			order_by := a_field
			order_ascending := True
		ensure
			order_by_set: attached order_by as l_order_by implies l_order_by = a_field
			asc_true: order_ascending
		end

	set_descending_order (a_field: READABLE_STRING_32)
			-- Pager with a order_by `a_field' desc.	
		do
			order_by := a_field
			order_ascending := False
		ensure
			order_by_set: attached order_by as l_order_by implies l_order_by = a_field
			asc_fasle: not order_ascending
		end


feature -- Access

	count: NATURAL
		-- Number of items per page.

	offset: NATURAL
		--  lower index of `items' pagination.

	order_by: detachable STRING
		-- field to order by.

	order_ascending: BOOLEAN
		-- is ascending ordering?	
end
