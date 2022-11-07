local function spawn_new_force()
	cm:create_force_with_general(
		"ovn_fim_marsh_hornets", -- faction_key,
		"fim_inf_fimm_warriors,fim_cav_marsh_hornets_ror,fim_inf_fimm_warriors,fim_inf_moor_hounds,fim_inf_shearl,fim_inf_shearl_javelineer", -- unit_list,
		"wh3_main_combi_region_desolation_of_drakenmoor", -- region_key,
		842, -- x,
		612, -- y,
		"general", -- type,
		"aky_chief_fimir_great_weapons", -- subtype,
		"names_name_999982385", -- name1,
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
    local marsh_hornets_string = "ovn_fim_marsh_hornets"
	local marsh_hornets = cm:get_faction(marsh_hornets_string)

    if not marsh_hornets then return end

    local to_kill_cqi = nil
    local mixer_marsh_hornets_leader = marsh_hornets:faction_leader()

	if mixer_marsh_hornets_leader and not mixer_marsh_hornets_leader:is_null_interface() then
		to_kill_cqi = mixer_marsh_hornets_leader:command_queue_index()
	end

    spawn_new_force()

    local desolation_of_drakenmoor = cm:get_region("wh3_main_combi_region_desolation_of_drakenmoor")
    cm:transfer_region_to_faction("wh3_main_combi_region_desolation_of_drakenmoor", "ovn_fim_marsh_hornets")
	cm:instantly_set_settlement_primary_slot_level(desolation_of_drakenmoor:settlement(), 3)
	cm:heal_garrison(desolation_of_drakenmoor:cqi());
	

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
            marsh_hornets,
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