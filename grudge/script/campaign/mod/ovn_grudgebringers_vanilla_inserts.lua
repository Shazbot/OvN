local grudgebringer_faction_key="ovn_emp_grudgebringers"

--[[if not narrative.faction_data[grudgebringer_faction_key] then
    narrative.faction_data[grudgebringer_faction_key]={}
end

narrative.faction_data[grudgebringer_faction_key]["shared_settlement_upgrade_upgrade_any_settlement_level_five_block"]=true
narrative.faction_data[grudgebringer_faction_key]["shared_settlement_upgrade_upgrade_any_settlement_block"]=true
narrative.faction_data[grudgebringer_faction_key]["shared_settlement_capture_event_control_provinces_block"]=true
narrative.faction_data[grudgebringer_faction_key]["shared_finance_gain_moderate_income_block"]=true
narrative.faction_data[grudgebringer_faction_key]["shared_raising_armies_event_recruit_army_block"]=true
narrative.faction_data[grudgebringer_faction_key]["shared_raising_armies_event_recruit_army_on_no_armies_block"]=true
narrative.faction_data[grudgebringer_faction_key]["shared_diplomacy_event_trade_mission_block"]=true
--]]

narrative.add_data_setup_callback(
    function() 
        narrative.add_playable_faction(grudgebringer_faction_key);
        narrative.add_data_for_faction(grudgebringer_faction_key, "shared_settlement_upgrade_upgrade_any_settlement_level_five_block", true)
        narrative.add_data_for_faction(grudgebringer_faction_key, "shared_settlement_upgrade_upgrade_any_settlement_block", true)
        narrative.add_data_for_faction(grudgebringer_faction_key, "shared_settlement_capture_event_control_provinces_block", true)
        narrative.add_data_for_faction(grudgebringer_faction_key, "shared_finance_gain_moderate_income_block", true)
        narrative.add_data_for_faction(grudgebringer_faction_key, "shared_raising_armies_event_recruit_army_block", true)
        narrative.add_data_for_faction(grudgebringer_faction_key, "shared_raising_armies_event_recruit_army_on_no_armies_block", true)
        narrative.add_data_for_faction(grudgebringer_faction_key, "shared_diplomacy_event_trade_mission_block", true)
    end
)


imperial_authority.campaign_factions.main_warhammer[grudgebringer_faction_key]={settlement_culture = "wh_main_emp_empire", active = false}

cm:add_first_tick_callback(
	function()
        	
        if cm:is_new_game() then
            character_unlocking.character_data["ulrika"].factions_involved[grudgebringer_faction_key] = true--to keep Ulrika event from happening to Grudgebringers
            character_unlocking.character_data["gotrek_and_felix"].factions_involved[grudgebringer_faction_key] = true--to keep Ulrika event from happening to Grudgebringers
            character_unlocking.character_data["theodore"].factions_involved[grudgebringer_faction_key] = true--to keep Ulrika event from happening to Grudgebringers
        end
	
        campaign_traits.legendary_lord_defeated_traits["morgan_bernhardt"] ="ovn_morgan_bernhardt_defeat_trait"
	end
)



table.insert(merc_contracts.client_exclusion_list, "ovn_emp_grudgebringers")--otherwise they'll gain settlement via contract