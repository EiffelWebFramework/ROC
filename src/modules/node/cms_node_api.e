note
	description: "[
			API to manage CMS Nodes
		]"
	date: "$Date: 2015-02-13 13:08:13 +0100 (ven., 13 févr. 2015) $"
	revision: "$Revision: 96616 $"

class
	CMS_NODE_API

inherit
	CMS_MODULE_API
		redefine
			initialize
		end

	REFACTORING_HELPER

create
	make

feature {NONE} -- Implementation

	initialize
			-- <Precursor>
		do
			Precursor
			initialize_content_types
		end

	initialize_content_types
			-- Initialize content type system.
		do
			create content_types.make (1)
			add_content_type (create {CMS_PAGE_CONTENT_TYPE})
		end

feature -- Content type

	content_types: ARRAYED_LIST [CMS_CONTENT_TYPE]
			-- Available content types

	add_content_type (a_type: CMS_CONTENT_TYPE)
		do
			content_types.force (a_type)
		end

	content_type (a_name: READABLE_STRING_GENERAL): detachable CMS_CONTENT_TYPE
		do
			across
				content_types as ic
			until
				Result /= Void
			loop
				Result := ic.item
				if not a_name.is_case_insensitive_equal (Result.name) then
					Result := Void
				end
			end
		end

feature -- Access: Node

	nodes_count: INTEGER_64
		do
			Result := storage.nodes_count
		end

	nodes: LIST [CMS_NODE]
			-- List of nodes.
		do
			Result := storage.nodes
		end

	recent_nodes (a_offset, a_rows: INTEGER): LIST [CMS_NODE]
			-- List of the `a_rows' most recent nodes starting from  `a_offset'.
		do
			Result := storage.recent_nodes (a_offset, a_rows)
		end

	node (a_id: INTEGER_64): detachable CMS_NODE
			-- Node by ID.
		do
			debug ("refactor_fixme")
				fixme ("Check preconditions")
			end
			Result := full_node (storage.node_by_id (a_id))
		end

	full_node (a_node: detachable CMS_NODE): detachable CMS_NODE
			-- If `a_node' is partial, return the full node from `a_node',
			-- otherwise return directly `a_node'.
		do
			if attached {CMS_PARTIAL_NODE} a_node as l_partial_node then
				if attached content_type (l_partial_node.content_type) as ct then
					Result := ct.new_node (l_partial_node)
					storage.fill_node (Result)
				else
					Result := l_partial_node
				end
			else
				Result := a_node
			end

				-- Update partial user if needed.
			if
				Result /= Void and then
				attached {CMS_PARTIAL_USER} Result.author as l_partial_author
			then
				if attached cms_api.user_api.user_by_id (l_partial_author.id) as l_author then
					Result.set_author (l_author)
				else
					check
						valid_author_id: False
					end
				end
			end
		end

feature -- Change: Node

	new_node (a_node: CMS_NODE)
			-- Add a new node `a_node'
		require
			no_id: not a_node.has_id
		do
			storage.new_node (a_node)
		end

	delete_node (a_node: CMS_NODE)
			-- Delete `a_node'.
		do
			if a_node.has_id then
				storage.delete_node (a_node)
			end
		end

	update_node (a_node: CMS_NODE)
			-- Update node `a_node' data.
		do
			storage.update_node (a_node)
		end

--	update_node_title (a_user_id: like {CMS_USER}.id; a_node_id: like {CMS_NODE}.id; a_title: READABLE_STRING_32)
--			-- Update node title, with user identified by `a_id', with node id `a_node_id' and a new title `a_title'.
--		do
--			debug ("refactor_fixme")
--				fixme ("Check preconditions")
--			end
--			storage.update_node_title (a_user_id, a_node_id, a_title)
--		end

--	update_node_summary (a_user_id: like {CMS_USER}.id; a_node_id: like {CMS_NODE}.id; a_summary: READABLE_STRING_32)
--			-- Update node summary, with user identified by `a_user_id', with node id `a_node_id' and a new summary `a_summary'.
--		do
--			debug ("refactor_fixme")
--				fixme ("Check preconditions")
--			end
--			storage.update_node_summary (a_user_id, a_node_id, a_summary)
--		end

--	update_node_content (a_user_id: like {CMS_USER}.id; a_node_id: like {CMS_NODE}.id; a_content: READABLE_STRING_32)
--			-- Update node content, with user identified by `a_user_id', with node id `a_node_id' and a new content `a_content'.
--		do
--			debug ("refactor_fixme")
--				fixme ("Check preconditions")
--			end
--			storage.update_node_content (a_user_id, a_node_id, a_content)
--		end


end
