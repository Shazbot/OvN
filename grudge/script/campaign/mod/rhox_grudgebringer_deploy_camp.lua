local function rhox_grudge_create_emp_army_buttons()
	local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center_docker", "hud_center", "small_bar",  "button_subpanel_parent", "button_subpanel", "button_group_army");

    local result = core:get_or_create_component("rhox_grudge_camp_button", "ui/campaign ui/rhox_grudgebringer_deploy_camp_button.twui.xml", parent_ui)
    if not result then
        script_error("Rhox Grudge: ".. "ERROR: could not create deploy camp button ui component? How can this be?");
        return false;
    end;
	
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
        end
    end
)