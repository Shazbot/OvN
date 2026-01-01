PJ_GRUDGE_HEALING = PJ_GRUDGE_HEALING or {}
local mod = PJ_GRUDGE_HEALING

local function round(num)
    return math.floor(num + 0.5)
end

math.huge = 2 ^ 1024 -- json needs this and it's not defined in CA Lua environment
local json = require("../../../ovn_requires/json")

-- useful to have this during dev, safely ignore
local dout = _G.dout or function(...) end

-- useful to have this during dev, safely ignore
real_timer.unregister("pj_grudge_healing_callback_id_2")

--- Refresh the whole army UI.
--- We close the whole campaign UI and simulate selecting the commander.
mod.simulate_army_refresh = function(commander_cqi)
    common.call_context_command("CcoCampaignCharacter", commander_cqi, "Select")
    -- find and open the lords dropdown
    local tab_units = find_uicomponent(
        core:get_ui_root(),
        "layout", "bar_small_top", "TabGroup", "tab_units"
    )
    if not tab_units then
        return --do nothing then script break
    end
    local do_we_close_the_panel_after = false
    if tab_units:CurrentState() ~= "selected" then
        tab_units:SimulateLClick()
        do_we_close_the_panel_after = true
    end

    local ui_root = core:get_ui_root()
    local units_dropdown = find_uicomponent(
        ui_root,
        "layout", "radar_things", "dropdown_parent", "units_dropdown"
    )
    if not units_dropdown then return end

    local list_clip = find_uicomponent(
        units_dropdown,
        "panel", "panel_clip", "sortable_list_units", "list_clip"
    )
    if not list_clip then return end

    for i = 0, list_clip:ChildCount() - 1 do
        local comp = UIComponent(list_clip:Find(i))
        if comp:Id() == "list_box" then
            for j = 0, comp:ChildCount() - 1 do
                local char_row = UIComponent(comp:Find(j))
                local char_name_label = find_uicomponent(char_row, "indent_parent", "dy_character_name")
                local char_name = char_name_label and char_name_label:GetStateText()
                local level_label = char_row and find_uicomponent(char_row, "indent_parent", "rank", "dy_rank")
                local level = level_label and level_label:GetStateText()

                if char_name and level and char_name == mod.commander_name and level == mod.commander_level then
                    char_row:SimulateLClick()
                    if do_we_close_the_panel_after then
                        tab_units:SimulateLClick()
                    end
                    return
                end
            end
        end
    end
end

local function binding_iter(binding)
    local pos = 0
    local num_items = binding:num_items()
    return function()
        if pos < num_items then
            local item = binding:item_at(pos)
            pos = pos + 1
            return item
        end
    end
end

mod.friendly_cultures = {} --will be set to RHOX_GRUDGEBRINGER_GOOD_CULTURE at first tick

mod.bad_faction={}--Will be set to RHOX_GRUDGEBRINGER_BAD_FACTION at first tick

mod.add_new_unit = function(unit_cqi, heal_all)
    local faction_cqi = cm:get_faction(cm:get_local_faction_name(true)):command_queue_index()

    local data_to_send = {
        unit_cqi = unit_cqi,
        commander_cqi = mod.commander_cqi,
		heal_all = heal_all
    }

    CampaignUI.TriggerCampaignScriptEvent(faction_cqi, "pj_grudge_healing_grant_unit|" .. json.encode(data_to_send))
end

--- Show, creating if needed, the upgrade icon on unit cards.
mod.show_upgrade_icon = function(unit_index, button_state, button_tooltip, are_agents_done)


    --out("Rhox Grudge: Showing the icons / Are agents are done: ".. tostring(are_agents_done))
    local campaign = find_uicomponent(
        core:get_ui_root(),
        "units_panel",
        "main_units_panel",
        "units",
        (not are_agents_done and "AgentUnit " or "LandUnit ") .. tostring(unit_index),
        "card_image_holder",
        "campaign"
    )
    if not campaign then
        --out("Rhox Grudge: Icon not found. Not doing it")
        return
    end
    local our_upgradable_icon = campaign and find_uicomponent(
        campaign,
        "pj_grudge_healing_button"
    )

    if not our_upgradable_icon then
        our_upgradable_icon = UIComponent(campaign:CreateComponent("pj_grudge_healing_button",
            "ui/templates/square_small_button"))
        our_upgradable_icon:SetImagePath("ui/pj_grudge_healing/icon_replenish_gold.png", 0)
        find_uicomponent(our_upgradable_icon, "icon"):SetVisible(false)
        our_upgradable_icon:SetDockingPoint(3)
        our_upgradable_icon:SetDockOffset(0, 12)
    end

    if our_upgradable_icon then
        our_upgradable_icon:SetTooltipText(button_tooltip, true)
        our_upgradable_icon:SetState(button_state)

        our_upgradable_icon:SetVisible(true)
    end
