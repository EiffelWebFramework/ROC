note
	description: "[
			Common interface for request handler specific to the CMS component.
		]"
	date: "$Date: 2015-02-13 13:08:13 +0100 (ven., 13 févr. 2015) $"
	revision: "$Revision: 96616 $"

deferred class
	CMS_HANDLER

inherit
	WSF_HANDLER

	CMS_REQUEST_UTIL

	REFACTORING_HELPER

feature {NONE} -- Initialization

	make (a_api: CMS_API)
			-- Initialize Current handler with `a_api'.
		do
			api := a_api
		end

feature -- API Service

	api: CMS_API

feature -- Response helpers

	redirect_to (a_location: READABLE_STRING_8; res: WSF_RESPONSE)
			-- Send via `res' a redirection message for location `a_location'.			
		do
			res.redirect_now (a_location)
--			res.send (create {CMS_REDIRECTION_RESPONSE_MESSAGE}.make (a_location))
		end

	send_access_denied (res: WSF_RESPONSE)
			-- Send via `res' an access denied response.
		do
			res.send (create {CMS_FORBIDDEN_RESPONSE_MESSAGE}.make)
		end

end
