note
	description: "Generic CMS Response, place to add HOOKS features as collaborators."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_RESPONSE

inherit

	CMS_REQUEST_UTIL

	REFACTORING_HELPER

feature {NONE} -- Initialization

	make (req: WSF_REQUEST; res: WSF_RESPONSE; a_setup: like setup; a_template: like template)
		do
			status_code := {HTTP_STATUS_CODE}.ok
			setup := a_setup
			request := req
			response := res
			template := a_template
			create header.make
			initialize
		end

	initialize
		do
			get_theme
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

	template: READABLE_STRING_32
	 		-- Current template.

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
				create {SMARTY_CMS_THEME} theme.make (setup, l_info, template)
			else
				create {DEFAULT_CMS_THEME} theme.make (setup, l_info)
			end
		end

feature -- Generation

	prepare (page: CMS_HTML_PAGE)
		do
			common_prepare (page)
			custom_prepare (page)
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
			response.send (page)
			on_terminated
		end

	on_terminated
		do

		end

end
