core:add_ui_created_callback(
    function(context)
        mixer_enable_custom_faction("459208402")
        mixer_add_starting_unit_list_for_faction("ovn_fim_rancor_hold", {"ovn_swamp_daemons", "elo_fenbeast", "fim_inf_fimm_warriors_great_weapons"})
		mixer_change_lord_name("459208402", "fim_cha_meargh_skattach")
		mixer_enable_custom_faction("1809709658")
        mixer_add_starting_unit_list_for_faction("ovn_fim_tendrils_of_doom", {"fim_mon_fianna_fimm", "fim_mon_fenbeast","ovn_fim_mon_bog_octopus_0"})
		mixer_change_lord_name("1809709658", "fim_cha_daemon_octopus_kroll")
    end
)