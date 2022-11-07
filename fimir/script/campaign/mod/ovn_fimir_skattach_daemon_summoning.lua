--[[
	Script by Aexrael Dex, modified by Wolfremio
	Adds mercenary units for specified factions
]]

local function ovn_fimir_skattach_daemons()

	-- Checking whether the script has already run for saved games and if it has then the script doesn't need to run again
	if cm:get_saved_value("ovn_fimir_skattach_daemons_enable") == nil then

		-- Table for faction, unit key and parameters for add_unit_to_faction_mercenary_pool
		local cror_list = {
			{faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_dae_inf_chaos_furies_0", rsrc = "daemonic_summoning", count = 1, rcp = 0, munits = 6, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_dae_inf_chaos_furies_0_faction_pool"},
            {faction_key = "ovn_fim_rancor_hold", unit = "fim_inf_swamp_daemons", rsrc = "daemonic_summoning", count = 1, rcp = 0, munits = 4, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "fim_skattach_daemons_swamp_daemons"},
            {faction_key = "ovn_fim_rancor_hold", unit = "fim_inf_moor_hounds", rsrc = "daemonic_summoning", count = 1, rcp = 0, munits = 6, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "fim_skattach_daemons_moor_hounds"},
            {faction_key = "ovn_fim_rancor_hold", unit = "fim_cav_nuckelavee", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 4, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "fim_skattach_daemons_nuckleavees"},
            {faction_key = "ovn_fim_rancor_hold", unit = "fim_mon_daemonomaniac", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 1, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "fim_skattach_daemons_daemonomaniac"},
            {faction_key = "ovn_fim_rancor_hold", unit = "fim_veh_eye_oculus", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 1, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "fim_skattach_daemons_shrinebalor"},
            {faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_kho_inf_bloodletters_0", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 4, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_kho_inf_bloodletters_0_warriors_faction_pool"},
            {faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_kho_inf_flesh_hounds_of_khorne_0", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 4, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_kho_inf_flesh_hounds_of_khorne_0_warriors_faction_pool"},
            {faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_kho_inf_bloodletters_1", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 4, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_kho_inf_bloodletters_1_belakor_faction_pool"},
            {faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_kho_mon_bloodthirster_0", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 1, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_kho_mon_bloodthirster_0_warriors_faction_pool"},
            {faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_nur_inf_nurglings_0", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 6, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_nur_inf_nurglings_0_warriors_faction_pool"},
            {faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_nur_inf_plaguebearers_0", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 4, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_nur_inf_plaguebearers_0_warriors_faction_pool"},
            {faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_nur_inf_plaguebearers_1", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 4, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_nur_inf_plaguebearers_1_belakor_faction_pool"},
            {faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_nur_mon_beast_of_nurgle_0", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 2, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_nur_mon_beast_of_nurgle_0_warriors_faction_pool"},
            {faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_nur_cav_plague_drones_0", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 2, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_nur_cav_plague_drones_0_warriors_faction_pool"},
            {faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_nur_mon_great_unclean_one_0", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 1, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_nur_mon_great_unclean_one_0_warriors_faction_pool"},
            {faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_tze_inf_pink_horrors_0", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 4, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_tze_inf_pink_horrors_0_warriors_faction_pool"},
            {faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_tze_inf_pink_horrors_1", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 4, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_tze_inf_pink_horrors_1_belakor_faction_pool"},
            {faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_tze_mon_flamers_0", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 2, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_tze_mon_flamers_0_warriors_faction_pool"},
            {faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_tze_mon_screamers_0", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 2, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_tze_mon_screamers_0_warriors_faction_pool"},
			{faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_tze_mon_lord_of_change_0", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 1, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_tze_mon_lord_of_change_0_warriors_faction_pool"},
            {faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_sla_inf_daemonette_0", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 4, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_sla_inf_daemonette_0_warriors_faction_pool"},
            {faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_sla_inf_daemonette_1", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 4, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_sla_inf_daemonette_1_belakor_faction_pool"},
            {faction_key = "ovn_fim_rancor_hold", unit = "wh3_main_sla_mon_keeper_of_secrets_0", rsrc = "daemonic_summoning", count = 0, rcp = 0, munits = 4, murpt = 0, frr = "", srr = "", trr = "", replen = true, mgroup = "wh3_main_sla_mon_keeper_of_secrets_0_warriors_faction_pool"}
		};         

		-- Loop for the table above
		for i = 1, #cror_list do
			local faction_name = cror_list[i].faction_key;	-- Faction whose pool the unit(s) should be added to
			local faction = cm:get_faction(faction_name);	-- FACTION_SCRIPT_INTERFACE
			local unit_key = cror_list[i].unit;				-- Key of unit to add to the mercenary pool, from the main_units table
			local rsrc = cror_list[i].rsrc;					-- The unit's recruitment source
			local unit_count = cror_list[i].count;			-- Number of units to add to the mercenary pool
			local rcp = cror_list[i].rcp;					-- Replenishment chance, as a percentage
			local munits = cror_list[i].munits;				-- The maximum number of units of the supplied type that the pool is allowed to contain.
			local murpt = cror_list[i].murpt;				-- The maximum number of units of the supplied type that may be added by replenishment per-turn
			local frr = cror_list[i].frr;					-- (may be empty) The key of the faction who can actually recruit the units, from the factions database table
			local srr = cror_list[i].srr;					-- (may be empty) The key of the subculture who can actually recruit the units, from the cultures_subcultures database table
			local trr = cror_list[i].trr;					-- (may be empty) The key of a technology that must be researched in order to recruit the units, from the technologies database table
			local replen = cror_list[i].replen;				-- Allow replenishment of partial units
			local mgroup = cror_list[i].mgroup;				-- The unit's mercenary unit group

			-- Adding the listed unit to the listed faction in the above table
			cm:add_unit_to_faction_mercenary_pool(faction, unit_key, rsrc, unit_count, rcp, munits, murpt, frr, srr, trr, replen, mgroup);

			-- Debug message for log
			out("CROR: adding " .. unit_key .. " to " .. faction_name);
		end;

		-- Setting saved value, so that the script doesn't run again when reloaded from a saved game
		cm:set_saved_value("ovn_fimir_skattach_daemons_enable", true);
	end;
end;

cm:add_first_tick_callback(function() ovn_fimir_skattach_daemons() end);