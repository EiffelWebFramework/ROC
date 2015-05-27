note
	description: "Deferred request handler related to /blogs/... Has an own blog api."
	author: "Dario Bösch <daboesch@student.ethz.ch>"
	date: "$Date: 2015-05-18 13:49:00 +0100 (lun., 18 mai 2015) $"
	revision: "$9661667$"

deferred class
	CMS_BLOG_HANDLER

inherit
	CMS_MODULE_HANDLER [CMS_BLOG_API]
		rename
			module_api as blog_api
		end

feature -- Access

	entries_per_page: NATURAL_32
		do
			Result := blog_api.entries_per_page
		end

end