end

mod.show_heal_all_icon = function(button_state, button_tooltip)

	local button_holder = find_uicomponent(
		core:get_ui_root(),
		"units_panel",
		"main_units_panel",
		"units",
		"LandUnit 0"
	)
	if not button_holder then
		return
	end
	local healing_all_icon = button_holder and find_uicomponent(
		button_holder,
		"pj_grudge_healing_all_button"
	)
	if not button_holder then
		return
	end
	if not healing_all_icon then
		healing_all_icon = UIComponent(button_holder:CreateComponent("pj_grudge_healing_all_button",
			"ui/templates/square_small_button"))
			healing_all_icon:SetImagePath("ui/battle ui/ability_icons/wh2_dlc13_character_abilities_patch_up.png", 0)
		find_uicomponent(healing_all_icon, "icon"):SetVisible(false)
		healing_all_icon:SetDockingPoint(3)
		healing_all_icon:SetDockOffset(-70, 12)
		healing_all_icon:Resize(55,55)
	end

	if healing_all_icon then
		healing_all_icon:SetTooltipText(button_tooltip, true)
		healing_all_icon:SetState(button_state)

		healing_all_icon:SetVisible(true)
	end
end

mod.hide_upgrade_icons = function()
    --out("Rhox Grudge: Hiding icons")
    local unit_index = -1

	local heal_all_button = find_uicomponent(
		core:get_ui_root(),
		"units_panel",
		"main_units_panel",
		"units",
		"LandUnit 0",
		"pj_grudge_healing_all_button"
	)
	if heal_all_button then
        --out("Rhox Grudge: Hiding the heal all button")
		heal_all_button:SetVisible(false)
	end

    while (true) do
        unit_index = unit_index + 1
        local land_unit_card = find_uicomponent(
            core:get_ui_root(),
            "units_panel",
            "main_units_panel",
            "units",
            "LandUnit " .. tostring(unit_index)
        )
        if not land_unit_card then
            break
        end

        local campaign = find_uicomponent(
            land_unit_card,
            "card_image_holder",
            "campaign"
        )
        local our_upgradable_icon = campaign and find_uicomponent(
            campaign,
            "pj_grudge_healing_button"
        )
        if our_upgradable_icon then
            our_upgradable_icon:SetVisible(false)
        end
    end
end

