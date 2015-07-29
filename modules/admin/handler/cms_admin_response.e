note
	description: "Summary description for {CMS_ADMIN_RESPONSE}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_ADMIN_RESPONSE

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

feature -- Process

	process
		local
			b: STRING
		do
			create b.make_empty
			set_title (translation ("Admin Page", Void))
			b.append ("<ul id=%"content-types%">")
			fixme ("Check how to make it configurable")
			if has_permissions (<< "View any">>) then
				b.append ("<li>" + link ("Users", "admin/users", Void))
				b.append ("<div class=%"description%">View/Edit/Add Users</div>")
				b.append ("</li>")
				b.append ("<li>" + link ("Roles", "admin/roles", Void))
				b.append ("<div class=%"description%">View/Edit/Add Roles</div>")
				b.append ("</li>")
			end
			b.append ("</ul>")
			set_main_content (b)
		end

feature -- Generation

	custom_prepare (page: CMS_HTML_PAGE)
		do
			if attached variables as l_variables then
				across l_variables as c loop page.register_variable (c.item, c.key) end
			end
		end

feature -- Admin: Add User Form

	handle_admin_user_form
		local
			s: STRING
			f: CMS_FORM
			t: WSF_FORM_TEXT_INPUT
			fe: WSF_FORM_EMAIL_INPUT
			fs: WSF_FORM_FIELD_SET
			f_submit: WSF_FORM_SUBMIT_INPUT
		do

			create f.make (request.percent_encoded_path_info, {CMS_ADMIN_MODULE}.name )
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

			if request.is_post_request_method then
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
						end(?, api)
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
						end(?, api, s)
					)

				f.process (Current)
				f.append_to_html (create {CMS_TO_WSF_THEME}.make (Current, Current.theme), s)
				Current.set_main_content (s)
			elseif request.is_get_head_request_method then
				create s.make_empty
				f.append_to_html (create {CMS_TO_WSF_THEME}.make (Current, Current.theme), s)
				Current.set_main_content (s)
			end
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
