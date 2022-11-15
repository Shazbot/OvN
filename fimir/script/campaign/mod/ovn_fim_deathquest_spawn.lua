local function ovn_fim_deathquest_spawn()
    local kroll_faction_key = "ovn_fim_tendrils_of_doom";
    local rancor_faction_key = "ovn_fim_rancor_hold";

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

            cm:add_unit_to_faction_mercenary_pool(FimFaction, "fim_inf_death_quest", "renown", 1, 20, 12, 0.1, "", "", "", true, "fim_inf_death_quest");

            if cm:get_faction(kroll_faction_key):is_human() or cm:get_faction(rancor_faction_key):is_human() then
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
                return context:character():faction():culture()  == "ovn_fimir" and (context:character():character_type_key() == "general" or context:character():character_type_key() == "colonel")
        end,
        function(context)
            local FimFaction = context:character():faction()

            cm:add_unit_to_faction_mercenary_pool(FimFaction, "fim_inf_death_quest", "renown", 1, 20, 12, 0.1, "", "", "", true, "fim_inf_death_quest");

            if cm:get_faction(kroll_faction_key):is_human() or cm:get_faction(rancor_faction_key):is_human() then
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
            function(context) return context:faction():culture()  == "ovn_fimir" and cm:get_faction("ovn_fim_rancor_hold"):is_dead()
            end,
            function(context)
                local FimFaction = cm:get_faction(kroll_faction_key)

                cm:add_unit_to_faction_mercenary_pool(FimFaction, "fim_inf_death_quest", "renown", 3, 20, 12, 0.1, "", "", "", true, "fim_inf_death_quest");
                
                if cm:get_faction(kroll_faction_key):is_human() then
                    cm:show_message_event(
                        kroll_faction_key,
                        "event_feed_fim_lost_rancor_hold_start_title",
                        "event_feed_fim_lost_rancor_hold_primary_detail",
                        "event_feed_fim_lost_rancor_hold_secondary_detail",
                        true,
                        2511
                    );
                end

                cm:set_saved_value("ovn_fimir_rancorhold_dead", true);
            end,
            false
        )
    end
    
    if cm:get_saved_value("ovn_fimir_kroll_dead") == nil then
        core:add_listener(
            "ovn_fim_spawn_deathquest_lost_kroll",
            "FactionTurnStart",
            function(context) return context:faction():culture() == "ovn_fimir" and cm:get_faction("ovn_fim_tendrils_of_doom"):is_dead()
            end,
            function(context)
                local FimFaction = cm:get_faction(rancor_faction_key)

                cm:add_unit_to_faction_mercenary_pool(FimFaction, "fim_inf_death_quest", "renown", 3, 20, 12, 0.1, "", "", "", true, "fim_inf_death_quest");

                if cm:get_faction(rancor_faction_key):is_human() then
                    cm:show_message_event(
                        rancor_faction_key,
                        "event_feed_fim_lost_kroll_start_title",
                        "event_feed_fim_lost_kroll_primary_detail",
                        "event_feed_fim_lost_kroll_secondary_detail",
                        true,
                        2511
                    );
                end
                cm:set_saved_value("ovn_fimir_kroll_dead", true);
            end,
            false
        )
    end
    
    if cm:get_saved_value("ovn_fimir_mist_dragons_dead") == nil then
        core:add_listener(
            "ovn_fim_spawn_deathquest_lost_mistdragons",
            "FactionTurnStart",
            function(context) return context:faction():culture()  == "ovn_fimir" and cm:get_faction("ovn_fim_mist_dragons"):is_dead()
            end,
            function(context)
                for _, human_fimir_faction_key in ipairs({kroll_faction_key, rancor_faction_key}) do
                    local FimFaction = cm:get_faction(human_fimir_faction_key)

                    cm:add_unit_to_faction_mercenary_pool(FimFaction, "fim_inf_death_quest", "renown", 3, 20, 12, 0.1, "", "", "", true, "fim_inf_death_quest");
        
                    if FimFaction:is_human() then
                        cm:show_message_event(
                            human_fimir_faction_key,
                            "event_feed_fim_lost_mist_dragons_start_title",
                            "event_feed_fim_lost_mist_dragons_primary_detail",
                            "event_feed__fim_lost_mist_dragons_secondary_detail",
                            true,
                            2511
                        );
                    end
                end

                cm:set_saved_value("ovn_fimir_mist_dragons_dead", true);

            end,
            false
        )
    end
    
    if cm:get_saved_value("ovn_fimir_marsh_hornets_dead") == nil then
        core:add_listener(
            "ovn_fim_spawn_deathquest_lost_marshhornets",
            "FactionTurnStart",
            function(context) return context:faction():culture()  == "ovn_fimir" and cm:get_faction("ovn_fim_marsh_hornets"):is_dead()
            end,
            function(context)
                for _, human_fimir_faction_key in ipairs({kroll_faction_key, rancor_faction_key}) do
                    local FimFaction = cm:get_faction(human_fimir_faction_key)

                    cm:add_unit_to_faction_mercenary_pool(FimFaction, "fim_inf_death_quest", "renown", 3, 20, 12, 0.1, "", "", "", true, "fim_inf_death_quest");
        
                    if FimFaction:is_human() then
                        cm:show_message_event(
                            human_fimir_faction_key,
                            "event_feed_fim_lost_marsh_hornets_start_title",
                            "event_feed_fim_lost_marsh_hornets_primary_detail",
                            "event_feed_fim_lost_marsh_hornets_secondary_detail",
                            true,
                            2511
                        );
                    end
                end

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
