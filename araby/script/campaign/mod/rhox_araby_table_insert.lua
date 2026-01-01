infamy.faction_override["ovn_arb_golden_fleet"] = {}
infamy.faction_override["ovn_arb_golden_fleet"]["shanty_incident"] = "rhox_araby_incident_cst_sea_shanty_gained_"
infamy.faction_override["ovn_arb_golden_fleet"]["effect_bundle_sea_shanty_complete"] = "effect_bundle{bundle_key rhox_araby_bundle_sea_shanty_complete;turns 0;}"


grudge_cycle.factors.culture_actions["ovn_araby"]="araby_actions"
grudge_cycle.cultures["araby"]="ovn_araby"


---------mistwalker
if (type(lair_action_effects) == "table") then
    table.insert(lair_action_effects, "wh2_dlc15_hef_dungeon_mistwalker_upgrade_araby")
end

if (type(lair_culture_to_effects) == "table") then
    lair_culture_to_effects["ovn_araby"]= "wh2_dlc15_hef_eltharion_dungeon_reward_araby"
end

--------Nemesis Crown
nemesis_crown.subculture_bundle_suffixes["ovn_sc_arb_araby"]="_arb"

cm:add_first_tick_callback(
	function()
		campaign_traits.legendary_lord_defeated_traits["arb_sultan_jaffar"] ="ovn_araby_jaffar_defeated"
		campaign_traits.legendary_lord_defeated_traits["arb_golden_magus"] ="ovn_araby_gm_defeated"
		campaign_traits.legendary_lord_defeated_traits["arb_fatandira"] ="ovn_araby_fatandira_defeated"
	end
)




