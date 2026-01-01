core:add_ui_created_callback(
    function(context)
        mixer_enable_custom_faction("459208402")
        mixer_add_starting_unit_list_for_faction("ovn_fim_rancor_hold", {"fim_inf_swamp_daemons", "fim_cav_nuckelavee", "fim_veh_eye_oculus"})
		mixer_change_lord_name("459208402", "fim_cha_meargh_skattach")
		mixer_enable_custom_faction("1809709658")
        mixer_add_starting_unit_list_for_faction("ovn_fim_tendrils_of_doom", {"fim_mon_fianna_fimm", "fim_mon_fenbeast","ovn_fim_mon_bog_octopus_0"})
		mixer_change_lord_name("1809709658", "fim_cha_daemon_octopus_kroll")
        mixer_add_faction_to_major_faction_list("ovn_fim_rancor_hold")
        mixer_add_faction_to_major_faction_list("ovn_fim_tendrils_of_doom")
        
        --OLD WORLD
        mixer_enable_custom_faction("1573703005")
        mixer_add_starting_unit_list_for_faction("ovn_fim_rancor_hold", {"fim_inf_swamp_daemons", "fim_cav_nuckelavee", "fim_veh_eye_oculus"})
		mixer_change_lord_name("1573703005", "fim_cha_meargh_skattach")
		mixer_enable_custom_faction("1074883223")
        mixer_add_starting_unit_list_for_faction("ovn_fim_tendrils_of_doom", {"fim_mon_fianna_fimm", "fim_mon_fenbeast","ovn_fim_mon_bog_octopus_0"})
		mixer_change_lord_name("1074883223", "fim_cha_daemon_octopus_kroll")
        mixer_add_faction_to_major_faction_list("ovn_fim_rancor_hold")
        mixer_add_faction_to_major_faction_list("ovn_fim_tendrils_of_doom")
        
        --OLD WORLD CLASSIC
        mixer_enable_custom_faction("823201737")
        mixer_add_starting_unit_list_for_faction("ovn_fim_rancor_hold", {"fim_inf_swamp_daemons", "fim_cav_nuckelavee", "fim_veh_eye_oculus"})
		mixer_change_lord_name("823201737", "fim_cha_meargh_skattach")
		mixer_enable_custom_faction("453668815")
        mixer_add_starting_unit_list_for_faction("ovn_fim_tendrils_of_doom", {"fim_mon_fianna_fimm", "fim_mon_fenbeast","ovn_fim_mon_bog_octopus_0"})
		mixer_change_lord_name("453668815", "fim_cha_daemon_octopus_kroll")
        mixer_add_faction_to_major_faction_list("ovn_fim_rancor_hold")
        mixer_add_faction_to_major_faction_list("ovn_fim_tendrils_of_doom")
        
    end
)