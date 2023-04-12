local grudgebringer_faction = "ovn_emp_grudgebringers"


local mission_types = {
	{"KILL_CHARACTER_BY_ANY_MEANS", "wh3_main_mission_ogre_contract_defeat_lord"},
	{"RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING", "wh3_main_mission_ogre_contract_raze_settlement"}
};

local culture_mapping = {
	["wh2_dlc09_tmb_tomb_kings"] = "tomb_kings",
	["wh2_dlc11_cst_vampire_coast"] = "vampire_coast",
	["wh2_main_def_dark_elves"] = "dark_elves",
	["wh2_main_hef_high_elves"] = "high_elves",
	["wh2_main_lzd_lizardmen"] = "lizardmen",
	["wh2_main_skv_skaven"] = "skaven",
	["wh3_main_cth_cathay"] = "cathay",
	["wh3_main_dae_daemons"] = "warriors_of_chaos",
	["wh3_main_kho_khorne"] = "khorne",
	["wh3_main_ksl_kislev"] = "kislev",
	["wh3_main_nur_nurgle"] = "nurgle",
	["wh3_main_ogr_ogre_kingdoms"] = "ogre_kingdoms",
	["wh3_main_sla_slaanesh"] = "slaanesh",
	["wh3_main_tze_tzeentch"] = "tzeentch",
	["wh_dlc03_bst_beastmen"] = "beastmen",
	["wh_dlc05_wef_wood_elves"] = "wood_elves",
	["wh_dlc08_nor_norsca"] = "norsca",
	["wh_main_brt_bretonnia"] = "bretonnia",
	["wh_main_chs_chaos"] = "warriors_of_chaos",
	["wh_main_dwf_dwarfs"] = "dwarfs",
	["wh_main_emp_empire"] = "empire",
	["wh_main_grn_greenskins"] = "greenskins",
	["wh_main_vmp_vampire_counts"] = "vampire_counts"
};

local contract_time = 6

local rhox_missing_ror_chance_contract = 20

local mission_issued = false

cm:add_first_tick_callback(
	function()
		if cm:get_local_faction_name(true) == grudgebringer_faction then
            
            out("Rhox Grudgebringer: Before making ui component")
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management");
            --local result = core:get_or_create_component("rhox_button_ogre_contracts", "ui/campaign ui/rhox_grudge_contract.twui.xml", parent_ui)
            local result = UIComponent(parent_ui:CreateComponent("rhox_button_contracts", "ui/campaign ui/rhox_grudgebringer_contract.twui.xml"))
            if not result then
                script_error("Rhox grudgebringer: ".. "ERROR: could not create contract ui component? How can this be?");
                return false;
            end;
            result:SetVisible(true)
            result:SetTooltipText(common.get_localised_string("uied_component_texts_localised_string_button_ogre_contracts_Tooltip_eaa3afec"), true)
            rhox_grudgebringer_setup_contracts()
		end
	end
)

cm:add_first_tick_callback_new(
	function()
		if cm:get_local_faction_name(true) == grudgebringer_faction then
            rhox_reset_contracts_timer(grudgebringer_faction); 
		end
	end
)


function rhox_reset_contracts_timer(faction_key)
	cm:add_turn_countdown_event(faction_key, contract_time, "ScriptEventAttemptToIssueOgreContracts", faction_key);
end;


function rhox_grudgebringer_setup_contracts()
	local human_ogre_exists = false;
	local human_factions = cm:get_human_factions(true);
	out("Rhox Grudgebringer: Setup contracts")
	if cm:get_local_faction_name(true) == grudgebringer_faction then
        rhox_update_contracts_remaining_turns(grudgebringer_faction); 
        
        core:add_listener(
            "rhox_grudgebringer_update_contracts_timer",
            "FactionTurnStart",
            function(context)
                return context:faction():name() == grudgebringer_faction;
            end,
            function()   
                mission_issued = false --it'll become true when you get the mission
                rhox_update_contracts_remaining_turns(grudgebringer_faction); 
            end,
            true
        );
	
		core:add_listener(
			"rhox_grudgebringer_issue_contracts",
			"ScriptEventAttemptToIssueOgreContracts",
			true,
			function(context)
				rhox_attempt_to_issue_contracts(context.string); 
			end,
			true
		);
		
		core:add_listener(
			"rhox_grudgebringer_clear_contracts",
			"ScriptEventClearOgreContracts",
			true,
			function(context)
				cm:clear_pending_missions(cm:get_faction(context.string)); 
			end,
			true
		);
		
		core:add_listener(
            "rhox_grudgebringer_mission_button_clicked",
            "ComponentLClickUp",
            function(context)
                return context.string == "accept_contract"
            end,
            function(context)
                mission_issued = true
                rhox_update_contracts_remaining_turns(grudgebringer_faction)
            end,
            true
        )

	end	
