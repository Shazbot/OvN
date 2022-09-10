    if not is_string(startpos_id) then
        out("ERROR: mixer_enable_custom_faction() called but supplied startpos id key [" .. tostring(startpos_id) .. "] is not a string");
        return false
    end
    
    out("removing "..startpos_id.." from the list")
    
    mixer_factions_that_require_other_mods[startpos_id] = nil    
    
    common.set_context_value("mixer_factions_that_require_other_mods", mixer_factions_that_require_other_mods)
    
    mixer_save_custom_faction_list()
end


core:add_ui_created_callback(
    function(context)
        ovn_enable_custom_faction("1887921038")
        mixer_add_starting_unit_list_for_faction("ovn_alb_order_of_the_truthsayers", {"elo_youngbloods", "albion_centaurs", "albion_giant"})
    end
)

core:add_ui_created_callback(
    function(context)
        mixer_change_lord_name("1887921038", "bl_elo_dural_durak", "ovn_alb_order_of_the_truthsayers")
    end
)


core:add_ui_created_callback(
    function(context)
        ovn_enable_custom_faction("1222718341")
        mixer_add_starting_unit_list_for_faction("ovn_alb_host_ravenqueen", {"elo_youngbloods", "albion_swordmaiden","albion_giant","albion_hearthguard"})
    end
)

core:add_ui_created_callback(
    function(context)
        mixer_change_lord_name("1222718341", "albion_morrigan", "ovn_alb_host_ravenqueen")
    end
)