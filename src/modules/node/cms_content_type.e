note
	description: "[
			Interface defining a CMS content type.
		]"
	status: "draft"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_CONTENT_TYPE

feature -- Access

	name: READABLE_STRING_8
			-- Internal name.
		deferred
		end

	title: READABLE_STRING_32
			-- Human readable name.
		deferred
		end

	description: detachable READABLE_STRING_32
			-- Optional description
		deferred
		end

feature -- Access

	available_formats: LIST [CONTENT_FORMAT]
			-- Available formats for Current type.
		deferred
		end

feature -- Factory

	new_node_with_title (a_title: READABLE_STRING_32; a_partial_node: detachable CMS_NODE): like  new_node
			-- New node with `a_title' and fill from partial `a_partial_node' if set.
		deferred
		end

	new_node (a_partial_node: detachable CMS_NODE): CMS_NODE
			-- New node based on partial `a_partial_node' if set.
		deferred
		end

note
	copyright: "2011-2015, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
