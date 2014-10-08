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
		deferred
		end

feature -- Filter

	filters: detachable LIST [WSF_FILTER]
		-- Possibly list of Filter's module.

feature -- Element Change: Filter

	add_filter (a_filter: WSF_FILTER)
			-- Add a filter `a_filter' to the list of module filters `filters'.
		local
			l_filters: like filters
		do
			l_filters := filters
			if l_filters = Void then
				create {ARRAYED_LIST [WSF_FILTER]} l_filters.make (1)
				filters := l_filters
			end
			l_filters.force (a_filter)
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
