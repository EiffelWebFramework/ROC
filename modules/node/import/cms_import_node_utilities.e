note
	description: "[
				Routines usefull during node exportation (see {CMS_HOOK_IMPORT}).
			]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_IMPORT_NODE_UTILITIES

inherit
	CMS_IMPORT_JSON_UTILITIES

	CMS_API_ACCESS

feature -- Access

	user_by_name (a_name: READABLE_STRING_GENERAL; a_node_api: CMS_NODE_API): detachable CMS_USER
			-- CMS user named `a_name`.
		do
			Result := a_node_api.cms_api.user_api.user_by_name (a_name)
		end

feature -- Conversion

	json_to_node (a_node_type: CMS_NODE_TYPE [CMS_NODE]; j: JSON_OBJECT; a_node_api: CMS_NODE_API): detachable CMS_NODE
		local
			l_node: CMS_PARTIAL_NODE
		do
			if
				attached json_string_item (j, "title") as l_title
			then
				create l_node.make_empty (a_node_type.name)
				l_node.set_title (l_title)
				Result := l_node
				if attached json_date_item (j, "creation_date") as dt then
					l_node.set_creation_date (dt)
				end
				if attached json_date_item (j, "modification_date") as dt then
					l_node.set_modification_date (dt)
				end
				if attached json_date_item (j, "publication_date") as dt then
					l_node.set_publication_date (dt)
				end
				if attached json_integer_item (j, "status") as l_status then
					inspect l_status
					when {CMS_NODE_API}.published then
						l_node.mark_published
					when {CMS_NODE_API}.not_published then
						l_node.mark_not_published
					when {CMS_NODE_API}.trashed then
						l_node.mark_trashed
					else
					end
				end
				if attached {JSON_OBJECT} j.item ("author") as j_author then
					l_node.set_author (json_to_user (j_author, a_node_api))
				end
				if attached {JSON_OBJECT} j.item ("data") as j_data then
					l_node.set_all_content (json_string_item (j_data, "content"), json_string_item (j_data, "summary"), json_string_8_item (j_data, "format"))
				end
				if
					attached {JSON_OBJECT} j.item ("link") as j_link and then
					attached json_to_local_link (j_link) as lnk
				then
					l_node.set_link (lnk)
				end
				if attached {JSON_ARRAY} j.item ("tags") as j_tags and then j_tags.count > 0 then
					if attached {CMS_TAXONOMY_API} a_node_api.cms_api.module_api ({CMS_TAXONOMY_MODULE}) as l_taxonomy_api then
						across
							j_tags as ic
						loop
							if
								attached {JSON_OBJECT} ic.item as j_tag and then
								attached json_string_item (j_tag, "text") as l_tag_text
							then
								if attached l_taxonomy_api.term_by_text (l_tag_text, Void) as t then
									l_taxonomy_api.associate_term_with_content (t, l_node)
								end
							end
						end
					end
				end
			end
		end

	json_to_user (j_user: JSON_OBJECT; a_node_api: CMS_NODE_API): detachable CMS_USER
		do
			if
				attached json_string_item (j_user, "name") as l_author_name
			then
				Result := user_by_name (l_author_name, a_node_api)
			end
		end

	json_to_local_link (j_link: JSON_OBJECT): detachable CMS_LOCAL_LINK
		do
			if
				attached json_string_8_item (j_link, "location") as loc
			then
				create Result.make (json_string_item (j_link, "title"), loc)
				Result.set_weight (json_integer_item (j_link, "weight").to_integer_32)
			end
		end

end
