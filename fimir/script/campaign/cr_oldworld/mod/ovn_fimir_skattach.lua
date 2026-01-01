local function spawn_new_force()
	cm:create_force_with_general(
		"ovn_fim_rancor_hold", -- faction_key,
		"fim_inf_swamp_daemons,fim_cav_nuckelavee,fim_veh_eye_oculus,fim_inf_shearl,fim_inf_shearl,fim_inf_shearl_javelineer", -- unit_list,
		"cr_oldworld_region_vorbegwerk", -- region_key,
		751, -- x,
		1297, -- y,
		"general", -- type,
		"fim_meargh_skattach", -- subtype,
		"names_name_999982314", -- name1,
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
    local rancor_hold_string = "ovn_fim_rancor_hold"
	local rancor_hold = cm:get_faction(rancor_hold_string)

    if not rancor_hold then return end

    local to_kill_cqi = nil
    local mixer_rancor_hold_leader = rancor_hold:faction_leader()

	if mixer_rancor_hold_leader and not mixer_rancor_hold_leader:is_null_interface() then
		to_kill_cqi = mixer_rancor_hold_leader:command_queue_index()
	end

    spawn_new_force()

    local vorbegwerk = cm:get_region("cr_oldworld_region_vorbegwerk")
    cm:transfer_region_to_faction("cr_oldworld_region_vorbegwerk", "ovn_fim_rancor_hold")
	cm:instantly_set_settlement_primary_slot_level(vorbegwerk:settlement(), 3)
		cm:instantly_upgrade_building_in_region(vorbegwerk:slot_list():item_at(2), "ovn_fimir_infantry_1")
	cm:heal_garrison(vorbegwerk:cqi());
    cm:force_declare_war("wh_main_emp_middenland", "ovn_fim_rancor_hold", false, false)
    
    local champion_agent = cm:create_agent(
        "ovn_fim_rancor_hold",
        "champion",
        "fim_finmor",
        750, -- x,
		1300
    )
    if champion_agent then
        cm:replenish_action_points(cm:char_lookup_str(champion_agent))
    end

    local unit_count = 1 -- card32 count
    local rcp = 20 -- float32 replenishment_chance_percentage
    local max_units = 1 -- int32 max_units
    local murpt = 0.1 -- float32 max_units_replenished_per_turn
    local xp_level = 0 -- card32 xp_level
    local frr = "" -- (may be empty) String faction_restricted_record
    local srr = "" -- (may be empty) String subculture_restricted_record
    local trr = "" -- (may be empty) String tech_restricted_record
    local units = {
        "fim_inf_fimm_warriors_axe_throwers_ror",
		"fim_mon_gharnus_daemon_ror",
		"fim_inf_killing_eye_ror",
		"fim_mon_daemonomaniac_ror",
		"fim_cav_marsh_hornets_ror",
		"fim_inf_moor_hounds_ror",
    }

    for _, unit in ipairs(units) do
        cm:add_unit_to_faction_mercenary_pool(
            rancor_hold,
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
    
    cm:callback(function()
        if to_kill_cqi then
            cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
            local str = "character_cqi:" .. to_kill_cqi
            cm:set_character_immortality(str, false)
            cm:kill_character_and_commanded_unit(str, true)
        end
    end, 0)
    cm:callback(function() 
        cm:disable_event_feed_events(false, "", "", "wh_event_category_character") 
    end, 0.2);

    cm:callback(
        function()
            if rancor_hold:is_human() then
                cm:show_message_event(
                    rancor_hold_string,
                    "event_feed_strings_text_wh2_scripted_event_how_they_play_title",
                    "factions_screen_name_" .. rancor_hold_string,
                    "event_feed_strings_text_ovn_fimir_how_they_play_skattach",
                    true,
                    2512
                )
            end
        end,
        1
    )
end

cm:add_first_tick_callback(
	function()
        mixer_set_faction_trait("ovn_fim_rancor_hold", "ovn_lord_trait_fim_skattach", true)
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