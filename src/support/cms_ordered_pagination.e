note
	description: "Pagination parameters with order capability"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_ORDERED_PAGINATION

inherit
	CMS_PAGINATION

create
	make
	
feature -- Access

	order_by: detachable READABLE_STRING_8
			-- field to order by.

	order_ascending: BOOLEAN
			-- is ascending ordering?

feature -- Element change

	set_ascending_order_by_field (a_field: detachable READABLE_STRING_8)
			-- Pager with a order_by `a_field' asc.	
		do
			if a_field /= Void then
				order_by := a_field
				order_ascending := True
			else
				order_by := Void
			end
		ensure
			order_by_unset: a_field = Void implies order_by = Void
			order_by_set: a_field /= Void implies attached order_by as l_order_by and then l_order_by.same_string (a_field)
			asc_true: order_ascending
		end

	set_descending_order_by_field (a_field: detachable READABLE_STRING_8)
			-- Pager sorting descending with field `a_field' if set, otherwise remove sorting.	
		do
			if a_field /= Void then
				order_by := a_field
				order_ascending := False
			else
				order_by := Void
			end
		ensure
			order_by_unset: a_field = Void implies order_by = Void
			order_by_set: a_field /= Void implies attached order_by as l_order_by and then l_order_by.same_string (a_field)
			asc_fasle: not order_ascending
		end

end
