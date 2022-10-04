core:add_ui_created_callback(
    function(context)
        mixer_enable_custom_faction("1840752775")
        mixer_add_starting_unit_list_for_faction("ovn_hlf_the_moot", {"halfling_cook", "ovn_mtl_cav_poultry_riders_0", "sr_ogre"})
		mixer_change_lord_name("1840752775", "ovn_hlf_glibfoot", "ovn_hlf_the_moot")
        mixer_enable_custom_faction("1611837450")
        mixer_add_starting_unit_list_for_faction("ovn_hlf_the_comradeship", {"ovn_com_cha_aragand_the_layabout_0", "ovn_com_cha_legles_the_elf_0", "ovn_com_cha_giblit_the_dwarf_0","wh2_dlc10_hef_mon_treekin_0" })
		mixer_change_lord_name("1611837450", "ovn_com_cha_olorin_the_grey_wizard_0", "ovn_hlf_the_comradeship")
    end
)