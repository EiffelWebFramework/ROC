note
	description: "Summary description for {CMS_DEFAULT_MODULE_CONFIGURATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_DEFAULT_MODULE_CONFIGURATOR

inherit

	CMS_MODULE_CONFIGURATOR

create
	make

feature {NONE} -- Initialization

	make (a_setup: CMS_SETUP)
		do
			build_modules (a_setup)
		end

feature -- Access

	modules: ARRAYED_LIST [CMS_MODULE]
			-- List of possible modules


feature -- Configuration

	build_modules (a_setup: CMS_SETUP)
			-- Core modules. (User, Admin, Node)
			-- At the moment only node is supported.
		local
			m: CMS_MODULE
		do
			create modules.make (3)
--			-- Core
--			create {USER_MODULE} m.make (a_setup)
--			m.enable
--			modules.extend (m)

--			create {ADMIN_MODULE} m.make (a_setup)
--			m.enable
--			modules.extend (m)

			create {NODE_MODULE} m.make (a_setup)
			m.enable
			modules.extend (m)
		end

end
