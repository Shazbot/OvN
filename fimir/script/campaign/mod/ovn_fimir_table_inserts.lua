book_of_grudges.grudge_culture_modifiers["ovn_fimir"]="medium"


book_of_grudges.grudge_culture_modifiers["ovn_fimir"]="medium"
grudge_cycle.factors.culture_actions["ovn_fimir"]="moc_actions"
grudge_cycle.cultural_modifiers["ovn_fimir"] = grudge_modifiers.high
grudge_cycle.cultures.moc_cultures["ovn_fimir"]=true

-- FIMIR TRAIT EXCLUSIONS
table.insert(campaign_traits.trait_exclusions.culture.wh2_main_trait_corrupted_chaos,"ovn_fimir");
table.insert(campaign_traits.trait_exclusions.culture.wh2_main_trait_corrupted_skaven,"ovn_fimir");
table.insert(campaign_traits.trait_exclusions.culture.wh3_main_trait_corrupted_khorne,"ovn_fimir");
table.insert(campaign_traits.trait_exclusions.culture.wh3_main_trait_corrupted_nurgle,"ovn_fimir");
table.insert(campaign_traits.trait_exclusions.culture.wh3_main_trait_corrupted_slaanesh,"ovn_fimir");
table.insert(campaign_traits.trait_exclusions.culture.wh3_main_trait_corrupted_tzeentch,"ovn_fimir");
table.insert(campaign_traits.trait_exclusions.culture.wh2_main_trait_pacifist,"ovn_fimir");
table.insert(campaign_traits.trait_exclusions.culture.wh2_main_trait_defeats_against_chaos,"ovn_fimir");
table.insert(campaign_traits.trait_exclusions.culture.wh2_main_trait_defeats_against_daemons,"ovn_fimir");
table.insert(campaign_traits.trait_exclusions.culture.wh2_main_trait_agent_actions_against_chaos,"ovn_fimir");
table.insert(campaign_traits.trait_exclusions.culture.wh2_main_trait_agent_actions_against_daemons,"ovn_fimir");
table.insert(campaign_traits.trait_exclusions.culture.wh2_main_trait_wins_against_chaos,"ovn_fimir");
table.insert(campaign_traits.trait_exclusions.culture.wh2_main_trait_wins_against_daemons,"ovn_fimir");

---------mistwalker
if (type(lair_action_effects) == "table") then
    table.insert(lair_action_effects, "wh2_dlc15_hef_dungeon_mistwalker_upgrade_fimir")
end

if (type(lair_culture_to_effects) == "table") then
    lair_culture_to_effects["ovn_fimir"]= "wh2_dlc15_hef_eltharion_dungeon_reward_fimir"
end

--------Nemesis Crown
nemesis_crown.subculture_bundle_suffixes["ovn_sc_fim_fimir"]="_fim"

cm:add_first_tick_callback(
	function()
		campaign_traits.legendary_lord_defeated_traits["fim_meargh_skattach"] ="fim_skattach_defeated_trait"
		campaign_traits.legendary_lord_defeated_traits["fim_daemon_octopus_kroll"] ="fim_kroll_defeated_trait"
	end
)


