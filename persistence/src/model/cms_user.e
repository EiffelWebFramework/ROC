note
	description: "Summary description for {USER}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_USER

create
	make

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_32)
			-- Create an object with name `a_name'.
		do
			name := a_name
		end

feature -- Access

	id: INTEGER_64
		-- Unique id.

	name: READABLE_STRING_32
		-- User name.

	password: detachable READABLE_STRING_32
		-- User password.

	email: detachable READABLE_STRING_32
		-- User email.

feature -- Change element

	set_id (a_id: like id)
			-- Set `id' with `a_id'.
		do
			id := a_id
		ensure
			id_set: id = a_id
		end

	set_name (n: like name)
			-- Set `name' with `n'.
		do
			name := n
		ensure
			name_set: name = n
		end

	set_password (p: like password)
			-- Set `password' with `p'.
		do
			password := p
		ensure
			password_set: password = p
		end

	set_email (m: like email)
			-- Set `email' with `m'.
		do
			email := m
		ensure
			email_set: email = m
		end

end
