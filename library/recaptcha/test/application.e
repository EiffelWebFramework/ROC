note
	description : "test application root class"
	date        : "$Date: 2015-01-14 15:37:57 -0300 (mi. 14 de ene. de 2015) $"
	revision    : "$Revision: 96458 $"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			test_invalid_input
			test_missing_input
			test_missing_key_input
		end


	test_invalid_input
			-- invalid-input-response
		local
			l_captcha: RECAPTCHA_API
		do
			create l_captcha.make ("","234")
			check
				not_true:not l_captcha.verify
			end
		end

	test_missing_input
			-- missing-input-response
		local
			l_captcha: RECAPTCHA_API
		do
			create l_captcha.make ("key","")
			check
				not_true:not l_captcha.verify
			end
		end

	test_missing_key_input
			-- missing-input-response
			-- invalid-input-response
		local
			l_captcha: RECAPTCHA_API
		do
			create l_captcha.make ("","")
			l_captcha.set_remoteip("localhost")
			check
				not_true:not l_captcha.verify
			end
		end

end
