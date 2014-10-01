note
	description: "Abstract template class"
	date: "$Date: 2014-08-20 15:21:15 -0300 (mi., 20 ago. 2014) $"
	revision: "$Revision: 95678 $"

deferred class
	ROC_TEMPLATE_PAGE

inherit

	SHARED_TEMPLATE_CONTEXT

	SHARED_LOGGER

	ARGUMENTS

feature -- Status

	representation: detachable STRING
			-- String representation, if any.

	set_template_folder (v: PATH)
			-- Set template folder to `v'.
		do
			template_context.set_template_folder (v)
		end

	set_template_file_name (v: STRING)
			-- Set  `template' to `v'.
		do
			create template.make_from_file (v)
		end

	set_template (v: like template)
			-- Set `template' to `v'.
		do
			template := v
		end

	template: TEMPLATE_FILE

	layout: APPLICATION_LAYOUT
		local
			l_env: EXECUTION_ENVIRONMENT
		once
			create l_env
			if attached separate_character_option_value ('d') as l_dir  then
				create Result.make_with_path (create {PATH}.make_from_string (l_dir))
			else
				create Result.make_default
			end
		end

	html_path: PATH
			-- Html template paths.
		do
			Result := layout.template_path.extended ("html")
		end

feature -- Process

	process
			-- Process the current template.
		do
			template_context.enable_verbose
			template.analyze
			template.get_output

			if attached template.output as l_output then
				representation := l_output
				debug
					log.write_debug (generator + ".make " +  l_output)
				end
			end
		end
end
