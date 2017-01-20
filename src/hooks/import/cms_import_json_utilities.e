note
	description: "[
			Usefull routines to import to JSON.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_IMPORT_JSON_UTILITIES

feature -- Access

	json_string_item (j: JSON_OBJECT; a_name: READABLE_STRING_GENERAL): detachable STRING_32
		do
			if attached {JSON_STRING} j.item (a_name) as s then
				Result := s.unescaped_string_32
			end
		end

	json_string_8_item (j: JSON_OBJECT; a_name: READABLE_STRING_GENERAL): detachable STRING_8
		do
			if attached {JSON_STRING} j.item (a_name) as s then
				Result := s.unescaped_string_8
			end
		end

	json_integer_item (j: JSON_OBJECT; a_name: READABLE_STRING_GENERAL): INTEGER_64
		local
			s: READABLE_STRING_GENERAL
		do
			if attached {JSON_NUMBER} j.item (a_name) as i then
				Result := i.integer_64_item
			elseif attached {JSON_STRING} j.item (a_name) as js then
				s := js.unescaped_string_32
				if s.is_integer_64 then
					Result := s.to_integer_64
				end
			end
		end

	json_date_item (j: JSON_OBJECT; a_name: READABLE_STRING_GENERAL): detachable DATE_TIME
		local
			hd: HTTP_DATE
		do
			if attached {JSON_NUMBER} j.item (a_name) as num then
				create hd.make_from_timestamp (num.integer_64_item)
				Result := hd.date_time
			elseif attached {JSON_STRING} j.item (a_name) as s then
				create hd.make_from_string (s.unescaped_string_32)
				Result := hd.date_time
			end
		end

note
	copyright: "2011-2017, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