end;



function rhox_update_contracts_remaining_turns(faction_key)
	local turns_remaining, a, e, c = cm:report_turns_until_countdown_event(faction_key, "ScriptEventAttemptToIssueOgreContracts");
	
	local contract_button_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management", "rhox_button_contracts");
	local alert_ui = find_uicomponent(contract_button_ui, "alert_icon");
	local turns_ui = find_uicomponent(contract_button_ui, "turns_icon");
	out("Rhox Grundgebringer: turns_remaining: "..turns_remaining)
	
    if turns_remaining == contract_time and mission_issued == false and cm:model():turn_number()>1 then --turn number should be greater than 1
        out("Rhox grudgebringer: Turning on the button")
        --contract_button_ui:SetState("active")
        contract_button_ui:SetImagePath("ui/skins/default/button_round_large_active.png", 1)
        contract_button_ui:SetImagePath("ui/skins/default/button_round_large_active.png", 2)
        contract_button_ui:SetImagePath("ui/skins/default/button_round_large_active.png", 3)
        contract_button_ui:SetDisabled(false)
        --contract_button_ui:SetInteractive(true)
        --alert_ui:SetVisible(true) --it activates on its own
        turns_ui:SetVisible(false)
        
        --rhox_attempt_to_issue_contracts(grudgebringer_faction) --I don't know let's see if this solves the issue
    else
        out("Rhox grudgebringer: You have to wait more for the mission")
		common.set_context_value("turns_until_ogre_contracts_" .. faction_key, tostring(turns_remaining));
		contract_button_ui:SetImagePath("ui/skins/default/button_round_large_inactive.png", 1)
		contract_button_ui:SetImagePath("ui/skins/default/button_round_large_inactive.png", 2)
		contract_button_ui:SetImagePath("ui/skins/default/button_round_large_inactive.png", 3)
		--contract_button_ui:SetState("inactive") --didn't work
		contract_button_ui:SetDisabled(true)
		--contract_button_ui:SetInteractive(false)
		--alert_ui:SetVisible(false)
		turns_ui:SetVisible(true)
		--out("Rhox Grundgebringer: Current state: "..contract_button_ui:CurrentState())
	end;
end;


local rhox_grudgebringer_good_culture ={
    ["wh2_main_hef_high_elves"] = true,
    ["wh3_main_cth_cathay"] = true,
    ["wh3_main_ksl_kislev"] = true,
    ["wh_dlc05_wef_wood_elves"] = true,
    ["wh_main_brt_bretonnia"] = true,
    ["wh_main_dwf_dwarfs"] = true,
    ["wh_main_emp_empire"] = true,
    ["mixer_teb_southern_realms"] = true
}


