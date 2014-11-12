note
	description: "Describe how to alter a form before it's rendered"
	date: "$Date: 2014-08-28 08:21:49 -0300 (ju. 28 de ago. de 2014) $"

deferred class
	CMS_HOOK_FORM_ALTER

inherit
	CMS_HOOK

feature -- Hook

	form_alter (a_form: CMS_FORM; a_form_data: detachable WSF_FORM_DATA; a_response: CMS_RESPONSE)
		deferred
		end

end
