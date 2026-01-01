local function spawn_new_force()
	cm:create_force_with_general(
		"ovn_arb_sultanate_of_all_araby", -- faction_key,
		"ovn_arb_inf_arabyan_spearmen,ovn_arb_inf_arabyan_warriors,ovn_arb_inf_arabyan_warriors,ovn_arb_mon_genie,ovn_arb_inf_arabyan_guard,ovn_arb_inf_arabyan_bowmen,ovn_arb_cav_arabyan_knights,ovn_arb_inf_arabyan_bowmen", -- unit_list,
		"cr_oldworld_region_al_haikk", -- region_key,
		45, -- x,
		449, -- y,
		"general", -- type,
		"arb_sultan_jaffar", -- subtype,
		"names_name_999982322", -- name1,
		"", -- name2,
		"names_name_999982323", -- name3,
		"", -- name4,
		true,-- make_faction_leader,
        function(cqi) -- callback
            local str = "character_cqi:" .. cqi
            cm:set_character_immortality(str, true);
            cm:set_character_unique(str, true);
        end
	)
end

local function new_game_startup()
    local sultanate_of_all_araby_string = "ovn_arb_sultanate_of_all_araby"
	local sultanate_of_all_araby = cm:get_faction(sultanate_of_all_araby_string)

    if not sultanate_of_all_araby then return end

    local to_kill_cqi = nil
    local mixer_sultanate_of_all_araby_leader = sultanate_of_all_araby:faction_leader()

	if mixer_sultanate_of_all_araby_leader and not mixer_sultanate_of_all_araby_leader:is_null_interface() then
		to_kill_cqi = mixer_sultanate_of_all_araby_leader:command_queue_index()
	end

    spawn_new_force()
    
    cm:force_change_cai_faction_personality("ovn_arb_sultanate_of_all_araby", "ovn_arb_sultanate_of_all_araby")
    
    --change the campaign settlement model used
	cm:override_building_chain_display("wh_main_VAMPIRES_settlement_major", "ovn_arb_special_settlement_al_haikk", "cr_oldworld_region_al_haikk")
	
    local al_haikk = cm:get_region("cr_oldworld_region_al_haikk")
    cm:transfer_region_to_faction("cr_oldworld_region_al_haikk", "ovn_arb_sultanate_of_all_araby")
    cm:transfer_region_to_faction("cr_oldworld_region_bakr_oasis", "ovn_arb_sultanate_of_all_araby")
	cm:instantly_set_settlement_primary_slot_level(al_haikk:settlement(), 2)
	cm:heal_garrison(al_haikk:cqi());
	
	--locking technology so it won't make available tech popup
	cm:lock_technology(sultanate_of_all_araby_string, "araby_tech_good_mil_4")
	cm:lock_technology(sultanate_of_all_araby_string, "araby_tech_good_mil_8")

    local wazar = cm:create_agent(
        "ovn_arb_sultanate_of_all_araby",
        "champion",
        "arb_champion_wazar",
		51, -- x,
		445 -- y,
	)
	if wazar then
        cm:replenish_action_points(cm:char_lookup_str(wazar))
        local name = common:get_localised_string("names_name_3508823268")
        cm:change_character_custom_name(wazar, name, "", "", "")
    end
    
    
    -- cm:force_declare_war("cr_tze_cult_of_mirrors", "ovn_arb_sultanate_of_all_araby", false, false)


    local unit_count = 1 -- card32 count
    local rcp = 100 -- float32 replenishment_chance_percentage
    local max_units = 1 -- int32 max_units
    local murpt = 0.1 -- float32 max_units_replenished_per_turn
    local xp_level = 0 -- card32 xp_level
    local frr = "" -- (may be empty) String faction_restricted_record
    local srr = "" -- (may be empty) String subculture_restricted_record
    local trr = "" -- (may be empty) String tech_restricted_record
    local units = {
        "ovn_arb_art_grand_bombard_ror",
		"ovn_arb_veh_naphtha_thrower_ror",
		"ovn_arb_cav_lancer_camels_ror",
		"ovn_arb_cav_arabyan_knights_ror",
		"ovn_arb_cav_sipahis_ror",
		"ovn_arb_cav_flying_carpets_ror",
		"ovn_arb_inf_arabyan_warriors_ror",
		"ovn_arb_mon_war_elephant_ror_2",
		"ovn_arb_mon_war_elephant_ror_1",
		"ovn_arb_inf_jezzails_ror",
        "ovn_arb_inf_naffatun_ror",
        "ovn_arb_art_quadballista_ror",        
        "ovn_arb_inf_arabyan_guard_ror",
        "ovn_arb_mon_desert_spirit_ror",
        "ovn_arb_mon_fire_efreet_ror",
        "ovn_arb_mon_sea_nymph_ror",
        "ovn_arb_mon_tempest_djinn_ror"
    }
    
    
    for _, unit in ipairs(units) do
        cm:add_unit_to_faction_mercenary_pool(
            sultanate_of_all_araby,
            unit,
            "renown",
            unit_count,
            rcp,
            max_units,
            murpt,
            frr,
            srr,
            trr,
            true,
            unit
        )
    end
    
    
    cm:add_event_restricted_unit_record_for_faction("ovn_arb_mon_desert_spirit_ror", sultanate_of_all_araby_string, "rhox_araby_jaffar_revenge_lock")
    cm:add_event_restricted_unit_record_for_faction("ovn_arb_mon_fire_efreet_ror", sultanate_of_all_araby_string, "rhox_araby_jaffar_revenge_lock")
    cm:add_event_restricted_unit_record_for_faction("ovn_arb_mon_sea_nymph_ror", sultanate_of_all_araby_string, "rhox_araby_jaffar_revenge_lock")
    cm:add_event_restricted_unit_record_for_faction("ovn_arb_mon_tempest_djinn_ror", sultanate_of_all_araby_string, "rhox_araby_jaffar_revenge_lock")
    
    
    
    cm:callback(function()
        if to_kill_cqi then
            cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
            local str = "character_cqi:" .. to_kill_cqi
            cm:set_character_immortality(str, false)
            cm:kill_character_and_commanded_unit(str, true)
        end
    end, 0)
    cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);

    cm:callback(
        function()
            if sultanate_of_all_araby:is_human() then
                cm:show_message_event(
                    sultanate_of_all_araby_string,
                    "event_feed_strings_text_wh2_scripted_event_how_they_play_title",
                    "factions_screen_name_" .. sultanate_of_all_araby_string,
                    "event_feed_strings_text_ovn_araby_how_they_play_jaffar",
                    true,
                    1001
                )
            end
        end,
        1
    )
end


cm:add_first_tick_callback(
	function()
        pcall(function()
            mixer_set_faction_trait("ovn_arb_sultanate_of_all_araby", "ovn_lord_trait_arb_sultanate_of_all_araby", true)
        end)
		if cm:is_new_game() then
			if cm:get_campaign_name() == "cr_oldworld" then 
				local ok, err =
					pcall(
					function()
						new_game_startup()
					end
				)
				if not ok then
					script_error(err)
				end
			end
		end
	end
)