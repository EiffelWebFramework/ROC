note
	description: "Summary description for {CMS_USER_FORM_RESPONSE}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_USER_FORM_RESPONSE

inherit

	CMS_RESPONSE
		redefine
			make,
			initialize,
			custom_prepare
		end

create
	make

feature {NONE} -- Initialization

	make (req: WSF_REQUEST; res: WSF_RESPONSE; a_api: like api)
		do
			create {WSF_NULL_THEME} wsf_theme.make
			Precursor (req, res, a_api)
		end

	initialize
		do
			Precursor
			create {CMS_TO_WSF_THEME} wsf_theme.make (Current, theme)
		end

	wsf_theme: WSF_THEME

feature -- Query

	user_id_path_parameter (req: WSF_REQUEST): INTEGER_64
			-- User id passed as path parameter for request `req'.
		local
			s: STRING
		do
			if attached {WSF_STRING} req.path_parameter ("id") as p_nid then
				s := p_nid.value
				if s.is_integer_64 then
					Result := s.to_integer_64
				end
			end
		end

feature -- Process

	process
			-- Computed response message.
		local
			b: STRING_8
			uid: INTEGER_64
			user_api: CMS_USER_API
		do
			user_api := api.user_api
			create b.make_empty
			uid := user_id_path_parameter (request)
			if
				uid > 0 and then
				attached user_api.user_by_id (uid) as l_user
			then
				fixme ("refactor: process_edit, process_create process edit")
 				if
					request.path_info.ends_with_general ("/edit")
				then
					edit_form (l_user)
				elseif	request.path_info.ends_with_general ("/delete")  then
					delete_form (l_user)
				end
			else
				new_form
			end
		end

feature -- Process Edit

	edit_form (a_user: CMS_USER)
		local
			f: like new_edit_form
			b: STRING
			fd: detachable WSF_FORM_DATA
		do
			create b.make_empty
			f := new_edit_form (a_user, url (request.path_info, Void), "edit-user")
			invoke_form_alter (f, fd)
			if request.is_post_request_method then
				f.submit_actions.extend (agent edit_form_submit (?, a_user, b))
				f.process (Current)
				fd := f.last_data
			end
			if a_user.has_id then
				add_to_menu (create {CMS_LOCAL_LINK}.make (translation ("View", Void),"admin/user/" + a_user.id.out), primary_tabs)
				add_to_menu (create {CMS_LOCAL_LINK}.make (translation ("Edit", Void),"admin/user/" + a_user.id.out + "/edit"), primary_tabs)
				add_to_menu (create {CMS_LOCAL_LINK}.make (translation ("Delete", Void),"admin/user/" + a_user.id.out + "/delete"), primary_tabs)
			end
			if attached redirection as l_location then
				-- FIXME: Hack for now
				set_title (a_user.name)
				b.append (html_encoded (a_user.name) + " saved")
			else
				set_title (formatted_string (translation ("Edit $1 #$2", Void), [a_user.name, a_user.id]))
				f.append_to_html (wsf_theme, b)
			end
			set_main_content (b)
		end

feature -- Process Delete

	delete_form (a_user: CMS_USER)
		local
			f: like new_delete_form
			b: STRING
			fd: detachable WSF_FORM_DATA
		do
			create b.make_empty
			f := new_delete_form (a_user, url (request.path_info, Void), "edit-user")
			invoke_form_alter (f, fd)
			if request.is_post_request_method then
				f.process (Current)
				fd := f.last_data
			end
			if a_user.has_id then
				add_to_menu (create {CMS_LOCAL_LINK}.make (translation ("View", Void),"admin/user/" + a_user.id.out ), primary_tabs)
				add_to_menu (create {CMS_LOCAL_LINK}.make (translation ("Edit", Void),"admin/user/" + a_user.id.out + "/edit"), primary_tabs)
				add_to_menu (create {CMS_LOCAL_LINK}.make (translation ("Delete", Void),"admin/user/" + a_user.id.out + "/delete"), primary_tabs)
			end
			if attached redirection as l_location then
				-- FIXME: Hack for now
				set_title (a_user.name)
				b.append (html_encoded (a_user.name) + " deleted")
			else
				set_title (formatted_string (translation ("Delete $1 #$2", Void), [a_user.name, a_user.id]))
				f.append_to_html (wsf_theme, b)
			end
			set_main_content (b)
		end


feature -- Process New

	new_form
		local
			f: like new_edit_form
			b: STRING
			fd: detachable WSF_FORM_DATA
			l_user: detachable CMS_USER
		do
			create b.make_empty
			f := new_edit_form (l_user, url (request.path_info, Void), "create-user")
			invoke_form_alter (f, fd)
			if request.is_post_request_method then
				f.validation_actions.extend (agent new_form_validate (?, b))
				f.submit_actions.extend (agent edit_form_submit (?, l_user, b))
				f.process (Current)
				fd := f.last_data
			end
			if attached redirection as l_location then
				-- FIXME: Hack for now
				if attached l_user then
					set_title (l_user.name)
					b.append (html_encoded (l_user.name) + " Saved")
				end
			else
				if attached l_user then
					set_title (formatted_string (translation ("Saved $1 #$2", Void), [l_user.name, l_user.id]))
				end
				f.append_to_html (wsf_theme, b)
			end
			set_main_content (b)
		end

feature -- Form	

	edit_form_submit (fd: WSF_FORM_DATA; a_user: detachable CMS_USER; b: STRING)
		local
			l_update_roles: BOOLEAN
			l_update_user: BOOLEAN
			l_save_user: BOOLEAN
			l_user: detachable CMS_USER
			s: STRING
			lnk: CMS_LINK
		do

			l_update_roles := attached {WSF_STRING} fd.item ("op") as l_op and then l_op.same_string ("Update user role")
			if l_update_roles then
				debug ("cms")
					across
						fd as c
					loop
						b.append ("<li>" +  html_encoded (c.key) + "=")
						if attached c.item as v then
							b.append (html_encoded (v.string_representation))
						end
						b.append ("</li>")
					end
				end
				if a_user /= Void then
					l_user := a_user
					if l_user.has_id then
						create {CMS_LOCAL_LINK}lnk.make (translation ("View", Void),"admin/user/" + l_user.id.out )
						change_user (fd, a_user)
						s := "modified"
						set_redirection (lnk.location)
					end
				end
			end
			l_update_user := attached {WSF_STRING} fd.item ("op") as l_op and then l_op.same_string ("Update user")
			if l_update_user then
				debug ("cms")
					across
						fd as c
					loop
						b.append ("<li>" +  html_encoded (c.key) + "=")
						if attached c.item as v then
							b.append (html_encoded (v.string_representation))
						end
						b.append ("</li>")
					end
				end
				if a_user /= Void then
					l_user := a_user
					if l_user.has_id then
						change_user (fd, a_user)
						s := "modified"
					end
				end
			end
			l_save_user := attached {WSF_STRING} fd.item ("op") as l_op and then l_op.same_string ("Create user")
			if l_save_user then
				debug ("cms")
					across
						fd as c
					loop
						b.append ("<li>" +  html_encoded (c.key) + "=")
						if attached c.item as v then
							b.append (html_encoded (v.string_representation))
						end
						b.append ("</li>")
					end
				end
				create_user (fd)
			end

		end

	new_edit_form (a_user: detachable CMS_USER; a_url: READABLE_STRING_8; a_name: STRING;): CMS_FORM
			-- Create a web form named `a_name' for uSER `a_YSER' (if set), using form action url `a_url'.
		local
			f: CMS_FORM
			th: WSF_FORM_HIDDEN_INPUT
		do
			create f.make (a_url, a_name)

			create th.make ("user-id")
			if a_user /= Void then
				th.set_text_value (a_user.id.out)
			else
				th.set_text_value ("0")
			end
			f.extend (th)

			populate_form (f, a_user)

			Result := f
		end

	new_form_validate (fd: WSF_FORM_DATA; b: STRING)
		do
			if attached fd.string_item ("op") as f_op then
				if f_op.is_case_insensitive_equal_general ("Create user") then
					if attached fd.string_item ("username") as l_username then
						if attached api.user_api.user_by_name (l_username) then
							fd.report_invalid_field ("username", "Username already taken!")
						end
					else
						fd.report_invalid_field ("username", "missing username")
									end
									if attached fd.string_item ("email") as l_email then
										if attached api.user_api.user_by_email (l_email) then
											fd.report_invalid_field ("email", "Email address already associated with an existing account!")
										end
									else
										fd.report_invalid_field ("email", "missing email address")
									end
								elseif f_op.is_case_insensitive_equal_general ("Update user") then
									if attached fd.string_item ("username") as l_username then
										if api.user_api.user_by_name (l_username) = Void then
											fd.report_invalid_field ("username", "Username does not exist!")
										end
									else
										fd.report_invalid_field ("username", "missing username")
									end
								end
							end
						end

	new_delete_form (a_user: detachable CMS_USER; a_url: READABLE_STRING_8; a_name: STRING;): CMS_FORM
			-- Create a web form named `a_name' for node `a_user' (if set), using form action url `a_url'.
		local
			f: CMS_FORM
			ts: WSF_FORM_SUBMIT_INPUT
		do
			create f.make (a_url, a_name)
			f.extend_html_text ("<br/>")
			f.extend_html_text ("<legend>Are you sure you want to delete?</legend>")

				-- TODO check if we need to check for has_permissions!!
			if
				a_user /= Void and then
				a_user.has_id
			then
				create ts.make ("op")
				ts.set_default_value ("Delete")
				fixme ("[
					ts.set_default_value (translation ("Delete"))
					]")

				f.extend (ts)
				create ts.make ("op")
				ts.set_default_value ("Cancel")
				ts.set_formmethod ("GET")
				ts.set_formaction ("/admin/user/" + a_user.id.out)
				f.extend (ts)
			end

			Result := f
		end



	populate_form (a_form: WSF_FORM; a_user: detachable CMS_USER)
			-- Fill the web form `a_form' with data from `a_node' if set,
			-- and apply this to content type `a_content_type'.
		local
			ti: WSF_FORM_TEXT_INPUT
			fe: WSF_FORM_EMAIL_INPUT
			fs: WSF_FORM_FIELD_SET
			cb: WSF_FORM_CHECKBOX_INPUT
			ts: WSF_FORM_SUBMIT_INPUT
		do
			if attached a_user as l_user then
				create fs.make
				fs.set_legend ("Basic User Account Information")
				fs.extend_html_text ("<div><string><label>User name </label></strong><br></div>")
				fs.extend_html_text (l_user.name)
				if attached l_user.email as l_email then
					create fe.make_with_text ("email", l_email)
				else
					create fe.make_with_text ("email", "")
				end
				fe.set_label ("Email")
				fe.enable_required
				fs.extend (fe)
				a_form.extend (fs)
				a_form.extend_html_text ("<br/>")
				create ts.make ("op")
				ts.set_default_value ("Update user")
				a_form.extend (ts)
				a_form.extend_html_text ("<hr>")


				create fs.make
				fs.set_legend ("User Roles")


				if attached {LIST[CMS_USER_ROLE]} api.user_api.user_roles (l_user) as u_roles and then
				   not u_roles.is_empty
				then
					u_roles.compare_objects
					across api.user_api.roles as ic loop
						if u_roles.has (ic.item) then
							create cb.make_with_value ("cms_roles", ic.item.id.out)
							cb.set_checked (True)
							cb.set_label (ic.item.name)
							fs.extend (cb)
						else
							create cb.make_with_value ("cms_roles", ic.item.id.out)
							cb.set_label (ic.item.name)
							fs.extend (cb)
						end
					end
				else
					across api.user_api.roles as ic loop
						create cb.make_with_value ("cms_roles", ic.item.id.out)
						cb.set_label (ic.item.name)
						fs.extend (cb)
					end
				end
				a_form.extend (fs)
				create ts.make ("op")
				ts.set_default_value ("Update user role")
				a_form.extend (ts)
			else
				create fs.make
				fs.set_legend ("Basic User Account Information")
				create ti.make ("username")
				ti.set_label ("Username")
				ti.enable_required
				fs.extend (ti)
				create fe.make_with_text ("email", "")
				fe.set_label ("Email")
				fe.enable_required
				fs.extend (fe)
				a_form.extend (fs)
				a_form.extend_html_text ("<br/>")
				create ts.make ("op")
				ts.set_default_value ("Create user")
				a_form.extend (ts)
				a_form.extend_html_text ("<hr>")
			end
		end

	change_user (a_form_data: WSF_FORM_DATA; a_user: CMS_USER)
			-- Update node `a_node' with form_data `a_form_data' for the given content type `a_content_type'.
		local
			l_uroles: LIST [CMS_USER_ROLE]
		do
			if attached a_form_data.string_item ("op") as f_op then
				if f_op.is_case_insensitive_equal_general ("Update user role") then
					if attached a_form_data.string_item ("user-id") as l_user_id and then
					   attached {CMS_USER} api.user_api.user_by_id (l_user_id.to_integer) as l_user
					then
						l_uroles := api.user_api.user_roles (l_user)
						l_uroles.compare_objects
						if attached {WSF_STRING} a_form_data.item ("cms_roles") as l_role then
							if attached api.user_api.user_role_by_id (l_role.integer_value) as role then
								if not l_uroles.has (role) then
									api.user_api.assign_role_to_user (role, a_user)
								end
							end
						elseif attached {WSF_MULTIPLE_STRING} a_form_data.item ("cms_roles") as l_roles then
							across l_roles as ic loop
								if attached api.user_api.user_role_by_id (ic.item.integer_value) as role then
									if not l_uroles.has (role) then
										api.user_api.assign_role_to_user (role, a_user)
									end
								end
							end
						else
							across api.user_api.roles as ic  loop
								api.user_api.unassign_role_from_user (ic.item, a_user)
							end
						end
						add_success_message ("Roles updated")
					else
						a_form_data.report_error ("Missing User")
					end
				elseif f_op.is_case_insensitive_equal_general ("Update user") then
					if
						attached a_form_data.string_item ("user-id") as l_user_id and then
						attached {CMS_USER} api.user_api.user_by_id (l_user_id.to_integer) as l_user
					then
						if
							attached a_form_data.string_item ("email") as l_email
						then
							if
								attached l_user.email as u_email and then
								not u_email.is_case_insensitive_equal_general (l_email) and then
								api.user_api.user_by_email (l_email) = Void
							then
									-- Valid email
								a_user.set_email (l_email)
							else
								if attached l_user.email as u_email and then not u_email.is_case_insensitive_equal_general (l_email) then
									a_form_data.report_invalid_field ("email", "Email already exist!")
								end
							end
							if not a_form_data.has_error then
								api.user_api.update_user (a_user)
								add_success_message ("Updated basic info")
							end
						end
					end
				end
			end
		end

	create_user (a_form_data: WSF_FORM_DATA)
		local
			u: CMS_USER
		do
			if attached a_form_data.string_item ("op") as f_op then
				if f_op.is_case_insensitive_equal_general ("Create user") then
					if
						attached a_form_data.string_item ("username") as l_username and then
						attached a_form_data.string_item ("email") as l_email and then
						l_email.is_valid_as_string_8
					then
						create u.make (l_username)
						u.set_email (l_email.as_string_8)
						u.set_password (new_random_password (u))
						api.user_api.new_user (u)
						if api.user_api.has_error then
							-- handle error
						else
							add_success_message ("Created user")
						end

					else
						a_form_data.report_invalid_field ("username", "Missing username!")
						a_form_data.report_invalid_field ("email", "Missing email address!")
					end
				end
			end
		end


feature -- Generation

	custom_prepare (page: CMS_HTML_PAGE)
		do
			if attached variables as l_variables then
				across l_variables as c loop page.register_variable (c.item, c.key) end
			end
		end

	handle_admin_hack (a_api: CMS_API; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			s: STRING
			r: CMS_RESPONSE
			f: CMS_FORM
			t: WSF_FORM_TEXT_INPUT
			fe: WSF_FORM_EMAIL_INPUT
			fs: WSF_FORM_FIELD_SET
			f_submit: WSF_FORM_SUBMIT_INPUT
		do
			create {GENERIC_VIEW_CMS_RESPONSE} r.make (req, res, a_api)

			create f.make (req.percent_encoded_path_info, {CMS_ADMIN_MODULE}.name + "_hack_form")
			create fs.make
			fs.set_legend ("Create new user without password:")
			create t.make_with_text ("username", "")
			t.set_label ("User name")
			t.enable_required
			t.set_placeholder ("username")
			fs.extend (t)

			create fe.make_with_text ("email", "")
			fe.set_label ("Email")
			fe.set_placeholder ("valid email")
			fs.extend (fe)
			create f_submit.make_with_text ("op", "Create user")
			fs.extend (f_submit)
			create f_submit.make_with_text ("op", "Update user")
			fs.extend (f_submit)
			f.extend (fs)

			if req.is_post_request_method then
				create s.make_empty
				f.validation_actions.extend (agent (fd: WSF_FORM_DATA; ia_api: CMS_API)
						do
							if attached fd.string_item ("op") as f_op then
								if f_op.is_case_insensitive_equal_general ("Create user") then
									if attached fd.string_item ("username") as l_username then
										if attached ia_api.user_api.user_by_name (l_username) then
											fd.report_invalid_field ("username", "Username already taken!")
										end
									else
										fd.report_invalid_field ("username", "missing username")
									end
									if attached fd.string_item ("email") as l_email then
										if attached ia_api.user_api.user_by_email (l_email) then
											fd.report_invalid_field ("email", "Email address already associated with an existing account!")
										end
									else
										fd.report_invalid_field ("email", "missing email address")
									end
								elseif f_op.is_case_insensitive_equal_general ("Update user") then
									if attached fd.string_item ("username") as l_username then
										if ia_api.user_api.user_by_name (l_username) = Void then
											fd.report_invalid_field ("username", "Username does not exist!")
										end
									else
										fd.report_invalid_field ("username", "missing username")
									end
								end
							end
						end(?, a_api)
					)
				f.submit_actions.extend (agent (fd: WSF_FORM_DATA; ia_api: CMS_API; a_output: STRING)
						local
							u: CMS_USER
							l_roles: detachable LIST [CMS_USER_ROLE]
							l_trusted_user_role: detachable CMS_USER_ROLE
						do
							if attached fd.string_item ("op") as f_op then
								if f_op.is_case_insensitive_equal_general ("Create user") then
									if
										attached fd.string_item ("username") as l_username and then
										attached fd.string_item ("email") as l_email and then
										l_email.is_valid_as_string_8
									then
										create u.make (l_username)
										u.set_email (l_email.as_string_8)
										u.set_password (new_random_password (u))
										ia_api.user_api.new_user (u)
										if ia_api.user_api.has_error then

										end
										a_output.append ("<li>New user ["+ html_encoded (l_username) +"] created.</li>")
									else
										fd.report_invalid_field ("username", "Missing username!")
										fd.report_invalid_field ("email", "Missing email address!")
									end
								elseif f_op.is_case_insensitive_equal_general ("Update user") then
									if
										attached fd.string_item ("username") as l_username and then
										attached ia_api.user_api.user_by_name (l_username) as l_user
									then
										l_trusted_user_role := ia_api.user_api.user_role_by_name ("trusted")
										if l_trusted_user_role = Void then
											create l_trusted_user_role.make ("trusted")
											ia_api.user_api.save_user_role (l_trusted_user_role)
										end

										l_trusted_user_role.add_permission ("admin wdocs")
										l_trusted_user_role.add_permission ("edit wdocs page")
										l_trusted_user_role.add_permission ("create wdocs page")
										l_trusted_user_role.add_permission ("delete wdocs page")
										l_trusted_user_role.add_permission ("edit any wdocs page")
										l_trusted_user_role.add_permission ("delete any wdocs page")
										l_trusted_user_role.add_permission ("clear wdocs cache")

										l_trusted_user_role.add_permission ("create page")
										l_trusted_user_role.add_permission ("edit any page")
										l_trusted_user_role.add_permission ("delete any page")
										l_trusted_user_role.add_permission ("create blog")
										l_trusted_user_role.add_permission ("edit any blog")
										l_trusted_user_role.add_permission ("delete any blog")

										l_trusted_user_role.add_permission ("edit any node")
										l_trusted_user_role.add_permission ("delete any node")


										ia_api.user_api.save_user_role (l_trusted_user_role)
										l_trusted_user_role := ia_api.user_api.user_role_by_name ("trusted")
										if l_trusted_user_role /= Void then
											u := l_user
											ia_api.user_api.update_user (u)
											l_roles := u.roles
											if l_roles = Void then
												create {ARRAYED_LIST [CMS_USER_ROLE]} l_roles.make (1)
											end
											l_roles.force (l_trusted_user_role)
											u.set_roles (l_roles)

											ia_api.user_api.update_user (u)
											a_output.append ("<li>User ["+ html_encoded (l_username) +"] updated.</li>")
										else
											a_output.append ("<li>User ["+ html_encoded (l_username) +"] NOT updated! [ERROR].</li>")
										end
									else
										fd.report_invalid_field ("username", "User does not exist!")
									end
								end
							end
						end(?, a_api, s)
					)

				f.process (r)
				f.append_to_html (create {CMS_TO_WSF_THEME}.make (r, r.theme), s)
				r.set_main_content (s)
			elseif req.is_get_head_request_method then
				create s.make_empty
				f.append_to_html (create {CMS_TO_WSF_THEME}.make (r, r.theme), s)
				r.set_main_content (s)
			end
			r.execute
		end

	new_random_password (u: CMS_USER): STRING
			-- Generate a new token activation token
		local
			l_token: STRING
			l_security: SECURITY_PROVIDER
			l_encode: URL_ENCODER
		do
			create l_security
			l_token := l_security.token
			create l_encode
			from until l_token.same_string (l_encode.encoded_string (l_token)) loop
				-- Loop ensure that we have a security token that does not contain characters that need encoding.
			    -- We cannot simply to an encode-decode because the email sent to the user will contain an encoded token
				-- but the user will need to use an unencoded token if activation has to be done manually.
				l_token := l_security.token
			end
			Result := l_token + url_encoded (u.name) + u.creation_date.out
		end


end
