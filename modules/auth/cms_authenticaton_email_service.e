note
	description: "Summary description for {CMS_AUTHENTICATON_EMAIL_SERVICE}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_AUTHENTICATON_EMAIL_SERVICE

inherit
	EMAIL_SERVICE
		redefine
			initialize,
			parameters
		end

create
	make

feature {NONE} -- Initialization	

	initialize
		do
			Precursor
			contact_email := parameters.contact_email
		end

	parameters: CMS_AUTHENTICATION_EMAIL_SERVICE_PARAMETERS
			-- Associated parameters.		

feature -- Access		

	contact_email: IMMUTABLE_STRING_8
			-- contact email.

feature -- Basic Operations

	send_account_evaluation (a_user: CMS_USER; a_application, a_url_activate, a_url_reject: READABLE_STRING_8)
			-- Send new user register to webmaster to confirm or reject itt.
		local
			l_message: STRING
		do
			create l_message.make_from_string (parameters.account_evaluation)
			l_message.replace_substring_all ("$user", a_user.name)
			if attached a_user.email as l_email then
				l_message.replace_substring_all ("$email", l_email)
			else
				l_message.replace_substring_all ("$email", "unknown email")
			end
			l_message.replace_substring_all ("$application", a_application)
			l_message.replace_substring_all ("$activate", a_url_activate)
			l_message.replace_substring_all ("$reject", a_url_reject)
			send_message (contact_email, contact_email, parameters.contact_subject_account_evaluation, l_message)
		end


	send_contact_email (a_to, a_user: READABLE_STRING_8)
			-- Send successful contact message to `a_to'.
		require
			attached_to: a_to /= Void
		local
			l_message: STRING
		do
			create l_message.make_from_string (parameters.account_activation)
			l_message.replace_substring_all ("$user", a_user)
			send_message (contact_email, a_to, parameters.contact_subject_register, l_message)
		end


	send_contact_activation_email (a_to, a_content: READABLE_STRING_8)
			-- Send successful contact message `a_token' to `a_to'.
		require
			attached_to: a_to /= Void
		local
			l_message: STRING
		do
			create l_message.make_from_string (parameters.account_re_activation)
			l_message.replace_substring_all ("$link", a_content)
			send_message (contact_email, a_to, parameters.contact_subject_activate, l_message)
		end


	send_contact_activation_confirmation_email (a_to, a_content: READABLE_STRING_8)
			-- Send successful contact activation to a_to.
		require
			attached_to: a_to /= Void
		local
			l_message: STRING
		do
			create l_message.make_from_string (parameters.account_activation_confirmation)
			l_message.replace_substring_all ("$email", a_content)
			send_message (contact_email, a_to, parameters.contact_subject_activated, l_message)
		end


	send_contact_activation_reject_email (a_to, a_content: READABLE_STRING_8)
			-- Send successful contact activation reject to `a_to'.
		require
			attached_to: a_to /= Void
		local
			l_message: STRING
		do
			create l_message.make_from_string (parameters.account_rejected)
			l_message.replace_substring_all ("$link", a_content)
			send_message (contact_email, a_to, parameters.contact_subject_activate, l_message)
		end



	send_contact_password_email (a_to, a_content: READABLE_STRING_8)
			-- Send successful contact message `a_token' to `a_to'.
		require
			attached_to: a_to /= Void
		local
			l_message: STRING
		do
			create l_message.make_from_string (parameters.account_password)
			l_message.replace_substring_all ("$link", a_content)
			send_message (contact_email, a_to, parameters.contact_subject_password, l_message)
		end

	send_contact_welcome_email (a_to, a_content: READABLE_STRING_8)
			-- Send successful contact message `a_token' to `a_to'.
		require
			attached_to: a_to /= Void
		local
			l_message: STRING
		do
			create l_message.make_from_string (parameters.account_welcome)
			l_message.replace_substring_all ("$link", a_content)
			send_message (contact_email, a_to, parameters.contact_subject_oauth, l_message)
		end


end
