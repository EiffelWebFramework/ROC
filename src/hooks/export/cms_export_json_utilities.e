note
	description: "[
			Usefull routines to export to JSON.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_EXPORT_JSON_UTILITIES

feature -- Access

	put_date_into_json (dt: detachable DATE_TIME; a_key: JSON_STRING; j: JSON_OBJECT)
		local
			hd: HTTP_DATE
		do
			if dt /= Void then
				create hd.make_from_date_time (dt)
				j.put_integer (hd.timestamp, a_key)
			end
		end

	json_to_string (j: JSON_OBJECT): STRING
		local
			pp: JSON_PRETTY_STRING_VISITOR
		do
			create Result.make_empty
			create pp.make (Result)
			j.accept (pp)
		end

note
	copyright: "2011-2015, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
