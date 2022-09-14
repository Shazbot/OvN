core:add_ui_created_callback(
    function(context)
        mixer_enable_custom_faction("1887921038")
        mixer_add_starting_unit_list_for_faction("ovn_alb_order_of_the_truthsayers", {"elo_youngbloods", "albion_centaurs", "albion_giant"})
		mixer_change_lord_name("1887921038", "bl_elo_dural_durak")
		mixer_enable_custom_faction("1222718341")
        mixer_add_starting_unit_list_for_faction("ovn_alb_host_ravenqueen", {"elo_youngbloods", "albion_swordmaiden","albion_giant","albion_hearthguard"})
		mixer_change_lord_name("1222718341", "albion_morrigan")
    end
)