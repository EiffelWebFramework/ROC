note
	description: "Summary description for {WSF_CMS_MODULE}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_MODULE

feature -- Access

	is_enabled: BOOLEAN

	name: STRING

	description: STRING

	package: STRING

	version: STRING

feature -- Router

	router: WSF_ROUTER
			-- Router configuration.
		require
			is_enabled: is_enabled
		deferred
		end

feature -- Filter

	filters: detachable LIST [WSF_FILTER]
			-- Optional list of filter for Current module.
		require
			is_enabled: is_enabled
		do
		end

feature -- Settings

	enable
		do
			is_enabled := True
		end

	disable
		do
			is_enabled := False
		end

feature -- Hooks

	help_text (a_path: STRING): STRING
		do
			create Result.make_empty
		end


end
