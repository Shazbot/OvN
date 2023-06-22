PJ_GRUDGE_HEALING = PJ_GRUDGE_HEALING or {}
local mod = PJ_GRUDGE_HEALING

local function round(num)
  return math.floor(num + 0.5)
end

math.huge = 2^1024 -- json needs this and it's not defined in CA Lua environment
local json = require("pj_grudge_healing/json")

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
		"layout","bar_small_top", "TabGroup", "tab_units"
	)
    if not tab_units then
        return--do nothing then script break
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

	for i=0, list_clip:ChildCount()-1 do
		local comp = UIComponent(list_clip:Find(i))
		if comp:Id() == "list_box" then
			for j=0, comp:ChildCount()-1 do
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

mod.friendly_cultures = {
	wh_main_emp_empire = true,
	wh_main_dwf_dwarfs = true,
	wh_dlc05_wef_wood_elves = true,
	wh2_main_hef_high_elves = true,
	wh3_main_cth_cathay = true,
	wh3_main_ksl_kislev = true,
	wh_main_brt_bretonnia = true,
	mixer_teb_southern_realms = true,
}

mod.add_new_unit = function(unit_cqi)
	local faction_cqi = cm:get_faction(cm:get_local_faction_name(true)):command_queue_index()

	local data_to_send = {
		unit_cqi = unit_cqi,
		commander_cqi = mod.commander_cqi,
	}

	CampaignUI.TriggerCampaignScriptEvent(faction_cqi, "pj_grudge_healing_grant_unit|"..json.encode(data_to_send))
end

--- Show, creating if needed, the upgrade icon on unit cards.
mod.show_upgrade_icon = function(unit_index, button_state, button_tooltip)
	local campaign = find_uicomponent(
		core:get_ui_root(),
		"units_panel",
		"main_units_panel",
		"units",
		"LandUnit "..tostring(unit_index),
		"card_image_holder",
		"campaign"
	)
	local our_upgradable_icon = campaign and find_uicomponent(
		campaign,
		"pj_grudge_healing_button"
	)
	if not our_upgradable_icon then
		our_upgradable_icon = UIComponent(campaign:CreateComponent("pj_grudge_healing_button", "ui/templates/square_small_button"))
		our_upgradable_icon:SetImagePath("ui/pj_grudge_healing/icon_replenish_gold.png",0)
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

