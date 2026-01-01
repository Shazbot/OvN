cm:add_first_tick_callback_new(
	function()
        if OVN_ARABY_MINOR and OVN_ARABY_MINOR.spawn_cult_djinn then
            local faction_string = "ovn_arb_cult_of_the_djinns"
            local cult_djinn = cm:get_faction(faction_string)

            cm:create_force_with_general(
                faction_string, -- faction_key,
                "ovn_arb_inf_arabyan_spearmen,ovn_arb_cav_bedouin_scouts,ovn_arb_djinn_carriage,ovn_arb_inf_arabyan_bowmen,ovn_arb_inf_arabyan_spearmen,ovn_arb_inf_arabyan_bowmen", -- unit_list,
                "cr_combi_region_kasar", -- region_key,
                1308, -- x,
                118, -- y,
                "general", -- type,
                "arb_vizier_desert", -- subtype,
                "names_name_999982575", -- name1,
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
           
                cm:force_change_cai_faction_personality("ovn_arb_cult_of_the_djinns", "ovn_arb_cult_of_the_djinns")
           
                cm:override_building_chain_display("wh3_main_cth_settlement_minor", "ovn_arb_settlement_minor", "cr_combi_region_kasar")
        
                cm:transfer_region_to_faction("cr_combi_region_kasar", faction_string)
                local region = cm:get_region("cr_combi_region_kasar")
                cm:heal_garrison(region:cqi());
        
                cm:callback(function()
                local clan_rikek = cm:get_faction("cr_skv_clan_rikek")
                if not clan_rikek or clan_rikek:is_null_interface() then return end

                local leader = clan_rikek:faction_leader()
                if leader and not leader:is_null_interface() then
                cm:teleport_to(cm:char_lookup_str(leader), 1295, 92, true)
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
