note
	description: "Configuration class for the blog module."
	author: "Dario Bösch <daboesch@student.ethz.ch"
	date: "$Date: 2015-05-22 11:26:00 +0100$"
	revision: "$Revision: 96616 $"

class
	CMS_BLOG_CONFIG


feature -- Configuration of blog handlers

	entries_per_page : NATURAL_32
			-- The numbers of posts that are shown on one page. If there are more post a pagination is generated
		do
			-- For test reasons this is 2, so we don't have to create a lot of blog entries.
			-- TODO: Set to bigger constant.
			Result := 2
		end

end
