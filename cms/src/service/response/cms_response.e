note
	description: "Generic CMS Response, place to add HOOKS features as collaborators."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_RESPONSE

inherit
	CMS_ENCODERS

	CMS_REQUEST_UTIL

	REFACTORING_HELPER

feature {NONE} -- Initialization

	make(req: WSF_REQUEST; res: WSF_RESPONSE; a_setup: like setup)
		do
			status_code := {HTTP_STATUS_CODE}.ok
			setup := a_setup
			request := req
			response := res
			create header.make
			create values.make (3)
			initialize
		end

	initialize
		do
			get_theme
			create menu_system.make
			initialize_block_region_settings
			register_hooks
		end


	register_hooks
		local
			l_module: CMS_MODULE
			l_available_modules: CMS_MODULE_COLLECTION
		do
--			log.write_debug (generator + ".register_hooks")
			l_available_modules := setup.modules
			across
				l_available_modules as ic
			loop
				l_module := ic.item
				if l_module.is_enabled then
					l_module.register_hooks (Current)
				end
			end
		end


feature -- Access

	request: WSF_REQUEST

	response: WSF_RESPONSE

	setup: CMS_SETUP
		-- Current setup

	status_code: INTEGER

	header: WSF_HEADER

	title: detachable READABLE_STRING_32

	page_title: detachable READABLE_STRING_32
			-- Page title

	main_content: detachable STRING_8

	values: CMS_VALUE_TABLE
			-- Associated values indexed by string name.


feature -- Element change				

	set_title (t: like title)
		do
			title := t
			set_page_title (t)
		end

	set_page_title (t: like page_title)
		do
			page_title := t
		end

	set_main_content (s: like main_content)
		do
			main_content := s
		end


feature -- Formats

	formats: CMS_FORMATS
		once
			create Result
		end

feature -- Menu

	menu_system: CMS_MENU_SYSTEM

	main_menu: CMS_MENU
		do
			Result := menu_system.main_menu
		end

	management_menu: CMS_MENU
		do
			Result := menu_system.management_menu
		end

	navigation_menu: CMS_MENU
		do
			Result := menu_system.navigation_menu
		end

	user_menu: CMS_MENU
		do
			Result := menu_system.user_menu
		end

	primary_tabs: CMS_MENU
		do
			Result := menu_system.primary_tabs
		debug
			end
		end

feature -- Blocks initialization

	initialize_block_region_settings
		local
			l_table: like block_region_settings
		do
			fixme ("CHECK:Can we use the same structure as in theme.info?")
			create regions.make_caseless (5)

			fixme ("let the user choose ...")
			create l_table.make_caseless (10)
			l_table["top"] := "top"
			l_table["header"] := "header"
			l_table["highlighted"] := "highlighted"
			l_table["help"] := "help"
			l_table["content"] := "content"
			l_table["footer"] := "footer"
			l_table["management"] := "first_sidebar"
			l_table["navigation"] := "first_sidebar"
			l_table["user"] := "first_sidebar"
			l_table["bottom"] := "page_bottom"
			block_region_settings := l_table
		end

feature -- Blocks regions

	regions: STRING_TABLE [CMS_BLOCK_REGION]
			-- Layout regions, that contains blocks.

	block_region_settings: STRING_TABLE [STRING]

	block_region (b: CMS_BLOCK; a_default_region: detachable READABLE_STRING_8): CMS_BLOCK_REGION
			-- Region associated with block `b', or else `a_default_region' if provided.
		local
			l_region_name: detachable READABLE_STRING_8
		do
			l_region_name := block_region_settings.item (b.name)
			if l_region_name = Void then
				if a_default_region /= Void then
					l_region_name := a_default_region
				else
						-- Default .. put it in same named region
						-- Maybe a bad idea

					l_region_name := b.name.as_lower
				end
			end
			if attached regions.item (l_region_name) as res then
				Result := res
			else
				create Result.make (l_region_name)
				regions.force (Result, l_region_name)
			end
		end


