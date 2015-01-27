note
	description: "[
				Hook providing a way to alter a block.
		]"
	date: "$Date: 2014-11-19 20:00:19 +0100 (mer., 19 nov. 2014) $"
	revision: "$Revision: 96123 $"

deferred class
	CMS_HOOK_BLOCK

inherit
	CMS_HOOK

feature -- Hook

	block_list: ITERABLE [like {CMS_BLOCK}.name]
			-- List of block names, managed by current object.
		deferred
		end

	get_block_view (a_block_id: READABLE_STRING_8; a_response: CMS_RESPONSE)
			-- Get block object identified by `a_block_id' and associate with `a_response'.
		deferred
		end

end
