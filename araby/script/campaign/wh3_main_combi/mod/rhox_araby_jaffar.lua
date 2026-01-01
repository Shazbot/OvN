local jaffar_faction_name = "ovn_arb_sultanate_of_all_araby"

local rhox_araby_jaffar_conquer_effect = "";
local rhox_araby_jaffar_conquer_level = 1;

local rhox_araby_jaffar_event_saw ={
    ["araby_united"] =false,
    ["teb_complete"] =false,
    ["bretonnia_foothold"]=false,
    ["bretonnia_complete"]=false
}



local rhox_araby_crusader_factions ={
    "wh2_dlc14_brt_chevaliers_de_lyonesse",
    "wh2_main_brt_knights_of_origo",
    "wh2_main_brt_knights_of_the_flame",
    "wh2_main_brt_thegans_crusaders"
}

local jaffar_remaining_rors={
    "ovn_arb_mon_desert_spirit_ror",
    "ovn_arb_mon_fire_efreet_ror",
    "ovn_arb_mon_sea_nymph_ror",
    "ovn_arb_mon_tempest_djinn_ror"
};



local function rhox_araby_jaffar_conquer_remove_effects()
	local effects = {"teb", "araby", "bretonnia"};
	local faction = cm:get_faction(jaffar_faction_name);
	
	for i = 1, 10 do
		for j = 1, #effects do
			local effect_bundle = "rhox_araby_jaffar_conquer_" .. effects[j] .. "_" .. i;
			
			if faction:has_effect_bundle(effect_bundle) then
				cm:remove_effect_bundle(effect_bundle, jaffar_faction_name);
			end
		end
	end
	effect_bundle = "rhox_araby_jaffar_conquer_complete";
			
    if faction:has_effect_bundle(effect_bundle) then
        cm:remove_effect_bundle(effect_bundle, jaffar_faction_name);
    end
	
end

function rhox_araby_jaffar_check_owner(region) --region interface
    local jaffar_faction =cm:get_faction(jaffar_faction_name)
    if not region:owning_faction() then
        return false
    end
    if region:owning_faction():name() == jaffar_faction_name then 
        return true;
    end
    if region:owning_faction():culture()== "wh_main_brt_bretonnia" then --Jaffar's Revenge will not accept Bretonnia even if they're his vassal
        return false;
    end
    if region:owning_faction():is_ally_vassal_or_client_state_of(jaffar_faction) then
        return true;
    end
    return false; --return false elsewise
end

