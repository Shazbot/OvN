local fatandira_faction_name = "ovn_arb_aswad_scythans"



local assassination_results = {
    ["wh2_main_agent_action_champion_hinder_agent_assassinate"] = true,
    ["wh2_main_agent_action_runesmith_hinder_character_assassinate"] = true,
    ["wh2_main_agent_action_spy_hinder_agent_assassinate"] = true,
    ["wh2_main_agent_action_champion_hinder_agent_wound"] = true,
    ["wh2_main_agent_action_dignitary_hinder_agent_wound"] = true,
    ["wh2_main_agent_action_engineer_hinder_agent_wound"] = true,
    ["wh2_main_agent_action_runesmith_hinder_agent_wound"] = true,
    ["wh2_main_agent_action_wizard_hinder_agent_wound"] = true
}

local rhox_araby_fatandira_assassination_value = 5
local rhox_araby_fatandira_war_value = 10
local rhox_araby_fatandira_trade_value = 1
local rhox_araby_fatandira_alliance_value = 3

local function rhox_araby_fatandira_value_to_effect(value)
    if value > 80 then
        return 9
    elseif value > 60 then
        return 8
    elseif value > 40 then
        return 7
    elseif value > 20 then
        return 6
    elseif value > -21 then
        return 5
    elseif value > -41 then
        return 4
    elseif value > -61 then
        return 3
    elseif value > -81 then
        return 2
    else
        return 1
    end
end


local function rhox_araby_fatandira_update_meter()
    local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar",
        "rhox_araby_fatandira_bar", "imperial_authority_bar", "segments_list");
    if not parent_ui then
        return --do nothing instead of breaking
    end
    if parent_ui:ChildCount() <= 2 then
        out("Rhox Fatandira: Child wasn't made")
        return      --do nothing instead of breaking
    end
    for i = 1, 9 do --0 is the template
        --local current_frame = find_uicomponent(parent_ui, "current_frame"..i);
        local child_entry = find_child_uicomponent_by_index(parent_ui, i)
        if child_entry then
            local current_frame = find_uicomponent(child_entry, "current_frame")
            if current_frame then
                current_frame:SetVisible(false)
            end
        end
    end --there are 9 current_frames, set all of them to invisible


    local rivalry_value = cm:get_faction(fatandira_faction_name):pooled_resource_manager():resource(
    "rhox_fatandira_meter"):value();
    local current_id = rhox_araby_fatandira_value_to_effect(rivalry_value)
    out("Rhox Fatandira: current value: " .. rivalry_value)

    local child_entry = find_child_uicomponent_by_index(parent_ui, current_id)
    if child_entry then
        local current_frame = find_uicomponent(child_entry, "current_frame")
        if current_frame then
            current_frame:SetVisible(true) --then show only the correct one.
        end
    end
end

local function rhox_fatandira_add_tk_units(faction_obj, unit_group)
    for i, v in pairs(unit_group) do
        cm:add_unit_to_faction_mercenary_pool(
            faction_obj,
            v[1], -- key
            v[2], -- recruitment source
            v[3], -- count
            v[4], --replen chance
            v[5], -- max units
            0, -- max per turn
            "", --faction restriction
            "", --subculture restriction
            "", --tech restriction
            true, --partial
            v[1] .. "_rhox_ovn_araby"
        );
    end
end

local function rhox_araby_fatandira_stop_listners()
    core:remove_listener("rhox_araby_fatandira_turn_update")
    core:remove_listener("rhox_araby_fatandira_Assassination")
    core:remove_listener("rhox_araby_fatnadira_NegativeDiplomaticEvent")
end

