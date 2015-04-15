note
	description : "Objects that ..."
	author      : "$Author: jfiat $"
	date        : "$Date: 2015-02-13 13:08:13 +0100 (ven., 13 févr. 2015) $"
	revision    : "$Revision: 96616 $"

deferred class
	CMS_LOGGER

feature -- Logging

	put_critical (a_message: READABLE_STRING_8; a_data: detachable ANY)
		deferred
		end

	put_alert (a_message: READABLE_STRING_8; a_data: detachable ANY)
		deferred
		end

	put_error (a_message: READABLE_STRING_8; a_data: detachable ANY)
		deferred
		end

	put_warning (a_message: READABLE_STRING_8; a_data: detachable ANY)
		deferred
		end

	put_information (a_message: READABLE_STRING_8; a_data: detachable ANY)
		deferred
		end

	put_debug (a_message: READABLE_STRING_8; a_data: detachable ANY)
		deferred
		end

feature {NONE} -- Logging

	log_message (a_message: READABLE_STRING_8; a_data: detachable ANY): STRING
		do
			create Result.make (a_message.count)
			if attached {CMS_MODULE} a_data as a_module then
				Result.append_character ('[')
				Result.append (a_module.name)
				Result.append_character (']')
				Result.append_character (' ')
			elseif attached {TYPE [detachable ANY]} a_data as a_type then
				Result.append_character ('{')
				Result.append (a_type.out)
				Result.append_character ('}')
				Result.append_character (' ')
			end
			Result.append (a_message)
		end

end
