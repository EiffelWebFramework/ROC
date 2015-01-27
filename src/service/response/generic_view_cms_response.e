note
	description: "Summary description for {NODE_VIEW_CMS_RESPONSE}."
	date: "$Date: 2014-11-13 16:23:47 +0100 (jeu., 13 nov. 2014) $"
	revision: "$Revision: 96085 $"

class
	GENERIC_VIEW_CMS_RESPONSE

inherit

	CMS_RESPONSE
		redefine
			custom_prepare
		end

create
	make

feature -- Generation

	custom_prepare (page: CMS_HTML_PAGE)
		do
			if attached variables as l_variables then
				across l_variables as c loop page.register_variable (c.item, c.key) end
			end
		end

feature -- Execution

	process
			-- Computed response message.
		do
--			set_title ("CMS")
--			set_page_title (Void)
		end
end

