local function spawn_new_force()
	cm:create_force_with_general(
		"ovn_fim_tendrils_of_doom", -- faction_key,
		"fim_mon_fianna_fimm,fim_mon_fenbeast,ovn_fim_mon_bog_octopus_0,fim_inf_shearl,fim_inf_shearl,fim_inf_shearl_javelineer", -- unit_list,
		"wh3_main_combi_region_monument_of_the_moon", -- region_key,
		137, -- x,
		456, -- y,
		"general", -- type,
		"fim_daemon_octopus_kroll", -- subtype,
		"names_name_999982440", -- name1,
		"", -- name2,
		"", -- name3,
		"", -- name4,
		true,-- make_faction_leader,
        function(cqi) -- callback
            local str = "character_cqi:" .. cqi
            cm:set_character_immortality(str, true);
            cm:set_character_unique(str, true);
            cm:replenish_action_points(cm:char_lookup_str(cqi))
        end
	)
end

local function new_game_startup()
    local tendrils_of_doom_string = "ovn_fim_tendrils_of_doom"
	local tendrils_of_doom = cm:get_faction(tendrils_of_doom_string)

    if not tendrils_of_doom then return end

    local to_kill_cqi = nil
    local mixer_tendrils_of_doom_leader = tendrils_of_doom:faction_leader()

	if mixer_tendrils_of_doom_leader and not mixer_tendrils_of_doom_leader:is_null_interface() then
		to_kill_cqi = mixer_tendrils_of_doom_leader:command_queue_index()
	end

    spawn_new_force()

    local monument_of_the_moon = cm:get_region("wh3_main_combi_region_monument_of_the_moon")
    cm:transfer_region_to_faction("wh3_main_combi_region_monument_of_the_moon", "ovn_fim_tendrils_of_doom")
	cm:instantly_set_settlement_primary_slot_level(monument_of_the_moon:settlement(), 3)
	cm:heal_garrison(monument_of_the_moon:cqi());

    cm:create_agent(
        "ovn_fim_tendrils_of_doom",
        "wizard",
        "elo_boglar_shaman",
		132, -- x,
		454, -- y,
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
        "fim_inf_fimm_warriors_axe_throwers_ror",
		"fim_mon_gharnus_daemon_ror",
		"fim_inf_killing_eye_ror",
		"fim_mon_daemonomaniac_ror",
		"fim_cav_marsh_hornets_ror",
		"fim_inf_moor_hounds_ror",
    }

    for _, unit in ipairs(units) do
        cm:add_unit_to_faction_mercenary_pool(
            tendrils_of_doom,
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

local get_num_temples = function(faction)
    local num_temples = 0

    ---@type CA_REGION
    for _, region in model_pairs(faction:region_list()) do
        ---@type CA_SLOT
        for _, slot in model_pairs(region:slot_list()) do
            if slot and slot:has_building() then
                local building_key = slot:building():name()
                if building_key == "ovn_fimir_temple_kroll_1" then
                    num_temples = num_temples + 1
                end
            end
        end
    end

    return num_temples
end

local give_kroll_god_bonuses = function(faction)
    local num_temples = get_num_temples(faction)

    local army_bundle_name = "ovn_fimir_kroll_bundle_1"
    local faction_bundle_name = "ovn_fimir_kroll_bundle_faction_1"

    cm:remove_effect_bundle("ovn_fimir_kroll_bundle_faction_1", faction:name())
    cm:remove_effect_bundle("ovn_fimir_kroll_bundle_faction_2", faction:name())
    cm:remove_effect_bundle("ovn_fimir_kroll_bundle_faction_3", faction:name())
    cm:remove_effect_bundle("ovn_fimir_kroll_bundle_faction_4", faction:name())

    if num_temples > 29 then
        army_bundle_name = "ovn_fimir_kroll_bundle_4"
        faction_bundle_name = "ovn_fimir_kroll_bundle_faction_4"
    elseif num_temples > 19 then
        army_bundle_name = "ovn_fimir_kroll_bundle_3"
        faction_bundle_name = "ovn_fimir_kroll_bundle_faction_3"
    elseif num_temples > 9 then
        army_bundle_name = "ovn_fimir_kroll_bundle_2"
        faction_bundle_name = "ovn_fimir_kroll_bundle_faction_2"
    end

    local army_custom_bundle = cm:create_new_custom_effect_bundle(army_bundle_name)
    local faction_custom_bundle = cm:create_new_custom_effect_bundle(faction_bundle_name)

    faction_custom_bundle:add_effect("ovn_fimir_kroll_army_bonuses_dummy", "faction_to_faction_own_unseen", 1)

    if num_temples >= 25 then
        army_custom_bundle:add_effect("wh_main_effect_force_stat_leadership", "character_to_force_own", 8)
        army_custom_bundle:add_effect("wh_main_effect_force_stat_weapon_strength", "character_to_force_own", 15)
        army_custom_bundle:add_effect("ovn_fimir_kroll_dmg_reflect_enable", "character_to_force_own", 1)

        faction_custom_bundle:add_effect("ovn_fimir_diplomacy_bonus_all_fimir", "faction_to_faction_own_unseen", 40)
        faction_custom_bundle:add_effect("ovn_fimir_kroll_god_dummy_4", "faction_to_faction_own_unseen", 1)
    elseif num_temples >= 15 then
        army_custom_bundle:add_effect("wh_main_effect_force_stat_leadership", "character_to_force_own", 6)
        army_custom_bundle:add_effect("wh_main_effect_force_stat_weapon_strength", "character_to_force_own", 10)

        faction_custom_bundle:add_effect("ovn_fimir_diplomacy_bonus_all_fimir", "faction_to_faction_own_unseen", 20)
        faction_custom_bundle:add_effect("ovn_fimir_kroll_god_dummy_3", "faction_to_faction_own_unseen", 1)
        faction_custom_bundle:add_effect("ovn_fimir_kroll_god_dummy_4", "faction_to_faction_own_unseen", -1)
    elseif num_temples >= 5 then
        army_custom_bundle:add_effect("wh_main_effect_force_stat_leadership", "character_to_force_own", 4)
        army_custom_bundle:add_effect("wh_main_effect_force_stat_weapon_strength", "character_to_force_own", 5)

        faction_custom_bundle:add_effect("ovn_fimir_diplomacy_bonus_all_fimir", "faction_to_faction_own_unseen", 10)
        faction_custom_bundle:add_effect("ovn_fimir_kroll_god_dummy_2", "faction_to_faction_own_unseen", 1)
        faction_custom_bundle:add_effect("ovn_fimir_kroll_god_dummy_3", "faction_to_faction_own_unseen", -1)
        faction_custom_bundle:add_effect("ovn_fimir_kroll_god_dummy_4", "faction_to_faction_own_unseen", -1)
    else
        army_custom_bundle:add_effect("wh_main_effect_force_stat_leadership", "character_to_force_own", 2)

        faction_custom_bundle:add_effect("ovn_fimir_kroll_god_dummy_1", "faction_to_faction_own_unseen", 1)
        faction_custom_bundle:add_effect("ovn_fimir_kroll_god_dummy_2", "faction_to_faction_own_unseen", -1)
        faction_custom_bundle:add_effect("ovn_fimir_kroll_god_dummy_3", "faction_to_faction_own_unseen", -1)
        faction_custom_bundle:add_effect("ovn_fimir_kroll_god_dummy_4", "faction_to_faction_own_unseen", -1)
    end

    cm:apply_custom_effect_bundle_to_faction(faction_custom_bundle, faction)

    ---@type CA_CHAR
    local char = faction:faction_leader()
    if char:has_military_force() then
        cm:remove_effect_bundle_from_character("ovn_fimir_kroll_bundle_1", char)
        cm:remove_effect_bundle_from_character("ovn_fimir_kroll_bundle_2", char)
        cm:remove_effect_bundle_from_character("ovn_fimir_kroll_bundle_3", char)
        cm:remove_effect_bundle_from_character("ovn_fimir_kroll_bundle_4", char)

        cm:apply_custom_effect_bundle_to_character(army_custom_bundle, char)
    end
end

local function on_every_first_tick()
    local kroll_faction = cm:get_faction("ovn_fim_tendrils_of_doom")
    if kroll_faction and kroll_faction:is_human() then
        give_kroll_god_bonuses(kroll_faction)
    end

    core:remove_listener("ovn_fimir_kroll_god_bonuses_on_kroll_selected")
    core:add_listener(
        "ovn_fimir_kroll_god_bonuses_on_kroll_selected",
        "CharacterSelected",
        function(context)
            ---@type CA_CHAR
            local char = context:character()
            return char:character_subtype_key() == "fim_daemon_octopus_kroll" and char:faction():is_human()
        end,
        function(context)
            local char = context:character()
            give_kroll_god_bonuses(char:faction())
        end,
        true
    )
    
    core:remove_listener("ovn_fimir_kroll_god_bonuses_on_turn_start")
    core:add_listener(
        "ovn_fimir_kroll_god_bonuses_on_turn_start",
        "FactionTurnStart",
        function(context)
            local faction = context:faction()
            return faction:name() == "ovn_fim_tendrils_of_doom"
        end,
        function(context)
            local faction = context:faction()
            give_kroll_god_bonuses(faction)
        end,
        true
    )    
end


cm:add_first_tick_callback(
	function()
        if cm:get_campaign_name() == "main_warhammer" then
            cm:callback(function()
                pcall(function()
                    mixer_set_faction_trait("ovn_fim_tendrils_of_doom", "ovn_tendrils_doom_faction_trait", true)
                end)

                on_every_first_tick()

                if cm:is_new_game() then
                    
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
                
            end, 3)
        end
	end
)
