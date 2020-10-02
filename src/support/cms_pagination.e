note
	description: "Pagination parameters"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_PAGINATION

create
	make

feature {NONE} -- Initialization

	make (a_offset: NATURAL; a_size: NATURAL)
		do
			offset := a_offset
			size := a_size
		ensure
			size_set: size = a_size
			offset_set: offset = a_offset
		end

feature -- Access

	size: NATURAL assign set_size
			-- Number of items per page.

	offset: NATURAL assign set_offset
			--  lower index of `items' pagination.

feature -- Element change

	set_size (a_size: NATURAL)
			-- Set `size' with `a_size'.
		do
			size := a_size
		ensure
			size_set: size = a_size
		end

	set_offset (a_offset: NATURAL)
			-- Set offset with `a_offset'.
		do
			offset := a_offset
		ensure
			limit_set: offset = a_offset
		end


end
