note
	description: "[
			Contact message storage based on SQL statements.
		]"
	date: "$Date: 2015-02-13 13:08:13 +0100 (ven., 13 fÃ©vr. 2015) $"
	revision: "$Revision: 96616 $"

class
	CONTACT_STORAGE_SQL

inherit
	CMS_PROXY_STORAGE_SQL

	CONTACT_STORAGE_I

	CMS_STORAGE_SQL_I

	REFACTORING_HELPER

create
	make

feature -- Access	

feature -- Change

	save_contact_message (m: CONTACT_MESSAGE)
		local
			l_parameters: STRING_TABLE [detachable ANY]
			now: DATE_TIME
		do
			create now.make_now_utc
			error_handler.reset

			write_information_log (generator + ".save_contact_message")
			create l_parameters.make (9)
			l_parameters.put (m, "message")
			l_parameters.put (now, "changed")
			sql_begin_transaction
			sql_modify (sql_insert_contact_message, l_parameters)
			sql_commit_transaction
		end

feature {NONE} -- Queries

	sql_insert_contact_message: STRING = "INSERT INTO contact_messages (name, email, date, message) VALUES (:name, :email, :date, :message);"
			-- SQL Insert to add a new contact message.

end
