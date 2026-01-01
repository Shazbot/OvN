local function spawn_new_force()
	cm:create_force_with_general(
		"ovn_arb_golden_fleet", -- faction_key,
		"ovn_arb_inf_corsairs,ovn_arb_inf_corsairs,ovn_arb_cav_flying_carpets,ovn_arb_inf_arabyan_bowmen,ovn_arb_mon_enchanted_rope,ovn_arb_inf_arabyan_bowmen,wh3_main_ogr_inf_maneaters_3", -- unit_list,
		"wh3_main_combi_region_the_copper_landing", -- region_key,
		104, -- x,
		168, -- y,
		"general", -- type,
		"arb_golden_magus", -- subtype,
		"names_name_999982318", -- name1,
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
    local golden_fleet_string = "ovn_arb_golden_fleet"
	local golden_fleet = cm:get_faction(golden_fleet_string)

    if not golden_fleet then return end

    local to_kill_cqi = nil
    local mixer_golden_fleet_leader = golden_fleet:faction_leader()

	if mixer_golden_fleet_leader and not mixer_golden_fleet_leader:is_null_interface() then
		to_kill_cqi = mixer_golden_fleet_leader:command_queue_index()
	end

    spawn_new_force()
    
    cm:force_change_cai_faction_personality("ovn_arb_golden_fleet", "ovn_arb_golden_fleet")
    
    --change the campaign settlement model used ("Copper Landing" isn't really a real settlement in lore, so I don't think it's a problem to just make it an Arabyan-themed pirate hideout)
	cm:override_building_chain_display("wh2_main_lzd_settlement_minor", "ovn_arb_settlement_minor", "wh3_main_combi_region_the_copper_landing")
	
    local the_copper_landing = cm:get_region("wh3_main_combi_region_the_copper_landing")
    cm:transfer_region_to_faction("wh3_main_combi_region_the_copper_landing", "ovn_arb_golden_fleet")
	cm:instantly_set_settlement_primary_slot_level(the_copper_landing:settlement(), 2)
	local target_slot = the_copper_landing:slot_list():item_at(2)
    cm:instantly_upgrade_building_in_region(target_slot, "ovn_arb_slaves_1")
	cm:heal_garrison(the_copper_landing:cqi());
	
	--locking technology so it won't make available tech popup
	cm:lock_technology(golden_fleet_string, "araby_tech_good_mil_4")
	cm:lock_technology(golden_fleet_string, "araby_tech_good_mil_8")

    cm:create_agent(
        "ovn_arb_golden_fleet",
        "wizard",
        "arb_magician_desert",
		103,
		167,
        false,
        function(cqi)
            cm:replenish_action_points(cm:char_lookup_str(cqi))
        end
    )
    
          if golden_fleet:is_human() then
          cm:create_force_with_general(
				"wh3_main_tmb_deserters_of_khatep",
                "wh2_dlc09_tmb_mon_sepulchral_stalkers_0,wh2_dlc09_tmb_mon_ushabti_0,wh2_dlc09_tmb_inf_skeleton_warriors_0,wh2_dlc09_tmb_inf_skeleton_archers_0",
				"wh3_main_combi_region_the_copper_landing",
                97,
                172,
				"general",
				"wh2_dlc09_tmb_tomb_king",
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
    
		cm:force_declare_war("wh3_main_tmb_deserters_of_khatep", "ovn_arb_golden_fleet", false, false)

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
            golden_fleet,
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
    
    cm:add_event_restricted_unit_record_for_faction("ovn_arb_mon_desert_spirit_ror", golden_fleet_string, "rhox_araby_pieces_of_eight_lock")
    cm:add_event_restricted_unit_record_for_faction("ovn_arb_mon_fire_efreet_ror", golden_fleet_string, "rhox_araby_pieces_of_eight_lock")
    cm:add_event_restricted_unit_record_for_faction("ovn_arb_mon_sea_nymph_ror", golden_fleet_string, "rhox_araby_pieces_of_eight_lock")
    cm:add_event_restricted_unit_record_for_faction("ovn_arb_mon_tempest_djinn_ror", golden_fleet_string, "rhox_araby_pieces_of_eight_lock")
    
    
    
    local rhox_tze_units = {
        "ovn_arb_tze_inf_pink_horrors_0",
		"ovn_arb_tze_mon_screamers_0",
		"ovn_arb_tze_mon_flamers_0",
		"ovn_arb_tze_inf_blue_horrors_0"
    }

    
    for _, unit in ipairs(rhox_tze_units) do
        cm:add_unit_to_faction_mercenary_pool(
            golden_fleet,
            unit,
            "",
            0,
            0,
            10,
            0,
            frr,
            srr,
            trr,
            true,
            unit.."_rhox_ovn_araby"
        )
    end
    
    
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
            if golden_fleet:is_human() then
                cm:show_message_event(
                    golden_fleet_string,
                    "event_feed_strings_text_wh2_scripted_event_how_they_play_title",
                    "factions_screen_name_" .. golden_fleet_string,
                    "event_feed_strings_text_ovn_araby_how_they_play_gm",
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
            mixer_set_faction_trait("ovn_arb_golden_fleet", "ovn_lord_trait_arb_golden_fleet", true)
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