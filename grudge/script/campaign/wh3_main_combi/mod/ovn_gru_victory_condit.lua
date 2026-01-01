local function ovn_gru_victory_conditions()
	if cm:is_new_game() and cm:get_campaign_name() == "main_warhammer" then

		if cm:get_faction("ovn_emp_grudgebringers"):is_human() then

			local mission = {[[
				 mission
				{
					victory_type ovn_victory_type_roleplay_gru_sothr;
					key wh_main_short_victory;
					issuer CLAN_ELDERS;
					primary_objectives_and_payload
					{
						objective
                        {
                            override_text mission_text_text_gru_sothr_intro;
                            type SCRIPTED;
                            script_key ovn_dummy;	
                        }
						objective
						{
							type DESTROY_FACTION;
							faction wh_main_grn_red_eye;
							faction wh_main_grn_scabby_eye;
							faction wh2_dlc16_grn_creeping_death;
							faction wh3_main_skv_clan_verms;
							faction wh2_main_skv_clan_skryre;
							confederation_valid;
						}
						payload
						{
							effect_bundle
							{
								bundle_key ovn_vc_gru_sothr;
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
				   victory_type ovn_victory_type_roleplay_gru_do;
				   key wh_main_long_victory;
				   issuer CLAN_ELDERS;
				   primary_objectives_and_payload
				   {
                        objective
                        {
                            override_text mission_text_text_gru_do_intro;
                            type SCRIPTED;
                            script_key ovn_dummy;	
                        }
					   objective
					   {
						   type DESTROY_FACTION;
						   faction wh2_dlc11_vmp_the_barrow_legion;
						   faction wh_main_vmp_mousillon;
						   faction wh_main_vmp_schwartzhafen;
						   faction wh_main_vmp_vampire_counts;
                           faction wh3_main_vmp_lahmian_sisterhood;
						   faction wh2_dlc09_tmb_followers_of_nagash;
                           faction ovn_tmb_dread_king;
						   confederation_valid;
					   }
					   payload
					   {
						   effect_bundle
						   {
							   bundle_key ovn_vc_gru_do;
							   turns 0;
						   }
						   game_victory;
					   }
				   }
			   }
		   ]]
		}
		
		if vfs.exists("script/frontend/mod/rhox_nagash_mixer.lua") then
            mission = {[[
                    mission
                    {
                        victory_type ovn_victory_type_roleplay_gru_sothr;
                        key wh_main_short_victory;
                        issuer CLAN_ELDERS;
                        primary_objectives_and_payload
                        {
                            objective
                            {
                                override_text mission_text_text_gru_sothr_intro;
                                type SCRIPTED;
                                script_key ovn_dummy;	
                            }
                            objective
                            {
                                type DESTROY_FACTION;
                                faction wh_main_grn_red_eye;
                                faction wh_main_grn_scabby_eye;
                                faction wh2_dlc16_grn_creeping_death;
                                faction wh3_main_skv_clan_verms;
                                faction wh2_main_skv_clan_skryre;
                                confederation_valid;
                            }
                            payload
                            {
                                effect_bundle
                                {
                                    bundle_key ovn_vc_gru_sothr;
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
                    victory_type ovn_victory_type_roleplay_gru_do;
                    key wh_main_long_victory;
                    issuer CLAN_ELDERS;
                    primary_objectives_and_payload
                    {
                            objective
                            {
                                override_text mission_text_text_gru_do_intro;
                                type SCRIPTED;
                                script_key ovn_dummy;	
                            }
                        objective
                        {
                            type DESTROY_FACTION;
                            faction wh2_dlc11_vmp_the_barrow_legion;
                            faction wh_main_vmp_mousillon;
                            faction wh_main_vmp_schwartzhafen;
                            faction wh_main_vmp_vampire_counts;
                            faction wh3_main_vmp_lahmian_sisterhood;
                            faction wh2_dlc09_tmb_followers_of_nagash;
                            faction ovn_tmb_dread_king;
                            faction mixer_nag_nagash;
                            confederation_valid;
                        }
                        payload
                        {
                            effect_bundle
                            {
                                bundle_key ovn_vc_gru_do;
                                turns 0;
                            }
                            game_victory;
                        }
                    }
                }
            ]]
            }
		end

			cm:trigger_custom_mission_from_string("ovn_emp_grudgebringers", mission[1]);
			cm:trigger_custom_mission_from_string("ovn_emp_grudgebringers", mission[2]);
			
			cm:callback(
				function()
                    cm:complete_scripted_mission_objective("ovn_emp_grudgebringers", "wh_main_short_victory", "ovn_dummy", true)
                    cm:complete_scripted_mission_objective("ovn_emp_grudgebringers", "wh_main_long_victory", "ovn_dummy", true)
				end,
				5
			)

			
            
		end
	end
end

cm:add_first_tick_callback(function() ovn_gru_victory_conditions() end)