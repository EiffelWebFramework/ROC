note
	description: "Summary description for {CMS_STORAGE_NULL}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_STORAGE_NULL

inherit

	CMS_STORAGE
	REFACTORING_HELPER


feature -- Access: user

	has_user: BOOLEAN
			-- Has any user?
		do
		end


	all_users: LIST [CMS_USER]
		do
			create {ARRAYED_LIST[CMS_USER]} Result.make (0)
		end

	user_by_id (a_id: like {CMS_USER}.id): detachable CMS_USER
		do
		end

	user_by_name (a_name: like {CMS_USER}.name): detachable CMS_USER
		do
		end

	user_by_email (a_email: like {CMS_USER}.email): detachable CMS_USER
		do
		end

	is_valid_credential (l_auth_login, l_auth_password: READABLE_STRING_32): BOOLEAN
		do
		end

feature -- User Nodes

	user_collaborator_nodes (a_id: like {CMS_USER}.id): LIST[CMS_NODE]
			-- Possible list of nodes where the user identified by `a_id', is a collaborator.
		do
		end

	user_author_nodes (a_id: like {CMS_USER}.id): LIST[CMS_NODE]
			-- Possible list of nodes where the user identified by `a_id', is the author.
		do
		end

feature -- Change: user

	save_user (a_user: CMS_USER)
			-- Add a new user `a_user'.
		do
		end

feature -- Access: roles and permissions

	user_role_by_id (a_id: like {CMS_USER_ROLE}.id): detachable CMS_USER_ROLE
		do
		end

	user_roles: LIST [CMS_USER_ROLE]
		do
		end


feature -- Change: roles and permissions		

	save_user_role (a_user_role: CMS_USER_ROLE)
		do
		end


feature -- Access: node

	nodes: LIST[CMS_NODE]
			-- List of nodes.
		do
			create {ARRAYED_LIST[CMS_NODE]} Result.make (0)
		end

	recent_nodes (a_lower: INTEGER; a_count: INTEGER): LIST [CMS_NODE]
			-- List of the `a_count' most recent nodes, starting from `a_lower'.
		do
			create {ARRAYED_LIST[CMS_NODE]} Result.make (0)
		end

	node (a_id: INTEGER_64): detachable CMS_NODE
			-- <Precursor>
		do
		end

	node_author (a_id: like {CMS_NODE}.id): detachable CMS_USER
			-- Node's author. if any.
		do
		end

	node_collaborators (a_id: like {CMS_NODE}.id): LIST [CMS_USER]
			-- Possible list of node's collaborator.
		do
		end

feature -- Node

	save_node (a_node: CMS_NODE)
			-- Add a new node
		do
		end

	delete_node (a_id: INTEGER_64)
			-- <Precursor>
		do
		end

	update_node (a_node: CMS_NODE)
			-- <Precursor>
		do
		end

	update_node_title (a_id: INTEGER_64; a_title: READABLE_STRING_32)
			-- <Precursor>
		do
		end

	update_node_summary (a_id: INTEGER_64; a_summary: READABLE_STRING_32)
			-- <Precursor>
		do
		end

	update_node_content (a_id: INTEGER_64; a_content: READABLE_STRING_32)
			-- <Precursor>
		do
		end

	add_node_author (a_node_id: like {CMS_NODE}.id; a_user_id: like {CMS_USER}.id)
			-- Add author `a_user_id' to the node `a_node_id'.
		do
		end

	add_node_collaborator (a_node_id: like {CMS_NODE}.id; a_user_id: like {CMS_USER}.id)
			-- Add/Update collaborator with `a_user_id' to the node `a_node_id'.
		do
		end

feature -- User

	new_user (a_user: CMS_USER)
			-- Add a new user `a_user'.
		do
		end

end
