note
	description: "Summary description for {CMS_BLOG_CONTENT_TYPE_WEBFORM_MANAGER}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_BLOG_CONTENT_TYPE_WEBFORM_MANAGER

inherit
	CMS_NODE_CONTENT_TYPE_WEBFORM_MANAGER [CMS_BLOG]
		redefine
			content_type,
			fill_edit_form,
			change_node,
			new_node
		end

create
	make

feature -- Access

	content_type: CMS_BLOG_CONTENT_TYPE
			-- Associated content type.	

feature -- form			

	fill_edit_form (response: NODE_RESPONSE; f: CMS_FORM; a_node: detachable like new_node)
		local
			ti: WSF_FORM_TEXT_INPUT
			fset: WSF_FORM_FIELD_SET
			ta: WSF_FORM_TEXTAREA
			tselect: WSF_FORM_SELECT
			opt: WSF_FORM_SELECT_OPTION
			s: STRING_32
		do
			Precursor (response, f, a_node)
			create ti.make ("tags")
			ti.set_label ("Tags")
			ti.set_size (70)
			if a_node /= Void and then attached a_node.tags as l_tags then
				create s.make_empty
				across
					l_tags as ic
				loop
					if not s.is_empty then
						s.append_character (',')
					end
					s.append (ic.item)
				end
				ti.set_text_value (s)
			end
			ti.set_is_required (False)
			f.extend (ti)
		end

	change_node	(response: NODE_RESPONSE; fd: WSF_FORM_DATA; a_node: like new_node)
		do
			Precursor (response, fd, a_node)
			if attached fd.string_item ("tags") as l_tags then
				a_node.set_tags_from_string (l_tags)
			end
		end

	new_node (response: NODE_RESPONSE; fd: WSF_FORM_DATA; a_node: detachable like new_node): like content_type.new_node
			-- <Precursor>
		do
			Result := Precursor (response, fd, a_node)
			if attached fd.string_item ("tags") as l_tags then
				Result.set_tags_from_string (l_tags)
			end
		end


end