local function rhox_araby_fatandira_add_listeners()
    if cm:get_saved_value("rhox_araby_saw_tk_allegiance_incident") ~= true and cm:get_saved_value("rhox_araby_saw_araby_allegiance_incident") ~= true then --if one of these have happened, do not update the value
        cm:add_faction_turn_start_listener_by_name(
            "rhox_araby_fatandira_turn_update",
            fatandira_faction_name,
            function(context)
                local trade_partners = context:faction():factions_trading_with()
                local alliance_partners = context:faction():factions_allied_with()
                if trade_partners:num_items() > 0 then
                    for i, faction in model_pairs(trade_partners) do
                        if faction:culture() == "wh2_dlc09_tmb_tomb_kings" then --move towards TK
                            cm:faction_add_pooled_resource(fatandira_faction_name, "rhox_fatandira_meter", "diplomacy",
                                -1 * rhox_araby_fatandira_trade_value);
                        elseif faction:culture() == "ovn_araby" then
                            cm:faction_add_pooled_resource(fatandira_faction_name, "rhox_fatandira_meter", "diplomacy",
                                rhox_araby_fatandira_trade_value);
                        end
                    end
                end
                if alliance_partners:num_items() > 0 then
                    for i, faction in model_pairs(alliance_partners) do
                        if faction:culture() == "wh2_dlc09_tmb_tomb_kings" then --move towards TK
                            cm:faction_add_pooled_resource(fatandira_faction_name, "rhox_fatandira_meter", "diplomacy",
                                -1 * rhox_araby_fatandira_alliance_value);
                        elseif faction:culture() == "ovn_araby" then
                            cm:faction_add_pooled_resource(fatandira_faction_name, "rhox_fatandira_meter", "diplomacy",
                                rhox_araby_fatandira_alliance_value);
                        end
                    end
                end

                if cm:get_saved_value("rhox_araby_saw_araby_allegiance_incident") ~= true and cm:get_saved_value("rhox_araby_saw_tk_allegiance_incident") ~= true and cm:get_faction(fatandira_faction_name):pooled_resource_manager():resource("rhox_fatandira_meter"):value() == 100 then
                    cm:set_saved_value("rhox_araby_saw_araby_allegiance_incident", true)
                    cm:trigger_incident(fatandira_faction_name, "rhox_araby_fatandira_araby_100", true, true);
                    cm:remove_event_restricted_unit_record_for_faction("ovn_arb_mon_desert_spirit_ror",
                        fatandira_faction_name)
                    cm:remove_event_restricted_unit_record_for_faction("ovn_arb_mon_fire_efreet_ror",
                        fatandira_faction_name)
                    cm:remove_event_restricted_unit_record_for_faction("ovn_arb_mon_sea_nymph_ror",
                        fatandira_faction_name)
                    cm:remove_event_restricted_unit_record_for_faction("ovn_arb_mon_tempest_djinn_ror",
                        fatandira_faction_name)
                    rhox_araby_fatandira_stop_listners()
                end
                
                if cm:get_saved_value("rhox_araby_saw_araby_allegiance_incident") == true then
                    cm:faction_add_pooled_resource(fatandira_faction_name, "rhox_fatandira_meter", "diplomacy",200);
                end


                if cm:get_saved_value("rhox_araby_saw_tk_allegiance_incident") ~= true and cm:get_saved_value("rhox_araby_saw_araby_allegiance_incident") ~= true and cm:get_faction(fatandira_faction_name):pooled_resource_manager():resource("rhox_fatandira_meter"):value() == -100 then
                    cm:set_saved_value("rhox_araby_saw_tk_allegiance_incident", true)
                    cm:trigger_incident(fatandira_faction_name, "rhox_araby_fatandira_tk_100", true, true);

                    local rhox_fatandira_tk_units = {
                        ---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
                        { "ovn_arb_tmb_mon_heirotitan_0",         "renown", 1, 10, 1 },
                        { "ovn_arb_tmb_mon_necrosphinx_0",        "renown", 1, 10, 1 },
                        { "ovn_arb_tmb_veh_khemrian_warsphinx_0", "renown", 2, 10, 2 },
                        { "ovn_arb_tmb_mon_ushabti_0",            "renown", 2, 10, 2 },
                        { "ovn_arb_tmb_mon_ushabti_1",            "renown", 2, 10, 2 },
                    }

                    rhox_fatandira_add_tk_units(context:faction(), rhox_fatandira_tk_units);
                    rhox_araby_fatandira_stop_listners()
                end
                
                if cm:get_saved_value("rhox_araby_saw_tk_allegiance_incident") == true then
                    cm:faction_add_pooled_resource(fatandira_faction_name, "rhox_fatandira_meter", "diplomacy",-200);
                end

                rhox_araby_fatandira_update_meter()
            end,
            true
        );

        core:add_listener(
            "rhox_araby_fatandira_Assassination",
            "CharacterCharacterTargetAction",
            function(context)
                return (context:mission_result_critial_success() or context:mission_result_success()) and
                assassination_results[context:agent_action_key()] and context:character():faction():is_human()
            end,
            function(context)
                local target_character = context:target_character()
                if target_character:faction():culture() == "wh2_dlc09_tmb_tomb_kings" then --target tombking towards araby side
                    cm:faction_add_pooled_resource(fatandira_faction_name, "rhox_fatandira_meter",
                        "characters_assassinated", rhox_araby_fatandira_assassination_value);
                elseif target_character:faction():culture() == "ovn_araby" then        --target araby moving towards tk side
                    cm:faction_add_pooled_resource(fatandira_faction_name, "rhox_fatandira_meter",
                        "characters_assassinated", -1 * rhox_araby_fatandira_assassination_value);
                end
            end,
            true
        )

        core:add_listener(
            "rhox_araby_fatnadira_NegativeDiplomaticEvent",
            "NegativeDiplomaticEvent",
            function(context)
                local proposer = context:proposer();
                return context:is_war() and proposer:is_human()
            end,
            function(context)
                out("Rhox Araby: Checked battle")
                local proposer = context:proposer();
                local recipient = context:recipient();
                local player = proposer:name();
                if recipient:culture() == "wh2_dlc09_tmb_tomb_kings" then
                    cm:faction_add_pooled_resource(player, "rhox_fatandira_meter", "diplomacy",
                        rhox_araby_fatandira_war_value);
                elseif recipient:culture() == "ovn_araby" then
                    cm:faction_add_pooled_resource(player, "rhox_fatandira_meter", "diplomacy",
                        -1 * rhox_araby_fatandira_war_value);
                end
            end,
            true
        );
    end

    core:add_listener(
        "rhox_araby_fatandira_pooled_resource_change_check",
        "PooledResourceChanged",
        function(context)
            return context:resource():key() == "rhox_fatandira_meter" and context:faction():is_human()
        end,
        function(context)
            --it will still happen because of battlefield loot and stuff
            rhox_araby_fatandira_update_meter()
            if cm:get_saved_value("rhox_araby_saw_araby_allegiance_incident") == true then --100
                cm:faction_add_pooled_resource(fatandira_faction_name, "rhox_fatandira_meter", "diplomacy",200);
            elseif cm:get_saved_value("rhox_araby_saw_tk_allegiance_incident") == true then -- -100
                cm:faction_add_pooled_resource(fatandira_faction_name, "rhox_fatandira_meter", "diplomacy",-200);
            end
        end,
        true
    )
    
    core:add_listener(
        "rhox_araby_fatandira_betrayal_check",
        "NegativeDiplomaticEvent",
        function(context)
            return context:is_war() and context:proposer():is_human() and context:proposer():name() == fatandira_faction_name and context:recipient():name() == "wh2_dlc09_tmb_numas"
        end,
        function(context)
            local faction = context:proposer()
            local incident_key = "rhox_araby_fatandira_betrayal"
            local incident_builder = cm:create_incident_builder(incident_key)
            local payload = cm:create_new_custom_effect_bundle("rhox_fatandira_betrayal")
            payload:set_duration(20)

            local payload_builder = cm:create_payload()
            payload_builder:effect_bundle_to_faction(payload)  
            incident_builder:set_payload(payload_builder)
            cm:launch_custom_incident_from_builder(incident_builder, faction)
            --cm:set_saved_value("rhox_araby_fatandira_betrated", true) -- it can fire multiple times as you can return and revive them so to block it, it needs to be triggered multiple times
        end,
        true
    )
    
    
end



cm:add_first_tick_callback(
    function()
        if cm:get_local_faction_name(true) == fatandira_faction_name then --ui thing and should be local
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder",
                "resources_bar");
            local result = core:get_or_create_component("rhox_araby_fatandira_bar",
                "ui/campaign ui/rhox_araby_fatandira_holder.twui.xml", parent_ui)

            core:add_listener(
                "applymeterOnGameStart",
                "ScriptEventIntroCutsceneFinished",
                true,
                function(context)
                    cm:callback(function() rhox_araby_fatandira_update_meter() end, 0.5)
                end,
                false
            )

            rhox_araby_fatandira_update_meter()
            
            cm:callback(
                function()
                    rhox_araby_fatandira_update_meter()
                end,
                5
            )
        end
        if cm:get_faction(fatandira_faction_name) and cm:get_faction(fatandira_faction_name):is_human() then
            rhox_araby_fatandira_add_listeners()
        end
    end
);
