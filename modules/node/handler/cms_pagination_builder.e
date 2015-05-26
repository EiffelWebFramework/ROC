note
	description: "Generic Pagination Builder Interface"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_PAGINATION_BUILDER [G]

feature -- Access

	set_limit (a_limit: NATURAL)
			-- Set limit with `a_limit'.
		do
			limit := a_limit
		ensure
			limit_set: limit = a_limit
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

feature -- Pager

	list: ITERABLE[G]
			-- Iterable of G with filters.
		deferred
		end

feature -- Access

	limit: NATURAL
		-- Number of rows per page.

	offset: NATURAL
		-- rows starting from the next row to the given OFFSET.

	order_by: detachable STRING
		-- field to order by

	order_ascending: BOOLEAN
		-- is ascending ordering?	
end