local function rhox_araby_jaffar_conquer_show_event(event_type)
    if rhox_araby_jaffar_event_saw[event_type] == true then 
        return
    end
    rhox_araby_jaffar_event_saw[event_type] = true;--no need to view same event twice

    local target_index = cm:random_number(#jaffar_remaining_rors, 1)
    out("Rhox Araby: target index and unit name"..target_index.."/"..jaffar_remaining_rors[target_index])
    cm:remove_event_restricted_unit_record_for_faction(jaffar_remaining_rors[target_index], jaffar_faction_name)
    table.remove(jaffar_remaining_rors, target_index)
    
    if event_type == "araby_united" then
        cm:spawn_character_to_pool(jaffar_faction_name, "names_name_3508823269", "", "", "", 18, true, "general", "arb_sheikh_mehmed", true, "");
    end
    
    cm:trigger_incident(jaffar_faction_name, "rhox_araby_jaffar_conquer_incident_"..event_type, true, true);
end


--1: weakest, 10:strongest
local function rhox_araby_jaffar_conquer_update()
    local rhox_araby_jaffar_conquer_regions = {
        ["araby"] = {
    --total 10   --coast, cracked, assassin, and ensure all 4 crusader factions are dead
            ["wh3_main_combi_region_black_tower_of_arkhan"] = false,
            ["wh3_main_combi_region_el_kalabad"] = false,
            ["wh3_main_combi_region_pools_of_despair"] = false,
            ["wh3_main_combi_region_zandri"] = false,
            ["wh3_main_combi_region_al_haikk"] = false,
            ["wh3_main_combi_region_copher"] = false,
            ["wh3_main_combi_region_fyrus"] = false,
            ["wh3_main_combi_region_lashiek"] = false,
            ["wh3_main_combi_region_sorcerers_islands"] = false,
            ["wh3_main_combi_region_wizard_caliphs_palace"] = false
        },
        ["teb"] = {
    --total 10 --pirate's current, tilea, estalia, irrana, blighted
            ["wh3_main_combi_region_sartosa"] = false,
            ["wh3_main_combi_region_luccini"] = false,
            ["wh3_main_combi_region_miragliano"] = false,
            ["wh3_main_combi_region_riffraffa"] = false,
            ["wh3_main_combi_region_magritta"] = false,
            ["wh3_main_combi_region_nuja"] = false,
            ["wh3_main_combi_region_tobaro"] = false,
            ["wh3_main_combi_region_bilbali"] = false,
            ["wh3_main_combi_region_montenas"] = false,
            ["wh3_main_combi_region_skavenblight"] = false
        },
        ["bretonnia"] = {
    --total 15 --carcassonne, chalons, cuileux, brienne, bastonne, arden, lyonesse, couronne
            ["wh3_main_combi_region_brionne"] = false,
            ["wh3_main_combi_region_castle_carcassonne"] = false,
            ["wh3_main_combi_region_parravon"] = false,
            ["wh3_main_combi_region_quenelles"] = false,
            ["wh3_main_combi_region_massif_orcal"] = false,
            ["wh3_main_combi_region_aquitaine"] = false,
            ["wh3_main_combi_region_bordeleaux"] = false,
            ["wh3_main_combi_region_castle_bastonne"] = false,
            ["wh3_main_combi_region_montfort"] = false,
            ["wh3_main_combi_region_castle_artois"] = false,
            ["wh3_main_combi_region_gisoreux"] = false,
            ["wh3_main_combi_region_lyonesse"] = false,
            ["wh3_main_combi_region_mousillon"] = false,
            ["wh3_main_combi_region_couronne"] = false,
            ["wh3_main_combi_region_languille"] = false
        },
        ["araby_taken"] = 0,
        ["teb_taken"] = 0,
        ["bretonnia_taken"] = 0
    }; --let's make it local as we need to reset this every time
	local region_types = {"teb", "araby", "bretonnia"};
	
	-- populate a lookup table of all relevant regions
	rhox_araby_jaffar_conquer_regions["all"] = {};
	
	for i = 1, #region_types do
		for region_key, value in pairs(rhox_araby_jaffar_conquer_regions[region_types[i]]) do
			rhox_araby_jaffar_conquer_regions["all"][region_key] = true;
			local region = cm:get_region(region_key);
			
			if region and region:owning_faction() and rhox_araby_jaffar_check_owner(region) ==true then
				rhox_araby_jaffar_conquer_regions[region_types[i]][region_key] = true;
				rhox_araby_jaffar_conquer_regions[region_types[i].."_taken"] = rhox_araby_jaffar_conquer_regions[region_types[i].."_taken"] + 1;
			end
		end
	end
	
	rhox_araby_jaffar_conquer_remove_effects();
	for i=1,#rhox_araby_crusader_factions do--add the faction annihilated value
        if cm:get_faction(rhox_araby_crusader_factions[i]):is_dead() then
            rhox_araby_jaffar_conquer_regions["araby_taken"] = rhox_araby_jaffar_conquer_regions["araby_taken"]+1
        end
    end
    rhox_araby_jaffar_conquer_regions["araby_taken"] = math.floor(rhox_araby_jaffar_conquer_regions["araby_taken"] *10/14) --10 province, 4 faction. need to apply this.
    
    
    if rhox_araby_jaffar_conquer_regions["araby_taken"] ==0 then
        rhox_araby_jaffar_conquer_regions["araby_taken"] = 1 --you'll at least start from level 1
    end
    
    if rhox_araby_jaffar_conquer_regions["bretonnia_taken"]>1 then
        rhox_araby_jaffar_conquer_regions["bretonnia_taken"] = math.floor(rhox_araby_jaffar_conquer_regions["bretonnia_taken"]*2/3) --it's 15 regions so have to use this to match the number
    end
    
    out("Rhox Araby: Araby taken: "..rhox_araby_jaffar_conquer_regions["araby_taken"])
    out("Rhox Araby: TEB taken: "..rhox_araby_jaffar_conquer_regions["teb_taken"])
    out("Rhox Araby: bretonnia taken: "..rhox_araby_jaffar_conquer_regions["bretonnia_taken"])
    
    if rhox_araby_jaffar_conquer_regions["araby_taken"] < 10 then --if it's smaller than 10, you're getting conquer araby effects
        rhox_araby_jaffar_conquer_effect = "rhox_araby_jaffar_conquer_araby";
        rhox_araby_jaffar_conquer_level = rhox_araby_jaffar_conquer_regions["araby_taken"]
    elseif rhox_araby_jaffar_conquer_regions["teb_taken"] == 0 then  --even you conquered all the araby, you'll get araby effect if you haven't taken the TEB land
        rhox_araby_jaffar_conquer_effect = "rhox_araby_jaffar_conquer_araby";
        rhox_araby_jaffar_conquer_level = rhox_araby_jaffar_conquer_regions["araby_taken"]
    elseif rhox_araby_jaffar_conquer_regions["teb_taken"] < 10 then --TEB effect as you haven't conquer all the TEB
        rhox_araby_jaffar_conquer_effect = "rhox_araby_jaffar_conquer_teb";
        rhox_araby_jaffar_conquer_level = rhox_araby_jaffar_conquer_regions["teb_taken"]
    elseif rhox_araby_jaffar_conquer_regions["bretonnia_taken"] == 0 then --max TEB effect
        rhox_araby_jaffar_conquer_effect = "rhox_araby_jaffar_conquer_teb";
        rhox_araby_jaffar_conquer_level = rhox_araby_jaffar_conquer_regions["teb_taken"]
    elseif rhox_araby_jaffar_conquer_regions["bretonnia_taken"] < 10 then
        rhox_araby_jaffar_conquer_effect = "rhox_araby_jaffar_conquer_bretonnia";
        rhox_araby_jaffar_conquer_level = rhox_araby_jaffar_conquer_regions["bretonnia_taken"]
    else  --it means it's bigger or equal to 10
        rhox_araby_jaffar_conquer_effect = "rhox_araby_jaffar_conquer_complete";
        rhox_araby_jaffar_conquer_level = 0
    end
    
    
    --some onetime event in a loop of ifs
    if rhox_araby_jaffar_conquer_regions["araby_taken"] == 10 then
        rhox_araby_jaffar_conquer_show_event("araby_united")
        if rhox_araby_jaffar_conquer_regions["teb_taken"] == 10 then
            rhox_araby_jaffar_conquer_show_event("teb_complete")
            if rhox_araby_jaffar_conquer_regions["bretonnia_taken"] > 0 then
                rhox_araby_jaffar_conquer_show_event("bretonnia_foothold")
            end
            if rhox_araby_jaffar_conquer_regions["bretonnia_taken"] == 10 then
                rhox_araby_jaffar_conquer_show_event("bretonnia_complete")
            end
        end
    end
    
	
	cm:apply_effect_bundle(rhox_araby_jaffar_conquer_effect .. "_" .. rhox_araby_jaffar_conquer_level, jaffar_faction_name, 0);
end














cm:add_first_tick_callback(
    function()
        out("==== Jaffar faction ====");
        if cm:get_faction(jaffar_faction_name):is_human() then
            cm:add_faction_turn_start_listener_by_name(
                "rhox_araby_jaffar_conquer_update",
                jaffar_faction_name,
                function()
                    rhox_araby_jaffar_conquer_update();
                end,
                true
            );
        elseif cm:model():turn_number()<=50 then
            core:add_listener(
                "rhox_araby_jaffar_ai_mehmed_giver",
                "FactionTurnStart",
                function(context)
                    local faction = context:faction()
                    local turn = cm:model():turn_number();
                    return faction:name() == jaffar_faction_name and turn == 50
                end,
                function(context)
                    cm:spawn_character_to_pool(jaffar_faction_name, "names_name_3508823269", "", "", "", 18, true, "general", "arb_sheikh_mehmed", true, "");
                end,
                true
            );
        end
        
    end
);

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_araby_jaffar_conquer_level", rhox_araby_jaffar_conquer_level, context);
        cm:save_named_value("rhox_araby_jaffar_event_saw", rhox_araby_jaffar_event_saw, context);
        cm:save_named_value("rhox_araby_jaffar_remaining_rors", jaffar_remaining_rors, context);
	end
);

cm:add_loading_game_callback(
	function(context)
        if cm:is_new_game() == false then
            rhox_araby_jaffar_conquer_level = cm:load_named_value("rhox_araby_jaffar_conquer_level", 1, context);
            rhox_araby_jaffar_event_saw = cm:load_named_value("rhox_araby_jaffar_event_saw", rhox_araby_jaffar_event_saw, context);
            jaffar_remaining_rors = cm:load_named_value("rhox_araby_jaffar_remaining_rors", jaffar_remaining_rors, context);
        end
	end
);