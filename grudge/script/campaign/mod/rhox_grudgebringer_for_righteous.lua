local grudgebringer_faction = "ovn_emp_grudgebringers"
local grudgebringer_mission_key = "rhox_grudgebringer_piece_of_eight_"
local grudgebringer_missions ={
   {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        ancillary_key= "grudge_item_storm_sword",
        reward = "ragnar_wolves"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        ancillary_key= "grudge_item_banner_of_wrath",
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
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        reward = "urblab_rotgut_mercenary_ogres"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        subculture_key = " wh_main_sc_vmp_vampire_counts",
        count = 5,
        ancillary_key= "grudge_item_hellfire_sword",
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
        ancillary_key= "grudge_item_horn_of_urgok",
        reward = "keelers_longbows"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        subculture_key = "wh2_main_sc_skv_skaven",
        count = 3,
        reward = "black_avangers"
    },
    {
        type = "ENGAGE_FORCE",
        faction_key = "wh_main_sc_grn_greenskins",
        count = 4,
        ancillary_key= "grudge_item_banner_of_arcane_warding",
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
        faction_key = "wh_main_sc_vmp_vampire_counts",
        count = 6,
        reward = "treeman_knarlroot"
    },
    {
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
        ancillary_key= "grudge_item_wand_of_jet",
        reward = "countess_guard"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        ancillary_key= "grudge_item_runefang",
        reward = "dieter_schaeffer_carroburg_greatswords"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "random",
        ancillary_key= "grudge_item_spelleater_shield",
        reward = "jurgen_muntz_outlaw_infantry"
    },
    {
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
        ancillary_key= "grudge_item_shield_of_ptolos",
        reward = "imperial_cannon_darius_flugenheim"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "wh_main_vmp_mousillon",
        count = 2,
        reward = "grail_knights_tristan_de_la_tourtristan_de_la_tour"
    },
    {
        type = "DEFEAT_N_ARMIES_OF_FACTION",
        faction_key = "wh2_dlc15_grn_broken_axe",
        count = 2,
        ancillary_key= "grudge_item_dragonhelm",
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
    "wh3_main_ogr_goldtooth"
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
        local faction = cm:get_faction(grudgebringer_missions[i].faction_key)
        out("faction key is "..tostring(grudgebringer_missions[i].faction_key))
        out("faction is "..tostring(faction))
        mm:add_condition("cqi "..faction:faction_leader():military_force():command_queue_index())
        mm:add_condition("requires_victory")
    elseif grudgebringer_missions[i].faction_key then --means it targets faction
        if grudgebringer_missions[i].faction_key == "random" then
            local target = cm:random_number(#grudgebringer_evil_ll_factions,1)
            --out("Rhox Grudge: target is: "..grudgebringer_evil_ll_factions[target])
            mm:add_condition("faction "..grudgebringer_evil_ll_factions[target]);
            table.remove(grudgebringer_evil_ll_factions, target)
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
        mm:add_condition("total "..cm:random_number(3,1))
    end
    
    cm:add_event_restricted_unit_record_for_faction(grudgebringer_missions[i].reward, grudgebringer_faction, "rhox_grudge_ror_lock")
    
    
    
    
    
    mm:add_payload("effect_bundle{bundle_key "..mission_key..";turns 1;}")
    
    if grudgebringer_missions[i].ancillary_key then
        mm:add_payload("add_ancillary_to_faction_pool{ancillary_key "..grudgebringer_missions[i].ancillary_key..";}")
    end
    mm:trigger()
end

local rhox_gurdge_lh_regions={
    "wh3_main_combi_region_flensburg",
    "wh3_main_combi_region_karak_hirn",
    "wh3_main_combi_region_kislev",
    "wh3_main_combi_region_zhufbar"
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



function rhox_setup_starting_missions()
    if cm:get_local_faction_name(true) == grudgebringer_faction then
        cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "")
        for i=1,24 do
            rhox_trigger_grudgebringer_mission(i)
        end
        for i=1,4 do
            rhox_trigger_grudgebringer_lh_mission(i)
        end
        cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "")
    end
end






local lh_missions={
    "rhox_grudgebringer_lh_1", --ludwig
    "rhox_grudgebringer_lh_2", --ceridan
    "rhox_grudgebringer_lh_3", --stormbringer
    "rhox_grudgebringer_lh_4" --dwarf envoy
}

cm:add_first_tick_callback(
	function()
        if cm:get_local_faction_name(true) == grudgebringer_faction then
            local pieces_of_eight_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management", "button_treasure_hunts");
            pieces_of_eight_button:SetVisible(true)
            pieces_of_eight_button:SetTooltipText(common.get_localised_string("campaign_localised_strings_string_rhox_grudgebringer_panel_open_button"),true)
            local treasure_hunt_count_ui = find_uicomponent(pieces_of_eight_button, "label_hunts_count"); --treasure hunt count. We don't need this
            treasure_hunt_count_ui:SetVisible(false)
            
            
            core:add_listener(
                "rhox_grudgebringer_treasure_panel_open_listener",
                "PanelOpenedCampaign",
                function(context)
                    return context.string == "treasure_hunts";
                end,
                function()
                    local pieces_tab = find_uicomponent(core:get_ui_root(), "treasure_hunts", "TabGroup", "pieces");
                    pieces_tab:SimulateLClick();
                    --pieces_tab:MoveTo(885, 919)  --doesn't work
                    --local x, y = pieces_tab:Position()
                    --out("Rhox mar: "..x..", "..y)  --1285, 919 is the original location
                    local pieces_text = find_uicomponent(pieces_tab, "tx");
                    pieces_text:SetText(common.get_localised_string("campaign_localised_strings_string_rhox_grudgebringer_piece_tab"))
                    
                    
                    
                    
                    local treasure_tab = find_uicomponent(core:get_ui_root(), "treasure_hunts", "TabGroup", "hunts");
                    treasure_tab:SetVisible(false) --we're not using this button and should disable it. 
                    treasure_tab:Destroy() --Will this change the position?
                    
                    cm:callback(
                        function()
                            local pieces_holder = find_uicomponent(core:get_ui_root(), "treasure_hunts", "TabGroup", "pieces", "tab_child", "map", "pieces_holder")
                            out("Rhox Grudge: Inside the panel")
                            if not pieces_holder then
                                out("Rhox Grudge: There isn't one I'm ending here")
                                return
                            end
                            for i=1,#lh_missions do
                                local lh_piece = find_uicomponent(pieces_holder, lh_missions[i])
                                if lh_piece then 
                                    out("Rhox Grudge: Changing the image")
                                    lh_piece:SetImagePath("ui/skins/ovn_grudge/LH_piece_active.png")
                                    lh_piece:SetImagePath("ui/skins/ovn_grudge/LH_piece_active.png", 3) --this is for the clicked
                                end
                            end
                        end,
                        0.2
                    )
                    
                    
                end,
                true
            )
            
        end
	end
);


core:add_listener(
	"rhox_grudge_lh_unlock_listener",
	"MissionSucceeded",
	function(context)
		return context:mission():mission_record_key():starts_with("rhox_grudgebringer_lh_")
	end,
	function(context)
        out("Rhox Grudge: Inside the mission success listener!")
        local current_mission = context:mission():mission_record_key()
        

        if current_mission == "rhox_grudgebringer_lh_1" then
            cm:spawn_unique_agent_at_character(context:faction():command_queue_index(), "ludwig_uberdorf_agent_subtype", context:faction():faction_leader():command_queue_index(), true)
        elseif current_mission == "rhox_grudgebringer_lh_2" then
            cm:spawn_unique_agent_at_character(context:faction():command_queue_index(), "ceridan", context:faction():faction_leader():command_queue_index(), true)
        elseif current_mission == "rhox_grudgebringer_lh_3" then
            cm:spawn_unique_agent_at_character(context:faction():command_queue_index(), "ice_mage_vladimir_stormbringer", context:faction():faction_leader():command_queue_index(), true)
        elseif current_mission == "rhox_grudgebringer_lh_4" then
            cm:spawn_unique_agent_at_character(context:faction():command_queue_index(), "dwarf_envoy", context:faction():faction_leader():command_queue_index(), true)
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
		cm:save_named_value("rhox_failed_mission_rewards", rhox_failed_mission_rewards, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			rhox_failed_mission_rewards = cm:load_named_value("rhox_failed_mission_rewards", rhox_failed_mission_rewards, context)
		end
	end
)