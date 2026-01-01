local rhox_grudge_gg_only_mercenaries={
    --"urblab_rotgut_mercenary_ogres",
    --"jurgen_muntz_outlaw_infantry",
    --"stephan_weiss_outlaw_pistoliers",
    "vannheim_75th",
    "ragnar_wolves",
    "keelers_longbows"
}


cm:add_first_tick_callback_new(
    function()
        local faction_list = cm:model():world():faction_list();
        for i = 0, faction_list:num_items() - 1 do

            local faction = faction_list:item_at(i);
            if not RHOX_GRUDGEBRINGER_GOOD_CULTURE[faction:culture()] or RHOX_GRUDGEBRINGER_BAD_FACTION[faction:name()] then
                for j=1, #rhox_grudge_gg_only_mercenaries do
                    cm:add_event_restricted_unit_record_for_faction(rhox_grudge_gg_only_mercenaries[j], faction:name(), "rhox_grudge_camp_recruitment_locked_bad_guy")
                end
            end
        end
    end
)