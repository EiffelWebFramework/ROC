note
	description: "Summary description for {CMS_LAYOUT}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_LAYOUT

inherit

	APPLICATION_LAYOUT

create
	make_default,
	make_with_path


feature -- Access

	theme_path: PATH
			-- Directory for templates (HTML, etc).
		once
			Result := www_path.extended ("theme")
		end

	cms_config_ini_path: PATH
			-- Database Configuration file path.
		once
			Result := config_path.extended ("cms.ini")
		end

end
