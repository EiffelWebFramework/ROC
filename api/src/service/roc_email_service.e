note
	description: "Provides email access"
	date: "$Date: 2014-08-20 15:21:15 -0300 (mi., 20 ago. 2014) $"
	revision: "$Revision: 95678 $"

class
	ROC_EMAIL_SERVICE

inherit

	SHARED_ERROR

create
	make

feature {NONE} -- Initialization

	make (a_smtp_server: READABLE_STRING_32)
			-- Create an instance of {ESA_EMAIL_SERVICE} with an smtp_server `a_smtp_server'.
			-- Using "noreplies@eiffel.com" as admin email.
		local
			l_address_factory: INET_ADDRESS_FACTORY
		do
					-- Get local host name needed in creation of SMTP_PROTOCOL.
			create l_address_factory
			create smtp_protocol.make (a_smtp_server, l_address_factory.create_localhost.host_name)
			set_successful
		end

	admin_email: IMMUTABLE_STRING_8
			-- Administrator email.
		once
			Result := "noreplies@eiffel.com"
		end

	webmaster_email: IMMUTABLE_STRING_8
			-- Webmaster email.
		once
			Result := "webmaster@eiffel.com"
		end

	smtp_protocol: SMTP_PROTOCOL
			-- SMTP protocol.

feature -- Basic Operations

	send_template_email (a_to, a_token, a_host: STRING)
			-- Send successful registration message containing activation code `a_token' to `a_to'.
		require
			attached_to: a_to /= Void
			attached_token: a_token /= Void
			attached_host: a_host /= Void
		local
			l_content: STRING
			l_url: URL_ENCODER
 			l_path: PATH
			l_html: HTML_ENCODER
			l_email: EMAIL
		do
			if successful then
				log.write_information (generator + ".send_post_registration_email to [" + a_to + "]" )
				create l_path.make_current
				create l_url
				create l_html
				create l_content.make (1024)
				l_content.append ("Thank you for registering at CMS.%N%NTo complete your registration, please click on this link to activate your account:%N%N")
				l_content.append (a_host)
				l_content.append ("/activation?code=")
				l_content.append (l_url.encoded_string (a_token))
				l_content.append ("&email=")
				l_content.append (l_url.encoded_string (a_to))
				l_content.append ("%N%NOnce there, please enter the following information and then click the Activate Account, button.%N%N")
				l_content.append ("Your e-mail: ")
				l_content.append (l_html.encoded_string (a_to))
				l_content.append ("%N%NYour activation code: ")
				l_content.append (l_html.encoded_string(a_token))
				l_content.append ("%N%NThank you for joining us.%N%N CMS team.")
				l_content.append (Disclaimer)
					-- Create our message.
				create l_email.make_with_entry (admin_email, a_to)
				l_email.set_message (l_content)
				l_email.add_header_entry ({EMAIL_CONSTANTS}.H_subject, "CMS Site: Account Activation")
				send_email (l_email)
			end
		end

	send_shutdown_email (a_message: READABLE_STRING_GENERAL)
			-- Send email shutdown cause by an unexpected condition.
		local
			l_email: EMAIL
			l_content: STRING
		do
			create l_email.make_with_entry (admin_email, webmaster_email)
			create l_content.make (2048)
			l_content.append (a_message.as_string_32)
			l_email.set_message (l_content)
			l_email.add_header_entry ({EMAIL_CONSTANTS}.H_subject, "ROC API exception")
			send_email (l_email)
		end

feature {NONE} -- Implementation

	send_email (a_email: EMAIL)
			-- Send the email represented by `a_email'.
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				log.write_information (generator + ".send_email Process send email.")
				smtp_protocol.initiate_protocol
				smtp_protocol.transfer (a_email)
				smtp_protocol.close_protocol
				log.write_information (generator + ".send_email Email sent.")
				set_successful
			else
				log.write_error (generator + ".send_email Email not send" + last_error_message )
			end
		rescue
			set_last_error_from_exception (generator + ".send_email")
			l_retried := True
			retry
		end

	Disclaimer: STRING = "This email is generated automatically, and the address is not monitored for responses. If you try contacting us by using %"reply%", you will not receive an answer."
		-- Email not monitored disclaimer.

end
