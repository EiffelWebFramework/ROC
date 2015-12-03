note
	description: "[
			Request handler related to 
				/taxonomy/term/{termid}
			]"
	date: "$Date$"
	revision: "$revision$"

class
	TAXONOMY_HANDLER

inherit
	CMS_MODULE_HANDLER [CMS_TAXONOMY_API]
		rename
			module_api as taxonomy_api
		end

	WSF_URI_HANDLER
		rename
			execute as uri_execute,
			new_mapping as new_uri_mapping
		end

	WSF_URI_TEMPLATE_HANDLER
		rename
			execute as uri_template_execute,
			new_mapping as new_uri_template_mapping
		select
			new_uri_template_mapping
		end

	WSF_RESOURCE_HANDLER_HELPER
		redefine
			do_get
		end

	REFACTORING_HELPER

	CMS_API_ACCESS

create
	make

feature -- execute

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler for any kind of mapping.
		do
			execute_methods (req, res)
		end

	uri_execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler for URI mapping.
		do
			execute (req, res)
		end

	uri_template_execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler for URI-template mapping.
		do
			execute (req, res)
		end

feature -- HTTP Methods	

	do_get (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			l_page: CMS_RESPONSE
			tid: INTEGER_64
			l_typename: detachable READABLE_STRING_8
			l_entity: detachable READABLE_STRING_32
			s: STRING
		do
			if
				attached {WSF_STRING} req.path_parameter ("termid") as p_termid and then
				p_termid.is_integer
			then
				tid := p_termid.value.to_integer_64
			end

			if tid > 0 then
				if attached taxonomy_api.term_by_id (tid) as t then
						-- Responding with `main_content_html (l_page)'.
					create {GENERIC_VIEW_CMS_RESPONSE} l_page.make (req, res, api)
					create s.make_empty
					l_page.set_page_title ("Entities associated with term %"" + l_page.html_encoded (t.text) + "%":")

					if
						attached taxonomy_api.entities_associated_with_term (t) as l_entity_type_lst and then
						not l_entity_type_lst.is_empty
					then
						s.append ("<ul class=%"taxonomy-entities%">")
						across
							l_entity_type_lst as ic
						loop
								-- FIXME: for now basic implementation .. to be replaced by specific hook !
							if attached ic.item.entity as e and then e.is_valid_as_string_8 then
								l_entity := e.to_string_8
								if attached ic.item.type as l_type and then l_type.is_valid_as_string_8 then
									l_typename := l_type.to_string_8
								else
									l_typename := Void
								end
								if l_typename /= Void then
									s.append ("<li class=%""+ l_typename +"%">")
									if
										l_typename.is_case_insensitive_equal_general ("page")
										or l_typename.is_case_insensitive_equal_general ("blog")
									then
										s.append (l_page.link ({STRING_32} "" + l_typename + "/" + l_entity, "node/" + l_entity.to_string_8, Void))
									end
									s.append ("</li>%N")
								end
							end
						end
						s.append ("</ul>%N")
					else
						s.append ("No entity found.")
					end
					l_page.set_main_content (s)
				else
						-- Responding with `main_content_html (l_page)'.
					create {NOT_FOUND_ERROR_CMS_RESPONSE} l_page.make (req, res, api)
				end
				l_page.execute
			else
					-- Responding with `main_content_html (l_page)'.
				create {BAD_REQUEST_ERROR_CMS_RESPONSE} l_page.make (req, res, api)
				l_page.execute
			end
		end

end
