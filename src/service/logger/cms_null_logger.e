note
	description : "Objects that ..."
	author      : "$Author: jfiat $"
	date        : "$Date: 2015-02-13 13:08:13 +0100 (ven., 13 févr. 2015) $"
	revision    : "$Revision: 96616 $"

class
	CMS_NULL_LOGGER

inherit
	CMS_LOGGER

feature -- Logging

	put_information (a_message: READABLE_STRING_8; a_data: detachable ANY)
		do
		end

	put_error (a_message: READABLE_STRING_8; a_data: detachable ANY)
		do
		end

	put_warning (a_message: READABLE_STRING_8; a_data: detachable ANY)
		do
		end

	put_critical (a_message: READABLE_STRING_8; a_data: detachable ANY)
		do
		end

	put_alert (a_message: READABLE_STRING_8; a_data: detachable ANY)
		do
		end

	put_debug (a_message: READABLE_STRING_8; a_data: detachable ANY)
		do
		end

end
