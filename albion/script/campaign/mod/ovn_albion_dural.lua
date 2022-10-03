local function spawn_new_force()
	cm:create_force_with_general(
		"ovn_alb_order_of_the_truthsayers", -- faction_key,
		"elo_youngbloods,albion_giant,druid_neophytes,elo_albion_warriors,albion_hearthguard,albion_riders_spear", -- unit_list,
		"wh3_main_combi_region_citadel_of_lead", -- region_key,
		350, -- x,
		761, -- y,
		"general", -- type,
		"bl_elo_dural_durak", -- subtype,
		"names_name_77777202", -- name1,
		"", -- name2,
		"names_name_77777201", -- name3,
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
    local order_of_the_truthsayers_string = "ovn_alb_order_of_the_truthsayers"
	local order_of_the_truthsayers = cm:get_faction(order_of_the_truthsayers_string)

    if not order_of_the_truthsayers then return end

    local to_kill_cqi = nil
    local mixer_order_of_the_truthsayers_leader = order_of_the_truthsayers:faction_leader()

	if mixer_order_of_the_truthsayers_leader and not mixer_order_of_the_truthsayers_leader:is_null_interface() then
		to_kill_cqi = mixer_order_of_the_truthsayers_leader:command_queue_index()
	end

    spawn_new_force()

    local shadowlegion = cm:get_faction("wh3_main_chs_shadow_legion")
    if not shadowlegion:is_human() then
    cm:teleport_to("faction:wh3_main_chs_shadow_legion", 415, 850, true)
    cm:teleport_to("faction:wh3_main_chs_shadow_legion,forename:2147353848", 419, 848, true)
    custom_starts:force_diplomacy_change("wh3_dlc20_tze_the_sightless","wh3_main_chs_shadow_legion","peace")
    cm:teleport_to("faction:wh3_dlc20_tze_the_sightless", 344, 755, true)
    if  not order_of_the_truthsayers:is_human() then
        cm:transfer_region_to_faction("wh3_main_combi_region_konquata", "ovn_alb_order_of_the_truthsayers")
    end
    end

    local citadel_of_lead = cm:get_region("wh3_main_combi_region_citadel_of_lead")
    cm:transfer_region_to_faction("wh3_main_combi_region_citadel_of_lead", "ovn_alb_order_of_the_truthsayers")
	cm:instantly_set_settlement_primary_slot_level(citadel_of_lead:settlement(), 3)
	cm:heal_garrison(citadel_of_lead:cqi());

    cm:create_agent(
        "ovn_alb_order_of_the_truthsayers",
        "wizard",
        "albion_wyrd_druid",
        353,
        761,
        false,
        function(cqi)
            cm:replenish_action_points(cm:char_lookup_str(cqi))
        end
    )
   
  cm:change_corruption_in_province_by("wh3_main_combi_province_albion","wh3_main_corruption_tzeentch", -40, "events")

    local unit_count = 1 -- card32 count
    local rcp = 20 -- float32 replenishment_chance_percentage
    local max_units = 1 -- int32 max_units
    local murpt = 0.1 -- float32 max_units_replenished_per_turn
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
            order_of_the_truthsayers,
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

local function ovn_albion_weather()
        if cm:get_campaign_name() == "main_warhammer" then
            
            core:add_listener(
            "ovn_albion_weather",
            "FactionTurnStart",
            function(context)
                return context:faction():is_human();
            end,
            function(context)
                local random_number = cm:random_number(12,1)

                if random_number == 1 then
                    cm:create_storm_for_region("wh3_main_combi_region_konquata", 1, 1, "ovn_albion_storm")
                elseif random_number == 2 then
                    cm:create_storm_for_region("wh3_main_combi_region_citadel_of_lead", 1, 1, "ovn_albion_storm")
                elseif random_number == 3 then
                    cm:create_storm_for_region("wh3_main_combi_region_isle_of_wights", 1, 1, "ovn_albion_storm")
                end
            end,
            true
        )
        end
end

cm:add_first_tick_callback(function() ovn_albion_weather() end);

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