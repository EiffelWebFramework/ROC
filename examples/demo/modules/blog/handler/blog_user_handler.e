note
	description: "Request handler related to /blogs/user/{id}/ or /blogs/user/{id}/page/{page}. Displays all posts of the given user"
	author: "Dario Bösch <daboesch@student.ethz.ch>"
	date: "$Date: 2015-05-22 15:13:00 +0100 (lun., 18 mai 2015) $"
	revision: "$Revision 96616$"

class
	BLOG_USER_HANDLER

inherit
	BLOG_HANDLER
		redefine
			do_get,
			posts,
			total_entries,
			page_title_html,
			base_path
		end

create
	make


feature -- Global Variables

	user : detachable CMS_USER

feature -- HTTP Methods

	do_get (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- <Precursor>
		local
			l_error: GENERIC_VIEW_CMS_RESPONSE
		do
			-- Check if userID valid
			if user_valid (req) then
				user := load_user(req)
				-- Output the results, similar as in the blog hanlder (but with other queries)
				precursor(req, res)
			else
				-- Throw a bad request error because the user is not valid
				create l_error.make (req, res, api)
				l_error.set_main_content ("<h1>Error</h1>User with id " + user_path_parameter(req).out + " doesn't exist!")
				l_error.execute
			end

		end

feature -- Query

	user_valid (req: WSF_REQUEST) : BOOLEAN
			-- Returns true if a valid user id is given and a user with this id exists; otherwise returns false.
		local
			user_id: INTEGER_32
		do

			user_id := user_path_parameter(req)

			if user_id <= 0 then
				--Given user id is not valid
				Result := false
			else
				--Check if user with user_id exists
				Result := api.user_api.user_by_id (user_id) /= Void
			end
		end

	load_user (req: WSF_REQUEST) :  detachable CMS_USER
			-- Returnes the user with the given id in the request req
		require
			user_valid(req)
		do
			Result := api.user_api.user_by_id (user_path_parameter(req))
		end

	user_path_parameter (req: WSF_REQUEST): INTEGER_32
			-- Returns the user id from the path /blogs/{user}. It's an unsigned integer since negative ids are not allowed. If no valid id can be read it returns -1
		local
			s: STRING
		do
			if attached {WSF_STRING} req.path_parameter ("user") as user_id then
				s := user_id.value
				if s.is_integer_32 then
					if s.to_integer_32 > 0 then
						Result := s.to_integer_32
					end
				end
			end
		end

	posts : LIST[CMS_NODE]
			-- The posts to list on the given page. Filters out the posts of the current user
		do
			if attached user as l_user then
				Result := node_api.blogs_from_user_order_created_desc_limited (l_user.id.to_integer_32, entries_per_page, (page_number-1) * entries_per_page)
			else
				create {ARRAYED_LIST [CMS_NODE]} Result.make (0)
			end
		end

	total_entries : NATURAL_32
			-- Returns the number of total entries/posts of the current user
		do
			if attached user as l_user then
				Result := node_api.blogs_count_from_user(l_user.id).to_natural_32
			else
				Result := precursor
			end

		end

feature -- HTML Output

	page_title_html : STRING
			-- Returns the title of the page as a html string. It shows the current page number and the name of the current user
		do
			create Result.make_from_string ("<h2>Posts from ")
			if attached user as l_user then
				Result.append(l_user.name)
			else
				Result.append ("unknown user")
			end
			if more_than_one_page then
				Result.append (" (Page " + page_number.out + " of " + pages.out + ")")
				-- Get the posts from the current page (limited by entries per page)
			end
			Result.append ("</h2>")
		end

	base_path : STRING
			-- the path to the page that lists all blogs. It must include the user id
		do
			if attached user as l_user then
				Result := "/blogs/user/" + l_user.id.out
			else
				Result := precursor
			end
		end

end
