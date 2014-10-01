note
	description: "Error filter"
	date: "$Date: 2014-08-08 16:02:11 -0300 (vi., 08 ago. 2014) $"
	revision: "$Revision: 95593 $"

class
	ERROR_FILTER

inherit
	WSF_URI_TEMPLATE_HANDLER

	APP_ABSTRACT_HANDLER
		rename
			set_esa_config as make
		end
	WSF_FILTER



create
	make

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the filter

		do
			if roc_config.is_successful and then roc_config.api_service.successful then
				log.write_information (generator + ".execute")
				execute_next (req, res)
			else
				-- send internal server error.
			end
		end


note
	copyright: "2011-2012, Olivier Ligot, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
