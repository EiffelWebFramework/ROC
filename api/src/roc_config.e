note
	description: "Eiffel Suppor API configuration"
	date: "$Date: 2014-08-20 15:21:15 -0300 (mi., 20 ago. 2014) $"
	revision: "$Revision: 95678 $"

class
	ROC_CONFIG

inherit

	SHARED_ERROR


create
	make

feature -- Initialization

	make (a_database: DATABASE_CONNECTION; a_api_service: ROC_API_SERVICE; a_email_service: ROC_EMAIL_SERVICE; a_layout: APPLICATION_LAYOUT )
			-- Create an object with defaults.
		do
			database := a_database
			api_service := a_api_service
			email_service := a_email_service
			layout := a_layout
			mark_api
		ensure
			database_set: database = a_database
			api_service_set: api_service = a_api_service
			email_service_set: email_service = a_email_service
			layout_set: layout = a_layout
		end

feature -- Access

	is_successful: BOOLEAN
			-- Is the configuration successful?
		do
			Result := successful
		end

	is_api: BOOLEAN
		-- Is the server running on server mode API

	is_web: BOOLEAN
		-- Is the server running on server mode API

	is_html: BOOLEAN
		-- Is the server running on html mode API	

	database: DATABASE_CONNECTION
			-- Database connection.

	api_service: ROC_API_SERVICE
			-- Support API.

	email_service: ROC_EMAIL_SERVICE
			-- Email service.

	layout: APPLICATION_LAYOUT
			-- Api layout.		

	mark_api
			-- Set server mode to api.
		do
			is_api := True
			is_html := False
			is_web := False
		end

	mark_web
			-- Set server mode to web.
		do
			is_web := True
			is_api := False
			is_html := False
		end

	mark_html
			-- Set server mode to web.
		do
			is_html := True
			is_api := False
			is_web := False
		end

end
