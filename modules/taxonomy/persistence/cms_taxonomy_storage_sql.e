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

	vocabulary (a_tid: INTEGER_64): detachable CMS_VOCABULARY
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

	term_by_id (a_tid: INTEGER_64): detachable CMS_TERM
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
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset

			create l_parameters.make (5)
			l_parameters.put (t.text, "text")
			l_parameters.put (t.description, "description")
			l_parameters.put (t.weight, "weight")

			sql_begin_transaction
			if t.has_id then
				l_parameters.put (t.id, "tid")
				sql_modify (sql_update_term, l_parameters)
			else
				sql_insert (sql_insert_term, l_parameters)
				t.set_id (last_inserted_term_id)
			end
			if has_error then
				sql_rollback_transaction
			else
				sql_commit_transaction
			end
			sql_finalize
		end

feature {NONE} -- Queries

	last_inserted_term_id: INTEGER_64
			-- Last insert term id.
		do
			error_handler.reset
			sql_query (Sql_last_inserted_term_id, Void)
			if not has_error and not sql_after then
				Result := sql_read_integer_64 (1)
			end
			sql_finalize
		end

	fetch_term: detachable CMS_TERM
		local
			tid: INTEGER_64
			l_text: detachable READABLE_STRING_32
		do
			tid := sql_read_integer_64 (1)
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

	Sql_last_inserted_term_id: STRING = "SELECT MAX(tid) FROM taxonomy_term;"

	sql_insert_term: STRING = "[
				INSERT INTO taxonomy_terms (tid, text, weight, description, langcode) 
				VALUES (:tid, :text, :weight, :description, null);
			]"

	sql_update_term: STRING = "[
				UPDATE taxonomy_terms 
				SET tid=:tid, text=:text, weight=:weight, description=:description, langcode=null
				WHERE tid=:tid;
			]"
	

end
