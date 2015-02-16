note
	description: "Summary description for {DATABASE_NO_CHANGE_ERROR}."
	author: ""
	date: "$Date: 2014-11-13 16:23:47 +0100 (jeu., 13 nov. 2014) $"
	revision: "$Revision: 96085 $"

class
	DATABASE_NO_CHANGE_ERROR

inherit
	DATABASE_ERROR
		redefine
			make_from_message
		end

create
	make_from_message

feature {NONE} -- Init

	make_from_message (a_m: like message; a_code: like code)
			-- Create from `a_m'
		do
			make (a_code, once "Database No Change Error", a_m)
		end

end
