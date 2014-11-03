note
	description: "Summary description for {CMS_BLOCK}."
	date: "$Date: 2014-08-28 08:21:49 -0300 (ju. 28 de ago. de 2014) $"

deferred class
	CMS_BLOCK

feature -- Access

	name: READABLE_STRING_8
		deferred
		end

	title: detachable READABLE_STRING_32
		deferred
		end

feature -- status report

	is_enabled: BOOLEAN

feature -- Conversion

	to_html (a_theme: CMS_THEME): STRING_8
		deferred
		end

end
