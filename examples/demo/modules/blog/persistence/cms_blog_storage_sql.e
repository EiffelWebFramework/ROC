note
	description: "Access to the sql database for the blog module"
	author: "Dario Bösch <daboesch@student.ethz.ch>"
	date: "$Date: 2015-05-21 14:46:00 +0100$"
	revision: "$Revision: 96616 $"

class
	CMS_BLOG_STORAGE_SQL

inherit
	CMS_NODE_STORAGE_SQL

	CMS_BLOG_STORAGE_I

create
	make

feature -- Access

	blogs_count: INTEGER_64
			-- Count of blog nodes
		do
			error_handler.reset
			write_information_log (generator + ".nodes_count")
			sql_query (sql_select_blog_count, Void)
			if sql_rows_count = 1 then
				Result := sql_read_integer_64 (1)
			end
		end

	blogs: LIST [CMS_NODE]
			-- List of nodes ordered by creation date (descending).
		do
			create {ARRAYED_LIST [CMS_NODE]} Result.make (0)

			error_handler.reset
			write_information_log (generator + ".nodes")

			from
				sql_query (sql_select_blogs_order_created_desc, Void)
				sql_start
			until
				sql_after
			loop
				if attached fetch_node as l_node then
					Result.force (l_node)
				end
				sql_forth
			end
		end

	blogs_limited (a_limit:NATURAL_32; a_offset:NATURAL_32) : LIST[CMS_NODE]
			-- List of nodes ordered by creation date from limit to limit + offset
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			create {ARRAYED_LIST [CMS_NODE]} Result.make (0)

			error_handler.reset
			write_information_log (generator + ".nodes")

			from
				create l_parameters.make (2)
				l_parameters.put (a_limit, "limit")
				l_parameters.put (a_offset, "offset")
				sql_query (sql_blogs_limited, l_parameters)
				sql_start
			until
				sql_after
			loop
				if attached fetch_node as l_node then
					Result.force (l_node)
				end
				sql_forth
			end
		end

feature {NONE} -- Queries

	sql_select_blog_count: STRING = "SELECT count(*) FROM Nodes WHERE status != -1 AND type = %"blog%";"
			-- Nodes count (Published and not Published)
			--| note: {CMS_NODE_API}.trashed = -1

	sql_select_blogs_order_created_desc: STRING = "SELECT * FROM Nodes WHERE status != -1 AND type = %"blog%" ORDER BY created DESC;"
			-- SQL Query to retrieve all nodes that are from the type "blog" ordered by descending creation date.

	sql_blogs_limited: STRING = "SELECT * FROM Nodes WHERE status != -1 AND type = %"blog%" ORDER BY created DESC LIMIT :limit OFFSET :offset ;"
			--- SQL Query to retrieve all node of type "blog" from limit to limit + offset

end
