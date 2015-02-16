note
	description: "Summary description for {CMS_STORAGE_MYSQL}."
	date: "$Date: 2015-02-09 22:29:56 +0100 (lun., 09 févr. 2015) $"
	revision: "$Revision: 96596 $"

class
	CMS_STORAGE_MYSQL

inherit
	CMS_STORAGE

	CMS_STORAGE_STORE_SQL

	CMS_USER_STORAGE_MYSQL

	CMS_NODE_STORAGE_MYSQL

	REFACTORING_HELPER

create
	make

feature -- Status report

	is_initialized: BOOLEAN
			-- Is storage initialized?
		do
			Result := has_user
		end

end
