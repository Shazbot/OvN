OVN_ARABY_MINOR={
    spawn_ind=false,
    extra_region_ovn_araby_elkalabad=false,
    spawn_cult_djinn=false,
}


core:add_listener(
    "rhox_ovn_araby_mct_initialize",
    "MctInitialized",
    true,
    function(context)
        -- get the mct object
        local mct = context:mct()
        local my_mod = mct:get_mod_by_key("ovn_araby")

        local ovn_araby_spawn_ind = my_mod:get_option_by_key("rhox_ovn_araby_minor_ind")
        local ovn_araby_spawn_ind_setting = ovn_araby_spawn_ind:get_finalized_setting()
        OVN_ARABY_MINOR.spawn_ind=ovn_araby_spawn_ind_setting
        
        -- El-Kalabad (extra regions)
        local ovn_araby_elkalabad = my_mod:get_option_by_key("rhox_ovn_araby_minor_elkalabad")
        local ovn_araby_elkalabad_setting = ovn_araby_elkalabad:get_finalized_setting()
        OVN_ARABY_MINOR.extra_region_ovn_araby_elkalabad=ovn_araby_elkalabad_setting  
        
        -- Cult of the Djinn
        local ovn_araby_cult_djinn = my_mod:get_option_by_key("rhox_ovn_araby_minor_cult_djinn")
        local ovn_araby_cult_djinn_setting = ovn_araby_cult_djinn:get_finalized_setting()
        OVN_ARABY_MINOR.spawn_cult_djinn=ovn_araby_cult_djinn_setting  
        
        --[[local ovn_araby_latency = my_mod:get_option_by_key("rhox_ovn_araby_minor_ind")
        local ovn_araby_latency_setitng = ovn_araby_latency:get_finalized_setting()
        OVN_ARABY_MINOR.latency=ovn_araby_latency_setting--]]

    end,
    true
)

cm:add_first_tick_callback_new(
	function()
        core:add_listener(
            "rhox_ovn_araby_mct_changed",
            "MctOptionSettingFinalized",
            true,
            function(context)
                local mct = context:mct()
                local my_mod = mct:get_mod_by_key("ovn_araby")

                local ovn_araby_spawn_ind = my_mod:get_option_by_key("rhox_ovn_araby_minor_ind")
                local ovn_araby_spawn_ind_setting = ovn_araby_spawn_ind:get_finalized_setting()
                OVN_ARABY_MINOR.spawn_ind=ovn_araby_spawn_ind_setting

                -- El-Kalabad (extra regions)
                local ovn_araby_elkalabad = my_mod:get_option_by_key("rhox_ovn_araby_minor_elkalabad")
                local ovn_araby_elkalabad_setting = ovn_araby_elkalabad:get_finalized_setting()
                OVN_ARABY_MINOR.extra_region_ovn_araby_elkalabad=ovn_araby_elkalabad_setting
                
                -- Cult of the Djinn
                local ovn_araby_cult_djinn = my_mod:get_option_by_key("rhox_ovn_araby_minor_cult_djinn")
                local ovn_araby_cult_djinn_setting = ovn_araby_cult_djinn:get_finalized_setting()
                OVN_ARABY_MINOR.spawn_cult_djinn=ovn_araby_cult_djinn_setting
                
                --[[local ovn_araby_latency = my_mod:get_option_by_key("rhox_ovn_araby_minor_ind")
                local ovn_araby_latency_setitng = ovn_araby_latency:get_finalized_setting()
                OVN_ARABY_MINOR.latency=ovn_araby_latency_setting--]]
            end,
            true
        )
        --out("Rhox Araby Checking: "..tostring(OVN_ARABY_MINOR.spawn_ind))
        if OVN_ARABY_MINOR.spawn_ind then
            local faction_string = "ovn_arb_sultanate_ind"
            cm:create_force_with_general(
                faction_string, -- faction_key,
                "ovn_arb_inf_arabyan_warriors,ovn_arb_cav_arabyan_knights,ovn_arb_mon_war_elephant_ror_2,ovn_arb_inf_arabyan_bowmen,ovn_arb_inf_arabyan_warriors,ovn_arb_inf_arabyan_bowmen", -- unit_list,
                "cr_combi_region_chandrahara", -- region_key,
                1114, -- x,
                340, -- y,
                "general", -- type,
                "arb_sheikh", -- subtype,
                "names_name_999982576", -- name1,
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
                    
                cm:force_change_cai_faction_personality("ovn_arb_sultanate_ind", "ovn_arb_sultanate_ind")      
                    
                cm:override_building_chain_display("cr_ind_settlement_ind_minor", "ovn_arb_settlement_minor", "cr_combi_region_varindapur")  
                    
                cm:transfer_region_to_faction("cr_combi_region_chandrahara", faction_string)
                local region = cm:get_region("cr_combi_region_chandrahara")
                cm:heal_garrison(region:cqi());
            
                cm:transfer_region_to_faction("cr_combi_region_varindapur", faction_string)
                region = cm:get_region("cr_combi_region_varindapur")
                cm:heal_garrison(region:cqi());
                        
            cm:callback(function()
                local skullstack = cm:get_faction("cr_chd_skullstack")
                if not skullstack or skullstack:is_null_interface() then return end

                local leader = skullstack:faction_leader()
                if leader and not leader:is_null_interface() then
                cm:teleport_to(cm:char_lookup_str(leader), 1105, 292, true)
            end
        end, 1.0)
            
            local unit_count = 1 -- card32 count
            local rcp = 100 -- float32 replenishment_chance_percentage
            local max_units = 1 -- int32 max_units
            local murpt = 0.1 -- float32 max_units_replenished_per_turn
            local xp_level = 0 -- card32 xp_level
            local frr = "" -- (may be empty) String faction_restricted_record
            local srr = "" -- (may be empty) String subculture_restricted_record
            local trr = "" -- (may be empty) String tech_restricted_record
            local units = {
                "ovn_arb_art_grand_bombard_ror",
                "ovn_arb_veh_naphtha_thrower_ror",
                "ovn_arb_cav_lancer_camels_ror",
                "ovn_arb_cav_arabyan_knights_ror",
                "ovn_arb_cav_sipahis_ror",
                "ovn_arb_cav_flying_carpets_ror",
                "ovn_arb_inf_arabyan_warriors_ror",
                "ovn_arb_mon_war_elephant_ror_2",
                "ovn_arb_mon_war_elephant_ror_1",
                "ovn_arb_inf_jezzails_ror",
                "ovn_arb_inf_naffatun_ror",
                "ovn_arb_art_quadballista_ror",        
                "ovn_arb_inf_arabyan_guard_ror"
            }
            
            
            for _, unit in ipairs(units) do
                cm:add_unit_to_faction_mercenary_pool(
                    faction_string,
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
