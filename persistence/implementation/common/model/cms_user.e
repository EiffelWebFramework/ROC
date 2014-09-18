note
	description: "Summary description for {USER}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_USER

inherit

	DEBUG_OUTPUT

create
	make

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_32)
			-- Create an object with name `a_name'.
		do
			name := a_name
			create creation_date.make_now_utc
		ensure
			name_set: name = a_name
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

	profile: detachable CMS_USER_PROFILE
		-- User profile.

	creation_date: DATE_TIME
		-- Creation date.

	last_login_date: detachable DATE_TIME
		-- User last login.

	data: detachable STRING_TABLE [detachable ANY]
		-- Additional user's data.

	data_item (k: READABLE_STRING_GENERAL): detachable ANY
			-- Additional item data.
		do
			if attached data as l_data then
				Result := l_data.item (k)
			end
		end

feature -- Status report

	has_id: BOOLEAN
		do
			Result := id > 0
		end

	has_email: BOOLEAN
		do
			Result := attached email as e and then not e.is_empty
		end

	debug_output: STRING
		do
			Result := name
		end

	same_as (u: detachable CMS_USER): BOOLEAN
		do
			Result := u /= Void and then id = u.id
		end

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

	set_profile (prof: like profile)
			-- Set `profile' with `prof'.
		do
			profile := prof
		ensure
			profile_set: profile = prof
		end

	set_data_item (k: READABLE_STRING_GENERAL; d: like data_item)
		local
			l_data: like data
		do
			l_data := data
			if l_data = Void then
				create l_data.make (1)
				data := l_data
			end
			l_data.force (d, k)
		end

	remove_data_item (k: READABLE_STRING_GENERAL)
		do
			if attached data as l_data then
				l_data.remove (k)
			end
		end

	set_profile_item (k: READABLE_STRING_8; v: READABLE_STRING_8)
		local
			prof: like profile
		do
			prof := profile
			if prof = Void then
				create prof.make
				profile := prof
			end
			prof.force (v, k)
		end

	set_last_login_date (dt: like last_login_date)
		do
			last_login_date := dt
		end

	set_last_login_date_now
		do
			set_last_login_date (create {DATE_TIME}.make_now_utc)
		end

end
