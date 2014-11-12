note
	description: "Summary description for {CMS_FORM}."
	date: "$Date: 2014-08-28 08:21:49 -0300 (ju. 28 de ago. de 2014) $"
	revision: "$Revision: 95708 $"

class
	CMS_FORM

inherit
	WSF_FORM
		rename
			process as process_form
		end

create
	make

feature -- Basic operation

	prepare (a_response: CMS_RESPONSE)
		do
			a_response.invoke_form_alter (Current, Void)
		end

	process (a_response: CMS_RESPONSE)
		do
			process_form (a_response.request, agent on_prepared (a_response, ?), agent on_processed (a_response, ?))
		end

	on_prepared (a_response: CMS_RESPONSE; fd: WSF_FORM_DATA)
		do
			a_response.invoke_form_alter (Current, fd)
		end

	on_processed (a_response: CMS_RESPONSE; fd: WSF_FORM_DATA)
		do
			if not fd.is_valid or fd.has_error then
				a_response.report_form_errors (fd)
			end
		end

end
