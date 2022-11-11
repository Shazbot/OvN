-- file should be present in all OvN packs with the same name and content
-- only one file will run in the end and it doesn't matter which one it is

local function disable_even_feeds(isDisabling)
    cm:disable_event_feed_events(isDisabling, "wh_event_category_character", "", "")
    cm:disable_event_feed_events(isDisabling, "wh_event_category_conquest", "", "")
    cm:disable_event_feed_events(isDisabling, "wh_event_category_diplomacy", "", "")
    cm:disable_event_feed_events(isDisabling, "wh_event_category_faction", "", "")
    cm:disable_event_feed_events(isDisabling, "wh_event_category_provinces", "", "")
    cm:disable_event_feed_events(isDisabling, "wh_event_category_world", "", "")
    cm:disable_event_feed_events(isDisabling, "wh_event_category_military", "", "")
    cm:disable_event_feed_events(isDisabling, "wh_event_category_agent", "", "")
    cm:disable_event_feed_events(isDisabling, "", "wh_event_subcategory_character_deaths", "")
    cm:disable_event_feed_events(isDisabling, "", "", "character_trait_lost")
    cm:disable_event_feed_events(isDisabling, "", "", "character_ancillary_lost")
    cm:disable_event_feed_events(isDisabling, "", "", "character_wounded")
    cm:disable_event_feed_events(isDisabling, "", "", "character_dies_in_action")
    cm:disable_event_feed_events(isDisabling, "", "", "diplomacy_faction_destroyed")
    cm:disable_event_feed_events(isDisabling, "", "", "diplomacy_faction_encountered")
    cm:disable_event_feed_events(isDisabling, "", "", "diplomacy_trespassing")
    cm:disable_event_feed_events(isDisabling, "", "", "faction_resource_lost")
    cm:disable_event_feed_events(isDisabling, "", "", "faction_resource_gained")
    cm:disable_event_feed_events(isDisabling, "", "", "conquest_province_secured")
    cm:disable_event_feed_events(isDisabling, "", "", "agent_recruited")
end

cm:add_first_tick_callback(
	function()
        if cm:is_new_game() and cm:get_campaign_name() == "main_warhammer" then
            disable_even_feeds(true)

            cm:callback(
                function()
                    disable_even_feeds(false)
                end,
                7
            )
        end
    end
)
