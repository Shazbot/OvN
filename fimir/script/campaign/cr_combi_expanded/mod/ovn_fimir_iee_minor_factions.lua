local iee_pestilens_setting_check=false;

core:add_listener(
    "rhox_ovn_fimir_mct_initialize_iee_checker",
    "MctInitialized",
    true,
    function(context)
        -- get the mct object
        local mct = context:mct()
        local cr_mod = mct:get_mod_by_key("cr_immortal_empires_expanded")

        local rhox_ovn_iee_pestilens = cr_mod:get_option_by_key("pestilens_to_khuresh_checkbox")
        local rhox_ovn_iee_pestilens_setting = rhox_ovn_iee_pestilens:get_finalized_setting()
        iee_pestilens_setting_check=rhox_ovn_iee_pestilens_setting


    end,
    true
)



cm:add_first_tick_callback_new(
	function()
        if OVN_FIMIR_MINOR and OVN_FIMIR_MINOR.spawn_ovn_fim_thunderous_sight then
            local faction_string = "ovn_fim_thunderous_sight"
            local thunderous_sight = cm:get_faction(faction_string)
            
            cm:create_force_with_general(
                faction_string,
                "fim_inf_fimm_warriors,fim_mon_fenbeast,fim_inf_fimm_warriors,fim_inf_shearl,fim_inf_shearl,fim_inf_shearl_javelineer", -- unit_list,
                "cr_combi_region_mata_mire", -- region_key,
                1386, -- x,
                269, -- y,
                "general", -- type,
                "fim_dirach_lord_beasts", -- subtype,
                "names_name_999982417", -- name1,
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
            
            cm:transfer_region_to_faction("cr_combi_region_mata_mire", faction_string)
            local region = cm:get_region("cr_combi_region_mata_mire")
            cm:instantly_set_settlement_primary_slot_level(region:settlement(), 2)
                cm:instantly_upgrade_building_in_region(region:slot_list():item_at(2), "ovn_fimir_infantry_1")
            cm:heal_garrison(region:cqi());
            
            cm:transfer_region_to_faction("cr_combi_region_hewn", faction_string)
            local hewn_region = cm:get_region("cr_combi_region_hewn")
            cm:instantly_set_settlement_primary_slot_level(hewn_region:settlement(), 2)
            cm:heal_garrison(hewn_region:cqi());
            
            cm:transfer_region_to_faction("cr_combi_region_tigercage_isle", "cr_cst_rotten_knot")
            local tigercage_isle = cm:get_region("cr_combi_region_tigercage_isle")
            cm:heal_garrison(tigercage_isle:cqi());
            
            cm:callback(function()
                local rotten_knot = cm:get_faction("cr_cst_rotten_knot")
                if not rotten_knot or rotten_knot:is_null_interface() then return end

                local leader = rotten_knot:faction_leader()
                if leader and not leader:is_null_interface() then
                    cm:teleport_to(cm:char_lookup_str(leader), 1352, 103, true)
                end
            end, 1.0)
                                   
            -- Sanmal only if not the starting position of Clan Pestilens
            cm:callback(function()
                if iee_pestilens_setting_check then
                    cm:force_make_peace("wh2_main_skv_clan_pestilens", "cr_cst_rotten_knot")
                    cm:force_declare_war("wh2_main_skv_clan_pestilens", "ovn_fim_thunderous_sight", false, false)

                else
                    out(">>> [OVN Fimir] No Clan Pestilens start – transferring Sanmal to Thunderous Sight")
                    cm:transfer_region_to_faction("cr_combi_region_sanmal", "ovn_fim_thunderous_sight")

                    local s = cm:get_region("cr_combi_region_sanmal")
                    if s and not s:is_null_interface() then
                        cm:instantly_set_settlement_primary_slot_level(s:settlement(), 2)
                        cm:heal_garrison(s:cqi())
                        out(">>> [OVN Fimir] Sanmal transferred and garrison healed for Thunderous Sight")
                    else
                        out(">>> [OVN Fimir] Warning: Sanmal region object invalid after transfer!")
                    end
                end
            end, 1.5)

        
            cm:callback(function()
                local faction = cm:get_faction("ovn_fim_thunderous_sight")
                if faction and not faction:is_null_interface() then
                    cm:force_change_cai_faction_personality("ovn_fim_thunderous_sight", "wh3_combi_norsca_minor")
                    out(">>> [OVN Fimir] CAI personality applied to Thunderous Sight")
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
                    thunderous_sight,
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
        
        if OVN_FIMIR_MINOR and OVN_FIMIR_MINOR.spawn_ovn_fim_hell_gate then
            local faction_string = "ovn_fim_hell_gate"
            local hell_gate = cm:get_faction(faction_string)
            
            cm:create_force_with_general(
                faction_string,
                "fim_inf_fimm_warriors,fim_mon_fianna_fimm,fim_cav_nuckelavee,fim_inf_shearl,fim_inf_shearl,fim_inf_shearl_javelineer", -- unit_list,
                "cr_combi_region_city_of_splinters", -- region_key,
                1046, -- x,
                861, -- y,
                "general", -- type,
                "fim_dirach_lord_death", -- subtype,
                "names_name_999982406", -- name1,
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
            
            cm:transfer_region_to_faction("cr_combi_region_city_of_splinters", faction_string)
            cm:transfer_region_to_faction("cr_combi_region_red_abyss", faction_string)

            local city_of_splinters = cm:get_region("cr_combi_region_city_of_splinters")
            cm:instantly_set_settlement_primary_slot_level(city_of_splinters:settlement(), 3)
            cm:instantly_upgrade_building_in_region(city_of_splinters:slot_list():item_at(1), "ovn_fimir_cavalry_1")
            cm:heal_garrison(city_of_splinters:cqi())
        
            local red_abyss = cm:get_region("cr_combi_region_red_abyss")
            cm:instantly_set_settlement_primary_slot_level(red_abyss:settlement(), 2)
            cm:heal_garrison(red_abyss:cqi())

            
            local withered_eye = cm:get_faction("cr_grn_withered_eye_tribe")
            if withered_eye and not withered_eye:is_dead() then
                cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
                cm:disable_event_feed_events(true, "wh_event_category_faction", "", "")
                cm:kill_all_armies_for_faction(withered_eye)
                cm:disable_event_feed_events(false, "wh_event_category_character", "", "")
                cm:disable_event_feed_events(false, "wh_event_category_faction", "", "")
            end

            cm:callback(function()
                local faction = cm:get_faction("ovn_fim_hell_gate")
                if faction and not faction:is_null_interface() then
                    cm:force_change_cai_faction_personality("ovn_fim_hell_gate", "wh3_combi_norsca_minor")
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
                    hell_gate,
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