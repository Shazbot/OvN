OVN_NAVAL_DEFENDER = OVN_NAVAL_DEFENDER or {}
local mod = OVN_NAVAL_DEFENDER

---@return CA_UIC
local function find_ui_component_str(starting_comp, str)
	local has_starting_comp = str ~= nil
	if not has_starting_comp then
		str = starting_comp
	end
	local fields = {}
	local pattern = string.format("([^%s]+)", ">")
	string.gsub(str, pattern, function(c)
		c = string.gsub(c, "^%s+", "")
		c = string.gsub(c, "%s+$", "")
		if c ~= "root" then
			fields[#fields+1] = c
		end
	end)
	return find_uicomponent(has_starting_comp and starting_comp or core:get_ui_root(), unpack(fields))
end

local campaign_key = "main_warhammer";
local cod_ll_popularity_regions = {};
local power_of_authority_vfx = "settlement_produces_ritual_currency"
local cod_naval_defender_faction_key = "wh2_main_hef_citadel_of_dusk";
local cod_naval_defender_effect = "";
mod.cod_naval_defender_level_inner = mod.cod_naval_defender_level_inner == nil and 1 or mod.cod_naval_defender_level_inner;
mod.cod_naval_defender_level_outer = mod.cod_naval_defender_level_outer == nil and 1 or mod.cod_naval_defender_level_outer;
mod.cod_naval_defender_level_all = mod.cod_naval_defender_level_all == nil and 1 or mod.cod_naval_defender_level_all;
mod.cod_naval_grace = mod.cod_naval_grace or 32;

local maluses_inner = {
	["wh_main_effect_economy_trade_tariff_mod"] = {-55, -100},
	["wh2_main_faction_political_diplomacy_mod_high_elves"] = {-5, -30},
	["wh_main_effect_force_all_campaign_upkeep"] = {16, 30},
	["wh_dlc05_effect_global_recruitment_duration_all"] = {0, 8},
	["wh_main_effect_public_order_base"] = {-3, -5},
	["wh_main_effect_force_all_campaign_recruitment_cost_all"] = {16, 30}
}

local maluses_outer = {
	["wh_main_effect_economy_trade_tariff_mod"] = {-5,-50},
	["wh_main_effect_force_all_campaign_upkeep"] = {1,15},
	["wh_main_effect_public_order_base"] = {-1,-3},
	["wh_main_effect_force_all_campaign_recruitment_cost_all"] = {1,15},
	["wh3_main_faction_political_diplomacy_mod_cathay"] = {5,3},
}

local maluses_safe = {
	["wh_main_effect_economy_trade_tariff_mod"] = {10.0000, 100.0000},
	["wh2_main_faction_political_diplomacy_mod_high_elves"] = {3.0000, 30.0000},
	["wh_main_effect_public_order_base"] = {1.0000, 5.0000},
	["wh_dlc05_effect_global_recruitment_duration_all"] = {-1.0000, -1.0000},
	["wh_main_effect_force_all_campaign_upkeep"] = {-3.0000, -30.0000},
	["wh_main_effect_force_all_campaign_recruitment_cost_all"] = {-3.0000, -30.0000},
	["wh3_main_faction_political_diplomacy_mod_cathay"] = {5.0000, 10.0000},
}

local specific_maluses_inner = {
	[1] = {
		["wh3_main_faction_political_diplomacy_mod_cathay"] = 3
	}
}

local malus_per_ten_inner = {}
for malus_effect, malus_range in pairs(maluses_inner) do
	local per_ten = (malus_range[2]-malus_range[1])/9
	malus_per_ten_inner[malus_effect] = per_ten
end

local malus_per_ten_outer = {}
for malus_effect, malus_range in pairs(maluses_outer) do
	local per_ten = (malus_range[2]-malus_range[1])/9
	malus_per_ten_outer[malus_effect] = per_ten
end

local malus_per_ten_safe = {}
for malus_effect, malus_range in pairs(maluses_safe) do
	local per_ten = (malus_range[2]-malus_range[1])/9
	malus_per_ten_safe[malus_effect] = per_ten
end

local malus_effect_to_scope = {
	["wh_main_effect_economy_trade_tariff_mod"] = "faction_to_region_own",
	["wh2_main_faction_political_diplomacy_mod_high_elves"] = "faction_to_faction_own_unseen",
	["wh_main_effect_public_order_base"] = "faction_to_province_own",
	["wh_dlc05_effect_global_recruitment_duration_all"] = "faction_to_faction_own_unseen",
	["wh_main_effect_force_all_campaign_upkeep"] = "faction_to_force_own",
	["wh_main_effect_force_all_campaign_recruitment_cost_all"] = "faction_to_force_own",
	["wh3_main_faction_political_diplomacy_mod_cathay"] = "faction_to_faction_own_unseen",
}

mod.cod_regions = {
	["main_warhammer"] = {
		["outer"] = {
			["wh3_main_combi_region_angerrial"] = true,
			["wh3_main_combi_region_lothern"] = true,
			["wh3_main_combi_region_shrine_of_asuryan"] = true,
			["wh3_main_combi_region_tower_of_lysean"] = true
        },
		["inner"] = {
			["wh3_main_combi_region_citadel_of_dusk"] = true,
			["wh3_main_combi_region_dusk_peaks"] = true,
			["wh3_main_combi_region_chupayotl"] = true,
			["wh3_main_combi_region_mangrove_coast"] = true,
			["wh3_main_combi_region_altar_of_the_horned_rat"] = true,
			["wh3_main_combi_region_the_star_tower"] = true,
			["wh3_main_combi_region_fuming_serpent"] = true,
			["wh3_main_combi_region_the_blood_swamps"] = true,
			["wh3_main_combi_region_pox_marsh"] = true,
			["wh3_main_combi_region_tlax"] = true,
			["wh3_main_combi_region_the_awakening"] = true,
			["wh3_main_combi_region_temple_of_tlencan"] = true,
			["wh3_main_combi_region_temple_of_kara"] = true,
			["wh3_main_combi_region_the_high_sentinel"] = true,
			["wh3_main_combi_region_shrine_of_sotek"] = true,
			["wh3_main_combi_region_kaiax"] = true
		},
		["outer_lost"] = 3, -- will get recalcuated in initialize
		["inner_lost"] = 14 -- will get recalcuated in initialize
	}
};
local cod_regions = mod.cod_regions

mod.num_inner_regions = 0
-- only for main_warhammer
for _ in pairs(cod_regions) do
	mod.num_inner_regions = mod.num_inner_regions + 1
end

cod_regions.main_warhammer.outer_sorted = {}
cod_regions.main_warhammer.inner_sorted = {}
cod_regions.localized_region_name_to_region_key = {}

local defender_bundles = {
	"cod_naval_defender_block",
	"cod_naval_defender_vbad",
	"cod_naval_defender_bad",
	"cod_naval_defender_ok",
	"ovn_cod_supply_lines_safe",
	"ovn_cod_supply_lines_outer_1",
	"ovn_cod_supply_lines_outer_2",
	"ovn_cod_supply_lines_outer_3",
	"ovn_cod_supply_lines_outer_4",
}

local defender_level_to_bundle_inner = {
	[10] = "cod_naval_defender_block",
	[9] = "cod_naval_defender_block",
	[8] = "cod_naval_defender_block",
	[7] = "cod_naval_defender_vbad",
	[6] = "cod_naval_defender_vbad",
	[5] = "cod_naval_defender_vbad",
	[4] = "cod_naval_defender_bad",
	[3] = "cod_naval_defender_bad",
	[2] = "cod_naval_defender_bad",
	[1] = "cod_naval_defender_ok",
}

local defender_level_to_bundle_outer = {
	[10] = "ovn_cod_supply_lines_outer_4",
	[9] = "ovn_cod_supply_lines_outer_4",
	[8] = "ovn_cod_supply_lines_outer_3",
	[7] = "ovn_cod_supply_lines_outer_3",
	[6] = "ovn_cod_supply_lines_outer_3",
	[5] = "ovn_cod_supply_lines_outer_2",
	[4] = "ovn_cod_supply_lines_outer_2",
	[3] = "ovn_cod_supply_lines_outer_2",
	[2] = "ovn_cod_supply_lines_outer_1",
	[1] = "ovn_cod_supply_lines_outer_1",
}

local defender_level_to_bundle_safe = {
	[10] = "ovn_cod_supply_lines_safe",
	[9] = "ovn_cod_supply_lines_safe",
	[8] = "ovn_cod_supply_lines_safe",
	[7] = "ovn_cod_supply_lines_safe",
	[6] = "ovn_cod_supply_lines_safe",
	[5] = "ovn_cod_supply_lines_safe",
	[4] = "ovn_cod_supply_lines_safe",
	[3] = "ovn_cod_supply_lines_safe",
	[2] = "ovn_cod_supply_lines_safe",
	[1] = "ovn_cod_supply_lines_safe",
}

local localized_text_region_is_dangerous = ""
local localized_text_region_is_safe = ""

local math_round = function(x) return math.floor(x+0.5) end

mod.set_cod_naval_defender_level = function(new_level)
	local is_inner = cod_regions[campaign_key]["inner_lost"] > 0
	local is_outer = cod_regions[campaign_key]["outer_lost"] > 0

	if is_inner then
		mod.cod_naval_defender_level_inner = new_level
	elseif is_outer then
		mod.cod_naval_defender_level_outer = new_level
	else
		mod.cod_naval_defender_level_all = new_level
	end
end

---@param region CA_REGION
mod.is_region_ownership_safe = function(region)
	if region:is_abandoned() then return false end

	if region:owning_faction():culture() == "wh2_main_hef_high_elves" then return true end

	local cod_faction = cm:get_faction(cod_naval_defender_faction_key)
	return cod_faction:military_allies_with(region:owning_faction())
end

mod.apply_naval_effect_bundles = function()
	local is_inner = cod_regions[campaign_key]["inner_lost"] > 0
	local is_outer = cod_regions[campaign_key]["outer_lost"] > 0

	local defender_level_to_bundle = is_inner and defender_level_to_bundle_inner or is_outer and defender_level_to_bundle_outer or defender_level_to_bundle_safe
	local cod_naval_defender_level = is_inner and mod.cod_naval_defender_level_inner or is_outer and mod.cod_naval_defender_level_outer or mod.cod_naval_defender_level_all

	-- TODO CHANGE
	local cod_naval_effect_bundle_key = defender_level_to_bundle[cod_naval_defender_level]
	if not cod_naval_effect_bundle_key then return end

	local cod_naval_effect_bundle = cm:create_new_custom_effect_bundle(cod_naval_effect_bundle_key)

	local malus_per_ten = is_inner and malus_per_ten_inner or is_outer and malus_per_ten_outer or malus_per_ten_safe
	local maluses = is_inner and maluses_inner or is_outer and maluses_outer or maluses_safe

	for malus, current_malus_per_ten in pairs(malus_per_ten) do
		local new_malus_value_float = (cod_naval_defender_level-1)*current_malus_per_ten
		local new_malus_value =  math_round(new_malus_value_float)+maluses[malus][1]
		local malus_scope = malus_effect_to_scope[malus]
		-- dout(malus,new_malus_value,new_malus_value_float)
		if new_malus_value ~= 0 and malus_scope then
			cod_naval_effect_bundle:add_effect(malus, malus_scope, new_malus_value)
		end
	end

	if is_inner then
		local specific = specific_maluses_inner[cod_naval_defender_level]
		if specific then
			for malus_key, value in pairs(specific) do
				local malus_scope = malus_effect_to_scope[malus_key]
				if malus_scope then
					cod_naval_effect_bundle:add_effect(malus_key, malus_scope, value)
				end
			end
		end
	end

	cm:apply_custom_effect_bundle_to_faction(cod_naval_effect_bundle, cm:get_faction(cod_naval_defender_faction_key))

	local was_prediction_made = false
	local prediction_bundle = cm:create_new_custom_effect_bundle("ovn_cod_supply_lines_predicted")
	if cod_naval_defender_level > 0 and cod_naval_defender_level < 10 then
		local predicted_cod_naval_defender_level = cod_naval_defender_level + 1
		was_prediction_made = true
		prediction_bundle:add_effect("ovn_cod_naval_defender_change_turns", "building_to_force_own_in_adjacent_province_unseen", math.ceil(mod.cod_naval_grace/2))
		prediction_bundle:add_effect("ovn_cod_naval_defender_change_list", "building_to_force_own_in_adjacent_province_unseen", 1)

		for malus, current_malus_per_ten in pairs(malus_per_ten) do
			local new_malus_value_float = (predicted_cod_naval_defender_level-1)*current_malus_per_ten
			local new_malus_value =  math_round(new_malus_value_float)+maluses[malus][1]
			local malus_scope = malus_effect_to_scope[malus]
			if new_malus_value ~= 0 and malus_scope then
				prediction_bundle:add_effect(malus, "building_to_force_own_in_adjacent_province_unseen", new_malus_value)
			end
		end
	end
	cm:remove_effect_bundle("ovn_cod_supply_lines_predicted", cod_naval_defender_faction_key)
	if was_prediction_made then
		cm:apply_custom_effect_bundle_to_faction(prediction_bundle, cm:get_faction(cod_naval_defender_faction_key))
	end
end

function add_cod_naval_listeners()
	for region_key in pairs(cod_regions.main_warhammer.outer) do
		local localized_region_name = common.get_localised_string("regions_onscreen_"..tostring(region_key))
		table.insert(cod_regions.main_warhammer.outer_sorted, localized_region_name)
		cod_regions.localized_region_name_to_region_key[localized_region_name] = region_key
	end
	table.sort(cod_regions.main_warhammer.outer_sorted)
	for region_key in pairs(cod_regions.main_warhammer.inner) do
		local localized_region_name = common.get_localised_string("regions_onscreen_"..tostring(region_key))
		table.insert(cod_regions.main_warhammer.inner_sorted, localized_region_name)
		cod_regions.localized_region_name_to_region_key[localized_region_name] = region_key
	end
	table.sort(cod_regions.main_warhammer.inner_sorted)

	cod_regions.localized_region_name_to_region_key["inner_sorted"] = common.get_localised_string("cod_inner_sorted")
	cod_regions.localized_region_name_to_region_key["outer_sorted"] = common.get_localised_string("cod_outer_sorted")
	
	localized_text_region_is_dangerous = common.get_localised_string("cod_supply_lines_status_dangerous_script_text")
	localized_text_region_is_safe = common.get_localised_string("cod_supply_lines_status_safe_script_text")

	out("#### Adding cod_naval Listeners ####");
	local cod_naval = cm:model():world():faction_by_key(cod_naval_defender_faction_key);

	-- COD CAPITAL INVISIBILITY MECH
	core:add_listener(
		"cod_capital_invisibility_update_listener",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == cod_naval_defender_faction_key and cm:get_campaign_name() == "main_warhammer";
		end,
		function(context)
			local random_number = cm:random_number(3, 1)
			if random_number == 1 then
				cm:cai_disable_targeting_against_settlement("settlement:wh3_main_combi_region_citadel_of_dusk")
			else
				cm:cai_enable_targeting_against_settlement("settlement:wh3_main_combi_region_citadel_of_dusk")
			end
		end,
		true
	);
	-- NAVAL TARGET REGIONS COMPONENTS

	if cod_naval:is_human() and cm:get_campaign_name() == "main_warhammer" then

	local cod_bundle_title_text = common.get_localised_string("cod_supply_lines_status_script_text")
	
	cm:apply_effect_bundle("cod_supply_lines_status", cod_naval_defender_faction_key, -1);
	core:remove_listener("cod_supply_lines_status_listener")
	core:add_listener(
		"cod_supply_lines_status_listener",
		"RealTimeTrigger",
		function(context)
				return context.string == "cod_supply_lines_status"
		end,
		function()
			local map = find_uicomponent(core:get_ui_root(), "cod_supply_lines_map")

			local tt = find_ui_component_str("root > TechTooltipPopup")
			if not tt or not tt:Visible() then
				if map then map:SetVisible(false) end
				return
			end

			local tooltip_title = find_ui_component_str("root > TechTooltipPopup > dy_title")
			local title_text = tooltip_title:GetStateText()

			if title_text == cod_bundle_title_text then
				if not map then
					map = UIComponent(core:get_ui_root():CreateComponent("cod_supply_lines_map", "ui/cod_naval_defender_map"))
					map:SetCanResizeHeight(true)
					map:SetCanResizeWidth(true)
					map:Resize(tt:Height()+6,tt:Height()+6)
					map:SetImagePath("ui/cod_supply_lines_map.png",0)
				end

				local px, py = tt:Position()
				map:MoveTo(px-map:Width()+12, py-2)
				map:SetVisible(true)
			else
				if map then map:SetVisible(false) end
			end

			if title_text ~= "Naval Supply Lines Status" then return end

			tooltip_title:SetStateText(cod_bundle_title_text)

			local tooltip_desc = find_ui_component_str("root > TechTooltipPopup > description_window")

			local desc_text = ""

			local campaign_regions = cod_regions[cm:get_campaign_name()]
			if not campaign_regions then return end

			for regions_group, regions in pairs(campaign_regions) do
				if (cod_regions[campaign_key]["inner_lost"] == 0 and regions_group == "outer_sorted") or regions_group == "inner_sorted" then
					if desc_text ~= "" then desc_text = desc_text.."\n" end
					desc_text = desc_text.."\n"..cod_regions.localized_region_name_to_region_key[regions_group]
					for _, localized_region_name in ipairs(regions) do
						desc_text = desc_text.."\n"..localized_region_name

						local region_key = cod_regions.localized_region_name_to_region_key[localized_region_name]
						if region_key then
							local region = cm:get_region(region_key)
							if region:is_abandoned() or not mod.is_region_ownership_safe(region) then
								desc_text = desc_text
									..": [[col:red]]"
									..localized_text_region_is_dangerous
									.."[[/col]]"
							else
								desc_text = desc_text
									..": [[col:green]]"
									..localized_text_region_is_safe
									.."[[/col]]"
							end
						end
					end
				end
			end

			tooltip_desc:SetStateText(desc_text)
		end,
		true
	)

	real_timer.unregister("cod_supply_lines_status")
	real_timer.register_repeating("cod_supply_lines_status", 0)

	-- POWER OF AUTHORITY
	core:remove_listener("cod_power_of_authority")
	core:add_listener(
		"cod_power_of_authority",
		"CharacterTurnStart",
		function(context)
			local current_char = context:character();
			return current_char:has_region() and current_char:is_at_sea() == false and current_char:character_subtype("wh2_dlc10_hef_alarielle") or
			 current_char:has_region() and current_char:is_at_sea() == false and current_char:character_subtype("wh2_dlc10_hef_alith_anar") or
			 current_char:has_region() and current_char:is_at_sea() == false and current_char:character_subtype("wh2_main_hef_teclis") or
			 current_char:has_region() and current_char:is_at_sea() == false and current_char:character_subtype("wh2_main_hef_tyrion") or
			 current_char:has_region() and current_char:is_at_sea() == false and current_char:character_subtype("wh2_dlc15_hef_eltharion") or
			 current_char:has_region() and current_char:is_at_sea() == false and current_char:character_subtype("wh2_dlc15_hef_imrik") or
			 current_char:has_region() and current_char:is_at_sea() == false and current_char:character_subtype("ovn_stormrider")
		end,
		function(context)
			local current_char = context:character();
			local region = current_char:region();

			if region:is_abandoned() == false and region:owning_faction():name() == cod_naval_defender_faction_key then
				local region_key = region:name();
				cm:remove_effect_bundle_from_region("ovn_cod_power_of_authority", region_key);
				cm:apply_effect_bundle_to_region("ovn_cod_power_of_authority", region_key, 6);
				cod_ll_popularity_regions[region_key] = 10;
				local garrison_residence = region:garrison_residence();
				local garrison_residence_CQI = garrison_residence:command_queue_index();
				cm:add_garrison_residence_vfx(garrison_residence_CQI, power_of_authority_vfx, false);
				core:trigger_event("ScriptEventPowerOfNatureTriggered");
			end
		end,
		true
	);
	core:remove_listener("cod_power_of_authority_region")
	core:add_listener(
		"cod_power_of_authority_region",
		"RegionTurnStart",
		function(context)
			local region = context:region();
			return cod_ll_popularity_regions[region:name()] ~= nil;
		end,
		function(context)
			local region = context:region();
			local region_key = region:name();
			local garrison_residence = region:garrison_residence();
			local garrison_residence_CQI = garrison_residence:command_queue_index();

			local turns_remaining = cod_ll_popularity_regions[region_key];
			turns_remaining = turns_remaining - 1;

			if region:is_abandoned() or not mod.is_region_ownership_safe(region) then
				turns_remaining = 0
			end

			-- remove old vfx from the region
			cm:remove_garrison_residence_vfx(garrison_residence_CQI, power_of_authority_vfx);

			if turns_remaining > 0 then
				cm:add_garrison_residence_vfx(garrison_residence_CQI, power_of_authority_vfx, false);
				cod_ll_popularity_regions[region_key] = turns_remaining;
			else
				-- Remove all VFX
				cod_ll_popularity_regions[region_key] = nil;
				cm:remove_effect_bundle_from_region("ovn_cod_power_of_authority", region_key);
			end
		end,
		true
	);

	core:remove_listener("cod_check_region")
	core:add_listener(
		"cod_check_region",
		"RegionTurnStart",
		function(context)
			local region = context:region();
			return cod_regions["all"][region:name()] ~= nil;
		end,
		function(context)
			local region = context:region();
			cod_naval_defender_update(region)
		end,
		true
	);

	core:remove_listener("cod_naval_action_region_update")
	core:add_listener(
		"cod_naval_action_region_update",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:character():faction():is_human() and context:character():faction():name() == cod_naval_defender_faction_key
		end,
		function(context)
			if cod_regions["all"] then
				local region_key = context:garrison_residence():region():name();
				if cod_regions["all"][region_key] then
					mod.cod_naval_grace = mod.cod_naval_grace + 4;
					
					cm:apply_effect_bundle("cod_influence", "wh2_main_hef_citadel_of_dusk", 2);
					cm:apply_dilemma_diplomatic_bonus("wh2_main_hef_citadel_of_dusk", "wh2_main_hef_eataine", 4)
					cm:apply_dilemma_diplomatic_bonus("wh2_main_hef_citadel_of_dusk", "wh2_main_hef_order_of_loremasters", 4)

					-- check if we can lower cod_naval_defender_level
					local is_inner = cod_regions[campaign_key]["inner_lost"] > 0
					local is_outer = cod_regions[campaign_key]["outer_lost"] > 0
					local cod_naval_defender_level = is_inner and mod.cod_naval_defender_level_inner or is_outer and mod.cod_naval_defender_level_outer or mod.cod_naval_defender_level_all
					if cod_naval_defender_level > 1 and mod.cod_naval_grace > 10 then
						mod.set_cod_naval_defender_level(math.clamp(cod_naval_defender_level-1, 1, 10))
						mod.cod_naval_grace = 10
					end
					
					mod.apply_naval_effect_bundles()
				end
			end
		end,
		true
	);

		-- COD NAVAL DEFENDER MECH
		core:remove_listener("cod_naval_defender_region_update")
		core:add_listener(
			"cod_naval_defender_region_update",
			"CharacterPerformsSettlementOccupationDecision",
			function(context)
				if cod_regions["all"] then
					local region_key = context:garrison_residence():region():name();
					return cod_regions["all"][region_key] == true;
				else
					return false;
				end
			end,
			function(context)
				local region = context:garrison_residence():region();
				cod_naval_defender_update(region);
			end,
			true
		);

		core:remove_listener("cod_naval_defender_update_listener")
		core:add_listener(
			"cod_naval_defender_update_listener",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == cod_naval_defender_faction_key;
			end,
			function(context)
				local is_inner = cod_regions[campaign_key]["inner_lost"] > 0
				local is_outer = cod_regions[campaign_key]["outer_lost"] > 0
				local cod_naval_defender_level = is_inner and mod.cod_naval_defender_level_inner or is_outer and mod.cod_naval_defender_level_outer or mod.cod_naval_defender_level_all
				if cod_naval_defender_level < 10 then
					mod.cod_naval_grace = math.max(mod.cod_naval_grace-2, 0)
					if mod.cod_naval_grace <= 0 then
						mod.set_cod_naval_defender_level(math.clamp(cod_naval_defender_level+1, 1, 10))
						mod.cod_naval_grace = 10
					end
				end

				local turn = cm:model():turn_number();
                local cooldown = 4
                if turn % cooldown == 0 then
					cod_naval_defender_initialize_invasion_and_supply()
				end
				cod_naval_defender_remove_effects(cod_naval_defender_faction_key);
				mod.apply_naval_effect_bundles()
			end,
			true
		);

		local is_new_game = cm:is_new_game()
		if is_new_game then
			cod_naval_intro_listeners();
			mod.cod_naval_grace = 32
		end

		cod_naval_defender_initialize(is_new_game);
	end
end

function cod_naval_defender_initialize(new_game)
	local naval_route_types = {"inner", "outer"};

	cod_regions["wh2_main_great_vortex"] = nil;

	-- Populate a lookup table of all relevant regions
	cod_regions["all"] = {};

	for i = 1, #naval_route_types do
		cod_regions[campaign_key][naval_route_types[i].."_lost"] = 0
	end

	for i = 1, #naval_route_types do
		for region_key, value in pairs(cod_regions[campaign_key][naval_route_types[i]]) do
			cod_regions["all"][region_key] = true;
			local region = cm:model():world():region_manager():region_by_key(region_key);

			if not region:is_null_interface() then
				if region:is_abandoned() or not mod.is_region_ownership_safe(region) then
					cod_regions[campaign_key][naval_route_types[i]][region_key] = false;
					cod_regions[campaign_key][naval_route_types[i].."_lost"] = cod_regions[campaign_key][naval_route_types[i].."_lost"] + 1;
				end
			end
		end
	end

	cod_naval_defender_remove_effects(cod_naval_defender_faction_key);

	if new_game then
		mod.cod_naval_defender_level_inner = 1
	end

	mod.apply_naval_effect_bundles()

	--- COD NAVAL DEFENDER INVASION RAM
	random_army_manager:new_force("ovn_cod_vamp_coast_force");
    random_army_manager:add_mandatory_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_inf_zombie_gunnery_mob_1", 3);
    random_army_manager:add_mandatory_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_inf_depth_guard_1", 3);
    random_army_manager:add_mandatory_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_mon_necrofex_colossus_0", 1);
    random_army_manager:add_mandatory_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_art_carronade", 1);
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_mon_rotting_leviathan_0", 1);
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_mon_terrorgheist", 1);
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_inf_syreens", 1);
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_inf_depth_guard_0", 1);
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_inf_deck_gunners_0", 1);
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_art_carronade", 1);
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_art_mortar", 1);
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_mon_mournguls_0", 1);
    random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_mon_bloated_corpse_0", 2);
	random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_cav_deck_droppers_1", 2);
	random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_inf_zombie_deckhands_mob_0", 3);
	random_army_manager:add_unit("ovn_cod_vamp_coast_force", "wh2_dlc11_cst_mon_fell_bats", 2);

    random_army_manager:new_force("ovn_cod_norsca_force");
    random_army_manager:add_mandatory_unit("ovn_cod_norsca_force", "wh_dlc08_nor_mon_fimir_1", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_norsca_force", "wh_dlc08_nor_mon_war_mammoth_2", 1);
    random_army_manager:add_mandatory_unit("ovn_cod_norsca_force", "wh_dlc08_nor_inf_marauder_champions_0", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_norsca_force", "wh_dlc08_nor_mon_skinwolves_1", 1);
    random_army_manager:add_mandatory_unit("ovn_cod_norsca_force", "wh_dlc08_nor_art_hellcannon_battery", 1);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_dlc08_nor_mon_war_mammoth_1", 1);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_main_nor_cav_marauder_horsemen_1", 2);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_dlc08_nor_mon_norscan_giant_0", 1);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_dlc08_nor_inf_marauder_champions_1", 2);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_dlc08_nor_inf_marauder_hunters_0", 1);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_dlc08_nor_mon_fimir_0", 2);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_dlc08_nor_mon_frost_wyrm_0", 1);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_dlc08_nor_mon_norscan_ice_trolls_0", 2);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_main_nor_cav_chaos_chariot", 1);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_dlc08_nor_inf_marauder_berserkers_0", 1);
    random_army_manager:add_unit("ovn_cod_norsca_force", "wh_main_nor_inf_chaos_marauders_0", 4);

    random_army_manager:new_force("ovn_cod_skaven_force");
    random_army_manager:add_mandatory_unit("ovn_cod_skaven_force", "wh2_dlc12_skv_inf_warplock_jezzails_0", 1);
    random_army_manager:add_mandatory_unit("ovn_cod_skaven_force", "wh2_main_skv_art_plagueclaw_catapult", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_stormvermin_0", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_skaven_force", "wh2_dlc12_skv_inf_ratling_gun_0", 1);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_art_warp_lightning_cannon", 1);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_plague_monk_censer_bearer", 1);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_poison_wind_globadiers", 1);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_dlc14_skv_inf_eshin_triads_0", 1);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_gutter_runners_1", 1);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_night_runners_1", 1);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_warpfire_thrower", 1);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_stormvermin_1", 2);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_mon_rat_ogres", 2);
    random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_veh_doomwheel", 1);
	random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_dlc12_skv_veh_doom_flayer_0", 1);
	random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_skavenslaves_0", 4);
	random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_skavenslave_slingers_0", 2);
	random_army_manager:add_unit("ovn_cod_skaven_force", "wh2_main_skv_inf_clanrats_1", 3);

	random_army_manager:new_force("ovn_cod_greenskin_force");
    random_army_manager:add_mandatory_unit("ovn_cod_greenskin_force", "wh_main_grn_art_doom_diver_catapult", 1);
    random_army_manager:add_mandatory_unit("ovn_cod_greenskin_force", "wh_main_grn_art_goblin_rock_lobber", 1);
    random_army_manager:add_mandatory_unit("ovn_cod_greenskin_force", "wh_main_grn_inf_orc_big_uns", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_greenskin_force", "wh_main_grn_inf_night_goblin_fanatics", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_greenskin_force", "wh_main_grn_mon_arachnarok_spider_0", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_mon_trolls", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_mon_giant", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_cav_forest_goblin_spider_riders_0", 2);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_cav_forest_goblin_spider_riders_1", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_cav_orc_boar_boy_big_uns", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_cav_savage_orc_boar_boy_big_uns", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_cav_goblin_wolf_riders_1", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_dlc06_grn_inf_squig_herd_0", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_dlc06_grn_inf_nasty_skulkers_0", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_inf_night_goblin_archers", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_inf_night_goblins", 1);
    random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_inf_goblin_archers", 1);
	random_army_manager:add_unit("ovn_cod_greenskin_force", "wh_main_grn_art_goblin_rock_lobber", 1);

	random_army_manager:new_force("ovn_cod_dark_elves_force");
    random_army_manager:add_mandatory_unit("ovn_cod_dark_elves_force", "wh2_main_def_inf_har_ganeth_executioners_0", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_dark_elves_force", "wh2_dlc10_def_inf_sisters_of_slaughter", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_dark_elves_force", "wh2_main_def_inf_darkshards_1", 1);
    random_army_manager:add_mandatory_unit("ovn_cod_dark_elves_force", "wh2_main_def_art_reaper_bolt_thrower", 1);
    random_army_manager:add_mandatory_unit("ovn_cod_dark_elves_force", "wh2_main_def_inf_black_ark_corsairs_0", 3);
    random_army_manager:add_mandatory_unit("ovn_cod_dark_elves_force", "wh2_main_def_inf_black_ark_corsairs_1", 3);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_main_def_inf_witch_elves_0", 1);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_main_def_inf_harpies", 1);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_main_def_inf_shades_2", 1);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_main_def_mon_war_hydra", 1);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_main_def_inf_black_guard_0", 2);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_dlc10_def_cav_doomfire_warlocks_0", 1);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_main_def_cav_cold_one_knights_1", 2);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_main_def_cav_cold_one_chariot", 1);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_main_def_mon_black_dragon", 1);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_dlc10_def_mon_kharibdyss_0", 1);
    random_army_manager:add_unit("ovn_cod_dark_elves_force", "wh2_dlc14_def_mon_bloodwrack_medusa_0", 1);

    random_army_manager:new_force("ovn_cod_chaos_force");
    random_army_manager:add_mandatory_unit("ovn_cod_chaos_force", "wh3_dlc20_chs_inf_chosen_mnur", 3);
    random_army_manager:add_mandatory_unit("ovn_cod_chaos_force", "wh_dlc01_chs_mon_dragon_ogre", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_chaos_force", "wh3_dlc20_chs_inf_chosen_mkho_dualweapons", 2);
    random_army_manager:add_mandatory_unit("ovn_cod_chaos_force", "wh_main_chs_art_hellcannon", 1);
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh_dlc01_chs_mon_dragon_ogre_shaggoth", 1);
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh_dlc01_chs_mon_trolls_1", 1);
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh_dlc01_chs_inf_chosen_0", 2);
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh_dlc06_chs_cav_marauder_horsemasters_0", 1);
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh3_dlc20_chs_cav_chaos_chariot_msla", 1);
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh3_main_kho_cav_gorebeast_chariot", 1);
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh3_main_sla_cav_hellstriders_1", 1);
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh3_main_tze_cav_doom_knights_0", 1);
    random_army_manager:add_unit("ovn_cod_chaos_force", "wh3_dlc20_chs_mon_giant_mnur_ror", 1);
	random_army_manager:add_unit("ovn_cod_chaos_force", "wh3_main_nur_mon_spawn_of_nurgle_0_warriors", 2);
	random_army_manager:add_unit("ovn_cod_chaos_force", "wh3_dlc20_chs_inf_forsaken_msla", 2);
	random_army_manager:add_unit("ovn_cod_chaos_force", "wh_main_chs_inf_chaos_warriors_0", 2);
	random_army_manager:add_unit("ovn_cod_chaos_force", "wh3_main_kho_inf_chaos_warriors_0", 2);
	random_army_manager:add_unit("ovn_cod_chaos_force", "wh3_dlc20_chs_inf_chaos_warriors_msla_hellscourges", 2);
	random_army_manager:add_unit("ovn_cod_chaos_force", "wh3_dlc20_chs_inf_chaos_warriors_mtze_halberds", 2);
end

function cod_naval_defender_update(region)
	if region ~= nil and region:is_null_interface() == false then
		local region_key = region:name();
		out("COD NAVAL DEFENDER MECH Region Update: "..region_key);
		local naval_route_type = nil;

		if cod_regions[campaign_key]["outer"][region_key] ~= nil then
			naval_route_type = "outer";
		elseif cod_regions[campaign_key]["inner"][region_key] ~= nil then
			naval_route_type = "inner";
		end

		if naval_route_type ~= nil then
			if cod_regions[campaign_key][naval_route_type][region_key] == true then
				if region:is_abandoned() or not mod.is_region_ownership_safe(region) then
					cod_regions[campaign_key][naval_route_type][region_key] = false;
					cod_regions[campaign_key][naval_route_type.."_lost"] = cod_regions[campaign_key][naval_route_type.."_lost"] + 1;
					mod.cod_naval_grace = mod.cod_naval_grace - 2;
					out("\tRegion was true and is now false - Value "..naval_route_type.."_lost count is "..tostring(cod_regions[campaign_key][naval_route_type.."_lost"]).." (+1)");
				end
			elseif cod_regions[campaign_key][naval_route_type][region_key] == false then
				if mod.is_region_ownership_safe(region) then
					cod_regions[campaign_key][naval_route_type][region_key] = true;
					cod_regions[campaign_key][naval_route_type.."_lost"] = cod_regions[campaign_key][naval_route_type.."_lost"] - 1;
					out("\tRegion was false and is now true - Value "..naval_route_type.."_lost count is "..tostring(cod_regions[campaign_key][naval_route_type.."_lost"]).." (-1)");
				end
			else
				out("\tNo changes made");
				return
			end

			cod_naval_defender_remove_effects(cod_naval_defender_faction_key);

			if cod_regions[campaign_key]["inner_lost"] > 0 then
				if cod_naval_defender_effect == "ovn_cod_naval_defender_all" or cod_naval_defender_effect == "ovn_cod_naval_defender_outer" then
					cod_naval_defender_show_event(region, "inner_lost");
					core:trigger_event("ScriptEventCodNavalDefenderInnerLost");
					mod.cod_naval_grace = 10;
				end
				cod_naval_defender_effect = "ovn_cod_naval_defender_inner";
			elseif cod_regions[campaign_key]["outer_lost"] > 0 then
				if cod_naval_defender_effect == "ovn_cod_naval_defender_all" then
					cod_naval_defender_show_event(region, "outer_lost");
					core:trigger_event("ScriptEventCodNavalDefenderOuterLost");
					mod.cod_naval_grace = 10;
				elseif cod_naval_defender_effect == "ovn_cod_naval_defender_inner" then
					core:trigger_event("ScriptEventCodNavalDefenderInnerRegained");
					mod.cod_naval_grace = 10;
				end
				cod_naval_defender_effect = "ovn_cod_naval_defender_outer";
			else
				if cod_naval_defender_effect == "ovn_cod_naval_defender_outer" or cod_naval_defender_effect == "ovn_cod_naval_defender_inner" then
					cod_naval_defender_show_event(region, "united");
					core:trigger_event("ScriptEventCodNavalDefenderUnited");
					mod.cod_naval_grace = 10;
				end
				cod_naval_defender_effect = "ovn_cod_naval_defender_all";
			end

			mod.apply_naval_effect_bundles()
		end
	end
end

function cod_naval_defender_remove_effects(faction_str)
	for _, defender_bundle_key in ipairs(defender_bundles) do
		cm:remove_effect_bundle(defender_bundle_key, faction_str)
	end
end

function cod_naval_defender_show_event(region, event_type)
	if event_type == "united" then
		cm:show_message_event(
			cod_naval_defender_faction_key,
			"event_feed_strings_text_".."ovn_event_feed_string_scripted_event_cod_naval_defender_title",
			"event_feed_strings_text_".."ovn_event_feed_string_scripted_event_cod_naval_defender_united_primary_detail",
			"event_feed_strings_text_".."ovn_event_feed_string_scripted_event_cod_naval_defender_united_secondary_detail",
			false,
			1012
		);
	else
		local x = region:settlement():logical_position_x();
		local y = region:settlement():logical_position_y();

		cm:show_message_event_located(
			cod_naval_defender_faction_key,
			"event_feed_strings_text_".."ovn_event_feed_string_scripted_event_cod_naval_defender_title",
			"event_feed_strings_text_".."ovn_event_feed_string_scripted_event_cod_naval_defender_"..event_type.."_primary_detail",
			"event_feed_strings_text_".."ovn_event_feed_string_scripted_event_cod_naval_defender_"..event_type.."_secondary_detail",
			x,
			y,
			false,
			1013
		);
	end
end

function cod_naval_intro_listeners()
	core:remove_listener("cod_naval_PanelOpenedCampaign")
	core:add_listener(
		"cod_naval_PanelOpenedCampaign",
		"PanelOpenedCampaign",
		function(context)
			local event_type, event_target, event_group = UIComponent(context.component):InterfaceFunction("GetEventType");

			if event_group == "wh_main_event_feed_scripted_intro_empire" then
				return true;
			end
			return false;
		end,
		function(context)
			local cod_naval_defender = find_uicomponent(core:get_ui_root(), "layout", "resources_bar", "topbar_list_parent", "alarielle_holder", "icon_effect");

			if cod_naval_defender then
				pulse_uicomponent(cod_naval_defender, true, 5);
			end
		end,
		false
	);
	core:remove_listener("cod_naval_PanelClosedCampaign")
	core:add_listener(
		"cod_naval_PanelClosedCampaign",
		"PanelClosedCampaign",
		function(context)
			local event_type, event_target, event_group = UIComponent(context.component):InterfaceFunction("GetEventType");

			if event_group == "wh_main_event_feed_scripted_intro_empire" then
				return true;
			end
			return false;
		end,
		function(context)
			local cod_naval_defender = find_uicomponent(core:get_ui_root(), "layout", "resources_bar", "topbar_list_parent", "alarielle_holder", "icon_effect");

			if cod_naval_defender then
				pulse_uicomponent(cod_naval_defender, false);
			end
		end,
		false
	);
end

function cod_naval_defender_initialize_invasion_and_supply()

	local faction_name_str = cod_naval_defender_faction_key
    local faction = cm:get_faction(faction_name_str);
	local high_roll = cm:random_number(4, 1) -- 25% Chance 4
	local standard_roll = cm:random_number(6, 1) -- 16.67% Chance 6
	local low_roll = cm:random_number(8, 1) -- 12.5% Chance 8
	local very_low_roll = cm:random_number(16, 1) -- 6.25% Chance 16

	local is_inner = cod_regions[campaign_key]["inner_lost"] > 0
	local is_outer = cod_regions[campaign_key]["outer_lost"] > 0
	local cod_naval_defender_level = is_inner and mod.cod_naval_defender_level_inner or is_outer and mod.cod_naval_defender_level_outer or mod.cod_naval_defender_level_all

	if is_inner then
		for i = 6, 10 do
			-- threat_v_high
			if cod_naval_defender_level == i then
				if high_roll == 1 then
				cod_invasion_start()
				end
				if very_low_roll == 2 then
				cod_reinforce_start()
				end
			end
		end

		for i = 1, 5 do
			-- threat_high
			if cod_naval_defender_level == i then
				if standard_roll == 1 then
				cod_invasion_start()
				end
				if low_roll == 2 then
				cod_reinforce_start()
				end
				if very_low_roll == 3 then
				cod_beast_invasion_start()
				end
			end
		end
	else
		for i = 1, 10 do
			if cod_regions[campaign_key]["outer_lost"] > 0 and cod_naval_defender_level == i then
				if low_roll == 1 then
				cod_invasion_start()
				elseif low_roll == 5 then
				cod_beast_invasion_start()
				end
				if standard_roll == 2 then
				cod_reinforce_start()
				end
			elseif cod_regions[campaign_key]["outer_lost"] == 0 and cod_naval_defender_level == i then
				if very_low_roll == 1 then
				cod_invasion_start()
				end
				if standard_roll == 6 then
				cod_beast_invasion_start()
				end
				if high_roll == 2 then
				cod_reinforce_start()
				end
			end
        end
	end
end

function cod_invasion_start()
local faction_name_str = cod_naval_defender_faction_key
local faction_name = cm:get_faction(faction_name_str)
local char_faction_leader = cm:get_faction(faction_name_str):faction_leader()
local character_str = cm:char_lookup_str(char_faction_leader)
local faction_capital = faction_name:home_region():name();
local w, z = cm:find_valid_spawn_location_for_character_from_settlement(faction_name_str, faction_capital, true, false, 45)
if faction_name:has_faction_leader() and faction_name:faction_leader():has_military_force() then
	w, z = cm:find_valid_spawn_location_for_character_from_character(faction_name_str, character_str, false, 35)
end
local location = {x = w, y = z};
local location_patrol_create = w + 15, z + 50;
local location_patrol = {location_patrol_create};
local faction
local army
local upa -- units per army
local random_number = cm:random_number(6, 1)
local experience_amount
local turn_number = cm:model():turn_number();
local cod_invasion_patrol = {{location}, {location_patrol}};
local cod_invasion_targets = {
	"wh2_main_hef_citadel_of_dusk",
	"wh2_main_hef_order_of_loremasters",
	"wh2_main_hef_eataine",
	"wh2_dlc12_lzd_cult_of_sotek",
	"wh2_main_lzd_itza",
	"wh2_dlc13_emp_the_huntmarshals_expedition"
}
cod_invasion_mess()

    if cm:model():turn_number() < 25 then
        upa = {8, 9}
        experience_amount = cm:random_number(3,1)
    elseif cm:model():turn_number() < 45 and cm:model():turn_number() > 10 then
        upa = {15, 18}
        experience_amount = cm:random_number(5,1)
    elseif cm:model():turn_number() < 69 and cm:model():turn_number() > 24 then
        upa = {16, 18}
        experience_amount = cm:random_number(7,1)
    elseif cm:model():turn_number() > 70 then
        upa = {17, 19}
        experience_amount = cm:random_number(12,1)
    end

    if random_number == 1 then
        faction = "wh2_dlc11_cst_vampire_coast_qb1"
		army = random_army_manager:generate_force("ovn_cod_vamp_coast_force", upa, false);
		cm:change_custom_faction_name("wh2_dlc11_cst_vampire_coast_qb1", "Harkon's Sea Dogs")
    elseif random_number == 2 then
        faction = "wh_main_nor_norsca_qb1"
		army = random_army_manager:generate_force("ovn_cod_norsca_force", upa, false);
		cm:change_custom_faction_name("wh_main_nor_norsca_qb1", "Skeggi Raiders")
    elseif random_number == 3 then
		faction = "wh2_main_skv_skaven_qb1"
		army = random_army_manager:generate_force("ovn_cod_skaven_force", upa, false);
		cm:change_custom_faction_name("wh2_main_skv_skaven_qb1", "Clan Skurvy")
    elseif random_number == 4 then
        faction = "wh_main_grn_greenskins_qb1"
		army = random_army_manager:generate_force("ovn_cod_greenskin_force", upa, false);
		cm:change_custom_faction_name("wh_main_grn_greenskins_qb1", "River Ratz")
    elseif random_number == 5 then
        faction = "wh2_main_def_dark_elves_qb1"
		army = random_army_manager:generate_force("ovn_cod_dark_elves_force", upa, false);
		cm:change_custom_faction_name("wh2_main_def_dark_elves_qb1", "Teilancarr's Corsairs")
    elseif random_number == 6 then
        faction = "wh_main_chs_chaos_qb1"
		army = random_army_manager:generate_force("ovn_cod_chaos_force", upa, false);
		cm:change_custom_faction_name("wh_main_chs_chaos_qb1", "Plaguefleet")
    end

    local cod_invasion = invasion_manager:new_invasion("cod_invasion_"..turn_number, faction, army, location);

	--cod_invasion:set_target("PATROL", cod_invasion_patrol, faction_name_str);

	if faction_name:has_faction_leader() and faction_name:faction_leader():has_military_force() then
		cod_invasion:set_target("CHARACTER", faction_name:faction_leader():command_queue_index(), faction_name_str);
		else
		cod_invasion:set_target("REGION", faction_capital, faction_name_str);
	end

     cod_invasion:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);
     cod_invasion:add_character_experience(experience_amount, true);
	 cod_invasion:add_unit_experience(experience_amount);
	 cod_invasion:add_aggro_radius(12000, cod_invasion_targets, 5, 3);
     cod_invasion:start_invasion(true);
