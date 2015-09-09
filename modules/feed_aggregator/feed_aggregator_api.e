note
	description: "API for Feed aggregator module."
	date: "$Date$"
	revision: "$Revision$"

class
	FEED_AGGREGATOR_API

inherit
	CMS_MODULE_API

create
	make

feature -- Access

	aggregations: HASH_TABLE [FEED_AGGREGATION, STRING]
			-- List of feed aggregations.
		local
			agg: FEED_AGGREGATION
		do
			create Result.make (2)
			create agg.make ("Blog from Bertrand Meyer")
			agg.locations.force ("https://bertrandmeyer.com/category/computer-science/feed/")
			Result.force (agg, "bertrandmeyer")

			create agg.make ("Eiffel Room")
			agg.locations.force ("https://room.eiffel.com/recent_changes/feed")
			Result.force (agg, "eiffelroom")
		end

	aggregation (a_name: READABLE_STRING_GENERAL): detachable FEED_AGGREGATION
		do
			if attached a_name.is_valid_as_string_8 then
				Result := aggregations.item (a_name.as_string_8)
			end
		end

end
