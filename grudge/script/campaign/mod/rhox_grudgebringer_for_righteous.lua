local grudgebringer_faction = "ovn_emp_grudgebringers"
local grudgebringer_mission_key = "rhox_grudgebringer_piece_of_eight_"
local skip_mission_sampling_num = 5
local skip_mission_table={}

local grudgebringer_missions ={
   {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        reward = "ragnar_wolves"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        reward = "flagellants_eusebio_the_bleak"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        reward = "azguz_bloodfist_dwarf_warriors"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        reward = "dargrimm_firebeard_dwarf_warriors"
    },
    {--5
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        reward = "urblab_rotgut_mercenary_ogres"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        subculture_key = "wh_main_sc_vmp_vampire_counts",
        count = 5,
        reward = "elrod_wood_elf_glade_guards"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "wh2_dlc11_vmp_the_barrow_legion",
        count = 3,
        reward = "galed_elf_archers"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "wh2_dlc11_vmp_the_barrow_legion",
        count = 2,
        reward = "helmgart_bowmen"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        reward = "keelers_longbows"
    },
    {--10
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        subculture_key = "wh2_main_sc_skv_skaven",
        count = 3,
        reward = "black_avangers"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        subculture_key = "wh_main_sc_grn_greenskins",
        count = 4,
        reward = "carlsson_guard"
    },
    {
        type = "ENGAGE_FORCE",
        faction_key = "wh2_main_skv_skaven_qb1",
        reward = "carlsson_cavalry"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        reward = "vannheim_75th"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        subculture_key = "wh_main_sc_vmp_vampire_counts",
        count = 6,
        reward = "treeman_knarlroot"
    },
    {--15
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        subculture_key = "wh2_main_sc_skv_skaven",
        count = 5,
        reward = "treeman_gnarl_fist"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        reward = "uter_blomkwist_imperial_mortar"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        reward = "countess_guard"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        reward = "dieter_schaeffer_carroburg_greatswords"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        reward = "jurgen_muntz_outlaw_infantry"
    },
    {--20
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        reward = "boris_von_raukov_4th_nuln_halberdiers"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        reward = "stephan_weiss_outlaw_pistoliers"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        reward = "imperial_cannon_darius_flugenheim"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "wh_main_vmp_mousillon",
        count = 2,
        reward = "grail_knights_tristan_de_la_tourtristan_de_la_tour"
    },
    {--24
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "wh2_dlc15_grn_broken_axe",
        count = 2,
        reward = "knights_of_the_realm_bertrand_le_grande"
    }
}

local rhox_failed_mission_rewards ={}

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



local grudgebringer_evil_ll_factions={
    "wh2_dlc15_grn_bonerattlaz",
    "wh_main_grn_crooked_moon",
    "wh_main_grn_greenskins",
    "wh_main_grn_orcs_of_the_bloody_hand",
    "wh_main_vmp_vampire_counts",
    "wh_main_vmp_schwartzhafen",
    "wh3_main_vmp_caravan_of_blue_roses",
    "wh3_dlc20_chs_azazel",
    "wh3_dlc20_chs_festus",
    "wh3_dlc20_chs_kholek",
    "wh3_dlc20_chs_sigvald",
    "wh3_dlc20_chs_valkia",
    "wh3_main_chs_shadow_legion",
    "wh3_dlc20_chs_vilitch",
    "wh_main_chs_chaos",
    "wh2_dlc17_bst_malagor",
    "wh2_dlc17_bst_taurox",
    "wh2_main_bst_shadowgor",
    "wh_dlc03_bst_beastmen",
    "wh_dlc08_nor_norsca",
    "wh_dlc08_nor_wintertooth",
    "wh2_dlc11_def_the_blessed_dread",
    "wh2_main_def_cult_of_pleasure",
    "wh2_main_def_hag_graef",
    "wh2_main_def_har_ganeth",
    "wh2_main_def_naggarond",
    "wh2_twa03_def_rakarth",
    "wh2_dlc09_skv_clan_rictus",
    "wh2_main_skv_clan_eshin",
    "wh2_main_skv_clan_mors",
    "wh2_main_skv_clan_moulder",
    "wh2_main_skv_clan_pestilens",
    "wh2_dlc11_cst_noctilus",
    "wh2_dlc11_cst_pirates_of_sartosa",
    "wh2_dlc11_cst_the_drowned",
    "wh2_dlc11_cst_vampire_coast",
    "wh3_main_kho_exiles_of_khorne",
    "wh3_main_nur_poxmakers_of_nurgle",
    "wh3_main_tze_oracles_of_tzeentch",
    "wh3_main_sla_seducers_of_slaanesh",
    "wh3_main_ogr_disciples_of_the_maw",
    "wh3_main_ogr_goldtooth",
    "wh3_dlc23_chd_astragoth",
    "wh3_dlc23_chd_legion_of_azgorh",
    "wh3_dlc23_chd_zhatan"
}





