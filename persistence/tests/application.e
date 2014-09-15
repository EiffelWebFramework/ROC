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
		do
			create connection.login_with_schema ("cms", "root", "")
--			create user.make (connection)
----			user.new_user ("jv", "test","test@test.com")

--			if attached user.user (3) as l_user then
--				if attached user.user_salt ("jv") as l_salt then
--					create l_security
--					if attached l_user.password as l_password then
--						print (l_password)
--						io.put_new_line
--						print (l_security.password_hash ("test", l_salt))

--						check same_string: l_security.password_hash ("test", l_salt).is_case_insensitive_equal (l_password) end
--					end
--				end
--			end

--			if attached user.user_by_name ("jv") as l_user then
--				check l_user.id = 3 end
--			end

			create node.make (connection)
			across node.recent_nodes (0, 5) as c loop
				print (c.item)
			end


		end

	connection: DATABASE_CONNECTION_MYSQL

end
