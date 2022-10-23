local function on_every_first_tick()
    if cm:get_local_faction(true):subculture() == "ovn_sc_fim_fimir" then
        core:remove_listener('ovn_fimir_on_opened_settlement_panel')
        core:add_listener(
            'ovn_fimir_on_opened_settlement_panel',
            'PanelOpenedCampaign',
            true,
            function(context)
                if context.string ~= "settlement_panel" then return end
    
                real_timer.unregister("ovn_fimir_show_slave_diktats_real_timer")
                real_timer.register_repeating("ovn_fimir_show_slave_diktats_real_timer", 0)
            end,
            true
        )
    
        core:remove_listener("ovn_fimir_show_slave_diktats_real_timer")
        core:add_listener(
            "ovn_fimir_show_slave_diktats_real_timer",
            "RealTimeTrigger",
            function(context)
                    return context.string == "ovn_fimir_show_slave_diktats_real_timer"
            end,
            function()
                local ui_root = core:get_ui_root()
                local panel = find_uicomponent(ui_root, "hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "script_hider_parent", "panel")
				if not panel then
					real_timer.unregister("ovn_fimir_show_slave_diktats_real_timer")
					return
				end
				for _, uic_child in uic_pairs(panel) do
					if uic_child:Id() == "frame_slaves" then
						uic_child:SetVisible(true)
                        break
					end
				end
            end,
            true
        )
    end
end
    
cm:add_first_tick_callback(
	function()
        cm:callback(
            function()
                on_every_first_tick()
            end,
            3
        )
	end
)
