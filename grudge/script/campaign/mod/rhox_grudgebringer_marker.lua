local marker_spawn_chance = 75
local camp_spawn_distance = 15
local marker_available_duration = 3;
local marker_cooldown = 4

local marker_cooldown_count = 0


local grudge_marker_key = "grudgebringer_mark"

local grudgebringer_random_encounter_marker = nil --this will act as a marker

local force_to_faction_name ={
    ["ovn_gru_skaven_force"]="wh2_dlc13_skv_skaven_invasion",
    ["ovn_gru_greenskin_force"]="wh2_dlc13_grn_greenskins_invasion",
    ["ovn_gru_vamp_coast_force"]="wh2_dlc11_cst_vampire_coast_encounters",
    ["ovn_gru_norsca_force"]="wh2_dlc13_nor_norsca_invasion",
    ["ovn_gru_human_force"]="wh_main_emp_empire_qb1",
    ["ovn_gru_chaos_force"]="wh_main_chs_chaos_qb1",
    ["ovn_gru_beastmen_force"]="wh2_dlc13_bst_beastmen_invasion",
    ["ovn_gru_dark_elves_force"]="wh2_main_def_dark_elves_qb1",
    ["ovn_gru_ogre_force"]="wh3_main_ogr_ogre_kingdoms_qb1",
    ["ovn_gru_khorne_force"]="wh3_main_kho_khorne_qb1",
    ["ovn_gru_nurgle_force"]="wh3_main_nur_nurgle_qb1",
    ["ovn_gru_tzeentch_force"]="wh3_main_tze_tzeentch_qb1",
    ["ovn_gru_slaanesh_force"]="wh3_main_sla_slaanesh_qb1",
    ["ovn_gru_undead_force"]="wh_main_vmp_vampire_counts_qb1",
    ["ovn_gru_troll_force"]="ovn_troll_gobblers",
    ["ovn_gru_chorf_force"]="wh3_dlc23_chd_chaos_dwarfs_qb1",
    ["ovn_gru_slayer_force"]="wh_main_dwf_dwarfs_qb1"
}

local rhox_grudgebringer_reinforcements_list ={
    ["wh2_main_hef_high_elves"] = "ovn_gru_hef_force",
    ["wh3_main_cth_cathay"] = "ovn_gru_cth_force",
    ["wh3_main_ksl_kislev"] = "ovn_gru_ksl_force",
    ["wh_dlc05_wef_wood_elves"] = "ovn_gru_wef_force",
    ["wh_main_brt_bretonnia"] = "ovn_gru_brt_force",
    ["wh_main_dwf_dwarfs"] = "ovn_gru_dwf_force",
    ["wh_main_emp_empire"] = "ovn_gru_emp_force",
    ["mixer_teb_southern_realms"] = "ovn_gru_teb_force",
    ["ovn_albion"]="ovn_gru_albion_force",
}    

local ovn_random_name_prefix="ovn_grudge_random_faction_name_"

local faction_key_to_random_faction_name={
    wh2_dlc13_skv_skaven_invasion = 5,
    wh2_dlc13_grn_greenskins_invasion = 3,
    wh2_dlc11_cst_vampire_coast_encounters = 3,
    wh2_dlc13_nor_norsca_invasion = 3,
    wh_main_emp_empire_qb1 = 5,
    wh_main_chs_chaos_qb1 = 3,
    wh2_dlc13_bst_beastmen_invasion = 3,
    wh2_main_def_dark_elves_qb1 = 3,
    wh3_main_ogr_ogre_kingdoms_qb1 = 3,
    wh3_main_kho_khorne_qb1 = 3,
    wh3_main_nur_nurgle_qb1 = 3,
    wh3_main_tze_tzeentch_qb1 = 2,
    wh3_main_sla_slaanesh_qb1 = 2,
    wh_main_vmp_vampire_counts_qb1 = 5,
    ovn_troll_gobblers = 1,
    wh3_dlc23_chd_chaos_dwarfs_qb1 = 3,
    wh_main_dwf_dwarfs_qb1 = 1
}

--Events

