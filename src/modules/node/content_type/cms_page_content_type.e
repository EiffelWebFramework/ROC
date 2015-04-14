note
	description: "Summary description for {CMS_PAGE_CONTENT_TYPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_PAGE_CONTENT_TYPE

inherit
	CMS_CONTENT_TYPE

feature -- Access

	name: STRING = "page"
			-- Internal name.

	title: STRING_32 = "Page"
			-- Human readable name.

feature -- Factory

	new_node (a_partial_node: detachable CMS_NODE): CMS_PAGE
			-- New node based on partial `a_partial_node', or from none.
		do
			create Result.make_empty
			if a_partial_node /= Void then
				Result.import_node (a_partial_node)
			end
		end

end
