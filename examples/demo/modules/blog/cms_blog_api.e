note
	description: "API to handle nodes of type blog"
	author: "Dario Bösch <daboesch@student.ethz.ch"
	date: "$Date: 2015-05-21 14:46:00 +0100$"
	revision: "$Revision: 96616 $"

class
	CMS_BLOG_API

inherit
	CMS_NODE_API
		redefine
			initialize,
			node_storage
		end

create
	make

feature {NONE} -- Implementation

	initialize
			-- <Precursor>
		do
			Precursor
			if attached {CMS_STORAGE_SQL_I} storage as l_storage_sql then
				create {CMS_BLOG_STORAGE_SQL} node_storage.make (l_storage_sql)
			else
				create {CMS_BLOG_STORAGE_NULL} node_storage.make
			end
			initialize_node_types
		end

feature {CMS_MODULE} -- Access nodes storage.

	node_storage: CMS_BLOG_STORAGE_I

feature -- Access node

	blogs_count: INTEGER_64
			-- Number of nodes of type blog
		do
			Result := node_storage.blogs_count
		end

	blogs_order_created_desc: LIST[CMS_NODE]
			-- List of nodes ordered by creation date (descending)
		do
			Result := node_storage.blogs
		end

	blogs_order_created_desc_limited (a_limit:INTEGER_32; a_offset:INTEGER_32) : LIST[CMS_NODE]
			-- List of nodes ordered by creation date and limited by limit and offset
		do
			Result := node_storage.blogs_limited (a_limit, a_offset)
		end

end
