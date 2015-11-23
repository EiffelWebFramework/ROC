note
	description: "[
				Implementation of taxonomy storage using a SQL database.
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_TAXONOMY_STORAGE_SQL

inherit
	CMS_TAXONOMY_STORAGE_I

	CMS_PROXY_STORAGE_SQL

create
	make

feature -- Access

	vocabulary_count: INTEGER_64
			-- Count of vocabularies.
		do
			error_handler.reset
			sql_query (sql_select_vocabularies_count, Void)
			if not has_error and not sql_after then
				Result := sql_read_integer_64 (1)
			end
			sql_finalize
		end

	vocabularies (limit: NATURAL_32; offset: NATURAL_32): LIST [CMS_VOCABULARY]
			-- List of vocabularies ordered by weight from offset to offset + limit.
		do
			create {ARRAYED_LIST [CMS_VOCABULARY]} Result.make (0)
		end

	vocabulary (a_tid: INTEGER): detachable CMS_VOCABULARY
			-- Vocabulary by id `a_tid'.
		do
			if attached term_by_id (a_tid) as t then
				create Result.make_from_term (t)
			end
		end

	term_count_from_vocabulary (a_vocab: CMS_VOCABULARY): INTEGER_64
			-- Number of terms from vocabulary `a_vocab'.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			create l_parameters.make (1)
			l_parameters.put (a_vocab.id, "parent_tid")
			sql_query (sql_select_vocabulary_terms_count, Void)
			if not has_error and not sql_after then
				Result := sql_read_integer_64 (1)
			end
			sql_finalize
		end

	terms (a_vocab: CMS_VOCABULARY; limit: NATURAL_32; offset: NATURAL_32): LIST [CMS_TERM]
			-- List of terms from vocabulary `a_vocab' ordered by weight from offset to offset + limit.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			create {ARRAYED_LIST [CMS_TERM]} Result.make (0)
			error_handler.reset

			create l_parameters.make (1)
			l_parameters.put (a_vocab.id, "parent_tid")
			from
				sql_query (sql_select_terms, l_parameters)
				sql_start
			until
				sql_after
			loop
				if attached fetch_term as l_term then
					Result.force (l_term)
				end
				sql_forth
			end
			sql_finalize
		end

	terms_count: INTEGER_64
			-- Number of terms.
		do
			error_handler.reset
			sql_query (sql_select_terms_count, Void)
			if not has_error and not sql_after then
				Result := sql_read_integer_64 (1)
			end
			sql_finalize
		end

	term_by_id (a_tid: INTEGER): detachable CMS_TERM
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset

			create l_parameters.make (1)
			l_parameters.put (a_tid, "tid")
			sql_query (sql_select_term, l_parameters)
			sql_start
			if not has_error and not sql_after then
				Result := fetch_term
			end
			sql_finalize
		end

feature -- Store

	save_term (t: CMS_TERM)
		do
		end

--	blogs_count: INTEGER_64
--			-- <Precursor>
--		do
--			error_handler.reset
--			write_information_log (generator + ".blogs_count")
--			sql_query (sql_select_blog_count, Void)
--			if not has_error and not sql_after then
--				Result := sql_read_integer_64 (1)
--			end
--			sql_finalize
--		end

--	blogs_count_from_user (a_user: CMS_USER) : INTEGER_64
--			-- <Precursor>
--		local
--			l_parameters: STRING_TABLE [detachable ANY]
--		do
--			error_handler.reset
--			write_information_log (generator + ".blogs_count_from_user")
--			create l_parameters.make (2)
--			l_parameters.put (a_user.id, "user")
--			sql_query (sql_select_blog_count_from_user, l_parameters)
--			if not has_error and not sql_after then
--				Result := sql_read_integer_64 (1)
--			end
--			sql_finalize
--		end

--	blogs: LIST [CMS_NODE]
--			-- <Precursor>
--		do
--			create {ARRAYED_LIST [CMS_NODE]} Result.make (0)

--			error_handler.reset
--			write_information_log (generator + ".blogs")

--			from
--				sql_query (sql_select_blogs_order_created_desc, Void)
--				sql_start
--			until
--				sql_after
--			loop
--				if attached fetch_node as l_node then
--					Result.force (l_node)
--				end
--				sql_forth
--			end
--			sql_finalize
--		end

--	blogs_limited (a_limit: NATURAL_32; a_offset: NATURAL_32): LIST [CMS_NODE]
--			-- <Precursor>
--		local
--			l_parameters: STRING_TABLE [detachable ANY]
--		do
--			create {ARRAYED_LIST [CMS_NODE]} Result.make (0)

--			error_handler.reset
--			write_information_log (generator + ".blogs_limited")

--			from
--				create l_parameters.make (2)
--				l_parameters.put (a_limit, "limit")
--				l_parameters.put (a_offset, "offset")
--				sql_query (sql_blogs_limited, l_parameters)
--				sql_start
--			until
--				sql_after
--			loop
--				if attached fetch_node as l_node then
--					Result.force (l_node)
--				end
--				sql_forth
--			end
--			sql_finalize
--		end

--	blogs_from_user_limited (a_user: CMS_USER; a_limit: NATURAL_32; a_offset: NATURAL_32): LIST [CMS_NODE]
--			-- <Precursor>
--		local
--			l_parameters: STRING_TABLE [detachable ANY]
--		do
--			create {ARRAYED_LIST [CMS_NODE]} Result.make (0)

--			error_handler.reset
--			write_information_log (generator + ".blogs_from_user_limited")

--			from
--				create l_parameters.make (2)
--				l_parameters.put (a_limit, "limit")
--				l_parameters.put (a_offset, "offset")
--				l_parameters.put (a_user.id, "user")
--				sql_query (sql_blogs_from_user_limited, l_parameters)
--				sql_start
--			until
--				sql_after
--			loop
--				if attached fetch_node as l_node then
--					Result.force (l_node)
--				end
--				sql_forth
--			end
--			sql_finalize
--		end

feature {NONE} -- Queries

	fetch_term: detachable CMS_TERM
		local
			tid: INTEGER
			l_text: detachable READABLE_STRING_32
		do
			tid := sql_read_integer_32 (1)
			l_text := sql_read_string_32 (2)
			if tid > 0 and l_text /= Void then
				create Result.make (tid, l_text)
				Result.set_weight (sql_read_integer_32 (3))
				if attached sql_read_string_32 (4) as l_desc then
					Result.set_description (l_desc)
				end
			end
		end

	sql_select_terms_count: STRING = "SELECT count(*) FROM taxonomy_term ;"
			-- Number of terms.

	sql_select_vocabularies_count: STRING = "SELECT count(*) FROM taxonomy_term INNER JOIN taxonomy_hierarchy ON taxonomy_term.tid = taxonomy_hierarchy.tid WHERE taxonomy_hierarchy.parent = 0;"
			-- Number of terms without parent.

	sql_select_vocabulary_terms_count: STRING = "SELECT count(*) FROM taxonomy_term INNER JOIN taxonomy_hierarchy ON taxonomy_term.tid = taxonomy_hierarchy.tid WHERE taxonomy_hierarchy.parent = :parent_tid;"
			-- Number of terms under :parent_tid.

	sql_select_vocabularies: STRING = "SELECT taxonomy_term.tid, taxonomy_term.text, taxonomy_term.weight, taxonomy_term.description FROM taxonomy_term INNER JOIN taxonomy_hierarchy ON taxonomy_term.tid = taxonomy_hierarchy.tid WHERE taxonomy_hierarchy.parent = 0;"
			-- Terms without parent.

	sql_select_terms: STRING = "SELECT taxonomy_term.tid, taxonomy_term.text, taxonomy_term.weight, taxonomy_term.description FROM taxonomy_term INNER JOIN taxonomy_hierarchy ON taxonomy_term.tid = taxonomy_hierarchy.tid WHERE taxonomy_hierarchy.parent = :parent_tid;"
			-- Terms under :parent_tid.

	sql_select_term: STRING = "SELECT tid, text, weight, description FROM taxonomy_term WHERE tid = :tid;"
			-- Term with tid :tid .

--	sql_select_blog_count_from_user: STRING = "SELECT count(*) FROM nodes WHERE status != -1 AND type = %"blog%" AND author = :user ;"
--			-- Nodes count (Published and not Published)
--			--| note: {CMS_NODE_API}.trashed = -1

--	sql_select_blogs_order_created_desc: STRING = "SELECT * FROM nodes WHERE status != -1 AND type = %"blog%" ORDER BY created DESC;"
--			-- SQL Query to retrieve all nodes that are from the type "blog" ordered by descending creation date.

--	sql_blogs_limited: STRING = "SELECT * FROM nodes WHERE status != -1 AND type = %"blog%" ORDER BY created DESC LIMIT :limit OFFSET :offset ;"
--			--- SQL Query to retrieve all node of type "blog" limited by limit and starting at offset

--	sql_blogs_from_user_limited: STRING = "SELECT * FROM nodes WHERE status != -1 AND type = %"blog%" AND author = :user ORDER BY created DESC LIMIT :limit OFFSET :offset ;"
--			--- SQL Query to retrieve all node of type "blog" from author with id limited by limit + offset


end
