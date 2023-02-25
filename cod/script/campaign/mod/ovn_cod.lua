local function spawn_new_force()
	cm:create_force_with_general(
		"wh2_main_hef_citadel_of_dusk", -- faction_key,
		"wh2_dlc10_hef_inf_the_storm_riders_ror_0,wh2_main_hef_inf_lothern_sea_guard_1,wh2_main_hef_mon_great_eagle,wh2_main_hef_art_eagle_claw_bolt_thrower,wh2_main_hef_inf_spearmen_0,wh2_main_hef_cav_ellyrian_reavers_1", -- unit_list,
		"wh3_main_combi_region_citadel_of_dusk", -- region_key,
		302, -- x,
		94, -- y,
		"general", -- type,
		"ovn_stormrider", -- subtype,
		"names_name_2147360164", -- name1,
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
    local citadel_of_dusk_string = "wh2_main_hef_citadel_of_dusk"
	local citadel_of_dusk = cm:get_faction(citadel_of_dusk_string)

    if not citadel_of_dusk then return end

    local to_kill_cqi = nil
    local mixer_citadel_of_dusk_leader = citadel_of_dusk:faction_leader()

	if mixer_citadel_of_dusk_leader and not mixer_citadel_of_dusk_leader:is_null_interface() then
		to_kill_cqi = mixer_citadel_of_dusk_leader:command_queue_index()
	end

    spawn_new_force()

    cm:create_agent(
        "wh2_main_hef_citadel_of_dusk",
        "wizard",
        "wh2_main_hef_mage_life",
        302,
        92,
        false,
        function(cqi)
            cm:replenish_action_points(cm:char_lookup_str(cqi))
        end
    )
    
    cm:make_region_visible_in_shroud("wh2_main_hef_citadel_of_dusk", "wh3_main_combi_region_li_zhu")
    cm:make_region_visible_in_shroud("wh2_main_hef_citadel_of_dusk", "wh3_main_combi_region_hanyu_port")

    cm:callback(function()
        if to_kill_cqi then
            local str = "character_cqi:" .. to_kill_cqi
            cm:set_character_immortality(str, false)
            cm:kill_character_and_commanded_unit(str, true)
        end
    end, 0)
end

cm:add_first_tick_callback(
	function()
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