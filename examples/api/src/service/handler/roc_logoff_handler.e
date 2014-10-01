note
	description: "Handle Logoff for Basic Authentication"
	date: "$Date: 2014-08-08 16:02:11 -0300 (vi., 08 ago. 2014) $"
	revision: "$Revision: 95593 $"

class
	ROC_LOGOFF_HANDLER

inherit

	APP_ABSTRACT_HANDLER
		rename
			set_esa_config as make
		end

	WSF_URI_HANDLER
		rename
			execute as uri_execute,
			new_mapping as new_uri_mapping
		end

	WSF_RESOURCE_HANDLER_HELPER
		redefine
			do_get
		end

	REFACTORING_HELPER

create
	make

feature -- execute

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler.
		do
			execute_methods (req, res)
		end

	uri_execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler.
		do
			execute_methods (req, res)
		end

feature -- HTTP Methods

	do_get (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		do
				log.write_information(generator + ".do_get Processing logoff")
			if attached req.query_parameter ("prompt") as l_prompt then
				(create {ROC_RESPONSE}.make(req,"")).new_response_unauthorized (req, res)
			else
				(create {ROC_RESPONSE}.make(req,"master2/logoff.tpl")).new_response_denied (req, res)
			end
		end

end
