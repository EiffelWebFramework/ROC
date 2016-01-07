note
	description: "[
		API to handle temporal User storage
		]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_TEMPORAL_USER_STORAGE_I

inherit
	SHARED_LOGGER

feature -- Error Handling

	error_handler: ERROR_HANDLER
			-- Error handler.
		deferred
		end

feature -- Access: Users

	users_count: INTEGER
			-- Number of pending users
			--! to be accepted or rejected
		deferred
		end

	user_temp_by_id (a_uid: like {CMS_USER}.id; a_consumer_table: READABLE_STRING_GENERAL): detachable CMS_USER
			-- Retrieve a temporal user by id `a_uid' for the consumer `a_consumer', if aby.
		deferred
		end

	user_by_name (a_name: like {CMS_USER}.name): detachable CMS_USER
			-- User with name `a_name', if any.
		require
			 a_name /= Void and then not a_name.is_empty
		deferred
		ensure
			same_name: Result /= Void implies a_name ~ Result.name
			password: Result /= Void implies (Result.hashed_password /= Void and Result.password = Void)
		end

	user_by_email (a_email: like {CMS_USER}.email): detachable CMS_USER
			-- User with name `a_email', if any.
		deferred
		ensure
			same_email: Result /= Void implies a_email ~ Result.email
			password: Result /= Void implies (Result.hashed_password /= Void and Result.password = Void)
		end


	user_by_activation_token (a_token: READABLE_STRING_32): detachable CMS_USER
			-- User with activation token `a_token', if any.
		deferred
		ensure
			password: Result /= Void implies (Result.hashed_password /= Void and Result.password = Void)
		end

	recent_users (a_lower: INTEGER; a_count: INTEGER): LIST [CMS_TEMPORAL_USER]
			-- List of recent `a_count' temporal users with an offset of `lower'.
		deferred
		end


	token_by_user_id (a_id: like {CMS_USER}.id): detachable STRING
			-- Retrieve activation token for user identified with id `a_id', if any.
		deferred
		end


feature -- New Temp User

	new_user_from_temporal_user (a_user: CMS_TEMPORAL_USER)
  			-- new user from temporal user `a_user'
  		require
  			no_id: not a_user.has_id
  		deferred
  		end

	remove_activation (a_token: READABLE_STRING_32)
			-- Remove activation by token `a_token'.
		deferred
		end

	new_temp_user (a_user: CMS_TEMPORAL_USER)
			-- New temp user `a_user'.
		require
			no_id: not a_user.has_id
		deferred
		end

	delete_user (a_user: CMS_USER)
			-- Delete user `a_user'.
		require
			has_id: a_user.has_id
		deferred
		end

end
