note
	description: "Summary description for {ESA_APPLICATION_CONSTANTS}."
	date: "$Date: 2014-08-20 15:21:15 -0300 (mi., 20 ago. 2014) $"
	revision: "$Revision: 95678 $"

class
	APPLICATION_CONSTANTS

feature -- Access

	major: INTEGER = 0
	minor: INTEGER = 1
	built: STRING = "0001"

	version: STRING
		do
			Result := major.out + "." + minor.out + "." + built
		end
end
