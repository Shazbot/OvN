local function spawn_heroes_around_olorin(olorin_cqi)
    core:add_listener(
        "aragand_created",
        "CharacterCreated",
        function(context)
            return olorin_cqi and context:character():character_subtype("ovn_com_aragand_the_layabout");
        end,
        function(context)
            cm:embed_agent_in_force(context:character(), cm:get_character_by_cqi(olorin_cqi):military_force());
            local char_cqi = context:character():command_queue_index()
            cm:set_character_immortality("character_cqi:"..char_cqi, true);
        end,
        false
    );
    core:add_listener(
        "legles_created",
        "CharacterCreated",
        function(context)
            return olorin_cqi and context:character():character_subtype("ovn_com_legles_the_elf");
        end,
        function(context)
            cm:embed_agent_in_force(context:character(), cm:get_character_by_cqi(olorin_cqi):military_force());
            local char_cqi = context:character():command_queue_index()
            cm:set_character_immortality("character_cqi:"..char_cqi, true);
        end,
        false
    );
    core:add_listener(
        "giblit_created",
        "CharacterCreated",
        function(context)
            return olorin_cqi and context:character():character_subtype("ovn_com_giblit_the_dwarf");
        end,
        function(context)
            cm:embed_agent_in_force(context:character(), cm:get_character_by_cqi(olorin_cqi):military_force());
            local char_cqi = context:character():command_queue_index()
            cm:set_character_immortality("character_cqi:"..char_cqi, true);
        end,
        false
    );

    local faction_cqi = cm:get_character_by_cqi(olorin_cqi):faction():command_queue_index()
    cm:spawn_unique_agent_at_character(faction_cqi, "ovn_com_aragand_the_layabout", olorin_cqi, true);
    cm:spawn_unique_agent_at_character(faction_cqi, "ovn_com_legles_the_elf", olorin_cqi, true);
    cm:spawn_unique_agent_at_character(faction_cqi, "ovn_com_giblit_the_dwarf", olorin_cqi, true);
end

local function spawn_new_force()
	cm:create_force_with_general(
		"ovn_hlf_the_comradeship", -- faction_key,
		"halfling_archer,wh2_dlc10_hef_mon_treekin_0,halfling_spear,halfling_inf", -- unit_list,
		"wh3_main_combi_region_grimtop", -- region_key,
		1045, -- x,
		489, -- y,
		"general", -- type,
		"ovn_com_olorin_the_grey_wizard", -- subtype,
		"names_name_162509577", -- name1,
		"", -- name2,
		"names_name_271572567", -- name3,
		"", -- name4,
		true,-- make_faction_leader,
        function(cqi) -- callback
            local str = "character_cqi:" .. cqi
            cm:set_character_immortality(str, true);
            cm:set_character_unique(str, true);
            spawn_heroes_around_olorin(cqi)
        end
	)
end

