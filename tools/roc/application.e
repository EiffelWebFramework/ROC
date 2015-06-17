note
	description: "[
			roc tool: install modules into an existing CMS Application.
			
			roc install [--module|-m <MODULE_PATH>] [(--dir|-d <CMS_PATH>) | <MODULE_NAME>]

			install:  Install a given module to the corresponding cms application
			--module|-m: module path or current directory if is not defined.
			--dir|-d cms application path or current directory if is not defined

			Running the command will copy to the CMS Application site/modules the following artifacts if the current module provide them.

				config
				scripts
				themes
			running
			roc instal blog
			will look for a module blog in the modules directory starting at the current directory.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit

	SHARED_EXECUTION_ENVIRONMENT

	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize tool.
		do
				-- TODO add support to other commands.
			if argument_count = 0 then
				print ("Use: roc install [--module|-m <MODULE_PATH>] [(--dir|-d <CMS_PATH>) | <MODULE_NAME>]")
			elseif argument (1).starts_with ("install") then
				execute_install
			else
				print ("Wrong command")
				print ("%NUse: roc install [--module|-m <MODULE_PATH>] -cap <CMS_PATH>")
			end
		end

feature {NONE} -- Install

	execute_install
			-- Install a new module.
		local
			i: INTEGER
			error: BOOLEAN
			optional_module: BOOLEAN
			cms_path: BOOLEAN
		do
			if is_valid_install_cmd then
				do_execute_install
			end
		end

	do_execute_install
			-- Install a module into a cms application.
			-- Pattern
			-- app/site/modules/module_name/config/....
			-- app/site/modules/module_name/scripts/....
			-- app/site/modules/module_name/themes/....
		local
			l_module_path: PATH
			l_config: PATH
			l_site_dir: DIRECTORY
			l_modules_dir: DIRECTORY
			l_dest_dir: DIRECTORY
			l_file: FILE
		do
			if attached install_cms_path as l_cms_path then
				l_module_path := install_module_path
					--Install configuration files.
				if attached l_module_path.entry as l_entry then
					create l_site_dir.make_with_path (l_cms_path.extended ("site"))
					create l_modules_dir.make_with_path (l_cms_path.extended ("site").extended ("modules"))

					if
						l_site_dir.exists and then
					   l_modules_dir.exists
					then
					    create l_dest_dir.make_with_path (l_cms_path.extended ("site").extended ("modules").extended (l_entry.name))
						if not l_dest_dir.exists then
							l_dest_dir.create_dir
						end
					   	install_module_elements (l_module_path, l_dest_dir.path, Config_dir)
						install_module_elements (l_module_path, l_dest_dir.path, Scripts_dir)
						install_module_elements (l_module_path, l_dest_dir.path, Themes_dir)
						print ("Module ")
						print ( l_entry)
						print ( " was successfuly installed to the cms Application located ")
						print (l_cms_path.name)
						print ("%NCheck the module elements at ")
						print (l_dest_dir.path.name)
					else
						print ("The CMS Application located at does not have the site or modules folders")
					end
				else
					print ("Error not possible to retrieve module name.")
				end
			else
				print ("%NWrong path to CMS application")
			end
		end

	install_module_elements (a_module_path: PATH; a_cms_path: PATH; a_element: STRING)
			-- Install module configuration files from `a_module_path' to cms application `a_cms_path' to the element `a_element'.
		local
			l_config: PATH
			l_dest_dir: DIRECTORY
			l_src_dir: DIRECTORY
			l_file: FILE
		do
			if attached a_module_path.entry as l_entry then
				l_config := a_module_path.extended ("site").extended (a_element)

				create l_src_dir.make_with_path (l_config)
					-- Create the element
				create l_dest_dir.make_with_path (a_cms_path.extended(a_element))
				if not l_dest_dir.exists then
					l_dest_dir.create_dir
				end
				copy_elements (l_src_dir, l_dest_dir)
			else
				print ("Error not possible to retrieve module name.")
			end
		end


	copy_elements (a_src_dir: DIRECTORY; a_dest_dir: DIRECTORY)
			-- Copy all elements from a_src_dir to a_dest_dir.
		local
			l_dir: DIRECTORY
			l_new_dir: DIRECTORY
			entry: PATH
			l_file: FILE
		do
			across
				a_src_dir.entries as ic
			loop
				entry := ic.item
				if not (entry.is_current_symbol or else entry.is_parent_symbol) then
					create {RAW_FILE} l_file.make_with_path (a_src_dir.path.extended_path (ic.item))
					if not l_file.is_directory then
						copy_file (l_file, a_dest_dir.path)
					else
						create l_dir.make_with_path (a_src_dir.path.extended_path (entry))
						create l_new_dir.make_with_path (a_dest_dir.path.extended_path (entry))
						if not l_new_dir.exists then
							l_new_dir.create_dir
						end
						if l_dir.exists then
							copy_elements (l_dir, l_new_dir)
						end
					end
				end
			end
		end


