local function binding_iter(binding)
	local pos = 0
	local num_items = binding:num_items()
	return function()
			if pos < num_items then
					local item = binding:item_at(pos)
					pos = pos + 1
					return item
			end
			return
	end
end

local grudebringers_faction_key = "ovn_emp_grudgebringers"

local function spawn_new_force()

    local x = 712
    local y = 534
    local spawn_region = "wh3_main_combi_region_stormhenge" --doesn't really matter'
    if cm:get_campaign_name() == "cr_oldworld" then
		x=983
		y=896
		spawn_region= "cr_oldworld_region_flensburg"
    end
    if cm:get_campaign_name() == "cr_oldworldclassic" then
		x=983
		y=896
		spawn_region= "cr_oldworld_region_flensburg"
    end
    

	cm:create_force_with_general(
		"ovn_emp_grudgebringers", -- faction_key,
		"grudgebringer_cavalry,grudgebringer_infantry,grudgebringer_cannon,grudgebringer_crossbow", -- unit_list,
		spawn_region, -- region_key,
        x, -- x
        y, -- y,
		"general", -- type,
		"morgan_bernhardt", -- subtype,
		"names_name_210309005", -- name1,
		"", -- name2,
		"names_name_210309006", -- name3,
		"", -- name4,
		true,-- make_faction_leader,
        function(cqi) -- callback
            local str = "character_cqi:" .. cqi
            cm:set_character_immortality(str, true);
            cm:set_character_unique(str, true);
            cm:set_character_excluded_from_trespassing(cm:get_character_by_cqi(cqi), true)
        end
	)
end

