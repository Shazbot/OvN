cm:add_first_tick_callback(
    function ()
        if map_replacer then

            -- Only add this if you want to replace any battle of the provided type in a radious around the X and Y position.
            -- This takes priority over the rest of replacements.
            --map_replacer:add_coordinate_replacement(campaign_key, battle_type, pos_x, pos_y, range, tile_upgrade_key, unique_key)

            -- Only add this if you want to replace any battle of the provided type in a specific region.
            -- This takes priority over province replacements.
            --map_replacer:add_region_replacement(campaign_key, battle_type, region_key, tile_upgrade_key)

            -- Only add this if you want to replace any battle of the provided type in a specific province.
            --map_replacer:add_province_replacement(campaign_key, battle_type, province_key, tile_upgrade_key)
            
            
            
            --Vanilla Immortal Empires
            map_replacer:add_region_replacement("main_warhammer", "settlement_standard", "wh3_main_combi_region_al_haikk", "alhaikk");
            map_replacer:add_region_replacement("main_warhammer", "settlement_standard", "wh3_main_combi_region_the_copper_landing", "alhaikk");
            --map_replacer:add_region_replacement("main_warhammer", "settlement_standard", "wh3_main_combi_region_quatar", "ovn_arb_settlement_standard_1");
            map_replacer:add_region_replacement("main_warhammer", "settlement_standard", "wh3_main_combi_region_el_kalabad", "alhaikk");
            map_replacer:add_region_replacement("main_warhammer", "settlement_standard", "wh3_main_combi_region_lashiek", "copher");
            map_replacer:add_region_replacement("main_warhammer", "settlement_standard", "wh3_main_combi_region_copher", "copher");
            map_replacer:add_region_replacement("main_warhammer", "settlement_standard", "wh3_main_combi_region_fyrus", "copher");
            map_replacer:add_region_replacement("main_warhammer", "settlement_standard", "wh3_main_combi_region_martek", "alhaikk");
            map_replacer:add_region_replacement("main_warhammer", "settlement_standard", "wh3_main_combi_region_wizard_caliphs_palace", "alhaikk");
            map_replacer:add_region_replacement("main_warhammer", "settlement_standard", "wh3_main_combi_region_sorcerers_islands", "copher");
            map_replacer:add_region_replacement("main_warhammer", "settlement_standard", "wh3_main_combi_region_ka_sabar", "ovn_arb_settlement_standard_1");
            
            --These two should be ignored in vanilla IE, and then used in IEE, no problems, probably
            map_replacer:add_region_replacement("main_warhammer", "settlement_standard", "cr_combi_region_akhaba", "alhaikk");
            map_replacer:add_region_replacement("main_warhammer", "settlement_standard", "cr_combi_region_sud", "alhaikk");
            
            
            --Immortal Empires Expanded (two extra, these won't actually be used since the map replacer only checks for "main_warhammer", will need to get Frodo to change, could also just )
            --[[map_replacer:add_region_replacement("cr_combi_expanded", "settlement_standard", "wh3_main_combi_region_al_haikk", "ovn_arb_settlement_standard_1");
            map_replacer:add_region_replacement("cr_combi_expanded", "settlement_standard", "wh3_main_combi_region_the_copper_landing", "ovn_arb_settlement_standard_1");
            --map_replacer:add_region_replacement("cr_combi_expanded", "settlement_standard", "wh3_main_combi_region_quatar", "ovn_arb_settlement_standard_1");
            map_replacer:add_region_replacement("cr_combi_expanded", "settlement_standard", "wh3_main_combi_region_el_kalabad", "ovn_arb_settlement_standard_1");
            map_replacer:add_region_replacement("cr_combi_expanded", "settlement_standard", "wh3_main_combi_region_lashiek", "ovn_arb_settlement_standard_1");
            map_replacer:add_region_replacement("cr_combi_expanded", "settlement_standard", "wh3_main_combi_region_copher", "ovn_arb_settlement_standard_1");
            map_replacer:add_region_replacement("cr_combi_expanded", "settlement_standard", "wh3_main_combi_region_fyrus", "ovn_arb_settlement_standard_1");
            map_replacer:add_region_replacement("cr_combi_expanded", "settlement_standard", "wh3_main_combi_region_martek", "ovn_arb_settlement_standard_1");
            map_replacer:add_region_replacement("cr_combi_expanded", "settlement_standard", "wh3_main_combi_region_wizard_caliphs_palace", "ovn_arb_settlement_standard_1");
            map_replacer:add_region_replacement("cr_combi_expanded", "settlement_standard", "wh3_main_combi_region_sorcerers_islands", "ovn_arb_settlement_standard_1");
            map_replacer:add_region_replacement("cr_combi_expanded", "settlement_standard", "wh3_main_combi_region_ka_sabar", "ovn_arb_settlement_standard_1");
            map_replacer:add_region_replacement("cr_combi_expanded", "settlement_standard", "cr_combi_region_akhaba", "ovn_arb_settlement_standard_1");
            map_replacer:add_region_replacement("cr_combi_expanded", "settlement_standard", "cr_combi_region_sud", "ovn_arb_settlement_standard_1");]]--
            
            
            
            --The Old World (nothing yet)
            map_replacer:add_region_replacement("cr_oldworld", "settlement_standard", "cr_oldworld_region_al_haikk", "alhaikk");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_standard", "cr_oldworld_region_bakr_oasis", "alhaikk");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_standard", "cr_oldworld_region_asad_oasis", "alhaikk");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_standard", "cr_oldworld_region_arjijil", "alhaikk");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_standard", "cr_oldworld_region_hashishins_lair", "alhaikk");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_standard", "cr_oldworld_region_fyrus", "copher");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_standard", "cr_oldworld_region_el_khabbath", "copher");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_standard", "cr_oldworld_region_oasis_of_gazi", "alhaikk");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_standard", "cr_oldworld_region_muzil_oasis", "alhaikk");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_standard", "cr_oldworld_region_malaluk_oasis", "alhaikk");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_standard", "cr_oldworld_region_gobi_alain", "alhaikk");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_standard", "cr_oldworld_region_djambiya", "copher");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_standard", "cr_oldworld_region_teshert", "alhaikk");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_standard", "cr_oldworld_region_salt_plain", "alhaikk");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_standard", "cr_oldworld_region_soqotra", "alhaikk");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_standard", "cr_oldworld_region_vitrolle", "alhaikk");
            
            
        end
    end
)