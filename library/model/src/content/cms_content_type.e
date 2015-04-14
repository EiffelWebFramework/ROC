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

feature -- Factory

	new_node (a_partial_node: detachable CMS_NODE): CMS_NODE
			-- New node based on partial `a_partial_node', or from none.
		deferred
		end

note
	copyright: "2011-2015, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
