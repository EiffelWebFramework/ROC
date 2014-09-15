note
	description: "[
			Specific application launcher

			DO NOT EDIT THIS CLASS

			you can customize APPLICATION_LAUNCHER
		]"
	date: "$Date: 2014-08-08 16:02:11 -0300 (vi., 08 ago. 2014) $"
	revision: "$Revision: 95593 $"

deferred class
	APPLICATION_LAUNCHER_I

feature -- Execution

	launch (a_service: WSF_SERVICE; opts: detachable WSF_SERVICE_LAUNCHER_OPTIONS)
		local
			launcher: WSF_SERVICE_LAUNCHER
		do
			create {WSF_DEFAULT_SERVICE_LAUNCHER} launcher.make_and_launch (a_service, opts)
		end

end


