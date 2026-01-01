local function spawn_new_force()
	cm:create_force_with_general(
		"ovn_arb_aswad_scythans", -- faction_key,
		"ovn_arb_inf_arabyan_spearmen,ovn_arb_inf_alrahem_nomads,ovn_arb_cav_bedouin_scouts,ovn_arb_inf_arabyan_bowmen,ovn_arb_inf_arabyan_spearmen,ovn_arb_inf_jezzails,ovn_arb_cav_waghzen", -- unit_list,
		"wh3_main_combi_region_karag_orrud", -- region_key,
		728, -- x,
		309, -- y,
		"general", -- type,
		"arb_fatandira", -- subtype,
		"names_name_999982308", -- name1,
		"", -- name2,
		"", -- name3,
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
    local aswad_scythans_string = "ovn_arb_aswad_scythans"
	local aswad_scythans = cm:get_faction(aswad_scythans_string)

    if not aswad_scythans then return end

    local to_kill_cqi = nil
    local mixer_aswad_scythans_leader = aswad_scythans:faction_leader()

	if mixer_aswad_scythans_leader and not mixer_aswad_scythans_leader:is_null_interface() then
		to_kill_cqi = mixer_aswad_scythans_leader:command_queue_index()
	end

    spawn_new_force()
    
    --[[
    if aswad_scythans:is_human() and cm:get_faction("wh2_dlc09_tmb_numas"):is_human() == false and cm:get_faction("wh2_dlc09_tmb_khemri"):is_human() == false then
        cm:force_make_peace("wh2_dlc09_tmb_numas", "wh2_dlc09_tmb_khemri")
    end
    --]]
    
    cm:force_change_cai_faction_personality("ovn_arb_aswad_scythans", "ovn_arb_aswad_scythans")
    
    --change the campaign settlement model used (Okay, maybe not for fatty)
	--cm:override_building_chain_display("wh2_dlc09_tmb_settlement_minor", "ovn_arb_settlement_minor", "wh3_main_combi_region_quatar")
	
    local target_region = cm:get_region("wh3_main_combi_region_karag_orrud")
    cm:transfer_region_to_faction("wh3_main_combi_region_karag_orrud", "ovn_arb_aswad_scythans")
	cm:instantly_set_settlement_primary_slot_level(target_region:settlement(), 2)
	local target_slot = target_region:slot_list():item_at(1)
    cm:instantly_upgrade_building_in_region(target_slot, "ovn_arb_nomad_cavalry_1")
	cm:heal_garrison(target_region:cqi());
	
	--locking technology so it won't make available tech popup
	cm:lock_technology(aswad_scythans_string, "araby_tech_good_civ_0")
	cm:lock_technology(aswad_scythans_string, "araby_tech_good_mil_4")
	cm:lock_technology(aswad_scythans_string, "araby_tech_good_mil_8")

    cm:create_agent(
        "ovn_arb_aswad_scythans",
        "spy",
        "arb_nomad",
		726, -- x,
		309, -- y,
        false,
        function(cqi)
            cm:replenish_action_points(cm:char_lookup_str(cqi))
        end
    )
    
          if aswad_scythans:is_human() then
          cm:create_force_with_general(
				"wh2_main_grn_arachnos",
                "wh_dlc06_grn_mon_spider_hatchlings_0,wh_dlc06_grn_mon_spider_hatchlings_0,wh_dlc06_grn_inf_squig_herd_0,wh_main_grn_cav_goblin_wolf_riders_0,wh_main_grn_inf_orc_boyz",
				"wh3_main_combi_region_quatar",
                735, -- x,
                308, -- y,
				"general",
				"wh_main_grn_orc_warboss",
				"",
				"",
				"",
				"",
				false,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, -1, true)
					cm:disable_movement_for_character("character_cqi:" .. cqi)
				end
			)
    
		cm:force_declare_war("wh2_main_grn_arachnos", "ovn_arb_aswad_scythans", false, false)

      end

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
            aswad_scythans,
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
    
    
    
    
    cm:add_event_restricted_unit_record_for_faction("ovn_arb_mon_desert_spirit_ror", aswad_scythans_string, "rhox_araby_allegiance_lock")
    cm:add_event_restricted_unit_record_for_faction("ovn_arb_mon_fire_efreet_ror", aswad_scythans_string, "rhox_araby_allegiance_lock")
    cm:add_event_restricted_unit_record_for_faction("ovn_arb_mon_sea_nymph_ror", aswad_scythans_string, "rhox_araby_allegiance_lock")
    cm:add_event_restricted_unit_record_for_faction("ovn_arb_mon_tempest_djinn_ror", aswad_scythans_string, "rhox_araby_allegiance_lock")
    
    
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
            if aswad_scythans:is_human() then
                cm:show_message_event(
                    aswad_scythans_string,
                    "event_feed_strings_text_wh2_scripted_event_how_they_play_title",
                    "factions_screen_name_" .. aswad_scythans_string,
                    "event_feed_strings_text_ovn_araby_how_they_play_fatandira",
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
            mixer_set_faction_trait("ovn_arb_aswad_scythans", "ovn_lord_trait_arb_aswad_scythans", true)
        end)
		if cm:is_new_game() then
			if cm:get_campaign_name() == "main_warhammer" then
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