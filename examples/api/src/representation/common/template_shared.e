note
	description: "Template shared common features to all the templates"
	date: "$Date: 2014-08-08 16:02:11 -0300 (vi., 08 ago. 2014) $"
	revision: "$Revision: 95593 $"

deferred class
	TEMPLATE_SHARED

inherit

    ROC_TEMPLATE_PAGE

feature --

	add_host (a_host: READABLE_STRING_GENERAL)
			-- Add value `a_host' to `host'
		do
			template.add_value (a_host, "host")
		end


	add_user (a_user: detachable ANY)
			-- Add value `a_host' to `host'
		do
			if attached a_user then
				template.add_value (a_user,"user")
			end
		end
end
