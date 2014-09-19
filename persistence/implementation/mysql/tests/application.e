note
	description : "tests application root class"
	date        : "$Date: 2014-08-20 15:21:15 -0300 (mi., 20 ago. 2014) $"
	revision    : "$Revision: 95678 $"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			user: USER_DATA_PROVIDER
			node: NODE_DATA_PROVIDER
			l_security: SECURITY_PROVIDER
			l_profile, l_db_profile: CMS_USER_PROFILE
			l_cursor: TABLE_ITERATION_CURSOR [READABLE_STRING_8, READABLE_STRING_8]
			l_list: LIST[CMS_NODE]
		do
			create connection.login_with_schema ("cms_dev", "root", "")
			create user.make (connection)
			create node.make (connection)
			(create {CLEAN_DB}).clean_db(connection)

			user.new_user ("test", "test","test@admin.com")
			if attached {CMS_USER} user.user_by_name ("test") as l_user then
				create l_profile.make
				l_profile.force ("Eiffel", "language")
				l_profile.force ("Argentina", "country")
				l_profile.force ("GMT-3", "time zone")
				user.save_profile (l_user.id, l_profile)
				l_db_profile := user.user_profile (l_user.id)
				from
					l_cursor := l_db_profile.new_cursor
				until
					l_cursor.after
				loop
					print (l_cursor.item + " - " + l_cursor.key + "%N")
					l_cursor.forth
				end

				create {ARRAYED_LIST[CMS_NODE]} l_list.make (0)
				node.new_node (default_node)
				node.new_node (custom_node ("content1", "summary1", "title1"))
				node.new_node (custom_node ("content2", "summary2", "title2"))
				node.new_node (custom_node ("content3", "summary3", "title3"))
				user.new_user ("u1", "u1", "email")
				if attached user.user_by_name ("u1") as ll_user then
					node.add_collaborator (l_user.id, 1)
					node.add_collaborator (l_user.id, 2)
					node.add_collaborator (l_user.id, 3)
					node.add_collaborator (l_user.id, 4)

					across node.node_collaborators (1) as c  loop
						print (c.item.name)
					end

				end


			end
		end


feature {NONE} -- Implementation

	connection: DATABASE_CONNECTION_MYSQL


	default_node: CMS_NODE
		do
			Result := custom_node ("Default content", "default summary", "Default")
		end

	custom_node (a_content, a_summary, a_title: READABLE_STRING_32): CMS_NODE
		do
			create Result.make (a_content, a_summary, a_title)
		end

end
