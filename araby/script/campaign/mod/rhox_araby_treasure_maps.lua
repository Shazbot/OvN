local rhox_araby_initial_treasure_map_missions = {
	["ovn_arb_golden_fleet"] =	"wh2_dlc11_cst_treasure_map_starting_treasure_rhox_golden_magus"
}

local pirate_factions = {
	"wh2_dlc11_cst_rogue_bleak_coast_buccaneers",
	"wh2_dlc11_cst_rogue_boyz_of_the_forbidden_coast",
	"wh2_dlc11_cst_rogue_freebooters_of_port_royale",
	"wh2_dlc11_cst_rogue_grey_point_scuttlers",
	"wh2_dlc11_cst_rogue_terrors_of_the_dark_straights",
	"wh2_dlc11_cst_rogue_the_churning_gulf_raiders",
	"wh2_dlc11_cst_rogue_tyrants_of_the_black_ocean",
	"wh2_dlc11_cst_shanty_dragon_spine_privateers",
	"wh2_dlc11_cst_shanty_middle_sea_brigands",
	"wh2_dlc11_cst_shanty_shark_straight_seadogs"
}

local treasure_map_payload_mapping = {
	reward_5 = {
		["wh2_dlc11_cst_treasure_map_structure_treasure_me_1_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_symbols_treasure_me_7_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_lake_treasure_me_9_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_river_treasure_me_5_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_river_treasure_me_6_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_volcano_treasure_me_4_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_volcano_treasure_me_1_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_volcano_treasure_me_2_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_volcano_treasure_me_3_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_skull_treasure_me_8_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_skull_treasure_me_6_level_2"] = true
	},
	reward_4 = {
		["wh2_dlc11_cst_treasure_map_animal_treasure_me_5_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_island_treasure_me_6_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_lake_treasure_me_8_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_volcano_treasure_me_6_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_volcano_treasure_me_5_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_skull_treasure_me_3_level_2"] = true
	},
	reward_3 = {
		["wh2_dlc11_cst_treasure_map_animal_treasure_me_6_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_structure_treasure_me_2_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_island_treasure_me_4_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_symbols_treasure_me_5_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_lake_treasure_me_4_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_lake_treasure_me_6_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_skull_treasure_me_1_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_skull_treasure_me_7_level_2"] = true
	},
	reward_2 = {
		["wh2_dlc11_cst_treasure_map_animal_treasure_me_4_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_animal_treasure_me_7_level_2" ] = true,
		["wh2_dlc11_cst_treasure_map_structure_treasure_me_5_level_2"] = true
	},
	reward_1 = {
		["wh2_dlc11_cst_treasure_map_animal_treasure_me_4_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_structure_treasure_me_6_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_structure_treasure_me_3_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_structure_treasure_me_4_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_lake_treasure_me_7_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_river_treasure_me_8_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_river_treasure_me_7_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_volcano_treasure_me_7_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_volcano_treasure_me_8_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_skull_treasure_me_4_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_skull_treasure_me_2_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_skull_treasure_me_5_level_1"] = true
	}
}

local gm_faction = "ovn_arb_golden_fleet"



