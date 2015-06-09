note
	description: "[
			Specific application launcher

			DO NOT EDIT THIS CLASS

			you can customize APPLICATION_LAUNCHER
		]"
	date: "$Date: 2015-02-09 22:29:56 +0100 (lun., 09 févr. 2015) $"
	revision: "$Revision: 96596 $"

deferred class
	APPLICATION_LAUNCHER_I [G -> WSF_EXECUTION create make end]

feature -- Execution

	launch (opts: detachable WSF_SERVICE_LAUNCHER_OPTIONS)
		local
			launcher: WSF_DEFAULT_SERVICE_LAUNCHER [G]
		do
			create launcher.make_and_launch (opts)
		end

end


