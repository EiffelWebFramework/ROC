note
	description: "API Service facade to the underlying business logic"
	date: "$Date: 2014-08-20 15:21:15 -0300 (mi., 20 ago. 2014) $"
	revision: "$Revision: 95678 $"

class
	ROC_API_SERVICE

inherit

	SHARED_ERROR


create make_with_database


feature -- Initialize

	make_with_database (a_connection: DATABASE_CONNECTION)
			-- Create the API service
		require
			is_connected: a_connection.is_connected
		do
			log.write_information (generator+".make_with_database is database connected?  "+ a_connection.is_connected.out )
			create node_provider.make (a_connection)
			create user_provider.make (a_connection)
			post_node_provider_execution
			post_user_provider_execution
		end

feature -- Access

	login_valid (l_auth_login, l_auth_password: READABLE_STRING_32): BOOLEAN
		local
			l_security: SECURITY_PROVIDER
		do
			if attached user_provider.user_salt (l_auth_login) as l_hash then
				if attached user_provider.user_by_name (l_auth_login) as l_user then
					create l_security
					if
						attached l_user.password as l_password and then
					   	l_security.password_hash (l_auth_password, l_hash).is_case_insensitive_equal (l_password)
					then
						Result := True
					else
						log.write_information (generator + ".login_valid User: wrong username or password" )
					end
				else
					log.write_information (generator + ".login_valid User:" + l_auth_login + "does not exist" )
				end
			end
			post_user_provider_execution
		end

	nodes: LIST[CMS_NODE]
			-- List of nodes.
		do
			create {ARRAYED_LIST[CMS_NODE]} Result.make (0)
			across node_provider.nodes as c loop
				Result.force (c.item)
			end
			post_node_provider_execution
		end

	recent_nodes (a_rows: INTEGER): LIST[CMS_NODE]
			-- List of the `a_rows' most recent nodes.
		do
			create {ARRAYED_LIST[CMS_NODE]} Result.make (0)
			across node_provider.recent_nodes (0,a_rows) as c loop
				Result.force (c.item)
			end
			post_node_provider_execution
		end

	node (a_id: INTEGER_64): detachable CMS_NODE
			--
		do
			Result :=  node_provider.node (a_id)
			post_node_provider_execution
		end


feature -- Node

	new_node (a_node: CMS_NODE)
			-- Add a new node
		do
			node_provider.new_node (a_node)
			post_node_provider_execution
		end

	delete_node (a_id: INTEGER_64)
		do
			node_provider.delete_node (a_id)
			post_node_provider_execution
		end

	update_node (a_node: CMS_NODE)
		do
			node_provider.update_node (a_node)
			post_node_provider_execution
		end

	update_node_title (a_id: INTEGER_64; a_title: READABLE_STRING_32)
		do
			node_provider.update_node_title (a_id, a_title)
			post_node_provider_execution
		end

	update_node_summary (a_id: INTEGER_64; a_summary: READABLE_STRING_32)
		do
			node_provider.update_node_summary (a_id, a_summary)
			post_node_provider_execution
		end

	update_node_content (a_id: INTEGER_64; a_content: READABLE_STRING_32)
		do
			node_provider.update_node_content (a_id, a_content)
			post_node_provider_execution
		end


feature -- User

	new_user (a_user: CMS_USER)
			-- Add a new user `a_user'.
		do
			if
				attached a_user.password as l_password and then
				attached a_user.email as l_email
			then
				user_provider.new_user (a_user.name, l_password, l_email)
			else
				-- set error
			end
		end

feature {NONE} -- Post process

	post_node_provider_execution
		do
			if node_provider.successful then
				set_successful
			else
				if attached node_provider.last_error then
					set_last_error_from_handler (node_provider.last_error)
				end
			end
		end

	post_user_provider_execution
		do
			if user_provider.successful then
				set_successful
			else
				if attached user_provider.last_error then
					set_last_error_from_handler (user_provider.last_error)
				end
			end
		end

	node_provider: NODE_DATA_PROVIDER
			-- Node Data provider.

	user_provider: USER_DATA_PROVIDER
			-- User Data provider.

end
