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

	blogs_count_from_user (user_id: INTEGER_64) : INTEGER_64
			-- Number of nodes of type blog from user with user_id
		do
		end

	blogs: LIST[CMS_NODE]
			-- List of nodes.
		do
			create {ARRAYED_LIST [CMS_NODE]} Result.make (0)
		end

	blogs_limited (limit:NATURAL_32; offset:NATURAL_32) : LIST[CMS_NODE]
			-- List of posts ordered by creation date from offset to offset + limit
		do
			create {ARRAYED_LIST [CMS_NODE]} Result.make (0)
		end

	blogs_from_user_limited (user_id: INTEGER_32; limit:NATURAL_32; offset:NATURAL_32) : LIST[CMS_NODE]
			-- List of posts from user_id ordered by creation date from offset to offset + limit
		do
			create {ARRAYED_LIST [CMS_NODE]} Result.make (0)
		end
end
