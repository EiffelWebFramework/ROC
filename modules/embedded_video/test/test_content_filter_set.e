note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_CONTENT_FILTER_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	test_video_filter_01
			-- New test routine
		local
			f: VIDEO_CONTENT_FILTER
			text: STRING
			expected_text: STRING
		do
			text := "[video:https://www.youtube.com/embed/jBMOSSnCMCk]"
			expected_text := "<iframe src=%"https://www.youtube.com/embed/jBMOSSnCMCk%" width=%"420%" height=%"315%"></iframe>"
			create f
			f.filter (text)
			assert ("expected iframe with video", text.same_string (expected_text))
		end

	test_video_filter_01_multi
			-- New test routine
		local
			f: VIDEO_CONTENT_FILTER
			text: STRING
			expected_text: STRING
		do
			text := "[
					[video:https://www.youtube.com/embed/jBMOSSnCMCk]
					and [video:https://www.youtube.com/embed/jBMOSSnCMCk]
					and [video:https://www.youtube.com/embed/jBMOSSnCMCk]
					done
				]"
			expected_text := "[
					<iframe src="https://www.youtube.com/embed/jBMOSSnCMCk" width="420" height="315"></iframe>
					and <iframe src="https://www.youtube.com/embed/jBMOSSnCMCk" width="420" height="315"></iframe>
					and <iframe src="https://www.youtube.com/embed/jBMOSSnCMCk" width="420" height="315"></iframe>
					done
				]"
			create f
			f.filter (text)
			assert ("expected iframe with video", text.same_string (expected_text))
		end


	test_video_filter_02
			-- New test routine
		local
			f: VIDEO_CONTENT_FILTER
			text: STRING
			expected_text: STRING
		do
			text := "[video:  https://www.youtube.com/embed/jBMOSSnCMCk   ]"
			expected_text := "<iframe src=%"https://www.youtube.com/embed/jBMOSSnCMCk%" width=%"420%" height=%"315%"></iframe>"
			create f
			f.filter (text)
			assert ("expected iframe with video", text.same_string (expected_text))
		end


	test_video_filter_03
			-- New test routine
		local
			f: VIDEO_CONTENT_FILTER
			text: STRING
			expected_text: STRING
		do
			text := "[video:https://www.youtube.com/embed/jBMOSSnCMCk   ]"
			expected_text := "<iframe src=%"https://www.youtube.com/embed/jBMOSSnCMCk%" width=%"420%" height=%"315%"></iframe>"
			create f
			f.filter (text)
			assert ("expected iframe with video", text.same_string (expected_text))
		end


	test_video_filter_04
			-- New test routine
		local
			f: VIDEO_CONTENT_FILTER
			text: STRING
			expected_text: STRING
		do
			text := "[video:https://www.youtube.com/embed/jBMOSSnCMCk   height:425]"
			expected_text := "<iframe src=%"https://www.youtube.com/embed/jBMOSSnCMCk%" width=%"420%" height=%"425%"></iframe>"
			create f
			f.filter (text)
			assert ("expected iframe with video", text.same_string (expected_text))
		end


	test_video_filter_05
			-- New test routine
		local
			f: VIDEO_CONTENT_FILTER
			text: STRING
			expected_text: STRING
		do
			text := "[video:https://www.youtube.com/embed/jBMOSSnCMCk   height :  425]"
			expected_text := "<iframe src=%"https://www.youtube.com/embed/jBMOSSnCMCk%" width=%"420%" height=%"425%"></iframe>"
			create f
			f.filter (text)
			assert ("expected iframe with video", text.same_string (expected_text))
		end


	test_video_filter_06
			-- New test routine
		local
			f: VIDEO_CONTENT_FILTER
			text: STRING
			expected_text: STRING
		do
			text := "[video:https://www.youtube.com/embed/jBMOSSnCMCk   height :  425 width:   425]"
			expected_text := "<iframe src=%"https://www.youtube.com/embed/jBMOSSnCMCk%" width=%"425%" height=%"425%"></iframe>"
			create f
			f.filter (text)
			assert ("expected iframe with video", text.same_string (expected_text))
		end

	test_video_filter_07
			-- New test routine
		local
			f: VIDEO_CONTENT_FILTER
			text: STRING
			expected_text: STRING
		do
			text := "[video:https://www.youtube.com/embed/jBMOSSnCMCk height:425 width:425]"
			expected_text := "<iframe src=%"https://www.youtube.com/embed/jBMOSSnCMCk%" width=%"425%" height=%"425%"></iframe>"
			create f
			f.filter (text)
			assert ("expected iframe with video", text.same_string (expected_text))
		end

	test_video_filter_08
			-- New test routine
		local
			f: VIDEO_CONTENT_FILTER
			text: STRING
			expected_text: STRING
		do
			text := "[ wrong:425  video:https://www.youtube.com/embed/jBMOSSnCMCk  height:425]"
			expected_text := "[ wrong:425  video:https://www.youtube.com/embed/jBMOSSnCMCk  height:425]"
			create f
			f.filter (text)
			assert ("expected iframe with video", text.same_string (expected_text))
		end

	test_video_filter_09
			-- New test routine
		local
			f: VIDEO_CONTENT_FILTER
			text: STRING
			expected_text: STRING
		do
			text := "[video:https://www.youtube.com/embed/jBMOSSnCMCk  height:425 foo:bar foo=bar foobar frameborder=%"0%" allowfullscreen]"
			expected_text := "<iframe src=%"https://www.youtube.com/embed/jBMOSSnCMCk%" width=%"420%" height=%"425%" foo=bar foobar frameborder=%"0%" allowfullscreen></iframe>"
			create f
			f.filter (text)
			assert ("expected iframe with video", text.same_string (expected_text))
		end

	test_video_filter_10
			-- New test routine
		local
			f: VIDEO_CONTENT_FILTER
			text: STRING
			expected_text: STRING
		do
			text := "[wrong hello:1020 ]"
			expected_text := "[wrong hello:1020 ]"
			create f
			f.filter (text)
			assert ("expected iframe with video", text.same_string (expected_text))
		end

	test_video_filter_tpl_01
			-- New test routine
		local
			f: VIDEO_CONTENT_FILTER
			text: STRING
			expected_text: STRING
		do
			text := "[video:https://www.youtube.com/embed/jBMOSSnCMCk  height:425 foo:bar foo=bar foobar]"
			create f
			f.set_template ("<iframe src=%"$url%" $att allowfullscreen></iframe>")
			f.set_default_width (500)
			f.set_default_height (400)

			expected_text := "<iframe src=%"https://www.youtube.com/embed/jBMOSSnCMCk%" width=%"500%" height=%"425%" foo=bar foobar allowfullscreen></iframe>"

			f.filter (text)
			assert ("expected iframe with video", text.same_string (expected_text))
		end

end


