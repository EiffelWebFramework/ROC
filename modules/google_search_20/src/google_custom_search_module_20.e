note
	description: "[
			Module providing Google Custom Search functionality.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	GOOGLE_CUSTOM_SEARCH_MODULE_20

inherit

	CMS_MODULE
		redefine
			setup_hooks
		end

	CMS_HOOK_AUTO_REGISTER

	REFACTORING_HELPER

	CMS_HOOK_RESPONSE_ALTER

	CMS_HOOK_BLOCK_HELPER

	SHARED_EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

	REFACTORING_HELPER

	SHARED_LOGGER

create
	make

feature {NONE} -- Initialization

	make
			-- Create current module
		do
			version := "2.0"
			description := "Google custome search module 2.0"
			package := "search"
		end

feature -- Access

	name: STRING = "google_search_20"
			-- <Precursor>

feature -- Router

	setup_router (a_router: WSF_ROUTER; a_api: CMS_API)
			-- Router configuration.
		local
			m: WSF_URI_MAPPING
		do
			create m.make_trailing_slash_ignored ("/gcse20", create {WSF_URI_AGENT_HANDLER}.make (agent handle_search (a_api, ?, ?)))
			a_router.map (m, a_router.methods_head_get)
		end

feature -- GCSE Keys

	gcse_cx_key (api: CMS_API): detachable READABLE_STRING_8
			-- Get google custom search cx key.
		local
			utf: UTF_CONVERTER
		do
			if attached api.module_configuration (Current, Void) as cfg then
				if
					attached cfg.text_item ("gcse.cx") as l_gcse_cx_key and then
					not l_gcse_cx_key.is_empty
				then
					Result := utf.utf_32_string_to_utf_8_string_8 (l_gcse_cx_key)
				end
			end
		end

feature -- Handler

	handle_search (api: CMS_API; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			r: CMS_RESPONSE
		do
			write_debug_log (generator + ".handle_search")
			create {GENERIC_VIEW_CMS_RESPONSE} r.make (req, res, api)
			if
				attached {WSF_STRING} req.query_parameter ("q") as l_query and then
				not l_query.value.is_empty
			then
				if
					attached gcse_cx_key (api) as l_cx
				then
					r.set_value (l_query.value, "cms_search_query")
					if
						attached smarty_template_block (Current, "search", api) as l_tpl_block
					then
						r.add_block (l_tpl_block, "content")
					end
				end
			else
				r.add_message ("No query submitted", Void)
			end
			r.execute
		end


feature -- Hooks configuration

	setup_hooks (a_hooks: CMS_HOOK_CORE_MANAGER)
			-- Module hooks configuration.
		do
			auto_subscribe_to_hooks (a_hooks)
		end

	response_alter (a_response: CMS_RESPONSE)
			-- <Precursor>
		local
			l_script: STRING
		do
			if attached gcse_cx_key (a_response.api) as l_ctx then
				create l_script.make_from_string (gcse_20_script)
				l_script.replace_substring_all ("#CX_VALUE", l_ctx)
				a_response.add_javascript_content (l_script)
			end
		end


feature {NONE} -- Implementation

	gcse_20_script: STRING = "[
			  (function() {
			    var cx = '#CX_VALUE';
			    var gcse = document.createElement('script'); gcse.type = 'text/javascript'; gcse.async = true;
			    gcse.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') +
			        '//www.google.com/cse/cse.js?cx=' + cx;
			    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(gcse, s);
			  })();
			]"
end
