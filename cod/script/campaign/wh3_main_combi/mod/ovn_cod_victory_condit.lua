local function ovn_cod_victory_conditions()
	if cm:is_new_game() and cm:get_campaign_name() == "main_warhammer" then
		-- Citadel of Dusk

		if cm:get_faction("wh2_main_hef_citadel_of_dusk"):is_human() then


			local mission = {[[
				 mission
				{
					victory_type ovn_victory_type_short;
					key wh_main_short_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
						{
							type DESTROY_FACTION;
							faction wh2_dlc11_cst_vampire_coast;
							confederation_valid;
						}
						objective
						{
							type CONTROL_N_PROVINCES_INCLUDING;
							total 1;
							province wh3_main_combi_province_the_capes;
						}
						objective
						{
							type OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS;
							total 30;
						}
						payload
						{
							effect_bundle
					{
						bundle_key wh3_main_ie_victory_objective_order_short;
						turns 0;
					}
							game_victory;
						}
					}
				}
			]],
			[[
				 mission
				{
					victory_type ovn_victory_type_long;
					key wh_main_long_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
						{
							type CONTROL_N_PROVINCES_INCLUDING;
							total 5;
							province wh3_main_combi_province_the_capes;
							province wh3_main_combi_province_vampire_coast;
							province wh3_main_combi_province_eataine;
						}
                        objective
						{
							type CONTROL_N_REGIONS_INCLUDING;
							total 13;
							region wh3_main_combi_region_chupayotl;
							region wh3_main_combi_region_mangrove_coast;
							region wh3_main_combi_region_altar_of_the_horned_rat;
							region wh3_main_combi_region_the_star_tower;
							region wh3_main_combi_region_fuming_serpent;
							region wh3_main_combi_region_the_blood_swamps;
							region wh3_main_combi_region_temple_of_tlencan;
							region wh3_main_combi_region_temple_of_kara;
							region wh3_main_combi_region_the_high_sentinel;
							region wh3_main_combi_region_shrine_of_sotek;
							region wh3_main_combi_region_kaiax;
							region wh3_main_combi_region_li_zhu;
							region wh3_main_combi_region_hanyu_port;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh2_dlc11_cst_vampire_coast;
							faction wh2_dlc11_cst_noctilus;
							faction wh2_dlc11_def_the_blessed_dread;
							confederation_valid;
						}
						objective
						{
							type OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS;
							total 70;
						}
						payload
						{
							effect_bundle
							{
								bundle_key wh3_main_ie_victory_objective_order_long;
								turns 0;
							}
							game_victory;
						}
					}
				}
			]]}

			cm:trigger_custom_mission_from_string("wh2_main_hef_citadel_of_dusk", mission[1]);
			cm:trigger_custom_mission_from_string("wh2_main_hef_citadel_of_dusk", mission[2]);

		end
	end
end

cm:add_first_tick_callback(function() ovn_cod_victory_conditions() end)