note
	description: "Summary description for {CMS_HOOK_BLOCK}."
	author: ""
	date: "$Date: 2014-08-28 08:21:49 -0300 (ju. 28 de ago. de 2014) $"
	revision: "$Revision: 95708 $"

deferred class
	CMS_HOOK_BLOCK

inherit
	CMS_HOOK

feature -- Hook

	block_list: ITERABLE [like {CMS_BLOCK}.name]
		deferred
		end

	get_block_view (a_block_id: detachable READABLE_STRING_8; a_response: CMS_RESPONSE)
		deferred
		end

end
