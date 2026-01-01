OVN_FIMIR_MINOR={
    spawn_ovn_fim_fen_serpents=false,
    spawn_ovn_fim_thunderous_sight=false,
    spawn_ovn_fim_hell_gate=false,
    extra_region_ovn_fim_marsh_hornets = false,
    extra_region_ovn_fim_mist_dragons = false,
}


core:add_listener(
    "rhox_ovn_fimir_mct_initialize",
    "MctInitialized",
    true,
    function(context)
        -- get the mct object
        local mct = context:mct()
        local my_mod = mct:get_mod_by_key("ovn_fimir")

        local rhox_ovn_fim_fen_serpents = my_mod:get_option_by_key("rhox_ovn_fim_fen_serpents")
        local rhox_ovn_fim_fen_serpents_setting = rhox_ovn_fim_fen_serpents:get_finalized_setting()
        OVN_FIMIR_MINOR.spawn_ovn_fim_fen_serpents=rhox_ovn_fim_fen_serpents_setting
        
        -- Marsh Hornets (extra region)
        local rhox_ovn_fim_marsh_hornets = my_mod:get_option_by_key("rhox_ovn_fim_marsh_hornets")
        local rhox_ovn_fim_marsh_hornets_setting = rhox_ovn_fim_marsh_hornets:get_finalized_setting()
        OVN_FIMIR_MINOR.extra_region_ovn_fim_marsh_hornets=rhox_ovn_fim_marsh_hornets_setting        
        
        -- Mist Dragons (extra region)
        local rhox_ovn_fim_mist_dragons = my_mod:get_option_by_key("rhox_ovn_fim_mist_dragons")
        local rhox_ovn_fim_mist_dragons_setting = rhox_ovn_fim_mist_dragons:get_finalized_setting()
        OVN_FIMIR_MINOR.extra_region_ovn_fim_mist_dragons=rhox_ovn_fim_mist_dragons_setting          
        
        if vfs.exists("script/campaign/mod/cr_iee_mixer_unlocker.lua") then
            local rhox_ovn_fim_thunderous_sight = my_mod:get_option_by_key("rhox_ovn_fim_thunderous_sight")
            local rhox_ovn_fim_thunderous_sight_setting = rhox_ovn_fim_thunderous_sight:get_finalized_setting()
            OVN_FIMIR_MINOR.spawn_ovn_fim_thunderous_sight=rhox_ovn_fim_thunderous_sight_setting
            
            local rhox_ovn_fim_hell_gate = my_mod:get_option_by_key("rhox_ovn_fim_hell_gate")
            local rhox_ovn_fim_hell_gate_setting = rhox_ovn_fim_hell_gate:get_finalized_setting()
            OVN_FIMIR_MINOR.spawn_ovn_fim_hell_gate=rhox_ovn_fim_hell_gate_setting
        end

    end,
    true
)

cm:add_first_tick_callback_new(
	function()
        core:add_listener(
            "rhox_ovn_fimir_mct_changed",
            "MctOptionSettingFinalized",
            true,
            function(context)
                -- get the mct object
                local mct = context:mct()
                local my_mod = mct:get_mod_by_key("ovn_fimir")

                local rhox_ovn_fim_fen_serpents = my_mod:get_option_by_key("rhox_ovn_fim_fen_serpents")
                local rhox_ovn_fim_fen_serpents_setting = rhox_ovn_fim_fen_serpents:get_finalized_setting()
                OVN_FIMIR_MINOR.spawn_ovn_fim_fen_serpents=rhox_ovn_fim_fen_serpents_setting
                
                if vfs.exists("script/campaign/mod/cr_iee_mixer_unlocker.lua") then
                    local rhox_ovn_fim_thunderous_sight = my_mod:get_option_by_key("rhox_ovn_fim_thunderous_sight")
                    local rhox_ovn_fim_thunderous_sight_setting = rhox_ovn_fim_thunderous_sight:get_finalized_setting()
                    OVN_FIMIR_MINOR.spawn_ovn_fim_thunderous_sight=rhox_ovn_fim_thunderous_sight_setting
                    
                    local rhox_ovn_fim_hell_gate = my_mod:get_option_by_key("rhox_ovn_fim_hell_gate")
                    local rhox_ovn_fim_hell_gate_setting = rhox_ovn_fim_hell_gate:get_finalized_setting()
                    OVN_FIMIR_MINOR.spawn_ovn_fim_hell_gate=rhox_ovn_fim_hell_gate_setting
                end
            end,
            true
        )
        if OVN_FIMIR_MINOR.spawn_ovn_fim_fen_serpents then
            local faction_string = "ovn_fim_fen_serpents"
            local fen_serpents = cm:get_faction(faction_string)
	
            cm:create_force_with_general(
                faction_string,
                "fim_inf_fimm_warriors,fim_inf_fimm_warriors_great_weapons,fim_inf_swamp_daemons,fim_inf_shearl,fim_inf_shearl,fim_inf_shearl_javelineer", -- unit_list,
                "wh3_main_combi_region_axlotl", -- region_key,
                202, -- x,
                236, -- y,
                "general", -- type,
                "aky_chief_fimir_great_weapons", -- subtype,
                "names_name_999982422", -- name1,
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
            
    
            cm:transfer_region_to_faction("wh3_main_combi_region_axlotl", faction_string)
            local region = cm:get_region("wh3_main_combi_region_axlotl")
            cm:instantly_set_settlement_primary_slot_level(region:settlement(), 2)
            cm:instantly_upgrade_building_in_region(region:slot_list():item_at(1), "ovn_fimir_infantry_1")
            cm:heal_garrison(region:cqi())

            cm:transfer_region_to_faction("wh3_main_combi_region_the_blood_swamps", faction_string)
            local blood_swamps = cm:get_region("wh3_main_combi_region_the_blood_swamps")
            cm:instantly_set_settlement_primary_slot_level(blood_swamps:settlement(), 2)
            cm:instantly_upgrade_building_in_region(blood_swamps:slot_list():item_at(1), "ovn_fimir_port_1")
            cm:heal_garrison(blood_swamps:cqi())
            
            cm:callback(function()
                local faction = cm:get_faction("ovn_fim_fen_serpents")
                if faction and not faction:is_null_interface() then
                    cm:force_change_cai_faction_personality("ovn_fim_fen_serpents", "wh3_combi_norsca_minor")
                    out(">>> [OVN Fimir] CAI personality applied to Hell Gate")
                end
            end, 2.0)
            
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
                    fen_serpents,
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
        end
    end
)