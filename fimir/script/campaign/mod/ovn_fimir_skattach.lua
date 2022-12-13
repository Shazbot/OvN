local function spawn_new_force()
	cm:create_force_with_general(
		"ovn_fim_rancor_hold", -- faction_key,
		"fim_inf_swamp_daemons,fim_cav_nuckelavee,fim_veh_eye_oculus,fim_inf_shearl,fim_inf_shearl,fim_inf_shearl_javelineer", -- unit_list,
		"wh3_main_combi_region_wreckers_point", -- region_key,
		479, -- x,
		744, -- y,
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

    local wreckers_point = cm:get_region("wh3_main_combi_region_wreckers_point")
    cm:transfer_region_to_faction("wh3_main_combi_region_wreckers_point", "ovn_fim_rancor_hold")
	cm:instantly_set_settlement_primary_slot_level(wreckers_point:settlement(), 3)
	cm:heal_garrison(wreckers_point:cqi());

    local champion_agent = cm:create_agent(
        "ovn_fim_rancor_hold",
        "champion",
        "fim_finmor",
        475,
        744
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
    
        cm:create_force_with_general(
				"wh_main_emp_marienburg",
				"wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_crossbowmen,wh_main_emp_cav_empire_knights",
				"wh3_main_combi_region_wreckers_point",
                475,
                740,
				"general",
				"wh_main_emp_lord",
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
    
		cm:force_declare_war("wh_main_emp_marienburg", "ovn_fim_rancor_hold", false, false)
    
    
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
        mixer_set_faction_trait("ovn_fim_rancor_hold", "ovn_rancor_hold_faction_trait", true)
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