local event_table = {
	
	["MarkerBattleA"] = 
	--rescue noble
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleA".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 3;
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and RHOX_GRUDGEBRINGER_GOOD_CULTURE[enemy_faction:culture()] then --there must be a noble, right? So the chance goes up as the controller is of good culture
            out("Rhox Grudge: This region is owned by good faction adding probability")
            probability = probability+5
		end
		
		

		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleA action called")
		local dilemma_name = "rhox_grudgebringer_battle_a";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_a", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                false,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        
        local target_region_interface = cm:get_region(target_region)
        if target_region_interface:owning_faction() and RHOX_GRUDGEBRINGER_GOOD_CULTURE[target_region_interface:owning_faction():culture()] then
            local diplo_mod = 1 + math.floor(character:faction():bonus_values():scripted_value("rhox_grudge_contracts_diplo_payload_modifier", "value") / 100); --diplomatic_attitude_adjustment are using 1~6 value you have to use /100
            payload_builder:diplomatic_attitude_adjustment(target_region_interface:owning_faction(), diplo_mod)
        end
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 5000 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction()); --this is to give time to create the army
        
        
	end,
	true},
	
	["MarkerBattleB"] = 
	--protect caravan
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleB".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 6;
		
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and RHOX_GRUDGEBRINGER_GOOD_CULTURE[enemy_faction:culture()] then --It's a caravan protection, chance of this goes up as this region is owned by not good guys
            out("Rhox Grudge: This region is owned by good faction, lower the probability")
            probability = probability-3
		end
		

		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleB action called")
		local dilemma_name = "rhox_grudgebringer_battle_b";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_b", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                false,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        local target_region_interface = cm:get_region(target_region)
        if target_region_interface:owning_faction() and RHOX_GRUDGEBRINGER_GOOD_CULTURE[target_region_interface:owning_faction():culture()] then
            local diplo_mod = 1 + math.floor(character:faction():bonus_values():scripted_value("rhox_grudge_contracts_diplo_payload_modifier", "value") / 100); --diplomatic_attitude_adjustment are using 1~6 value you have to use /100
            payload_builder:diplomatic_attitude_adjustment(target_region_interface:owning_faction(), diplo_mod)
        end
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 4000 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkerBattleC"] = 
	--defend village
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleC".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 3;
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and RHOX_GRUDGEBRINGER_GOOD_CULTURE[enemy_faction:culture()] then --chace goes up if this region belongs to the good culture
            out("Rhox Grudge: This region is owned by good faction adding probability")
            probability = probability+3
		end
		
		

		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleC action called")
		local dilemma_name = "rhox_grudgebringer_battle_c";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_c", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                false,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        local target_region_interface = cm:get_region(target_region)
        if target_region_interface:owning_faction() and RHOX_GRUDGEBRINGER_GOOD_CULTURE[target_region_interface:owning_faction():culture()] then
            local diplo_mod = 1 + math.floor(character:faction():bonus_values():scripted_value("rhox_grudge_contracts_diplo_payload_modifier", "value") / 100); --diplomatic_attitude_adjustment are using 1~6 value you have to use /100
            payload_builder:diplomatic_attitude_adjustment(target_region_interface:owning_faction(), diplo_mod)
        end
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 2000 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkerBattleD"] = 
	--clear infestation
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleD".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 6;
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and RHOX_GRUDGEBRINGER_GOOD_CULTURE[enemy_faction:culture()] then --chance goes up if good culture owns it. Local population
            out("Rhox Grudge: This region is owned by good faction adding probability")
            probability = probability+3
		end
		

		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleD action called")
		local dilemma_name = "rhox_grudgebringer_battle_d";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_d", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                false,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        local target_region_interface = cm:get_region(target_region)
        if target_region_interface:owning_faction() and RHOX_GRUDGEBRINGER_GOOD_CULTURE[target_region_interface:owning_faction():culture()] then
            local diplo_mod = 1 + math.floor(character:faction():bonus_values():scripted_value("rhox_grudge_contracts_diplo_payload_modifier", "value") / 100); --diplomatic_attitude_adjustment are using 1~6 value you have to use /100
            payload_builder:diplomatic_attitude_adjustment(target_region_interface:owning_faction(), diplo_mod)
        end
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 3000 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkerBattleE"] = 
	--take back the fortification
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleE".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 0;
		--local probability = 900;
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and RHOX_GRUDGEBRINGER_GOOD_CULTURE[enemy_faction:culture()] and player_faction:at_war_with(enemy_faction) ==false then --local fortification, you need reinforcements so it'll be zero chance unless it's owned by a good faction.
            out("Rhox Grudge: This region is owned by good faction adding probability")
            probability = probability+3
		end
		

		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleE action called")
		local dilemma_name = "rhox_grudgebringer_battle_e";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_e", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                false,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        local target_region_interface = cm:get_region(target_region)
        if target_region_interface:owning_faction() and RHOX_GRUDGEBRINGER_GOOD_CULTURE[target_region_interface:owning_faction():culture()] then
            local diplo_mod = 1 + math.floor(character:faction():bonus_values():scripted_value("rhox_grudge_contracts_diplo_payload_modifier", "value") / 100); --diplomatic_attitude_adjustment are using 1~6 value you have to use /100
            payload_builder:diplomatic_attitude_adjustment(target_region_interface:owning_faction(), diplo_mod)
        end
        
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 3000 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkerBattleF"] = 
	--help wizard
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleF".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 0;
		--local probability = 600;
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and RHOX_GRUDGEBRINGER_GOOD_CULTURE[enemy_faction:culture()] and player_faction:at_war_with(enemy_faction) ==false then --this faction is going to get a Empire wizard
            out("Rhox Grudge: This region is owned by Good guys, adding probability")
            probability = probability+3
		end
		
		

		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleF action called")
		local dilemma_name = "rhox_grudgebringer_battle_f";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_f", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                false,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        local target_region_interface = cm:get_region(target_region)
        if target_region_interface:owning_faction() and RHOX_GRUDGEBRINGER_GOOD_CULTURE[target_region_interface:owning_faction():culture()] then
            local diplo_mod = 1 + math.floor(character:faction():bonus_values():scripted_value("rhox_grudge_contracts_diplo_payload_modifier", "value") / 100); --diplomatic_attitude_adjustment are using 1~6 value you have to use /100
            payload_builder:diplomatic_attitude_adjustment(target_region_interface:owning_faction(), diplo_mod)
        end
        
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 4000 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:faction_ancillary_gain(rhox_grudgebringer_get_random_item())
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
        
	end,
	true},
	
	["MarkerBattleG"] = 
	--dragon slayer
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleG".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 0;
		--local probability = 900;
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and RHOX_GRUDGEBRINGER_GOOD_CULTURE[enemy_faction:culture()] and player_faction:at_war_with(enemy_faction) ==false then --you need reinforcements so it'll be zero chance unless it's owned by a good faction.
            out("Rhox Grudge: This region is owned by good faction adding probability")
            probability = probability+3
		end
		

		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleG action called")
		local dilemma_name = "rhox_grudgebringer_battle_g";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_g", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                false,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        local target_region_interface = cm:get_region(target_region)
        if target_region_interface:owning_faction() and RHOX_GRUDGEBRINGER_GOOD_CULTURE[target_region_interface:owning_faction():culture()] then
            local diplo_mod = 1 + math.floor(character:faction():bonus_values():scripted_value("rhox_grudge_contracts_diplo_payload_modifier", "value") / 100); --diplomatic_attitude_adjustment are using 1~6 value you have to use /100
            payload_builder:diplomatic_attitude_adjustment(target_region_interface:owning_faction(), diplo_mod)
        end
        
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 5000 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkerBattleH"] = 
	--relief force
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleH".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 0;
		--local probability = 900;
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and RHOX_GRUDGEBRINGER_GOOD_CULTURE[enemy_faction:culture()] and player_faction:at_war_with(enemy_faction) ==false then --you need reinforcements so it'll be zero chance unless it's owned by a good faction.
            out("Rhox Grudge: This region is owned by good faction adding probability")
            probability = probability+3
		end
		
		
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleH action called")
		local dilemma_name = "rhox_grudgebringer_battle_h";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_h", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                false,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        local target_region_interface = cm:get_region(target_region)
        if target_region_interface:owning_faction() and RHOX_GRUDGEBRINGER_GOOD_CULTURE[target_region_interface:owning_faction():culture()] then
            local diplo_mod = 1 + math.floor(character:faction():bonus_values():scripted_value("rhox_grudge_contracts_diplo_payload_modifier", "value") / 100); --diplomatic_attitude_adjustment are using 1~6 value you have to use /100
            payload_builder:diplomatic_attitude_adjustment(target_region_interface:owning_faction(), diplo_mod)
        end
        
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 3000 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:text_display("rhox_grudgebringer_50_chance_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkerBattleI"] = 
	--capture fugitive
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleI".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 0;
		--local probability = 900;
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and RHOX_GRUDGEBRINGER_GOOD_CULTURE[enemy_faction:culture()] and player_faction:at_war_with(enemy_faction) ==false then --you need reinforcements so it'll be zero chance unless it's owned by a good faction.
            out("Rhox Grudge: This region is owned by good faction adding probability")
            probability = probability+3
		end
		
		
		--probability= 1000000000
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleI action called")
		local dilemma_name = "rhox_grudgebringer_battle_i";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_i", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                false,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        local target_region_interface = cm:get_region(target_region)
        if target_region_interface:owning_faction() and RHOX_GRUDGEBRINGER_GOOD_CULTURE[target_region_interface:owning_faction():culture()] then
            local diplo_mod = 1 + math.floor(character:faction():bonus_values():scripted_value("rhox_grudge_contracts_diplo_payload_modifier", "value") / 100); --diplomatic_attitude_adjustment are using 1~6 value you have to use /100
            payload_builder:diplomatic_attitude_adjustment(target_region_interface:owning_faction(), diplo_mod)
        end
        
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 3000 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkerBattleJ"] = 
	--intercept enemy forces
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleJ".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 0;
		--local probability = 900;
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and RHOX_GRUDGEBRINGER_GOOD_CULTURE[enemy_faction:culture()] and player_faction:at_war_with(enemy_faction) ==false then --you need reinforcements so it'll be zero chance unless it's owned by a good faction.
            out("Rhox Grudge: This region is owned by good faction adding probability")
            probability = probability+3
		end
		
		

		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleJ action called")
		local dilemma_name = "rhox_grudgebringer_battle_j";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_j", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                false,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        local target_region_interface = cm:get_region(target_region)
        if target_region_interface:owning_faction() and RHOX_GRUDGEBRINGER_GOOD_CULTURE[target_region_interface:owning_faction():culture()] then
            local diplo_mod = 1 + math.floor(character:faction():bonus_values():scripted_value("rhox_grudge_contracts_diplo_payload_modifier", "value") / 100); --diplomatic_attitude_adjustment are using 1~6 value you have to use /100
            payload_builder:diplomatic_attitude_adjustment(target_region_interface:owning_faction(), diplo_mod)
        end
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 4000 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkerBattleK"] = 
	--the Skaven Nest
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleK".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 3;
		--local probability = 600
		
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and enemy_faction:culture() == "wh2_main_skv_skaven" then --chance goes up if it's owned by a skaven
            out("Rhox Grudge: This region is owned by Skaven, increase the probability")
            probability = probability+6
        elseif event_region:province():pooled_resource_manager():resource("wh3_main_corruption_skaven") and event_region:province():pooled_resource_manager():resource("wh3_main_corruption_skaven"):value() > 20 then --even it's not owned by Skaven guys, the corruption will make it more likely
            out("Rhox Grudge: This region's Skaven corruption is over 20, increasing the probability")
            probability = probability+4
		end
		

		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleK action called")
		local dilemma_name = "rhox_grudgebringer_battle_k";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_k", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                false,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        local target_region_interface = cm:get_region(target_region)
        if target_region_interface:owning_faction() and RHOX_GRUDGEBRINGER_GOOD_CULTURE[target_region_interface:owning_faction():culture()] then
            local diplo_mod = 1 + math.floor(character:faction():bonus_values():scripted_value("rhox_grudge_contracts_diplo_payload_modifier", "value") / 100); --diplomatic_attitude_adjustment are using 1~6 value you have to use /100
            payload_builder:diplomatic_attitude_adjustment(target_region_interface:owning_faction(), diplo_mod)
        end
        
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 3500 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:faction_ancillary_gain(rhox_grudgebringer_get_random_item())
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkerBattleL"] = 
	--the rising dead
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleL".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 3;
		--local probability = 600
		
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and (enemy_faction:culture() == "wh_main_vmp_vampire_counts" or enemy_faction:culture() == "wh2_dlc11_cst_vampire_coast") then --chance goes up if it's owned by vampire count or vampire coast
            out("Rhox Grudge: This region is owned by Vampire factions, increase the probability")
            probability = probability+6
        elseif event_region:province():pooled_resource_manager():resource("wh3_main_corruption_vampiric") and event_region:province():pooled_resource_manager():resource("wh3_main_corruption_vampiric"):value() > 20 then --even it's not owned by Vapmpire guys, the corruption will make it more likely
            out("Rhox Grudge: This region's vampiric corruption is over 20, increasing the probability")
            probability = probability+4
		end
		

		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleL action called")
		local dilemma_name = "rhox_grudgebringer_battle_l";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_l", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                false,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        local target_region_interface = cm:get_region(target_region)
        if target_region_interface:owning_faction() and RHOX_GRUDGEBRINGER_GOOD_CULTURE[target_region_interface:owning_faction():culture()] then
            local diplo_mod = 1 + math.floor(character:faction():bonus_values():scripted_value("rhox_grudge_contracts_diplo_payload_modifier", "value") / 100); --diplomatic_attitude_adjustment are using 1~6 value you have to use /100
            payload_builder:diplomatic_attitude_adjustment(target_region_interface:owning_faction(), diplo_mod)
        end
        
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 3000 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:faction_ancillary_gain(rhox_grudgebringer_get_random_item())
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkerBattleM"] = 
	--trolls
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleM".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 0;
		
		
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and RHOX_GRUDGEBRINGER_GOOD_CULTURE[enemy_faction:culture()] and player_faction:at_war_with(enemy_faction) ==false then --local fortification, you need reinforcements so it'll be zero chance unless it's owned by a good faction.
            out("Rhox Grudge: This region is owned by good faction adding probability")
            probability = probability+3
		end
		
		
		--probability = 900;
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleM action called")
		local dilemma_name = "rhox_grudgebringer_battle_m";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_m", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                false,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        local target_region_interface = cm:get_region(target_region)
        if target_region_interface:owning_faction() and RHOX_GRUDGEBRINGER_GOOD_CULTURE[target_region_interface:owning_faction():culture()] then
            local diplo_mod = 1 + math.floor(character:faction():bonus_values():scripted_value("rhox_grudge_contracts_diplo_payload_modifier", "value") / 100); --diplomatic_attitude_adjustment are using 1~6 value you have to use /100
            payload_builder:diplomatic_attitude_adjustment(target_region_interface:owning_faction(), diplo_mod)
        end
        
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 3500 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkerBattleN"] = 
	--greenskin camp raid
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleN".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 3;
		--local probability = 600
		
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and enemy_faction:culture() == "wh_main_grn_greenskins" then --chance goes up if it's owned by a Greenskin
            out("Rhox Grudge: This region is owned by Greenskins, increase the probability")
            probability = probability+10
		end
		
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleN action called")
		local dilemma_name = "rhox_grudgebringer_battle_n";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_n", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                false,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        local target_region_interface = cm:get_region(target_region)
        if target_region_interface:owning_faction() and RHOX_GRUDGEBRINGER_GOOD_CULTURE[target_region_interface:owning_faction():culture()] then
            local diplo_mod = 1 + math.floor(character:faction():bonus_values():scripted_value("rhox_grudge_contracts_diplo_payload_modifier", "value") / 100); --diplomatic_attitude_adjustment are using 1~6 value you have to use /100
            payload_builder:diplomatic_attitude_adjustment(target_region_interface:owning_faction(), diplo_mod)
        end
        
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 2500 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:faction_ancillary_gain(rhox_grudgebringer_get_random_item())
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkerBattleO"] = 
	--Giants
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleO".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 0;
		
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and (enemy_faction:culture()=="wh_main_brt_bretonnia" or enemy_faction:culture()=="wh_main_dwf_dwarfs"  or enemy_faction:culture()=="wh_main_emp_empire") then --only for empire, dwarf, bretonnia
            out("Rhox Grudge: This region is owned by Empire, Dwarf, or Bretonnia adding probability")
            probability = probability+3
		end
		

		--probability = 900;
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleO action called")
		local dilemma_name = "rhox_grudgebringer_battle_o";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_o", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                false,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        local target_region_interface = cm:get_region(target_region)
        if target_region_interface:owning_faction() and RHOX_GRUDGEBRINGER_GOOD_CULTURE[target_region_interface:owning_faction():culture()] then
            local diplo_mod = 1 + math.floor(character:faction():bonus_values():scripted_value("rhox_grudge_contracts_diplo_payload_modifier", "value") / 100); --diplomatic_attitude_adjustment are using 1~6 value you have to use /100
            payload_builder:diplomatic_attitude_adjustment(target_region_interface:owning_faction(), diplo_mod)
        end
        
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 6000 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkerBattleP"] = 
	--slayers
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleP".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 3;
		
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and enemy_faction:culture()=="wh_main_dwf_dwarfs" then --Increased probability in Dwarf holding region
            out("Rhox Grudge: This region is owned by Dwarf, adding probability")
            probability = probability+3
		end
		
		if cm:model():turn_number() < 20 then --too harsh on the early turns
            probability = 0
		end

		--probability = 900;
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleP action called")
		local dilemma_name = "rhox_grudgebringer_battle_p";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_p", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                true,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 2000 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkerBattleQ"] = 
	--Human ambush
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleQ".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 3;
		
		
		local player_faction = world_conditions["faction"];

		
		

		--probability = 900;
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleQ action called")
		local dilemma_name = "rhox_grudgebringer_battle_q";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_q", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                true,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 2000 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkerBattleR"] = 
	--Greenskin Ambush
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleR".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 3;
		
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and enemy_faction:culture()=="wh_main_grn_greenskins" then --increased probabiolity in Greenskin's lands
            out("Rhox Grudge: This region is owned by Greenskins, adding probability")
            probability = probability+3
		end
		
		

		--probability = 900;
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleR action called")
		local dilemma_name = "rhox_grudgebringer_battle_r";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_r", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                true,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 2500 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkerBattleS"] = 
	--Vampire Count ambush
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleS".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 3;
		
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and enemy_faction:culture()=="wh_main_vmp_vampire_counts" then --increased probabiolity in Undead lands
            out("Rhox Grudge: This region is owned by Vampire Counts, adding probability")
            probability = probability+3
		end
		
		

		--probability = 900;
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleS action called")
		local dilemma_name = "rhox_grudgebringer_battle_s";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_s", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                true,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 2000 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkerBattleT"] = 
	--Skaven ambush
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerBattleT".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 3;
		
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and enemy_faction:culture()=="wh2_main_skv_skaven" then --increased probabiolity in Skaven's lands
            out("Rhox Grudge: This region is owned by Skavens, adding probability")
            probability = probability+3
		end
		
		

		--probability = 900;
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerBattleT action called")
		local dilemma_name = "rhox_grudgebringer_battle_t";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("battle_t", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                true,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 2000 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	
	
	["MarkerFinalBattle"] = 
	--final battle
	{function(world_conditions)
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		local enemy_faction_name = "nobody"  --default, will cover if there is a region owner
        if enemy_faction then
            enemy_faction_name = event_region:owning_faction():name()
        end
		
        local eventname = "MarkerFinalBattle".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*";
		out("Rhox Grudge: eventname string: "..eventname)
		local probability = 0;
		
		local player_faction = world_conditions["faction"];
		if enemy_faction and RHOX_GRUDGEBRINGER_GOOD_CULTURE[enemy_faction:culture()] and player_faction:at_war_with(enemy_faction) ==false then --you need reinforcements so it'll be zero chance unless it's owned by a good faction.
            out("Rhox Grudge: This region is owned by good faction adding probability")
            probability = probability+1
		end
		
		if cm:model():turn_number() < 50 or cm:get_saved_value("rhox_grudge_final_battle") == true then
            probability = 0 --don't trigger this before turn 50 or do not trigger this again
		end
		

		
		--probability = 900;--temp
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerFinalBattle action called")
		cm:set_saved_value("rhox_grudge_final_battle",true) --to not trigger this again
		local dilemma_name = "rhox_grudgebringer_final_battle";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = rhox_grudgebringer_read_out_event_params(event_conditions,3);
		
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local attacking_force, target_force_name = rhox_grudgebringer_generate_attackers("final_battle", character:military_force())  --we're not going to use bandit threat
		enemy_faction = force_to_faction_name[target_force_name]
		out("Rhox Grudge: force name: "..target_force_name)
		out("Rhox Grudge: Enemy faction name: "..enemy_faction)
		

        local enemy_cqi = rhox_grudgebringer_attach_battle_to_dilemma(
                                                dilemma_name,
                                                character,
                                                attacking_force,
                                                false,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        --Trigger dilemma to be handled by aboove function
        local faction_cqi = character:faction():command_queue_index();
        local settlement_target = cm:get_region(target_region):settlement();
        
        out.design("Triggering dilemma:"..dilemma_name)
            
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        
        local target_region_interface = cm:get_region(target_region)
        if target_region_interface:owning_faction() and RHOX_GRUDGEBRINGER_GOOD_CULTURE[target_region_interface:owning_faction():culture()] then
            local diplo_mod = 1 + math.floor(character:faction():bonus_values():scripted_value("rhox_grudge_contracts_diplo_payload_modifier", "value") / 100); --diplomatic_attitude_adjustment are using 1~6 value you have to use /100
            payload_builder:diplomatic_attitude_adjustment(target_region_interface:owning_faction(), diplo_mod)
        end
        
        
        local mod = 1 + (character:faction():bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100);
        local money = 4000 * mod;
        
        payload_builder:treasury_adjustment(money);
        payload_builder:text_display("rhox_grudgebringer_declare_war_payload")
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", character:military_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
	end,
	true},
	
	["MarkermarketA"] = 
	--trader market
	{function(world_conditions)
		
		local eventname = "MarkermarketA".."?";
		local turn_number = cm:turn_number();
		
		local probability = 2
		--local probability = 600
		
		local player_faction = world_conditions["faction"];
		
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		
		
		if enemy_faction and RHOX_GRUDGEBRINGER_GOOD_CULTURE[enemy_faction:culture()] then --increase chance of meeting merchant when hold by good culture
            out("Rhox Grudge: This region is owned by good faction adding probability")
            probability = probability+3
		end
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkermarketA action called")
		local dilemma_name = "rhox_grudgebringer_market_a";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode

		rhox_grudgebringer_attach_battle_to_dilemma(
					dilemma_name,
					character,
					nil,
					false,
					nil,
					nil,
					nil,
					nil);
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();

		local mod = 1 + (character:faction():bonus_values():scripted_value("rhox_grudge_market_price_modifier", "value") / 100);
		
		payload_builder:faction_ancillary_gain(rhox_grudgebringer_get_random_item())
		payload_builder:treasury_adjustment(-1*math.floor(cm:random_number(1250, 750)*mod));
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear();

		payload_builder:faction_ancillary_gain(rhox_grudgebringer_get_random_item())
		payload_builder:treasury_adjustment(-1*math.floor(cm:random_number(1250, 750)*mod));
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		payload_builder:clear();
		
		payload_builder:faction_ancillary_gain(rhox_grudgebringer_get_random_item())
		payload_builder:treasury_adjustment(-1*math.floor(cm:random_number(1250, 750)*mod));
		dilemma_builder:add_choice_payload("THIRD", payload_builder);
		payload_builder:clear();
		
		dilemma_builder:add_choice_payload("FOURTH", payload_builder);
		payload_builder:clear();
		
		dilemma_builder:add_target("default", character:military_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
		
	end,
	false},
	
	["MarkermarketB"] = 
	--caravan market
	{function(world_conditions)
		
		local eventname = "MarkermarketB".."?";
		local turn_number = cm:turn_number();
		
		local probability = 2
		--local probability = 600
		
		local player_faction = world_conditions["faction"];
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		
		
		if enemy_faction and RHOX_GRUDGEBRINGER_GOOD_CULTURE[enemy_faction:culture()] then --increase chance of meeting merchant when hold by good culture
            out("Rhox Grudge: This region is owned by good faction adding probability")
            probability = probability+3
		end
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkermarketB action called")
		local dilemma_name = "rhox_grudgebringer_market_b";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode
		
		rhox_grudgebringer_attach_battle_to_dilemma(
					dilemma_name,
					character,
					nil,
					false,
					nil,
					nil,
					nil,
					nil);
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();

		local mod = 1 + (character:faction():bonus_values():scripted_value("rhox_grudge_market_price_modifier", "value") / 100);
		
		payload_builder:faction_ancillary_gain(rhox_grudgebringer_get_random_item())
		payload_builder:treasury_adjustment(-1*math.floor(cm:random_number(1250, 750)*mod));
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear();

		payload_builder:faction_ancillary_gain(rhox_grudgebringer_get_random_item())
		payload_builder:treasury_adjustment(-1*math.floor(cm:random_number(1250, 750)*mod));
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		payload_builder:clear();
		
		payload_builder:faction_ancillary_gain(rhox_grudgebringer_get_random_item())
		payload_builder:treasury_adjustment(-1*math.floor(cm:random_number(1250, 750)*mod));
		dilemma_builder:add_choice_payload("THIRD", payload_builder);
		payload_builder:clear();
		
		dilemma_builder:add_choice_payload("FOURTH", payload_builder);
		payload_builder:clear();
		
		dilemma_builder:add_target("default", character:military_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
		
	end,
	false},
	
	["MarkermarketC"] = 
	--trading outpost market
	{function(world_conditions)
		
		local eventname = "MarkermarketC".."?";
		local turn_number = cm:turn_number();
		
		local probability = 2
		--local probability = 600
		
		local player_faction = world_conditions["faction"];
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();   --think of it as a local faction holder
		
		
		if enemy_faction and RHOX_GRUDGEBRINGER_GOOD_CULTURE[enemy_faction:culture()] then --increase chance of meeting merchant when hold by good culture
            out("Rhox Grudge: This region is owned by good faction adding probability")
            probability = probability+3
		end
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkermarketC action called")
		local dilemma_name = "rhox_grudgebringer_market_c";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode
		
		rhox_grudgebringer_attach_battle_to_dilemma(
					dilemma_name,
					character,
					nil,
					false,
					nil,
					nil,
					nil,
					nil);
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		local mod = 1 + (character:faction():bonus_values():scripted_value("rhox_grudge_market_price_modifier", "value") / 100);
		
		payload_builder:faction_ancillary_gain(rhox_grudgebringer_get_random_item())
		payload_builder:treasury_adjustment(-1*math.floor(cm:random_number(1250, 750)*mod));
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear();

		payload_builder:faction_ancillary_gain(rhox_grudgebringer_get_random_item())
		payload_builder:treasury_adjustment(-1*math.floor(cm:random_number(1250, 750)*mod));
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		payload_builder:clear();
		
		payload_builder:faction_ancillary_gain(rhox_grudgebringer_get_random_item())
		payload_builder:treasury_adjustment(-1*math.floor(cm:random_number(1250, 750)*mod));
		dilemma_builder:add_choice_payload("THIRD", payload_builder);
		payload_builder:clear();
		
		dilemma_builder:add_choice_payload("FOURTH", payload_builder);
		payload_builder:clear();
		
		dilemma_builder:add_target("default", character:military_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
		
	end,
	false},
	
	["MarkerdebtA"] = 
	--trading outpost market
	{function(world_conditions)
		
		local eventname = "MarkerdebtA".."?";
		local turn_number = cm:turn_number();
		
		
		local player_faction = world_conditions["faction"];
		
		local probability = 2
		--local probability = 600
		
		if player_faction:has_effect_bundle("rhox_grudge_debt_money") then
            probability = 0 --you can't take anbother loan if you already have it
		elseif player_faction:treasury() > 15000 then
            probability = 0 --you don't need money if you have too much
        elseif player_faction:treasury() < 2000 then
            probability = probability +20 --you're low on money so you're desperate
		end
		
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,character)
		
		out.design("MarkerdebtA action called")
		local dilemma_name = "rhox_grudgebringer_debt_a";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode
		
		rhox_grudgebringer_attach_battle_to_dilemma(
					dilemma_name,
					character,
					nil,
					false,
					nil,
					nil,
					nil,
					nil);
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();

		
		
		payload_builder:treasury_adjustment(10000);
		
		local debt = cm:create_new_custom_effect_bundle("rhox_grudge_debt_money");
		debt:set_duration(12);

		payload_builder:effect_bundle_to_faction(debt);
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear();

		
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		payload_builder:clear();
		
		dilemma_builder:add_target("default", character:military_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, character:faction());
		
	end,
	false}
	
};


function rhox_grudgebringer_marker_event_handler(context)
	
	--package up some world state
	--generate an event
	local character = context:family_member():character();
	local faction = character:faction();
    local event_region = character:region()
	
	local conditions = {
		["character"]=character,
		["event_region"]=event_region,
		["faction"]=faction
    };
	out("Rhox Grudge: World conditions: ")
	out("Rhox Grudge: character: "..character:character_subtype_key())
	out("Rhox Grudge: event_region: "..event_region:name())
	out("Rhox Grudge: faction: "..faction:name())
	
	out("Rhox Grudge: Call generate event")
	local contextual_event, is_battle = rhox_grudgebringer_generate_event(conditions);
	
	--if battle then waylay
	
	if is_battle == true and contextual_event ~= nil then
		out.design("Generated event "..contextual_event..". for a marker")
	elseif is_battle == false and contextual_event ~= nil then
		out.design("Generated event "..contextual_event)
	elseif is_battle == nil and contextual_event == nil then
		out.design("No event this turn");
	end;
	
	--out("Rhox Grudge contextual_event: "..contextual_event)
	
	local event_key = rhox_grudgebringer_read_out_event_key(contextual_event)
	out("Rhox Grudge event key: "..event_key)
	event_table[event_key][2](contextual_event,character);
end


function rhox_grudgebringer_generate_event(conditions)
	
	--look throught the events table and create a table for weighted roll
	--pick one and return the event name
	local weighted_random_list = {};
	local total_probability = 0;
	local i = 0;
	
	--build table for weighted roll
	for key, val in pairs(event_table) do
		
		i = i + 1;
		
		--Returns the probability of the event 
		local args = val[1](conditions)
		local prob = args[1];
		total_probability = prob + total_probability;
		--Returns the name and target of the event
		local name_args = args[2];
		
		--Returns if a battle is possible from this event
		--i.e. does it need to waylay
		local is_battle = val[3];
		
		out.design("Adding "..name_args.." with probability: "..prob)
		weighted_random_list[i] = {total_probability,name_args,is_battle}

	end
	
	--check all the probabilites until matched
	--local no_event_chance = 25;
	local no_event_chance = 0; --Might be temp might be not. We want events so we can check them
	local random_int = cm:random_number(total_probability + no_event_chance,1);
	local is_battle = nil;
	local contextual_event_name = nil;
	
	out.design("********")
	out.design("Rhox Grudge: Marker Event -> Random number: "..random_int.." out of: "..total_probability)
	out.design("********")
	for j=1,i do
		if weighted_random_list[j][1] >= random_int then
			contextual_event_name = weighted_random_list[j][2];
			is_battle = weighted_random_list[j][3];
			break;
		end
	end
	
	if cm:tol_campaign_key() then
		contextual_event_name = nil;
	end;
	
	return contextual_event_name, is_battle
end;


local function rhox_grudge_clear_marker_forces(reinforcement_general_cqi)
    out("Rhox Grudge: Inside thge clear marker force function")
    cm:disable_event_feed_events(true, "", "", "diplomacy_faction_destroyed");
    
    if reinforcement_general_cqi and not cm:get_character_by_cqi(reinforcement_general_cqi):is_null_interface() then --there was a reinforcement and he is still living.
        out("Rhox Grudge: There was a reinforcement, this is general's CQI: "..reinforcement_general_cqi)
        cm:kill_character_and_commanded_unit(cm:char_lookup_str(reinforcement_general_cqi), true) --remove reinforcements  if there was any. They cause strange problems for AI
    end
    
    for force, faction_key in pairs(force_to_faction_name) do
		if not cm:get_faction(faction_key):is_dead() then
            cm:kill_all_armies_for_faction(cm:get_faction(faction_key));
		end
	end

    cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_faction_destroyed") end, 0.2);
end

function rhox_grudgebringer_attach_battle_to_dilemma(
			dilemma_name,
			character,
			attacking_force,
			is_ambush,
			target_faction,
			enemy_faction,
			target_region,
			custom_option)
	
	--Create the enemy force
	local enemy_force_cqi = nil;
	local reinforcement_general_cqi = nil;
	local x = nil;
	local y = nil;
	
	
	
	if attacking_force ~= nil then
		out.design("Create enemy force")
        enemy_force_cqi, x, y, reinforcement_general_cqi = rhox_grudgebringer_spawn_marker_battle_force(character, attacking_force, target_region, is_ambush, false, enemy_faction, dilemma_name)
	end
	
	function rhox_grudgebringer_marker_dilemma_choice(context)
		local dilemma = context:dilemma();
		local choice = context:choice();
		local faction = context:faction();
		local faction_key = faction:name();
		out.design("Caught a dilemma: "..dilemma);
		out.design("Choice made: "..tostring(choice));
		
		if dilemma == dilemma_name then
			--if battle option is chosen
			core:remove_listener("cth_DilemmaChoiceMadeEvent_"..faction_key);
			
			if choice == 0 and attacking_force ~= nil then
                out.design("Battle option chosen in dilemma "..dilemma_name)
                if dilemma_name =="rhox_grudgebringer_battle_h" and cm:model():random_percent(50) then
                    out("Rhox Grudge: But it avoided battle by a 50% chacne")
                    rhox_grudge_clear_marker_forces(reinforcement_general_cqi)
                else
                    rhox_grudgebringer_create_marker_battle(character, enemy_force_cqi, x, y, is_ambush, reinforcement_general_cqi);
                end
				cm:force_add_trait("character_cqi:"..context:faction():faction_leader():cqi(), "rhox_grudge_local_helper", true, 1); --you helped local people so get a trait
				cm:replenish_action_points("character_cqi:"..context:faction():faction_leader():cqi()) --replenish action points after the battle
            elseif custom_option ~= nil and choice == 1 then
                custom_option();
            elseif attacking_force == nil then
                cm:replenish_action_points("character_cqi:"..context:faction():faction_leader():cqi()) --there wasn't a fight so it was a market, replenish his action points.
            else
                if dilemma_name ~="rhox_grudgebringer_final_battle" then --we don't remove the enemy for the final battle
                    rhox_grudge_clear_marker_forces(reinforcement_general_cqi) --you didn't pick the fight option, so remove the created forces
                end
			end
			
			
			
		
		else
			out.design("Wrong dilemma...");
		end
	end
	
	local faction_key = character:faction():name()

	core:add_listener(
		"cth_DilemmaChoiceMadeEvent_"..faction_key,
		"DilemmaChoiceMadeEvent",
		true,
		function(context)
			rhox_grudgebringer_marker_dilemma_choice(context) 
		end,
		true
	);
	
	return enemy_force_cqi
end;

function rhox_grudgebringer_spawn_marker_battle_force(character, attacking_force, region, is_ambush, immediate_battle, optional_faction, dilemma_name)

	out.design("Battle created");
	
	local enemy_faction = optional_faction or "wh3_main_ogr_ogre_kingdoms_qb1"
	local character_faction = character:faction();
	local enemy_force_cqi = 0;
	local reinforcement_general_cqi = nil;
	--local x,y = find_battle_coords_from_region(character_faction:name(), region);
	local x,y = cm:find_valid_spawn_location_for_character_from_character(enemy_faction, cm:char_lookup_str(character), true, 1)
	--local x,y = cm:find_valid_spawn_location_for_character_from_settlement(enemy_faction, region, false, true, 1)
	
	local reinforcements =false
	local reinforcements_num =2

    local random_pool = faction_key_to_random_faction_name[enemy_faction]
    local random_number_fn = cm:random_number(random_pool, 1)
    local ovn_gru_enemy_faction_name = common.get_localised_string(ovn_random_name_prefix .. tostring(random_number_fn) .. "_" .. enemy_faction)
    cm:change_custom_faction_name(enemy_faction, ovn_gru_enemy_faction_name)
	
	if dilemma_name == "rhox_grudgebringer_battle_e" then 
        reinforcements = true
        reinforcements_num = 2
    elseif dilemma_name == "rhox_grudgebringer_battle_f" then
        reinforcements = true
        reinforcements_num = 1
    elseif dilemma_name == "rhox_grudgebringer_battle_g" then
        reinforcements = true
        reinforcements_num = cm:random_number(3,2)
        cm:change_custom_faction_name("wh2_dlc13_grn_greenskins_invasion", "Khaz Drakk")
    elseif dilemma_name == "rhox_grudgebringer_battle_h" then
        reinforcements = true
        reinforcements_num = cm:random_number(3,2)
    elseif dilemma_name == "rhox_grudgebringer_battle_i" then
        reinforcements = true
        reinforcements_num = cm:random_number(2,1)
    elseif dilemma_name == "rhox_grudgebringer_battle_j" then
        reinforcements = true
        reinforcements_num = cm:random_number(4,3)
    elseif dilemma_name == "rhox_grudgebringer_battle_m" then
        reinforcements = true
        reinforcements_num = cm:random_number(4,3)
    elseif dilemma_name == "rhox_grudgebringer_final_battle" then
        reinforcements = true
        reinforcements_num = 7
	end
	
	local local_faction = cm:get_region(region):owning_faction() --who is going to appear as a reinforcements
	
	if reinforcements == true then --should change this to need reinforcements table
        local reinforcement_army_list = random_army_manager:generate_force(rhox_grudgebringer_reinforcements_list[local_faction:culture()], reinforcements_num, false)
	
        --local new_x, new_y = cm:find_valid_spawn_location_for_character_from_position(local_faction:name(), x, y, true)
        local new_x, new_y = cm:find_valid_spawn_location_for_character_from_character(local_faction:name(), cm:char_lookup_str(character), true, 1)
        --local new_x, new_y = cm:find_valid_spawn_location_for_character_from_settlement(enemy_faction, region, false, true, 1)
        cm:create_force(
            local_faction:name(),
            reinforcement_army_list,
            region,
            new_x,
            new_y,
            true,
            function(char_cqi,force_cqi)
                reinforcement_general_cqi = char_cqi
                if dilemma_name == "rhox_grudgebringer_battle_f" then --need to summon wizard and make him accompany the created force
                    out("Rhox Grudge: Have to create a wizard for the battle")
                    local empire_wizards ={
                        "wh2_pro07_emp_amethyst_wizard",
                        "wh_dlc03_emp_amber_wizard",
                        "wh_dlc05_emp_grey_wizard",
                        "wh_dlc05_emp_jade_wizard",
                        "wh_main_emp_bright_wizard",
                        "wh_main_emp_celestial_wizard",
                        "wh_main_emp_light_wizard"
                    }
                    
                    out("Rhox Grudge: agent type: "..empire_wizards[cm:random_number(#empire_wizards,1)])
                    cm:spawn_agent_at_military_force(local_faction, cm:get_military_force_by_cqi(force_cqi), "wizard", empire_wizards[cm:random_number(#empire_wizards,1)])
                    local agent = cm:get_most_recently_created_character_of_type(local_faction:name(), "wizard")
                    cm:embed_agent_in_force(agent, cm:get_military_force_by_cqi(force_cqi));
                    
                end
            end
        );
	end
	
	
	if dilemma_name == "rhox_grudgebringer_battle_m" then
        --We need specific enemy lord type for this battle
        cm:create_force_with_general(
            enemy_faction,
            attacking_force,
            region,
            x,
            y,
            "general",
            "ovn_grudge_grn_river_troll_hag",
            "","","","", --names
            false,
            function(char_cqi)
                local force_cqi = cm:get_character_by_cqi(char_cqi):military_force():command_queue_index()
                enemy_force_cqi = force_cqi;
                
                cm:disable_event_feed_events(true, "", "", "diplomacy_war_declared");
                cm:force_declare_war(enemy_faction, character_faction:name(), false, false);	
                if reinforcements == true then
                    cm:force_declare_war(enemy_faction, local_faction:name(), false, false);
                end
                cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_war_declared") end, 0.2);
                cm:disable_movement_for_character(cm:char_lookup_str(char_cqi));
                cm:set_force_has_retreated_this_turn(cm:get_military_force_by_cqi(force_cqi));
            end
        );
    elseif dilemma_name == "rhox_grudgebringer_battle_o" then
        --We need specific enemy lord type for this battle
        cm:create_force_with_general(
            enemy_faction,
            attacking_force,
            region,
            x,
            y,
            "general",
            "ovn_grudge_grn_mon_giant_boss",
            "","","","", --names
            false,
            function(char_cqi)
                local force_cqi = cm:get_character_by_cqi(char_cqi):military_force():command_queue_index()
                enemy_force_cqi = force_cqi;
                
                cm:disable_event_feed_events(true, "", "", "diplomacy_war_declared");
                cm:force_declare_war(enemy_faction, character_faction:name(), false, false);	
                if reinforcements == true then
                    cm:force_declare_war(enemy_faction, local_faction:name(), false, false);
                end
                cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_war_declared") end, 0.2);
                cm:disable_movement_for_character(cm:char_lookup_str(char_cqi));
                cm:set_force_has_retreated_this_turn(cm:get_military_force_by_cqi(force_cqi));
                cm:change_custom_faction_name("wh2_dlc13_grn_greenskins_invasion", "Bugman's Bane")
            end
        );
	else
        --spawn enemy army
        cm:create_force(
            enemy_faction,
            attacking_force,
            region,
            x,
            y,
            true,
            function(char_cqi,force_cqi)
                enemy_force_cqi = force_cqi;
                
                cm:disable_event_feed_events(true, "", "", "diplomacy_war_declared");
                cm:force_declare_war(enemy_faction, character_faction:name(), false, false);	
                if reinforcements == true then
                    cm:force_declare_war(enemy_faction, local_faction:name(), false, false);
                end
                cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_war_declared") end, 0.2);
                cm:disable_movement_for_character(cm:char_lookup_str(char_cqi));
                cm:set_force_has_retreated_this_turn(cm:get_military_force_by_cqi(force_cqi));
            end
        );
	end

	
	if immediate_battle == true then
		if cm:is_multiplayer() then
			rhox_grudgebringer_create_marker_battle(character, enemy_force_cqi, x, y, is_ambush, reinforcement_general_cqi)
		else
			cm:trigger_transient_intervention(
				"spawn_marker_battle_force",
				function(inv)
					rhox_grudgebringer_create_marker_battle(character, enemy_force_cqi, x, y, is_ambush, reinforcement_general_cqi)
					inv:complete()
				end
			);
		end
	elseif immediate_battle == false then 
		return enemy_force_cqi, x, y, reinforcement_general_cqi
	end
end


function rhox_grudgebringer_create_marker_battle(character, enemy_force_cqi, x, y, is_ambush, reinforcement_general_cqi)
	--move the carvan here

	local enemy_char = cm:get_character_by_mf_cqi(enemy_force_cqi)
	
	out.design("Attack opportunity:");
	out.design("1 Passed CQI "..tostring(enemy_force_cqi));
	out.design("2 Passed CQI "..tostring(character:command_queue_index()));
	out.design("Ambush: "..tostring(is_ambush));
	
	--add callack to delete enemy force after battle
	local uim = cm:get_campaign_ui_manager();
	uim:override("retreat"):lock(); 
	out.design("Disable retreat button");
	
	--suppress events
	cm:disable_event_feed_events(true, "", "", "diplomacy_faction_destroyed");
	cm:disable_event_feed_events(true, "", "", "character_dies_battle");
	
	
	if is_ambush then --if it's ambush, enemy has to attack the player
        cm:force_attack_of_opportunity(
            enemy_force_cqi, 
            character:military_force():command_queue_index(),
            is_ambush
        );
	else
        cm:force_attack_of_opportunity(
            character:military_force():command_queue_index(),
            enemy_force_cqi, 
            is_ambush
        );
	end
	
	
	
	core:add_listener(
        "rhox_grudgebringer_unlock_retreat_button",
        "CharacterCompletedBattle",
        function(context)
            return context:character() == character or context:character() == enemy_char
        end,
        function(context)
            uim:override("retreat"):unlock() --unlock the retreat button after the battle
            cm:callback(function() rhox_grudge_clear_marker_forces(reinforcement_general_cqi) end, 0.5);--remove any reinforcements or remaining enemies if there is any. No callback will cause crash as it's still in the result panel
        end,
        false
    );
end;

function rhox_grudgebringer_generate_attackers(force_name, military_force)
	
	local difficulty = cm:get_difficulty(false);
	local turn_number = cm:turn_number();
	local upa

    if turn_number > 55 then
        upa = 8
    elseif turn_number  > 35 then
        upa = 6
    elseif turn_number > 18 then
        upa = 4
    else
        upa = 1
    end
	
	out("Rhox grudge: Current diffuiculty: "..tostring(difficulty))
	out("Rhox grudge: Force name: "..force_name)
	
	--return force name so we can figure out who to declare war
	if force_name == "battle_a" then
        force_name = {"ovn_gru_skaven_force", "ovn_gru_greenskin_force", "ovn_gru_vamp_coast_force", "ovn_gru_norsca_force", "ovn_gru_human_force", "ovn_gru_chaos_force", "ovn_gru_beastmen_force", "ovn_gru_dark_elves_force", "ovn_gru_ogre_force", "ovn_gru_khorne_force", "ovn_gru_nurgle_force", "ovn_gru_tzeentch_force", "ovn_gru_slaanesh_force", "ovn_gru_undead_force", "ovn_gru_chorf_force"}
        local target_index = cm:random_number(#force_name,1)
        local enemy_force = force_name[target_index]
        return random_army_manager:generate_force(enemy_force, upa+10, false), enemy_force;  --5000 gold battle, 10 should do it.  
    elseif force_name == "battle_b" then
        force_name = {"ovn_gru_skaven_force", "ovn_gru_greenskin_force", "ovn_gru_vamp_coast_force", "ovn_gru_norsca_force", "ovn_gru_human_force", "ovn_gru_chaos_force", "ovn_gru_beastmen_force", "ovn_gru_dark_elves_force", "ovn_gru_ogre_force", "ovn_gru_khorne_force", "ovn_gru_nurgle_force", "ovn_gru_tzeentch_force", "ovn_gru_slaanesh_force", "ovn_gru_undead_force", "ovn_gru_chorf_force"}
        local target_index = cm:random_number(#force_name,1)
        local enemy_force = force_name[target_index]
        return random_army_manager:generate_force(enemy_force, upa+8, false), enemy_force;  --4000 gold battle, 8 should do it.  
    elseif force_name == "battle_c" then
        force_name = {"ovn_gru_skaven_force", "ovn_gru_greenskin_force", "ovn_gru_vamp_coast_force", "ovn_gru_norsca_force", "ovn_gru_human_force", "ovn_gru_chaos_force", "ovn_gru_beastmen_force", "ovn_gru_dark_elves_force", "ovn_gru_ogre_force", "ovn_gru_khorne_force", "ovn_gru_nurgle_force", "ovn_gru_tzeentch_force", "ovn_gru_slaanesh_force", "ovn_gru_undead_force", "ovn_gru_chorf_force"}
        local target_index = cm:random_number(#force_name,1)
        local enemy_force = force_name[target_index]
        return random_army_manager:generate_force(enemy_force, upa+6, false), enemy_force;  --2000 gold battle, 5 should do it.  
    elseif force_name == "battle_d" then
        force_name = {"ovn_gru_skaven_force", "ovn_gru_greenskin_force", "ovn_gru_vamp_coast_force", "ovn_gru_norsca_force", "ovn_gru_human_force", "ovn_gru_chaos_force", "ovn_gru_beastmen_force", "ovn_gru_dark_elves_force", "ovn_gru_ogre_force", "ovn_gru_khorne_force", "ovn_gru_nurgle_force", "ovn_gru_tzeentch_force", "ovn_gru_slaanesh_force", "ovn_gru_undead_force", "ovn_gru_chorf_force"}
        local target_index = cm:random_number(#force_name,1)
        local enemy_force = force_name[target_index]
        return random_army_manager:generate_force(enemy_force, upa+6, false), enemy_force;  --3000 gold battle, 6 should do it.  
    elseif force_name == "battle_e" then
        force_name = {"ovn_gru_skaven_force", "ovn_gru_greenskin_force", "ovn_gru_vamp_coast_force", "ovn_gru_norsca_force", "ovn_gru_human_force", "ovn_gru_chaos_force", "ovn_gru_beastmen_force", "ovn_gru_dark_elves_force", "ovn_gru_ogre_force", "ovn_gru_khorne_force", "ovn_gru_nurgle_force", "ovn_gru_tzeentch_force", "ovn_gru_slaanesh_force", "ovn_gru_undead_force", "ovn_gru_chorf_force"}
        local target_index = cm:random_number(#force_name,1)
        local enemy_force = force_name[target_index]
        return random_army_manager:generate_force(enemy_force, upa+8, false), enemy_force;  --3000 gold battle, but with reinforcements. 8 should do it.
    elseif force_name == "battle_f" then
        force_name = {"ovn_gru_skaven_force", "ovn_gru_greenskin_force", "ovn_gru_vamp_coast_force", "ovn_gru_norsca_force", "ovn_gru_human_force", "ovn_gru_chaos_force", "ovn_gru_beastmen_force", "ovn_gru_dark_elves_force", "ovn_gru_ogre_force", "ovn_gru_khorne_force", "ovn_gru_nurgle_force", "ovn_gru_tzeentch_force", "ovn_gru_slaanesh_force", "ovn_gru_undead_force", "ovn_gru_chorf_force"}
        local target_index = cm:random_number(#force_name,1)
        local enemy_force = force_name[target_index]
        return random_army_manager:generate_force(enemy_force, upa+10, false), enemy_force;  --4000 gold battle, random ancillary ally reinforcements. 12 should do it
    elseif force_name == "battle_g" then
        local enemy_force = "ovn_gru_dragon_force"
        return random_army_manager:generate_force(enemy_force, upa, false), enemy_force;
    elseif force_name == "battle_h" then
        force_name = {"ovn_gru_skaven_force", "ovn_gru_greenskin_force", "ovn_gru_vamp_coast_force", "ovn_gru_norsca_force", "ovn_gru_human_force", "ovn_gru_chaos_force", "ovn_gru_beastmen_force", "ovn_gru_dark_elves_force", "ovn_gru_ogre_force", "ovn_gru_khorne_force", "ovn_gru_nurgle_force", "ovn_gru_tzeentch_force", "ovn_gru_slaanesh_force", "ovn_gru_undead_force", "ovn_gru_chorf_force"}
        local target_index = cm:random_number(#force_name,1)
        local enemy_force = force_name[target_index]
        return random_army_manager:generate_force(enemy_force, upa+9, false), enemy_force;  --3000 gold battle, 2~3 ally reinforcements. 50% chance to go to battle 10 should do it.
    elseif force_name == "battle_i" then
        force_name = {"ovn_gru_skaven_force", "ovn_gru_greenskin_force", "ovn_gru_vamp_coast_force", "ovn_gru_norsca_force", "ovn_gru_human_force", "ovn_gru_chaos_force", "ovn_gru_beastmen_force", "ovn_gru_dark_elves_force", "ovn_gru_ogre_force", "ovn_gru_khorne_force", "ovn_gru_nurgle_force", "ovn_gru_tzeentch_force", "ovn_gru_slaanesh_force", "ovn_gru_undead_force", "ovn_gru_chorf_force"}
        local target_index = cm:random_number(#force_name,1)
        local enemy_force = force_name[target_index]
        return random_army_manager:generate_force(enemy_force, upa+6, false)..",wh_main_emp_cha_captain_0,wh2_dlc17_emp_inf_prisoners_0,wh2_dlc17_emp_inf_prisoners_0", enemy_force;  --3000 gold battle, but with reinforcements. 8 should do it. 5 random, 3 fixed
    elseif force_name == "battle_j" then
        force_name = {"ovn_gru_skaven_force", "ovn_gru_greenskin_force", "ovn_gru_vamp_coast_force", "ovn_gru_norsca_force", "ovn_gru_human_force", "ovn_gru_chaos_force", "ovn_gru_beastmen_force", "ovn_gru_dark_elves_force", "ovn_gru_ogre_force", "ovn_gru_khorne_force", "ovn_gru_nurgle_force", "ovn_gru_tzeentch_force", "ovn_gru_slaanesh_force", "ovn_gru_undead_force", "ovn_gru_chorf_force"}
        local target_index = cm:random_number(#force_name,1)
        local enemy_force = force_name[target_index]
        return random_army_manager:generate_force(enemy_force, upa+10, false), enemy_force;  --4000 gold battle, with 2~3 ally reinforcements. 10 should do it.
    elseif force_name == "battle_k" then
        local enemy_force = "ovn_gru_skaven_force"
        return random_army_manager:generate_force(enemy_force, upa+10, false), enemy_force;  --3500 gold battle+ancillary 10 should do it.
    elseif force_name == "battle_l" then
        force_name = {"ovn_gru_vamp_coast_force", "ovn_gru_undead_force"}
        local target_index = cm:random_number(#force_name,1)
        local enemy_force = force_name[target_index]
        return random_army_manager:generate_force(enemy_force, upa+9, false), enemy_force;  --3000 gold battl+ancillary 9 should do it.
    elseif force_name == "battle_m" then
        local enemy_force = "ovn_gru_troll_force"
        return random_army_manager:generate_force(enemy_force, upa+6, false).."wh2_dlc15_grn_cha_river_troll_hag_0", enemy_force;
    elseif force_name == "battle_n" then
        local enemy_force = "ovn_gru_greenskin_force"
        return random_army_manager:generate_force(enemy_force, upa+9, false), enemy_force;  --2500 gold battl+ancillary 8 should do it.
    elseif force_name == "battle_o" then
        local enemy_force = "ovn_gru_giant_force"
        return random_army_manager:generate_force(enemy_force, upa+2, false), enemy_force;
    elseif force_name == "battle_p" then
        local enemy_force = "ovn_gru_slayer_force"
        return random_army_manager:generate_force(enemy_force, upa+8, false), enemy_force;
    elseif force_name == "battle_q" then
        local enemy_force = "ovn_gru_human_force"
        return random_army_manager:generate_force(enemy_force, upa+10, false), enemy_force;
    elseif force_name == "battle_r" then
        local enemy_force = "ovn_gru_greenskin_force"
        return random_army_manager:generate_force(enemy_force, upa+10, false), enemy_force;
    elseif force_name == "battle_s" then
        local enemy_force = "ovn_gru_undead_force"
        return random_army_manager:generate_force(enemy_force, upa+10, false), enemy_force;
    elseif force_name == "battle_t" then
        local enemy_force = "ovn_gru_skaven_force"
        return random_army_manager:generate_force(enemy_force, upa+10, false), enemy_force;
    elseif force_name == "final_battle" then
        force_name = {"ovn_gru_skaven_force", "ovn_gru_greenskin_force", "ovn_gru_vamp_coast_force", "ovn_gru_norsca_force", "ovn_gru_human_force", "ovn_gru_chaos_force", "ovn_gru_beastmen_force", "ovn_gru_dark_elves_force", "ovn_gru_ogre_force", "ovn_gru_khorne_force", "ovn_gru_nurgle_force", "ovn_gru_tzeentch_force", "ovn_gru_slaanesh_force", "ovn_gru_undead_force", "ovn_gru_chorf_force"}
        local target_index = cm:random_number(#force_name,1)
        local enemy_force = force_name[target_index]
        return random_army_manager:generate_force(enemy_force, 19, false), enemy_force;  --final battle
    else --failsafe
        force_name = {"ovn_gru_skaven_force", "ovn_gru_greenskin_force", "ovn_gru_vamp_coast_force", "ovn_gru_norsca_force", "ovn_gru_human_force", "ovn_gru_chaos_force", "ovn_gru_beastmen_force", "ovn_gru_dark_elves_force", "ovn_gru_ogre_force", "ovn_gru_khorne_force", "ovn_gru_nurgle_force", "ovn_gru_tzeentch_force", "ovn_gru_slaanesh_force", "ovn_gru_undead_force", "ovn_gru_chorf_force"}
        local target_index = cm:random_number(#force_name,1)
        local enemy_force = force_name[target_index]
        return random_army_manager:generate_force(enemy_force, 5, false), enemy_force;  
	end

end


local function rhox_grudge_bringer_first_marker_setup()

    grudgebringer_random_encounter_marker = Interactive_Marker_Manager:new_marker_type(grudge_marker_key, grudge_marker_key, marker_available_duration, nil, nil, nil, true)  --key, marker_info, opt_duration, opt_radius, opt_faction_filter, opt_subculture_filter, opt_lord_only


    -- Spawn/Despawn events rely on event_feed_message_event records which are bound to campaign groups (hence the numeric codes). These events do not need to be defined explicitly in the database as incidents.
    grudgebringer_random_encounter_marker:add_spawn_event_feed_event(
        "event_feed_strings_text_rhox_grudgebringer_marker_spawn_title",
        "event_feed_strings_text_rhox_grudgebringer_marker_spawn_primary_detail",
        "event_feed_strings_text_rhox_grudgebringer_marker_spawn_secondary_detail",
        3301238)
    grudgebringer_random_encounter_marker:add_despawn_event_feed_event(
        "event_feed_strings_text_rhox_grudgebringer_marker_disappear_title",
        "event_feed_strings_text_rhox_grudgebringer_marker_disappear_primary_detail",
        "event_feed_strings_text_rhox_grudgebringer_marker_disappear_secondary_detail",
        3301239)
    grudgebringer_random_encounter_marker:despawn_on_interaction(true)
end



local function rhox_grudge_bringer_start_marker_setup()
    core:add_listener(
        "rhox_grudge_marker_RoundStart",
        "FactionRoundStart",
        function(context)
            return context:faction():name() == "ovn_emp_grudgebringers" and cm:model():turn_number() > 1 and cm:model():random_percent(marker_spawn_chance) and marker_cooldown_count == 0  --not on the first turn
        end,
        function(context)
            out("Rhox Grudge: Inside the marker generator")
            local faction_leader = context:faction():faction_leader();
            if not faction_leader then
                out("Rhox Grudge: No leader")
                return --grudgebringer is single army so I think chance is low
            end
            
            if faction_leader:is_at_sea() then
                out("Rhox Grudge: Leader is at the sea, not creating the marker")
                return -- don't create counter when he is at the sea
            end
            grudgebringer_random_encounter_marker:spawn_at_region(faction_leader:region():name(), false, false, false, camp_spawn_distance, "ovn_emp_grudgebringers")
            marker_cooldown_count = marker_cooldown
        end,
        true
    )
    
    
    core:add_listener(
        "rhox_grudge_debt_RoundStart",
        "FactionRoundStart",
        function(context)
            return context:faction():name() == "ovn_emp_grudgebringers" and context:faction():bonus_values():scripted_value("rhox_grudge_debt_modifier", "value") < 0
        end,
        function(context)
            local faction = context:faction()
            local amount = context:faction():bonus_values():scripted_value("rhox_grudge_debt_modifier", "value")
            if faction:treasury() > 1000 then
                cm:treasury_mod(faction:name(), amount) --debt repaid, don't have to do anything and the turn will go down
            else
                cm:apply_effect_bundle("rhox_grudge_debt_money", "ovn_emp_grudgebringers",1) --apply it for one more turn
            end
        end,
        true
    )
    
    core:add_listener(
		"rhox_grudgebringer_marker_Cooldown",
		"WorldStartRound",
		true,
		function(context)
            out("Rhox Grudge: Marker cooldown was: "..marker_cooldown_count)
            if marker_cooldown_count > 0 then
                marker_cooldown_count = marker_cooldown_count-1
                out("Rhox Grudge: Marker cooldown is now "..marker_cooldown_count)
            end
		end,
		true
	)
	
	
	
	core:add_listener( --should trigger dilemma here
		"rhox_grudgebringer_marker_AreaEntered",
		"AreaEntered",
		function(context)
            --out("Rhox grudgebringer area key: "..context:area_key())
            --out("Rhox grudgebringer result of a function: "..string.match(context:area_key(),grudge_marker_key))
			return grudge_marker_key == string.match(context:area_key(),grudge_marker_key);
		end,
		function(context)
            out("Rhox grudgebringer: Hi, you entered the area!")
			local character = context:family_member():character();
			if character:is_null_interface() then
				return;
			end;

			local faction = character:faction()
			local faction_key = faction:name()
			local has_military_force = character:has_military_force()

			if not faction:is_human() then --AI can not get dilemmas
				return
			end
			
			if not has_military_force then --lord only event
				return
			end
			
			--cm:remove_interactable_campaign_marker(context:area_key())
            rhox_grudgebringer_marker_event_handler(context) --this will do all the things for dilemma

		end,
		true
	);


end


function rhox_grudgebringer_read_out_event_key(event_string)
	
	t = {}
	s = event_string          --format is "banditAttack?first*second*third*"
	for v in string.gmatch(s, "(%a+)?") do
		table.insert(t, v)
	end
	
	return(t[1])
end;

function rhox_grudgebringer_read_out_event_params(event_string,num_args)
	
	local arg_table = {};
	
	local i = 0;
	for v in string.gmatch(event_string, "[_%w]+*") do
		i=i+1;
		
		local substring = v:sub(1, #v - 1)
		arg_table[i] = substring;
		
	end
	
	return(arg_table)
end;

cm:add_first_tick_callback_new(
    function()
        rhox_grudge_bringer_first_marker_setup()
    end
)

cm:add_first_tick_callback(
	function()
        if cm:get_faction("ovn_emp_grudgebringers"):is_human() then        
            rhox_grudge_bringer_start_marker_setup()
            --setup random armies
            random_army_manager:new_force("ovn_gru_chorf_force");
            random_army_manager:add_unit("ovn_gru_chorf_force", "wh3_dlc23_chd_inf_orc_labourers", 2);
            random_army_manager:add_unit("ovn_gru_chorf_force", "wh3_dlc23_chd_mon_kdaai_fireborn", 2);
            random_army_manager:add_unit("ovn_gru_chorf_force", "wh3_dlc23_chd_inf_hobgoblin_cutthroats", 2);
            random_army_manager:add_unit("ovn_gru_chorf_force", "wh3_dlc23_chd_inf_hobgoblin_archers", 2);
            random_army_manager:add_unit("ovn_gru_chorf_force", "wh3_dlc23_chd_inf_goblin_labourers", 2);
            random_army_manager:add_unit("ovn_gru_chorf_force", "wh3_dlc23_chd_inf_chaos_dwarf_warriors", 2);
            random_army_manager:add_unit("ovn_gru_chorf_force", "wh3_dlc23_chd_inf_chaos_dwarf_warriors_great_weapons", 2);
            random_army_manager:add_unit("ovn_gru_chorf_force", "wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses", 2);
            random_army_manager:add_unit("ovn_gru_chorf_force", "wh3_dlc23_chd_cav_bull_centaurs_axe", 2);
            
            random_army_manager:new_force("ovn_gru_vamp_coast_force");
            random_army_manager:add_unit("ovn_gru_vamp_coast_force", "wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0", 2);
            random_army_manager:add_unit("ovn_gru_vamp_coast_force", "wh2_dlc11_cst_inf_zombie_gunnery_mob_1", 3);
            random_army_manager:add_unit("ovn_gru_vamp_coast_force", "wh2_dlc11_cst_inf_depth_guard_1", 3);
            random_army_manager:add_unit("ovn_gru_vamp_coast_force", "wh2_dlc11_cst_mon_necrofex_colossus_0", 1);
            random_army_manager:add_unit("ovn_gru_vamp_coast_force", "wh2_dlc11_cst_art_carronade", 1);
            random_army_manager:add_unit("ovn_gru_vamp_coast_force", "wh2_dlc11_cst_mon_rotting_leviathan_0", 1);
            random_army_manager:add_unit("ovn_gru_vamp_coast_force", "wh2_dlc11_cst_mon_terrorgheist", 1);
            random_army_manager:add_unit("ovn_gru_vamp_coast_force", "wh2_dlc11_cst_inf_syreens", 1);
            random_army_manager:add_unit("ovn_gru_vamp_coast_force", "wh2_dlc11_cst_inf_depth_guard_0", 1);
            random_army_manager:add_unit("ovn_gru_vamp_coast_force", "wh2_dlc11_cst_inf_deck_gunners_0", 1);
            random_army_manager:add_unit("ovn_gru_vamp_coast_force", "wh2_dlc11_cst_art_carronade", 1);
            random_army_manager:add_unit("ovn_gru_vamp_coast_force", "wh2_dlc11_cst_art_mortar", 1);
            random_army_manager:add_unit("ovn_gru_vamp_coast_force", "wh2_dlc11_cst_mon_mournguls_0", 1);
            random_army_manager:add_unit("ovn_gru_vamp_coast_force", "wh2_dlc11_cst_mon_bloated_corpse_0", 2);
            random_army_manager:add_unit("ovn_gru_vamp_coast_force", "wh2_dlc11_cst_cav_deck_droppers_1", 2);
            random_army_manager:add_unit("ovn_gru_vamp_coast_force", "wh2_dlc11_cst_inf_zombie_deckhands_mob_0", 3);
            random_army_manager:add_unit("ovn_gru_vamp_coast_force", "wh2_dlc11_cst_mon_fell_bats", 2);

            random_army_manager:new_force("ovn_gru_norsca_force");
            random_army_manager:add_unit("ovn_gru_norsca_force", "wh_dlc08_nor_mon_fimir_1", 2);
            random_army_manager:add_unit("ovn_gru_norsca_force", "wh_dlc08_nor_mon_war_mammoth_2", 1);
            random_army_manager:add_unit("ovn_gru_norsca_force", "wh_dlc08_nor_inf_marauder_champions_0", 2);
            random_army_manager:add_unit("ovn_gru_norsca_force", "wh_dlc08_nor_mon_skinwolves_1", 1);
            random_army_manager:add_unit("ovn_gru_norsca_force", "wh_dlc08_nor_art_hellcannon_battery", 1);
            random_army_manager:add_unit("ovn_gru_norsca_force", "wh_dlc08_nor_mon_war_mammoth_1", 1);
            random_army_manager:add_unit("ovn_gru_norsca_force", "wh_main_nor_cav_marauder_horsemen_1", 2);
            random_army_manager:add_unit("ovn_gru_norsca_force", "wh_dlc08_nor_mon_norscan_giant_0", 1);
            random_army_manager:add_unit("ovn_gru_norsca_force", "wh_dlc08_nor_inf_marauder_champions_1", 2);
            random_army_manager:add_unit("ovn_gru_norsca_force", "wh_dlc08_nor_inf_marauder_hunters_0", 1);
            random_army_manager:add_unit("ovn_gru_norsca_force", "wh_dlc08_nor_mon_fimir_0", 2);
            random_army_manager:add_unit("ovn_gru_norsca_force", "wh_dlc08_nor_mon_frost_wyrm_0", 1);
            random_army_manager:add_unit("ovn_gru_norsca_force", "wh_dlc08_nor_mon_norscan_ice_trolls_0", 2);
            random_army_manager:add_unit("ovn_gru_norsca_force", "wh_main_nor_cav_chaos_chariot", 1);
            random_army_manager:add_unit("ovn_gru_norsca_force", "wh_dlc08_nor_inf_marauder_berserkers_0", 1);
            random_army_manager:add_unit("ovn_gru_norsca_force", "wh_main_nor_inf_chaos_marauders_0", 4);

            random_army_manager:new_force("ovn_gru_skaven_force");
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_dlc12_skv_inf_warplock_jezzails_0", 1);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_main_skv_art_plagueclaw_catapult", 2);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_main_skv_inf_stormvermin_0", 2);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_main_skv_inf_stormvermin_1", 2);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_main_skv_art_warp_lightning_cannon", 1);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_main_skv_inf_plague_monk_censer_bearer", 1);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_main_skv_inf_poison_wind_globadiers", 1);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_dlc14_skv_inf_eshin_triads_0", 1);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_main_skv_inf_gutter_runners_1", 1);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_main_skv_inf_night_runners_1", 1);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_main_skv_inf_warpfire_thrower", 1);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_dlc12_skv_inf_ratling_gun_0", 2);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_main_skv_mon_rat_ogres", 2);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_main_skv_veh_doomwheel", 1);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_dlc12_skv_veh_doom_flayer_0", 1);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_main_skv_inf_skavenslaves_0", 4);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_main_skv_inf_skavenslave_slingers_0", 2);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_main_skv_inf_clanrats_1", 3);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_main_skv_inf_clanrat_spearmen_1", 2);
            random_army_manager:add_unit("ovn_gru_skaven_force", "wh2_main_skv_mon_hell_pit_abomination", 1);

            random_army_manager:new_force("ovn_gru_greenskin_force");
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_art_doom_diver_catapult", 1);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_art_goblin_rock_lobber", 1);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_inf_orc_big_uns", 2);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_inf_night_goblin_fanatics", 2);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_mon_arachnarok_spider_0", 1);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_mon_trolls", 1);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_mon_giant", 1);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_cav_forest_goblin_spider_riders_0", 2);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_cav_forest_goblin_spider_riders_1", 1);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_cav_orc_boar_boy_big_uns", 1);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_cav_savage_orc_boar_boy_big_uns", 1);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_cav_goblin_wolf_riders_1", 1);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_dlc06_grn_inf_squig_herd_0", 1);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_dlc06_grn_inf_nasty_skulkers_0", 1);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_inf_night_goblin_archers", 1);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_inf_night_goblins", 1);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_inf_goblin_archers", 1);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_art_goblin_rock_lobber", 1);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_inf_orc_arrer_boyz", 1);
            random_army_manager:add_unit("ovn_gru_greenskin_force", "wh_main_grn_cav_orc_boar_boyz", 1);

            random_army_manager:new_force("ovn_gru_dark_elves_force");
            random_army_manager:add_unit("ovn_gru_dark_elves_force", "wh2_main_def_inf_har_ganeth_executioners_0", 2);
            random_army_manager:add_unit("ovn_gru_dark_elves_force", "wh2_dlc10_def_inf_sisters_of_slaughter", 2);
            random_army_manager:add_unit("ovn_gru_dark_elves_force", "wh2_main_def_inf_darkshards_1", 1);
            random_army_manager:add_unit("ovn_gru_dark_elves_force", "wh2_main_def_art_reaper_bolt_thrower", 1);
            random_army_manager:add_unit("ovn_gru_dark_elves_force", "wh2_main_def_inf_black_ark_corsairs_0", 3);
            random_army_manager:add_unit("ovn_gru_dark_elves_force", "wh2_main_def_inf_black_ark_corsairs_1", 3);
            random_army_manager:add_unit("ovn_gru_dark_elves_force", "wh2_main_def_inf_witch_elves_0", 1);
            random_army_manager:add_unit("ovn_gru_dark_elves_force", "wh2_main_def_inf_harpies", 1);
            random_army_manager:add_unit("ovn_gru_dark_elves_force", "wh2_main_def_inf_shades_2", 1);
            random_army_manager:add_unit("ovn_gru_dark_elves_force", "wh2_main_def_mon_war_hydra", 1);
            random_army_manager:add_unit("ovn_gru_dark_elves_force", "wh2_main_def_inf_black_guard_0", 2);
            random_army_manager:add_unit("ovn_gru_dark_elves_force", "wh2_dlc10_def_cav_doomfire_warlocks_0", 1);
            random_army_manager:add_unit("ovn_gru_dark_elves_force", "wh2_main_def_cav_cold_one_knights_1", 2);
            random_army_manager:add_unit("ovn_gru_dark_elves_force", "wh2_main_def_cav_cold_one_chariot", 1);
            random_army_manager:add_unit("ovn_gru_dark_elves_force", "wh2_main_def_mon_black_dragon", 1);
            random_army_manager:add_unit("ovn_gru_dark_elves_force", "wh2_dlc10_def_mon_kharibdyss_0", 1);
            random_army_manager:add_unit("ovn_gru_dark_elves_force", "wh2_dlc14_def_mon_bloodwrack_medusa_0", 1);

            random_army_manager:new_force("ovn_gru_chaos_force");
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh3_dlc20_chs_inf_chosen_mnur", 3);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh_dlc01_chs_mon_dragon_ogre", 2);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh3_dlc20_chs_inf_chosen_mkho_dualweapons", 2);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh_main_chs_art_hellcannon", 1);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh_dlc01_chs_mon_dragon_ogre_shaggoth", 1);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh_dlc01_chs_mon_trolls_1", 1);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh_dlc01_chs_inf_chosen_0", 2);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh_dlc06_chs_cav_marauder_horsemasters_0", 1);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh3_dlc20_chs_cav_chaos_chariot_msla", 1);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh3_main_kho_cav_gorebeast_chariot", 1);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh3_main_sla_cav_hellstriders_1", 1);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh3_main_tze_cav_doom_knights_0", 1);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh3_dlc20_chs_mon_giant_mnur_ror", 1);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh3_main_nur_mon_spawn_of_nurgle_0_warriors", 2);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh3_dlc20_chs_inf_forsaken_msla", 2);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh_main_chs_inf_chaos_warriors_0", 2);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh3_main_kho_inf_chaos_warriors_0", 2);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh3_dlc20_chs_inf_chaos_warriors_msla_hellscourges", 2);
            random_army_manager:add_unit("ovn_gru_chaos_force", "wh3_dlc20_chs_inf_chaos_warriors_mtze_halberds", 2);

            random_army_manager:new_force("ovn_gru_human_force");
            random_army_manager:add_unit("ovn_gru_human_force", "wh_dlc04_emp_inf_free_company_militia_0", 3);
            random_army_manager:add_unit("ovn_gru_human_force", "wh_main_emp_cav_pistoliers_1", 2);
            random_army_manager:add_unit("ovn_gru_human_force", "wh_main_emp_inf_handgunners", 2);
            random_army_manager:add_unit("ovn_gru_human_force", "wh_main_emp_inf_swordsmen", 2);
            random_army_manager:add_unit("ovn_gru_human_force", "wh_main_emp_art_great_cannon", 1);
            random_army_manager:add_unit("ovn_gru_human_force", "wh_main_emp_art_helstorm_rocket_battery", 1);
            random_army_manager:add_unit("ovn_gru_human_force", "wh_main_emp_art_mortar", 1);
            random_army_manager:add_unit("ovn_gru_human_force", "wh_main_emp_cav_outriders_0", 1);
            random_army_manager:add_unit("ovn_gru_human_force", "wh_main_emp_inf_spearmen_0", 3);
            random_army_manager:add_unit("ovn_gru_human_force", "wh2_dlc13_emp_veh_war_wagon_0", 2);
            random_army_manager:add_unit("ovn_gru_human_force", "wh_main_emp_art_helblaster_volley_gun", 1);
            random_army_manager:add_unit("ovn_gru_human_force", "wh2_dlc13_emp_veh_war_wagon_1", 1);

            random_army_manager:new_force("ovn_gru_beastmen_force")
            random_army_manager:add_unit("ovn_gru_beastmen_force", "wh_dlc03_bst_inf_bestigor_herd_0", 3);
            random_army_manager:add_unit("ovn_gru_beastmen_force", "wh_dlc03_bst_inf_gor_herd_1", 3);
            random_army_manager:add_unit("ovn_gru_beastmen_force", "wh_dlc03_bst_inf_ungor_spearmen_1", 3);
            random_army_manager:add_unit("ovn_gru_beastmen_force", "wh_dlc03_bst_inf_ungor_raiders_0", 3);
            random_army_manager:add_unit("ovn_gru_beastmen_force", "wh_dlc03_bst_inf_minotaurs_0", 2);
            random_army_manager:add_unit("ovn_gru_beastmen_force", "wh_dlc03_bst_inf_cygor_0", 1);
            random_army_manager:add_unit("ovn_gru_beastmen_force", "wh_dlc03_bst_mon_giant_0", 1);
            random_army_manager:add_unit("ovn_gru_beastmen_force", "wh_dlc03_bst_inf_ungor_spearmen_0",	3)
            random_army_manager:add_unit("ovn_gru_beastmen_force", "wh2_dlc17_bst_mon_jabberslythe_0",	2)
            random_army_manager:add_unit("ovn_gru_beastmen_force", "wh2_dlc17_bst_mon_ghorgon_0",	2)
            random_army_manager:add_unit("ovn_gru_beastmen_force", "wh_dlc03_bst_inf_chaos_warhounds_0", 1)
            random_army_manager:add_unit("ovn_gru_beastmen_force", "wh2_dlc17_bst_cav_tuskgor_chariot_0",  1)

            random_army_manager:new_force("ovn_gru_ogre_force");
            random_army_manager:add_unit("ovn_gru_ogre_force", "wh3_main_ogr_inf_maneaters_0", 1);
            random_army_manager:add_unit("ovn_gru_ogre_force", "wh3_main_ogr_cav_mournfang_cavalry_0", 1);
            random_army_manager:add_unit("ovn_gru_ogre_force", "wh3_main_ogr_inf_ogres_0", 1);
            random_army_manager:add_unit("ovn_gru_ogre_force", "wh3_main_ogr_inf_gnoblars_0", 2);
            random_army_manager:add_unit("ovn_gru_ogre_force", "wh3_main_ogr_inf_gnoblars_1", 3);
            random_army_manager:add_unit("ovn_gru_ogre_force", "wh3_main_ogr_veh_gnoblar_scraplauncher_0", 1);
            random_army_manager:add_unit("ovn_gru_ogre_force", "wh3_main_ogr_inf_leadbelchers_0", 1);
            random_army_manager:add_unit("ovn_gru_ogre_force", "wh3_main_ogr_mon_sabretusk_pack_0", 1);

            random_army_manager:new_force("ovn_gru_khorne_force");
            random_army_manager:add_unit("ovn_gru_khorne_force", "wh3_main_kho_inf_bloodletters_0", 3);
            random_army_manager:add_unit("ovn_gru_khorne_force", "wh3_main_kho_inf_chaos_warhounds_0", 3);
            random_army_manager:add_unit("ovn_gru_khorne_force", "wh3_main_kho_cav_gorebeast_chariot", 1);
            random_army_manager:add_unit("ovn_gru_khorne_force", "wh3_main_kho_inf_bloodletters_1", 3);
            random_army_manager:add_unit("ovn_gru_khorne_force", "wh3_main_kho_inf_chaos_furies_0", 2);
            random_army_manager:add_unit("ovn_gru_khorne_force", "wh3_main_kho_mon_khornataurs_0", 1);
            random_army_manager:add_unit("ovn_gru_khorne_force", "wh3_main_kho_cav_bloodcrushers_0", 1);

            random_army_manager:new_force("ovn_gru_nurgle_force");
            random_army_manager:add_unit("ovn_gru_nurgle_force", "wh3_main_nur_inf_plaguebearers_1", 4);
            random_army_manager:add_unit("ovn_gru_nurgle_force", "wh3_main_nur_cav_pox_riders_of_nurgle_0", 4);
            random_army_manager:add_unit("ovn_gru_nurgle_force", "wh3_main_nur_inf_forsaken_0", 2);
            random_army_manager:add_unit("ovn_gru_nurgle_force", "wh3_main_nur_cav_plague_drones_1", 2);
            random_army_manager:add_unit("ovn_gru_nurgle_force", "wh3_main_nur_mon_great_unclean_one_0", 1);
            random_army_manager:add_unit("ovn_gru_nurgle_force", "wh3_main_nur_mon_soul_grinder_0", 1);
            random_army_manager:add_unit("ovn_gru_nurgle_force", "wh3_main_nur_mon_beast_of_nurgle_0", 2);
            random_army_manager:add_unit("ovn_gru_nurgle_force", "wh3_main_nur_inf_plaguebearers_0", 2);
            random_army_manager:add_unit("ovn_gru_nurgle_force", "wh3_main_nur_mon_spawn_of_nurgle_0", 1);
            random_army_manager:add_unit("ovn_gru_nurgle_force", "wh3_main_nur_cav_plague_drones_0", 1);
            random_army_manager:add_unit("ovn_gru_nurgle_force", "wh3_main_nur_inf_nurglings_0", 3);
            random_army_manager:add_unit("ovn_gru_nurgle_force", "wh3_main_nur_mon_plague_toads_0", 2);
            random_army_manager:add_unit("ovn_gru_nurgle_force", "wh3_main_nur_mon_rot_flies_0", 2);

            random_army_manager:new_force("ovn_gru_tzeentch_force");
            random_army_manager:add_unit("ovn_gru_tzeentch_force", "wh3_main_tze_cav_chaos_knights_0", 1);
            random_army_manager:add_unit("ovn_gru_tzeentch_force", "wh3_main_tze_cav_doom_knights_0", 2);
            random_army_manager:add_unit("ovn_gru_tzeentch_force", "wh3_main_tze_inf_chaos_furies_0", 1);
            random_army_manager:add_unit("ovn_gru_tzeentch_force", "wh3_main_tze_inf_forsaken_0", 2);
            random_army_manager:add_unit("ovn_gru_tzeentch_force", "wh3_main_tze_inf_pink_horrors_0", 2);
            random_army_manager:add_unit("ovn_gru_tzeentch_force", "wh3_main_tze_inf_pink_horrors_1", 3);
            random_army_manager:add_unit("ovn_gru_tzeentch_force", "wh3_main_tze_mon_exalted_flamer_0", 1);
            random_army_manager:add_unit("ovn_gru_tzeentch_force", "wh3_main_tze_mon_flamers_0", 2);
            random_army_manager:add_unit("ovn_gru_tzeentch_force", "wh3_main_tze_mon_lord_of_change_0", 1);
            random_army_manager:add_unit("ovn_gru_tzeentch_force", "wh3_main_tze_mon_screamers_0", 1);
            random_army_manager:add_unit("ovn_gru_tzeentch_force", "wh3_main_tze_mon_soul_grinder_0", 1);
            random_army_manager:add_unit("ovn_gru_tzeentch_force", "wh3_main_tze_mon_spawn_of_tzeentch_0", 1);
            random_army_manager:add_unit("ovn_gru_tzeentch_force", "wh3_main_tze_veh_burning_chariot_0", 1);

            random_army_manager:new_force("ovn_gru_slaanesh_force");
            random_army_manager:add_unit("ovn_gru_slaanesh_force", "wh3_main_sla_cav_heartseekers_of_slaanesh_0", 2);
            random_army_manager:add_unit("ovn_gru_slaanesh_force", "wh3_main_sla_cav_hellstriders_0", 1);
            random_army_manager:add_unit("ovn_gru_slaanesh_force", "wh3_main_sla_cav_hellstriders_1", 2);
            random_army_manager:add_unit("ovn_gru_slaanesh_force", "wh3_main_sla_cav_seekers_of_slaanesh_0", 1);
            random_army_manager:add_unit("ovn_gru_slaanesh_force", "wh3_main_sla_inf_daemonette_0", 1);
            random_army_manager:add_unit("ovn_gru_slaanesh_force", "wh3_main_sla_inf_daemonette_1", 2);
            random_army_manager:add_unit("ovn_gru_slaanesh_force", "wh3_main_sla_inf_marauders_2", 2);
            random_army_manager:add_unit("ovn_gru_slaanesh_force", "wh3_main_sla_mon_fiends_of_slaanesh_0", 1);
            random_army_manager:add_unit("ovn_gru_slaanesh_force", "wh3_main_sla_mon_keeper_of_secrets_0", 1);
            random_army_manager:add_unit("ovn_gru_slaanesh_force", "wh3_main_sla_mon_soul_grinder_0", 1);
            random_army_manager:add_unit("ovn_gru_slaanesh_force", "wh3_main_sla_mon_spawn_of_slaanesh_0", 1);
            random_army_manager:add_unit("ovn_gru_slaanesh_force", "wh3_main_sla_veh_exalted_seeker_chariot_0", 1);
            random_army_manager:add_unit("ovn_gru_slaanesh_force", "wh3_main_sla_veh_hellflayer_0", 2);
            random_army_manager:add_unit("ovn_gru_slaanesh_force", "wh3_main_sla_veh_seeker_chariot_0", 1);

            random_army_manager:new_force("ovn_gru_undead_force");
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_main_vmp_cav_black_knights_0", 2);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_main_vmp_inf_cairn_wraiths", 1);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_main_vmp_inf_crypt_ghouls", 2);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_main_vmp_inf_grave_guard_0", 1);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_main_vmp_inf_grave_guard_1", 1);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_main_vmp_mon_crypt_horrors", 2);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_main_vmp_mon_fell_bats", 2);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_main_vmp_inf_zombie", 3);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_main_vmp_inf_skeleton_warriors_0", 3);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_main_vmp_inf_skeleton_warriors_1", 2);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_main_vmp_cav_hexwraiths", 1);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_dlc04_vmp_veh_mortis_engine_0", 1);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_dlc02_vmp_cav_blood_knights_0", 2);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_dlc04_vmp_veh_corpse_cart_1", 1);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh2_dlc11_vmp_inf_crossbowmen", 1);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh2_dlc11_vmp_inf_handgunners", 1);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_main_vmp_mon_terrorgheist", 1);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_main_vmp_mon_vargheists", 1);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_main_vmp_mon_varghulf", 1);
            random_army_manager:add_unit("ovn_gru_undead_force", "wh_main_vmp_mon_dire_wolves", 1);
            
            random_army_manager:new_force("ovn_gru_troll_force");
            random_army_manager:add_unit("ovn_gru_troll_force", "wh2_dlc15_grn_mon_river_trolls_0", 1);
            random_army_manager:add_unit("ovn_gru_troll_force", "wh2_dlc15_grn_mon_stone_trolls_0", 1);
            random_army_manager:add_unit("ovn_gru_troll_force", "wh_main_grn_mon_trolls", 3);

            random_army_manager:new_force("ovn_gru_dragon_force");
            random_army_manager:add_unit("ovn_gru_dragon_force", "wh2_twa03_grn_mon_wyvern_0", 1);

            random_army_manager:new_force("ovn_gru_giant_force");
            random_army_manager:add_unit("ovn_gru_giant_force", "wh_main_grn_mon_giant", 1);

            -- ALLIED REINFORCEMENT ARMIES
            
            random_army_manager:new_force("ovn_gru_hef_force");
            random_army_manager:add_unit("ovn_gru_hef_force", "wh2_main_hef_inf_lothern_sea_guard_1", 1);
            
            random_army_manager:new_force("ovn_gru_cth_force");
            random_army_manager:add_unit("ovn_gru_cth_force", "wh3_main_cth_inf_jade_warriors_1", 2);
            random_army_manager:add_unit("ovn_gru_cth_force", "wh3_main_cth_inf_jade_warrior_crossbowmen_1", 1);
            
            random_army_manager:new_force("ovn_gru_ksl_force");
            random_army_manager:add_unit("ovn_gru_ksl_force", "wh3_main_ksl_inf_armoured_kossars_0", 1);
            
            random_army_manager:new_force("ovn_gru_wef_force");
            random_army_manager:add_unit("ovn_gru_wef_force", "wh_dlc05_wef_inf_deepwood_scouts_0", 1);
            
            random_army_manager:new_force("ovn_gru_brt_force");
            random_army_manager:add_unit("ovn_gru_brt_force", "wh_dlc07_brt_cav_knights_errant_0", 1);
            
            random_army_manager:new_force("ovn_gru_dwf_force");
            random_army_manager:add_unit("ovn_gru_dwf_force", "wh_main_dwf_inf_dwarf_warrior_0", 2);
            random_army_manager:add_unit("ovn_gru_dwf_force", "wh_main_dwf_inf_quarrellers_0", 1);
            
            random_army_manager:new_force("ovn_gru_emp_force");
            random_army_manager:add_unit("ovn_gru_emp_force", "wh_main_emp_inf_halberdiers", 2);
            random_army_manager:add_unit("ovn_gru_emp_force", "wh_main_emp_inf_crossbowmen", 1);
            

            random_army_manager:new_force("ovn_gru_teb_force");
            if vfs.exists("script/frontend/mod/cataph_teb.lua") then
                random_army_manager:add_unit("ovn_gru_teb_force", "teb_pikemen", 2);
                random_army_manager:add_unit("ovn_gru_teb_force", "teb_pavisiers", 1);
            else
                random_army_manager:add_unit("ovn_gru_teb_force", "wh_main_emp_inf_halberdiers", 2);
                random_army_manager:add_unit("ovn_gru_teb_force", "wh_main_emp_inf_crossbowmen", 1);
            end
            
            random_army_manager:new_force("ovn_gru_albion_force");
            if vfs.exists("script/frontend/mod/ovn_albion_frontend.lua") then
                random_army_manager:add_unit("ovn_gru_albion_force", "albion_hearthguard", 2);
                random_army_manager:add_unit("ovn_gru_albion_force", "albion_huntresses", 1);

            else
                random_army_manager:add_unit("ovn_gru_albion_force", "wh_main_emp_inf_halberdiers", 2);
                random_army_manager:add_unit("ovn_gru_albion_force", "wh_main_emp_inf_crossbowmen", 1);
            end
            random_army_manager:new_force("ovn_gru_slayer_force");
            random_army_manager:add_unit("ovn_gru_slayer_force", "wh2_dlc10_dwf_inf_giant_slayers", 1);
            random_army_manager:add_unit("ovn_gru_slayer_force", "wh_dlc06_dwf_inf_dragonback_slayers_0", 1);
            random_army_manager:add_unit("ovn_gru_slayer_force", "wh_main_dwf_inf_slayers", 6);
        end
	end
)

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_grudgebringer_marker_cooldown_count", marker_cooldown_count, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
            marker_cooldown_count = cm:load_named_value("rhox_grudgebringer_marker_cooldown_count", marker_cooldown_count, context)
            if (not cm:is_new_game()) and (not Interactive_Marker_Manager.marker_list[grudge_marker_key]) then
                script_error(string.format("ERROR: This is not a new game, yet there is no '%s' marker in the Marker Manager. Has this script deserialised before Marker Manager? Grudgebringer marker will be broken in your loaded game.",
                    grudge_marker_key))
            else
                grudgebringer_random_encounter_marker = Interactive_Marker_Manager.marker_list[grudge_marker_key]
            end
		end
	end
)