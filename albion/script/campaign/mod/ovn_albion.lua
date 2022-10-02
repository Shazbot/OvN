local function spawn_new_force()
	cm:create_force_with_general(
		"ovn_alb_host_ravenqueen", -- faction_key,
		"elo_youngbloods,albion_giant,albion_swordmaiden,elo_albion_warriors,albion_hearthguard,albion_riders_spear", -- unit_list,
		"wh3_main_combi_region_the_folly_of_malofex", -- region_key,
		466, -- x,
		907, -- y,
		"general", -- type,
		"albion_morrigan", -- subtype,
		"names_name_77777001", -- name1,
		"", -- name2,
		"names_name_77777002", -- name3,
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
    local ravenqueen_host_string = "ovn_alb_host_ravenqueen"
	local ravenqueen_host = cm:get_faction(ravenqueen_host_string)

    if not ravenqueen_host then return end

    local to_kill_cqi = nil
    local mixer_ravenqueen_host_leader = ravenqueen_host:faction_leader()

	if mixer_ravenqueen_host_leader and not mixer_ravenqueen_host_leader:is_null_interface() then
		to_kill_cqi = mixer_ravenqueen_host_leader:command_queue_index()
	end

    spawn_new_force()

    local folly_of_malofex = cm:get_region("wh3_main_combi_region_the_folly_of_malofex")
    cm:transfer_region_to_faction("wh3_main_combi_region_the_folly_of_malofex", "ovn_alb_host_ravenqueen")
	cm:instantly_set_settlement_primary_slot_level(folly_of_malofex:settlement(), 3)
	cm:heal_garrison(folly_of_malofex:cqi());

    cm:create_agent(
        "ovn_alb_host_ravenqueen",
        "champion",
        "albion_chief",
        465,
        906,
        false,
        function(cqi)
            cm:replenish_action_points(cm:char_lookup_str(cqi))
        end
    )

    local unit_count = 1 -- card32 count
    local rcp = 20 -- float32 replenishment_chance_percentage
    local max_units = 1 -- int32 max_units
    local murpt = 0.1 -- float32 max_units_replenished_per_turn
    local xp_level = 0 -- card32 xp_level
    local frr = "" -- (may be empty) String faction_restricted_record
    local srr = "" -- (may be empty) String subculture_restricted_record
    local trr = "" -- (may be empty) String tech_restricted_record
    local units = {
        "albion_shieldmaiden_ror",
		"albion_bologs_giant_ror",
		"elo_fly_infested_rotwood",
		"albion_woadraider_sworn_ror",
		"alb_cav_noble_first_ror",
		"albion_warriors_lugh",
		"albion_huntresses_warden_ror",
		"albion_centaur_hunter_ror",
		"albion_cachtorr_stonethrower",
		"albion_highlander_ror",
    }

    
    
    
    for _, unit in ipairs(units) do
        cm:add_unit_to_faction_mercenary_pool(
            ravenqueen_host,
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