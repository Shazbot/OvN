core:add_ui_created_callback(
    function(context)
        mixer_enable_custom_faction("1793960962")
        mixer_add_starting_unit_list_for_faction("ovn_arb_sultanate_of_all_araby", {"ovn_arb_inf_arabyan_spearmen", "ovn_arb_inf_arabyan_spearmen", "ovn_arb_mon_genie", "ovn_arb_inf_arabyan_guard", "ovn_arb_inf_arabyan_bowmen", "ovn_arb_inf_arabyan_bowmen", "ovn_arb_cav_arabyan_knights"})
		mixer_change_lord_name("1793960962", "ovn_arb_cha_sultan_jaffar_0")

		mixer_enable_custom_faction("98686852")
        mixer_add_starting_unit_list_for_faction("ovn_arb_golden_fleet", {"ovn_arb_inf_corsairs", "ovn_arb_inf_corsairs", "ovn_arb_mon_enchanted_rope", "ovn_arb_cav_flying_carpets", "ovn_arb_inf_arabyan_bowmen", "ovn_arb_inf_arabyan_bowmen", "wh3_main_ogr_inf_maneaters_3"})
		mixer_change_lord_name("98686852", "ovn_arb_cha_golden_magus_0")

        mixer_enable_custom_faction("1124314978")
        mixer_add_starting_unit_list_for_faction("ovn_arb_aswad_scythans", {"ovn_arb_inf_arabyan_spearmen", "ovn_arb_inf_arabyan_spearmen", "ovn_arb_inf_arabyan_bowmen", "ovn_arb_inf_alrahem_nomads", "ovn_arb_inf_jezzails", "ovn_arb_cav_bedouin_scouts", "ovn_arb_cav_waghzen"})
		mixer_change_lord_name("1124314978", "ovn_arb_cha_fatandira_0")

        mixer_add_faction_to_major_faction_list("ovn_arb_sultanate_of_all_araby")
        mixer_add_faction_to_major_faction_list("ovn_arb_golden_fleet")
        mixer_add_faction_to_major_faction_list("ovn_arb_aswad_scythans")
        
        
        --------------TOW
        mixer_enable_custom_faction("16519695")
		mixer_change_lord_name("16519695", "ovn_arb_cha_sultan_jaffar_0")

		mixer_enable_custom_faction("1374481135")
		mixer_change_lord_name("1374481135", "ovn_arb_cha_golden_magus_0")

        mixer_enable_custom_faction("2048898288")
		mixer_change_lord_name("2048898288", "ovn_arb_cha_fatandira_0")
		
		--------------TOWC

        mixer_enable_custom_faction("83248920")
		mixer_change_lord_name("83248920", "ovn_arb_cha_fatandira_0")
        
    end
)