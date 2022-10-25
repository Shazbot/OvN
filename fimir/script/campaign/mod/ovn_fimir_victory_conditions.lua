local function ovn_fimir_victory_conditions()
	if cm:is_new_game() and cm:get_campaign_name() == "main_warhammer" then
		if cm:get_faction("ovn_fim_tendrils_of_doom"):is_human() then
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
							type CONTROL_N_PROVINCES_INCLUDING;
							total 8;
							province wh3_main_combi_province_isthmus_of_lustria;
							province wh3_main_combi_province_the_isthmus_coast;
							province wh3_main_combi_province_jungles_of_pahualaxa;
							province wh3_main_combi_province_aymara_swamps;
							province wh3_main_combi_province_the_creeping_jungle;
							province wh3_main_combi_province_the_gwangee_valley;
							province wh3_main_combi_province_scorpion_coast;
							province wh3_main_combi_province_mosquito_swamps;
						}
						objective
						{
							type CAPTURE_X_BATTLE_CAPTIVES;
							total 10000;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction ovn_fim_tendrils_of_doom;
							total 13;
							building_level ovn_fimir_temple_kroll_1;
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
							total 11;
							province wh3_main_combi_province_isthmus_of_lustria;
							province wh3_main_combi_province_the_isthmus_coast;
							province wh3_main_combi_province_jungles_of_pahualaxa;
							province wh3_main_combi_province_aymara_swamps;
							province wh3_main_combi_province_the_creeping_jungle;
							province wh3_main_combi_province_the_gwangee_valley;
							province wh3_main_combi_province_scorpion_coast;
							province wh3_main_combi_province_mosquito_swamps;
							province wh3_main_combi_province_titan_peaks;
							province wh3_main_combi_province_the_bleak_coast;
							province wh3_main_combi_province_doom_glades;
						}
						objective
						{
							type CAPTURE_X_BATTLE_CAPTIVES;
							total 17500;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction ovn_fim_tendrils_of_doom;
							total 20;
							building_level ovn_fimir_temple_kroll_1;
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

			cm:trigger_custom_mission_from_string("ovn_fim_tendrils_of_doom", mission[1]);
			cm:trigger_custom_mission_from_string("ovn_fim_tendrils_of_doom", mission[2]);
        elseif cm:get_faction("ovn_fim_rancor_hold"):is_human() then
			local mission = {
				[[
					mission
					{
						victory_type ovn_victory_type_short;
						key wh_main_short_victory;
						issuer CLAN_ELDERS;
						primary_objectives_and_payload
						{
							objective
							{
								type CONTROL_N_PROVINCES_INCLUDING;
								total 7;
								province wh3_main_combi_province_the_misty_hills;
								province wh3_main_combi_province_the_wasteland;
								province wh3_main_combi_province_nordland;
								province wh3_main_combi_province_the_witchs_wood;
							}
							objective
							{
								type CAPTURE_X_BATTLE_CAPTIVES;
								total 10000;
							}
							objective
							{
								type DESTROY_FACTION;
								faction wh_main_emp_empire;
								faction wh_main_emp_middenland;
								faction wh_main_emp_hochland;
								faction wh_main_emp_ostland;
								faction wh_main_emp_talabecland;
								confederation_valid;
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
								total 12;
								province wh3_main_combi_province_the_misty_hills;
								province wh3_main_combi_province_the_wasteland;
								province wh3_main_combi_province_nordland;
								province wh3_main_combi_province_the_witchs_wood;
								province wh3_main_combi_province_marches_of_couronne;
								province wh3_main_combi_province_albion;
							}
							objective
							{
								type CAPTURE_X_BATTLE_CAPTIVES;
								total 17500;
							}
							objective
							{
								type DESTROY_FACTION;
								faction wh_main_emp_empire;
								faction wh_main_emp_middenland;
								faction wh_main_emp_hochland;
								faction wh_main_emp_ostland;
								faction wh_main_emp_talabecland;
								faction wh3_main_ksl_the_ice_court;
								faction wh3_main_ksl_the_great_orthodoxy;
								confederation_valid;
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
				]]
			}
                
			cm:trigger_custom_mission_from_string("ovn_fim_rancor_hold", mission[1]);
			cm:trigger_custom_mission_from_string("ovn_fim_rancor_hold", mission[2]);
		end
	end
end

cm:add_first_tick_callback(function() ovn_fimir_victory_conditions() end)
