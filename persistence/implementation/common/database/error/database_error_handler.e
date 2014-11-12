note
	description: "Database error handler"
	date: "$Date: 2013-08-08 16:39:49 -0300 (ju. 08 de ago. de 2013) $"
	revision: "$Revision: 195 $"

class
	DATABASE_ERROR_HANDLER

inherit
	ERROR_HANDLER

create
	make

feature -- Error operation

	add_database_error (a_message: READABLE_STRING_32; a_code: INTEGER)
			-- Add a database error.
		local
			l_error: DATABASE_ERROR
		do
			create l_error.make_from_message (a_message, a_code)
			add_error (l_error)
		end

	add_database_no_change_error (a_message: READABLE_STRING_32; a_code: INTEGER)
			-- Add a database error.
		local
			l_error: DATABASE_NO_CHANGE_ERROR
		do
			create l_error.make_from_message (a_message, a_code)
			add_error (l_error)
		end

end
