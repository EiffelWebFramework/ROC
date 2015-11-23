note
	description: "[
			Taxonomy vocabulary.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_VOCABULARY

create
	make,
	make_from_term

feature {NONE} -- Initialization

	make (a_tid: INTEGER_64; a_name: READABLE_STRING_GENERAL)
		do
			id := a_tid
			set_name (a_name)
			create {ARRAYED_LIST [CMS_TERM]} items.make (0)
		end

	make_from_term (a_term: CMS_TERM)
		do
			make (a_term.id,  a_term.text)
			description := a_term.description
		end

feature -- Access

	id: INTEGER_64

	name: IMMUTABLE_STRING_32

	description: detachable READABLE_STRING_32

	items: LIST [CMS_TERM]
			-- Collection of terms.

	has_id: BOOLEAN
		do
			Result := id > 0
		end

feature -- Element change

	set_name (a_name: READABLE_STRING_GENERAL)
		do
			create name.make_from_string_general (a_name)
		end

	sort
			--  Sort `items'
		local
			l_sorter: QUICK_SORTER [CMS_TERM]
		do
			create l_sorter.make (create {COMPARABLE_COMPARATOR [CMS_TERM]})
			l_sorter.sort (items)
		end

end

