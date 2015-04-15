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

	send_access_denied_message (res: WSF_RESPONSE)
			-- Send via `res' an access denied response.
		do
			res.send (create {CMS_FORBIDDEN_RESPONSE_MESSAGE}.make)
		end

	send_access_denied (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Forbidden response.
		local
			r: CMS_RESPONSE
		do
			create {FORBIDDEN_ERROR_CMS_RESPONSE} r.make (req, res, api)
			r.execute
		end

	send_not_found (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Send via `res' a not found response.
		local
			r: CMS_RESPONSE
		do
			create {NOT_FOUND_ERROR_CMS_RESPONSE} r.make (req, res, api)
			r.execute
		end

	send_bad_request (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Send via `res' a bad request response.
		local
			r: CMS_RESPONSE
		do
			create {BAD_REQUEST_ERROR_CMS_RESPONSE} r.make (req, res, api)
			r.execute
		end

end
