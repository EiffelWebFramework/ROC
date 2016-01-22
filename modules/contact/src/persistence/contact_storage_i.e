note
	description: "[
			Persistence interface for CONTACT_MODULE.
		]"
	author: "$Author: jfiat $"
	date: "$Date: 2015-05-22 23:00:09 +0200 (ven., 22 mai 2015) $"
	revision: "$Revision: 97349 $"

deferred class
	CONTACT_STORAGE_I

feature -- Error Handling

	error_handler: ERROR_HANDLER
			-- Error handler.
		deferred
		end

feature -- Access

feature -- Change

	save_contact_message (m: CONTACT_MESSAGE)
		deferred
		end

end
