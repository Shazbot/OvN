
local morghan_coords = nil;


local function scan_for_morghan_and_summon(alliance_armies, enemy_armies)
	for j=1, alliance_armies:count() do
		local army = alliance_armies:item(j)
		local player_units = army:units();

		for i = 1, player_units:count() do
			local current_unit = player_units:item(i);
			if current_unit then
				local type_key = current_unit:type();			

				if (type_key == "morgan_bernhardt" or type_key == "morgan_bernhardt_mount") then
					morghan_coords = current_unit:position();
					
					
					army:use_special_ability("rhox_grudge_summon_gotrek", morghan_coords, d_to_r(0))
                    army:use_special_ability("rhox_grudge_summon_felix", morghan_coords, d_to_r(0))
				end
			end
		end
	end
end




local function rhox_grudge_summon_gotrek_and_felix()
	local alliance_armies = bm:alliances():item(bm:get_player_alliance_num()):armies()
	local enemy_armies = bm:alliances():item(bm:get_non_player_alliance_num()):armies()
    
    scan_for_morghan_and_summon(alliance_armies, enemy_armies)
    
end




local has_gf_ability = true

local function rhox_grudge_check_and_remove_ui()
    local abilities_need_hiding={
        "button_holder_rhox_grudge_summon_gotrek",
        "button_holder_rhox_grudge_summon_felix",
    }

    local army_ability_parent = find_uicomponent(core:get_ui_root(), "hud_battle", "army_ability_container", "army_ability_parent")
    if not army_ability_parent then
        return
    end
    for i=1,#abilities_need_hiding do
        local ability = find_uicomponent(army_ability_parent, abilities_need_hiding[i])
        if ability then
            ability:SetVisible(false)
        else
            has_gf_ability = false
        end
    end
end


bm:register_phase_change_callback(
	"Deployment", 
	function()
		if bm:player_army_is_faction("ovn_emp_grudgebringers") or bm:player_army_is_faction("ovn_emp_grudgebringers_CB") then
			rhox_grudge_check_and_remove_ui()
		end
	end
);



bm:register_phase_change_callback(
	"Deployed", 
	function()
        local random_number = bm:random_number(1, 100)
        out("Rhox Grudge: Random number is ".. random_number)
        if (bm:player_army_is_faction("ovn_emp_grudgebringers") or bm:player_army_is_faction("ovn_emp_grudgebringers_CB")) and
        has_gf_ability == true and random_number <= 30 then
			rhox_grudge_summon_gotrek_and_felix()
		end
		
	end
);