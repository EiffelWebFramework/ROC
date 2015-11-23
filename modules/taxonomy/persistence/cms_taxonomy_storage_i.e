note
	description: "[
			Interface for accessing taxonomy data from storage.
		]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_TAXONOMY_STORAGE_I

feature -- Error Handling

	error_handler: ERROR_HANDLER
			-- Error handler.
		deferred
		end

feature -- Access

	vocabulary_count: INTEGER_64
			-- Count of vocabularies.
		deferred
		end

	vocabularies (limit: NATURAL_32; offset: NATURAL_32): LIST [CMS_VOCABULARY]
			-- List of vocabularies ordered by weight from offset to offset + limit.
		deferred
		end

	vocabulary (a_id: INTEGER_64): detachable CMS_VOCABULARY
			-- Vocabulary by id `a_id'.
		require
			valid_id: a_id > 0
		deferred
		end

	terms_count: INTEGER_64
			-- Number of terms.
		deferred
		end

	term_by_id (tid: INTEGER_64): detachable CMS_TERM
			-- Term associated with id `tid'.
		deferred
		ensure
			Result /= Void implies Result.id = tid
		end

	term_count_from_vocabulary (a_vocab: CMS_VOCABULARY): INTEGER_64
			-- Number of terms from vocabulary `a_vocab'.
		require
			has_id: a_vocab.has_id
		deferred
		end

	terms (a_vocab: CMS_VOCABULARY; limit: NATURAL_32; offset: NATURAL_32): LIST [CMS_TERM]
			-- List of terms from vocabulary `a_vocab' ordered by weight from offset to offset + limit.
		require
			has_id: a_vocab.has_id
		deferred
		end

feature -- Store

	save_term (t: CMS_TERM)
			-- Insert or update term `t'.
		deferred
		ensure
			not error_handler.has_error implies t.has_id and then term_by_id (t.id) /= Void
		end

end
