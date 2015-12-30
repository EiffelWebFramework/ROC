note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date: 2015-01-14 15:37:57 -0300 (mi. 14 de ene. de 2015) $"
	revision: "$Revision: 96458 $"
	testing: "type/manual"

class
	RECAPTCHA_API_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	test_invalid_input
			-- invalid-input-response
		local
			l_captcha: RECAPTCHA_API
		do
			create l_captcha.make ("","234")
			check
				not_true:not l_captcha.verify
			end
			assert ("Not true", not l_captcha.verify)
			assert ("Has error invalid-input-response",has_error (l_captcha,"invalid-input-response"))
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
			assert ("Not true", not l_captcha.verify)
			assert ("Has error missing-input-response",has_error (l_captcha,"missing-input-response"))
		end

	test_missing_key_input
			-- missing-input-response
			-- invalid-input-response
		local
			l_captcha: RECAPTCHA_API
		do
			create l_captcha.make ("","")
			l_captcha.set_remoteip("localhost")
			assert ("Not true", not l_captcha.verify)
			assert ("Has error missing-input-response",has_error (l_captcha,"missing-input-response"))
			assert ("Has error invalid-input-response",has_error (l_captcha,"invalid-input-response"))
		end

feature {NONE} -- Implementation

	has_error (l_captcha: RECAPTCHA_API; a_error: READABLE_STRING_32): BOOLEAN
		do
			if attached l_captcha.errors as l_errors then
				l_errors.compare_objects
				Result := l_errors.has (a_error)
			end
		end

end


