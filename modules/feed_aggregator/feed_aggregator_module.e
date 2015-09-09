note
	description: "CMS module bringing support for feed aggregation."
	date: "$Date: 2015-02-13 13:08:13 +0100 (ven., 13 févr. 2015) $"
	revision: "$Revision: 96616 $"

class
	FEED_AGGREGATOR_MODULE

inherit
	CMS_MODULE
		rename
			module_api as feed_aggregator_api
		redefine
			initialize,
			register_hooks,
			permissions,
			feed_aggregator_api
		end

	CMS_HOOK_BLOCK

	CMS_HOOK_RESPONSE_ALTER

create
	make

feature {NONE} -- Initialization

	make
			-- Create Current module, disabled by default.
		do
			version := "1.0"
			description := "Feed aggregation"
			package := "feed"
		end

feature -- Access

	name: STRING = "feed_aggregator"

	permissions: LIST [READABLE_STRING_8]
			-- List of permission ids, used by this module, and declared.
		do
			Result := Precursor
			Result.force ("manage feed aggregator")
		end

feature {CMS_API} -- Module Initialization			

	initialize (api: CMS_API)
			-- <Precursor>
		do
			Precursor (api)
			create feed_aggregator_api.make (api)
		end

feature {CMS_API} -- Access: API

	feed_aggregator_api: detachable FEED_AGGREGATOR_API
			-- Eventual module api.

feature -- Access: router

	setup_router (a_router: WSF_ROUTER; a_api: CMS_API)
			-- <Precursor>
		do
--			a_router.handle ("/admin/feed_aggregator/", create {WSF_URI_AGENT_HANDLER}.make (agent handle_feed_aggregator_admin (a_api, ?, ?)), a_router.methods_head_get_post)
		end

feature -- Hooks configuration

	register_hooks (a_response: CMS_RESPONSE)
			-- Module hooks configuration.
		do
			a_response.hooks.subscribe_to_block_hook (Current)
			a_response.hooks.subscribe_to_response_alter_hook (Current)
		end

feature -- Hook

	block_list: ITERABLE [like {CMS_BLOCK}.name]
			-- List of block names, managed by current object.
		local
			res: ARRAYED_LIST [like {CMS_BLOCK}.name]
		do
			create res.make (5)
			if attached feed_aggregator_api as l_feed_api then
				across
					l_feed_api.aggregations as ic
				loop
					res.force ("feed__" + ic.key)
				end
			end
			Result := res
		end

	get_block_view (a_block_id: READABLE_STRING_8; a_response: CMS_RESPONSE)
			-- Get block object identified by `a_block_id' and associate with `a_response'.
		local
			i: INTEGER
			s: READABLE_STRING_8
			b: CMS_CONTENT_BLOCK
			l_content: STRING
			pref: STRING
		do
			if attached feed_aggregator_api as l_feed_api then
				pref := "feed__"
				if a_block_id.starts_with (pref) then
					s := a_block_id.substring (pref.count + 1, a_block_id.count)
				else
					s := a_block_id
				end
				if attached l_feed_api.aggregation (s) as l_agg then
					create l_content.make_empty
					if attached l_agg.description as l_desc then
						l_content.append_string_general (l_desc)
						l_content.append_character ('%N')
						l_content.append_character ('%N')
					end
					across
						l_agg.locations as ic
					loop
						l_content.append ("%T-" + ic.item)
						l_content.append_character ('%N')
					end
					create b.make (a_block_id, l_agg.name, l_content, Void)
					a_response.add_block (b, Void)
				end
			end
		end

feature -- Hook

	response_alter (a_response: CMS_RESPONSE)
		do
--			a_response.add_additional_head_line ("[
--					<style>
--						table.recent-changes th { padding: 3px; }
--						table.recent-changes td { padding: 3px; border: dotted 1px #ddd; }
--						table.recent-changes td.date { padding-left: 15px; }
--						table.recent-changes td.title { font-weight: bold; }
--						</style>
--				]", True)
		end

end
