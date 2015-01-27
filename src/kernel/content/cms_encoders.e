note
	description: "Summary description for {CMS_ENCODERS}."
	author: ""
	date: "$Date: 2014-11-13 16:23:47 +0100 (jeu., 13 nov. 2014) $"
	revision: "$Revision: 96085 $"

class
	CMS_ENCODERS

feature -- Encoders

	url_encoded (s: detachable READABLE_STRING_GENERAL): STRING_8
		local
			enc: URL_ENCODER
		do
			create enc
			if s /= Void then
				Result := enc.general_encoded_string (s)
			else
				create Result.make_empty
			end
		end

	html_encoded (s: detachable READABLE_STRING_GENERAL): STRING_8
		local
			enc: HTML_ENCODER
		do
			create enc
			if s /= Void then
				Result := enc.general_encoded_string (s)
			else
				create Result.make_empty
			end
		end
end
