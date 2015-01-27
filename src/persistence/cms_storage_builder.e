note
	description: "[
			Objects that ...
		]"
	author: "$Author: jfiat $"
	date: "$Date: 2015-01-27 19:15:02 +0100 (mar., 27 janv. 2015) $"
	revision: "$Revision: 96542 $"

deferred class
	CMS_STORAGE_BUILDER

feature -- Factory

	storage (a_setup: CMS_SETUP): detachable CMS_STORAGE
		deferred
		end

end
