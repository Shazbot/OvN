local function rhox_loop_and_find_flag()
    local node_list_ui = find_uicomponent(core:get_ui_root(), "cathay_caravans", "node_list");
    local node_count = node_list_ui:ChildCount()
    
    for i=0, node_count-1 do
        local child = find_child_uicomponent_by_index(node_list_ui, i)
        local flag_parent = find_uicomponent(child, "node_overlay")
        local flag = find_uicomponent(flag_parent, "flag_ripple")
        if flag:Visible() then
            flag:SetVisible(false)
            local result = core:get_or_create_component("rhox_araby_jellabas_flag", "ui/campaign ui/rhox_araby_jellabas_flag.twui.xml", flag_parent)
            result:SetVisible(true)
        end
    end
end

cm:add_first_tick_callback(
	function ()
			
			if cm:get_local_faction(true):culture() == "ovn_araby" then --ui thing and should be local
                local caravan_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management", "button_caravan");
                if not caravan_button then
                    return --fatandira GM or anybody else
                end
                caravan_button:SetTooltipText(common.get_localised_string("localised_text_ovn_araby_jellabas_way_docker_button_text"), true) --this changes faction button docker tooltip
                
                
                core:add_listener(--this is where changing all the localization, flag, and movie for CARAVAN-COVOY happens
                    "rhox_araby_caravan_open_listener",
                    "PanelOpenedCampaign",
                    function(context)
                        return context.string == "cathay_caravans";
                    end,
                    function()
                        local caravan_head_text = find_uicomponent(core:get_ui_root(), "cathay_caravans", "caravans_panel", "header_holder_high_res", "tx_header");
                        if not caravan_head_text then
                            return
                        end
                        caravan_head_text:SetText(common.get_localised_string("localised_text_ovn_araby_jellabas_way"))
                        
                        
                        local caravan_head_movie_holder = find_uicomponent(core:get_ui_root(), "cathay_caravans", "caravans_panel", "header_holder_high_res");
                        local caravan_head_movie = find_uicomponent(caravan_head_movie_holder, "background_movie");
                        caravan_head_movie:SetVisible(false) --we don't want to see the caravan movie
                        
                        
                        local result = core:get_or_create_component("rhox_araby_movie_header", "ui/campaign ui/rhox_araby_movie_replacer.twui.xml", caravan_head_movie_holder)
                        
                        
                        cm:callback(
                            function()
                                rhox_loop_and_find_flag()
                            end,
                            1
                        )
                    end,
                    true
                )
            end
        end
);