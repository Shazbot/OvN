local fimir_faction_keys = {
    "ovn_fim_rancor_hold",
    "ovn_fim_tendrils_of_doom",
    "ovn_fim_marsh_hornets",
    "ovn_fim_mist_dragons",
}

local kroll_faction_key = "ovn_fim_tendrils_of_doom";
local rancor_faction_key = "ovn_fim_rancor_hold";

local function give_death_quest_after_faction_dies(died_faction_key)
    for _, fimir_faction_key in ipairs(fimir_faction_keys) do
        if fimir_faction_key ~= died_faction_key then
            local FimFaction = cm:get_faction(fimir_faction_key)

            cm:add_unit_to_faction_mercenary_pool(FimFaction, "fim_inf_death_quest", "renown", 1, 20, 10, 0.1, "", "", "", true, "fim_inf_death_quest");
            
            if cm:get_faction(fimir_faction_key):is_human() then
                cm:show_message_event(
                    fimir_faction_key,
                    "event_feed_fim_lost_"..tostring(died_faction_key).."_start_title",
                    "event_feed_fim_lost_"..tostring(died_faction_key).."_primary_detail",
                    "event_feed_fim_lost_"..tostring(died_faction_key).."_secondary_detail",
                    true,
                    2511
                );
            end
        end
    end
end

local function ovn_fim_deathquest_spawn()
    core:add_listener(
        "ovn_fim_spawn_deathquest_lost_battle",
        "CharacterCompletedBattle",
        function(context)
                local char = context:character()
                local losses = char:percentage_of_own_alliance_killed();
                return context:character():faction():culture()  == "ovn_fimir"
                and not char:won_battle() and losses >= 0.5
        end,
        function(context)
            local FimFaction = context:character():faction()

            cm:add_unit_to_faction_mercenary_pool(FimFaction, "fim_inf_death_quest", "renown", 1, 20, 10, 0.1, "", "", "", true, "fim_inf_death_quest");

            if FimFaction:is_human() then
                cm:show_message_event(
                    context:character():faction():name(),
                    "event_feed_fim_lost_battle_start_title",
                    "event_feed_fim_lost_battle_primary_detail",
                    "event_feed_fim_lost_battle_secondary_detail",
                    true,
                    2511
                );
            end
        end,
        true
    )

    core:add_listener(
        "ovn_fim_spawn_deathquest_lost_char",
        "CharacterConvalescedOrKilled",
        function(context)
                return context:character():faction():culture() == "ovn_fimir" and context:character():character_type_key() == "general"
        end,
        function(context)
            local char = context:character()
            -- don't trigger it for default Mixer faction leaders we kill at game start
            if char:character_subtype_key() == "wh_main_nor_marauder_chieftain" and cm:model():turn_number() == 1 then
                return
            end

            local FimFaction = char:faction()

            cm:add_unit_to_faction_mercenary_pool(FimFaction, "fim_inf_death_quest", "renown", 1, 20, 10, 0.1, "", "", "", true, "fim_inf_death_quest");

            if FimFaction:is_human() then
                cm:show_message_event(
                    context:character():faction():name(),
                    "event_feed_fim_lost_battle_start_title",
                    "event_feed_fim_lost_battle_primary_detail",
                    "event_feed_fim_lost_battle_secondary_detail",
                    true,
                    2511
                );
            end
        end,
        true
    )

    if cm:get_saved_value("ovn_fimir_rancorhold_dead") == nil then
        core:add_listener(
            "ovn_fim_spawn_deathquest_lost_rancorhold",
            "FactionTurnStart",
            function(context) return not cm:get_saved_value("ovn_fimir_rancorhold_dead") and context:faction():culture()  == "ovn_fimir" and cm:get_faction("ovn_fim_rancor_hold"):is_dead()
            end,
            function(context)
                give_death_quest_after_faction_dies("ovn_fim_rancor_hold")
                cm:set_saved_value("ovn_fimir_rancorhold_dead", true);
            end,
            false
        )
    end
    
    if cm:get_saved_value("ovn_fimir_kroll_dead") == nil then
        core:add_listener(
            "ovn_fim_spawn_deathquest_lost_kroll",
            "FactionTurnStart",
            function(context) return not cm:get_saved_value("ovn_fimir_kroll_dead") and context:faction():culture() == "ovn_fimir" and cm:get_faction("ovn_fim_tendrils_of_doom"):is_dead()
            end,
            function(context)
                give_death_quest_after_faction_dies("ovn_fim_tendrils_of_doom")
                cm:set_saved_value("ovn_fimir_kroll_dead", true);
            end,
            false
        )
    end
    
    if cm:get_saved_value("ovn_fimir_mist_dragons_dead") == nil then
        core:add_listener(
            "ovn_fim_spawn_deathquest_lost_mistdragons",
            "FactionTurnStart",
            function(context) return not cm:get_saved_value("ovn_fimir_mist_dragons_dead") and context:faction():culture()  == "ovn_fimir" and cm:get_faction("ovn_fim_mist_dragons"):is_dead()
            end,
            function(context)
                give_death_quest_after_faction_dies("ovn_fim_mist_dragons")
                cm:set_saved_value("ovn_fimir_mist_dragons_dead", true);
            end,
            false
        )
    end
    
    if cm:get_saved_value("ovn_fimir_marsh_hornets_dead") == nil then
        core:add_listener(
            "ovn_fim_spawn_deathquest_lost_marshhornets",
            "FactionTurnStart",
            function(context) return not cm:get_saved_value("ovn_fimir_marsh_hornets_dead") and context:faction():culture()  == "ovn_fimir" and cm:get_faction("ovn_fim_marsh_hornets"):is_dead()
            end,
            function(context)
                give_death_quest_after_faction_dies("ovn_fim_marsh_hornets")
                cm:set_saved_value("ovn_fimir_marsh_hornets_dead", true);
            end,
            false
        )
    end
end
    
cm:add_first_tick_callback(
    function()
        ovn_fim_deathquest_spawn()
    end
)