mod.update_upgrade_icons = function()
    cm:callback( --give them time to update the panel
        function()
            --out("Rhox Grudge: Updating icons")
            if not mod.commander_cqi then
                return
            end

            -- loop through all the unit cards
            local unit_index = 0

            ---@type CA_CHAR
            local char = cm:get_character_by_cqi(mod.commander_cqi)
            if not char:has_military_force() or not char or not char:faction() then
                --out("Rhox Grudge: It does not have character or faction or military force")
                return
            end
            if char:faction():name() ~= "ovn_emp_grudgebringers" then --rhox edit
                --mod.hide_upgrade_icons()--rhox edit
                --out("Rhox Grudge: Factin name isn't Grudgebringers: " ..char:faction():name())
                return
            end




            local region = char:region()
            local province_name = not region:is_null_interface() and region:province_name()
            local unit_list = char:military_force():unit_list()
            local army_size = unit_list:num_items()
            --out("Rhox Grudge: Army size: ".. army_size)


            local num_agents = char:military_force():character_list():num_items()-1 --because of generals
            --out("Rhox Grudge: Agent number: ".. num_agents)
						for _, char in model_pairs(char:military_force():character_list()) do
							if char:character_type("colonel") then
								num_agents = num_agents - 1
							end
						end


            local local_faction_obj = cm:get_local_faction(true)
            local faction_name = cm:get_local_faction_name(true)


            local commander = cm:get_character_by_cqi(mod.commander_cqi)
            if not commander or commander:is_null_interface() then
                return
            end

            local is_near_settlement = false

            if commander:region():is_null_interface() then
                is_near_settlement = false
            else
                local settlement = commander:region():settlement()
                local x, y = settlement:logical_position_x(), settlement:logical_position_y()
                local dist_sqr = distance_squared(x, y, commander:logical_position_x(), commander:logical_position_y())
                if dist_sqr <= 37 and mod.friendly_cultures[commander:region():owning_faction():culture()] and not mod.bad_faction[commander:region():owning_faction():name()] then
                    is_near_settlement = true
                end
            end

            if not is_near_settlement then
                mod.hide_upgrade_icons()
                return
            end

            local are_agents_done = false
            local local_faction = cm:get_local_faction(true)

			local total_replenish_cost =0
			local is_everybody_full = true

            while (true) do
                local land_unit_card = not are_agents_done and find_uicomponent(
                    core:get_ui_root(),
                    "units_panel",
                    "main_units_panel",
                    "units",
                    "AgentUnit " .. tostring(unit_index)
                )

                if not are_agents_done and not land_unit_card then
                    unit_index = 0
                    are_agents_done = true
                end

                local land_unit_card = land_unit_card or find_uicomponent(
                    core:get_ui_root(),
                    "units_panel",
                    "main_units_panel",
                    "units",
                    "LandUnit " .. tostring(unit_index)
                )
                if not land_unit_card then
                    break
                end

                land_unit_card:AddScriptEventReporter()

                local exp = find_uicomponent(
                    land_unit_card,
                    "card_image_holder",
                    "experience"
                )
                if not exp then
                    break
                end

                if unit_index > 50 then
                    real_timer.unregister("pj_grudge_healing_callback_id_2")
                    break
                end



                if army_size > unit_index then
                    local army_unit_index = unit_index
                    if army_unit_index > 0 then
                        army_unit_index = are_agents_done and (num_agents + unit_index) or unit_index + 1
                    else
                        army_unit_index = not are_agents_done and army_unit_index + 1 or army_unit_index
                    end
                    local unit_to_upgrade = unit_list:item_at(army_unit_index)
                    if not are_agents_done then
                        -- agents cards aren't actually in the same order as the units in the army unit list
                        -- so for example the first agent card in the UI could be the second agent in the army unit list
                        local cqi = land_unit_card:GetContextObjectId("CcoCampaignUnit")
                        for _, unit in model_pairs(unit_list) do
                            if tostring(unit:command_queue_index()) == cqi then
                                unit_to_upgrade = unit
                                break
                            end
                        end
                    end
                    if unit_to_upgrade and not unit_to_upgrade:is_null_interface() then
                        local unit_cost = unit_to_upgrade:get_unit_custom_battle_cost()
                        local replenish_cost = round((1 - unit_to_upgrade:percentage_proportion_of_full_strength() / 100) *
                            (unit_cost/2))
						total_replenish_cost = total_replenish_cost+ replenish_cost


                        local new_tooltip_text = common.get_localised_string("pj_healing_replenishment_string")
                        if unit_to_upgrade:percentage_proportion_of_full_strength() ~= 100 then
                            new_tooltip_text = new_tooltip_text .. common.get_localised_string("pj_healing_replenishment_money") .. replenish_cost .. "."
                            if not is_near_settlement then
                                new_tooltip_text = new_tooltip_text ..
                                   common.get_localised_string("pj_healing_replenishment_order_warning")
                            end
                        else
                            new_tooltip_text = new_tooltip_text .. common.get_localised_string("pj_healing_replenishment_already_full")
                        end
                        if local_faction:treasury() < replenish_cost then
                            new_tooltip_text = new_tooltip_text .. common.get_localised_string("pj_healing_replenishment_need_money")
                        end

						if unit_to_upgrade:percentage_proportion_of_full_strength() ~= 100 then
							is_everybody_full = false
						end

                        if unit_to_upgrade:percentage_proportion_of_full_strength() == 100
                            or local_faction:treasury() < replenish_cost
                            or not is_near_settlement
                        then
                            mod.show_upgrade_icon(unit_index, "inactive", new_tooltip_text, are_agents_done)
                        else
                            mod.show_upgrade_icon(unit_index, "active", new_tooltip_text, are_agents_done)
                        end
                    end
                end
                --out("Rhox Grudge: index ".. unit_index .. "th one finished")
                unit_index = unit_index + 1
            end

			local new_tooltip_text = common.get_localised_string("pj_healing_replenishment_string_force")
			if is_everybody_full then
				new_tooltip_text = new_tooltip_text .. common.get_localised_string("pj_healing_replenishment_already_force_full")
			else
				new_tooltip_text = new_tooltip_text .. common.get_localised_string("pj_healing_replenishment_money") .. total_replenish_cost .. "."
				if not is_near_settlement then
					new_tooltip_text = new_tooltip_text ..
					   common.get_localised_string("pj_healing_replenishment_order_warning")
				end
			end
			if local_faction:treasury() < total_replenish_cost then
				new_tooltip_text = new_tooltip_text .. common.get_localised_string("pj_healing_replenishment_need_money")
			end

			if is_everybody_full or local_faction:treasury() < total_replenish_cost or not is_near_settlement then
				mod.show_heal_all_icon("inactive", new_tooltip_text)
			else
				mod.show_heal_all_icon("active", new_tooltip_text)
			end
            --out("Rhox Grudge: Finished updating icons")
        end,
        0.1
    )
