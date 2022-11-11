local modded_units = {
    
    {"elo_albion_warriors", "core"},
    {"elo_albion_warriors_spears", "core"},
    {"elo_albion_warriors_2h", "core"},
    {"elo_youngbloods", "core"},
    {"elo_bloodhounds", "core"},
    {"albion_riders", "core"},
    {"albion_riders_spear", "core"},
    {"albion_riders_javelins", "core"},
    {"albion_chariot", "core"},
    
    {"elo_woadraider", "special", 1},
    {"albion_swordmaiden", "special", 1},
    {"druid_neophytes", "special", 1},
    {"albion_hearthguard", "special", 2},
    {"albion_hearthguard_halberd", "special", 2},
    {"albion_hearthguard_2h", "special", 2},
    {"albion_huntresses", "special", 1}, 
    {"alb_cav_noble", "special", 2},
    {"alb_cav_noble_spear", "special", 2},
    {"albion_centaurs", "special", 1},
    {"ovn_barrow_wight", "special", 1},
    {"albion_half_giants", "special", 2},
    {"alb_viridian_champ", "special", 1},
    {"elo_albion_gryphon", "special", 2},
    
    {"elo_fenbeast", "rare", 1},
    {"albion_stonethrower", "rare", 1},
    {"albion_fenhulk", "rare", 3},
    {"albion_giant", "rare", 2},
    {"ovn_alb_inf_stone_throw_giant", "rare", 3},

    {"albion_warriors_lugh", "core"},

    {"albion_woadraider_sworn_ror", "special", 1},
    {"albion_shieldmaiden_ror", "special", 1},
    {"albion_highlander_ror", "special", 2},
    {"albion_huntresses_warden_ror", "special", 1},     
    {"alb_cav_noble_first_ror", "special", 2},    
    {"albion_centaur_hunter_ror", "special", 1},       

    {"elo_fly_infested_rotwood", "rare", 1},    
    {"albion_bologs_giant_ror", "rare", 2},
    {"albion_cachtorr_stonethrower", "rare", 3}

}

local ttc = core:get_static_object("tabletopcaps")
if ttc then
    ttc.add_setup_callback(function()
        ttc.add_unit_list(modded_units)
    end)
end