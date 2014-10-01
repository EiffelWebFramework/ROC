note
	description: "Shared error handler for database"
	date: "$Date: 2013-08-08 16:39:49 -0300 (ju. 08 de ago. de 2013) $"
	revision: "$Revision: 195 $"

class
	SHARED_ERROR_HANDLER

feature -- Access

	database_error_handler: DATABASE_ERROR_HANDLER
			-- Error handler
		once
			create Result.make
		end

feature -- Helper

	exception_as_error (a_e: like {EXCEPTION_MANAGER}.last_exception)
			-- Record exception as an error.
		do
			if attached a_e as l_e and then attached l_e.exception_trace as l_trace then
				database_error_handler.add_error_details (l_e.code, once "Exception", l_trace.as_string_32)
			end
		end

end
