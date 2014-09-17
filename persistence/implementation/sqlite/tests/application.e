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
			create connection.make_basic ("cms_dev")
			create user.make (connection)
			user.new_user ("test", "test", "test")
		end

	connection: DATABASE_CONNECTION_ODBC

end
