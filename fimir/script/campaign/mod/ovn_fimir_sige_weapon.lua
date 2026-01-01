
-- because rebels and rogue armies do not get siege equipment via the cultural trait system, we have to add them to the force manually
-- to only suitable way to determine which siege equipment to apply to which force is to perform a search on the unit key :(
local function ovn_fimir_determine_siege_equipment_bundle(cqi, unit_key) --yeah vanilla function will still spit out script errors
    if string.find(unit_key, "fim_") then
        cm:apply_effect_bundle_to_force("wh_main_bundle_force_siege_equipment_chs", cqi, 0);
    end;
end;



core:add_listener(
    "ovn_albion_rebel_army_monitor",
    "FactionTurnStart",
    function(context)
        local faction = context:faction();
            
        return faction:is_rebel() or faction:culture() == "wh2_main_rogue";
    end,
    function(context)
        local char_list = context:faction():character_list();
        for i = 0, char_list:num_items() - 1 do
            current_char = char_list:item_at(i);
            if current_char:has_military_force() then
                local cqi = current_char:military_force():command_queue_index();
                local unit_key = current_char:military_force():unit_list():item_at(0):unit_key();
                ovn_fimir_determine_siege_equipment_bundle(cqi, unit_key)
            end;
        end;
    end,
    true
);
	
	
	
	