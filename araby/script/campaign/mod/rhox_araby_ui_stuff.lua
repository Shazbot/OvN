local function set_diktat_visible()
    local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "script_hider_parent", "panel") --there is "frame_slaves" slaves in the income
    if parent_ui then
        local diktat_panel = find_child_uicomponent(parent_ui, "frame_slaves")
        if diktat_panel then
            diktat_panel:SetVisible(true)
        end
    end
end

local araby_slave_factions = {
	["ovn_arb_sultanate_of_all_araby"] =true,
	--"ovn_arb_aswad_scythans",
	["ovn_arb_golden_fleet"]=true,
	["ovn_arb_sultanate_of_el_kalabad"]=true
	--["ovn_arb_sultanate_ind"]=true	
	--["ovn_arb_cult_of_the_djinns"]=true	
}

cm:add_first_tick_callback(
    function()
        if araby_slave_factions[cm:get_local_faction_name(true)] then--ui thing and should be local
            core:add_listener(
                "rhox_araby_settlement_selected_slave_diktats",
                "SettlementSelected",
                function(context)
                    local region = context:garrison_residence():region()
                    return region:owning_faction() and region:owning_faction():name() == cm:get_local_faction_name(true)
                end,
                function()
                    --out("Rhox Araby: In the diktat viewer")
                    core:get_tm():real_callback(function()
                        set_diktat_visible()                    
                    end, 100)
                end,
                true
            )
            core:add_listener(
                "rhox_araby_performed_slave_diktats",
                "ComponentLClickUp",
                function(context)
                    return string.find(context.string, "wh3_main_ritual_def_slave_")
                end,
                function()
                    --out("Rhox Araby: In the performed ritual diktat viewer")
                    core:get_tm():real_callback(function()
                        set_diktat_visible()                    
                    end, 100)
                end,
                true
            )
            
            core:add_listener(
                "rhox_araby_construct_building_button_slave_diktats",
                "ComponentLClickUp",
                function(context)
                    return context.string == "square_building_button"
                end,
                function()
                    --out("Rhox Araby: In the performed ritual diktat viewer")
                    core:get_tm():real_callback(function()
                        set_diktat_visible()                    
                    end, 100)
                end,
                true
            )
            
            core:add_listener(
                "rhox_araby_expand_slot_button_slave_diktats",
                "ComponentLClickUp",
                function(context)
                    return context.string == "button_expand_slot"
                end,
                function()
                    --out("Rhox Araby: In the performed ritual diktat viewer")
                    core:get_tm():real_callback(function()
                        set_diktat_visible()                    
                    end, 100)
                end,
                true
            )
        end
    end
);