local function new_game_startup()
    local grudgebringers_string = "ovn_emp_grudgebringers"
	local grudgebringers = cm:get_faction(grudgebringers_string)

    if not grudgebringers then return end
    local to_kill_cqi = nil
    local mixer_grudgebringers_leader = grudgebringers:faction_leader()

	if mixer_grudgebringers_leader and not mixer_grudgebringers_leader:is_null_interface() then
		to_kill_cqi = mixer_grudgebringers_leader:command_queue_index()
	end

    spawn_new_force()

    local unit_count = 1 -- card32 count
    local rcp = 20 -- float32 replenishment_chance_percentage
    local max_units = 1 -- int32 max_units
    local murpt = 0 -- float32 max_units_replenished_per_turn
    local xp_level = 0 -- card32 xp_level
    local frr = "" -- (may be empty) String faction_restricted_record
    local srr = "" -- (may be empty) String subculture_restricted_record
    local trr = "" -- (may be empty) String tech_restricted_record
    local units = {
		"helmgart_bowmen",
		"keelers_longbows",
		"dargrimm_firebeard_dwarf_warriors",
		"azguz_bloodfist_dwarf_warriors",
		"urblab_rotgut_mercenary_ogres",
		"treeman_knarlroot",
		"galed_elf_archers",
        "elrod_wood_elf_glade_guards",
        "black_avangers",
        "carlsson_cavalry",
        "carlsson_guard",
        "countess_guard",
        "vannheim_75th",
        "treeman_gnarl_fist",
        "ragnar_wolves",
        "flagellants_eusebio_the_bleak",
        "dieter_schaeffer_carroburg_greatswords",
        "imperial_cannon_darius_flugenheim",
        "knights_of_the_realm_bertrand_le_grande",
        "grail_knights_tristan_de_la_tourtristan_de_la_tour",
        "dwarf_envoy_dwarf_warriors",
        "jurgen_muntz_outlaw_infantry",
        "stephan_weiss_outlaw_pistoliers",
        "boris_von_raukov_4th_nuln_halberdiers",
        "uter_blomkwist_imperial_mortar",
        "dwarf_envoy_dwarf_warriors",
        "leitdorf_9th_crossbows",
        "emperors_hellblaster_volley_gun",
        "reiksguard_knights_todbringer"
    }

    
    for _, unit in ipairs(units) do
        cm:add_unit_to_faction_mercenary_pool(
            grudgebringers,
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
    cm:add_event_restricted_unit_record_for_faction("dwarf_envoy_dwarf_warriors", grudebringers_faction_key, "rhox_grudge_locked_by_envoy")
    
        if to_kill_cqi then
            cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
            local str = "character_cqi:" .. to_kill_cqi
            cm:set_character_immortality(str, false)
            cm:kill_character_and_commanded_unit(str, true)
            cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, 0.5)
        end
        
        -- prevent war with Order factions bar Lizardmen
        for culture_key, _ in pairs(RHOX_GRUDGEBRINGER_GOOD_CULTURE) do
            cm:force_diplomacy("faction:ovn_emp_grudgebringers", "culture:" .. culture_key, "war", false, false, true);
        end
        
        for faction_key, _ in pairs(RHOX_GRUDGEBRINGER_BAD_FACTION) do
            cm:force_diplomacy("faction:ovn_emp_grudgebringers", "faction:" .. faction_key, "war", true, true, true);
        end
        
        local all_factions = cm:model():world():faction_list();
        for i = 0, all_factions:num_items()-1 do
            local faction = all_factions:item_at(i);
            if faction:is_human() and RHOX_GRUDGEBRINGER_GOOD_CULTURE[faction:culture()] then
                cm:force_diplomacy("faction:ovn_emp_grudgebringers", "faction:" .. faction:name(), "war", true, true, true);
            end
        end;
        
        
        --Spawn Starting Enemy Army

		local enemy_x=717
		local enemy_y=534
        local spawn_region = "wh3_main_combi_region_stormhenge" --doesn't really matter'
		if cm:get_campaign_name() == "cr_oldworld" then
			enemy_x=987
			enemy_y=896
			spawn_region= "cr_oldworld_region_flensburg"
		end
		if cm:get_campaign_name() == "cr_oldworldclassic" then
			enemy_x=987
			enemy_y=896
			spawn_region= "cr_oldworld_region_flensburg"
		end
        
        if grudgebringers:is_human() then
            cm:create_force_with_general(
                    "wh2_main_skv_skaven_qb1",
                    "wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh2_main_skv_inf_clanrats_0,wh2_main_skv_inf_clanrats_0,wh2_main_skv_inf_clanrats_0,wh2_main_skv_inf_clanrats_1",
                    spawn_region,
                    enemy_x,
                    enemy_y,
                    "general",
                    "wh2_dlc14_skv_master_assassin",
                    "",
                    "",
                    "",
                    "",
                    true,
                    function(cqi)
                        cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, -1, true)
                        cm:disable_movement_for_character("character_cqi:" .. cqi)
                    end
                )
        
            cm:force_declare_war("wh2_main_skv_skaven_qb1", "ovn_emp_grudgebringers", false, false)
            
            cm:change_custom_faction_name("wh2_main_skv_skaven_qb1", common.get_localised_string("ovn_grudge_starting_enemy_faction_name"))
            
            cm:treasury_mod("ovn_emp_grudgebringers",-2000)
        end
    cm:lock_technology(grudebringers_faction_key, "wh2_dlc13_tech_emp_academia_1") --lock the basic empire economy tuff so the player won't get research available eventhough they have researched all
    cm:lock_technology(grudebringers_faction_key, "wh2_dlc13_tech_emp_economy_1")
    


end

function rhox_grudge_trigger_how_they_play()
    local grudge_interface = cm:model():world():faction_by_key(grudebringers_faction_key)
    
    if grudge_interface:is_human() == true then
        out("Rhox Grudge: Let's show how they play")
        local faction_name = grudge_interface:name()
        local title = "event_feed_strings_text_wh2_scripted_event_how_they_play_title";
        local primary_detail = "factions_screen_name_" .. faction_name;
        local secondary_detail = "event_feed_strings_text_rhox_grudge_event_feed_string_scripted_event_intro_grudgebringer_secondary_detail";
        local pic = 3301240;
        out(title)
        out(primary_detail)
        out(secondary_detail)
        cm:show_message_event(
            faction_name,
            title,
            primary_detail,
            secondary_detail,
            true,
            pic
        );
        out("Rhox Grudge: I'd show them the how to play")
    end
