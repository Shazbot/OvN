local function ovn_albion_victory_conditions()
	if cm:is_new_game() and cm:get_campaign_name() == "main_warhammer" then
		--Albion

		if cm:get_faction("ovn_alb_order_of_the_truthsayers"):is_human() then

			--local delf_faction_obj = cm:get_faction("wh2_main_def_naggarond")
			--local delf_faction_leader_cqi = delf_faction_obj:faction_leader():command_queue_index()

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
							faction wh3_main_chs_shadow_legion;
							confederation_valid;
						}
						objective
						{
							type CONTROL_N_PROVINCES_INCLUDING;
							total 1;
							province wh3_main_combi_province_albion;
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
							total 15;
							province wh3_main_combi_province_albion;
						}
						objective
						{
							type DESTROY_FACTION;
							faction wh3_main_chs_shadow_legion;
							faction wh3_dlc20_chs_sigvald;
							faction wh_dlc08_nor_norsca;
							faction wh3_main_sla_seducers_of_slaanesh;
							confederation_valid;
						}
						objective
						{
							type CONSTRUCT_N_OF_A_BUILDING;
							faction ovn_alb_order_of_the_truthsayers;
							total 3;
							building_level ovn_Waystone_3;
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
			]],
			[[
				mission
			   {
				   victory_type ovn_victory_type_roleplay_dd;
				   key wh_main_long_victory;
				   issuer CLAN_ELDERS;
				   primary_objectives_and_payload
				   {
                        objective
                        {
                            override_text mission_text_text_shadows_over_albion_intro;
                            type SCRIPTED;
                            script_key ovn_dummy;	
                        }
					   objective
					   {
						   type CONTROL_N_PROVINCES_INCLUDING;
						   total 10;
						   province wh3_main_combi_province_albion;
					   }
					   objective
					   {
						   type DESTROY_FACTION;
						   faction wh3_main_chs_shadow_legion;
						   faction wh3_dlc20_chs_sigvald;
						   faction wh_dlc08_nor_norsca;
						   faction wh3_main_sla_seducers_of_slaanesh;
						   faction wh_dlc08_nor_vanaheimlings;
                           faction wh_main_vmp_mousillon;
						   faction wh_dlc03_grn_black_pit;
						   confederation_valid;
					   }
					   objective
					   {
						type KILL_CHARACTER_BY_ANY_MEANS;
						family_member 47;
					   }
					   objective
					   {
						   type CONSTRUCT_N_OF_A_BUILDING;
						   faction ovn_alb_order_of_the_truthsayers;
						   total 3;
						   building_level ovn_Waystone_3;
					   }
					   payload
					   {
						   effect_bundle
						   {
							   bundle_key albion_roleplay_vc;
							   turns 0;
						   }
						   game_victory;
					   }
				   }
			   }
		   ]]}

			cm:trigger_custom_mission_from_string("ovn_alb_order_of_the_truthsayers", mission[1]);
			cm:trigger_custom_mission_from_string("ovn_alb_order_of_the_truthsayers", mission[2]);
			cm:trigger_custom_mission_from_string("ovn_alb_order_of_the_truthsayers", mission[3]);

            elseif cm:get_faction("ovn_alb_host_ravenqueen"):is_human() then

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
                                faction wh3_main_chs_shadow_legion;
                                faction wh3_dlc20_chs_sigvald;
                                confederation_valid;
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
                                total 15;
                                province wh3_main_combi_province_albion;
                                province wh3_main_combi_province_the_cold_mires;
                            }
                            objective
                            {
                                type DESTROY_FACTION;
                                faction wh3_main_chs_shadow_legion;
                                faction wh3_dlc20_chs_sigvald;
                                faction wh_dlc08_nor_norsca;
                                faction wh_dlc08_nor_wintertooth;
                                faction wh3_main_dae_daemon_prince;
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
                ]],
                [[
                     mission
                    {
                        victory_type ovn_victory_type_roleplay_rq;
                        key wh_main_long_victory;
                        issuer CLAN_ELDERS;
                        primary_objectives_and_payload
                        {
                            objective
                            {
                                override_text mission_text_text_scouring_chaos_wastes_intro;
                                type SCRIPTED;
                                script_key ovn_dummy;	
                            }
                            objective
                            {
                                type CONTROL_N_PROVINCES_INCLUDING;
                                total 12;
                                province wh3_main_combi_province_albion;
                                province wh3_main_combi_province_the_cold_mires;
                                province wh3_main_combi_province_the_shard_lands;
                                province wh3_main_combi_province_northern_wastes;
                                province wh3_main_combi_province_the_eternal_lagoon;
                            }
                            objective
                            {
                                type DESTROY_FACTION;
                                faction wh3_main_chs_shadow_legion;
                                faction wh3_dlc20_chs_sigvald;
                                faction wh_dlc08_nor_norsca;
                                faction wh_dlc08_nor_wintertooth;
                                faction wh3_main_dae_daemon_prince;
                                faction wh3_main_sla_seducers_of_slaanesh;
                                faction wh_main_vmp_mousillon;
                                faction wh2_main_skv_clan_septik;
                                confederation_valid;
                            }
                            objective
                            {
                                type KILL_CHARACTER_BY_ANY_MEANS;
                                family_member 47;
                            }
							objective
							{
								type OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS;
								total 50;
							}
                            payload
                            {
								effect_bundle
								{
									bundle_key albion_roleplay_vc;
									turns 0;
								}
                                game_victory;
                            }
                        }
                    }
                 ]]}
                
                cm:trigger_custom_mission_from_string("ovn_alb_host_ravenqueen", mission[1]);
                cm:trigger_custom_mission_from_string("ovn_alb_host_ravenqueen", mission[2]);
                cm:trigger_custom_mission_from_string("ovn_alb_host_ravenqueen", mission[3]);

                
		end
	end
end

cm:add_first_tick_callback(function() ovn_albion_victory_conditions() end)