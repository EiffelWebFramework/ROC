note
	description: "[
			Objects that ...
		]"
	author: "$Author: jfiat $"
	date: "$Date: 2015-05-22 23:00:09 +0200 (ven., 22 mai 2015) $"
	revision: "$Revision: 97349 $"

class
	CONTACT_STORAGE_NULL

inherit
	CONTACT_STORAGE_I

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			create error_handler.make
		end

feature -- Error Handling

	error_handler: ERROR_HANDLER
			-- Error handler.	

feature -- Access

feature -- Change

	save_contact_message (m: CONTACT_MESSAGE)
		do
		end

end
