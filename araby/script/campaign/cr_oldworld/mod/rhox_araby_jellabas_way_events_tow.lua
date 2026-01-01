local jaffar_faction_key = "ovn_arb_sultanate_of_all_araby"

local araby_culture = "ovn_araby"

local rhox_araby_jaffar_events_cooldown = {}
local rhox_araby_jaffar_event_max_cooldown = 15

local rhox_caravan_exception_list={
    ovn_arb_cha_caravan_master =true,
    ovn_arb_cha_sheikh_0 =true,
    ovn_arb_cha_sheikh_1 =true,
}




local rhox_araby_jaffar_event_tables = {

    --Format is [key] == {probability function, event function}

    ["cathayCargo"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_cathay_caravan";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if world_conditions["caravan"]:cargo() >= 1000 then
            probability = 0;
        end
        
        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end

        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh3_main_cth_cathay_qb1"
        
        local eventname = "cathayCargo".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("cathayCargo action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_cathay_caravan";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "cathay_caravan_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo+100)
        end
        
        custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_cathay_caravan_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        payload_builder:text_display("dummy_convoy_cathay_caravan_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["genericShortcut"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "genericShortcut".."?";
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_the_guide"
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("genericShortcut action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_the_guide"			
        
        function extra_move()
            --check if more than 1 move from the end
            cm:move_caravan(caravan_handle);
        end
        custom_option = extra_move;
        
        rhox_araby_jaffar_attach_battle_to_dilemma(
            dilemma_name,
            caravan_handle,
            nil,
            false,
            nil,
            nil,
            nil,
            custom_option);
        
        local scout_skill = caravan_handle:caravan_master():character_details():character():bonus_values():scripted_value("caravan_scouting", "value");
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        local faction_key = caravan_handle:caravan_force():faction():name();

        local own_faction = caravan_handle:caravan_force():faction();

        payload_builder:text_display("dummy_convoy_guide_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        payload_builder:treasury_adjustment(math.floor(-500*((100+scout_skill)/100)));

        payload_builder:text_display("dummy_convoy_guide_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        dilemma_builder:add_target("default", caravan_handle:caravan_force());

        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
        
    end,
    false},


    ["ogreRecruitment"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "ogreRecruitment".."?";
        local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
        local dilemma_name = "rhox_araby_jaffar_dilemma_ogre_mercenaries";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        local probability = math.floor((20 - army_size)/2);

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("ogreRecruitment action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_ogre_mercenaries";
        local faction_key = caravan_handle:caravan_force():faction():name();
        --Decode the string into arguments-- Need to specify the argument encoding
        --none to decode
        
        rhox_araby_jaffar_attach_battle_to_dilemma(
                    dilemma_name,
                    caravan_handle,
                    nil,
                    false,
                    nil,
                    nil,
                    nil,
                    nil);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local ogre_list = {"wh3_main_ogr_inf_maneaters_0","wh3_main_ogr_inf_maneaters_1","wh3_main_ogr_inf_maneaters_2"};
        
        payload_builder:add_unit(caravan_handle:caravan_force(), ogre_list[cm:random_number(#ogre_list,1)], 1, 0);
        payload_builder:treasury_adjustment(-1000);
        payload_builder:text_display("dummy_convoy_ogres_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        payload_builder:text_display("dummy_convoy_ogres_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["skavenShortcut"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_rats_in_a_tunnel";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh2_main_skv_skaven_qb1"
        
        local eventname = "skavenShortcut".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("skavenShortcut action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_rats_in_a_tunnel";
        local caravan = caravan_handle;
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "skaven_shortcut_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        function extra_move()
            --check if more than 1 move from the end
            cm:move_caravan(caravan_handle);
        end
        custom_option = extra_move;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local own_faction = caravan_handle:caravan_force():faction();

        payload_builder:text_display("dummy_convoy_rats_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());

        payload_builder:clear();

        payload_builder:text_display("dummy_convoy_rats_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["dwarfsConvoy"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_dwarfs";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if world_conditions["caravan"]:cargo() >= 1000 then
            probability = 0
        end

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh_main_dwf_dwarfs_qb1"
        
        local eventname = "dwarfsConvoy".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("dwarfsConvoy action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_dwarfs";
        local caravan = caravan_handle;
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "dwarf_convoy_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo+100)
        end
        
        custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );

                                                
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
        local own_faction = caravan_handle:caravan_force():faction();

        payload_builder:text_display("dummy_convoy_dwarfs_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        payload_builder:clear();
        payload_builder:text_display("dummy_convoy_cathay_caravan_second"); --it says cathay but it's just avoid battle so it's okay
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        
    
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["ogreAmbush"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_the_ambush";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end

        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh3_main_ogr_ogre_kingdoms_qb1"
        
        local eventname = "ogreAmbush".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("ogreAmbush action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_the_ambush";
        local caravan = caravan_handle;
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "ogre_bandit_high_b");
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );

        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();

        local own_faction = caravan_handle:caravan_force():faction();
        payload_builder:text_display("dummy_convoy_ambush_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());

        payload_builder:clear();
        payload_builder:text_display("dummy_convoy_ambush_second");										
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["hobgoblinTribute"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "hobgoblinTribute".."?";
        local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
        local dilemma_name = "rhox_araby_jaffar_dilemma_fresh_battlefield";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        local probability = math.floor((20 - army_size)/2);

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("hobgoblinTribute action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_fresh_battlefield";
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- Need to specify the argument encoding
        --none to decode
        
        rhox_araby_jaffar_attach_battle_to_dilemma(
                    dilemma_name,
                    caravan_handle,
                    nil,
                    false,
                    nil,
                    nil,
                    nil,
                    nil);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        


        
        local araby_unit_list = {"ovn_arb_inf_arabyan_warriors","ovn_arb_inf_arabyan_spearmen","ovn_arb_inf_arabyan_bowmen"};
        
        payload_builder:add_unit(caravan_handle:caravan_force(), araby_unit_list[cm:random_number(#araby_unit_list,1)], 2, 0);
        payload_builder:text_display("dummy_convoy_hobgoblin_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        local replenish = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2");
        replenish:add_effect("wh_main_effect_force_all_campaign_replenishment_rate", "force_to_force_own", 8);
        replenish:add_effect("wh_main_effect_force_army_campaign_enable_replenishment_in_foreign_territory", "force_to_force_own", 1);
        replenish:set_duration(2);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), replenish);
        payload_builder:text_display("dummy_convoy_hobgoblin_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["hungryDaemons"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local event_region = world_conditions["event_region"];
        local enemy_faction_name = "wh_main_chs_chaos_qb1";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        local enemy_faction = cm:get_faction(enemy_faction_name);
        
        local random_unit ="NONE";
        local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
        
        if caravan_force_unit_list:num_items() > 1 then
            random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items()-1,1)):unit_key();
            
            if rhox_caravan_exception_list[random_unit] then
                random_unit = "NONE";
            end
            out.design("Random unit to be eaten: "..random_unit);
        end;
        
        --Construct targets
        local eventname = "hungryDaemons".."?"
            ..event_region:name().."*"
            ..random_unit.."*"
            ..tostring(bandit_threat).."*"
            ..enemy_faction_name.."*";
            
        
        --Calculate probability
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_hungry_daemons";
        
        if random_unit == "NONE" then
            probability = 0;
        else
            probability = 1;
            
            if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
                probability = 0;
            end
        end

        

        local caravan_faction = world_conditions["faction"];
        if enemy_faction:name() == caravan_faction:name() then
            probability = 0;
        end;
        
        --probability = 10000
        
        return {probability,eventname}
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("hungryDaemons action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_hungry_daemons";
        local caravan = caravan_handle;
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- Need to specify the argument encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = true;
        local target_faction = decoded_args[4];
        local enemy_faction = decoded_args[4];
        local target_region = decoded_args[1];
        local custom_option = nil;
        
        local random_unit = decoded_args[2];
        local bandit_threat = tonumber(decoded_args[3]);
        local attacking_force = rhox_araby_generate_attackers(bandit_threat,"hungry_chaos_army")
        
        
        --Eat unit to option 2
        function eat_unit_outcome()
            if random_unit ~= nil then
                local caravan_master_lookup = cm:char_lookup_str(caravan:caravan_force():general_character():command_queue_index())
                cm:remove_unit_from_character(
                caravan_master_lookup,
                random_unit);

            else
                out("Script error - should have a unit to eat?")
            end
        end
        
        custom_option = nil; --eat_unit_outcome;
        
        --Battle to option 1, eat unit to 2
        local enemy_force_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                    dilemma_name,
                                                    caravan,
                                                    attacking_force,
                                                    false,
                                                    target_faction,
                                                    enemy_faction,
                                                    target_region,
                                                    custom_option
                                                    );
    
        --Trigger dilemma to be handled by above function
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        payload_builder:text_display("dummy_convoy_hungry_daemons_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        local target_faction_object =  cm:get_faction(target_faction);
        
        payload_builder:remove_unit(caravan:caravan_force(), random_unit);

        payload_builder:text_display("dummy_convoy_hungry_daemons_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        out.design("Triggering dilemma:"..dilemma_name)
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_force_cqi));
        
        dilemma_builder:add_target("target_military_1", caravan:caravan_force());
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["trainingCamp"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "trainingCamp".."?";
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_training_camp";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions, caravan_handle)
        
        out.design("trainingCamp action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_training_camp";
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- Need to specify the argument encoding
        --none to decode
        
        rhox_araby_jaffar_attach_battle_to_dilemma(
                    dilemma_name,
                    caravan_handle,
                    nil,
                    false,
                    nil,
                    nil,
                    nil,
                    nil);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();

        local experience = cm:create_new_custom_effect_bundle("wh3_dlc23_dilemma_chd_convoy_experience");
        experience:add_effect("wh2_main_effect_captives_unit_xp", "force_to_force_own", 2000);
        experience:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), experience);
        payload_builder:text_display("dummy_convoy_training_camp_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        payload_builder:text_display("dummy_convoy_training_camp_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["wayofLava"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "wayofLava".."?";
        
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_way_of_lava";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        --probability = 10000

        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions, caravan_handle)
        
        out.design("wayofLava action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_way_of_lava";
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- Need to specify the argument encoding
        --none to decode
        
        
        rhox_araby_jaffar_attach_battle_to_dilemma(
            dilemma_name,
            caravan_handle,
            nil,
            false,
            nil,
            nil,
            nil,
            nil);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();

        payload_builder:text_display("dummy_convoy_way_of_lava_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        local attrition = cm:create_new_custom_effect_bundle("wh3_dlc23_dilemma_chd_convoy_attrition");
        attrition:add_effect("wh_main_effect_campaign_enable_attrition", "force_to_force_own", 500);
        attrition:set_duration(3);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), attrition);

        payload_builder:text_display("dummy_convoy_way_of_lava_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["offenceorDefence"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "offenceorDefence".."?";
        
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_offence_or_defence";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions, caravan_handle)
        
        out.design("wayofLava action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_offence_or_defence";
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- Need to specify the argument encoding
        --none to decode
        
        rhox_araby_jaffar_attach_battle_to_dilemma(
            dilemma_name,
            caravan_handle,
            nil,
            false,
            nil,
            nil,
            nil,
            nil);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();

        local offence = cm:create_new_custom_effect_bundle("wh3_dlc23_dilemma_chd_convoy_offence");
        offence:add_effect("wh_main_effect_force_stat_melee_attack", "force_to_force_own", 10);
        offence:add_effect("wh_main_effect_force_stat_weapon_strength", "force_to_force_own", 20);
        offence:set_duration(5);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), offence);

        payload_builder:text_display("dummy_convoy_offence_defence_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        local defence = cm:create_new_custom_effect_bundle("wh3_dlc23_dilemma_chd_convoy_defence");
        defence:add_effect("wh_main_effect_force_stat_melee_defence", "force_to_force_own", 10);
        defence:add_effect("wh_main_effect_force_stat_armour", "force_to_force_own", 20);
        defence:set_duration(5);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), defence);

        payload_builder:text_display("dummy_convoy_offence_defence_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["localisedElfs"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_localised_elfs";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        if world_conditions["caravan"]:cargo() >= 1000 then
            probability = 0;
        end

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh2_main_hef_high_elves_qb1"
        
        local eventname = "localisedElfs".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("localisedElfs action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_localised_elfs";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "high_elf_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo+100)
        end
        
        custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_localised_elfs_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        payload_builder:text_display("dummy_convoy_localised_elfs_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["readDeadify"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local event_region = world_conditions["event_region"];
        local enemy_faction_name = "wh_main_vmp_vampire_counts_qb1";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        local enemy_faction = cm:get_faction(enemy_faction_name);
        
        local random_unit ="NONE";
        local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
        
        if caravan_force_unit_list:num_items() > 1 then
            random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items()-1,1)):unit_key();
            
            if rhox_caravan_exception_list[random_unit] then
                random_unit = "NONE";
            end
            out.design("Random unit to be eaten: "..random_unit);
        end;
        
        --Construct targets
        local eventname = "readDeadify".."?"
            ..event_region:name().."*"
            ..random_unit.."*"
            ..tostring(bandit_threat).."*"
            ..enemy_faction_name.."*";
            
        
        --Calculate probability
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_redeadify";
        
        if random_unit == "NONE" then
            probability = 0;
        else
            probability = 1;
            if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
                probability = 0;
            end
        end
        local caravan_faction = world_conditions["faction"];
        if enemy_faction:name() == caravan_faction:name() then
            probability = 0;
        end;
        
        --probability = 10000
        
        return {probability,eventname}
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("hungryDaemons action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_redeadify";
        local caravan = caravan_handle;
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- Need to specify the argument encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = true;
        local target_faction = decoded_args[4];
        local enemy_faction = decoded_args[4];
        local target_region = decoded_args[1];
        local custom_option = nil;
        
        local random_unit = decoded_args[2];
        local bandit_threat = tonumber(decoded_args[3]);
        local attacking_force = rhox_araby_generate_attackers(bandit_threat,"vampire_count_army")
        
        
        --Eat unit to option 2
        function eat_unit_outcome()
            if random_unit ~= nil then
                local caravan_master_lookup = cm:char_lookup_str(caravan:caravan_force():general_character():command_queue_index())
                cm:remove_unit_from_character(
                caravan_master_lookup,
                random_unit);

            else
                out("Script error - should have a unit to eat?")
            end
        end
        
        custom_option = nil; --eat_unit_outcome;
        
        --Battle to option 1, eat unit to 2
        local enemy_force_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                    dilemma_name,
                                                    caravan,
                                                    attacking_force,
                                                    false,
                                                    target_faction,
                                                    enemy_faction,
                                                    target_region,
                                                    custom_option
                                                    );
    
        --Trigger dilemma to be handled by above function
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        payload_builder:text_display("dummy_convoy_redeadify_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        local target_faction_object =  cm:get_faction(target_faction);
        
        payload_builder:remove_unit(caravan:caravan_force(), random_unit);

        payload_builder:text_display("dummy_convoy_redeadify_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        out.design("Triggering dilemma:"..dilemma_name)
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_force_cqi));
        
        dilemma_builder:add_target("target_military_1", caravan:caravan_force());
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},
    
    ["farfromHome"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_far_from_home";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        if world_conditions["caravan"]:cargo() >= 1000 then
            probability = 0;
        end

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh2_dlc09_tmb_tombking_qb1"
        
        local eventname = "farfromHome".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("farfromHome action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_far_from_home";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "tomb_kings_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo+100)
        end
        
        custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_far_from_home_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        payload_builder:text_display("dummy_convoy_far_from_home_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["quickWayDown"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "quickWayDown".."?";
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_quick_way_down"
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();	

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("quickWayDown action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_quick_way_down"	
        local faction_key = caravan_handle:caravan_force():faction():name();		
        --Decode the string into arguments-- Need to specify the argument encoding
        --none to decode
        
        local cargo_amount = caravan_handle:cargo();

        function remove_cargo()
            cm:set_caravan_cargo(caravan_handle, cargo_amount-50)
        end
        
        custom_option = remove_cargo;
        
        rhox_araby_jaffar_attach_battle_to_dilemma(
            dilemma_name,
            caravan_handle,
            nil,
            false,
            nil,
            nil,
            nil,
            custom_option);
        
        local scout_skill = caravan_handle:caravan_master():character_details():character():bonus_values():scripted_value("caravan_scouting", "value");
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local own_faction = caravan_handle:caravan_force():faction();

        local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -50);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);

        payload_builder:text_display("dummy_convoy_quick_way_down_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        payload_builder:text_display("dummy_convoy_quick_way_down_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        dilemma_builder:add_target("default", caravan_handle:caravan_force());

        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
        
    end,
    false},

    ["tradingDarkElfs"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "tradingDarkElfs".."?";
        local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        local probability = math.floor((20 - army_size)/2);
        local dilemma_name = "rhox_araby_jaffar_dilemma_trading_dark_elfs";

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("tradingDarkElfs action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_trading_dark_elfs";
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local cargo_amount = caravan_handle:cargo();

        function remove_cargo()
            cm:set_caravan_cargo(caravan_handle, cargo_amount-100)
        end
        
        custom_option = remove_cargo;

        rhox_araby_jaffar_attach_battle_to_dilemma(
                    dilemma_name,
                    caravan_handle,
                    nil,
                    false,
                    nil,
                    nil,
                    nil,
                    custom_option);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);

        local monster_list = {"wh2_dlc10_def_mon_kharibdyss_0","wh2_twa03_def_mon_war_mammoth_0","wh2_main_def_mon_black_dragon"};
        
        payload_builder:add_unit(caravan_handle:caravan_force(), monster_list[cm:random_number(#monster_list,1)], 1, 0);
        payload_builder:text_display("dummy_convoy_trading_dark_elfs_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        payload_builder:text_display("dummy_convoy_trading_dark_elfs_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["powerOverwhelming"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local random_unit ="NONE";
        local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
        local event_region = world_conditions["event_region"];
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        if caravan_force_unit_list:num_items() > 1 then
            random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items()-1,1)):unit_key();
            
            if rhox_caravan_exception_list[random_unit] then
                random_unit = "NONE";
            end
            out.design("Random unit to be eaten: "..random_unit);
        end;
        
        --Construct targets
        local eventname = "powerOverwhelming".."?"
            ..event_region:name().."*"
            ..random_unit.."*";

        --Calculate probability
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_power_overwhelming";

        if random_unit == "NONE" then
            probability = 0;
        else
            probability = 1;
            if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
                probability = 0;
            end
        end;

        --probability = 10000
        return {probability,eventname}
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("powerOverwhelming action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_power_overwhelming";
        local caravan = caravan_handle;
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- Need to specify the argument encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3); --use vanilla
        
        local is_ambush = true;
        local target_faction = decoded_args[4];
        local target_region = decoded_args[1];
        local custom_option = nil;
        
        local random_unit = decoded_args[2];
        
        function eat_unit_outcome()
            if random_unit ~= nil then
                local caravan_master_lookup = cm:char_lookup_str(caravan:caravan_force():general_character():command_queue_index())
                cm:remove_unit_from_character(
                caravan_master_lookup,
                random_unit);

            else
                out("Script error - should have a unit to eat?")
            end
        end
        
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- Need to specify the argument encoding
        --none to decode
        
        rhox_araby_jaffar_attach_battle_to_dilemma(
                    dilemma_name,
                    caravan_handle,
                    nil,
                    false,
                    nil,
                    nil,
                    nil,
                    nil);

    
        --Trigger dilemma to be handled by above function
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local power = cm:create_new_custom_effect_bundle("wh3_dlc23_dilemma_chd_power_overwhelming");
        power:add_effect("wh_main_effect_force_all_campaign_replenishment_rate", "force_to_force_own", 5);
        power:add_effect("wh_main_effect_force_stat_speed", "force_to_force_own", 10);
        power:add_effect("wh_main_effect_force_stat_ap_damage", "force_to_force_own", 10);
        power:add_effect("wh_main_effect_force_stat_leadership_pct", "force_to_force_own", 15);
        power:add_effect("wh_main_effect_force_stat_ward_save", "force_to_force_own", 15);
        power:add_effect("wh_main_effect_force_army_campaign_enable_replenishment_in_foreign_territory", "force_to_force_own", 10);
        power:set_duration(10);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), power);
        payload_builder:text_display("dummy_convoy_power_overwhelming_first");
        payload_builder:remove_unit(caravan:caravan_force(), random_unit);
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        payload_builder:text_display("dummy_convoy_power_overwhelming_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        out.design("Triggering dilemma:"..dilemma_name)
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

	["tkcrypt"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_tk_crypt";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh2_dlc09_tmb_tombking_qb1"
        
		if event_region and event_region:owning_faction() and event_region:owning_faction():culture() == "wh2_dlc09_tmb_tomb_kings" then
			probability = probability+3
		end

        local eventname = "tkcrypt".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("tkcrypt action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_tk_crypt";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "tomb_kings_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo-100)
        end
        
        custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_portal_2_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

		local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);

        payload_builder:text_display("dummy_convoy_portal_2_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},
	
	["skvambush"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_skaven_ambush";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh2_main_skv_skaven_qb1"
        
		if event_region and event_region:owning_faction() and event_region:owning_faction():culture() == "wh2_main_skv_skaven" then
			probability = probability+3
		end

        local eventname = "skvambush".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("skvambush action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_skaven_ambush";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "skaven_shortcut_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo-100)
        end
        
        custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_50_battle");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

		local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);

        payload_builder:text_display("dummy_convoy_portal_2_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

	["blackark"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local dilemma_name = "rhox_araby_jaffar_dilemma_def_black_ark_reinforcement_battle";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
		local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()

		local probability = math.floor((20 - army_size)/2);

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh2_main_def_dark_elves_qb1"
        
		if event_region and event_region:owning_faction() and event_region:owning_faction():culture() == "wh2_main_def_dark_elves" then
			probability = probability+1
		end
		if army_size > 18 then
			probability=0
		end

        local eventname = "blackark".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("blackark action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_def_black_ark_reinforcement_battle";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "rhox_araby_def_caravan_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_fight_keep_slave");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

		payload_builder:add_unit(caravan_handle:caravan_force(), "wh2_main_def_inf_bleakswords_0", 1, 0);
		payload_builder:add_unit(caravan_handle:caravan_force(), "wh2_main_def_inf_darkshards_1", 1, 0);
		payload_builder:faction_pooled_resource_transaction("def_slaves", "wh3_dlc23_chd_consumed", -150, true)
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

	["csttreasuremap"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_cst_treasure_map";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh2_dlc11_cst_vampire_coast_qb1"
        
		if event_region and event_region:owning_faction() and event_region:owning_faction():culture() == "wh2_dlc11_cst_vampire_coast" then
			probability = probability+3
		end

        local eventname = "csttreasuremap".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("csttreasuremap action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_cst_treasure_map";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "rhox_araby_cst_caravan_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        

        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_fight_treasure_map");
		payload_builder:treasury_adjustment(5000)
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

		payload_builder:text_display("dummy_convoy_power_overwhelming_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

	["taxingjourney"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local dilemma_name = "rhox_araby_jaffar_dilemma_hef_tax_reinforcement_battle";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
		local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()

		local probability = math.floor((20 - army_size)/2);

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh2_main_hef_high_elves_qb1"
        
		if event_region and event_region:owning_faction() and event_region:owning_faction():culture() == "wh2_main_hef_high_elves" then
			probability = probability+1
		end
		if army_size > 18 then
			probability=0
		end

        local eventname = "taxingjourney".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("taxingjourney action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_hef_tax_reinforcement_battle";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "high_elf_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo-250)
        end
        
        custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_portal_2_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
		
		
		payload_builder:add_unit(caravan_handle:caravan_force(), "wh2_main_hef_inf_archers_1", 1, 0);
		payload_builder:add_unit(caravan_handle:caravan_force(), "wh2_main_hef_inf_spearmen_0", 1, 0);
		local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -250);
        cargo_bundle:set_duration(0);
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
		payload_builder:text_display("dummy_convoy_portal_2_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

	["rublamp"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_wooden_lamp";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh_dlc05_wef_wood_elves_qb2"
        
		

        local eventname = "rublamp".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("rublamp action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_wooden_lamp";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "rhox_araby_wef_lamp_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo-100)
        end
        
        custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_50_battle");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

		local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
		payload_builder:add_unit(caravan_handle:caravan_force(), "wh_dlc05_wef_mon_treeman_0", 1, 0);
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},
    
	["brterrantry"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_brt_errant";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh_main_brt_bretonnia_qb1"
        
		if event_region and event_region:owning_faction() and event_region:owning_faction():culture() == "wh_main_brt_bretonnia" then
			probability = probability+3
		end

        local eventname = "brterrantry".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("brterrantry action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_brt_errant";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "rhox_araby_brt_caravan_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        
 
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        local own_faction = caravan_handle:caravan_force():faction();
        
		local dilemma_bundle = cm:create_new_custom_effect_bundle("rhox_araby_punished_bret");
        dilemma_bundle:set_duration(5);
        payload_builder:effect_bundle_to_faction(dilemma_bundle);
        payload_builder:text_display("dummy_convoy_hungry_daemons_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

		local dilemma_bundle2 = cm:create_new_custom_effect_bundle("rhox_araby_spared_bret");
        dilemma_bundle2:set_duration(5);
		payload_builder:text_display("dummy_convoy_localised_elfs_second");
		payload_builder:effect_bundle_to_faction(dilemma_bundle2);
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

	["heftribute"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_hef_tribute";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
		local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh2_main_hef_high_elves_qb2"
        
		if event_region and event_region:owning_faction() and event_region:owning_faction():culture() == "wh2_main_hef_high_elves" then
			probability = probability+3
		end

        local eventname = "heftribute".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("heftribute action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_hef_tribute";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "high_elf_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo-200)
        end
        
        custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_portal_2_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
		
		local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -200);
        cargo_bundle:set_duration(0);
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
		payload_builder:text_display("dummy_convoy_portal_2_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

	["defcorsair"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_def_corsair";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
		local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh2_main_def_dark_elves_qb1"
        
		if event_region and event_region:owning_faction() and event_region:owning_faction():culture() == "wh2_main_def_dark_elves" then
			probability = probability+3
		end
		if army_size > 18 then
			probability=0
		end

        local eventname = "defcorsair".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("defcorsair action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_def_corsair";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "rhox_araby_def_caravan_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo-250)
        end
        
        custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_portal_2_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
		
		local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -250);
        cargo_bundle:set_duration(0);
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
		payload_builder:text_display("dummy_convoy_portal_2_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

	["northernmercenaries"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "northernmercenaries".."?";
        local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        local probability = math.floor((20 - army_size)/2);
        local dilemma_name = "rhox_araby_jaffar_dilemma_emp_mercenaries";

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("northernmercenaries action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_emp_mercenaries";
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local cargo_amount = caravan_handle:cargo();


        
        local custom_option = nil;

        rhox_araby_jaffar_attach_battle_to_dilemma(
                    dilemma_name,
                    caravan_handle,
                    nil,
                    false,
                    nil,
                    nil,
                    nil,
                    custom_option);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);

        local unit_list = {"wh_main_emp_inf_halberdiers","wh_main_emp_inf_handgunners","wh_dlc04_emp_inf_free_company_militia_0", "wh_main_emp_cav_pistoliers_1"};
        payload_builder:treasury_adjustment(-1000)
        payload_builder:add_unit(caravan_handle:caravan_force(), unit_list[cm:random_number(#unit_list,1)], 1, 0);
        payload_builder:text_display("dummy_convoy_trading_dark_elfs_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        payload_builder:text_display("dummy_convoy_trading_dark_elfs_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

	["smokesignal"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local dilemma_name = "rhox_araby_jaffar_dilemma_chd_cannon_reinforcement_battle";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
		local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
		local probability = math.floor((20 - army_size)/2);

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh3_dlc23_chd_chaos_dwarfs_qb1"
        
		if event_region and event_region:owning_faction() and event_region:owning_faction():culture() == "wh3_dlc23_chd_chaos_dwarfs" then
			probability = probability+1
		end
		if army_size > 18 then
			probability=0
		end

        local eventname = "smokesignal".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("smokesignal action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_chd_cannon_reinforcement_battle";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "rhox_araby_chd_caravan_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_fight_keep_slave");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

		payload_builder:add_unit(caravan_handle:caravan_force(), "wh3_dlc23_chd_veh_iron_daemon", 1, 0);
		payload_builder:faction_pooled_resource_transaction("def_slaves", "wh3_dlc23_chd_consumed", -200, true)
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

	["mountainfolk"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local dilemma_name = "rhox_araby_jaffar_dilemma_dwf_thane_reinforcement_battle";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
		local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
		local probability = math.floor((20 - army_size)/2);

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh_main_dwf_dwarfs_qb1"
        
		if event_region and event_region:owning_faction() and event_region:owning_faction():culture() == "wh_main_dwf_dwarfs" then
			probability = probability+1
		end
		if army_size > 18 then
			probability=0
		end

        local eventname = "mountainfolk".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("mountainfolk action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_dwf_thane_reinforcement_battle";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "dwarf_convoy_army");
        
        
        local cargo_amount = caravan_handle:cargo();
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo+100)
        end
		custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_dwarfs_first");
		local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        payload_builder:add_unit(caravan_handle:caravan_force(), "wh_main_dwf_cha_thane", 1, 0);
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

	["mourkainshortcut"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "mourkainshortcut".."?";
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_vmp_shortcut"
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();	

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("mourkainshortcut action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_vmp_shortcut"	
        local faction_key = caravan_handle:caravan_force():faction():name();		
        --Decode the string into arguments-- Need to specify the argument encoding
        --none to decode
        
        local cargo_amount = caravan_handle:cargo();

        function remove_cargo()
            cm:set_caravan_cargo(caravan_handle, cargo_amount-100)
        end
        
        custom_option = remove_cargo;
        
        rhox_araby_jaffar_attach_battle_to_dilemma(
            dilemma_name,
            caravan_handle,
            nil,
            false,
            nil,
            nil,
            nil,
            custom_option);
        
        local scout_skill = caravan_handle:caravan_master():character_details():character():bonus_values():scripted_value("caravan_scouting", "value");
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local own_faction = caravan_handle:caravan_force():faction();

        local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);

        payload_builder:text_display("dummy_convoy_quick_way_down_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        payload_builder:text_display("dummy_convoy_quick_way_down_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        dilemma_builder:add_target("default", caravan_handle:caravan_force());

        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
        
    end,
    false},

    ["fimirBattle"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_fimir_battle";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
		local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()



        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "mixer_fim_fimir_dummy"
        
		if event_region and event_region:owning_faction() and event_region:owning_faction():culture() == "ovn_fimir" then
			probability = probability+3
		end

        if not vfs.exists("script/frontend/mod/ovn_fimir_frontend.lua") then
            probability = 0;
        end

        local eventname = "fimirBattle".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("fimirBattle action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_fimir_battle";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = true;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "rhox_araby_fimir_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo-100)
        end
        
        custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_portal_2_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
		
		local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -100);
        cargo_bundle:set_duration(0);
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
		payload_builder:text_display("dummy_convoy_portal_2_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["TEBevent"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "TEBevent".."?";
        local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        local probability = math.floor((20 - army_size)/2);
        local dilemma_name = "rhox_araby_jaffar_dilemma_teb_reinforcement";

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end

        if not vfs.exists("script/frontend/mod/cataph_teb.lua") then
            probability = 0;
        end
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("TEBevent action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_teb_reinforcement";
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local cargo_amount = caravan_handle:cargo();


        
        local custom_option = nil;

        rhox_araby_jaffar_attach_battle_to_dilemma(
                    dilemma_name,
                    caravan_handle,
                    nil,
                    false,
                    nil,
                    nil,
                    nil,
                    custom_option);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        payload_builder:add_unit(caravan_handle:caravan_force(), "teb_pavisiers", 2, 0);
        payload_builder:text_display("dummy_convoy_portal_3_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        payload_builder:treasury_adjustment(1300)
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["GnoblarRecruit"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "GnoblarRecruit".."?";
        local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        local probability = math.floor((20 - army_size)/2);
        local dilemma_name = "rhox_araby_jaffar_dilemma_gnoblar_reinforcement";

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end

        if not vfs.exists("script/frontend/mod/mixu_gnob_frontend.lua") then
            probability = 0;
        end
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("GnoblarRecruit action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_gnoblar_reinforcement";
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local cargo_amount = caravan_handle:cargo();


        
        local custom_option = nil;

        --Dilemma option to lose cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo-200)
        end
        
        custom_option = add_cargo;

        rhox_araby_jaffar_attach_battle_to_dilemma(
                    dilemma_name,
                    caravan_handle,
                    nil,
                    false,
                    nil,
                    nil,
                    nil,
                    custom_option);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        

        
        
        payload_builder:treasury_adjustment(2000)
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -200);
        cargo_bundle:set_duration(0);
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
        payload_builder:add_unit(caravan_handle:caravan_force(), "gnob_inf_powder_sniffers", 2, 0);
        payload_builder:text_display("dummy_convoy_trading_dark_elfs_first");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["TombPrinceRecruitment"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local dilemma_name = "rhox_araby_jaffar_dilemma_tmb_reinforcement_battle";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
		local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
		local probability = math.floor((20 - army_size)/2);

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh2_dlc09_tmb_tombking_qb1"
        
		if event_region and event_region:owning_faction() and event_region:owning_faction():culture() == "wh2_dlc09_tmb_tomb_kings" then
			probability = probability+1
		end
		if army_size > 18 then
			probability=0
		end

        local eventname = "TombPrinceRecruitment".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("TombPrinceRecruitment action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_tmb_reinforcement_battle";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "tomb_kings_army");
        
        
        local cargo_amount = caravan_handle:cargo();
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo+200)
        end
		custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_dwarfs_first");
		local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        payload_builder:add_unit(caravan_handle:caravan_force(), "wh2_dlc09_tmb_cha_tomb_prince_0", 1, 0);
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["DKBattle"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_dk_battle";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
		local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()



        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh2_dlc09_tmb_tombking_qb1"
        
		if event_region and event_region:owning_faction() and event_region:owning_faction():name() == "ovn_tmb_dread_king" then
			probability = probability+3
		end

        if not vfs.exists("script/frontend/mod/ovn_dread_king_frontend.lua") then
            probability = 0;
        end

        local eventname = "DKBattle".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("DKBattle action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_dk_battle";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "rhox_araby_dk_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_fight_keep_slave");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
		
		
        payload_builder:faction_pooled_resource_transaction("def_slaves", "wh3_dlc23_chd_consumed", -200, true)
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["arabyArm"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_brt_battle";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh_main_brt_bretonnia_qb1"
        
		if event_region and event_region:owning_faction() and event_region:owning_faction():culture() == "wh_main_brt_bretonnia" then
			probability = probability+3
		end

        local eventname = "arabyArm".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("arabyArm action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_brt_battle";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "rhox_araby_brt_caravan_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        
 
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_hungry_daemons_first");
        payload_builder:faction_pooled_resource_transaction("def_slaves", "battles", 200, true)
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

		local dilemma_bundle2 = cm:create_new_custom_effect_bundle("wh2_main_incident_trade_income_up");
        dilemma_bundle2:set_duration(5);
		payload_builder:text_display("dummy_convoy_localised_elfs_second");
		payload_builder:effect_bundle_to_faction(dilemma_bundle2);
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["ArabyCarpet"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
        local probability = math.floor((20 - army_size)/2);
        local dilemma_name = "rhox_araby_jaffar_dilemma_arb_carpet";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "mixer_arb_araby_dummy"
        
		if event_region and event_region:owning_faction() and event_region:owning_faction():culture() == "ovn_araby" then
			probability = probability+3
		end

        local eventname = "ArabyCarpet".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("ArabyCarpet action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_arb_carpet";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = rhox_araby_generate_attackers(bandit_threat, "rhox_araby_carpet_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo-400)
        end
        
        custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_araby_jaffar_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:treasury_adjustment(2000)
        payload_builder:text_display("dummy_convoy_far_from_home_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

		local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);

        payload_builder:add_unit(caravan_handle:caravan_force(), "ovn_arb_cav_flying_carpets", 2, 0);
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["ArbRope"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local event_region = world_conditions["event_region"];
        local enemy_faction_name = "wh_main_chs_chaos_qb1";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        local enemy_faction = cm:get_faction(enemy_faction_name);
        
        local random_unit ="NONE";
        local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
        
        if caravan_force_unit_list:num_items() > 1 then
            random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items()-1,1)):unit_key();
            
            if rhox_caravan_exception_list[random_unit] then
                random_unit = "NONE";
            end
            out.design("Random unit to be eaten: "..random_unit);
        end;
        
        --Construct targets
        local eventname = "ArbRope".."?"
            ..event_region:name().."*"
            ..random_unit.."*"
            ..tostring(bandit_threat).."*"
            ..enemy_faction_name.."*";
            
        
        --Calculate probability
        local probability = 1;
        local dilemma_name = "rhox_araby_jaffar_dilemma_arb_rope";
        
        if random_unit == "NONE" then
            probability = 0;
        else
            probability = 1;
            
            if rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] > 0 then
                probability = 0;
            end
        end

        

        local caravan_faction = world_conditions["faction"];
        if enemy_faction:name() == caravan_faction:name() then
            probability = 0;
        end;
        
        --probability = 10000
        
        return {probability,eventname}
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        out.design("ArbRope action called")
        local dilemma_name = "rhox_araby_jaffar_dilemma_arb_rope";
        local faction_key = caravan_handle:caravan_force():faction():name();
        local caravan = caravan_handle;
        local cargo_amount = caravan_handle:cargo();


        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        local custom_option = nil;
        local random_unit = decoded_args[2];

        custom_option = nil;


        rhox_araby_jaffar_attach_battle_to_dilemma(
                    dilemma_name,
                    caravan_handle,
                    nil,
                    false,
                    nil,
                    nil,
                    nil,
                    custom_option);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        

        
        
        local experience = cm:create_new_custom_effect_bundle("wh3_dlc23_dilemma_chd_convoy_experience");
        experience:add_effect("wh2_main_effect_captives_unit_xp", "force_to_force_own", 2000);
        experience:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), experience);
        payload_builder:remove_unit(caravan:caravan_force(), random_unit);
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        
        payload_builder:add_unit(caravan_handle:caravan_force(), "ovn_arb_mon_enchanted_rope", 2, 0);
        payload_builder:text_display("dummy_convoy_ambush_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_araby_jaffar_events_cooldown[faction_key][dilemma_name] = rhox_araby_jaffar_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());


    
        
    end,
    false},
};




	















--------------------------------------------------------------------------------------------------
--Functions

function rhox_araby_jaffar_event_handler(context)
	
	--package up some world state
	--generate an event
	local caravan_master = context:caravan_master();
	local faction = context:faction();
	
	if context:from():is_null_interface() or context:to():is_null_interface() then
		return false
	end;
	
	local from_node = context:caravan():position():network():node_for_position(context:from());
	local to_node = context:caravan():position():network():node_for_position(context:to());
	
	local route_segment = context:caravan():position():network():segment_between_nodes(
	from_node, to_node);
	
	if route_segment:is_null_interface() then
		return false
	end
	
	local list_of_regions = route_segment:regions();
	
	local num_regions;
	local event_region;
	--pick a region from the route at random - don't crash the game if empty
	if list_of_regions:is_empty() ~= true then
		num_regions = list_of_regions:num_items()
		event_region = list_of_regions:item_at(cm:random_number(num_regions-1,0)):region();
	else
		out.design("*** No Regions in an Ivory Road segment - Need to fix data in DaVE: campaign_map_route_segments ***")
		out.design("*** Rest of this script will fail ***")
	end;
	
	local bandit_list_of_regions = {};
	
	--override region if one is at war
	for i = 0,num_regions-1 do
		table.insert(bandit_list_of_regions,list_of_regions:item_at(i):region():name())
		
		if list_of_regions:item_at(i):region():owning_faction():at_war_with(context:faction()) then
			event_region=list_of_regions:item_at(i):region()
		end;
	end
	
	
	local bandit_threat = math.floor( cm:model():world():caravans_system():total_banditry_for_regions_by_key(bandit_list_of_regions) / num_regions);	
	local conditions = {
		["caravan"]=context:caravan(),
		["caravan_master"]=caravan_master,
		["list_of_regions"]=list_of_regions,
		["event_region"]=event_region,
		["bandit_threat"]=bandit_threat,
		["faction"]=faction
		};
	
	local contextual_event, is_battle = rhox_araby_jaffar_generate_event(conditions);
	
	out("Rhox Araby: Chosen event is: ".. tostring(contextual_event))
	--if battle then waylay
	
	if is_battle == true and contextual_event ~= nil then
		context:flag_for_waylay(contextual_event);
	elseif is_battle == false and contextual_event ~= nil then
		context:flag_for_waylay(contextual_event);
		--needs to survive a save load at this point
	end;
	
end

function rhox_araby_jaffar_generate_event(conditions)

	--look throught the events table and create a table for weighted roll
	--pick one and return the event name
	
	local weighted_random_list = {};
	local total_probability = 0;
	local i = 0;

	local events = rhox_araby_jaffar_event_tables
	
	--build table for weighted roll
	for key, val in pairs(events) do
		
		i = i + 1;
		
		--Returns the probability of the event 
		local args = val[1](conditions)
		local prob = args[1];
		out("Rhox Araby: Event name is ".. args[2] .. "and probability is ".. args[1])
		total_probability = prob + total_probability;
		--Returns the name and target of the event
		local name_args = args[2];
		
		--Returns if a battle is possible from this event
		--i.e. does it need to waylay
		local is_battle = val[3];
		
		weighted_random_list[i] = {total_probability,name_args,is_battle}

	end
	
	--check all the probabilites until matched
	local no_event_chance = 25;
	local random_int = cm:random_number(total_probability + no_event_chance,1);
	local is_battle = nil;
	local contextual_event_name = nil;

	for j=1,i do
		if weighted_random_list[j][1] >= random_int then
            contextual_event_name = weighted_random_list[j][2];
			is_battle = weighted_random_list[j][3];
			break;
		end
	end
	
	return contextual_event_name, is_battle
end;


function rhox_araby_jaffar_waylaid_caravan_handler(context)
	
	local event_name_formatted = context:context();
	local caravan_handle = context:caravan();
	
	local event_key = caravans:read_out_event_key(event_name_formatted); --use vanilla
	out("Rhox Araby: rhox_araby_jaffar_waylaid_caravan_handler Going to call event: ".. event_key)
	local events = rhox_araby_jaffar_event_tables
	--call the action side of the event
	events[event_key][2](event_name_formatted,caravan_handle);
	
end





function rhox_araby_jaffar_attach_battle_to_dilemma(
			dilemma_name,
			caravan,
			attacking_force,
			is_ambush,
			target_faction,
			enemy_faction,
			target_region,
			custom_option)
	
	--Create the enemy force
	local enemy_force_cqi = nil;
	local x = nil;
	local y = nil;
	
	if attacking_force ~= nil then
		enemy_force_cqi, x, y = caravans:spawn_caravan_battle_force(caravan, attacking_force, target_region, is_ambush, false, enemy_faction) --we don't need new function for these
	end
	
	function ivory_road_dilemma_choice(context)
		local dilemma = context:dilemma();
		local choice = context:choice();
		local faction = context:faction();
		local faction_key = faction:name();
		
		if dilemma == dilemma_name then
			--if battle option is chosen
			core:remove_listener("rhox_araby_jaffar_cth_DilemmaChoiceMadeEvent_"..faction_key);
			
			if choice == 3 then
				return;
			end
			--option 0 is always a fight if there is a enemy force
			local choice_zero_dilemmas = --Trigger the custom option on choice 0, if it's not a choice_zero_dilemma custom option will be called upon choice 1
				{
					rhox_araby_jaffar_dilemma_cathay_caravan = true,
					rhox_araby_jaffar_dilemma_rats_in_a_tunnel = true,
					rhox_araby_jaffar_dilemma_dwarfs = true,
					rhox_araby_jaffar_dilemma_localised_elfs = true,
					rhox_araby_jaffar_dilemma_far_from_home = true,
					rhox_araby_jaffar_dilemma_dwf_thane_reinforcement_battle=true,
                    rhox_araby_jaffar_dilemma_tmb_reinforcement_battle=true,
                    rhox_araby_jaffar_dilemma_arb_rope=true
				};
			local choice_one_dilemmas =  --don't trigger custom option on choice 1
				{
					rhox_araby_jaffar_dilemma_cathay_caravan = true,
					rhox_araby_jaffar_dilemma_rats_in_a_tunnel = true,
					rhox_araby_jaffar_dilemma_the_ambush = true,
					rhox_araby_jaffar_dilemma_dwarfs = true,
					rhox_araby_jaffar_dilemma_localised_elfs = true,
					rhox_araby_jaffar_dilemma_far_from_home = true,
					rhox_araby_jaffar_dilemma_quick_way_down = true,
					rhox_araby_jaffar_dilemma_trading_dark_elfs = true,
					rhox_araby_jaffar_dilemma_emp_mercenaries=true,
					rhox_araby_jaffar_dilemma_vmp_shortcut=true,
                    rhox_araby_jaffar_dilemma_gnoblar_reinforcement=true,
                    rhox_araby_jaffar_dilemma_dwf_thane_reinforcement_battle=true,
                    rhox_araby_jaffar_dilemma_tmb_reinforcement_battle=true
				};	

			local not_move_dilemmas = --do not move caravan
				{
					rhox_araby_jaffar_dilemma_training_camp = true,
					rhox_araby_jaffar_dilemma_way_of_lava = true,
					rhox_araby_jaffar_dilemma_quick_way_down = true
				};	

			local move_dilemma_one = --you only move if you choose the 0 option
				{
					rhox_araby_jaffar_dilemma_the_ambush = true,
                    rhox_araby_jaffar_dilemma_arb_rope = true
				};

			local cargo_dilemmas = --call custom option on choice 0
				{
					rhox_araby_jaffar_dilemma_trading_dark_elfs = true,
					rhox_araby_jaffar_dilemma_emp_mercenaries=true,
                    rhox_araby_jaffar_dilemma_gnoblar_reinforcement=true
				}
			local double_move_dilemmas={
					rhox_araby_jaffar_dilemma_quick_way_down = true,
					rhox_araby_jaffar_dilemma_vmp_shortcut=true
				}

			local only_fight_fifty_percent_dilemma={
				rhox_araby_jaffar_dilemma_skaven_ambush=true,
				rhox_araby_jaffar_dilemma_wooden_lamp=true
			}



				--choice 0 is always a battle if there is an attacking force, if it's choice_zero dilemma, it triggers cutom option
			if choice == 0 and attacking_force ~= nil and only_fight_fifty_percent_dilemma[dilemma_name] and cm:model():random_percent(50) then
				caravans:create_caravan_battle(caravan, enemy_force_cqi, x, y, is_ambush);
			elseif choice == 0 and attacking_force ~= nil and not choice_zero_dilemmas[dilemma_name] then
				caravans:create_caravan_battle(caravan, enemy_force_cqi, x, y, is_ambush);
			elseif attacking_force ~= nil and (choice == 0 and choice_zero_dilemmas[dilemma_name]) then
				caravans:create_caravan_battle(caravan, enemy_force_cqi, x, y, is_ambush);
				custom_option();--call this when the choice is 0, and is part of chooice 0 dilemma
			end	
			--unless it's a move_dilemma_one, you're moving on choice 1, 
			--unless it's a not_move_dilemmas and if there isn't a attacking force, you're moving on choice 0
			if (choice ~= 0 and not move_dilemma_one[dilemma_name]) or (choice == 0 and attacking_force == nil and not not_move_dilemmas[dilemma_name]) then 
				cm:move_caravan(caravan);
			end	
			
			--if it's a cargo dilemma and there isn't attacking force and choice is 0, trigger the custom option
			--if it is not a choice one dilemma and choice is 1, trigger the custom option
			if (choice == 0 and attacking_force == nil and cargo_dilemmas[dilemma_name]) or (custom_option ~= nil and choice == 1 and not choice_one_dilemmas[dilemma_name]) then
				custom_option();
			end
			
			if choice == 0 and attacking_force == nil and double_move_dilemmas[dilemma_name] then
				cm:move_caravan(caravan);
				cm:move_caravan(caravan);
				custom_option();
			end
		end
	end
	
	local faction_key = caravan:caravan_master():character():faction():name()

	core:add_listener(
		"rhox_araby_jaffar_cth_DilemmaChoiceMadeEvent_"..faction_key,
		"DilemmaChoiceMadeEvent",
		true,
		function(context)
			ivory_road_dilemma_choice(context) 
		end,
		true
	);
	
	return enemy_force_cqi
end;

function rhox_araby_jaffar_adjust_end_node_values_for_demand()

	local temp_end_nodes = rhox_araby_jaffar_safe_get_saved_value_ivory_road_demand()
	
	for key, val in pairs(temp_end_nodes) do
		out.design("Key: "..key.." and value: "..val.." for passive demand increase.")
		rhox_araby_jaffar_adjust_end_node_value(key, 1, "add")
	end

end



function rhox_araby_jaffar_initalize_end_node_values()

	--randomise the end node values
	local end_nodes = {
        ["cr_oldworld_region_tuareg_oasis"]				=75-cm:random_number(50,0),
        ["cr_oldworld_region_teshert"]				=75-cm:random_number(50,0),
        ["cr_oldworld_region_bilbali"]				=75-cm:random_number(50,0),
        ["cr_oldworld_region_miragliano"]				=75-cm:random_number(50,0),
        ["cr_oldworld_region_khypris"]	=75-cm:random_number(50,0),
        ["cr_oldworld_region_akendorf"]	=75-cm:random_number(50,0),
    };
 
	
	--save them
	cm:set_saved_value("rhox_araby_jaffar_slave_demand", end_nodes);
	local temp_end_nodes = rhox_araby_jaffar_safe_get_saved_value_ivory_road_demand() 
	
	--apply the effect bundles
	for key, val in pairs(temp_end_nodes) do
		out.design("Key: "..key.." and value: "..val)
		rhox_araby_jaffar_adjust_end_node_value(key, val, "replace")--TODO
	end
end

function rhox_araby_jaffar_safe_get_saved_value_ivory_road_demand()
	
	return cm:get_saved_value("rhox_araby_jaffar_slave_demand");

end		




function rhox_araby_jaffar_adjust_end_node_value(region_name, value, operation, apply_variance)
	
	local region = cm:get_region(region_name);
	if not region then
		script_error("Could not find region " ..region_name.. " for caravan script")
		return false
	end
	local cargo_value_bundle = cm:create_new_custom_effect_bundle("wh3_main_ivory_road_end_node_value");
	cargo_value_bundle:set_duration(0);


	
	if operation == "replace" then
		local temp_end_nodes = rhox_araby_jaffar_safe_get_saved_value_ivory_road_demand()
		cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", value);
		
		temp_end_nodes[region_name]=value;
		cm:set_saved_value("rhox_araby_jaffar_slave_demand", temp_end_nodes);
		
	elseif operation == "add" then
		local temp_end_nodes = rhox_araby_jaffar_safe_get_saved_value_ivory_road_demand()
		local old_value = temp_end_nodes;

		if old_value == nil then
			out.design("*******   Error in ivory road script    *********")
			return 0;
		end
		
		old_value = old_value[region_name]

		local new_value = math.min(old_value+value,200)
		new_value = math.max(old_value+value,-60)
		
		cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", new_value);
		
		temp_end_nodes[region_name]=new_value;
		cm:set_saved_value("rhox_araby_jaffar_slave_demand", temp_end_nodes);
	--elseif operation == "duration" then --not doing duration
	end
	
	if region:has_effect_bundle("wh3_main_ivory_road_end_node_value") then
		cm:remove_effect_bundle_from_region("wh3_main_ivory_road_end_node_value", region_name);
	end;
	
	cm:apply_custom_effect_bundle_to_region(cargo_value_bundle, region);
end



function rhox_araby_generate_attackers(bandit_threat, force_name)

	local force_non_ogre = 
	{
		daemon_incursion = true,
		daemon_incursion_convoy = true,
		cathay_caravan_army = true,
		skaven_shortcut_army = true,
		dwarf_convoy_army = true,
		hungry_chaos_army = true,
		high_elf_army = true,
		vampire_count_army = true,
		tomb_kings_army = true,
		rhox_araby_def_caravan_army=true,
		rhox_araby_cst_caravan_army=true,
		rhox_araby_wef_lamp_army=true,
		rhox_araby_brt_caravan_army=true,
		rhox_araby_chd_caravan_army=true,
        rhox_araby_fimir_army=true,
        rhox_araby_dk_army=true,
        rhox_araby_carpet_army=true,
        rhox_araby_rope_army=true,
	};	
	
	if force_non_ogre[force_name] then

		if cm:turn_number() >= 50 then
			force_name = force_name.."_late"
		end
		
		return random_army_manager:generate_force(force_name, 5, false);
	end

	if bandit_threat < 50 then
			force_name = {"ogre_bandit_low_a","ogre_bandit_low_b"}
			return random_army_manager:generate_force(force_name[cm:random_number(#force_name,1)], 5, false);
		elseif bandit_threat >= 50 and bandit_threat < 70 then
			force_name = {"ogre_bandit_med_a","ogre_bandit_med_b"}
			return random_army_manager:generate_force(force_name[cm:random_number(#force_name,1)], 8, false);
		elseif bandit_threat >= 70 then
			force_name = {"ogre_bandit_high_a","ogre_bandit_high_b"}
			return random_army_manager:generate_force(force_name[cm:random_number(#force_name,1)], 10, false);
	end

end


------------------------------listeners

core:add_listener(
    "rhox_araby_jaffar_caravan_finished",
    "CaravanCompleted",
    function(context)
        return context:faction():culture() == araby_culture
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
            --reward_item_check(faction, region_name, context:caravan_master()) --we don't have any. Why check them?
        end
        --faction has tech that grants extra trade tariffs bonus after every caravan - create scripted bundle
            
        if not region_owner:is_null_interface() then
            local region_owner_key = region_owner:name()
            cm:cai_insert_caravan_diplomatic_event(region_owner_key,faction_key)

            if region_owner:is_human() and faction_key ~= region_owner_key then
                cm:trigger_incident_with_targets(
                    region_owner:command_queue_index(),
                    "wh3_main_cth_caravan_completed_received", --it's actually a slave, but let's just insert it.
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
        cm:callback(function()rhox_araby_jaffar_adjust_end_node_value(region_name, value, "add") end, 5);
                    
    end,
    true
);



core:add_listener(
    "rhox_araby_jaffar_caravan_waylay_query",
    "QueryShouldWaylayCaravan",
    function(context)
        return context:faction():is_human() and context:faction():culture() == araby_culture
    end,
    function(context)
        out("Rhox Araby: In the QueryShouldWaylayCaravan listener")
        local faction_key = context:faction():name()
        if rhox_araby_jaffar_event_handler(context) == false then
            out.design("Caravan not valid for event");
        end
    end,
    true
);


core:add_listener(
    "rhox_araby_jaffar_caravan_waylaid",
    "CaravanWaylaid",
    function(context)
        return context:faction():culture() == araby_culture
    end,
    function(context)
        rhox_araby_jaffar_waylaid_caravan_handler(context);
    end,
    true
);


core:add_listener(
	"rhox_araby_add_inital_force",
	"CaravanRecruited",
	function(context)
		return context:faction():culture() == araby_culture
	end,
	function(context)
		out.design("*** Caravan recruited ***");
		if context:caravan():caravan_force():unit_list():num_items() < 2 then
			local caravan = context:caravan();
			rhox_araby_add_inital_force(caravan);
			cm:set_character_excluded_from_trespassing(context:caravan():caravan_master():character(), true)
		end;
	end,
	true
);

core:add_listener(
	"rhox_araby_jaffar_add_inital_bundles",
	"CaravanSpawned",
	function(context)
		return context:faction():culture() == araby_culture
	end,
	function(context)
		out.design("*** Caravan deployed ***");
		local caravan = context:caravan();
		caravans:set_stance(caravan);--reuse this one
		cm:set_saved_value("caravans_dispatched_" .. context:faction():name(), true);
		cm:set_character_excluded_from_trespassing(context:caravan():caravan_master():character(), true)
	end,
	true
);

core:add_listener(
    "caravans_increase_demand",
    "WorldStartRound",
    true,
    function(context)
        rhox_araby_jaffar_adjust_end_node_values_for_demand();
    end,
    true
);

core:add_listener(
	"rhox_araby_jaffar_caravan_master_heal",
	"CaravanMoved",
	function(context)
		return context:faction():culture() == araby_culture
	end,
	function(context)
		--Heal Lord
		local caravan_force_list = context:caravan_master():character():military_force():unit_list();
		local unit = nil;
		for i=0, caravan_force_list:num_items()-1 do
			unit = caravan_force_list:item_at(i);
			if rhox_caravan_exception_list[unit:unit_key()] then --caravan master or LH
				cm:set_unit_hp_to_unary_of_maximum(unit, 1);
			end
		end
		--Spread out caravans
		local caravan_lookup = cm:char_lookup_str(context:caravan():caravan_force():general_character():command_queue_index())
		local x,y = cm:find_valid_spawn_location_for_character_from_character(
			context:faction():name(),
			caravan_lookup,
			true,
			cm:random_number(15,5)
			)
		cm:teleport_to(caravan_lookup,  x,  y);
	end,
	true
);






-- Logic --
--Setup
cm:add_first_tick_callback_new(
	function()
		rhox_araby_jaffar_initalize_end_node_values()
		if cm:get_local_faction_name(true) == jaffar_faction_key then --ui thing and should be local
            cm:set_script_state("caravan_camera_x",451);
            cm:set_script_state("caravan_camera_y",657);
        end
        
        if cm:get_faction(jaffar_faction_key):is_human() then
            rhox_araby_jaffar_events_cooldown[jaffar_faction_key] = {
                ["rhox_araby_jaffar_dilemma_cathay_caravan"] = 0,
                ["rhox_araby_jaffar_dilemma_dwarfs"] = 0,
                ["rhox_araby_jaffar_dilemma_far_from_home"] = 0,
                ["rhox_araby_jaffar_dilemma_fresh_battlefield"] = 0,
                ["rhox_araby_jaffar_dilemma_hungry_daemons"] = 0,
                ["rhox_araby_jaffar_dilemma_localised_elfs"] = 0,
                ["rhox_araby_jaffar_dilemma_offence_or_defence"] = 0,
                ["rhox_araby_jaffar_dilemma_ogre_mercenaries"] = 0,
                ["rhox_araby_jaffar_dilemma_power_overwhelming"] = 0,
                ["rhox_araby_jaffar_dilemma_quick_way_down"] = 0,
                ["rhox_araby_jaffar_dilemma_rats_in_a_tunnel"] = 0,
                ["rhox_araby_jaffar_dilemma_redeadify"] = 0,
                ["rhox_araby_jaffar_dilemma_the_ambush"] = 0,
                ["rhox_araby_jaffar_dilemma_the_guide"] = 0,
                ["rhox_araby_jaffar_dilemma_trading_dark_elfs"] = 0,
                ["rhox_araby_jaffar_dilemma_training_camp"] = 0,
                ["rhox_araby_jaffar_dilemma_way_of_lava"] = 0,
                ["rhox_araby_jaffar_dilemma_tk_crypt"]=0,
                ["rhox_araby_jaffar_dilemma_skaven_ambush"]=0,
                ["rhox_araby_jaffar_dilemma_def_black_ark_reinforcement_battle"]=0,
                ["rhox_araby_jaffar_dilemma_cst_treasure_mp"]=0,
                ["rhox_araby_jaffar_dilemma_hef_tax_reinforcement_battle"]=0,
                ["rhox_araby_jaffar_dilemma_wooden_lamp"]=0,
                ["rhox_araby_jaffar_dilemma_brt_errant"]=0,
                ["rhox_araby_jaffar_dilemma_hef_tribute"]=0,
                ["rhox_araby_jaffar_dilemma_def_corsair"]=0,
                ["rhox_araby_jaffar_dilemma_chd_cannon_reinforcement_battle"]=0,
                ["rhox_araby_jaffar_dilemma_dwf_thane_reinforcement_battle"]=0,
                ["rhox_araby_jaffar_dilemma_vmp_shortcut"]=0,
                ["rhox_araby_jaffar_dilemma_fimir_battle"]=0,
                ["rhox_araby_jaffar_dilemma_teb_reinforcement"]=0,
                ["rhox_araby_jaffar_dilemma_gnoblar_reinforcement"]=0,
                ["rhox_araby_jaffar_dilemma_tmb_reinforcement_battle"]=0,
                ["rhox_araby_jaffar_dilemma_dk_battle"]=0,
                ["rhox_araby_jaffar_dilemma_brt_battle"]=0,
                ["rhox_araby_jaffar_dilemma_arb_carpet"]=0,
                ["rhox_araby_jaffar_dilemma_arb_rope"]=0
            }
		end
		

		local all_factions = cm:model():world():faction_list();
		local faction = nil;
		for i=0, all_factions:num_items()-1 do
			faction = all_factions:item_at(i)
			if not faction:is_human() and faction:culture() == araby_culture then
				cm:apply_effect_bundle("wh3_main_caravan_AI_threat_reduction", faction:name(),0)
			end
		end
	end
);


core:add_listener(
	"araby_event_update",
	"WorldStartRound",
	true,
	function(context)
		for _, faction_cooldowns in pairs(rhox_araby_jaffar_events_cooldown) do
			for dilemma_key, cooldown in pairs(faction_cooldowns) do
				if cooldown > 0 then
					faction_cooldowns[dilemma_key] = cooldown - 1
				end
			end
		end
	end,
	true
);



--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_araby_jaffar_events_cooldown", rhox_araby_jaffar_events_cooldown, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			rhox_araby_jaffar_events_cooldown = cm:load_named_value("rhox_araby_jaffar_events_cooldown", rhox_araby_jaffar_events_cooldown, context);
		end;
	end
);