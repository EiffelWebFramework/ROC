note
	description: "Summary description for {CMS_BLOG_STORAGE_NULL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_BLOG_STORAGE_NULL

inherit
	CMS_NODE_STORAGE_NULL

	CMS_BLOG_STORAGE_I

create
	make

feature -- Access

	blogs_count: INTEGER_64
			-- Count of nodes.
		do
		end

	blogs: LIST[CMS_NODE]
			-- List of nodes.
		do
			create {ARRAYED_LIST [CMS_NODE]} Result.make (0)
		end

	blogs_limited (limit:INTEGER_32; offset:INTEGER_32) : LIST[CMS_NODE]
			-- List of nodes ordered by creation date from limit to limit + offset
		do
			create {ARRAYED_LIST [CMS_NODE]} Result.make (0)
		end
end