function rhox_araby_treasure_map_listeners()
	out("#### Adding Treasure Maps Listeners ####")
	
	if cm:is_new_game() then
		local human_factions = cm:get_human_factions()
		
		cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "")
		
		if cm:get_campaign_name() == "cr_oldworld" then 
            rhox_araby_initial_treasure_map_missions["ovn_arb_golden_fleet"]="wh2_dlc11_cst_treasure_map_starting_treasure_tow_rhox_golden_magus"
		end
		
		for i = 1, #human_factions do
			if rhox_araby_initial_treasure_map_missions[human_factions[i]] then
				cm:trigger_mission(human_factions[i], rhox_araby_initial_treasure_map_missions[human_factions[i]], true)
			end
		end
		
		cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "") end, 0.2)
		
		-- initialise this value at the start of a new singleplayer campaign - it's used by advice
		if not cm:get_saved_value("num_treasure_missions_succeeded_sp") then
			cm:set_saved_value("num_treasure_missions_succeeded_sp", 0)
		end
	end
	
	core:add_listener( 
		"rhox_araby_BattleCompleted_Treasure_Map",
		"BattleCompleted",
		function() 
			return cm:pending_battle_cache_human_is_involved()
		end,
		function()
			local main_attacker_faction_key = cm:pending_battle_cache_get_attacker_faction_name(1)
			local main_defender_faction_key = cm:pending_battle_cache_get_defender_faction_name(1)
			local main_attacker_faction = cm:get_faction(main_attacker_faction_key)
			local main_defender_faction = cm:get_faction(main_defender_faction_key)
			local main_attacker_faction_is_gm = main_attacker_faction_key == gm_faction
			local main_defender_faction_is_gm = main_defender_faction_key == gm_faction
			
			-- human won against a pirate faction
			for i = 1, #pirate_factions do
				if main_attacker_faction_key == pirate_factions[i] and cm:pending_battle_cache_defender_victory() and main_defender_faction_is_gm then
					trigger_treasure_map_mission(main_defender_faction_key, 30)
					return
				elseif main_defender_faction_key == pirate_factions[i] and cm:pending_battle_cache_attacker_victory() and main_attacker_faction_is_gm then
					trigger_treasure_map_mission(main_attacker_faction_key, 30)
					return
				end
			end
			
			-- human won against any other faction
			if main_attacker_faction and main_attacker_faction:is_human() and main_attacker_faction_is_gm and cm:pending_battle_cache_attacker_victory() then
				trigger_treasure_map_mission(main_attacker_faction_key, 0)
			elseif main_defender_faction and main_defender_faction:is_human() and main_defender_faction_is_gm and cm:pending_battle_cache_defender_victory() then
				trigger_treasure_map_mission(main_defender_faction_key, 0)
			end	
		end,
		true
	)
	 
	core:add_listener(
		"rhox_araby_MissionSucceeded_Treasure_Map",
		"MissionSucceeded",
		function(context)
			return context:faction():name() == gm_faction
		end,
		function(context)
            
			local current_mission = context:mission():mission_record_key()
			local faction = context:faction()
			local faction_name = faction:name()
			
			out("Rhox Araby Mission name: "..current_mission)
			if is_treasure_map_mission(current_mission) then
				set_treasure_map_end_variables(get_treasure_map_mission_category(current_mission))
				
				-- mission success advice
				if not cm:is_multiplayer() then
					local num_treasure_missions_succeeded_sp = cm:get_saved_value("num_treasure_missions_succeeded_sp") + 1
					
					cm:set_saved_value("num_treasure_missions_succeeded_sp", num_treasure_missions_succeeded_sp)
					
					if num_treasure_missions_succeeded_sp >= 1 and num_treasure_missions_succeeded_sp <= 2 then
						core:trigger_event("ScriptEventFirstTreasureMapMissionSucceeded")
					elseif num_treasure_missions_succeeded_sp >= 5 and num_treasure_missions_succeeded_sp <= 8 then
						core:trigger_event("ScriptEventFifthTreasureMapMissionSucceeded")
					end
				end
				
				-- generate the incident and its payload
				local incident_payload = cm:create_payload();
				
				out("Rhox Araby Mission type: "..get_treasure_map_mission_category(current_mission))
				if get_treasure_map_mission_category(current_mission) == "starting" then
					incident_payload:treasury_adjustment(4000)
					incident_payload:faction_pooled_resource_transaction("cst_infamy", "missions", 150, false)
				elseif get_treasure_map_mission_category(current_mission) == "unique" then
					incident_payload:treasury_adjustment(10000)
					incident_payload:faction_pooled_resource_transaction("cst_infamy", "missions", 150, false)
					incident_payload:faction_ancillary_gain(faction, get_random_ancillary_key_for_faction(faction_name, false, "rare"))
                    --incident_payload:faction_ancillary_gain(faction, get_random_ancillary_key_for_faction(faction_name, false, "rare"))
				elseif treasure_map_payload_mapping.reward_5[current_mission] then
					incident_payload:treasury_adjustment(8000)
					incident_payload:faction_ancillary_gain(faction, get_random_ancillary_key_for_faction(faction_name, false, "rare"))
                    --incident_payload:faction_ancillary_gain(faction, get_random_ancillary_key_for_faction(faction_name, false, "rare"))
				elseif treasure_map_payload_mapping.reward_4[current_mission] then
					incident_payload:treasury_adjustment(6000)
					incident_payload:faction_ancillary_gain(faction, get_random_ancillary_key_for_faction(faction_name, false, "uncommon"))
   					--incident_payload:faction_ancillary_gain(faction, get_random_ancillary_key_for_faction(faction_name, false, "uncommon"))
				elseif treasure_map_payload_mapping.reward_3[current_mission] then
					incident_payload:treasury_adjustment(5000)
					--incident_payload:faction_ancillary_gain(faction, get_random_ancillary_key_for_faction(faction_name, false, "uncommon"))
   					incident_payload:faction_ancillary_gain(faction, get_random_ancillary_key_for_faction(faction_name, false, "uncommon"))
				elseif treasure_map_payload_mapping.reward_2[current_mission] then
					incident_payload:treasury_adjustment(4000)
					incident_payload:faction_ancillary_gain(faction, get_random_ancillary_key_for_faction(faction_name, false, "common"))
                    --incident_payload:faction_ancillary_gain(faction, get_random_ancillary_key_for_faction(faction_name, false, "common"))
				elseif treasure_map_payload_mapping.reward_1[current_mission] then
					incident_payload:treasury_adjustment(3000)
				else
					incident_payload:treasury_adjustment(4000)
                    incident_payload:faction_pooled_resource_transaction("cst_infamy", "missions", 150, false)
				end
				
				cm:trigger_custom_incident(faction_name, "wh2_dlc11_incident_cst_found_treasure", true, incident_payload)
				
				-- delay triggering the next mission for a small period to give mission-success/hoard-uncovered event messages a chance to show
				cm:callback(function() trigger_treasure_map_mission(faction_name, 0) end, 0.5)
			end	
		end,
		true
	)
	
	core:add_listener(
		"rhox_araby_MissionCancelled_Treasure_Map",
		"MissionCancelled",
		function(context)
			return is_treasure_map_mission(context:mission():mission_record_key())
		end,
		function(context)
			set_treasure_map_end_variables(get_treasure_map_mission_category(context:mission():mission_record_key()))
		end,
		true
	)
	
	-- listen for treasure searches being failed
	local num_treasure_hunt_missions_succeeded = 0
	local num_treasure_hunt_missions_failed = 0
	
	core:add_listener(
		"rhox_araby_treasure_not_found_listener",
		"HaveCharacterWithinRangeOfPositionMissionEvaluationResultEvent",
		function(context)
			-- we don't test for the search being successful here as it allows the first instance of the trigger callback (which is triggered for each active treasure hunt mission) 
			-- to cancel subsequent failure tests - if the first is a success we don't want any failure events showing, and in this way they will be cancelled.
			return is_treasure_map_mission(context:mission_key()) and context:character():faction():name() == gm_faction
		end,
		function(context)
			if context:was_successful() then
				num_treasure_hunt_missions_succeeded = num_treasure_hunt_missions_succeeded + 1
			else
				num_treasure_hunt_missions_failed = num_treasure_hunt_missions_failed + 1
			end
			
			local faction = context:character():faction()
			local faction_key = faction:name()
			
			cm:callback(
				function()
					if not faction:is_factions_turn() then
						return
					end
				
					if num_treasure_hunt_missions_succeeded == 0 and num_treasure_hunt_missions_failed > 0 then
						cm:show_message_event(
							faction_key,						-- assumes that factions can only generate these failure events on their turn
							"event_feed_strings_text_wh2_scripted_event_treasure_hunt_search_failed_title",
							"factions_screen_name_" .. faction_key,
							"event_feed_strings_text_wh2_scripted_event_treasure_hunt_search_failed_secondary_detail",
							true,
							786
						)
					end
					
					num_treasure_hunt_missions_succeeded = 0
					num_treasure_hunt_missions_failed = 0
				end,
				0.3
			)
		end,
		true
	)