function rhox_attempt_to_issue_contracts(faction_key)
    out("Rhox Grudgebringer: I'm going to give you a mission!")
	local faction = cm:get_faction(faction_key);
	local faction_has_home_region = faction:has_home_region();
	local faction_has_faction_leader = faction:has_faction_leader();
	local faction_region_list = faction:region_list();
	
	local trigger_incident = false;
	
	-- get 3 factions to issue missions
	local factions_met = faction:factions_met();
	
	local factions_met_at_peace = {};
	
	-- only get factions that have capitals near to the player
	local max_distance_between_player_settlement_and_issuer_capital = 50000;
	
	for i = 0, factions_met:num_items() - 1 do
		local current_faction = factions_met:item_at(i);
		
		if not faction:at_war_with(current_faction) and not current_faction:is_dead() and not current_faction:is_human() and current_faction:has_home_region() and rhox_grudgebringer_good_culture[current_faction:culture()] then --have to be good culture added to the condition
			if faction_has_home_region then
				local current_faction_capital = current_faction:home_region():settlement();
				
				for j = 0, faction_region_list:num_items() - 1 do
					local current_settlement = faction_region_list:item_at(j):settlement();
					
					if distance_squared(current_settlement:logical_position_x(), current_settlement:logical_position_y(), current_faction_capital:logical_position_x(), current_faction_capital:logical_position_y()) < max_distance_between_player_settlement_and_issuer_capital then
						table.insert(factions_met_at_peace, current_faction);
						break;
					end;
				end;
			elseif faction_has_faction_leader then
				table.insert(factions_met_at_peace, current_faction);
			else
				-- player doesn't have a faction leader or a capital somehow, not issuing contracts
				return false;
			end;
		end;
	end;
	
	if #factions_met_at_peace < 1 then
		-- found no peaceful factions, not issuing contracts
		return false;
	end;
	
	factions_met_at_peace = cm:random_sort(factions_met_at_peace);
	
	local used_general_targets = cm:get_saved_value("ogre_contracts_used_general_targets") or {};
	local used_region_targets = cm:get_saved_value("ogre_contracts_used_region_targets") or {};
	
	local faction_pos_x = 0;
	local faction_pos_y = 0;
	
	if faction_has_faction_leader then
		local faction_leader = faction:faction_leader();
		
		faction_pos_x = faction_leader:logical_position_x();
		faction_pos_y = faction_leader:logical_position_y();
	elseif faction_has_home_region then
		local capital = faction:home_region():settlement();
		
		faction_pos_x = capital:logical_position_x();
		faction_pos_y = capital:logical_position_y();
	else
		-- player doesn't have a faction leader or a capital somehow, not issuing contracts
		return false;
	end;
	
	for i = 1, 3 do
		local selected_issuing_faction = factions_met_at_peace[i];
		
		if not selected_issuing_faction then
			selected_issuing_faction = factions_met_at_peace[1];
		end;
		
		local selected_issuing_faction_name = selected_issuing_faction:name();
		
		out.design("Selected issuing faction: " .. selected_issuing_faction_name);
		
		-- select an enemy to target
		local enemies = selected_issuing_faction:factions_at_war_with();
		
		-- filter out any factions that are dead or have no armies
		--or is good faction
		local filtered_enemies = {};
		
		for j = 0, enemies:num_items() - 1 do
			local current_enemy = enemies:item_at(j);
			
			if not current_enemy:is_dead() and not current_enemy:military_force_list():is_empty() and not current_enemy:has_effect_bundle("wh3_main_bundle_realm_factions") and not current_enemy:has_effect_bundle("wh3_main_bundle_rift_factions") and not rhox_grudgebringer_good_culture[current_enemy:culture()] then
				table.insert(filtered_enemies, current_enemy);
			end;
		end;
		
		local selected_enemy = false;
		
		if #filtered_enemies == 0 then
			-- the issuer has no enemies, get the faction with the lowest relations instead
			local lowest_relation = 1000;
			
			for j = 0, selected_issuing_faction:factions_met():num_items() - 1 do
				local current_faction_met = selected_issuing_faction:factions_met():item_at(j);
				
				-- filter out any human, dead or vassal/master factions
				if not current_faction_met:is_human() and not current_faction_met:is_dead() and not current_faction_met:has_effect_bundle("wh3_main_bundle_realm_factions") and not current_faction_met:has_effect_bundle("wh3_main_bundle_rift_factions") and not selected_issuing_faction:is_vassal_of(current_faction_met) and not current_faction_met:is_vassal_of(selected_issuing_faction) and not rhox_grudgebringer_good_culture[current_faction_met:culture()] then
					local current_faction_relation = selected_issuing_faction:diplomatic_attitude_towards(current_faction_met:name());
					
					if current_faction_relation < lowest_relation then
						selected_enemy = current_faction_met;
						lowest_relation = current_faction_relation;
					end;
				end;
			end;
		else
			-- the issuer has at least one enemy, get a random enemy
			selected_enemy = filtered_enemies[cm:random_number(#filtered_enemies)];
		end;
		
		if not selected_enemy then
			script_error("Could not find an enemy to target a contract at. This should not be possible?");
			break;
		end;
		
		out.design("\tSelected enemy is: " .. selected_enemy:name());
		
		local mission_index = 1;
		
		-- if the enemy has regions, allow those missions to be used too
		if not selected_enemy:region_list():is_empty() then
			mission_index = cm:random_number(#mission_types);
		end;
		
		local selected_mission = mission_types[mission_index];
		
		out.design("\tSelected mission is " .. selected_mission[1]);
		
		local obj_str = false;
		
		if selected_mission[1] == "KILL_CHARACTER_BY_ANY_MEANS" then
			-- get the closest general to the player, ensuring the same general is not used by the same issuer more than once
			local mf_list = selected_enemy:military_force_list();
			local valid_generals = {};
			
			-- build a table of valid generals before selecting one
			for j = 0, mf_list:num_items() - 1 do
				local current_mf = mf_list:item_at(j);
				local current_mf_force_type = current_mf:force_type():key();
				
				if not current_mf:is_armed_citizenry() and current_mf:has_general() and current_mf_force_type ~= "DISCIPLE_ARMY" and current_mf_force_type ~= "OGRE_CAMP" and current_mf_force_type ~= "CARAVAN" then
					local general_character = current_mf:general_character();
					
					if general_character:has_region() then
						local current_mf_general_cqi = general_character:family_member():command_queue_index();
						
						-- check if this general has already been selected by the same issuer
						if not used_general_targets[selected_issuing_faction_name .. current_mf_general_cqi] then
							table.insert(valid_generals, current_mf_general_cqi);
						end;
					end;
				end;
			end;
			
			local closest_distance = 500000;
			local chosen_general_cqi = false;
			
			for j = 1, #valid_generals do
				local current_general_fm = cm:get_family_member_by_cqi(valid_generals[j])
				
				if current_general_fm then
					local current_general = current_general_fm:character();
					
					if not current_general:is_null_interface() then
						local distance = distance_squared(current_general:logical_position_x(), current_general:logical_position_y(), faction_pos_x, faction_pos_y);
						
						if distance < closest_distance then
							chosen_general_cqi = valid_generals[j];
							closest_distance = distance;
						end;
					end;
				end;
			end;
			
			if chosen_general_cqi then
				used_general_targets[selected_issuing_faction_name .. chosen_general_cqi] = true;
				
				obj_str = "family_member " .. chosen_general_cqi;
			end;
		else
			-- get the closest region to the player, ensuring the same region is not used by the same issuer more than once
			local closest_distance = 500000;
			local region_list = selected_enemy:region_list();
			local chosen_region_key = "";
			
			for j = 0, region_list:num_items() - 1 do
				local current_region = region_list:item_at(j);
				local current_region_key = current_region:name();
				local current_settlement = current_region:settlement();
				
				if not used_region_targets[selected_issuing_faction_name .. current_region_key] then
					local distance = distance_squared(current_settlement:logical_position_x(), current_settlement:logical_position_y(), faction_pos_x, faction_pos_y);
					
					if distance < closest_distance then
						chosen_region_key = current_region_key;
						closest_distance = distance;
					end;
				end;
			end;
			
			if chosen_region_key ~= "" then
				used_region_targets[selected_issuing_faction_name .. chosen_region_key] = true;
				
				obj_str = "region " .. chosen_region_key;
				
				if selected_mission[1] == "RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING" then
					obj_str = obj_str .. ";total 1";
				end;
			end;
		end;
		
		if obj_str then
			trigger_incident = true;
			
			local mod = 1 + (faction:bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
			
			local money = math.max(math.floor(selected_issuing_faction:treasury() / 5), 1500) * mod;
			
			local culture = culture_mapping[selected_enemy:culture()] or "gen";
			
			local payload = "money " .. money .. ";" ..
							"diplomacy_change{" ..
								"target_faction " .. selected_issuing_faction_name .. ";" ..
								"attitude_adjustement 6;" ..
							"}";
			
			-- add bonus payloads
			local random_payload = cm:random_number(2); --was 3 but 2 because grudgebringer does not use meat
			
			if random_payload == 1 then
				payload = payload .. "effect_bundle {bundle_key wh_main_payload_morale_army;turns 10;}";
			elseif random_payload == 2 then
				payload = payload .. "add_ancillary_to_faction_pool {ancillary_key " .. get_random_ancillary_key_for_faction(faction_key, nil, "rare") .. ";}";
			else --will never reach here
			end;
			
			if rhox_is_missed_ror_in_the_table() and cm:model():random_percent(rhox_missing_ror_chance_contract) then --20%
                out("Rhox Grudge Contract: I'm giving RoR as a reward")
                local effect_bundle_key, ancillary_key = rhox_get_missing_ror_bundle()
                payload = payload .. "effect_bundle {bundle_key "..effect_bundle_key..";turns 2;}";                
            end
			
			cm:add_custom_pending_mission_from_string(
				faction,
				selected_issuing_faction,
				"mission{" ..
					"key " .. selected_mission[2] .. "_" .. culture .. "; " ..
					"issuer CLAN_ELDERS;" ..
					"primary_objectives_and_payload{" ..
						"objective{" ..
							"type " .. selected_mission[1] .. ";" .. obj_str .. ";" ..
						"}" ..
						"payload{" ..
							payload ..
						"}" ..
					"}" ..
				"}"
			);
		end;
	end;
	
	cm:set_saved_value("ogre_contracts_used_general_targets", used_general_targets);
	cm:set_saved_value("ogre_contracts_used_region_targets", used_region_targets);
	
	if trigger_incident then
		cm:trigger_incident(faction_key, "wh3_main_incident_ogr_contracts_available", true);
	end;
	
	-- Send successful event with faction key.
	core:trigger_event("ScriptEventOgreContractsIssued", faction_key)

	cm:add_turn_countdown_event(faction_key, 1, "ScriptEventClearOgreContracts", faction_key);
	
	rhox_reset_contracts_timer(faction_key);
end;


cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_mission_issued", mission_issued, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			mission_issued = cm:load_named_value("rhox_mission_issued", mission_issued, context)
		end
	end
)