local function new_game_startup()
    local the_comradeship_string = "ovn_hlf_the_comradeship"
	local the_comradeship = cm:get_faction(the_comradeship_string)

    if not the_comradeship then return end

    local to_kill_cqi = nil
    local mixer_the_comradeship_leader = the_comradeship:faction_leader()

	if mixer_the_comradeship_leader and not mixer_the_comradeship_leader:is_null_interface() then
		to_kill_cqi = mixer_the_comradeship_leader:command_queue_index()
	end

    spawn_new_force()

    local grimtop_region = cm:get_region("wh3_main_combi_region_grimtop")

    cm:transfer_region_to_faction("wh3_main_combi_region_grimtop", "ovn_hlf_the_comradeship")
    cm:heal_garrison(grimtop_region:cqi());

    if the_comradeship:is_human() then
        cm:treasury_mod("ovn_hlf_the_comradeship", -1000)
    else
        cm:instantly_set_settlement_primary_slot_level(grimtop_region:settlement(), 3)
    end

    cm:heal_garrison(grimtop_region:cqi())

    local unit_count = 1 -- card32 count
    local rcp = 20 -- float32 replenishment_chance_percentage
    local max_units = 1 -- int32 max_units
    local murpt = 0.1 -- float32 max_units_replenished_per_turn
    local xp_level = 0 -- card32 xp_level
    local frr = "" -- (may be empty) String faction_restricted_record
    local srr = "" -- (may be empty) String subculture_restricted_record
    local trr = "" -- (may be empty) String tech_restricted_record
    local units = {
        "halfling_warfoot",
        "sr_ogre_ror",
        "halfling_cock",
        "wh_main_mtl_veh_soupcart",
        "halfling_cat_ror",
        "halfling_pantry_guards_ror",
        "halfling_lords_of_harvest_ror",
        "halfling_knights_kitchentable_ror",
    }

    for _, unit in ipairs(units) do
        cm:add_unit_to_faction_mercenary_pool(
            the_comradeship,
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

    cm:callback(function()
        if to_kill_cqi then
            local str = "character_cqi:" .. to_kill_cqi
            cm:set_character_immortality(str, false)
            cm:kill_character_and_commanded_unit(str, true)
        end
    end, 0)
end

local function on_every_first_tick()
    local the_comradeship_string = "ovn_hlf_the_comradeship"
	local the_comradeship = cm:get_faction(the_comradeship_string)
    cm:set_faction_max_secondary_cooking_ingredients(the_comradeship, 2)

    if cm:get_local_faction(true):name() == "ovn_hlf_the_comradeship" then
        core:remove_listener('ovn_hlf_on_opened_settlement_panel')
        core:add_listener(
            'ovn_hlf_on_opened_settlement_panel',
            'PanelOpenedCampaign',
            true,
            function(context)
                if context.string ~= "settlement_panel" then return end
    
                real_timer.unregister("ovn_hlf_show_restaurant_slots_real_timer")
                real_timer.register_repeating("ovn_hlf_show_restaurant_slots_real_timer", 0)
            end,
            true
        )
    
        core:remove_listener("ovn_hlf_show_restaurant_slots_real_timer")
        core:add_listener(
            "ovn_hlf_show_restaurant_slots_real_timer",
            "RealTimeTrigger",
            function(context)
                    return context.string == "ovn_hlf_show_restaurant_slots_real_timer"
            end,
            function()
                local ui_root = core:get_ui_root()
                local settlement_list = find_uicomponent(ui_root, "settlement_panel", "settlement_list")
                if not settlement_list then
                    real_timer.unregister("ovn_hlf_show_restaurant_slots_real_timer")
                    return
                    end
            
                for i=0, settlement_list:ChildCount()-1 do
                    local comp = settlement_list:Find(i) and UIComponent(settlement_list:Find(i))
                    if comp then
                        local button_player_foreign_view = find_uicomponent(comp, "settlement_view", "toggle_button_holder", "button_list", "button_player_foreign_view")
                        if button_player_foreign_view:Visible() then
                            local daemon = find_uicomponent(comp, "settlement_view", "hostile_views", "wh3_daemon_factions")
                            if daemon then
                                local daemon_slots = find_uicomponent(daemon, "slots")
                                if daemon_slots then
                                    daemon:SetVisible(true)
                                end
                            end
                        end
                    end
                end
            end,
            true
        )
    end
end

core:remove_listener('ovn_hlf_on_opened_cooking_panel')
core:add_listener(
	'ovn_hlf_on_opened_cooking_panel',
	'PanelOpenedCampaign',
	true,
	function(context)
		if cm:get_local_faction(true):name() ~= "ovn_hlf_the_comradeship" then return end

		local ui_root = core:get_ui_root()
		local cauldron = find_uicomponent(ui_root, "groms_cauldron")
		if not cauldron then return end

		local cauldron_bg = find_uicomponent(cauldron, "animated_background")
		cauldron_bg:SetImagePath("ui/skins/default/hlfng_burrow_panel_background.png")

		local arch = find_uicomponent(cauldron, "mid_colum", "pot_holder", "arch")
		local pot = find_uicomponent(cauldron, "mid_colum", "pot_holder", "pot")
		arch:SetVisible(false)
		pot:SetVisible(false)

		local startingX = nil
		local startingY = nil
		local ingredients_and_effects = find_uicomponent(cauldron, "mid_colum", "pot_holder", "ingredients_and_effects")
		for i=1,4 do
			local slot = find_uicomponent(ingredients_and_effects, "main_ingredient_slot_"..i)
			if slot then
				if not startingX then
					startingX, startingY = slot:Position()
				end

				local currentX, currentY = slot:Position()

				local deltaY = 300
				if i==2 or i==3 then
					deltaY = 300
				end
				slot:MoveTo(currentX, startingY+deltaY)

				if i==1 or i==4 then
					slot:SetCanResizeHeight(true)
					slot:SetCanResizeWidth(true)
					slot:Resize(64,64)
					slot:ResizeCurrentStateImage(0,64,64)
				end
			end
		end
	end,
	true
)

cm:add_first_tick_callback(
	function()
        on_every_first_tick()

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
