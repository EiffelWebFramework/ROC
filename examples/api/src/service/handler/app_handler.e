note
	description: "Summary description for {ESA_HANDLER}."
	date: "$Date: 2014-08-20 15:21:15 -0300 (mi., 20 ago. 2014) $"
	revision: "$Revision: 95678 $"

class
	APP_HANDLER

inherit

	SHARED_LOGGER

feature -- User

	current_user_name (req: WSF_REQUEST): detachable READABLE_STRING_32
			-- Current user name or Void in case of Guest users.
		note
			EIS: "src=eiffel:?class=AUTHENTICATION_FILTER&feature=execute"
		do
			if attached {CMS_USER} current_user (req) as l_user then
				Result := l_user.name
			end
		end

	current_user (req: WSF_REQUEST): detachable CMS_USER
			-- Current user or Void in case of Guest user.
		note
			EIS: "eiffel:?class=AUTHENTICATION_FILTER&feature=execute"
		do
			if attached {CMS_USER} req.execution_variable ("user") as l_user then
				Result := l_user
			end
		end

feature -- Media Type

	current_media_type (req: WSF_REQUEST): detachable READABLE_STRING_32
			-- Current media type or Void if it's not acceptable.
		do
			if attached {STRING} req.execution_variable ("media_type") as l_type then
				Result := l_type
			end
		end

feature -- Absolute Host

	absolute_host (req: WSF_REQUEST; a_path:STRING): STRING
		do
			Result := req.absolute_script_url (a_path)
			if Result.last_index_of ('/', Result.count) = Result.count then
				Result.remove_tail (1)
			end
			log.write_debug (generator + ".absolute_host " + Result )
		end

feature -- Compression

	current_compression (req: WSF_REQUEST): detachable READABLE_STRING_32
			-- Current compression encoding or Void if it's not acceptable.
		do
			if attached {STRING} req.execution_variable ("compression") as l_encoding then
				Result := l_encoding
			end
		end

feature {NONE} -- Implementations

		append_iterable_to (a_title: READABLE_STRING_8; it: detachable ITERABLE [WSF_VALUE]; s: STRING_8)
			local
				n: INTEGER
			do
				if it /= Void then
					across it as c loop
						n := n + 1
					end
					if n > 0 then
						s.append (a_title)
						s.append_character (':')
						s.append_character ('%N')
						across
							it as c
						loop
							s.append ("  - ")
							s.append (c.item.url_encoded_name)
							s.append_character (' ')
							s.append_character ('{')
							s.append (c.item.generating_type)
							s.append_character ('}')
							s.append_character ('=')
							s.append (c.item.debug_output.as_string_8)
							s.append_character ('%N')
						end
					end
				end
			end


end