feature -- Blocks 		

	add_block (b: CMS_BLOCK; a_default_region: detachable READABLE_STRING_8)
			-- Add block `b' to associated region or `a_default_region' if provided.
		local
			l_region: detachable like block_region
		do
			l_region := block_region (b, a_default_region)
			l_region.extend (b)
		end

	get_blocks
		do
			fixme ("find a way to have this in configuration or database, and allow different order")
			add_block (top_header_block, "top")
			add_block (header_block, "header")
			if attached message_block as m then
				add_block (m, "content")
			end
				-- FIXME: avoid hardcoded html! should be only in theme.
			add_block (create {CMS_CONTENT_BLOCK}.make_raw ("top_content_anchor", Void, "<a id=%"main-content%"></a>%N", formats.full_html), "content")
			if attached page_title as l_page_title then
					-- FIXME: avoid hardcoded html! should be only in theme.
				add_block (create {CMS_CONTENT_BLOCK}.make_raw ("page_title", Void, "<h1 id=%"page-title%" class=%"title%">"+ l_page_title +"</h1>%N", formats.full_html), "content")
			end
			if attached primary_tabs_block as m then
				add_block (m, "content")
			end
			add_block (content_block, "content")

			if attached management_menu_block as l_block then
				add_block (l_block, "first_sidebar")
			end
			if attached navigation_menu_block as l_block then
				add_block (l_block, "first_sidebar")
			end

			if attached user_menu_block as l_block then
				add_block (l_block, "first_sidebar")
			end

			if attached footer_block as l_block then
				add_block (l_block, "footer")
			end

			hook_block_view
		end

	main_menu_block: detachable CMS_MENU_BLOCK
		do
			if attached main_menu as m and then not m.is_empty then
				create Result.make (m)
			end
		end

	management_menu_block: detachable CMS_MENU_BLOCK
		do
			if attached management_menu as m and then not m.is_empty then
				create Result.make (m)
			end
		end

	navigation_menu_block: detachable CMS_MENU_BLOCK
		do
			if attached navigation_menu as m and then not m.is_empty then
				create Result.make (m)
			end
		end

	user_menu_block: detachable CMS_MENU_BLOCK
		do
			if attached user_menu as m and then not m.is_empty then
				create Result.make (m)
			end
		end

	primary_tabs_block: detachable CMS_MENU_BLOCK
		do
			if attached primary_tabs as m and then not m.is_empty then
				create Result.make (m)
			end
		end

	top_header_block: CMS_CONTENT_BLOCK
		local
			s: STRING
		do
			create s.make_empty
			create Result.make ("page_top", Void, s, formats.full_html)
			Result.set_is_raw (True)
		end

	header_block: CMS_CONTENT_BLOCK
		local
			s: STRING
			tpl: SMARTY_CMS_PAGE_TEMPLATE
			l_page: CMS_HTML_PAGE
			l_hb: STRING
		do
			create s.make_from_string (theme.menu_html (main_menu, True))
			create l_hb.make_empty
			to_implement ("Check if the tpl does not exist, provide a default implementation")
			if attached {SMARTY_CMS_THEME} theme as l_theme then
				create tpl.make ("block/header_test", l_theme)
					-- Change to "block/header_block" to use the template code.
				create l_page.make
				l_page.register_variable (s, "header_block")
				tpl.prepare (l_page)
				l_hb := tpl.to_html (l_page)
			end
			if l_hb.starts_with ("ERROR") then
				l_hb.wipe_out
				to_implement ("Hardcoded HTML with CSS, find a better way to define defaults!!!.")
				l_hb := "[
						  <div class='navbar navbar-inverse'>
					      <div class='navbar-inner nav-collapse' style='height: auto;'>
        			  	  <ul class='nav'>
        				]"
        		l_hb.append (s)
        		l_hb.append ("[
						        </ul>
						      </div>
						    </div>  
						    ]")

			end
			create Result.make ("header", Void, l_hb, formats.full_html)
			Result.set_is_raw (True)
		end

	message_block: detachable CMS_CONTENT_BLOCK
		do
			if attached message as m and then not m.is_empty then
				create Result.make ("message", Void, "<div id=%"message%">" + m + "</div>", formats.full_html)
				Result.set_is_raw (True)
			end
		end

	content_block: CMS_CONTENT_BLOCK
		local
			s: STRING
		do
			if attached main_content as l_content then
				s := l_content
			else
				s := ""
				debug
					s := "No Content"
				end
			end
			create Result.make ("content", Void, s, formats.full_html)
			Result.set_is_raw (True)
		end

	footer_block: CMS_CONTENT_BLOCK
		local
			s: STRING
		do
			create s.make_empty
			s.append ("Made with <a href=%"http://www.eiffel.com/%">EWF</a>")
			create Result.make ("made_with", Void, s, formats.full_html)
		end

feature -- Hook: value alter

	add_value_alter_hook (h: like value_alter_hooks.item)
		local
			lst: like value_alter_hooks
		do
			lst := value_alter_hooks
			if lst = Void then
				create lst.make (1)
				value_alter_hooks := lst
			end
			if not lst.has (h) then
				lst.force (h)
			end
		end

	value_alter_hooks: detachable ARRAYED_LIST [CMS_HOOK_VALUE_ALTER]

	call_value_alter_hooks (m: CMS_VALUE_TABLE)
		do
			if attached value_alter_hooks as lst then
				across
					lst as c
				loop
					c.item.value_alter (m, Current)
				end
			end
		end

feature -- Hook: menu_alter

	add_menu_alter_hook (h: like menu_alter_hooks.item)
		local
			lst: like menu_alter_hooks
		do
			lst := menu_alter_hooks
			if lst = Void then
				create lst.make (1)
				menu_alter_hooks := lst
			end
			if not lst.has (h) then
				lst.force (h)
			end
		end

	menu_alter_hooks: detachable ARRAYED_LIST [CMS_HOOK_MENU_ALTER]

	call_menu_alter_hooks (m: CMS_MENU_SYSTEM )
		do
			if attached menu_alter_hooks as lst then
				across
					lst as c
				loop
					c.item.menu_alter (m, Current)
				end
			end
		end

feature -- Hook: form_alter

	add_form_alter_hook (h: like form_alter_hooks.item)
		local
			lst: like form_alter_hooks
		do
			lst := form_alter_hooks
			if lst = Void then
				create lst.make (1)
				form_alter_hooks := lst
			end
			if not lst.has (h) then
				lst.force (h)
			end
		end

	form_alter_hooks: detachable ARRAYED_LIST [CMS_HOOK_FORM_ALTER]

	call_form_alter_hooks (f: CMS_FORM; a_form_data: detachable WSF_FORM_DATA; )
		do
			if attached form_alter_hooks as lst then
				across
					lst as c
				loop
					c.item.form_alter (f, a_form_data, Current)
				end
			end
		end

feature -- Hook: block		

	add_block_hook (h: like block_hooks.item)
		local
			lst: like block_hooks
		do
			lst := block_hooks
			if lst = Void then
				create lst.make (1)
				block_hooks := lst
			end
			if not lst.has (h) then
				lst.force (h)
			end
		end

	block_hooks: detachable ARRAYED_LIST [CMS_HOOK_BLOCK]

	hook_block_view
		do
			if attached block_hooks as lst then
				across
					lst as c
				loop
					across
						c.item.block_list as blst
					loop
						c.item.get_block_view (blst.item, Current)
					end
				end
			end
		end


feature -- Menu: change

	add_to_main_menu (lnk: CMS_LINK)
		do
--			if attached {CMS_LOCAL_LINK} lnk as l_local then
--				l_local.get_is_active (request)
--			end
			main_menu.extend (lnk)
		end

	add_to_menu (lnk: CMS_LINK; m: CMS_MENU)
		do
--			if attached {CMS_LOCAL_LINK} lnk as l_local then
--				l_local.get_is_active (request)
--			end
			m.extend (lnk)
		end

feature -- Message

	add_message (a_msg: READABLE_STRING_8; a_category: detachable READABLE_STRING_8)
		local
			m: like message
		do
			m := message
			if m = Void then
				create m.make (a_msg.count + 9)
				message := m
			end
			if a_category /= Void then
				m.append ("<li class=%""+ a_category +"%">")
			else
				m.append ("<li>")
			end
			m.append (a_msg + "</li>")
		end

	add_notice_message (a_msg: READABLE_STRING_8)
		do
			add_message (a_msg, "notice")
		end

	add_warning_message (a_msg: READABLE_STRING_8)
		do
			add_message (a_msg, "warning")
		end

	add_error_message (a_msg: READABLE_STRING_8)
		do
			add_message (a_msg, "error")
		end

	add_success_message (a_msg: READABLE_STRING_8)
		do
			add_message (a_msg, "success")
		end

	report_form_errors (fd: WSF_FORM_DATA)
		require
			has_error: not fd.is_valid
		do
			if attached fd.errors as errs then
				across
					errs as err
				loop
					if attached err.item as e then
						if attached e.field as l_field then
							if attached e.message as e_msg then
								add_error_message (e_msg) --"Field [" + l_field.name + "] is invalid. " + e_msg)
							else
								add_error_message ("Field [" + l_field.name + "] is invalid.")
							end
						elseif attached e.message as e_msg then
							add_error_message (e_msg)
						end
					end
				end
			end
		end

	message: detachable STRING_8

