local chars = {}

math.huge = 2 ^ 1024 -- json needs this and it's not defined in CA Lua environment
local json = require("ovn_fimir/json")

local function get_tier_cost()
    local turn_number = cm:turn_number() - 1;
    return 75 + (turn_number * 10)
end

core:remove_listener("ovn_fimir_change_slaves")
core:add_listener(
    "ovn_fimir_change_slaves",
    "UITrigger",
    function(context)
        return context:trigger():starts_with("ovn_fimir_change_slaves")
    end,
    function(context)
        local stringified_data = context:trigger():gsub("ovn_fimir_change_slaves|", "")
        local data = json.decode(stringified_data)

        local factor = "battles"

        cm:faction_add_pooled_resource(data.f_key, "ovn_fimir_slaves", factor, data.val)
    end,
    true
)

core:remove_listener("ovn_fimir_remove_bundles")
core:add_listener(
    "ovn_fimir_remove_bundles",
    "UITrigger",
    function(context)
        return context:trigger():starts_with("ovn_fimir_remove_bundles")
    end,
    function(context)
        local stringified_data = context:trigger():gsub("ovn_fimir_remove_bundles|", "")
        local data = json.decode(stringified_data)

        local char = cm:get_character_by_cqi(data.cqi)
        if not char then
            return
        end
        local battle_fought = data.battle_fought
        local refund_if_not_fought = data.refund_if_not_fought

        if not battle_fought and refund_if_not_fought then
            if char:has_effect_bundle("ovn_fimir_spell_mastery_1") then
                cm:faction_add_pooled_resource(char:faction():name(), "ovn_fimir_slaves", "battles", get_tier_cost())
            elseif char:has_effect_bundle("ovn_fimir_spell_mastery_2") then
                cm:faction_add_pooled_resource(char:faction():name(), "ovn_fimir_slaves", "battles", get_tier_cost() * 2)
            elseif char:has_effect_bundle("ovn_fimir_spell_mastery_3") then
                cm:faction_add_pooled_resource(char:faction():name(), "ovn_fimir_slaves", "battles", get_tier_cost() * 3)
            elseif char:has_effect_bundle("ovn_fimir_spell_mastery_4") then
                cm:faction_add_pooled_resource(char:faction():name(), "ovn_fimir_slaves", "battles", get_tier_cost() * 4)
            elseif char:has_effect_bundle("ovn_fimir_spell_mastery_5") then
                cm:faction_add_pooled_resource(char:faction():name(), "ovn_fimir_slaves", "battles", get_tier_cost() * 5)
            end
        end
        cm:remove_effect_bundle_from_character("ovn_fimir_spell_mastery_1", char)
        cm:remove_effect_bundle_from_character("ovn_fimir_spell_mastery_2", char)
        cm:remove_effect_bundle_from_character("ovn_fimir_spell_mastery_3", char)
        cm:remove_effect_bundle_from_character("ovn_fimir_spell_mastery_4", char)
        cm:remove_effect_bundle_from_character("ovn_fimir_spell_mastery_5", char)
    end,
    true
)

core:remove_listener("ovn_fimir_add_bundle")
core:add_listener(
    "ovn_fimir_add_bundle",
    "UITrigger",
    function(context)
        return context:trigger():starts_with("ovn_fimir_add_bundle")
    end,
    function(context)
        local stringified_data = context:trigger():gsub("ovn_fimir_add_bundle|", "")
        local data = json.decode(stringified_data)

        local char = cm:get_character_by_cqi(data.cqi)
        cm:apply_effect_bundle_to_character(data.bundle_key, char, 1)
    end,
    true
)

local function remove_bundles_from_char(char, battle_fought, refund_if_not_fought)
    local data = {
        cqi = char:cqi(),
        battle_fought = battle_fought,
        refund_if_not_fought = refund_if_not_fought
    }

    CampaignUI.TriggerCampaignScriptEvent(cm:get_faction(cm:get_local_faction_name(true)):command_queue_index(),
        "ovn_fimir_remove_bundles|" .. json.encode(data))
end



