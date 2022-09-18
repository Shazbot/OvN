core:add_ui_created_callback(
    function(context)
        mixer_enable_custom_faction("1793960962")
        mixer_add_starting_unit_list_for_faction("ovn_arb_sultanate_of_all_araby", {"ovn_arb_inf_jezzails", "ovn_arb_inf_arabyan_guard", "ovn_arb_art_grand_bombard"})
		mixer_change_lord_name("1793960962", "ovn_arb_cha_sultan_jaffar_0")


		mixer_enable_custom_faction("98686852")
        mixer_add_starting_unit_list_for_faction("ovn_arb_golden_fleet", {"ovn_arb_inf_corsairs", "ovn_arb_mon_enchanted_rope","ovn_arb_cav_flying_carpets"})
		mixer_change_lord_name("98686852", "ovn_arb_cha_golden_magus_0")

        mixer_enable_custom_faction("1124314978")
        mixer_add_starting_unit_list_for_faction("ovn_arb_aswad_scythans", {"ovn_arb_inf_alrahem_nomads", "ovn_arb_cav_bedouin_scouts","ovn_arb_mon_elephant"})
		mixer_change_lord_name("1124314978", "ovn_arb_cha_fatandira_0")
    end
)