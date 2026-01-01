RHOX_GRUDGEBRINGER_ITEM_LIST={--maybe somebody want to put something in the list
    "wh_main_anc_armour_helm_of_discord",
    "wh_main_anc_armour_armour_of_destiny",
    "wh_main_anc_weapon_tormentor_sword",
    "wh_main_anc_talisman_talisman_of_preservation",
    "wh_main_anc_enchanted_item_healing_potion",
    "wh_main_anc_weapon_obsidian_blade",
    "wh_main_anc_weapon_runefang",
    "wh_main_anc_talisman_seed_of_rebirth",
    "wh_main_anc_enchanted_item_van_horstmanns_speculum",
    "wh2_dlc09_anc_armour_armour_armour_of_dawn",
    "wh2_dlc10_anc_enchanted_item_extinguished_phoenix_pinion",
    "wh_main_anc_weapon_giant_blade",
    "wh_main_anc_weapon_sword_of_bloodshed",
    "wh_main_anc_talisman_the_white_cloak_of_ulric",
    "wh2_dlc09_anc_enchanted_item_ouroboros",
    "wh2_dlc17_anc_armour_cloak_of_unreality",
    "wh2_dlc17_anc_armour_mutated_ghorgon_hide",
    "wh_main_anc_armour_armour_of_destiny",
    "wh_main_anc_armour_tricksters_helm",
    "wh_main_anc_enchanted_item_the_other_tricksters_shard",
    "wh_main_anc_magic_standard_rangers_standard",
    "wh_main_anc_magic_standard_wailing_banner",
}


function rhox_grudgebringer_get_random_item()--made this because vanilla is broken
    return RHOX_GRUDGEBRINGER_ITEM_LIST[cm:random_number(#RHOX_GRUDGEBRINGER_ITEM_LIST)]
end