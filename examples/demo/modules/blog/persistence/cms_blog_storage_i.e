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

	blogs: LIST [CMS_NODE]
			-- List of nodes ordered by creation date (descending).
		deferred
		end

	blogs_limited (limit:INTEGER_32; offset:INTEGER_32) : LIST[CMS_NODE]
			-- List of nodes ordered by creation date from limit to limit + offset
		deferred
		end

end
