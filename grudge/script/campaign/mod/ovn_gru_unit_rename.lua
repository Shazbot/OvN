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
        ["wh_main_emp_inf_halberdiers_ovn_gru"] = "Halberdiers",
        ["wh_main_emp_inf_swordsmen_ovn_gru"] = "Swordsmen",
        ["wh_main_emp_inf_spearmen_0_ovn_gru"] = "Spearmen",
        ["wh_main_emp_inf_crossbowmen_ovn_gru"] = "Crossbowmen",
        ["wh2_dlc13_emp_inf_archers_0_ovn_gru"] = "Bowmen",
        ["wh_main_emp_inf_handgunners_ovn_gru"] = "Handgunners",
        ["wh3_main_ogr_inf_ogres_0_ovn_gru"] = "Ogres",
        ["wh_main_emp_inf_greatswords_ovn_gru"] = "Greatswords",
        ["wh_dlc04_emp_inf_free_company_militia_0_ovn_gru"] = "Militia",
        ["wh_main_emp_cav_empire_knights_ovn_gru"] = "Knights",
        ["wh_main_emp_cav_pistoliers_1_ovn_gru"] = "Pistoliers",
        ["wh_dlc04_emp_inf_flagellants_0_ovn_gru"] = "Flagellants",
        ["wh_main_dwf_inf_dwarf_warrior_0_ovn_gru"] = "Warriors",
        ["wh_main_dwf_inf_slayers_ovn_gru"] = "Slayers",
        ["wh3_main_ogr_inf_maneaters_0_ovn_gru"] = "Ogres",
        ["wh3_main_ogr_inf_maneaters_1_ovn_gru"] = "Ogres (Ironfists)",
        ["wh3_main_ogr_inf_maneaters_2_ovn_gru"] = "Ogres (Great Weapons)",
        ["wh3_main_ogr_inf_maneaters_3_ovn_gru"] = "Ogres (Ogre Pistol)",
        ["wh_main_dwf_inf_dwarf_warrior_1_ovn_gru"] = "Warriors (Great Weapons)",
        ["wh_main_emp_art_mortar_ovn_gru"] = "Mortars",
        ["wh_main_emp_art_great_cannon_ovn_gru"] = "Cannons"
    }
    local ovn_gru_unique_first_name = {
        "Iron",
        "Blood",
        "Great",
        "Golden",
        "Bronze",
        "Silver",
        "Night",
        "Bright",
        "Dark",
        "Holy",
        "Rogue",
        "Phantom",
        "Piercing",
        "Valiant",
        "Brave",
        "Silent",
        "Eternal",
        "Unforgiving",
        "Relentless",
        "Desert",
        "Forest",
        "Snow",
        "Mountain",
        "Last",
        "Seeping",
        "Lost",
        "Swamp",
        "Mad",
        "Grim",
        "Howling",
        "Cursed",
        "Barren",
        "Old",
        "Count's",
        "Countess",
        "Grizzled",
        "Desolate",
        "Twisted",
        "Shattered",
        "Nuln",
        "Altdorf",
        "Akendorf",
        "Imperial",
        "Feasting",
        "Broken",
        "Fractured",
        "Forgotten", 
        "Immortal", 
        "Cloaked", 
        "Screaming", 
        "Blighted",
        "Tilean",
        "Kislevite",
        "Estalian",
        "Stubborn", 
        "Crystal",
        "Kislev",
        "Praag",
        "Luccini",
        "Miragliano",
        "Sartosa",
        "Tobaro",
        "Remas",
        "Magritta",
        "Bilbali",
        "Verezzo",
        "Crimson",
        "Pavona",
        "Unbreakable",
        "Scurvy" -- INDEX 70
    }
    
    local ovn_gru_unique_last_name = {
        "Order",
        "Sunset",
        "Dusk",
        "Dawn",
        "Wolf",
        "Night",
        "Moon",
        "Sun",
        "Thunder",
        "Guard",
        "Skull",
        "Warhammer",
        "Angel",
        "Heart",
        "Dog",
        "Blade",
        "Storm",
        "Rat",
        "Snake",
        "Sky",
        "Cloud",
        "Eye",
        "Pig",
        "Dawn", 
        "Grudge", 
        "Fury", 
        "Rage", 
        "Scorpion", 
        "Lightning", 
        "Vanguard", 
        "Guardian", 
        "Mauler", 
        "Spirit", 
        "Wrath", 
        "Spectre", 
        "Dagger", 
        "Mirage", 
        "Hunter", 
        "Boar", 
        "Stag", 
        "Wasp", 
        "Hornet", 
        "Dragon", 
        "Griffon", 
        "Bear", 
        "Harpy", 
        "Horn", 
        "Panther", 
        "Jaguar", 
        "Mermaid", 
        "Crescent", 
        "Crow", 
        "Pegasus", 
        "Phoenix", 
        "Toad", 
        "Raven", 
        "Cock", 
        "Death", 
        "Shield", 
        "Stand", 
        "Avengers", 
        "Leopards",
        "Skeleton",
        "Honour",
        "Fortune",
        "Fang",
        "Pass",
        "Peak",
        "Fort",
        "Spire",
        "Tower",
        "Fire",
        "Rain",
        "Gust",
        "Messenger",
        "Hold",
        "Keep",
        "Nomad", 
        "Mercenary",
        "Wanderer", 
        "Titan",
        "Pirate",
        "Warband",
        "Rebel",
        "Brigand",
        "Brotherhood",
        "Watcher" ,
        "Vendetta" ,
        "Champion",
        "Brawler",
        "Legion",
        "Fox",
        "Hand",
        "Desparado",
        "Mirror",
        "Martyr",
        "Butcher" ,
        "Cutthroat",
        "Skull-Splitter",
        "Executioner",
        "Protector", -- INDEX 100
        "Outlaw"
    }
    
    local ovn_gru_unique_last_name_gun = {
        "Belcher",
        "Spitter",
        "Thunderer",
        "Juggernaut",
        "Smoke",
        "Titan-Slayer",
        "Haze",
        "Fuse",
        "Black-Powder",
        "Boomer", -- INDEX 10
        "Sure-shot",
        "Never-Miss",
        "Splutterer",
        "Line"
    }
    
    local random_number_fn = cm:random_number(#ovn_gru_unique_first_name, 1)
    local ovn_gru_chosen_first_name = ovn_gru_unique_first_name[random_number_fn]
    
    local random_number_ln = cm:random_number(#ovn_gru_unique_last_name, 1)
    local ovn_gru_chosen_last_name = ovn_gru_unique_last_name[random_number_ln]
    
    local main_unit_key = unit:unit_key()
    local land_unit_name = gru_units_default_name[main_unit_key]
    
        if valid_gru_units_gunpowder[main_unit_key] and cm:random_number(2, 1) == 2 then
            cm:change_custom_unit_name(unit, ovn_gru_chosen_first_name.." "..ovn_gru_unique_last_name_gun.." "..land_unit_name)
        elseif valid_gru_units[main_unit_key] or valid_gru_units_gunpowder[main_unit_key] then
            cm:change_custom_unit_name(unit, ovn_gru_chosen_first_name.." "..ovn_gru_chosen_last_name.." "..land_unit_name)
        end
    
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