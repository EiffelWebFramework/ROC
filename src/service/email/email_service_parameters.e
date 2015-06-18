note
	description: "Basic Email Service customized for cms site"
	author: ""
	date: "$Date: 2015-01-16 07:17:14 -0300 (vi. 16 de ene. de 2015) $"
	revision: "$Revision: 96467 $"

deferred class
	EMAIL_SERVICE_PARAMETERS

feature	-- Access

	smtp_server: IMMUTABLE_STRING_8
		deferred
		end

	admin_email: IMMUTABLE_STRING_8
		deferred
		end

end
