
local function ovn_fim_deathquest_spawn()

local kroll_faction_key = "ovn_fim_tendrils_of_doom";
local rancor_faction_key = "ovn_fim_rancor_hold";

core:add_listener(
    "ovn_fim_spawn_deathquest_lost_battle",
    "CharacterCompletedBattle",
    function(context)
            local char = context:character()
            local losses = char:percentage_of_own_alliance_killed();
            return (context:character():faction():name() == kroll_faction_key
            or context:character():faction():name() == rancor_faction_key)
            and not char:won_battle() and (char:is_wounded() or losses >= 0.6)
    end,
    function(context)
        cm:add_unit_to_faction_mercenary_pool(kroll_faction_key, "fim_inf_death_quest", "renown", 1, 20, 12, 0.1, "", "", "", true, "fim_inf_death_quest");

        if cm:get_faction(kroll_faction_key):is_human() or cm:get_faction(rancor_faction_key):is_human() then

        cm:show_message_event(
            context:character():faction():name(),
								"event_feed_fim_lost_battle_start_title",
								"event_feed_fim_lost_battle_primary_detail",
								"event_feed_fim_lost_battle_secondary_detail",
								true,
								595
							);

        end
    end,
    true
)

if cm:get_saved_value("ovn_fimir_rancorhold_dead") == nil then

core:add_listener(
    "ovn_fim_spawn_deathquest_lost_rancorhold",
    "FactionTurnStart",
    function(context) return context:faction():name() == kroll_faction_key and cm:get_faction("ovn_fim_rancor_hold"):is_dead()
    end,
    function(context)
        cm:add_unit_to_faction_mercenary_pool(kroll_faction_key, "fim_inf_death_quest", "renown", 3, 20, 12, 0.1, "", "", "", true, "fim_inf_death_quest");
        if cm:get_faction(kroll_faction_key):is_human() then
        cm:show_message_event(
            kroll_faction_key,
								"event_feed_fim_lost_rancor_hold_start_title",
								"event_feed_fim_lost_rancor_hold_primary_detail",
								"event_feed_fim_lost_rancor_hold_secondary_detail",
								true,
								595
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
        function(context) return context:faction():name() == rancor_faction_key and cm:get_faction("ovn_fim_tendrils_of_doom"):is_dead()
        end,
        function(context)
            cm:add_unit_to_faction_mercenary_pool(kroll_faction_key, "fim_inf_death_quest", "renown", 3, 20, 12, 0.1, "", "", "", true, "fim_inf_death_quest");
            if cm:get_faction(rancor_faction_key):is_human() then
            cm:show_message_event(
                rancor_faction_key,
                                    "event_feed_fim_lost_kroll_start_title",
                                    "event_feed_fim_lost_kroll_primary_detail",
                                    "event_feed_fim_lost_kroll_secondary_detail",
                                    true,
                                    595
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
            function(context) return (context:faction():name() == rancor_faction_key or context:faction():name() == kroll_faction_key) and cm:get_faction("ovn_fim_mist_dragons"):is_dead()
            end,
            function(context)
                cm:add_unit_to_faction_mercenary_pool(kroll_faction_key, "fim_inf_death_quest", "renown", 3, 20, 12, 0.1, "", "", "", true, "fim_inf_death_quest");
                cm:add_unit_to_faction_mercenary_pool(rancor_faction_key, "fim_inf_death_quest", "renown", 3, 20, 12, 0.1, "", "", "", true, "fim_inf_death_quest");

                if cm:get_faction(kroll_faction_key):is_human() or cm:get_faction(rancor_faction_key):is_human() then
                cm:show_message_event(
                    context:character():faction():name(),
                                        "event_feed_fim_lost_mist_dragons_start_title",
                                        "event_feed_fim_lost_mist_dragons_primary_detail",
                                        "event_feed__fim_lost_mist_dragons_secondary_detail",
                                        true,
                                        595
                                    );
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
                function(context) return (context:faction():name() == rancor_faction_key or context:faction():name() == kroll_faction_key) and cm:get_faction("ovn_fim_marsh_hornets"):is_dead()
                end,
                function(context)
                    cm:add_unit_to_faction_mercenary_pool(kroll_faction_key, "fim_inf_death_quest", "renown", 3, 20, 12, 0.1, "", "", "", true, "fim_inf_death_quest");
                    cm:add_unit_to_faction_mercenary_pool(rancor_faction_key, "fim_inf_death_quest", "renown", 3, 20, 12, 0.1, "", "", "", true, "fim_inf_death_quest");

                    if cm:get_faction(kroll_faction_key):is_human() or cm:get_faction(rancor_faction_key):is_human() then
                    cm:show_message_event(
                        context:character():faction():name(),
                                            "event_feed_fim_lost_marsh_hornets_start_title",
                                            "event_feed_fim_lost_marsh_hornets_primary_detail",
                                            "event_feed_fim_lost_marsh_hornets_secondary_detail",
                                            true,
                                            595
                                        );
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