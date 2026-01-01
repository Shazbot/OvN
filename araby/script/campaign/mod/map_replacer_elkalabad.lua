cm:add_first_tick_callback(
    function ()
        if map_replacer then
            map_replacer:add_region_replacement("main_warhammer", "settlement_unfortified", "wh3_main_combi_region_el_kalabad", "elkalabad");
            map_replacer:add_region_replacement("cr_combi_expanded", "settlement_unfortified", "wh3_main_combi_region_el_kalabad", "elkalabad");
            map_replacer:add_region_replacement("main_warhammer", "settlement_unfortified", "wh3_main_combi_region_martek", "elkalabad");
            map_replacer:add_region_replacement("cr_combi_expanded", "settlement_unfortified", "wh3_main_combi_region_martek", "elkalabad");
            map_replacer:add_region_replacement("main_warhammer", "settlement_unfortified", "wh3_main_combi_region_fyrus", "elkalabad");
            map_replacer:add_region_replacement("cr_combi_expanded", "settlement_unfortified", "wh3_main_combi_region_fyrus", "elkalabad");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_unfortified", "cr_oldworld_region_bakr_oasis", "elkalabad");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_unfortified", "cr_oldworld_region_asad_oasis", "elkalabad");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_unfortified", "cr_oldworld_region_gobi_alain", "elkalabad");
            map_replacer:add_region_replacement("cr_oldworld", "settlement_unfortified", "cr_oldworld_region_salt_plain", "elkalabad");
        end
    end
)