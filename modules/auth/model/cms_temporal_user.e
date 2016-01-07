note
	description: "Summary description for {CMS_TEMPORAL_USER}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_TEMPORAL_USER

inherit

	CMS_USER

create
	make,
	make_with_id

feature -- Access

	personal_information: detachable STRING_32
			-- User personal information.

	salt: detachable STRING_32
			-- User's password salt.		


feature -- Element change

	set_personal_information (an_personal_information: like personal_information)
			-- Assign `personal_information' with `an_personal_information'.
		do
			personal_information := an_personal_information
		ensure
			personal_information_assigned: personal_information = an_personal_information
		end

	set_salt (a_salt: like salt)
			-- Assign `salt' with `a_salt'.
		do
			salt := a_salt
		ensure
			salt_assigned: salt = a_salt
		end

end