feature -- Theme

	theme: CMS_THEME
		-- Current theme

	get_theme
		local
			l_info: CMS_THEME_INFORMATION
		do
			if attached setup.theme_information_location as fn then
				create l_info.make (fn)
			else
				create l_info.make_default
			end
			if l_info.engine.is_case_insensitive_equal_general ("smarty") then
				create {SMARTY_CMS_THEME} theme.make (setup, l_info)
			else
				create {DEFAULT_CMS_THEME} theme.make (setup, l_info)
			end
		end

feature -- Element Change

	set_status_code (a_status: INTEGER)
			-- Set `status_code' with `a_status'.
		note
			EIS: "src=eiffel:?class=HTTP_STATUS_CODE"
		do
			to_implement ("Feature to test if a_status is a valid status code!!!.")
			status_code := a_status
		ensure
			status_code_set: status_code = a_status
		end

feature -- Generation

	prepare (page: CMS_HTML_PAGE)
		do
			common_prepare (page)
			custom_prepare (page)

				-- Cms values
			call_value_alter_hooks (values)

					-- Values Associated with current Execution object.
			across
				values as ic
			loop
				page.register_variable (ic.item, ic.key)
			end

				-- Specific values
			page.register_variable (request.absolute_script_url (""), "site_url")

				-- Additional lines in <head ../>

			add_to_main_menu (create {CMS_LOCAL_LINK}.make ("Home", "/"))
			call_menu_alter_hooks (menu_system)
			prepare_menu_system (menu_system)

			get_blocks
			across
				regions as reg_ic
			loop
				across
					reg_ic.item.blocks as ic
				loop
					if attached {CMS_MENU_BLOCK} ic.item as l_menu_block then
						recursive_get_active (l_menu_block.menu, request)
					end
				end
			end

			if attached title as l_title then
				page.set_title (l_title)
			else
				page.set_title ("CMS::" + request.path_info)
			end

				-- blocks
			across
				regions as reg_ic
			loop
				across
					reg_ic.item.blocks as ic
				loop
					page.add_to_region (theme.block_html (ic.item), reg_ic.item.name)
				end
			end
		end

	common_prepare (page: CMS_HTML_PAGE)
		do
			fixme ("Fix generacion common")
			page.register_variable (request.absolute_script_url (""), "host")
			page.register_variable (setup.is_web, "web")
			page.register_variable (setup.is_html, "html")
			if attached current_user_name (request) as l_user then
				page.register_variable (l_user, "user")
			end
		end

	custom_prepare (page: CMS_HTML_PAGE)
		do
		end


    prepare_menu_system (a_menu_system: CMS_MENU_SYSTEM)
		do
