note
	description: "Describe how to alter generic values before they are rendered."
	date: "$Date: 2014-10-23 08:30:11 -0300 (ju. 23 de oct. de 2014) $"
	revision: "$Revision: 95980 $"

deferred class
	CMS_HOOK_VALUE_ALTER

inherit

	CMS_HOOK

feature -- Hook

	value_alter (a_value: CMS_VALUE_TABLE; a_response: CMS_RESPONSE)
		deferred
		end
note
	copyright: "2011-2014, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
