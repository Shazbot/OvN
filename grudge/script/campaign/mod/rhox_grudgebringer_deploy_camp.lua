local function rhox_grudge_create_emp_army_buttons()
	local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center_docker", "hud_center", "small_bar",  "button_subpanel_parent", "button_subpanel", "button_group_army");

    local result = core:get_or_create_component("rhox_grudge_camp_button", "ui/campaign ui/rhox_grudgebringer_deploy_camp_button.twui.xml", parent_ui)
    
    
    local result2 = core:get_or_create_component("rhox_grudge_camp_panel", "ui/campaign ui/rhox_grudgebringer_camp_panel.twui.xml", core:get_ui_root())
    
    
end


cm:add_first_tick_callback(
    function(context) 
        if cm:get_local_faction_name(true) == "ovn_emp_grudgebringers" then
            core:add_listener(
                "rhox_grudgebringer_army_panel_opened",
                "PanelOpenedCampaign",
                function(context) return context.string == "units_panel" end,
                function(context)
                    cm:real_callback(rhox_grudge_create_emp_army_buttons, 2);
                end,
                true
            );
            
            core:add_listener(
				"rhox_ovn_grudgebringer_CharacterSelected_horde_growth_shower",
				"CharacterSelected",
				function(context)
                    
					return context:character():faction():name() == "ovn_emp_grudgebringers" and context:character():character_subtype_key()=="ovn_grudge_camp_lord";
				end,
				function(context)
                    cm:callback(
                        function()
                            local horde_growth = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "horde_growth");
                            if horde_growth then 
                                horde_growth:SetVisible(true)
                            end
                        end,
                        0.1
                    )
				end,
				true
            )
        end
    end
)