local function handle_ui()
    local purchasable_effects = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "allies_combatants_panel",
        "army", "units_and_banners_parent", "purchasable_effects")
    if not purchasable_effects then return end

    local allies_combatants_panel = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "allies_combatants_panel")
    local char_cqi = allies_combatants_panel:GetContextObjectId("CcoCampaignCharacter")
    local char = cm:get_character_by_cqi(char_cqi)
    if not char then return end

    if char:faction() ~= cm:get_local_faction(true) then
        return
    end
    if char:faction():subculture() ~= "ovn_sc_fim_fimir" then return end

    if not find_uicomponent(purchasable_effects, "ovn_fimir_charges") then
        purchasable_effects:CreateComponent('ovn_fimir_charges', "ui/ovn_fimir_prebattle_charges")
        purchasable_effects:SetVisible(true)
        local ogre_charge = find_uicomponent(purchasable_effects, "ogre_charge")
        if ogre_charge then
            ogre_charge:SetVisible(false)
        end
    end

    local faction = cm:get_local_faction(true)
    local faction_key = faction:name()
    local current_charges = 0

    if faction:subculture() ~= "ovn_sc_fim_fimir" then return end

    local ovn_fimir_charges = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "allies_combatants_panel", "army",
        "units_and_banners_parent", "purchasable_effects", "ovn_fimir_charges")
    if not ovn_fimir_charges then return end

    local charge_icon = find_uicomponent(ovn_fimir_charges, "dy_charges", "charge_icon")
    charge_icon:SetVisible(false)

    local add_charges = find_uicomponent(ovn_fimir_charges, "dy_charges", "ovn_fimir_button_add_charges")
    add_charges:SetState("active")

    local remove_charges = find_uicomponent(ovn_fimir_charges, "dy_charges", "ovn_fimir_button_remove_charges")
    remove_charges:SetState("inactive")

    local dy_meat = find_uicomponent(ovn_fimir_charges, "dy_meat")
    dy_meat:SetTooltipText(common.get_localised_string("ovn_fimir_pre_battle_charge_slave_tooltip"), true)

    local tx_header = find_uicomponent(ovn_fimir_charges, "tx_header")
    tx_header:SetStateText(common.get_localised_string("ovn_fimir_pre_battle_charge_text"))
    tx_header:SetTooltipText(common.get_localised_string("ovn_fimir_pre_battle_charge_tooltip"), true)

    remove_bundles_from_char(char, false, true) --Rhox: this is for quick battle so we'll always need to refund the cost


    if faction:pooled_resource_manager():resource("ovn_fimir_slaves"):value() < get_tier_cost() then
        local add_charges = find_uicomponent(ovn_fimir_charges, "dy_charges", "ovn_fimir_button_add_charges")
        add_charges:SetState("inactive")
    end

    core:remove_listener('ovn_fimir_spell_mastery_on_add_charges_clicked')
    core:add_listener(
        'ovn_fimir_spell_mastery_on_add_charges_clicked',
        'ComponentLClickUp',
        function(context)
            return context.string == "ovn_fimir_button_add_charges"
        end,
        function(context)
            local ovn_fimir_charges = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "allies_combatants_panel",
                "army", "units_and_banners_parent", "purchasable_effects", "ovn_fimir_charges")
            if not ovn_fimir_charges then return end

            if faction:pooled_resource_manager():resource("ovn_fimir_slaves"):value() < get_tier_cost() * 2 then
                local add_charges = find_uicomponent(ovn_fimir_charges, "dy_charges", "ovn_fimir_button_add_charges")
                add_charges:SetState("inactive")
            end
            if faction:pooled_resource_manager():resource("ovn_fimir_slaves"):value() > get_tier_cost() then
                local data = {
                    f_key = faction_key,
                    val = -get_tier_cost()
                }
                CampaignUI.TriggerCampaignScriptEvent(
                cm:get_faction(cm:get_local_faction_name(true)):command_queue_index(),
                    "ovn_fimir_change_slaves|" .. json.encode(data))
                current_charges = current_charges + 1

                local remove_charges = find_uicomponent(ovn_fimir_charges, "dy_charges",
                    "ovn_fimir_button_remove_charges")
                remove_charges:SetState("active")

                local dy_charges = find_uicomponent(ovn_fimir_charges, "dy_charges")
                dy_charges:SetStateText((current_charges == 0 and "" or "+ ") ..
                tostring(current_charges * get_tier_cost()))

                if current_charges == 5 then
                    local add_charges = find_uicomponent(ovn_fimir_charges, "dy_charges", "ovn_fimir_button_add_charges")
                    add_charges:SetState("inactive")
                end

                local charge_icon = find_uicomponent(ovn_fimir_charges, "dy_charges", "charge_icon")
                charge_icon:SetVisible(true)

                charge_icon:SetContextObject(cco("CcoEffectBundle", "ovn_fimir_spell_mastery_" ..
                tostring(current_charges)));

                for _, char in ipairs(chars) do
                    remove_bundles_from_char(char, false, false)
                end

                cm:callback(
			        function()
                        for _, char in ipairs(chars) do
                            local data = {
                                cqi = char:cqi(),
                                bundle_key = "ovn_fimir_spell_mastery_" .. tostring(current_charges)
                            }
                            CampaignUI.TriggerCampaignScriptEvent(
                            cm:get_faction(cm:get_local_faction_name(true)):command_queue_index(),
                                "ovn_fimir_add_bundle|" .. json.encode(data))
                        end
                    end,
                    0.1
                )
            end
        end,
        true
    )

    core:remove_listener('ovn_fimir_spell_mastery_on_remove_charges_clicked')
    core:add_listener(
        'ovn_fimir_spell_mastery_on_remove_charges_clicked',
        'ComponentLClickUp',
        function(context)
            return context.string == "ovn_fimir_button_remove_charges"
        end,
        function(context)
            local ovn_fimir_charges = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "allies_combatants_panel",
                "army", "units_and_banners_parent", "purchasable_effects", "ovn_fimir_charges")
            if not ovn_fimir_charges then return end

            if current_charges == 1 then
                local remove_charges = find_uicomponent(ovn_fimir_charges, "dy_charges",
                    "ovn_fimir_button_remove_charges")
                remove_charges:SetState("inactive")

                local charge_icon = find_uicomponent(ovn_fimir_charges, "dy_charges", "charge_icon")
                charge_icon:SetVisible(false)

                for _, char in ipairs(chars) do
                    remove_bundles_from_char(char, false, false)
                end
            end
            if current_charges > 0 then
                local data = {
                    f_key = faction_key,
                    val = get_tier_cost()
                }
                CampaignUI.TriggerCampaignScriptEvent(
                cm:get_faction(cm:get_local_faction_name(true)):command_queue_index(),
                    "ovn_fimir_change_slaves|" .. json.encode(data))
                current_charges = current_charges - 1

                local add_charges = find_uicomponent(ovn_fimir_charges, "dy_charges", "ovn_fimir_button_add_charges")
                add_charges:SetState("active")

                local dy_charges = find_uicomponent(ovn_fimir_charges, "dy_charges")
                dy_charges:SetStateText((current_charges == 0 and "" or "+ ") ..
                tostring(current_charges * get_tier_cost()))

                charge_icon:SetContextObject(cco("CcoEffectBundle", "ovn_fimir_spell_mastery_" ..
                tostring(current_charges)));

                for _, char in ipairs(chars) do
                    remove_bundles_from_char(char, false, false)
                end
                m:callback(
			        function()
                        for _, char in ipairs(chars) do
                            cm:apply_effect_bundle_to_character("ovn_fimir_spell_mastery_" .. tostring(current_charges), char, 1)
                        end
                    end,
                    0.1
                )
            end
        end,
        true
    )
