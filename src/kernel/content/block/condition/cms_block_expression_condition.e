note
	description: "Condition for block to be displayed."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_BLOCK_EXPRESSION_CONDITION

inherit	
	CMS_BLOCK_CONDITION

create
	make

feature {NONE} -- Initialization

	make (a_exp: READABLE_STRING_8)
		do
			expression := a_exp
		end

feature -- Access

	description: READABLE_STRING_32
		do
			create Result.make_from_string_general ("Expression: %"")
			Result.append_string_general (expression)
			Result.append_character ('%"')
		end

	expression: STRING

feature -- Evaluation

	satisfied_for_response (res: CMS_RESPONSE): BOOLEAN
		do
			if expression.same_string ("is_front") then
				Result := res.is_front
			elseif expression.starts_with ("path=") then
			end
		end

note
	copyright: "2011-2015, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