end

function cod_beast_invasion_start()

	local faction_name_str = cod_naval_defender_faction_key
	local faction_name = cm:get_faction(faction_name_str)
	local char_faction_leader = cm:get_faction(faction_name_str):faction_leader()
	local character_str = cm:char_lookup_str(char_faction_leader)
	local faction_capital = faction_name:home_region():name();
	local w, z = cm:find_valid_spawn_location_for_character_from_settlement(faction_name_str, faction_capital, false, false, 25)
	if faction_name:has_faction_leader() and faction_name:faction_leader():has_military_force() then
		 w, z = cm:find_valid_spawn_location_for_character_from_character(faction_name_str, character_str, false, 35)
	end
	local location = {x = w, y = z};
	local location_patrol_create = w + 15, z + 50;
	local location_patrol = {location_patrol_create};
	local faction = "wh2_main_lzd_lizardmen_qb1"
	local army
	local random_number = cm:random_number(4, 1)
	local experience_amount
	local turn_number = cm:model():turn_number();
	local cod_invasion_patrol = {{location}, {location_patrol}};
	local cod_invasion_targets = {
		"wh2_main_hef_citadel_of_dusk",
		"wh2_main_hef_order_of_loremasters",
		"wh2_main_hef_eataine",
		"wh2_dlc13_emp_the_huntmarshals_expedition"
	}
	cod_beast_invasion_mess()

		if cm:model():turn_number() < 25 then
			experience_amount = cm:random_number(6,1)
		elseif cm:model():turn_number() < 45 and cm:model():turn_number() > 10 then
			experience_amount = cm:random_number(8,1)
		elseif cm:model():turn_number() < 69 and cm:model():turn_number() > 24 then
			experience_amount = cm:random_number(10,1)
		elseif cm:model():turn_number() > 70 then
			experience_amount = cm:random_number(12,1)
		end

		if random_number == 1 then
			army = "wh2_dlc13_lzd_mon_dread_saurian_0,wh2_dlc13_lzd_mon_dread_saurian_0,wh2_dlc13_lzd_mon_dread_saurian_0"
		elseif random_number == 2 then
			army = "wh2_dlc10_lzd_mon_carnosaur_boss,wh2_main_lzd_mon_carnosaur_0,wh2_main_lzd_mon_carnosaur_0,wh2_main_lzd_mon_carnosaur_0,wh2_main_lzd_mon_carnosaur_0"
		elseif random_number == 3 then
			army = "wh2_main_lzd_mon_stegadon_0,wh2_main_lzd_mon_stegadon_0,wh2_main_lzd_mon_stegadon_0,wh2_main_lzd_mon_bastiladon_0,wh2_main_lzd_mon_bastiladon_0,wh2_main_lzd_mon_bastiladon_0,wh2_main_lzd_mon_bastiladon_0"
		elseif random_number == 4 then
			army = "wh2_main_lzd_mon_carnosaur_0,wh2_main_lzd_mon_carnosaur_0,wh2_main_lzd_mon_carnosaur_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0,wh2_main_lzd_cav_cold_ones_feral_0"
		end

		cm:change_custom_faction_name("wh2_main_lzd_lizardmen_qb1", "Beasts of the Jungle")

		local cod_beast_invasion = invasion_manager:new_invasion("cod_beast_invasion_"..turn_number, faction, army, location);

		--cod_beast_invasion:set_target("PATROL", cod_invasion_patrol, faction_name_str);

		if faction_name:has_faction_leader() and faction_name:faction_leader():has_military_force() then
			cod_beast_invasion:set_target("CHARACTER", faction_name:faction_leader():command_queue_index(), faction_name_str);
            else
        	cod_beast_invasion:set_target("REGION", faction_capital, faction_name_str);
    	end

		cod_beast_invasion:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);
		cod_beast_invasion:add_character_experience(experience_amount, true);
		cod_beast_invasion:add_unit_experience(experience_amount);
		cod_beast_invasion:add_aggro_radius(12000, cod_invasion_targets, 5, 3);
		cod_beast_invasion:start_invasion(true);
	end

