local function spawn_new_force()
	cm:create_force_with_general(
		"ovn_arb_sultanate_of_el_kalabad", -- faction_key,
		"ovn_arb_inf_arabyan_spearmen,ovn_arb_mon_elephant,ovn_arb_mon_war_elephant,ovn_arb_inf_arabyan_bowmen,ovn_arb_inf_arabyan_spearmen,ovn_arb_inf_arabyan_bowmen", -- unit_list,
		"wh3_main_combi_region_el_kalabad", -- region_key,
		536, -- x,
		279, -- y,
		"general", -- type,
		"arb_sheikh", -- subtype,
		"names_name_999982538", -- name1,
		"", -- name2,
		"names_name_999982539", -- name3,
		"", -- name4,
		true,-- make_faction_leader,
        function(cqi) -- callback
            --out("Rhox Araby: Hi, I summoned the guy")
            local str = "character_cqi:" .. cqi
            cm:set_character_immortality(str, true);
            cm:set_character_unique(str, true);
        end
	)
end


local function new_game_startup()
    local sultanate_of_el_kalabad_string = "ovn_arb_sultanate_of_el_kalabad"
	local sultanate_of_el_kalabad = cm:get_faction(sultanate_of_el_kalabad_string)

    if not sultanate_of_el_kalabad then return end


    
    spawn_new_force()
    
    cm:force_change_cai_faction_personality("ovn_arb_sultanate_of_el_kalabad", "ovn_arb_sultanate_of_el_kalabad")
    
    --change the campaign settlement model used
	cm:override_building_chain_display("wh2_dlc09_tmb_settlement_minor", "ovn_arb_settlement_minor", "wh3_main_combi_region_el_kalabad")
	
	--also changed the other settlements here
	cm:override_building_chain_display("wh_main_BRETONNIA_settlement_minor", "ovn_arb_settlement_minor", "wh3_main_combi_region_lashiek")
	cm:override_building_chain_display("wh_main_BRETONNIA_settlement_minor", "ovn_arb_settlement_minor", "wh3_main_combi_region_copher")
	cm:override_building_chain_display("wh_main_VAMPIRES_settlement_minor", "ovn_arb_settlement_minor", "wh3_main_combi_region_fyrus")
	cm:override_building_chain_display("wh_main_BRETONNIA_settlement_minor", "ovn_arb_settlement_minor", "wh3_main_combi_region_martek")
	
	--IF USER DOES NOT HAVE OVN LOST WORLD
    if not common.vfs_exists("script/campaign/mod/ovn_lost_world.lua") then					
        cm:override_building_chain_display("wh2_dlc09_tmb_settlement_major", "ovn_arb_settlement_major", "wh3_main_combi_region_wizard_caliphs_palace")
        cm:override_building_chain_display("wh2_dlc09_tmb_settlement_minor", "ovn_arb_settlement_minor", "wh3_main_combi_region_sorcerers_islands")
	end
	
	if cm:model():campaign_name_key() == "cr_combi_expanded" then --only in IEE
        --also changed IEE settlements here
        cm:override_building_chain_display("wh_main_BRETONNIA_settlement_major", "ovn_arb_settlement_major", "cr_combi_region_akhaba")
        cm:override_building_chain_display("wh3_main_ogr_settlement_minor", "ovn_arb_settlement_minor", "cr_combi_region_sud")
    end
	
	
    local el_kalabad = cm:get_region("wh3_main_combi_region_el_kalabad")
    cm:transfer_region_to_faction("wh3_main_combi_region_el_kalabad", "ovn_arb_sultanate_of_el_kalabad")
	cm:instantly_set_settlement_primary_slot_level(el_kalabad:settlement(), 2)
	local target_slot = el_kalabad:slot_list():item_at(1)
    cm:instantly_upgrade_building_in_region(target_slot, "ovn_arb_defence_minor_1")
	cm:heal_garrison(el_kalabad:cqi());
	
    -- OPTIONAL REGIONS (Sun's Anvil IEE) via MCT
    if OVN_ARABY_MINOR and OVN_ARABY_MINOR.extra_region_ovn_araby_elkalabad then
        local region_akhaba = cm:get_region("cr_combi_region_akhaba")
            cm:transfer_region_to_faction("cr_combi_region_akhaba", "ovn_arb_sultanate_of_el_kalabad")
            cm:instantly_set_settlement_primary_slot_level(region_akhaba:settlement(), 2)
            cm:heal_garrison(region_akhaba:cqi())
            
        local region_sud = cm:get_region("cr_combi_region_sud")
            cm:transfer_region_to_faction("cr_combi_region_sud", "ovn_arb_sultanate_of_el_kalabad")
            cm:instantly_set_settlement_primary_slot_level(region_sud:settlement(), 2)
        cm:heal_garrison(region_sud:cqi())
    end


    local unit_count = 1 -- card32 count
    local rcp = 100 -- float32 replenishment_chance_percentage
    local max_units = 1 -- int32 max_units
    local murpt = 0.1 -- float32 max_units_replenished_per_turn
    local xp_level = 0 -- card32 xp_level
    local frr = "" -- (may be empty) String faction_restricted_record
    local srr = "" -- (may be empty) String subculture_restricted_record
    local trr = "" -- (may be empty) String tech_restricted_record
    local units = {
        "ovn_arb_art_grand_bombard_ror",
		"ovn_arb_veh_naphtha_thrower_ror",
		"ovn_arb_cav_lancer_camels_ror",
		"ovn_arb_cav_arabyan_knights_ror",
		"ovn_arb_cav_sipahis_ror",
		"ovn_arb_cav_flying_carpets_ror",
		"ovn_arb_inf_arabyan_warriors_ror",
		"ovn_arb_mon_war_elephant_ror_2",
		"ovn_arb_mon_war_elephant_ror_1",
		"ovn_arb_inf_jezzails_ror",
        "ovn_arb_inf_naffatun_ror",
        "ovn_arb_art_quadballista_ror",        
        "ovn_arb_inf_arabyan_guard_ror"
    }
    
    
    for _, unit in ipairs(units) do
        cm:add_unit_to_faction_mercenary_pool(
            sultanate_of_el_kalabad,
            unit,
            "renown",
            unit_count,
            rcp,
            max_units,
            murpt,
            frr,
            srr,
            trr,
            true,
            unit
        )
    end
    
end



cm:add_first_tick_callback(
	function()
        --[[
        pcall(function()
            mixer_set_faction_trait("ovn_arb_sultanate_of_el_kalabad", "ovn_lord_trait_arb_golden_fleet", true) --they don't have this I guess
        end)
        --]]
		if cm:is_new_game() then
			if cm:get_campaign_name() == "main_warhammer" then
				local ok, err =
					pcall(
					function()
						new_game_startup()
					end
				)
				if not ok then
					script_error(err)
				end
			end
		end
	end
)