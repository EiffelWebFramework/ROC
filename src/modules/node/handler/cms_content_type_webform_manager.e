note
	description: "Summary description for {CMS_CONTENT_TYPE_WEBFORM_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_CONTENT_TYPE_WEBFORM_MANAGER

feature {NONE} -- Initialization

	make (a_type: like content_type)
		do
			content_type := a_type
		end

feature -- Access

	content_type: CMS_CONTENT_TYPE
			-- Associated content type.

	name: READABLE_STRING_8
		do
			Result := content_type.name
		end

feature -- Forms ...		

	fill_edit_form (response: NODE_RESPONSE; a_form: WSF_FORM; a_node: detachable CMS_NODE)
		deferred
		end

	new_node (response: NODE_RESPONSE; a_form_data: WSF_FORM_DATA; a_node: detachable CMS_NODE): CMS_NODE
		deferred
--			Result := content_type.new_node (a_node)
		end

	change_node (response: NODE_RESPONSE; a_form_data: WSF_FORM_DATA; a_node: CMS_NODE)
--		require
--			a_node.has_id
		deferred
		end

end
