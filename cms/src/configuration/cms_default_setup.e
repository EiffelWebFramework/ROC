note
	description: "Summary description for {CMS_DEFAULT_SETUP}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_DEFAULT_SETUP

inherit
	CMS_SETUP

	REFACTORING_HELPER
create
	make

feature {NONE} -- Initialization

	make (a_layout: CMS_LAYOUT)
		do
			layout := a_layout
			create configuration.make (layout)
			initialize
		end

	initialize
		do
			configure
			create modules.make (3)
			build_mailer
			initialize_modules
		end

	configure
		do
			site_id := configuration.site_id
			site_url := configuration.site_url ("")
			site_name := configuration.site_name ("EWF::CMS")
			site_email := configuration.site_email ("webmaster")
			site_dir := configuration.root_location
			site_var_dir := configuration.var_location
			files_location := configuration.files_location
			themes_location := configuration.themes_location
			theme_name := configuration.theme_name ("default")

			compute_theme_location
			compute_theme_resource_location
		end

	initialize_modules
		local
			m: CMS_MODULE
		do
--			-- Core
--			create {USER_MODULE} m.make (Current)
--			m.enable
--			modules.extend (m)

--			create {ADMIN_MODULE} m.make (Current)
--			m.enable
--			modules.extend (m)

			create {NODE_MODULE} m.make (Current)
			m.enable
			modules.extend (m)
		end

feature -- Access

	modules: CMS_MODULE_COLLECTION
			-- <Precursor>

	is_html: BOOLEAN
			-- <Precursor>
		do
				-- Enable change the mode
			Result := (create {CMS_JSON_CONFIGURATION}).is_html_mode(layout.application_config_path)
		end

	is_web: BOOLEAN
			-- <Precursor>
		do
			Result := (create {CMS_JSON_CONFIGURATION}).is_web_mode(layout.application_config_path)

		end

	build_auth_engine
		do
			to_implement ("Not implemented authentication")
		end

	build_mailer
		do
			to_implement ("Not implemented mailer")
		end

feature -- Compute location

	compute_theme_location
		do
			theme_location := themes_location.extended (theme_name)
		end

	compute_theme_resource_location
			-- assets (js, css, images, etc)
			-- Not used at the moment.
		do
			theme_resource_location := theme_location
		end

end
