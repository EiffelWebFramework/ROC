note
	description: "Describe content to be placed inside Regions."
	date: "$Date: 2014-08-28 08:21:49 -0300 (ju. 28 de ago. de 2014) $"

deferred class
	CMS_BLOCK

feature -- Access

	name: READABLE_STRING_8
			-- Name identifying Current block.
		deferred
		end

	title: detachable READABLE_STRING_32
			-- Optional title.
		deferred
		end

feature -- status report

	is_enabled: BOOLEAN
			-- Is current block enabled?

	is_raw: BOOLEAN
			-- Is raw?
			-- If True, do not get wrapped it with block specific div			
		deferred
		end

feature -- Conversion

	to_html (a_theme: CMS_THEME): STRING_8
			-- HTML representation of Current block.
		deferred
		end

end
