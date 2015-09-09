note
	description: "Feed aggregation parameters."
	date: "$Date$"
	revision: "$Revision$"

class
	FEED_AGGREGATION

create
	make

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_GENERAL)
		do
			create name.make_from_string_general (a_name)
			create {ARRAYED_LIST [READABLE_STRING_8]} locations.make (0)
		end

feature -- Access

	name: IMMUTABLE_STRING_32
			-- Associated name.

	description: detachable IMMUTABLE_STRING_32
			-- Optional description.

	locations: LIST [READABLE_STRING_8]
			-- List of feed location aggregated into current.

feature -- Element change

	set_description (a_desc: detachable READABLE_STRING_GENERAL)
		do
			if a_desc = Void then
				description := Void
			else
				create description.make_from_string_general (a_desc)
			end
		end

end