--			across
--				a_menu_system as c
--			loop
--				prepare_links (c.item)
--			end
		end

	prepare_links (a_menu: CMS_LINK_COMPOSITE)
		local
			to_remove: ARRAYED_LIST [CMS_LINK]
		do
			create to_remove.make (0)
			across
				a_menu as c
			loop
				if attached {CMS_LOCAL_LINK} c.item as lm then
--					if attached lm.permission_arguments as perms and then not has_permissions (perms) then
--						to_remove.force (lm)
--					else
						-- if lm.permission_arguments is Void , this is permitted
--						lm.get_is_active (request)
						if attached {CMS_LINK_COMPOSITE} lm as comp then
							prepare_links (comp)
						end
--					end
				elseif attached {CMS_LINK_COMPOSITE} c.item as comp then
					prepare_links (comp)
				end
			end
			across
				to_remove as c
			loop
				a_menu.remove (c.item)
			end
		end

	recursive_get_active (a_comp: CMS_LINK_COMPOSITE; req: WSF_REQUEST)
			-- Update the active status recursively on `a_comp'.
		local
			ln: CMS_LINK
		do
			if attached a_comp.items as l_items then
				across
					l_items as ic
				loop
					ln := ic.item
					if attached {CMS_LOCAL_LINK} ln as l_local then
--						l_local.get_is_active (request)
					end
					if (ln.is_expanded or ln.is_collapsed) and then attached {CMS_LINK_COMPOSITE} ln as l_comp then
						recursive_get_active (l_comp, req)
					end
				end
			end
		end


feature -- Custom Variables

	variables: detachable STRING_TABLE[ANY]
		-- Custom variables to feed the templates.


feature -- Element change: Add custom variables.

	add_variable (a_element: ANY; a_key:READABLE_STRING_32)
		local
			l_variables: like variables
		do
			l_variables := variables
			if l_variables = Void then
				create l_variables.make (5)
				variables := l_variables
			end
			l_variables.force (a_element, a_key)
		end


feature -- Execution

	execute
		do
			begin
			process
			terminate
		end

feature {NONE} -- Execution		

	begin
		do
		end

	process
		deferred
		end

	frozen terminate
		local
			cms_page: CMS_HTML_PAGE
			page: CMS_HTML_PAGE_RESPONSE
		do
			create cms_page.make
			prepare (cms_page)
			create page.make (theme.page_html (cms_page))
			page.set_status_code (status_code)
			page.header.put_content_length (page.html.count)
			page.header.put_current_date
			response.send (page)
			on_terminated
		end

	on_terminated
		do

		end

end
