note
	description : "Objects that ..."
	author      : "$Author: jfiat $"
	date        : "$Date: 2015-02-13 13:08:13 +0100 (ven., 13 févr. 2015) $"
	revision    : "$Revision: 96616 $"

class
	CMS_ENV_LOGGER

inherit
	CMS_LOGGER

	SHARED_LOGGER
		rename
			log as log_facility
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
		end

feature -- Logging

	put_information (a_message: READABLE_STRING_8; a_data: detachable ANY)
		do
			log_facility.write_information (log_message (a_message, a_data))
		end

	put_error (a_message: READABLE_STRING_8; a_data: detachable ANY)
		do
			log_facility.write_error (log_message (a_message, a_data))
		end

	put_warning (a_message: READABLE_STRING_8; a_data: detachable ANY)
		do
			log_facility.write_warning (log_message (a_message, a_data))
		end

	put_critical (a_message: READABLE_STRING_8; a_data: detachable ANY)
		do
			log_facility.write_critical (log_message (a_message, a_data))
		end

	put_alert (a_message: READABLE_STRING_8; a_data: detachable ANY)
		do
			log_facility.write_alert (log_message (a_message, a_data))
		end

	put_debug (a_message: READABLE_STRING_8; a_data: detachable ANY)
		do
			log_facility.write_debug (log_message (a_message, a_data))
		end

end
