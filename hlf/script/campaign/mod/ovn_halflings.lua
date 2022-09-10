local function spawn_new_force()
	cm:create_force_with_general(
		"ovn_hlf_the_moot", -- faction_key,
		"halfling_archer,ovn_mtl_cav_poultry_riders_0,sr_ogre,halfling_cook,halfling_spear,halfling_inf", -- unit_list,
		"wh3_main_combi_region_the_moot", -- region_key,
		644, -- x,
		600, -- y,
		"general", -- type,
		"ovn_hlf_glibfoot", -- subtype,
		"names_name_999982316", -- name1,
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
    local moot_string = "ovn_hlf_the_moot"
	local moot = cm:get_faction(moot_string)

    if not moot then return end

    local to_kill_cqi = nil
    local mixer_moot_leader = moot:faction_leader()

	if mixer_moot_leader and not mixer_moot_leader:is_null_interface() then
		to_kill_cqi = mixer_moot_leader:command_queue_index()
	end

    spawn_new_force()

    local moot_region = cm:get_region("wh3_main_combi_region_the_moot")

    cm:transfer_region_to_faction("wh3_main_combi_region_the_moot", "ovn_hlf_the_moot")
    cm:heal_garrison(moot_region:cqi());

    if moot:is_human() then
        cm:treasury_mod("ovn_hlf_the_moot", -1000)
        cm:force_alliance("ovn_hlf_the_moot", "wh_main_emp_empire", true)
    else
        cm:instantly_set_settlement_primary_slot_level(moot_region:settlement(), 3)
    end

    cm:heal_garrison(moot_region:cqi())

    cm:create_agent(
        "ovn_hlf_the_moot",
        "dignitary",
        "ovn_hlf_master_chef",
        644,
        603,
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
        "halfling_warfoot",
        "sr_ogre_ror",
        "halfling_cock",
        "wh_main_mtl_veh_soupcart",
        "halfling_cat_ror",
        "halfling_pantry_guards_ror",
        "halfling_lords_of_harvest_ror",
        "halfling_knights_kitchentable_ror",
    }

    for _, unit in ipairs(units) do
        cm:add_unit_to_faction_mercenary_pool(
            moot,
            unit,
            unit_count,
            rcp,
            max_units,
            murpt,
            xp_level,
            frr,
            srr,
            trr,
            true,
            "ovn_halflings_ror"
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