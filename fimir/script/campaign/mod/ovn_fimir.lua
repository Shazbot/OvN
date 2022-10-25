local function on_every_first_tick()
        core:remove_listener("ovn_fimir_remove_fog_vanguard")
        core:add_listener(
            "ovn_fimir_remove_fog_vanguard",
            "BattleCompleted",
            true,
            function(context)
                if not cm:pending_battle_cache_human_is_involved() then
                    return
                end

                for i = 1, cm:pending_battle_cache_num_defenders() do
                    local this_char_cqi = cm:pending_battle_cache_get_defender(i);
                    local char = cm:get_character_by_cqi(this_char_cqi)
                    if char:faction():subculture()=="ovn_sc_fim_fimir" then
                        cm:remove_effect_bundle_from_characters_force("ovn_fimir_fog_diktat_empty", char:cqi())
                    end
                end
                for i = 1, cm:pending_battle_cache_num_attackers() do
                    local this_char_cqi = cm:pending_battle_cache_get_attacker(i);
                    local char = cm:get_character_by_cqi(this_char_cqi)
                    if char:faction():subculture()=="ovn_sc_fim_fimir" then
                        cm:remove_effect_bundle_from_characters_force("ovn_fimir_fog_diktat_empty", char:cqi())
                    end
                end
            end,
            true
        )

        core:remove_listener("ovn_fimir_give_fog_vanguard")
        core:add_listener(
            "ovn_fimir_give_fog_vanguard",
            "PendingBattle",
            function()
                return true
            end,
            function(context)
                if not cm:pending_battle_cache_human_is_involved() then
                    return
                end

                local first_attacker_cqi = cm:pending_battle_cache_get_attacker(1);
                local first_attacker_char = cm:get_character_by_cqi(first_attacker_cqi)

                local any_region_has_fimir_fog = false
                for _, region in model_pairs(first_attacker_char:region():province():regions()) do
                    if region:has_effect_bundle("ovn_fimir_fog_diktat") then
                        any_region_has_fimir_fog = true
                        break
                    end
                end

                if not any_region_has_fimir_fog then return end

                for i = 1, cm:pending_battle_cache_num_defenders() do
                    local this_char_cqi = cm:pending_battle_cache_get_defender(i);
                    local char = cm:get_character_by_cqi(this_char_cqi)
                    if char:faction():subculture()=="ovn_sc_fim_fimir" then
                        local custom_bundle = cm:create_new_custom_effect_bundle("ovn_fimir_fog_diktat_empty")
                        custom_bundle:add_effect("wh_main_effect_attribute_enable_vanguard_deployment", "character_to_force_own", 1)
                        cm:apply_custom_effect_bundle_to_characters_force(custom_bundle, char)
                    end
                end
                for i = 1, cm:pending_battle_cache_num_attackers() do
                    local this_char_cqi = cm:pending_battle_cache_get_attacker(i);
                    local char = cm:get_character_by_cqi(this_char_cqi)
                    if char:faction():subculture()=="ovn_sc_fim_fimir" then
                        local custom_bundle = cm:create_new_custom_effect_bundle("ovn_fimir_fog_diktat_empty")
                        custom_bundle:add_effect("wh_main_effect_attribute_enable_vanguard_deployment", "character_to_force_own", 1)
                        cm:apply_custom_effect_bundle_to_characters_force(custom_bundle, char)
                    end
                end
            end,
            true
        )

        core:remove_listener("ovn_fimir_give_fog_bundle_to_chars")
        core:add_listener(
            "ovn_fimir_give_fog_bundle_to_chars",
            "CharacterTurnStart",
            true,
            function(context)
                ---@type CA_CHAR
                local char = context:character()
                if not cm:char_is_general_with_army(char) or not char:has_region() then return end

                local any_region_has_fimir_fog = false
                for _, region in model_pairs(char:region():province():regions()) do
                    if region:has_effect_bundle("ovn_fimir_fog_diktat") then
                        any_region_has_fimir_fog = true
                        break
                    end
                end

                if not any_region_has_fimir_fog then
                    cm:remove_effect_bundle_from_characters_force("ovn_fimir_fog_diktat_empty", char:cqi())
                    return
                end

                if char:faction():subculture() == "ovn_sc_fim_fimir" then
                    local custom_bundle = cm:create_new_custom_effect_bundle("ovn_fimir_fog_diktat_empty")
                    custom_bundle:add_effect("wh_main_effect_force_all_campaign_movement_range", "force_to_force_own_lords_army", 20)
                    custom_bundle:add_effect("wh_main_effect_force_army_campaign_ambush_attack_success_chance", "force_to_force_own", 20)
                    cm:apply_custom_effect_bundle_to_characters_force(custom_bundle, char)
                else
                    local custom_bundle = cm:create_new_custom_effect_bundle("ovn_fimir_fog_diktat_empty")
                    custom_bundle:add_effect("wh_main_effect_force_all_campaign_movement_range", "force_to_force_own_lords_army", -50)
                    cm:apply_custom_effect_bundle_to_characters_force(custom_bundle, char)
                end
            end,
            true
        )

    if cm:get_local_faction(true):subculture() == "ovn_sc_fim_fimir" then
        local res_bar = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar")
        if res_bar then
            UIComponent(res_bar:CreateComponent("ovn_fimir_slaves", "ui/ovn_fimir_slaves"))
        end

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
