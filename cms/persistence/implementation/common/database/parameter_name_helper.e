note
	description: "Helper for paramenter Names"
	date: "$Date: 2014-08-20 15:21:15 -0300 (mi., 20 ago. 2014) $"
	revision: "$Revision: 95678 $"

deferred class
	PARAMETER_NAME_HELPER

feature -- String

	string_parameter (a_value: STRING; a_length: INTEGER): STRING
			-- Adjust a parameter `a_value' to the lenght `a_length'.
		require
			valid_length: a_length > 0
		do
			if a_value.count <= a_length then
				Result := a_value
			else
				create Result.make_from_string (a_value.substring (1, a_length))
			end
		end

end
