note
	description: "Authentication filter."
	author: "Olivier Ligot"
	date: "$Date: 2014-08-20 15:21:15 -0300 (mi., 20 ago. 2014) $"
	revision: "$Revision: 95678 $"

class
	AUTHENTICATION_FILTER

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
		local
			l_auth: HTTP_AUTHORIZATION
		do
			log.write_debug (generator + ".execute " )
			create l_auth.make (req.http_authorization)
			if attached req.raw_header_data as l_raw_data then
			   log.write_debug (generator + ".execute " + l_raw_data )
			end
				-- A valid user
			if (attached l_auth.type as l_auth_type and then l_auth_type.is_case_insensitive_equal ("basic")) and then
				attached l_auth.login as l_auth_login and then attached l_auth.password as l_auth_password then
				if api_service.login_valid (l_auth_login, l_auth_password) then
					if attached api_service.user_by_name (l_auth_login) as l_user then
						req.set_execution_variable ("user", l_user)
						execute_next (req, res)
					else
						-- Internal server error	
					end
				else
					log.write_error (generator + ".execute login_valid failed for: " + l_auth_login )
					execute_next (req, res)
				end
			else
				log.write_error (generator + ".execute Not valid")
				execute_next (req, res)
			end
		end

note
	copyright: "2011-2012, Olivier Ligot, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"

end
