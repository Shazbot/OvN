core:add_ui_created_callback(
    function(context)
        mixer_enable_custom_faction("1840752775")
        mixer_add_starting_unit_list_for_faction("ovn_hlf_the_moot", {"halfling_cook", "ovn_mtl_cav_poultry_riders_0", "sr_ogre"})
		mixer_enable_custom_faction("1611837450")
		mixer_change_lord_name("1840752775", "ovn_hlf_glibfoot", "ovn_hlf_the_moot")
    end
)