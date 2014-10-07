note
	description: "Summary description for {CMS_SETUP}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_SETUP

feature -- Access

	configuration: CMS_CONFIGURATION
		-- cms configuration.

	layout: CMS_LAYOUT
		-- CMS layout.

	api_service: CMS_API_SERVICE
	    -- cms api service.

	is_html: BOOLEAN
			--  api with progresive enhacements css and js, server side rendering.
		deferred
		end

	is_web: BOOLEAN
			-- web: Web Site with progresive enhacements css and js and Ajax calls.
		deferred
		end

feature -- Access: Site

	site_id: READABLE_STRING_8

	site_name: READABLE_STRING_32

	site_email: READABLE_STRING_8

	site_url: READABLE_STRING_8

	site_dir: PATH

	site_var_dir: PATH

	files_location: PATH

feature -- Access:Theme	

	themes_location: PATH

	theme_location: PATH

	theme_resource_location: PATH
		--

	theme_information_location: PATH
			-- theme informations.
		do
			Result := theme_location.extended ("theme.info")
		end

	theme_name: READABLE_STRING_32
		-- theme name

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
