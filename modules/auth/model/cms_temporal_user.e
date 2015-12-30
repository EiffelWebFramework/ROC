note
	description: "Summary description for {CMS_TEMPORAL_USER}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_TEMPORAL_USER

inherit

	CMS_USER

create
		make,
		make_with_id

feature -- Access

	application: detachable STRING_32
			-- User application

feature -- Element change

	set_application (an_application: like application)
			-- Assign `application' with `an_application'.
		do
			application := an_application
		ensure
			application_assigned: application = an_application
		end

end
