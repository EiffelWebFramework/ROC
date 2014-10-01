note
	description: "Summary description for {CMS_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_HANDLER

inherit

	CMS_REQUEST_UTIL

	SHARED_LOGGER

	REFACTORING_HELPER

feature {NONE} -- Initialization

	make (a_setup: CMS_SETUP)
		do
			setup := a_setup
		end

feature -- Setup

	setup:  CMS_SETUP

feature -- API Service

	api_service: CMS_API_SERVICE
		do
			Result := setup.api_service
		end

end
