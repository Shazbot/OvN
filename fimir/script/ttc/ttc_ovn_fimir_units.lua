local modded_units = {
{"fim_cav_nuckelavee", "rare", 2},
{"fim_inf_boglar", "core"},
{"fim_inf_shearl", "core"},
{"fim_inf_death_quest", "special", 1},
{"fim_inf_killing_eye_ror", "special", 1},
{"fim_inf_fimm_warriors", "core"},
{"fim_inf_fimm_warriors_great_weapons", "core"},
{"fim_inf_swamp_daemons", "special", 1},
{"fim_inf_swamp_daemons_summon", "special", 1},
{"fim_inf_fimm_warriors_axe_throwers_ror", "core"},
{"fim_inf_shearl_javelineer", "core"},
{"fim_mon_daemonomaniac", "rare", 3},
{"fim_mon_daemonomaniac_ror", "rare", 3},
{"ovn_fim_mon_bog_octopus_0", "rare", 2},
{"fim_cav_marsh_reavers", "special", 2},
{"fim_cav_marsh_reavers_kroll", "special", 2},
{"fim_cav_marsh_hornets_ror", "special", 2},
{"fim_mon_fenbeast", "special", 2},
{"fim_mon_gharnus_daemon_ror", "special", 2},
{"fim_mon_fianna_fimm", "special", 2},
{"fim_mon_fianna_fimm_great_weapons", "special", 2},
{"fim_mon_mistmor", "special", 2},
{"fim_mon_balefiend_apprentices", "rare", 2},
{"fim_inf_moor_hounds", "core"},
{"fim_inf_moor_hounds_ror", "core"},
{"fim_mon_bog_beasts", "special", 2},
{"fim_veh_eye_oculus", "rare", 2}
}


local ttc = core:get_static_object("tabletopcaps")
if ttc then
    ttc.add_setup_callback(function()
        ttc.add_unit_list(modded_units)
    end)
end