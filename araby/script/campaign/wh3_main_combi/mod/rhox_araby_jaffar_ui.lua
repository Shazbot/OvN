local rhox_araby_jaffar_conquer_regions = {
    ["araby"] = {
--total 10   --coast, cracked, assassin, and ensure all 4 crusader factions are dead
        "wh3_main_combi_region_black_tower_of_arkhan",
        "wh3_main_combi_region_el_kalabad",
        "wh3_main_combi_region_pools_of_despair",
        "wh3_main_combi_region_zandri",
        "wh3_main_combi_region_al_haikk",
        "wh3_main_combi_region_copher",
        "wh3_main_combi_region_fyrus",
        "wh3_main_combi_region_lashiek",
        "wh3_main_combi_region_sorcerers_islands",
        "wh3_main_combi_region_wizard_caliphs_palace"
    },
    ["teb"] = {
--total 10 --pirate's current, tilea, estalia, irrana, blighted
        "wh3_main_combi_region_sartosa",
        "wh3_main_combi_region_luccini",
        "wh3_main_combi_region_miragliano",
        "wh3_main_combi_region_riffraffa",
        "wh3_main_combi_region_magritta",
        "wh3_main_combi_region_nuja",
        "wh3_main_combi_region_tobaro",
        "wh3_main_combi_region_bilbali",
        "wh3_main_combi_region_montenas",
        "wh3_main_combi_region_skavenblight"
    },
    ["bretonnia"] = {
--total 15 --carcassonne, chalons, cuileux, brienne, bastonne, arden, lyonesse, couronne
        "wh3_main_combi_region_brionne",
        "wh3_main_combi_region_castle_carcassonne",
        "wh3_main_combi_region_parravon",
        "wh3_main_combi_region_quenelles",
        "wh3_main_combi_region_massif_orcal",
        "wh3_main_combi_region_aquitaine",
        "wh3_main_combi_region_bordeleaux",
        "wh3_main_combi_region_castle_bastonne",
        "wh3_main_combi_region_montfort",
        "wh3_main_combi_region_castle_artois",
        "wh3_main_combi_region_gisoreux",
        "wh3_main_combi_region_lyonesse",
        "wh3_main_combi_region_mousillon",
        "wh3_main_combi_region_couronne",
        "wh3_main_combi_region_languille"
    }
};
local rhox_araby_crusader_factions ={
    "wh2_dlc14_brt_chevaliers_de_lyonesse",
    "wh2_main_brt_knights_of_origo",
    "wh2_main_brt_knights_of_the_flame",
    "wh2_main_brt_thegans_crusaders"
}




local rhox_araby_jaffar_effect_bundle_titles={
    ["Reconquest of Araby"]="araby",
    ["Subjugation of the Southern Realms"]="teb",
    ["Annihilation of Bretonnia"]="bretonnia",
}


local original_desc=""

