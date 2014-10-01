note
	description: "Abstrat Eiffel Support API Handler."
	date: "$Date: 2014-08-08 16:02:11 -0300 (vi., 08 ago. 2014) $"
	revision: "$Revision: 95593 $"

deferred class
	APP_ABSTRACT_HANDLER

inherit
	WSF_HANDLER

	APP_HANDLER

	SHARED_CONNEG_HELPER

feature -- Change

	set_esa_config (a_esa_config: like roc_config)
			-- Set `roc_config' to `a_esa_condig'.
		do
			roc_config := a_esa_config
		ensure
			esa_config_set: roc_config = a_esa_config
		end

feature -- Access

	roc_config: ROC_CONFIG
		-- Configuration.

	api_service: ROC_API_SERVICE
			-- api Service.
		do
			Result := roc_config.api_service
		end

	email_service: ROC_EMAIL_SERVICE
			-- Email Service.
		do
			Result := roc_config.email_service
		end

	is_web: BOOLEAN
		do
			Result := roc_config.is_web
		end

end
