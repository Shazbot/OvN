local rhox_araby_jaffar_conquer_regions = {
    ["araby"] = {
    --total 9   6 settlements, and ensure all 3 crusader factions are dead
        "cr_oldworld_region_al_haikk",
        "cr_oldworld_region_fyrus",
        "cr_oldworld_region_tuareg_oasis",
        "cr_oldworld_region_oasis_of_a_thousand_and_one_camels",
        "cr_oldworld_region_el_khabbath",
        "cr_oldworld_region_djambiya",
    },
    ["teb"] = {
--total 9
        "cr_oldworld_region_magritta",
        "cr_oldworld_region_almagora",
        "cr_oldworld_region_nuja",
        "cr_oldworld_region_bilbali",
        "cr_oldworld_region_tobaro",
        "cr_oldworld_region_sartosa",
        "cr_oldworld_region_luccini",
        "cr_oldworld_region_remas",
        "cr_oldworld_region_skavenblight",
    },
    ["bretonnia"] = {
--total 13
        "cr_oldworld_region_castle_brionne",
        "cr_oldworld_region_castle_aquitaine",
        "cr_oldworld_region_castle_quenelles",
        "cr_oldworld_region_castle_carcassonne",
        "cr_oldworld_region_castle_bordeleaux",
        "cr_oldworld_region_castle_parravon",
        "cr_oldworld_region_montfort",
        "cr_oldworld_region_castle_bastonne",
        "cr_oldworld_region_castle_gisoreux",
        "cr_oldworld_region_castle_mousillon",
        "cr_oldworld_region_castle_lyonesse",
        "cr_oldworld_region_castle_languille",
        "cr_oldworld_region_couronne",
    }
};
local rhox_araby_crusader_factions ={
    "wh2_main_brt_thegans_crusaders",
    "wh2_main_brt_knights_of_the_flame",
    "cr_tze_cult_of_mirrors",
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
                local px, py = tt:Position()
				map:MoveTo(px-map:Width()+12, py-2)
				
                if effect_type == "araby" then
                    map:SetImagePath("ui/ovn/arb_revenge_map_tow.png",0)
                elseif effect_type == "teb" then
                    map:SetImagePath("ui/ovn/arb_revenge_map_tow_2.png",0)
                elseif effect_type == "bretonnia" then
                    map:SetImagePath("ui/ovn/arb_revenge_map_tow_3.png",0)
                end
                map:Resize(tt:Width(),tt:Width()+17)
				map:SetVisible(true)
				
				local tooltip_desc = find_uicomponent(tt, "description_window")
                if not tooltip_desc then return end
                if original_desc == "" then
                    original_desc = tooltip_desc:GetStateText()
                end
				
				
				local desc_text = original_desc.. "\n\n" .. common:get_localised_string("rhox_araby_jaffar_conquer_regions")

                local campaign_regions = rhox_araby_jaffar_conquer_regions[effect_type]
                if not campaign_regions then return end
                --out("Rhox Araby: Number of regions in this group: ".. #campaign_regions)

                for i=1,#campaign_regions do
                    local region_key = campaign_regions[i]
                    local region = cm:get_region(region_key)

                    if rhox_araby_jaffar_check_owner(region) then
                        --out("Rhox Araby: Region name: "..region_key)
                        --out("Rhox Araby: Output name: "..common:get_localised_string("regions_onscreen_"..region_key))
                        
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
                return faction:name() == "ovn_arb_sultanate_of_all_araby"
            end,
            function(context)
                original_desc=""
            end,
            true
        );
    end
);
