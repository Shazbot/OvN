--this file is same all across the caravan mods I participated in. 


function caravans:initialise()
	--Setup
	if not cm:get_saved_value("ivory_road_demand") then 
		self:initalise_end_node_values();
	end	

	if cm:is_new_game() then
		local human_factions = cm:get_human_factions_of_culture("wh3_dlc23_chd_chaos_dwarfs")

		for i = 1, #human_factions do
			local current_faction = human_factions[i]
			caravans.events_cooldown[current_faction] = {
				["wh3_dlc23_dilemma_chd_convoy_cathay_caravan"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_dwarfs"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_far_from_home"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_hobgoblin_tribute"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_hungry_daemons"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_localised_elfs"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_offence_or_defence"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_ogre_mercenaries"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_portals_part_1"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_portals_part_2"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_portals_part_3_a"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_power_overwhelming"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_quick_way_down"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_rats_in_a_tunnel"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_redeadify"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_the_ambush"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_the_guide"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_trading_dark_elfs"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_training_camp"] = 0,
				["wh3_dlc23_dilemma_chd_convoy_way_of_lava"] = 0
			}
		end
	end

	--Listeners
	core:add_listener(
		"convoy_event_update",
		"WorldStartRound",
		true,
		function()
			for _, faction_cooldowns in pairs(caravans.events_cooldown) do
				for dilemma_key, cooldown in pairs(faction_cooldowns) do
					if cooldown > 0 then
						faction_cooldowns[dilemma_key] = cooldown - 1
					end
				end
			end

			-- select a random caravan for each human player to trigger an event for
			local caravans_system = cm:model():world():caravans_system()
			local human_factions = cm:get_human_factions()

			for i = 1, #human_factions do
				local caravans = caravans_system:faction_caravans_by_key(human_factions[i])
				if not caravans:is_null_interface() then
					local num_caravans = caravans:number_of_active_caravans()

					if num_caravans > 0 then
						local chosen_caravan = cm:random_number(num_caravans)
						local chosen_caravan_cqi = caravans:active_caravans():item_at(chosen_caravan - 1):caravan_force():command_queue_index()
						cm:set_saved_value("chosen_caravan_master_" .. human_factions[i], chosen_caravan_cqi)
					end
				end
			end

			self:adjust_end_node_values_for_demand();
		end,
		true
	);

	core:add_listener(
		"caravan_waylay_query",
		"QueryShouldWaylayCaravan",
		function(context)
			local faction = context:faction()
			return faction:is_human() and context:caravan():caravan_force():command_queue_index() == cm:get_saved_value("chosen_caravan_master_" .. faction:name()) and caravans.culture_to_faction[context:faction():culture()]
		end,
		function(context)
			if self:event_handler(context) == false then
				out.design("Caravan not valid for event");
			end
		end,
		true
	);

	core:add_listener(
		"caravan_waylaid",
		"CaravanWaylaid",
		function(context)
            return caravans.culture_to_faction[context:faction():culture()]
        end,
		function(context)
			local event_name_formatted = context:context();
			local caravan_handle = context:caravan();
			local event_key = self:read_out_event_key(event_name_formatted);
			
			local culture = caravan_handle:caravan_force():faction():culture()
			local events = self.event_tables[culture]
			--call the action side of the event
			events[event_key][2](event_name_formatted,caravan_handle);
		end,
		true
	);

	core:add_listener(
		"add_inital_force",
		"CaravanRecruited",
		function(context)
            return caravans.culture_to_faction[context:faction():culture()]
        end,
		function(context)
			out.design("*** Caravan recruited ***");
			if context:caravan():caravan_force():unit_list():num_items() < 2 then
				local caravan = context:caravan();
				self:add_inital_force(caravan);
				cm:set_character_excluded_from_trespassing(context:caravan():caravan_master():character(), true)
			end;
		end,
		true
	);

	core:add_listener(
		"add_inital_bundles",
		"CaravanSpawned",
		function(context)
            return caravans.culture_to_faction[context:faction():culture()]
        end,
		function(context)
			out.design("*** Caravan deployed ***");
			local caravan = context:caravan();
			self:set_stance(caravan);
			cm:set_saved_value("caravans_dispatched_" .. context:faction():name(), true);
		end,
		true
	);

	core:add_listener(
		"caravan_finished",
		"CaravanCompleted",
		function(context)
            return caravans.culture_to_faction[context:faction():culture()]
        end,
		function(context)
			-- store a total value of goods moved for this faction and then trigger an onwards event, narrative scripts use this
			local node = context:complete_position():node()
			local region_name = node:region_key()
			local region = node:region_data():region()
			local region_owner = region:owning_faction();
			
			out.design("Caravan (player) arrived in: "..region_name)
			
			local faction = context:faction()
			local faction_key = faction:name();
			local prev_total_goods_moved = cm:get_saved_value("caravan_goods_moved_" .. faction_key) or 0;
			local num_caravans_completed = cm:get_saved_value("caravans_completed_" .. faction_key) or 0;
			cm:set_saved_value("caravan_goods_moved_" .. faction_key, prev_total_goods_moved + context:cargo());
			cm:set_saved_value("caravans_completed_" .. faction_key, num_caravans_completed + 1);
			core:trigger_event("ScriptEventCaravanCompleted", context);
			
			if faction:is_human() then
				self:reward_item_check(faction, region_name, context:caravan_master())
			end
			
			-- faction has tech that grants extra trade tariffs bonus after every caravan - create scripted bundle
			local bv = cm:get_factions_bonus_value(faction, "chd_convoy_trade_tariff_scripted")
			if bv > 0 then
				local trade_modifier = cm:get_saved_value("convoy_trade_modifier_" .. faction_key) or 0
				trade_modifier = trade_modifier + bv
				cm:set_saved_value("convoy_trade_modifier_" .. faction_key, trade_modifier)
				local trade_effect = "wh_main_effect_economy_trade_tariff_mod"
				local trade_effect_bundle_key = "wh3_dlc23_effect_chd_convoy_trade_tariff_scripted_bundle"
				local trade_effect_bundle = cm:create_new_custom_effect_bundle(trade_effect_bundle_key)

				trade_effect_bundle:add_effect(trade_effect, "faction_to_faction_own_unseen", trade_modifier)
				trade_effect_bundle:set_duration(0)

				if faction:has_effect_bundle(trade_effect_bundle_key) then
					cm:remove_effect_bundle(trade_effect_bundle_key, faction_key)
				end
				
				cm:apply_custom_effect_bundle_to_faction(trade_effect_bundle, faction)
			end
				
			if not region_owner:is_null_interface() then
				local region_owner_key = region_owner:name()
				cm:cai_insert_caravan_diplomatic_event(region_owner_key,faction_key)

				if region_owner:is_human() and faction_key ~= region_owner_key then
					local incident_key = "wh3_main_cth_caravan_completed_received"
					
					if faction:culture() == "wh3_dlc23_chd_chaos_dwarfs" then
						incident_key = "wh3_dlc23_chd_convoy_completed_received"
					end
					
					cm:trigger_incident_with_targets(
						region_owner:command_queue_index(),
						incident_key,
						0,
						0,
						0,
						0,
						region:cqi(),
						0
					)
				end
			end
			
			--Reduce demand
			local cargo = context:caravan():cargo()
			local value = math.floor(-cargo/18)
			local faction = self.culture_to_faction[context:faction():culture()];
			cm:callback(function()self:adjust_end_node_value(region_name, value, "add", faction) end, 5);
						
		end,
		true
	);

	core:add_listener(
		"caravan_master_heal",
		"CaravanMoved",
		function(context)
			return not context:caravan():is_null_interface();
		end,
		function(context)
			--Heal Lord
			cm:set_unit_hp_to_unary_of_maximum(context:caravan_master():character():military_force():unit_list():item_at(0), 1)
			
			--Spread out caravans
			local caravan_lookup = cm:char_lookup_str(context:caravan():caravan_force():general_character():command_queue_index())
			local x,y = cm:find_valid_spawn_location_for_character_from_character(
				context:faction():name(),
				caravan_lookup,
				true,
				cm:random_number(15,5)
			)

			cm:teleport_to(caravan_lookup, x, y);
		end,
		true
	);

	core:add_listener(
		"cleanup_caravan_battle",
		"BattleCompleted",
		function(context)
			return self.enemy_force_cqi > 0
		end,
		function()
			self:cleanup_post_battle()
		end,
		true
	)

	core:add_listener(
		"convoy_refresh_values",
		"ActiveContractRefreshEvent",
		function(context)
			return context:faction():culture() == "wh3_dlc23_chd_chaos_dwarfs"
		end,
		function(context)
			local region = context:position():node():region_key()
			local culture = context:faction():culture()

			if(culture == "wh3_dlc23_chd_chaos_dwarfs") then
				caravans:adjust_end_node_value(region, nil, "duration", "chaos_dwarfs", true)
			end
		end,
		true
	);

	core:add_listener(
		"new_contracts_update",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return faction:is_human() and faction:culture() == "wh3_dlc23_chd_chaos_dwarfs"
		end,
		function(context)
			local turn = cm:model():turn_number();
			local faction_key = context:faction():name()
			if turn == 5 then
				cm:trigger_incident(faction_key, "wh3_dlc23_chd_convoy_unlocked", true);
			elseif (turn % 10 == 0) then
				cm:trigger_incident(faction_key, "wh3_dlc23_chd_convoy_new_contracts", true);
			end
		end,
		true
	);

end
