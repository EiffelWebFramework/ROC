note
	description: "[
				API to handle taxonomy vocabularies and terms.
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_TAXONOMY_API

inherit
	CMS_MODULE_API
		redefine
			initialize
		end

	REFACTORING_HELPER

create
	make

feature {NONE} -- Initialization

	initialize
			-- <Precursor>
		do
			Precursor

				-- Create the node storage for type blog
			if attached storage.as_sql_storage as l_storage_sql then
				create {CMS_TAXONOMY_STORAGE_SQL} taxonomy_storage.make (l_storage_sql)
			else
				create {CMS_TAXONOMY_STORAGE_NULL} taxonomy_storage.make
			end
		end

feature {CMS_MODULE} -- Access nodes storage.

	taxonomy_storage: CMS_TAXONOMY_STORAGE_I

feature -- Access node

	vocabulary_count: INTEGER_64
			-- Number of vocabulary.
		do
			Result := taxonomy_storage.vocabulary_count
		end

	vocabularies (a_limit: NATURAL_32; a_offset: NATURAL_32): LIST [CMS_VOCABULARY]
			-- List of vocabularies ordered by weight and limited by limit and offset.
		do
			Result := taxonomy_storage.vocabularies (a_limit, a_offset)
		end

	vocabulary (a_id: INTEGER): detachable CMS_VOCABULARY
			-- Vocabulary associated with id `a_id'.
		require
			valid_id: a_id > 0
		do
			Result := taxonomy_storage.vocabulary (a_id)
		end

	term_count_from_vocabulary (a_vocab: CMS_VOCABULARY): INTEGER_64
			-- Number of terms from vocabulary `a_vocab'.
		require
			has_id: a_vocab.has_id
		do
			Result := taxonomy_storage.term_count_from_vocabulary (a_vocab)
		end

	terms (a_vocab: CMS_VOCABULARY; a_limit: NATURAL_32; a_offset: NATURAL_32): LIST [CMS_TERM]
			-- List of terms ordered by weight and limited by limit and offset.
		require
			has_id: a_vocab.has_id
		do
			Result := taxonomy_storage.terms (a_vocab, a_limit, a_offset)
		end

	term_by_id (a_tid: INTEGER): detachable CMS_TERM
		do
			Result := taxonomy_storage.term_by_id (a_tid)
		end

end
