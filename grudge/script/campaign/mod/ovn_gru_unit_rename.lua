

local function rename_gru_unit(unit)
    valid_gru_units =  {
        ["wh_main_emp_inf_halberdiers_ovn_gru"] = true,
        ["wh_main_emp_inf_swordsmen_ovn_gru"] = true,
        ["wh_main_emp_inf_spearmen_0_ovn_gru"] = true,
        ["wh_main_emp_inf_crossbowmen_ovn_gru"] = true,
        ["wh2_dlc13_emp_inf_archers_0_ovn_gru"] = true,
        ["wh3_main_ogr_inf_ogres_0_ovn_gru"] = true,
        ["wh_main_emp_inf_greatswords_ovn_gru"] = true,
        ["wh_dlc04_emp_inf_free_company_militia_0_ovn_gru"] = true,
        ["wh_main_emp_cav_empire_knights_ovn_gru"] = true,
        ["wh_main_emp_cav_pistoliers_1_ovn_gru"] = true,
        ["wh_dlc04_emp_inf_flagellants_0_ovn_gru"] = true,
        ["wh_main_dwf_inf_dwarf_warrior_0_ovn_gru"] = true,
        ["wh_main_dwf_inf_slayers_ovn_gru"] = true,
        ["wh3_main_ogr_inf_maneaters_0_ovn_gru"] = true,
        ["wh3_main_ogr_inf_maneaters_1_ovn_gru"] = true,
        ["wh3_main_ogr_inf_maneaters_2_ovn_gru"] = true,
        ["wh_main_dwf_inf_dwarf_warrior_1_ovn_gru"] = true
    }
    
    valid_gru_units_gunpowder =  {
        ["wh_main_emp_inf_handgunners_ovn_gru"] = true,
        ["wh3_main_ogr_inf_maneaters_3_ovn_gru"] = true,
        ["wh_main_emp_art_mortar_ovn_gru"] = true,
        ["wh_main_emp_art_great_cannon_ovn_gru"] = true
    }
    
    gru_units_default_name ={
        ["wh_main_emp_inf_halberdiers_ovn_gru"] = "land_units_onscreen_name_wh_main_emp_inf_halberdiers",
        ["wh_main_emp_inf_swordsmen_ovn_gru"] = "land_units_onscreen_name_wh_main_emp_inf_swordsmen",
        ["wh_main_emp_inf_spearmen_0_ovn_gru"] = "land_units_onscreen_name_wh_main_emp_inf_spearmen_0",
        ["wh_main_emp_inf_crossbowmen_ovn_gru"] = "land_units_onscreen_name_wh_main_emp_inf_crossbowmen",
        ["wh2_dlc13_emp_inf_archers_0_ovn_gru"] = "default_name_wh2_dlc13_emp_inf_archers_0_ovn_gru",
        ["wh_main_emp_inf_handgunners_ovn_gru"] = "land_units_onscreen_name_wh_main_emp_inf_handgunners",
        ["wh3_main_ogr_inf_ogres_0_ovn_gru"] = "default_name_wh3_main_ogr_inf_ogres_0_ovn_gru",
        ["wh_main_emp_inf_greatswords_ovn_gru"] = "land_units_onscreen_name_wh_main_emp_inf_greatswords",
        ["wh_dlc04_emp_inf_free_company_militia_0_ovn_gru"] = "default_name_wh_dlc04_emp_inf_free_company_militia_0_ovn_gru",
        ["wh_main_emp_cav_empire_knights_ovn_gru"] = "default_name_wh_main_emp_cav_empire_knights_ovn_gru",
        ["wh_main_emp_cav_pistoliers_1_ovn_gru"] = "default_name_wh_main_emp_cav_pistoliers_1_ovn_gru",
        ["wh_dlc04_emp_inf_flagellants_0_ovn_gru"] = "land_units_onscreen_name_wh_dlc04_emp_inf_flagellants_0",
        ["wh_main_dwf_inf_dwarf_warrior_0_ovn_gru"] = "default_name_wh_main_dwf_inf_dwarf_warrior_0_ovn_gru",
        ["wh_main_dwf_inf_slayers_ovn_gru"] = "land_units_onscreen_name_wh_main_dwf_inf_slayers",
        ["wh3_main_ogr_inf_maneaters_0_ovn_gru"] = "default_name_wh3_main_ogr_inf_maneaters_0_ovn_gru",
        ["wh3_main_ogr_inf_maneaters_1_ovn_gru"] = "default_name_wh3_main_ogr_inf_maneaters_1_ovn_gru",
        ["wh3_main_ogr_inf_maneaters_2_ovn_gru"] = "default_name_wh3_main_ogr_inf_maneaters_2_ovn_gru",
        ["wh3_main_ogr_inf_maneaters_3_ovn_gru"] = "default_name_wh3_main_ogr_inf_maneaters_3_ovn_gru",
        ["wh_main_dwf_inf_dwarf_warrior_1_ovn_gru"] = "default_name_wh_main_dwf_inf_dwarf_warrior_1_ovn_gru",
        ["wh_main_emp_art_mortar_ovn_gru"] = "land_units_onscreen_name_wh_main_emp_art_mortar",
        ["wh_main_emp_art_great_cannon_ovn_gru"] = "land_units_onscreen_name_wh_main_dwf_art_cannon"
    }
    
    local main_unit_key = unit:unit_key()
    if not gru_units_default_name[main_unit_key] then
        out("Rhox Grudge: There is no default name for the " ..main_unit_key .. "Escaping the function")
        return
    end
    
    local ovn_gru_first_name_prefix = "ovn_gru_unique_first_name_"
    local ovn_gru_unique_first_name = 112
    
    local ovn_gru_last_name_prefix ="ovn_gru_unique_last_name_"
    local ovn_gru_unique_last_name = 183
    local ovn_gru_last_name_gun_prefix ="ovn_gru_unique_last_name_gun_"
    local ovn_gru_unique_last_name_gun = 24
    
    local random_number_fn = cm:random_number(ovn_gru_unique_first_name, 1)
    local ovn_gru_chosen_first_name = common.get_localised_string(ovn_gru_first_name_prefix .. tostring(random_number_fn))
    
    local random_number_ln = cm:random_number(ovn_gru_unique_last_name, 1)
    local ovn_gru_chosen_last_name = common.get_localised_string(ovn_gru_last_name_prefix .. tostring(random_number_ln))
    
    local random_number_gun_ln = cm:random_number(ovn_gru_unique_last_name_gun, 1)
    local ovn_gru_chosen_last_name_gun = common.get_localised_string(ovn_gru_last_name_gun_prefix .. tostring(random_number_gun_ln))

    --out("Rhox Grudge: Getting random names. Check".. ovn_gru_chosen_first_name .. "/" .. ovn_gru_chosen_last_name .. "/" .. ovn_gru_chosen_last_name_gun)
    
    
    
    
    --out("Rhox Grudge: Unit key " ..main_unit_key)
    
    
    
    local land_unit_name = common.get_localised_string(gru_units_default_name[main_unit_key])
    
    
    --out("Rhox Grudge: Getting default names. Check: " .. land_unit_name)
    
    if valid_gru_units_gunpowder[main_unit_key] and cm:random_number(2, 1) == 2 then
        cm:change_custom_unit_name(unit, ovn_gru_chosen_first_name.." "..ovn_gru_chosen_last_name_gun.." "..land_unit_name)
    elseif valid_gru_units[main_unit_key] or valid_gru_units_gunpowder[main_unit_key] then
        cm:change_custom_unit_name(unit, ovn_gru_chosen_first_name.." "..ovn_gru_chosen_last_name.." "..land_unit_name)
    end
    --out("Rhox Grudge: Changing name complete") 
end

    
core:add_listener(
    "ovn_grudge_unit_rename_on_unit_trained",
    "UnitTrained",
    function(context)
        return context:unit():faction():name() == "ovn_emp_grudgebringers"
    end,
    function(context)
        ---@type CA_UNIT
        local unit = context:unit()
        if unit:has_force_commander() then
            local fc = unit:force_commander()
            if not fc or fc:is_null_interface() then return end
            rename_gru_unit(unit)
    
        end
    end,
    true
)