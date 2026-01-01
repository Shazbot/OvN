local vampire_coast_culture = "wh2_dlc11_cst_vampire_coast"
local gm_faction = "ovn_arb_golden_fleet"

local remaining_rors={
    "ovn_arb_mon_desert_spirit_ror",
    "ovn_arb_mon_fire_efreet_ror",
    "ovn_arb_mon_sea_nymph_ror",
    "ovn_arb_mon_tempest_djinn_ror"
};
local number_of_collected_pieces_of_eight = 0;

local pirate_faction_names ={
    "wh2_dlc11_cst_rogue_boyz_of_the_forbidden_coast",
    "wh2_dlc11_cst_rogue_freebooters_of_port_royale",
    "wh2_dlc11_cst_rogue_the_churning_gulf_raiders",
    "wh2_dlc11_cst_rogue_bleak_coast_buccaneers",
    "wh2_dlc11_cst_rogue_grey_point_scuttlers",
    "wh2_dlc11_cst_rogue_tyrants_of_the_black_ocean",
    "wh2_dlc11_cst_rogue_terrors_of_the_dark_straights"
};





cm:add_first_tick_callback(
	function()
        
        if cm:get_local_faction_name(ture) == gm_faction then --UI things
            local pieces_of_eight_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management", "button_treasure_hunts");
            pieces_of_eight_button:SetVisible(true)
        end
        
        if cm:get_faction(gm_faction) and cm:get_faction(gm_faction):is_human() then
            rhox_araby_treasure_map_listeners() 
            
            core:add_listener(
                "rhox_araby_PieceOfEight_MissionSucceeded",
                "MissionSucceeded",
                function(context)
                    local mission_key = context:mission():mission_record_key()
                    local faction = context:faction()
                    local faction_key = faction:name()
                    return faction_key == gm_faction and mission_key:starts_with("wh2_dlc11_mission_piece_of_eight_")
                end,
                function(context)
                    out("Rhox Araby: Mission success")
                    local mission_key = context:mission():mission_record_key()
                    local faction = context:faction()
                    local faction_key = faction:name()
                    
                    number_of_collected_pieces_of_eight = number_of_collected_pieces_of_eight+1
                    out("Rhox Araby: number_of_collected_pieces_of_eight: "..number_of_collected_pieces_of_eight)
                    
                    out("Rhox Araby: number of remaining RoRs: "..#remaining_rors)
                    if number_of_collected_pieces_of_eight%2 == 0 or number_of_collected_pieces_of_eight == 7 then --he isn't going to collect the 8th one. Which is done by quest battles in Vampire Coast+ fuck, why is % operator not working??? 
                        local target_index = cm:random_number(#remaining_rors, 1)
                        out("Rhox Araby: target index and unit name"..target_index.."/"..remaining_rors[target_index])
                        cm:remove_event_restricted_unit_record_for_faction(remaining_rors[target_index], faction_key)
                        table.remove(remaining_rors, target_index)
                    end
                end,
                true
            )

        end


		if cm:get_faction(gm_faction):is_human() and cm:is_new_game() then
            --Giving him missions.
            local piece_of_eight_mission_count = 1
            for k, pirate_faction in pairs(pirate_faction_names) do
                local mission_key = "wh2_dlc11_mission_piece_of_eight_"..piece_of_eight_mission_count
                out("Rhox Araby mission key: "..mission_key)
                
                local mm = mission_manager:new(gm_faction, mission_key)
                mm:set_mission_issuer("CLAN_ELDERS")
                mm:add_new_objective("ENGAGE_FORCE")
                mm:add_condition("cqi "..cm:get_faction(pirate_faction):faction_leader():military_force():command_queue_index())
                mm:add_condition("requires_victory")
                --mm:add_payload("money 5000")
                mm:add_payload("effect_bundle{bundle_key rhox_araby_wh2_dlc11_ror_reward_"..piece_of_eight_mission_count..";turns 0;}")
                mm:trigger()

                piece_of_eight_mission_count = piece_of_eight_mission_count+1
            end
        end
	end
);


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_araby_gm_remaining_rors", remaining_rors, context)
		cm:save_named_value("rhox_araby_number_of_collected_pieces_of_eight", number_of_collected_pieces_of_eight, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			remaining_rors = cm:load_named_value("rhox_araby_gm_remaining_rors", remaining_rors, context)
			number_of_collected_pieces_of_eight = cm:load_named_value("rhox_araby_number_of_collected_pieces_of_eight", number_of_collected_pieces_of_eight, context)
		end
	end
)
