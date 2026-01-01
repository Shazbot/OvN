local rhox_gurdge_lh_mission_key={
    "rhox_grudgebringer_lh_7",-- allor/ "wh3_main_combi_region_karak_hirn"
    "rhox_grudgebringer_lh_6",--luther/ "wh3_main_combi_region_averheim",
    "rhox_grudgebringer_lh_3",-- vlad/ "wh3_main_combi_region_vitevo",
    "rhox_grudgebringer_lh_4",-- envoy/ "wh3_main_combi_region_zhufbar",
    "rhox_grudgebringer_lh_2",-- ceridan/ "wh3_main_combi_region_kings_glade",
    "rhox_grudgebringer_lh_5",-- matthias/ "wh3_main_combi_region_altdorf",
    "rhox_grudgebringer_lh_1",-- ludwig/ "wh3_main_combi_region_flensburg",
}



local rhox_gruge_lh_key={
    "allor",
    "luther_flamenstrike",
    "ice_mage_vladimir_stormbringer",
    "dwarf_envoy",
    "ceridan",
    "matthias",
    "ludwig_uberdorf_agent_subtype"
}

local function summon_and_do_the_book_ui_thing(type, choice) --type 0 is mage 1 is fighter// choice 0~3
    local faction = cm:get_faction("ovn_emp_grudgebringers")
    local faction_leader_force = faction:faction_leader():military_force()

    local target_key = 3*type + choice + 1--because choice starts from 0
    local agent_subtype = rhox_gruge_lh_key[target_key]
    local agent_type = "champion"
    if target_key == 3 then
        agent_type = "wizard"
    end

    cm:spawn_unique_agent_at_character(faction:command_queue_index(), agent_subtype, faction:faction_leader():command_queue_index(), true)
    agent = cm:get_most_recently_created_character_of_type("ovn_emp_grudgebringers",agent_type, agent_subtype)
    
    if agent and faction_leader_force then
        cm:replenish_action_points(cm:char_lookup_str(agent))
        cm:embed_agent_in_force(agent ,faction_leader_force)
        if target_key == 5 then
            cm:callback(
                function()
                    local forename =  common:get_localised_string("land_units_onscreen_name_ilmarin")
                    cm:change_character_custom_name(agent, forename, "","","")
                end,
                0.1
            )
            
            cm:callback(
                function()
                    cm:add_character_model_override(agent, "ilmarin");
                end,
                0.2
            )
        end
    end 

    if type ==1 then --if this is fighter dilemma
        if choice == 0 then --and you picked envoy
            cm:remove_event_restricted_unit_record_for_faction("dwarf_envoy_dwarf_warriors", "ovn_emp_grudgebringers"); --it was dwarf envoy, unlock this unit's restriction
        else --and you picked somebody else
            cm:add_unit_to_faction_mercenary_pool(cm:get_faction("ovn_emp_grudgebringers"),"dwarf_envoy_dwarf_warriors", "renown", 0,0,0,0,"","","", true,"dwarf_envoy_dwarf_warriors") --you're not getting them
        end
    end

    local mission_statuses = cm:get_saved_value("ovn_grudge_missions_statuses") or {}
    mission_statuses.success = mission_statuses.success or {}
    mission_statuses.failed = mission_statuses.failed or {}
    if type ==0 then  --wizard
        mission_statuses.success[rhox_gurdge_lh_mission_key[target_key]] = true
        for i=1,3 do
            if i ~= target_key then
                mission_statuses.failed[rhox_gurdge_lh_mission_key[i]] = true
            end
        end
    else
        mission_statuses.success[rhox_gurdge_lh_mission_key[target_key]] = true
        for i=4,7 do
            if i ~= target_key then
                mission_statuses.failed[rhox_gurdge_lh_mission_key[i]] = true
            end
        end
    end
    cm:set_saved_value("ovn_grudge_missions_statuses", mission_statuses)

end


local choice_string ={
    "FIRST",
    "SECOND",
    "THIRD",
    "FOURTH",
    "FIFTH"
}

cm:add_first_tick_callback(
	function()
		if cm:get_faction("ovn_emp_grudgebringers"):is_human() and RHOX_GRUDGEBRINGER_MCT.all_hero == false and not RHOX_GRUDGEBRINGER_MCT.disable_all_hero_recruitment then
            core:add_listener(
                "rhox_grudge_wizard_dilemma",
                "MissionSucceeded",
                function(context)
                    return context:mission():mission_record_key() == "rhox_grudgebringer_piece_of_eight_12"
                end,
                function(context)
                    out("Rhox Grudge: In the dilemma issuer")
                    --trigger dilemma
                    local dilemma_builder = cm:create_dilemma_builder("rhox_grudgebringer_mage_dilemma");
                    local payload_builder = cm:create_payload();
                    for i=1, 3 do
                        dilemma_builder:add_choice_payload(choice_string[i], payload_builder);
                    end
                    cm:launch_custom_dilemma_from_builder(dilemma_builder, cm:get_faction("ovn_emp_grudgebringers"));
                    
                    core:add_listener(
                        "rhox_grudge_wizard_dilemma_choice_made",
                        "DilemmaChoiceMadeEvent",
                        function(context)
                            local dilemma = context:dilemma();
                            local choice = context:choice();
                            return dilemma == "rhox_grudgebringer_mage_dilemma"
                        end,
                        function(context)
                            local choice = context:choice();
                            summon_and_do_the_book_ui_thing(0, choice)
                        end,
                        false
                    );
                end,
                false
            );
            core:add_listener(
                "rhox_grudge_fighter_dilemma",
                "FactionTurnStart",
                function(context)    
                    return context:faction():name() == "ovn_emp_grudgebringers" and cm:model():turn_number() ==2
                end,
                function(context)
                    --trigger dilemma
                    local dilemma_builder = cm:create_dilemma_builder("rhox_grudgebringer_fighter_dilemma");
                    local payload_builder = cm:create_payload();
                    for i=1, 4 do
                        dilemma_builder:add_choice_payload(choice_string[i], payload_builder);
                    end
                    cm:launch_custom_dilemma_from_builder(dilemma_builder, cm:get_faction("ovn_emp_grudgebringers"));         
                    core:add_listener(
                        "rhox_grudge_fighter_dilemma_choice_made",
                        "DilemmaChoiceMadeEvent",
                        function(context)
                            local dilemma = context:dilemma();
                            local choice = context:choice();
                            return dilemma == "rhox_grudgebringer_fighter_dilemma"
                        end,
                        function(context)
                            local choice = context:choice();
                            summon_and_do_the_book_ui_thing(1, choice)
                        end,
                        false
                    );
                end,
                true
            )
            

            
		end
	end
)



