-- local function spawn_new_force()
	-- cm:create_force_with_general(
		-- "ovn_arb_sultanate_of_el_kalabad", -- faction_key,
		-- "ovn_arb_inf_arabyan_spearmen,ovn_arb_mon_elephant,ovn_arb_mon_war_elephant,ovn_arb_inf_arabyan_bowmen,ovn_arb_inf_arabyan_spearmen,ovn_arb_inf_arabyan_bowmen", -- unit_list,
		-- "wh3_main_combi_region_el_kalabad", -- region_key,
		-- 537, -- x,
		-- 275, -- y,
		-- "general", -- type,
		-- "arb_sheikh", -- subtype,
		-- "names_name_999982538", -- name1,
		-- "", -- name2,
		-- "names_name_999982539", -- name3,
		-- "", -- name4,
		-- true,-- make_faction_leader,
        -- function(cqi) -- callback
            -- local str = "character_cqi:" .. cqi
            -- cm:set_character_immortality(str, true);
            -- cm:set_character_unique(str, true);
        -- end
	-- )
-- end

-- local function new_game_startup()
    -- local sultanate_of_el_kalabad_string = "ovn_arb_sultanate_of_el_kalabad"
	-- local sultanate_of_el_kalabad = cm:get_faction(sultanate_of_el_kalabad_string)

    -- if not sultanate_of_el_kalabad then return end

    -- local to_kill_cqi = nil
    -- local mixer_sultanate_of_el_kalabad_leader = sultanate_of_el_kalabad:faction_leader()

	-- if mixer_sultanate_of_el_kalabad_leader and not mixer_sultanate_of_el_kalabad_leader:is_null_interface() then
		-- to_kill_cqi = mixer_sultanate_of_el_kalabad_leader:command_queue_index()
	-- end

    -- spawn_new_force()

    -- local el_kalabad = cm:get_region("wh3_main_combi_region_el_kalabad")
    -- cm:transfer_region_to_faction("wh3_main_combi_region_el_kalabad", "ovn_arb_sultanate_of_el_kalabad")
	-- cm:instantly_set_settlement_primary_slot_level(el_kalabad:settlement(), 3)
	-- cm:heal_garrison(el_kalabad:cqi());

    -- local unit_count = 1 -- card32 count
    -- local rcp = 20 -- float32 replenishment_chance_percentage
    -- local max_units = 1 -- int32 max_units
    -- local murpt = 0.1 -- float32 max_units_replenished_per_turn
    -- local xp_level = 0 -- card32 xp_level
    -- local frr = "" -- (may be empty) String faction_restricted_record
    -- local srr = "" -- (may be empty) String subculture_restricted_record
    -- local trr = "" -- (may be empty) String tech_restricted_record
    -- local units = {
        -- "ovn_arb_art_grand_bombard_ror",
		-- "ovn_arb_veh_naphtha_thrower_ror",
		-- "ovn_arb_cav_lancer_camels_ror",
		-- "ovn_arb_cav_arabyan_knights_ror",
		-- "ovn_arb_cav_sipahis_ror",
		-- "ovn_arb_cav_flying_carpets_ror",
		-- "ovn_arb_inf_jaguar_champions_ror",
		-- "ovn_arb_mon_war_elephant_ror_2",
		-- "ovn_arb_mon_war_elephant_ror_1",
		-- "ovn_arb_inf_jezzails_ror",
        -- "ovn_arb_inf_jezzails_ror",
        -- "ovn_arb_inf_arabyan_guard_ror"
    -- }

    
    
    
    -- for _, unit in ipairs(units) do
        -- cm:add_unit_to_faction_mercenary_pool(
            -- sultanate_of_el_kalabad,
            -- unit,
            -- unit_count,
            -- rcp,
            -- max_units,
            -- murpt,
            -- xp_level,
            -- frr,
            -- srr,
            -- trr,
            -- true,
            -- "ovn_arb_units_of_renown_pool"
        -- )
    -- end
    
    
    -- cm:callback(function()
        -- if to_kill_cqi then
            -- local str = "character_cqi:" .. to_kill_cqi
            -- cm:set_character_immortality(str, false)
            -- cm:kill_character_and_commanded_unit(str, true)
        -- end
    -- end, 0)
-- end



-- cm:add_first_tick_callback(
	-- function()
		-- if cm:is_new_game() then
			-- if cm:get_campaign_name() == "main_warhammer" then
				-- local ok, err =
					-- pcall(
					-- function()
						-- new_game_startup()
					-- end
				-- )
				-- if not ok then
					-- script_error(err)
				-- end
			-- end
		-- end
	-- end
-- )