end

--[[
--- Get number of agents in an army by scraping the UI.
mod.get_num_agents = function()
    local index = 0
    while (true) do
        local agent = find_uicomponent(
            core:get_ui_root(),
            "units_panel",
            "main_units_panel",
            "units",
            "Agent " .. tostring(index)
        )
        if not agent then
            break
        end
        index = index + 1
        if index > 30 then
            return 0
        end
    end

    local index2 = 0
    while (true) do
        local agent = find_uicomponent(
            core:get_ui_root(),
            "units_panel",
            "main_units_panel",
            "units",
            "AgentUnit " .. tostring(index2)
        )
        if not agent then
            break
        end
        index2 = index2 + 1
        if index2 > 30 then
            return 0
        end
    end
    out("Rhox Grudge: Index 1: ".. index .."/index 2: "..index2)
    return index + index2
end
]]--

core:remove_listener("pj_grudge_healing_on_script_event_grant_unit")
core:add_listener(
    "pj_grudge_healing_on_script_event_grant_unit",
    "UITrigger",
    function(context)
        return context:trigger():starts_with("pj_grudge_healing_grant_unit")
    end,
    function(context)
        local faction_cqi = context:faction_cqi()

        local stringified_data = context:trigger():gsub("pj_grudge_healing_grant_unit|", "")

        local data = json.decode(stringified_data)
        local commander_cqi = data.commander_cqi
        local unit_cqi = data.unit_cqi
		local heal_all = data.heal_all

        if not commander_cqi or not unit_cqi then
            return
        end

        local commander = cm:get_character_by_cqi(commander_cqi)
        if not commander then return end

        local faction = commander:faction()

        local num_items = commander:military_force():unit_list():num_items()
        for i = 0, num_items - 1 do
            local unit_interface = commander:military_force():unit_list():item_at(i)
            if unit_interface:command_queue_index() == unit_cqi or heal_all then
                local unit_cost = unit_interface:get_unit_custom_battle_cost()
                local replenish_cost = round((1 - unit_interface:percentage_proportion_of_full_strength() / 100) *
                    (unit_cost/1.5))
                cm:treasury_mod(faction:name(), -replenish_cost)
                cm:set_unit_hp_to_unary_of_maximum(unit_interface, 1)
				if not heal_all then
                	break
				end
            end
        end

        if cm:get_faction(cm:get_local_faction_name(true)):command_queue_index() == faction_cqi then
            mod.simulate_army_refresh(commander_cqi)
        end
    end,
    true
)

