local function spawn_new_force()
	cm:create_force_with_general(
		"ovn_fim_mist_dragons", -- faction_key,
		"fim_inf_fimm_warriors,fim_mon_fianna_fimm,fim_inf_fimm_warriors,fim_inf_shearl,fim_inf_shearl,fim_inf_shearl_javelineer", -- unit_list,
		"cr_oldworld_region_black_bog", -- region_key,
		165, -- x,
		1309, -- y,
		"general", -- type,
		"aky_chief_fimir_great_weapons", -- subtype,
		"names_name_999982386", -- name1,
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
    local mist_dragons_string = "ovn_fim_mist_dragons"
	local mist_dragons = cm:get_faction(mist_dragons_string)

    if not mist_dragons then return end

    local to_kill_cqi = nil
    local mixer_mist_dragons_leader = mist_dragons:faction_leader()

	if mixer_mist_dragons_leader and not mixer_mist_dragons_leader:is_null_interface() then
		to_kill_cqi = mixer_mist_dragons_leader:command_queue_index()
	end

    spawn_new_force()

    local black_bog = cm:get_region("cr_oldworld_region_black_bog")
    cm:transfer_region_to_faction("cr_oldworld_region_black_bog", "ovn_fim_mist_dragons")
	cm:instantly_set_settlement_primary_slot_level(black_bog:settlement(), 3)
		cm:instantly_upgrade_building_in_region(black_bog:slot_list():item_at(2), "ovn_fimir_infantry_1")
	cm:heal_garrison(black_bog:cqi());
	

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
            mist_dragons,
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
            local str = "character_cqi:" .. to_kill_cqi
            cm:set_character_immortality(str, false)
            cm:kill_character_and_commanded_unit(str, true)
        end
    end, 0)
end



cm:add_first_tick_callback(
	function()
		if cm:is_new_game() then
			if cm:get_campaign_name() == "cr_oldworldclassic" then
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