function cod_reinforce_start()

    local ovn_cod_reinforcement_unit_pool = {
        "ovn_hef_cav_ellyrian_reavers_shore",
        "ovn_hef_inf_archers_sea",
        "ovn_hef_inf_archers_fire",
        "ovn_hef_inf_archers_wind",
        "ovn_hef_inf_spearmen_falcon",
        "ovn_hef_inf_spearmen_sapphire"
	}

-- COULD ADD EXTRAS IF THE USER IS USING CATAPHS SEA ELF NAVY MOD
   --[[ if cm:get_saved_value("Cataph_TEB") == true then
        local cataph_units = {
            "teb_ricco",
            "teb_origo"
        }
        for i = 1, #cataph_units do
            table.insert(ovn_reinforcement_unit_pool, cataph_units [i])
        end;
    end]]

    local human_faction = cm:get_human_factions();
    local faction_name = cm:get_faction(human_faction[1])
    local faction_str = faction_name:name()
    local random_number = cm:random_number(#ovn_cod_reinforcement_unit_pool, 1)
    local unit_key = ovn_cod_reinforcement_unit_pool[random_number]

	cm:add_unit_to_faction_mercenary_pool(faction_name, unit_key,"renown", 1, 0, 5, 0, "", "", "", false, unit_key);
	cod_unit_gained_mess()
	mod.cod_naval_grace = mod.cod_naval_grace + 2;
end

function cod_unit_gained_mess()

	local human_factions = cm:get_human_factions();

		for i = 1, #human_factions do

			cm:show_message_event(
				human_factions[i],
					"event_feed_strings_text_ovn_event_feed_string_scripted_event_cod_unit_gained_primary_detail",
					"",
					"event_feed_strings_text_ovn_event_feed_string_scripted_event_cod_unit_gained_secondary_detail",
					true,
					2602
					);
		end;

end

function cod_invasion_mess()

	local human_factions = cm:get_human_factions();

		for i = 1, #human_factions do

			cm:show_message_event(
				human_factions[i],
					"event_feed_strings_text_ovn_event_feed_string_scripted_event_cod_invasion_primary_detail",
					"",
					"event_feed_strings_text_ovn_event_feed_string_scripted_event_cod_invasion_secondary_detail",
					true,
					2601
					);
		end;

end

function cod_beast_invasion_mess()

	local human_factions = cm:get_human_factions();

		for i = 1, #human_factions do

			cm:show_message_event(
				human_factions[i],
					"event_feed_strings_text_ovn_event_feed_string_scripted_event_cod_beast_invasion_primary_detail",
					"",
					"event_feed_strings_text_ovn_event_feed_string_scripted_event_cod_beast_invasion_secondary_detail",
					true,
					2600
					);
		end;

end

cm:add_first_tick_callback(function() add_cod_naval_listeners() end)

--- If we're hot-reloading during dev execute some stuff explicitly.
--- We're checking for presence of execute external lua file in the traceback.
if debug.traceback():find('pj_loadfile') then
	mod.cod_naval_grace = 32
	add_cod_naval_listeners()
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("cod_naval_defender_level_inner", mod.cod_naval_defender_level_inner, context);
		cm:save_named_value("cod_naval_defender_level_outer", mod.cod_naval_defender_level_outer, context);
		cm:save_named_value("cod_naval_defender_level_all", mod.cod_naval_defender_level_all, context);
		cm:save_named_value("cod_naval_grace", mod.cod_naval_grace, context);
		cm:save_named_value("cod_ll_popularity_regions", cod_ll_popularity_regions, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		mod.cod_naval_defender_level_inner = cm:load_named_value("cod_naval_defender_level_inner", 1, context);
		mod.cod_naval_defender_level_outer = cm:load_named_value("cod_naval_defender_level_outer", 1, context);
		mod.cod_naval_defender_level_all = cm:load_named_value("cod_naval_defender_level_all", 1, context);
		mod.cod_naval_grace = cm:load_named_value("cod_naval_grace", 1, context);
		cod_ll_popularity_regions = cm:load_named_value("cod_ll_popularity_regions", {}, context);
	end
);
