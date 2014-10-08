note
	description: "Summary description for {CMS_DEFAULT_MODULE_COLLECTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_DEFAULT_MODULE_COLLECTION

inherit
	CMS_MODULE_COLLECTION
		rename
			make as make_with_capacity
		end

create
	make

feature {NONE} -- Initialization

	make (a_setup: CMS_SETUP)
		do
			make_with_capacity (3)
			build_modules (a_setup)
		end

feature -- Configuration

	build_modules (a_setup: CMS_SETUP)
			-- Core modules. (User, Admin, Node)
			-- At the moment only node is supported.
		local
			m: CMS_MODULE
		do
--			-- Core
--			create {USER_MODULE} m.make (a_setup)
--			m.enable
--			extend (m)

--			create {ADMIN_MODULE} m.make (a_setup)
--			m.enable
--			extend (m)


			create {BASIC_AUTH_MODULE} m.make (a_setup)
			m.enable
			extend (m)

			create {NODE_MODULE} m.make (a_setup)
			m.enable
			extend (m)
		end

end