local function rhox_araby_start_jaffar_listener(result)
    local jaffar_button = find_uicomponent(result, "icon_effect")
    core:add_listener(
        "rhox_araby_jaffar_tooltip_on",
        "RealTimeTrigger",
        function(context)
            return context.string == "rhox_jaffar_araby_map_ui"
        end,
        function(context)
            --out("Rhox Araby: Triggering Map Viewer!")
            if cm:get_local_faction_name(true) == "ovn_arb_sultanate_of_all_araby" then
                local tt = find_uicomponent(core:get_ui_root(), "TechTooltipPopup")
                local map = core:get_or_create_component("rhox_jaffar_map", "ui/campaign ui/rhox_araby_jaffar_tooltip.twui.xml", core:get_ui_root())			
                if not tt or not map then
                    if map then
                        map:SetVisible(false)
                    end
                    return
                end
                local tooltip_title = find_uicomponent(tt, "dy_title")
                if not tooltip_title then
                    map:SetVisible(false)
                    return
                end
                
                local title_text = tooltip_title:GetStateText()
                if not rhox_araby_jaffar_effect_bundle_titles[title_text] then
                    --out("Rhox Araby: Nothing found title text was "..title_text)
                    map:SetVisible(false)
                    return
                end
                
                local effect_type=rhox_araby_jaffar_effect_bundle_titles[title_text]
                if not effect_type then
                    --out("Rhox Araby: ERROR Jaffar has no valid conquest type effect bundle")
                    return
                end
                
                map:SetCanResizeHeight(true)
                map:SetCanResizeWidth(true)
                map:SetMoveable(true)
                
                if effect_type == "araby" then
                    map:SetImagePath("ui/ovn/arb_revenge_map.png",0)
                elseif effect_type == "teb" then
                    map:SetImagePath("ui/ovn/arb_revenge_map_2.png",0)
                elseif effect_type == "bretonnia" then
                    map:SetImagePath("ui/ovn/arb_revenge_map_3.png",0)
                end
                local px, py = tt:Position()
				map:MoveTo(px-map:Width()+12, py-2)
				map:Resize(tt:Width(),tt:Width()+31)
				map:SetVisible(true)
				
				local tooltip_desc = find_uicomponent(tt, "description_window")
                if not tooltip_desc then return end
                if original_desc == "" then
                    original_desc = tooltip_desc:GetStateText()
                end
				
				
				local desc_text = original_desc.. "\n\n" .. common:get_localised_string("rhox_araby_jaffar_conquer_regions")

                local campaign_regions = rhox_araby_jaffar_conquer_regions[effect_type]
                if not campaign_regions then return end

                for i=1,#campaign_regions do
                    local region_key = campaign_regions[i]
                    local region = cm:get_region(region_key)

                    if rhox_araby_jaffar_check_owner(region) then
                        desc_text = desc_text
                            .."\n[[col:green]]"
                            ..common:get_localised_string("regions_onscreen_"..region_key)
                            .."[[/col]]"
                    else
                        
                        desc_text = desc_text
                            .."\n[[col:red]]"
                            ..common:get_localised_string("regions_onscreen_"..region_key)
                            .."[[/col]]"
                    end
                end

                if effect_type == "araby" then
                    desc_text = desc_text ..  "\n\n" .. common:get_localised_string("rhox_araby_jaffar_destroy_factions")
                    for i=1,#rhox_araby_crusader_factions do
                        local faction_key = rhox_araby_crusader_factions[i]
                        local faction = cm:get_faction(faction_key)
    
                        if faction:is_dead() then
                            desc_text = desc_text
                                .."\n[[col:green]]"
                                ..common:get_localised_string("factions_screen_name_"..faction_key)
                                .."[[/col]]"
                        else
                            
                            desc_text = desc_text
                                .."\n[[col:red]]"
                                ..common:get_localised_string("factions_screen_name_"..faction_key)
                                .."[[/col]]"
                        end
                    end
                end
                
                desc_text = desc_text .. common:get_localised_string("rhox_araby_jaffar_current_effects")
                

                tooltip_desc:SetStateText(desc_text)
            end
        end,
        true
    )
end

cm:add_first_tick_callback(
    function()
        ------for translation mods
        rhox_araby_jaffar_effect_bundle_titles[common:get_localised_string("effect_bundles_localised_title_rhox_araby_jaffar_conquer_araby_1")]="araby"
        rhox_araby_jaffar_effect_bundle_titles[common:get_localised_string("effect_bundles_localised_title_rhox_araby_jaffar_conquer_teb_1")]="teb"
        rhox_araby_jaffar_effect_bundle_titles[common:get_localised_string("effect_bundles_localised_title_rhox_araby_jaffar_conquer_bretonnia_1")]="bretonnia"
    
        if cm:get_local_faction_name(true) == "ovn_arb_sultanate_of_all_araby" then --ui thing and should be local
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            local result = core:get_or_create_component("rhox_araby_jaffar_holder", "ui/campaign ui/rhox_araby_jaffar_holder.twui.xml", parent_ui)
            rhox_araby_start_jaffar_listener(result)
            real_timer.unregister("rhox_jaffar_araby_map_ui")
            real_timer.register_repeating("rhox_jaffar_araby_map_ui", 0)
        end
        core:add_listener(
            "rhox_araby_jaffar_loc_reset_turn_start",
            "FactionTurnStart",
            function(context)
                local faction = context:faction()
                return faction:name() == "ovn_arb_sultanate_of_all_araby"
            end,
            function(context)
                original_desc=""
            end,
            true
        );
    end
);