feature {NONE} -- Copy File

	copy_file (a_file: FILE; a_dir: PATH)
			--Copy file `a_file' to dir `a_dir'.
		local
			l_dest: RAW_FILE
			l_path: PATH
		do
			if attached a_file.path.entry as l_name then
				l_path := a_dir.absolute_path.extended (l_name.name)
				create l_dest.make_with_path (l_path)
				l_dest.create_read_write
				a_file.open_read
					-- Copy file source to destination
				if l_dest.exists and then l_dest.is_writable and then a_file.exists and then a_file.is_readable then
					a_file.copy_to (l_dest)
					a_file.close
					l_dest.close
				end
			else
			end
		end

feature {NONE} -- Command Validator

	install_module_path: PATH
			-- Path to the module to install.
		do
			if attached separate_word_option_value ("m") as l_m then
				create Result.make_from_string (l_m)
			elseif attached separate_word_option_value ("-module") as l_m then
				create Result.make_from_string (l_m)
			else
				Result := Execution_environment.current_working_path
			end
		end

	install_cms_path: PATH
			-- Path to the cms application to install a module.
		local
			l_dir: DIRECTORY
		do
			if attached separate_word_option_value ("d") as l_m then
				create Result.make_from_string (l_m)
			elseif attached separate_word_option_value ("-dir") as l_m then
				create Result.make_from_string (l_m)
			else
				Result := Execution_environment.current_working_path.extended ("modules")
			end
		end

	is_valid_install_cmd: BOOLEAN
			-- Is the submitted install command valid?
			-- install [--module|-m %MODULE_PATH%] -cap %CMS_PATH%
		local
			i: INTEGER
			error: BOOLEAN
			optional_module: BOOLEAN
			cms_path: BOOLEAN
		do
				-- TODO add error reporting.
			if argument_count >= 2 and then argument_count <= 5 then
				from
					i := 2
				until
					i > argument_count
				loop
					if option_word_equal (argument (i), "m") then
						optional_module := True
					elseif option_word_equal (argument (i), "-module") then
						optional_module := True
					elseif option_word_equal (argument (i), "d") then
						cms_path := True
					elseif option_word_equal (argument (i), "-dir") then
						cms_path := True
					end
					i := i + 1
				end
				if argument_count = 5 then
					if (cms_path and optional_module) then
							-- valid command
						Result := True
					else
						print ("Error check the optional argument --module|-m and --dir|-d")
					end
				elseif argument_count = 3 then
					if (cms_path and not optional_module) then
						Result := True
					else
						print ("Error missing value for dir")
						Result := False
					end
				else
					Result := True
				end
			else
				Result := False
				if argument_count > 5 then
					print ("Too many arguments")
				end
				if argument_count < 2 then
					print ("Too few argumetns")
				end
			end
		end

feature -- Constants

	Config_dir: STRING = "config"
		-- Configuration dir.

	Scripts_dir: STRING = "scripts"
		-- Scripts dir.

	Themes_dir: STRING = "themes"
		-- Themes dir.

end