end

cm:add_first_tick_callback(function()
    core:remove_listener("ovn_fimir_remove_spell_mastery_bundles_after_battle")
    core:add_listener(
        "ovn_fimir_remove_spell_mastery_bundles_after_battle",
        "BattleCompleted",
        true,
        function()
            if cm:pending_battle_cache_num_attackers() >= 1 then
                for i = 1, cm:pending_battle_cache_num_attackers() do
                    local char_cqi = cm:pending_battle_cache_get_attacker(i);

                    local char = cm:get_character_by_cqi(char_cqi)
                    if char then
                        remove_bundles_from_char(char, cm:model():pending_battle():has_been_fought(), true)
                    end
                end
            end
        end,
        true
    )

    core:remove_listener('ovn_fimir_spell_mastery_on_pre_battle_popup')
    core:add_listener(
        "ovn_fimir_spell_mastery_on_pre_battle_popup",
        "PanelOpenedCampaign",
        function(context)
            return context.string == "popup_pre_battle"
        end,
        function()
            local allies_combatants_panel = find_uicomponent(core:get_ui_root(), "popup_pre_battle",
                "allies_combatants_panel")
            local char_cqi = allies_combatants_panel:GetContextObjectId("CcoCampaignCharacter")
            local char = cm:get_character_by_cqi(char_cqi)

            chars = {}
            current_charges = 0

            if char:faction() ~= cm:get_local_faction(true) then
                return
            end
            if char:faction():subculture() ~= "ovn_sc_fim_fimir" then return end

            local commander_header_parent = find_uicomponent(core:get_ui_root(), "popup_pre_battle",
                "allies_combatants_panel", "army", "units_and_banners_parent", "units_window", "listview", "list_clip",
                "list_box")
            for i = 0, 50 do
                local commander_header = find_uicomponent(commander_header_parent, "commander_header_" .. tostring(i))
                if commander_header then
                    local char_cqi = commander_header:GetContextObjectId("CcoCampaignCharacter")
                    local char = cm:get_character_by_cqi(char_cqi)
                    if char:faction() == cm:get_local_faction(true) then
                        table.insert(chars, char)
                    end
                else
                    break
                end
            end

            handle_ui()
        end,
        true
    )

    -- if quick loading into opened pre-battle panel
    local allies_combatants_panel = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "allies_combatants_panel")
    if not allies_combatants_panel then
        return
    end
    local char_cqi = allies_combatants_panel:GetContextObjectId("CcoCampaignCharacter")
    local char = cm:get_character_by_cqi(char_cqi)
    chars = {}
    current_charges = 0

    if char:faction() ~= cm:get_local_faction(true) then
        return
    end
    if char:faction():subculture() ~= "ovn_sc_fim_fimir" then return end

    local commander_header_parent = find_uicomponent(core:get_ui_root(), "popup_pre_battle",
        "allies_combatants_panel", "army", "units_and_banners_parent", "units_window", "listview", "list_clip",
        "list_box")
    for i = 0, 50 do
        local commander_header = find_uicomponent(commander_header_parent, "commander_header_" .. tostring(i))
        if commander_header then
            local char_cqi = commander_header:GetContextObjectId("CcoCampaignCharacter")
            local char = cm:get_character_by_cqi(char_cqi)
            if char:faction() == cm:get_local_faction(true) then
                table.insert(chars, char)
            end
        else
            break
        end
    end
    handle_ui()
end)