end

local function rhox_araby_gm_change_stance_icon()
    local dig_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "BL_parent", "land_stance_button_stack", "clip_parent", "stack_background", "button_MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING"); 
    if dig_button then
        dig_button:SetImagePath("ui/campaign ui/stance_icons/ovn_arb_golden_fleet/military_force_active_stance_type_channeling.png")
    end
    
    local active_dig_button_parent = find_uicomponent(core:get_ui_root(), "hud_campaign", "BL_parent", "land_stance_button_stack"); 
    
    if active_dig_button_parent then
        local active_dig_button= find_child_uicomponent(active_dig_button_parent, "button_MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING")
        if active_dig_button then
            active_dig_button:SetImagePath("ui/campaign ui/stance_icons/ovn_arb_golden_fleet/military_force_active_stance_type_channeling.png")
        end
    end
end

cm:add_first_tick_callback(
    function()
        if cm:get_local_faction_name(true) == "ovn_arb_golden_fleet" then --ui thing
            core:add_listener(
				"rhox_araby_CharacterSelected_deplobutton_shower",
				"CharacterSelected",
				function(context)
					return context:character():faction():name() == "ovn_arb_golden_fleet" and context:character():character_type_key() == "general";
				end,
				function(context)
                    rhox_araby_gm_change_stance_icon()
				end,
				true
            )
        end
    end
);