end





cm:add_first_tick_callback(
	function()
        pcall(function()
            mixer_set_faction_trait("ovn_emp_grudgebringers", "ovn_lord_trait_emp_morgan", true)
        end)
		if cm:is_new_game() then
			if cm:get_campaign_name() == "main_warhammer" or cm:get_campaign_name() == "cr_oldworld" or cm:get_campaign_name() == "cr_oldworldclassic" then
				local ok, err =
					pcall(
					function()
                        new_game_startup()
                        rhox_setup_starting_missions()
                        cm:callback(
                            function()
                                rhox_grudge_trigger_how_they_play()
                            end,
                            5.0
                        )
					end
				)
				if not ok then
					script_error(err)
				end
			end
		end
	end
)

core:remove_listener('ovn_grudgebringers_on_faction_turn_start')
core:add_listener(
	'ovn_grudgebringers_on_faction_turn_start',
	'FactionTurnStart',
	true,
	function(context)
		---@type CA_FACTION
		local faction = context:faction()
		if faction:name() ~= grudebringers_faction_key then return end

		for char in binding_iter(faction:character_list()) do
			cm:set_character_excluded_from_trespassing(char, true)
		end

	end,
	true
)

core:remove_listener("ovn_grudgebringers_on_character_created_remove_trespass_penalty")
core:add_listener(
	"ovn_grudgebringers_on_character_created_remove_trespass_penalty",
	"CharacterCreated",
	function(context)
		---@type CA_FACTION
		local faction = context:character():faction()
		return faction:name() == grudebringers_faction_key
	end,
	function(context)
		local char = context:character()
		cm:set_character_excluded_from_trespassing(char, true)
		local faction = context:character():faction()
		if faction:is_human() == false and char:character_subtype_key() == "morgan_bernhardt" then --give AI replenishment bonus and AI can't handle it
            cm:apply_effect_bundle_to_character("rhox_grudge_AI_hidden_bonus", char, -1)
		end
	end,
	true
)

core:remove_listener("ovn_grudgebringers_on_character_replacing_general_remove_trespass_penalty")
core:add_listener(
	"ovn_grudgebringers_on_character_replacing_general_remove_trespass_penalty",
	"CharacterReplacingGeneral",
	function(context)
		---@type CA_FACTION
		local faction = context:character():faction()
		return faction:name() == grudebringers_faction_key
	end,
	function(context)
		local char = context:character()
		cm:set_character_excluded_from_trespassing(char, true)
		local faction = context:character():faction()
		if faction:is_human() == false and char:character_subtype_key() == "morgan_bernhardt" then --give AI replenishment bonus and AI can't handle it
            cm:apply_effect_bundle_to_character("rhox_grudge_AI_hidden_bonus", char, -1)
		end
	end,
	true
)


RHOX_GRUDGEBRINGER_MCT={
    ror_skip = 8,
    all_hero = false,
    disable_all_hero_recruitment=false,--this is for compatibility
}


core:add_listener(
    "rhox_grudge_mct_initialize",
    "MctInitialized",
    true,
    function(context)
        -- get the mct object
        local mct = context:mct()

        local my_mod = mct:get_mod_by_key("ovn_grudgebringer")

        
        local mct_ror_skip_num = my_mod:get_option_by_key("rhox_grudge_ror_skip")
        RHOX_GRUDGEBRINGER_MCT.ror_skip = mct_ror_skip_num:get_finalized_setting()
        
        local mct_all_hero_option = my_mod:get_option_by_key("rhox_grudge_all_hero")
        RHOX_GRUDGEBRINGER_MCT.all_hero = mct_all_hero_option:get_finalized_setting()
        
        


    end,
    true
)