function rhox_is_missed_ror_in_the_table()
    if #rhox_failed_mission_rewards > 0 then
        out("Rhox Grudge: There was missed RoR")
        return true
    else
        out("Rhox Grudge: There wasn't a missed RoR")
        return false
    end
    return false
end

function rhox_get_missing_ror_bundle()
    local index= cm:random_number(#rhox_failed_mission_rewards,1)
    
    local ancillary_key = false
    if rhox_failed_mission_rewards[index].ancillary_key then
        ancillary_key = rhox_failed_mission_rewards[index].ancillary_key
    end
    out("Rhox Grudge: bundle key: ".. grudgebringer_mission_key..tostring(rhox_failed_mission_rewards[index].index))
    out("Rhox Grudge: ancillary key: ".. tostring(ancillary_key))
    return grudgebringer_mission_key..tostring(rhox_failed_mission_rewards[index].index), ancillary_key
end


local function rhox_trigger_grudgebringer_mission(i)
    local mission_key = grudgebringer_mission_key..tostring(i)
    local mm = mission_manager:new(grudgebringer_faction, mission_key)
    mm:set_mission_issuer("CLAN_ELDERS")
    
    mm:add_new_objective(grudgebringer_missions[i].type)
    if grudgebringer_missions[i].type == "ENGAGE_FORCE" then
        --out("Rhox Grudge: Inside the engage force")
        mm:add_condition("cqi "..cm:get_faction(grudgebringer_missions[i].faction_key):faction_leader():military_force():command_queue_index())
        mm:add_condition("requires_victory")
    elseif grudgebringer_missions[i].faction_key then --means it targets faction
        if grudgebringer_missions[i].faction_key == "random" then
            local target = cm:random_number(#grudgebringer_evil_ll_factions,1)
            --out("Rhox Grudge: target is: "..grudgebringer_evil_ll_factions[target])
            local target_faction = grudgebringer_evil_ll_factions[target]
            mm:add_condition("faction "..target_faction);
            table.remove(grudgebringer_evil_ll_factions, target)
            grudgebringer_missions[i].rolled_target = target_faction
        else
            mm:add_condition("faction "..grudgebringer_missions[i].faction_key);
        end
    else --means its a subculture target 
        mm:add_condition("subculture "..grudgebringer_missions[i].subculture_key);
    end
    
    if grudgebringer_missions[i].type == "ENGAGE_FORCE" then
        out("Engage force: Not adding anything.")
        --do nothing
    elseif grudgebringer_missions[i].count then
        mm:add_condition("total "..grudgebringer_missions[i].count)
    else
        local rolled_total = cm:random_number(3,1)
        mm:add_condition("total "..rolled_total)
        grudgebringer_missions[i].rolled_total = rolled_total
    end

    grudgebringer_missions[i].mission_key = mission_key
    cm:set_saved_value("ovn_grudge_missions", grudgebringer_missions)
    
    cm:add_event_restricted_unit_record_for_faction(grudgebringer_missions[i].reward, grudgebringer_faction, "rhox_grudge_ror_lock")
    
    
    
    
    
    mm:add_payload("effect_bundle{bundle_key "..mission_key..";turns 1;}")
    
    if grudgebringer_missions[i].ancillary_key then
        mm:add_payload("add_ancillary_to_faction_pool{ancillary_key "..grudgebringer_missions[i].ancillary_key..";}")
    end
    mm:trigger()
end

local rhox_gurdge_lh_regions={
    "wh3_main_combi_region_flensburg",
    "wh3_main_combi_region_kings_glade",
    "wh3_main_combi_region_vitevo",
    "wh3_main_combi_region_zhufbar",
    "wh3_main_combi_region_altdorf",
    "wh3_main_combi_region_averheim"
}

local function rhox_trigger_grudgebringer_lh_mission(i)
    local mission_key = "rhox_grudgebringer_lh_"..tostring(i)
    
    local mm = mission_manager:new(grudgebringer_faction, mission_key)
    mm:set_mission_issuer("CLAN_ELDERS")
    mm:add_new_objective("MOVE_TO_REGION")
    mm:add_condition("region "..rhox_gurdge_lh_regions[i]);
    mm:add_payload("effect_bundle{bundle_key ".."rhox_grudgebringer_lh_reward_bundle_"..tostring(i)..";turns 1;}")
    
    mm:trigger()
end


local ai_ror_list={}


function rhox_setup_starting_missions()


    local ancillaries={
        "grudge_item_storm_sword",
        "grudge_item_banner_of_wrath",
        "grudge_item_hellfire_sword",
        "grudge_item_horn_of_urgok",
        "grudge_item_banner_of_arcane_warding",
        "grudge_item_wand_of_jet",
        "grudge_item_runefang",
        "grudge_item_shield_of_ptolos",
        "grudge_item_dragonhelm",
        "grudge_item_spelleater_shield"
    }
        
    if cm:get_faction(grudgebringer_faction):is_human() then
        for i=1,skip_mission_sampling_num do
            local target = cm:random_number(#grudgebringer_missions, 1)
            if target ~= 12 then --it's the starting mission and shouldn't be skipped
                skip_mission_table[target]=true
            end
        end
        
        local ancillary_candidate={}
        for i=1,#grudgebringer_missions do
            if skip_mission_table[i]~=true then
                table.insert(ancillary_candidate, i)
            end
        end
        ancillary_candidate= cm:random_sort(ancillary_candidate)
        for i=1,#ancillaries do
            grudgebringer_missions[ancillary_candidate[i]].ancillary_key = ancillaries[i]
            out("Rhox Grudge: Giving ancillary " .. ancillaries[i] .. " to mission number ".. ancillary_candidate[i])
        end
    
    
        cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "")
        for i=1,#grudgebringer_missions do
            if skip_mission_table[i] ~= true then
                rhox_trigger_grudgebringer_mission(i)
            else
                out("Rhox Grudge: Skipping mission: "..i)
                cm:add_unit_to_faction_mercenary_pool(cm:get_faction("ovn_emp_grudgebringers"),grudgebringer_missions[i].reward, "renown", 0,0,0,0,"","","", true,grudgebringer_missions[i].reward) --you're not getting them, let's remove them from the reward
            end
        end
        for i=1,#rhox_gurdge_lh_regions do
            rhox_trigger_grudgebringer_lh_mission(i)
        end
        cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "")
    else --for ai just put them inside the table we will use them later
        for i=1,#grudgebringer_missions do
            table.insert(ai_ror_list, grudgebringer_missions[i].reward)
            cm:add_event_restricted_unit_record_for_faction(grudgebringer_missions[i].reward, grudgebringer_faction, "rhox_grudge_ror_lock") --lock it.
            
        end
        
        for i=1,#ancillaries do
            cm:add_ancillary_to_faction(cm:get_faction(grudgebringer_faction), ancillaries[i], false) --just give ancillary to the AI
        end
        
        ----and summon legendary heroes. It will make less reports about missing LHs when Grudgebringer is the AI
        local faction = cm:get_faction(grudgebringer_faction)
        local faction_leader_force = faction:faction_leader():military_force()
        cm:spawn_unique_agent_at_character(faction:command_queue_index(), "ludwig_uberdorf_agent_subtype", faction:faction_leader():command_queue_index(), true)
        agent = cm:get_most_recently_created_character_of_type(grudgebringer_faction,"champion","ludwig_uberdorf_agent_subtype")
        if agent then
            cm:replenish_action_points(cm:char_lookup_str(agent))
            cm:embed_agent_in_force(agent ,faction_leader_force)
        end        
        cm:spawn_unique_agent_at_character(faction:command_queue_index(), "ceridan", faction:faction_leader():command_queue_index(), true)
        agent = cm:get_most_recently_created_character_of_type(grudgebringer_faction,"champion","ceridan")
        if agent then
            cm:replenish_action_points(cm:char_lookup_str(agent))
            cm:embed_agent_in_force(agent ,faction_leader_force)
        end
    
        cm:spawn_unique_agent_at_character(faction:command_queue_index(), "ice_mage_vladimir_stormbringer", faction:faction_leader():command_queue_index(), true)
        agent = cm:get_most_recently_created_character_of_type(grudgebringer_faction,"wizard","ice_mage_vladimir_stormbringer")
        if agent then
            cm:replenish_action_points(cm:char_lookup_str(agent))
            cm:embed_agent_in_force(agent ,faction_leader_force)
        end
    
        cm:spawn_unique_agent_at_character(faction:command_queue_index(), "dwarf_envoy", faction:faction_leader():command_queue_index(), true)
        agent = cm:get_most_recently_created_character_of_type(grudgebringer_faction,"champion","dwarf_envoy")
        cm:remove_event_restricted_unit_record_for_faction("dwarf_envoy_dwarf_warriors", grudgebringer_faction);
        if agent then
            cm:replenish_action_points(cm:char_lookup_str(agent))
            cm:embed_agent_in_force(agent ,faction_leader_force)
        end
        
        cm:spawn_unique_agent_at_character(faction:command_queue_index(), "matthias", faction:faction_leader():command_queue_index(), true)
        agent = cm:get_most_recently_created_character_of_type(grudgebringer_faction,"champion","matthias")
        if agent then
            cm:replenish_action_points(cm:char_lookup_str(agent))
            cm:embed_agent_in_force(agent ,faction_leader_force)
        end
        
        cm:spawn_unique_agent_at_character(faction:command_queue_index(), "luther_flamenstrike", faction:faction_leader():command_queue_index(), true)
        agent = cm:get_most_recently_created_character_of_type(grudgebringer_faction,"champion","luther_flamenstrike")
        if agent then
            cm:replenish_action_points(cm:char_lookup_str(agent))
            cm:embed_agent_in_force(agent ,faction_leader_force)
        end
        
        
    end
end


local function rhox_grudge_ai_ror_unlocker()
    if #ai_ror_list ==0 then
        out("Rhox Grudge: There is no unit in the function, returning")
        return --there is no unit left to give, return
    end
    local target = cm:random_number(#ai_ror_list, 1)
    cm:remove_event_restricted_unit_record_for_faction(ai_ror_list[target], grudgebringer_faction);
    out("Rhox Grudge: Unlocked unit " .. ai_ror_list[target] .. "for the AI")
    table.remove(ai_ror_list, target)
end




core:add_listener(
	"rhox_grudge_lh_unlock_listener",
	"MissionSucceeded",
	function(context)
		return context:mission():mission_record_key():starts_with("rhox_grudgebringer_lh_")
	end,
	function(context)
        out("Rhox Grudge: Inside the mission success listener!")
        local current_mission = context:mission():mission_record_key()
        
        local agent = nil
        if current_mission == "rhox_grudgebringer_lh_1" then
            cm:spawn_unique_agent_at_character(context:faction():command_queue_index(), "ludwig_uberdorf_agent_subtype", context:faction():faction_leader():command_queue_index(), true)
            agent = cm:get_most_recently_created_character_of_type(grudgebringer_faction,"champion","ludwig_uberdorf_agent_subtype")
        elseif current_mission == "rhox_grudgebringer_lh_2" then
            cm:spawn_unique_agent_at_character(context:faction():command_queue_index(), "ceridan", context:faction():faction_leader():command_queue_index(), true)
            agent = cm:get_most_recently_created_character_of_type(grudgebringer_faction,"champion","ceridan")
        elseif current_mission == "rhox_grudgebringer_lh_3" then
            cm:spawn_unique_agent_at_character(context:faction():command_queue_index(), "ice_mage_vladimir_stormbringer", context:faction():faction_leader():command_queue_index(), true)
            agent = cm:get_most_recently_created_character_of_type(grudgebringer_faction,"wizard","ice_mage_vladimir_stormbringer")
        elseif current_mission == "rhox_grudgebringer_lh_4" then
            cm:spawn_unique_agent_at_character(context:faction():command_queue_index(), "dwarf_envoy", context:faction():faction_leader():command_queue_index(), true)
            agent = cm:get_most_recently_created_character_of_type(grudgebringer_faction,"champion","dwarf_envoy")
            cm:remove_event_restricted_unit_record_for_faction("dwarf_envoy_dwarf_warriors", grudgebringer_faction);
        elseif current_mission == "rhox_grudgebringer_lh_5" then
            cm:spawn_unique_agent_at_character(context:faction():command_queue_index(), "matthias", context:faction():faction_leader():command_queue_index(), true)
            agent = cm:get_most_recently_created_character_of_type(grudgebringer_faction,"champion","matthias")
        elseif current_mission == "rhox_grudgebringer_lh_6" then
            cm:spawn_unique_agent_at_character(context:faction():command_queue_index(), "luther_flamenstrike", context:faction():faction_leader():command_queue_index(), true)
            agent = cm:get_most_recently_created_character_of_type(grudgebringer_faction,"champion","luther_flamenstrike")
        end
        local faction_leader_force = context:faction():faction_leader():military_force()
        if faction_leader_force:unit_list():num_items() < 20 and agent then --it means agent has bees generated and Morgan has a room in his army
            cm:replenish_action_points(cm:char_lookup_str(agent))
            cm:embed_agent_in_force(agent ,faction_leader_force)
        end
	end,
	true
);


core:add_listener(
	"rhox_grudge_ror_unlock_listener",
	"MissionSucceeded",
	function(context)
		return context:mission():mission_record_key():starts_with(grudgebringer_mission_key)
	end,
	function(context)
        out("Rhox Grudge: Inside the mission success listener!")
        local current_mission = context:mission():mission_record_key()
        
        
        local mission_key = grudgebringer_mission_key
        local id = tonumber(string.sub(current_mission, string.len(mission_key) + 1, string.len(current_mission)))
        out("Rhox Grudge: ID: "..id)
        cm:remove_event_restricted_unit_record_for_faction(grudgebringer_missions[id].reward, grudgebringer_faction);
        
        local mission_statuses = cm:get_saved_value("ovn_grudge_missions_statuses") or {}
        mission_statuses.success = mission_statuses.success or {}
        mission_statuses.success[current_mission] = true
        cm:set_saved_value("ovn_grudge_missions_statuses", mission_statuses)
	end,
	true
);

core:add_listener(
	"rhox_grudge_ror_cancel_listener",
	"MissionCancelled",
	function(context)
		return context:mission():mission_record_key():starts_with(grudgebringer_mission_key)
	end,
	function(context)
        out("Rhox Grudge: Inside the mission canceled listener!")
        local current_mission = context:mission():mission_record_key()
        
        
        local mission_key = grudgebringer_mission_key
        local id = tonumber(string.sub(current_mission, string.len(mission_key) + 1, string.len(current_mission)))
        out("Rhox Grudge: ID: "..id)
        local to_put = grudgebringer_missions[id]
        to_put.index=id
        table.insert(rhox_failed_mission_rewards, to_put)
        out("Rhox Grudge: finished inserting the table! "..to_put.index)

        local mission_statuses = cm:get_saved_value("ovn_grudge_missions_statuses") or {}
        mission_statuses.failed = mission_statuses.failed or {}
        mission_statuses.failed[current_mission] = true
        cm:set_saved_value("ovn_grudge_missions_statuses", mission_statuses)
	end,
	true
);


function rhox_check_ror_rewards(faction)
    for i=1,24 do
        if faction:has_effect_bundle(grudgebringer_mission_key..tostring(i)) then
            cm:remove_event_restricted_unit_record_for_faction(grudgebringer_missions[i].reward, grudgebringer_faction);
            for j=1,#rhox_failed_mission_rewards do
                if rhox_failed_mission_rewards[j].reward == grudgebringer_missions[i].reward then
                    if grudgebringer_missions[i].ancillary_key and not faction:ancillary_exists(grudgebringer_missions[i].ancillary_key) then --give them the ancillary also
                        cm:add_ancillary_to_faction(faction, grudgebringer_missions[i].ancillary_key, false)
                    end
                    table.remove(rhox_failed_mission_rewards, j) --so they won't popup again
                end
            end
        end
    end
end

core:add_listener(
    "rhox_grudge_ror_giver_FactionTurnStart",
    "FactionTurnStart",
    function(context)    
        return context:faction():name() == grudgebringer_faction
    end,
    function(context)
        rhox_check_ror_rewards(context:faction())
        local turn = cm:model():turn_number();
        if context:faction():is_human() ==false and turn%5 ==1 then
            rhox_grudge_ai_ror_unlocker()
        end
        
    end,
    true
)


core:add_listener(
	"rhox_grudge_ror_unlock_ogre_mission_success_listener",
	"MissionSucceeded",
	function(context)
		return context:faction():name() == grudgebringer_faction and context:mission():mission_record_key() == "wh3_main_mission_ogre_contract_defeat_lord" or context:mission():mission_record_key() == "wh3_main_mission_ogre_contract_raze_settlement" 
	end,
	function(context)
        rhox_check_ror_rewards(context:faction())
	end,
	true
);

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_grudge_failed_mission_rewards", rhox_failed_mission_rewards, context)
		cm:save_named_value("rhox_grudge_ai_ror_list", ai_ror_list, context)
		cm:save_named_value("rhox_grudge_grudgebringer_missions", grudgebringer_missions, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			rhox_failed_mission_rewards = cm:load_named_value("rhox_grudge_failed_mission_rewards", rhox_failed_mission_rewards, context)
			ai_ror_list = cm:load_named_value("rhox_grudge_ai_ror_list", ai_ror_list, context)
			grudgebringer_missions = cm:load_named_value("rhox_grudge_grudgebringer_missions", grudgebringer_missions, context)
		end
	end
)