mod.first_tick_cb = function()
    mod.friendly_cultures = RHOX_GRUDGEBRINGER_GOOD_CULTURE
    mod.bad_faction = RHOX_GRUDGEBRINGER_BAD_FACTION
    --- When we click the unit upgrade button.
    core:remove_listener('pj_grudge_healing_on_clicked_retrain_button')
    core:add_listener(
        'pj_grudge_healing_on_clicked_retrain_button',
        'ComponentLClickUp',
        function(context)
            local is_player_turn = false
            for faction in binding_iter(cm:whose_turn_is_it()) do
                if faction == cm:get_local_faction(true) then
                    is_player_turn = true
                    break
                end
            end
            return context.string:starts_with("pj_grudge_healing_button") and is_player_turn
        end,
        function(context)
            if not mod.commander_cqi then
                return
            end

            local retrain_button_index = UIComponent(UIComponent(UIComponent(UIComponent(context.component):Parent())
                :Parent()):Parent())
            if not retrain_button_index then return end

            local unit_id = retrain_button_index:GetContextObjectId("CcoCampaignUnit")
            if not unit_id then return end

            local unit = nil
            local commander = cm:get_character_by_cqi(mod.commander_cqi)
            if commander and not commander:is_null_interface() then
                for current_unit in binding_iter(commander:military_force():unit_list()) do
                    if tostring(current_unit:command_queue_index()) == unit_id then
                        unit = current_unit
                    end
                end
            end

            if not unit then return end

			mod.add_new_unit(unit:command_queue_index(), false)

        end,
        true
    )
	core:add_listener(
        'pj_grudge_healing_on_clicked_retrain_all_button',
        'ComponentLClickUp',
        function(context)
            local is_player_turn = false
            for faction in binding_iter(cm:whose_turn_is_it()) do
                if faction == cm:get_local_faction(true) then
                    is_player_turn = true
                    break
                end
            end
            return context.string == "pj_grudge_healing_all_button" and is_player_turn
        end,
        function(context)
            if not mod.commander_cqi then
                return
            end
			local commander = cm:get_character_by_cqi(mod.commander_cqi)

            local unit = commander:military_force():unit_list():item_at(0)

			mod.add_new_unit(unit:command_queue_index(), true)

        end,
        true
    )

    --- Stop the repeating UI update when we unselect the army.
    core:remove_listener('pj_grudge_healing_on_closed_units_panel')
    core:add_listener(
        'pj_grudge_healing_on_closed_units_panel',
        'PanelClosedCampaign',
        function(context)
            return context.string == "units_panel"
        end,
        function()
            --out("Rhox Grudge: Unit panel closed")
            real_timer.unregister("pj_grudge_healing_callback_id_2")
        end,
        true
    )


    core:remove_listener("pj_grudge_healing_update_upgrade_icons_trigger")
    core:add_listener(
        "pj_grudge_healing_update_upgrade_icons_trigger",
        "RealTimeTrigger",
        function(context)
            return context.string == "pj_grudge_healing_callback_id_2"
        end,
        function()
            mod.update_upgrade_icons()
        end,
        true
    )

    core:remove_listener('pj_grudge_healing_on_character_selected')
    core:add_listener(
        'pj_grudge_healing_on_character_selected',
        'CharacterSelected',
        function()
            return true
        end,
        function(context)
            ---@type CA_CHAR
            --out("Rhox Grudge: Character Selected")
            local char = context:character()

            local faction = char:faction()
            if faction:name() ~= "ovn_emp_grudgebringers" then
                --out("Rhox Grudge: It's not Grudgebringers")
                real_timer.unregister("pj_grudge_healing_callback_id_2")
                mod.commander_cqi = nil
                return
            end
            --out("Rhox Grudge: It's the Grudgebringers")

            local is_player_turn = false
            for faction in binding_iter(cm:whose_turn_is_it()) do
                if faction == cm:get_local_faction(true) then
                    is_player_turn = true
                    break
                end
            end

            local is_player_char = char:faction():name() == cm:get_local_faction_name(true)
                and is_player_turn

            if not is_player_char then
                real_timer.unregister("pj_grudge_healing_callback_id_2")
                mod.commander_cqi = nil
                --mod.commander_cqi = char:cqi() --rhox edit: we need it to check whether we're creating the ui for the right guys

                --out("Rhox Grudge: Non-player character selected. Setting the value to nil")
                return
            end

            mod.commander_cqi = char:cqi()

            cm:callback(function()
                local ui_root = core:get_ui_root()

                local army_name_label = find_uicomponent(
                    ui_root,
                    "units_panel",
                    "main_units_panel",
                    "header",
                    "button_focus",
                    "dy_txt"
                )

                local commander_level_label = find_uicomponent(
                    ui_root,
                    "layout",
                    "info_panel_holder",
                    "primary_info_panel_holder",
                    "info_panel_background",
                    "CharacterInfoPopup",
                    "rank",
                    "skills",
                    "dy_rank"
                )

                mod.commander_level = commander_level_label and commander_level_label:GetStateText()
                mod.commander_name = army_name_label and army_name_label:GetStateText()
            end, 0.1)

            mod.update_upgrade_icons()
            real_timer.unregister("pj_grudge_healing_callback_id_2")
            real_timer.register_repeating("pj_grudge_healing_callback_id_2", 100)
        end,
        true
    )
end

mod.delayed_first_tick_cb = function()
    cm:callback(mod.first_tick_cb, 2.5)
end

cm:add_first_tick_callback(mod.delayed_first_tick_cb)

--- We'll call first_tick_cb directly if hot-reloading during dev.
--- We're checking for presence of execute external lua file in the traceback.
if debug.traceback():find('pj_loadfile') then
    mod.first_tick_cb()
end
