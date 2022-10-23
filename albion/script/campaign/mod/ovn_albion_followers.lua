local albion_followers = {
	{
		["follower"] = "albion_hunting_dog",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and cm:region_has_chain_or_superchain(character:region(), "albion_hunters");
			end,
		["chance"] = 12
	},
	{
		["follower"] = "albion_lone_huntress",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and cm:region_has_chain_or_superchain(character:region(), "albion_hunters");
			end,
		["chance"] = 12
	},
	{
		["follower"] = "albion_woad_raider",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 15
	},
	{
		["follower"] = "albion_tame_raven",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function(context)
				return true;
			end,
		["chance"] = 20
	},
	{
		["follower"] = "albion_druid_advisor",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and cm:region_has_chain_or_superchain(character:region(), "albion_hunters");
			end,
		["chance"] = 12
	},
	{
		["follower"] = "albion_chief",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 15
	},
	{
		["follower"] = "albion_old_warrior",
		["event"] = "CharacterRazedSettlement",
		["condition"] =
			function(context)
				return true;
			end,
		["chance"] = 20
	},
	{
		["follower"] = "albion_scavanger",
		["event"] = "CharacterLootedSettlement",
		["condition"] =
			function(context)
				return true;
			end,
		["chance"] = 20
	},
	{
		["follower"] = "albion_woman",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1;
			end,
		["chance"] = 12
	},
	{
		["follower"] = "fenbeast_follower",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:character_type("wizard");
			end,
		["chance"] = 12
	},
	{
		["follower"] = "hearthguard_follower",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:character_type("champion");
			end,
		["chance"] = 12
	},
	{
		["follower"] = "druid_neophyte",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:character_subtype("albion_truthsayer_beast")
					or character:character_subtype("albion_truthsayer_light")
					or character:character_subtype("albion_truthsayer_life")
					or character:character_subtype("albion_truthsayer_truth")
			end,
		["chance"] = 12
	},
	{
		["follower"] = "albion_hardened_warrior",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 15
	},
}

local function load_albion_followers()
	for i = 1, #albion_followers do
		core:add_listener(
			albion_followers[i].follower,
			albion_followers[i].event,
			albion_followers[i].condition,
			function(context)
				local character = context:character();
				local chance = albion_followers[i].chance;
				
				if not character:character_type("colonel") and not character:character_subtype("wh_dlc07_brt_green_knight") and not character:character_subtype("wh2_dlc10_hef_shadow_walker") and cm:random_number(100) <= chance then
					cm:force_add_ancillary(context:character(), albion_followers[i].follower, false, false);
				end;
			end,
			true
		);
	end;
end;

cm:add_first_tick_callback(
	function()
		cm:callback(
			function()
				load_albion_followers()
			end,
			3
		)
	end
)
