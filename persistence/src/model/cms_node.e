note
	description: "Summary description for {NODE}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_NODE

create
	make

feature{NONE} -- Initialization
	make (a_content: READABLE_STRING_32; a_summary:READABLE_STRING_32; a_title: READABLE_STRING_32)
		local
			l_time: DATE_TIME
		do
			create l_time.make_now_utc
			set_content (a_content)
			set_summary (a_summary)
			set_title (a_title)
			set_creation_date (l_time)
			set_modification_date (l_time)
			set_publication_date (l_time)
		ensure
			content_set: content = a_content
			summary_set: summary = a_summary
			title_set: title = a_title
		end

feature -- Access

	content: READABLE_STRING_32
			-- Content of the node.

	summary: READABLE_STRING_32
			-- A short summary of the node.

	title: READABLE_STRING_32
			-- Full title of the node.

	modification_date: DATE_TIME
			-- When the node was updated.

	creation_date: DATE_TIME
			-- When the node was created.

	publication_date: DATE_TIME
			-- When the node was published.

	publication_date_output: READABLE_STRING_32

	id: INTEGER_64 assign set_id
			-- Unique id.

feature -- Element change

	set_content (a_content: like content)
			-- Assign `content' with `a_content'.
		do
			content := a_content
		ensure
			content_assigned: content = a_content
		end

	set_summary (a_summary: like summary)
			-- Assign `summary' with `a_summary'.
		do
			summary := a_summary
		ensure
			summary_assigned: summary = a_summary
		end

	set_title (a_title: like title)
			-- Assign `title' with `a_title'.
		do
			title := a_title
		ensure
			title_assigned: title = a_title
		end

	set_modification_date (a_modification_date: like modification_date)
			-- Assign `modification_date' with `a_modification_date'.
		do
			modification_date := a_modification_date
		ensure
			modification_date_assigned: modification_date = a_modification_date
		end

	set_creation_date (a_creation_date: like creation_date)
			-- Assign `creation_date' with `a_creation_date'.
		do
			creation_date := a_creation_date
		ensure
			creation_date_assigned: creation_date = a_creation_date
		end

	set_publication_date (a_publication_date: like publication_date)
			-- Assign `publication_date' with `a_publication_date'.
		do
			publication_date := a_publication_date
			publication_date_output := publication_date.formatted_out ("yyyy/[0]mm/[0]dd")
		ensure
			publication_date_assigned: publication_date = a_publication_date
		end

	set_id (an_id: like id)
			-- Assign `id' with `an_id'.
		do
			id := an_id
		ensure
			id_assigned: id = an_id
		end

end
