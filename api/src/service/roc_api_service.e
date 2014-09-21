note
	description: "API Service facade to the underlying business logic"
	date: "$Date: 2014-08-20 15:21:15 -0300 (mi., 20 ago. 2014) $"
	revision: "$Revision: 95678 $"

class
	ROC_API_SERVICE

inherit

	SHARED_ERROR
	REFACTORING_HELPER


create make


feature -- Initialize

	make (a_storage: CMS_STORAGE)
			-- Create the API service with an storege `a_storage'.
		do
			storage := a_storage
			set_successful
		ensure
			storage_set: storage = a_storage
		end

feature -- Access

	login_valid (l_auth_login, l_auth_password: READABLE_STRING_32): BOOLEAN
		local
			l_security: SECURITY_PROVIDER
		do
			Result := storage.is_valid_credential (l_auth_login, l_auth_password)
		end

feature -- Access: Node

	nodes: LIST[CMS_NODE]
			-- List of nodes.
		do
			fixme ("Implementation")
			Result := storage.recent_nodes (0, 10)
		end

	recent_nodes (a_offset, a_rows: INTEGER): LIST[CMS_NODE]
			-- List of the `a_rows' most recent nodes starting from  `a_offset'.
		do
			Result := storage.recent_nodes (a_offset, a_rows)
		end

	node (a_id: INTEGER_64): detachable CMS_NODE
			-- Node by ID.
		do
			fixme ("Check preconditions")
			Result := storage.node (a_id)
		end


feature -- Change: Node

	new_node (a_node: CMS_NODE)
			-- Add a new node
		do
			storage.save_node (a_node)
		end

	delete_node (a_id: INTEGER_64)
		do
			storage.delete_node (a_id)
		end

	update_node (a_id: like {CMS_USER}.id; a_node: CMS_NODE)
		do
			storage.update_node (a_id,a_node)
		end

	update_node_title (a_id: like {CMS_USER}.id; a_node_id: like {CMS_NODE}.id; a_title: READABLE_STRING_32)
		do
			fixme ("Check preconditions")
			storage.update_node_title (a_id,a_node_id,a_title)
		end

	update_node_summary (a_id: like {CMS_USER}.id; a_node_id: like {CMS_NODE}.id; a_summary: READABLE_STRING_32)
		do
			fixme ("Check preconditions")
			storage.update_node_summary (a_id,a_node_id, a_summary)
		end

	update_node_content (a_id: like {CMS_USER}.id; a_node_id: like {CMS_NODE}.id; a_content: READABLE_STRING_32)
		do
			fixme ("Check preconditions")
			storage.update_node_content (a_id,a_node_id, a_content)
		end


feature -- Access: User

	user_by_name (a_username: READABLE_STRING_32): detachable CMS_USER
		do
			Result := storage.user_by_name (a_username)
		end
feature -- Change User

	new_user (a_user: CMS_USER)
			-- Add a new user `a_user'.
		do
			if
				attached a_user.password as l_password and then
				attached a_user.email as l_email
			then
				storage.save_user (a_user)
			else
				fixme ("Add error")
			end
		end


feature {NONE} -- Implemenataion


	storage: CMS_STORAGE
		-- Persistence storage

end
