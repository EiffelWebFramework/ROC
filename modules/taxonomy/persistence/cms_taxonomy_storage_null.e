note
	description: "Summary description for {CMS_TAXONOMY_STORAGE_NULL}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_TAXONOMY_STORAGE_NULL

inherit
	CMS_TAXONOMY_STORAGE_I

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			create error_handler.make
		end

feature -- Error Handling

	error_handler: ERROR_HANDLER
			-- Error handler.	

feature -- Access

	vocabulary_count: INTEGER_64
			-- Count of vocabularies.
		do
		end

	term_count_from_vocabulary (a_vocab: CMS_VOCABULARY): INTEGER_64
			-- Number of terms from vocabulary `a_vocab'.
		do
		end

	vocabularies (limit: NATURAL_32; offset: NATURAL_32): LIST [CMS_VOCABULARY]
			-- List of vocabularies ordered by weight from offset to offset + limit.
		do
			create {ARRAYED_LIST [CMS_VOCABULARY]} Result.make (0)
		end

	vocabulary (a_id: INTEGER): detachable CMS_VOCABULARY
			-- Vocabulary by id `a_id'.
		do
		end

	terms_count: INTEGER_64
			-- Number of terms.
		do
		end

	term_by_id (tid: INTEGER): detachable CMS_TERM
			-- Term associated with id `tid'.
		do
		end

	terms (a_vocab: CMS_VOCABULARY; limit: NATURAL_32; offset: NATURAL_32): LIST [CMS_TERM]
			-- List of terms from vocabulary `a_vocab' ordered by weight from offset to offset + limit.
		do
			create {ARRAYED_LIST [CMS_TERM]} Result.make (0)
		end

end
