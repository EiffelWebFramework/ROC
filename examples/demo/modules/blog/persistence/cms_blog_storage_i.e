note
	description: "Interface for accessing blog contents from the database."
	date: "$Date: 2015-01-27 19:15:02 +0100 (mar., 27 janv. 2015) $"
	revision: "$Revision: 96542 $"

deferred class
	CMS_BLOG_STORAGE_I

inherit
	CMS_NODE_STORAGE_I

feature -- Access

	blogs_count: INTEGER_64
			-- Count of blog nodes
		deferred
		end

	blogs_count_from_user (user_id: INTEGER_64) : INTEGER_64
			-- Number of nodes of type blog from user with user_id
		deferred
		end

	blogs: LIST [CMS_NODE]
			-- List of nodes ordered by creation date (descending).
		deferred
		end

	blogs_limited (limit:NATURAL_32; offset:NATURAL_32) : LIST[CMS_NODE]
			-- List of posts ordered by creation date from offset to offset + limit
		deferred
		end

	blogs_from_user_limited (user_id: INTEGER_32; limit:NATURAL_32; offset:NATURAL_32) : LIST[CMS_NODE]
			-- List of posts from user_id ordered by creation date from offset to offset + limit
		deferred
		end

end