mod.hide_upgrade_icons = function()
	local unit_index = -1
	
	while(true) do
		unit_index = unit_index + 1
		local land_unit_card = find_uicomponent(
			core:get_ui_root(),
			"units_panel",
			"main_units_panel",
			"units",
			"LandUnit "..tostring(unit_index)
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
	if not mod.commander_cqi then
		return
	end

	-- loop through all the unit cards
	local unit_index = 0
	local num_agents = mod.get_num_agents()
	---@type CA_CHAR
	local char = cm:get_character_by_cqi(mod.commander_cqi)
	if not char:has_military_force() then return end

	local region = char:region()
	local province_name = not region:is_null_interface() and region:province_name()
	local unit_list = char:military_force():unit_list()
	local army_size = unit_list:num_items()

	local local_faction_obj = cm:get_faction(cm:get_local_faction_name(true))
	local faction_name = local_faction_obj:name()

	if not mod.commander_cqi then
		return
	end

	local commander = cm:get_character_by_cqi(mod.commander_cqi)
	if not commander or commander:is_null_interface() then
		return
	end

	local is_near_settlement = false

	if commander:region():is_null_interface() then
		is_near_settlement = false
	else
		local settlement = commander:region():settlement()
		local x,y = settlement:logical_position_x(), settlement:logical_position_y()
		local dist_sqr = distance_squared(x,y , commander:logical_position_x(), commander:logical_position_y())
		if dist_sqr <= 25 and mod.friendly_cultures[commander:region():owning_faction():culture()] then
			is_near_settlement = true
		end
	end

	if not is_near_settlement then
		mod.hide_upgrade_icons()
		return
	end

	while(true) do
		local land_unit_card = find_uicomponent(
			core:get_ui_root(),
			"units_panel",
			"main_units_panel",
			"units",
			"LandUnit "..tostring(unit_index)
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

		if army_size > unit_index+num_agents then
			local unit_to_upgrade = unit_list:item_at(unit_index+num_agents)
			if unit_to_upgrade and not unit_to_upgrade:is_null_interface() then

				local unit_cost = unit_to_upgrade:get_unit_custom_battle_cost()
				local replenish_cost = round((1-unit_to_upgrade:percentage_proportion_of_full_strength()/100)*unit_cost)

				local local_faction = cm:get_faction(cm:get_local_faction_name(true))
				local new_tooltip_text = "Fully replenish the unit.\nMust be near an Order settlement."
				if unit_to_upgrade:percentage_proportion_of_full_strength() ~= 100 then
					new_tooltip_text = new_tooltip_text.."\nCosts [[img:icon_money]][[/img]]"..replenish_cost.."."
					if not is_near_settlement then
						new_tooltip_text = new_tooltip_text.."\n[[col:red]]Must be near an Empire settlement to replenish troops.[[/col]]"
					end
				else
					new_tooltip_text = new_tooltip_text.."\n[[col:yellow]]Unit is already fully replenished.[[/col]]"
				end
				if local_faction:treasury() < replenish_cost then
					new_tooltip_text = new_tooltip_text.."\n[[col:red]]Not enough [[img:icon_money]][[/img]].[[/col]]"
				end


				if unit_to_upgrade:percentage_proportion_of_full_strength() == 100
					or local_faction:treasury() < replenish_cost
					or not is_near_settlement
				then
					mod.show_upgrade_icon(unit_index, "inactive", new_tooltip_text)
				else
					mod.show_upgrade_icon(unit_index, "active", new_tooltip_text)
				end

			end
		end

		unit_index = unit_index + 1
	end
end

--- Get number of agents in an army by scraping the UI.
mod.get_num_agents = function()
	local index = 0
	while(true) do
		local agent = find_uicomponent(
			core:get_ui_root(),
			"units_panel",
			"main_units_panel",
			"units",
			"Agent "..tostring(index)
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
	while(true) do
		local agent = find_uicomponent(
			core:get_ui_root(),
			"units_panel",
			"main_units_panel",
			"units",
			"AgentUnit "..tostring(index2)
		)
		if not agent then
			break
		end
		index2 = index2 + 1
		if index2 > 30 then
			return 0
		end
	end

	return index+index2
end

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

		if not commander_cqi or not unit_cqi then
			return
		end

		local commander = cm:get_character_by_cqi(commander_cqi)
		if not commander then return end

		local faction = commander:faction()

		local num_items = commander:military_force():unit_list():num_items()
		for i=0, num_items-1 do
			local unit_interface = commander:military_force():unit_list():item_at(i)
			if unit_interface:command_queue_index() == unit_cqi then
				local unit_cost = unit_interface:get_unit_custom_battle_cost()
				local replenish_cost = round((1-unit_interface:percentage_proportion_of_full_strength()/100)*unit_cost)
				cm:treasury_mod(faction:name(), -replenish_cost)
				cm:set_unit_hp_to_unary_of_maximum(unit_interface, 1)
				break
			end
		end

		if cm:get_faction(cm:get_local_faction_name(true)):command_queue_index() == faction_cqi then
			mod.simulate_army_refresh(commander_cqi)
		end
	end,
	true
)

mod.first_tick_cb = function()
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

			local retrain_button_index = UIComponent(UIComponent(UIComponent(UIComponent(context.component):Parent()):Parent()):Parent())
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

			mod.add_new_unit(unit:command_queue_index())
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
			local char = context:character()

			local faction = char:faction()
			if faction:name() ~= "ovn_emp_grudgebringers" then
				return
			end

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
				mod.commander_cqi = nil
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
			real_timer.register_repeating("pj_grudge_healing_callback_id_2", 0)
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
