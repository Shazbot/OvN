OVN_ARABY_SLAVE_FOLLOWERS = OVN_ARABY_SLAVE_FOLLOWERS or {}
local mod = OVN_ARABY_SLAVE_FOLLOWERS

-- -@return CA_UIC
local function find_ui_component_str(starting_comp, str)
	local has_starting_comp = str ~= nil
	if not has_starting_comp then
		str = starting_comp
	end
	local fields = {}
	local pattern = string.format("([^%s]+)", " > ")
	string.gsub(str, pattern, function(c)
		if c ~= "root" then
			fields[#fields+1] = c
		end
	end)
	return find_uicomponent(has_starting_comp and starting_comp or core:get_ui_root(), unpack(fields))
end

math.huge = 2^1024 -- json needs this and it's not defined in CA Lua environment
local json = require("ovn/json")

local araby_factions = {
	"ovn_arb_sultanate_of_all_araby",
	"ovn_arb_aswad_scythans",
	"ovn_arb_golden_fleet",
	"ovn_arb_sultanate_of_el_kalabad"
}

local araby_slaver_factions = {
	"ovn_arb_sultanate_of_all_araby",
	"ovn_arb_golden_fleet",
	"ovn_arb_sultanate_of_el_kalabad"
}

local cats = {
	"ovn_arb_crafting_lzd",
	"ovn_arb_crafting_dwarfs",
	"ovn_arb_crafting_def",
	"ovn_arb_crafting_hef",
	"ovn_arb_crafting_men",
	"ovn_arb_crafting_undead",
	"ovn_arb_crafting_chaos",
	"ovn_arb_crafting_skv",
	"ovn_arb_crafting_nor",
	"ovn_arb_crafting_we",
	"ovn_arb_crafting_grn",
	"ovn_arb_crafting_bst",
	"ovn_arb_crafting_tmb",
    "ovn_arb_crafting_ogr",
}

local all_cats = {
	"ovn_arb_crafting_lzd",
	"ovn_arb_crafting_dwarfs",
	"ovn_arb_crafting_def",
	"ovn_arb_crafting_hef",
	"ovn_arb_crafting_men",
	"ovn_arb_crafting_undead",
	"ovn_arb_crafting_chaos",
	"ovn_arb_crafting_skv",
	"ovn_arb_crafting_nor",
	"ovn_arb_crafting_we",
	"ovn_arb_crafting_grn",
	"ovn_arb_crafting_bst",
	"ovn_arb_crafting_tmb",
    "ovn_arb_crafting_ogr",
	"ovn_arb_crafting_weapons",
	"ovn_arb_crafting_armor",
	"ovn_arb_crafting_enchanted_items",
	"ovn_arb_crafting_talismans",
	"ovn_arb_crafting_arcane_items",
}

local ritual_key_to_anci = {
    ovn_arb_crafting_followers_1 = "ovn_araby_anc_follower_skv_trainee_assassin",
    ovn_arb_crafting_followers_2 = "ovn_araby_anc_follower_skv_slave_skv",
    ovn_arb_crafting_followers_3 = "ovn_araby_anc_follower_skv_slave_human",
    ovn_arb_crafting_followers_4 = "ovn_araby_anc_follower_skv_scribe",
    ovn_arb_crafting_followers_5 = "ovn_araby_anc_follower_skv_scavenger_1",
    ovn_arb_crafting_followers_6 = "ovn_araby_anc_follower_skv_sacrificial_victim_lizardman",
    ovn_arb_crafting_followers_7 = "ovn_araby_anc_follower_skv_sacrificial_victim_dwarf",
    ovn_arb_crafting_followers_8 = "ovn_araby_anc_follower_skv_saboteur",
    ovn_arb_crafting_followers_9 = "ovn_araby_anc_follower_skv_pet_wolf_rat",
    ovn_arb_crafting_followers_10 = "ovn_araby_anc_follower_skv_messenger",
    ovn_arb_crafting_followers_11 = "ovn_araby_anc_follower_skv_mechanic",
    ovn_arb_crafting_followers_12 = "ovn_araby_anc_follower_skv_hell_pit_attendant",
    ovn_arb_crafting_followers_13 = "ovn_araby_anc_follower_skv_female",
    ovn_arb_crafting_followers_14 = "ovn_araby_anc_follower_skv_clerk",
    ovn_arb_crafting_followers_15 = "ovn_araby_anc_follower_skv_chemist",
    ovn_arb_crafting_followers_16 = "ovn_araby_anc_follower_skv_bodyguard",
    ovn_arb_crafting_followers_17 = "ovn_araby_anc_follower_skv_artefact_hunter",
    ovn_arb_crafting_followers_18 = "ovn_araby_anc_follower_lzd_zoat",
    ovn_arb_crafting_followers_19 = "ovn_araby_anc_follower_lzd_veteran_warrior",
    ovn_arb_crafting_followers_20 = "ovn_araby_anc_follower_lzd_temple_cleaner",
    ovn_arb_crafting_followers_21 = "ovn_araby_anc_follower_lzd_sacrificial_victim_skv",
    ovn_arb_crafting_followers_22 = "ovn_araby_anc_follower_lzd_sacrificial_victim_human",
    ovn_arb_crafting_followers_23 = "ovn_araby_anc_follower_lzd_librarian",
    ovn_arb_crafting_followers_24 = "ovn_araby_anc_follower_lzd_gardener",
    ovn_arb_crafting_followers_25 = "ovn_araby_anc_follower_lzd_fan_waver",
    ovn_arb_crafting_followers_26 = "ovn_araby_anc_follower_lzd_defence_expert",
    ovn_arb_crafting_followers_27 = "ovn_araby_anc_follower_lzd_clerk",
    ovn_arb_crafting_followers_28 = "ovn_araby_anc_follower_lzd_attendant",
    ovn_arb_crafting_followers_29 = "ovn_araby_anc_follower_lzd_astronomer",
    ovn_arb_crafting_followers_30 = "ovn_araby_anc_follower_lzd_artefact_hunter",
    ovn_arb_crafting_followers_31 = "ovn_araby_anc_follower_lzd_archivist",
    ovn_arb_crafting_followers_32 = "ovn_araby_anc_follower_lzd_acolyte_priest",
    ovn_arb_crafting_followers_41 = "ovn_araby_anc_follower_hef_wine_merchant",
    ovn_arb_crafting_followers_42 = "ovn_araby_anc_follower_hef_trappist",
    ovn_arb_crafting_followers_43 = "ovn_araby_anc_follower_hef_shrine_keeper",
    ovn_arb_crafting_followers_44 = "ovn_araby_anc_follower_hef_scout",
    ovn_arb_crafting_followers_45 = "ovn_araby_anc_follower_hef_raven_keeper",
    ovn_arb_crafting_followers_46 = "ovn_araby_anc_follower_hef_priestess_isha",
    ovn_arb_crafting_followers_47 = "ovn_araby_anc_follower_hef_priest_vaul",
    ovn_arb_crafting_followers_48 = "ovn_araby_anc_follower_hef_poisoner",
    ovn_arb_crafting_followers_49 = "ovn_araby_anc_follower_hef_minstrel",
    ovn_arb_crafting_followers_50 = "ovn_araby_anc_follower_hef_librarian",
    ovn_arb_crafting_followers_51 = "ovn_araby_anc_follower_hef_food_taster",
    ovn_arb_crafting_followers_52 = "ovn_araby_anc_follower_hef_dragon_armourer",
    ovn_arb_crafting_followers_53 = "ovn_araby_anc_follower_hef_counterspy",
    ovn_arb_crafting_followers_54 = "ovn_araby_anc_follower_hef_counsellor",
    ovn_arb_crafting_followers_55 = "ovn_araby_anc_follower_hef_beard_weaver",
    ovn_arb_crafting_followers_56 = "ovn_araby_anc_follower_hef_bard",
    ovn_arb_crafting_followers_57 = "ovn_araby_anc_follower_hef_assassin",
    ovn_arb_crafting_followers_58 = "ovn_araby_anc_follower_hef_admiral",
    ovn_arb_crafting_followers_59 = "ovn_araby_anc_follower_def_slave_trader",
    ovn_arb_crafting_followers_60 = "ovn_araby_anc_follower_def_slave",
    ovn_arb_crafting_followers_61 = "ovn_araby_anc_follower_def_propagandist",
    ovn_arb_crafting_followers_62 = "ovn_araby_anc_follower_def_overseer",
    ovn_arb_crafting_followers_63 = "ovn_araby_anc_follower_def_organ_merchant",
    ovn_arb_crafting_followers_64 = "ovn_araby_anc_follower_def_musician_flute",
    ovn_arb_crafting_followers_65 = "ovn_araby_anc_follower_def_musician_drum",
    ovn_arb_crafting_followers_66 = "ovn_araby_anc_follower_def_musician_choirmaster",
    ovn_arb_crafting_followers_67 = "ovn_araby_anc_follower_def_merchant",
    ovn_arb_crafting_followers_68 = "ovn_araby_anc_follower_def_harem_keeper",
    ovn_arb_crafting_followers_69 = "ovn_araby_anc_follower_def_gravedigger",
    ovn_arb_crafting_followers_70 = "ovn_araby_anc_follower_def_fanatic",
    ovn_arb_crafting_followers_71 = "ovn_araby_anc_follower_def_diplomat_slaanesh",
    ovn_arb_crafting_followers_72 = "ovn_araby_anc_follower_def_diplomat",
    ovn_arb_crafting_followers_73 = "ovn_araby_anc_follower_def_cultist",
    ovn_arb_crafting_followers_74 = "ovn_araby_anc_follower_def_bodyguard",
    ovn_arb_crafting_followers_75 = "ovn_araby_anc_follower_def_beastmaster",
    ovn_arb_crafting_followers_76 = "ovn_araby_anc_follower_def_apprentice_assassin",
    ovn_arb_crafting_followers_87 = "ovn_araby_anc_follower_tmb_ushabti_bodyguard",
    ovn_arb_crafting_followers_88 = "ovn_araby_anc_follower_tmb_tombfleet_taskmaster",
    ovn_arb_crafting_followers_89 = "ovn_araby_anc_follower_tmb_skeletal_labourer",
    ovn_arb_crafting_followers_90 = "ovn_araby_anc_follower_tmb_priest_of_ptra",
    ovn_arb_crafting_followers_91 = "ovn_araby_anc_follower_tmb_legionnaire_of_asaph",
    ovn_arb_crafting_followers_92 = "ovn_araby_anc_follower_tmb_high_born_of_khemri",
    ovn_arb_crafting_followers_93 = "ovn_araby_anc_follower_tmb_cultist_of_usirian",
    ovn_arb_crafting_followers_94 = "ovn_araby_anc_follower_tmb_charnel_valley_necrotect",
    ovn_arb_crafting_followers_95 = "ovn_araby_anc_follower_tmb_acolyte_of_sokth",
    ovn_arb_crafting_followers_96 = "ovn_araby_anc_follower_undead_warp_stone_hunter",
    ovn_arb_crafting_followers_97 = "ovn_araby_anc_follower_undead_warlock",
    ovn_arb_crafting_followers_98 = "ovn_araby_anc_follower_undead_possessed_mirror",
    ovn_arb_crafting_followers_99 = "ovn_araby_anc_follower_undead_poltergeist",
    ovn_arb_crafting_followers_100 = "ovn_araby_anc_follower_undead_mortal_informer",
    ovn_arb_crafting_followers_101 = "ovn_araby_anc_follower_undead_manservant",
    ovn_arb_crafting_followers_102 = "ovn_araby_anc_follower_undead_corpse_thief",
    ovn_arb_crafting_followers_103 = "ovn_araby_anc_follower_undead_carrion",
    ovn_arb_crafting_followers_104 = "ovn_araby_anc_follower_undead_black_cat",
    ovn_arb_crafting_followers_106 = "ovn_araby_anc_follower_halfling_fieldwarden",
    ovn_arb_crafting_followers_107 = "ovn_araby_anc_follower_empire_woodsman",
    ovn_arb_crafting_followers_108 = "ovn_araby_anc_follower_empire_watchman",
    ovn_arb_crafting_followers_109 = "ovn_araby_anc_follower_empire_tradesman",
    ovn_arb_crafting_followers_110 = "ovn_araby_anc_follower_empire_thief",
    ovn_arb_crafting_followers_111 = "ovn_araby_anc_follower_empire_seaman",
    ovn_arb_crafting_followers_112 = "ovn_araby_anc_follower_empire_scribe",
    ovn_arb_crafting_followers_113 = "ovn_araby_anc_follower_empire_road_warden",
    ovn_arb_crafting_followers_114 = "ovn_araby_anc_follower_empire_rat_catcher",
    ovn_arb_crafting_followers_115 = "ovn_araby_anc_follower_empire_peasant",
    ovn_arb_crafting_followers_116 = "ovn_araby_anc_follower_empire_noble",
    ovn_arb_crafting_followers_117 = "ovn_araby_anc_follower_empire_messenger",
    ovn_arb_crafting_followers_118 = "ovn_araby_anc_follower_empire_marine",
    ovn_arb_crafting_followers_119 = "ovn_araby_anc_follower_empire_light_college_acolyte",
    ovn_arb_crafting_followers_120 = "ovn_araby_anc_follower_empire_jailer",
    ovn_arb_crafting_followers_121 = "ovn_araby_anc_follower_empire_hunter",
    ovn_arb_crafting_followers_122 = "ovn_araby_anc_follower_empire_ferryman",
    ovn_arb_crafting_followers_123 = "ovn_araby_anc_follower_empire_entertainer",
    ovn_arb_crafting_followers_124 = "ovn_araby_anc_follower_empire_coachman",
    ovn_arb_crafting_followers_125 = "ovn_araby_anc_follower_empire_charcoal_burner",
    ovn_arb_crafting_followers_126 = "ovn_araby_anc_follower_empire_camp_follower",
    ovn_arb_crafting_followers_127 = "ovn_araby_anc_follower_empire_burgher",
    ovn_arb_crafting_followers_128 = "ovn_araby_anc_follower_empire_bone_picker",
    ovn_arb_crafting_followers_129 = "ovn_araby_anc_follower_empire_barber_surgeon",
    ovn_arb_crafting_followers_130 = "ovn_araby_anc_follower_empire_apprentice_wizard",
    ovn_arb_crafting_followers_131 = "ovn_araby_anc_follower_empire_agitator",
    ovn_arb_crafting_followers_132 = "ovn_araby_anc_follower_bretonnia_squire",
    ovn_arb_crafting_followers_133 = "ovn_araby_anc_follower_bretonnia_court_jester",
    ovn_arb_crafting_followers_134 = "wh_main_anc_follower_all_student",
    ovn_arb_crafting_followers_135 = "wh_main_anc_follower_all_men_zealot",
    ovn_arb_crafting_followers_136 = "wh_main_anc_follower_all_men_valet",
    ovn_arb_crafting_followers_137 = "wh_main_anc_follower_all_men_vagabond",
    ovn_arb_crafting_followers_138 = "wh_main_anc_follower_all_men_tomb_robber",
    ovn_arb_crafting_followers_139 = "wh_main_anc_follower_all_men_tollkeeper",
    ovn_arb_crafting_followers_140 = "wh_main_anc_follower_all_men_thug",
    ovn_arb_crafting_followers_141 = "wh_main_anc_follower_all_men_soldier",
    ovn_arb_crafting_followers_142 = "wh_main_anc_follower_all_men_smuggler",
    ovn_arb_crafting_followers_143 = "wh_main_anc_follower_all_men_servant",
    ovn_arb_crafting_followers_144 = "wh_main_anc_follower_all_men_rogue",
    ovn_arb_crafting_followers_145 = "wh_main_anc_follower_all_men_protagonist",
    ovn_arb_crafting_followers_146 = "wh_main_anc_follower_all_men_outrider",
    ovn_arb_crafting_followers_147 = "wh_main_anc_follower_all_men_outlaw",
    ovn_arb_crafting_followers_148 = "wh_main_anc_follower_all_men_ogres_pit_fighter",
    ovn_arb_crafting_followers_149 = "wh_main_anc_follower_all_men_militiaman",
    ovn_arb_crafting_followers_150 = "wh_main_anc_follower_all_men_mercenary",
    ovn_arb_crafting_followers_151 = "wh_main_anc_follower_all_men_kislevite_kossar",
    ovn_arb_crafting_followers_152 = "wh_main_anc_follower_all_men_initiate",
    ovn_arb_crafting_followers_153 = "wh_main_anc_follower_all_men_grave_robber",
    ovn_arb_crafting_followers_154 = "wh_main_anc_follower_all_men_fisherman",
    ovn_arb_crafting_followers_155 = "wh_main_anc_follower_all_men_bounty_hunter",
    ovn_arb_crafting_followers_156 = "wh_main_anc_follower_all_men_bodyguard",
    ovn_arb_crafting_followers_157 = "wh_main_anc_follower_all_men_boatman",
    ovn_arb_crafting_followers_158 = "wh_main_anc_follower_all_men_bailiff",
    ovn_arb_crafting_followers_159 = "wh_main_anc_follower_all_hedge_wizard",
    ovn_arb_crafting_followers_160 = "ovn_araby_anc_follower_whalers",
    ovn_arb_crafting_followers_161 = "ovn_araby_anc_follower_slave_worker",
    ovn_arb_crafting_followers_162 = "ovn_araby_anc_follower_skaeling_trader",
    ovn_arb_crafting_followers_163 = "ovn_araby_anc_follower_seer",
    ovn_arb_crafting_followers_164 = "ovn_araby_anc_follower_mountain_scout",
    ovn_arb_crafting_followers_165 = "ovn_araby_anc_follower_mammoth",
    ovn_arb_crafting_followers_166 = "ovn_araby_anc_follower_kurgan_slave_merchant",
    ovn_arb_crafting_followers_167 = "ovn_araby_anc_follower_dragonbone_raiders",
    ovn_arb_crafting_followers_168 = "ovn_araby_anc_follower_cathy_slave_dancers",
    ovn_arb_crafting_followers_169 = "ovn_araby_anc_follower_beserker",
    ovn_arb_crafting_followers_170 = "ovn_araby_anc_follower_dwarfs_troll_slayer",
    ovn_arb_crafting_followers_171 = "ovn_araby_anc_follower_dwarfs_treasure_hunter",
    ovn_arb_crafting_followers_172 = "ovn_araby_anc_follower_dwarfs_teller_of_tales",
    ovn_arb_crafting_followers_173 = "ovn_araby_anc_follower_dwarfs_stonemason",
    ovn_arb_crafting_followers_174 = "ovn_araby_anc_follower_dwarfs_shipwright",
    ovn_arb_crafting_followers_175 = "ovn_araby_anc_follower_dwarfs_sapper",
    ovn_arb_crafting_followers_176 = "ovn_araby_anc_follower_dwarfs_runebearer",
    ovn_arb_crafting_followers_177 = "ovn_araby_anc_follower_dwarfs_reckoner",
    ovn_arb_crafting_followers_178 = "ovn_araby_anc_follower_dwarfs_prospector",
    ovn_arb_crafting_followers_179 = "ovn_araby_anc_follower_dwarfs_powder_mixer",
    ovn_arb_crafting_followers_180 = "ovn_araby_anc_follower_dwarfs_miner",
    ovn_arb_crafting_followers_181 = "ovn_araby_anc_follower_dwarfs_jewelsmith",
    ovn_arb_crafting_followers_182 = "ovn_araby_anc_follower_dwarfs_guildmaster",
    ovn_arb_crafting_followers_183 = "ovn_araby_anc_follower_dwarfs_grudgekeeper",
    ovn_arb_crafting_followers_184 = "ovn_araby_anc_follower_dwarfs_goldsmith",
    ovn_arb_crafting_followers_185 = "ovn_araby_anc_follower_dwarfs_dwarfen_tattooist",
    ovn_arb_crafting_followers_186 = "ovn_araby_anc_follower_dwarfs_dwarf_bride",
    ovn_arb_crafting_followers_187 = "ovn_araby_anc_follower_dwarfs_daughter_of_valaya",
    ovn_arb_crafting_followers_188 = "ovn_araby_anc_follower_dwarfs_cooper",
    ovn_arb_crafting_followers_189 = "ovn_araby_anc_follower_dwarfs_choir_master",
    ovn_arb_crafting_followers_190 = "ovn_araby_anc_follower_dwarfs_candle_maker",
    ovn_arb_crafting_followers_191 = "ovn_araby_anc_follower_dwarfs_brewmaster",
    ovn_arb_crafting_followers_192 = "ovn_araby_anc_follower_dwarfs_archivist",
    ovn_arb_crafting_followers_194 = "ovn_araby_anc_follower_beastmen_pox_carrier",
    ovn_arb_crafting_followers_195 = "ovn_araby_anc_follower_beastmen_mannish_thrall",
    ovn_arb_crafting_followers_196 = "ovn_araby_anc_follower_beastmen_flying_spy",
    ovn_arb_crafting_followers_197 = "ovn_araby_anc_follower_beastmen_flayer",
    ovn_arb_crafting_followers_198 = "ovn_araby_anc_follower_beastmen_chieftains_pet",
    ovn_arb_crafting_followers_199 = "ovn_araby_anc_follower_beastmen_bray_shamans_familiar",
    ovn_arb_crafting_followers_200 = "ovn_araby_anc_follower_chaos_slave_master",
    ovn_arb_crafting_followers_201 = "ovn_araby_anc_follower_chaos_possessed",
    ovn_arb_crafting_followers_202 = "ovn_araby_anc_follower_chaos_oar_slave",
    ovn_arb_crafting_followers_203 = "ovn_araby_anc_follower_chaos_mutant",
    ovn_arb_crafting_followers_204 = "ovn_araby_anc_follower_chaos_kurgan_chieftain",
    ovn_arb_crafting_followers_205 = "ovn_araby_anc_follower_chaos_huscarl",
    ovn_arb_crafting_followers_207 = "ovn_araby_anc_follower_chaos_collector",
    ovn_arb_crafting_followers_208 = "ovn_araby_anc_follower_chaos_beast_tamer",
    ovn_arb_crafting_followers_209 = "ovn_araby_anc_follower_chaos_barbarian",
    ovn_arb_crafting_followers_210 = "ovn_araby_anc_follower_greenskins_swindla",
    ovn_arb_crafting_followers_212 = "ovn_araby_anc_follower_greenskins_snotling_scavengers",
    ovn_arb_crafting_followers_213 = "ovn_araby_anc_follower_greenskins_serial_loota",
    ovn_arb_crafting_followers_214 = "ovn_araby_anc_follower_greenskins_pit_boss",
    ovn_arb_crafting_followers_215 = "ovn_araby_anc_follower_greenskins_idol_carva",
    ovn_arb_crafting_followers_216 = "ovn_araby_anc_follower_greenskins_gobbo_ranta",
    ovn_arb_crafting_followers_217 = "ovn_araby_anc_follower_greenskins_dung_collector",
    ovn_arb_crafting_followers_218 = "ovn_araby_anc_follower_greenskins_dog_boy_scout",
    ovn_arb_crafting_followers_219 = "ovn_araby_anc_follower_greenskins_bully",
    ovn_arb_crafting_followers_220 = "ovn_araby_anc_follower_greenskins_bat-winged_loony",
    ovn_arb_crafting_followers_221 = "ovn_araby_anc_follower_greenskins_backstabba",
    ovn_arb_crafting_followers_222 = "ovn_araby_anc_follower_young_stag",
    ovn_arb_crafting_followers_223 = "ovn_araby_anc_follower_vauls_anvil_smith",
    ovn_arb_crafting_followers_224 = "ovn_araby_anc_follower_royal_standard_bearer",
    ovn_arb_crafting_followers_225 = "ovn_araby_anc_follower_hunting_hound",
    ovn_arb_crafting_followers_226 = "ovn_araby_anc_follower_hawk_companion",
    ovn_arb_crafting_followers_227 = "ovn_araby_anc_follower_forest_spirit",
    ovn_arb_crafting_followers_228 = "ovn_araby_anc_follower_elder_scout",
    ovn_arb_crafting_followers_229 = "ovn_araby_anc_follower_dryad_spy",
    ovn_arb_crafting_followers_231 = "ovn_araby_anc_follower_cst_travelling_necromancer",
    ovn_arb_crafting_followers_232 = "ovn_araby_anc_follower_cst_sartosa_navigator",
    ovn_arb_crafting_followers_233 = "ovn_araby_anc_follower_ogr_campfire_storyteller",
    ovn_arb_crafting_followers_234 = "ovn_araby_anc_follower_ogr_eastern_traveller",
    ovn_arb_crafting_followers_235 = "ovn_araby_anc_follower_ogr_enforcer",
    ovn_arb_crafting_followers_236 = "ovn_araby_anc_follower_ogr_bellower",
    ovn_arb_crafting_followers_237 = "ovn_araby_anc_follower_ogr_gnoblar_treasurer",
    ovn_arb_crafting_followers_238 = "ovn_araby_anc_follower_ogr_brewer",
    ovn_arb_crafting_followers_239 = "ovn_araby_anc_follower_ogr_spider_hunter",
}
local function table_contains(target_table, target_string)
	for i = 1, #target_table do
		if target_table[i] == target_string then
			return true
		end
	end
	return false
end

local function add_custom_panel()
	local mort = find_ui_component_str("root > mortuary_cult")
	if not mort then return end

	mort:SetDockOffset(-120, 0)

	local ski = core:get_or_create_component("ovn_crafting_araby_slaves_back_frame", "ui/templates/pj_custom_image", mort)
	ski:SetImagePath("ui/ovn/ovn_crafting_araby_slaves_back_frame.png", 0)
	ski:SetDockingPoint(3)
	ski:SetDockOffset(281+18, -60)
	ski:SetCanResizeHeight(true)
	ski:SetCanResizeWidth(true)
	ski:Resize(300+18-18,1005-20)

	local new_title = find_ui_component_str(mort, "ovn_crafting_araby_slaves_title")
	if not new_title then
		local title = find_ui_component_str(mort, "panel_title")
		new_title = UIComponent(title:CopyComponent("ovn_crafting_araby_slaves_title"))
		ski:Adopt(new_title:Address())
	end
	new_title:SetDockingPoint(2)
	new_title:SetDockOffset(0, -5)
	new_title:SetImagePath("ui/ovn/transparent.png")
	local title_text = find_ui_component_str(new_title, "tx")
	title_text:SetStateText("Slave Market")

	local skil = core:get_or_create_component("ovn_crafting_araby_slaves_top_left", "ui/templates/pj_custom_image", ski)
	local skir = core:get_or_create_component("ovn_crafting_araby_slaves_top_right", "ui/templates/pj_custom_image", ski)
	skil:SetImagePath("ui/skins/default/empire_event_ornament_top_left.png", 0)
	skir:SetImagePath("ui/skins/default/empire_event_ornament_top_right.png", 0)
	skil:SetDockingPoint(1)
	skil:SetDockOffset(-10, 0)
	skir:SetDockingPoint(3)
	skir:SetDockOffset(5, 0)
end





mod.rearrange_category_buttons = function() --UI script so local_faction should be used

    if cm:get_local_faction_name(true) =="ovn_arb_aswad_scythans" then 
        return --she does not have slaves
    end

	local mort = find_ui_component_str("root > mortuary_cult")
	if not mort then return end

	
	local mort2 = find_ui_component_str(mort, "ovn_crafting_araby_slaves_back_frame")
	if not mort2 then
		add_custom_panel()
		return
	end

	local buy_slaves_button = core:get_or_create_component("ovn_crafting_araby_slaves_buy_slaves", "ui/templates/square_large_text_button", mort2)
	buy_slaves_button:SetDockingPoint(2)
	buy_slaves_button:SetDockOffset(0, 85)
	buy_slaves_button:SetCanResizeWidth(true)
	buy_slaves_button:SetCanResizeHeight(true)
	buy_slaves_button:Resize(339-70, 51)
	local button_txt = find_uicomponent(buy_slaves_button, "button_txt")
	button_txt:SetStateText("Buy Slave Rabble")
	local tooltip = common.get_localised_string("ovn_araby_slave_purchase_cost_intro")


	local char = mod.last_araby_char_cqi and cm:get_character_by_cqi(mod.last_araby_char_cqi)
	if not char or char:is_null_interface() then
		tooltip = tooltip..common.get_localised_string("ovn_araby_slave_purchase_no_valid_army")
		buy_slaves_button:SetState("inactive")
	else
		local forename = char:get_forename() ~= "" and common.get_localised_string(char:get_forename()) or ""
		local surname = char:get_surname() ~= "" and common.get_localised_string(char:get_surname()) or ""
		local localized_name = ""
		if forename ~= "" and surname ~= "" then
			localized_name = forename.." "..surname
		elseif forename ~= "" then
			localized_name = forename
		else
			localized_name = surname
		end
		
		
		
		tooltip = tooltip.. common.get_localised_string("ovn_araby_slave_purchase_selected_army_first") ..localized_name..common.get_localised_string("ovn_araby_slave_purchase_selected_army_second")
		
		

		local num_items = char:military_force():unit_list():num_items()
		if num_items > 19 then
			tooltip = tooltip..common.get_localised_string("ovn_araby_slave_purchase_selected_army_full")
			buy_slaves_button:SetState("inactive")
		end

		local region = char:region()
		if region:is_null_interface() or region:owning_faction():name() ~= char:faction():name() then
			tooltip = tooltip..common.get_localised_string("ovn_araby_slave_purchase_selected_army_outside")
			buy_slaves_button:SetState("inactive")
		end
	end

	if cm:get_local_faction(true):treasury() < 200 then
		tooltip = tooltip..common.get_localised_string("ovn_araby_slave_purchase_not_enough_money")
		buy_slaves_button:SetState("inactive")
	end

	if buy_slaves_button:GetTooltipText() ~= tooltip then
		buy_slaves_button:SetTooltipText(tooltip, true)
	end

	local header = find_uicomponent(mort, "header_list")
	for i, cat_name in ipairs(cats) do
		local cat = find_uicomponent(header, cat_name)
		if cat then
			if find_uicomponent(mort2, cat_name) then
				local dummy = core:get_or_create_component("pj_dummy", "UI/campaign ui/script_dummy", mort)
				dummy:Adopt(cat:Address())
				dummy:SetVisible(false)
			else
				mort2:Adopt(cat:Address())
				cat:SetDockingPoint(3)
				cat:SetDockOffset(0,i*30)
			end
		end
	end
	header:Layout()

	for i, cat_name in ipairs(cats) do
		local cat = find_uicomponent(mort2, cat_name)
		if cat then
			cat:SetDockingPoint(2)
			cat:SetDockOffset(0,i*60+85)
		end
	end
end

local function adjust_araby_crafting_panel()
	local mortuary_cult = find_ui_component_str("root > mortuary_cult")
	if not mortuary_cult then
		real_timer.unregister("ovn_arb_crafting_adjust_panel")
	end

	mod.rearrange_category_buttons()

	local lb = find_ui_component_str(mortuary_cult, "listview > list_clip > list_box")
	if not lb then return end

	if not mod.current_category or not table_contains(cats, mod.current_category) then return end
	local pooled_res_id = mod.category_to_id[mod.current_category]
	if not pooled_res_id then
		return
	end

	local lfk = cm:get_local_faction_name(true)

	for i=0, lb:ChildCount()-1 do
		local follower = UIComponent(lb:Find(i))
		local name = find_uicomponent(follower, "dy_name")

		local victories = find_ui_component_str(follower, "requirement_list > "..pooled_res_id.." > dy_value")
		if victories then
			victories:SetStateText(mod.get_cost(lfk, pooled_res_id))
		end

		local anci = ritual_key_to_anci[follower:Id()]
		if anci then
			name:SetStateText(common.get_localised_string("ancillaries_onscreen_name_"..anci))
		end
	end
end







mod.give_sharkas_slaves = function()
	local data_to_send = {
		cqi = mod.last_araby_char_cqi,
	}
	CampaignUI.TriggerCampaignScriptEvent(cm:get_faction(cm:get_local_faction_name(true)):command_queue_index(), "ovn_crafting_araby_slaves_sharkas|"..json.encode(data_to_send))
end





local subculture_to_res = {
	wh2_main_sc_lzd_lizardmen = "ovn_araby_victories_lzd",
	wh_main_sc_dwf_dwarfs = "ovn_araby_victories_dwarfs",
	wh2_main_sc_def_dark_elves = "ovn_araby_victories_def",
	wh2_main_sc_hef_high_elves = "ovn_araby_victories_hef",
	wh2_dlc11_sc_cst_vampire_coast = "ovn_araby_victories_undead",
	wh_main_sc_chs_chaos = "ovn_araby_victories_chaos",
	wh2_main_sc_skv_skaven = "ovn_araby_victories_skv",
	wh_dlc08_sc_nor_norsca = "ovn_araby_victories_nor",
	wh_dlc05_sc_wef_wood_elves = "ovn_araby_victories_we",
	wh_dlc03_sc_bst_beastmen = "ovn_araby_victories_bst",
	wh2_dlc09_sc_tmb_tomb_kings = "ovn_araby_victories_tmb",
    wh3_main_sc_dae_daemons = "ovn_araby_victories_chaos",
    wh3_main_sc_kho_khorne = "ovn_araby_victories_chaos",
    wh3_main_sc_nur_nurgle = "ovn_araby_victories_chaos",
    wh3_main_sc_sla_slaanesh = "ovn_araby_victories_chaos",
    wh3_main_sc_tze_tzeentch = "ovn_araby_victories_chaos",
    wh3_dlc23_sc_chd_chaos_dwarfs = "ovn_araby_victories_dwarfs",
}


local culture_to_res = {
	wh_main_emp_empire = "ovn_araby_victories_men",
	wh2_main_rogue = "ovn_araby_victories_men",
	wh_main_brt_bretonnia = "ovn_araby_victories_men",
	wh_main_grn_greenskins = "ovn_araby_victories_grn",
    wh3_main_cth_cathay = "ovn_araby_victories_men",
    wh3_main_ksl_kislev = "ovn_araby_victories_men",
    wh3_main_ogr_ogre_kingdoms = "ovn_araby_victories_ogr",
    wh_main_vmp_vampire_counts = "ovn_araby_victories_undead",
    wh_dlc08_nor_norsca = "ovn_araby_victories_nor",
    mixer_gnob_gnoblar_horde = "ovn_araby_victories_ogr",
    mixer_vmp_jade_vampires = "ovn_araby_victories_undead",
    mixer_nag_nagash = "ovn_araby_victories_undead",
    ovn_fimir = "ovn_araby_victories_nor",
    ovn_albion = "ovn_araby_victories_men",
    ovn_amazon = "ovn_araby_victories_men",
    ovn_halflings = "ovn_araby_victories_men",
    ovn_troll = "ovn_araby_victories_grn",
}


mod.category_to_id = {
	ovn_arb_crafting_lzd = "ovn_araby_victories_lzd",
	ovn_arb_crafting_dwarfs = "ovn_araby_victories_dwarfs",
	ovn_arb_crafting_def = "ovn_araby_victories_def",
	ovn_arb_crafting_hef = "ovn_araby_victories_hef",
	ovn_arb_crafting_men = "ovn_araby_victories_men",
	ovn_arb_crafting_undead = "ovn_araby_victories_undead",
	ovn_arb_crafting_chaos = "ovn_araby_victories_chaos",
	ovn_arb_crafting_skv = "ovn_araby_victories_skv",
	ovn_arb_crafting_nor = "ovn_araby_victories_nor",
	ovn_arb_crafting_we = "ovn_araby_victories_we",
	ovn_arb_crafting_grn = "ovn_araby_victories_grn",
	ovn_arb_crafting_bst = "ovn_araby_victories_bst",
	ovn_arb_crafting_tmb = "ovn_araby_victories_tmb",
    ovn_arb_crafting_ogr = "ovn_araby_victories_ogr",
}

mod.default_victories_state = {
	ovn_araby_victories_lzd = 0,
	ovn_araby_victories_dwarfs = 0,
	ovn_araby_victories_def = 0,
	ovn_araby_victories_hef = 0,
	ovn_araby_victories_men = 0,
	ovn_araby_victories_undead = 0,
	ovn_araby_victories_chaos = 0,
	ovn_araby_victories_skv = 0,
	ovn_araby_victories_nor = 0,
	ovn_araby_victories_we = 0,
	ovn_araby_victories_grn = 0,
	ovn_araby_victories_bst = 0,
	ovn_araby_victories_tmb = 0,
    ovn_araby_victories_ogr = 0,
}

mod.current_victories = mod.current_victories or {}

local victory_effects = {
	"ovn_araby_victories_lzd",
	"ovn_araby_victories_dwarfs",
	"ovn_araby_victories_def",
	"ovn_araby_victories_hef",
	"ovn_araby_victories_men",
	"ovn_araby_victories_undead",
	"ovn_araby_victories_chaos",
	"ovn_araby_victories_skv",
	"ovn_araby_victories_nor",
	"ovn_araby_victories_we",
	"ovn_araby_victories_grn",
	"ovn_araby_victories_bst",
	"ovn_araby_victories_tmb",
    "ovn_araby_victories_ogr",
}



local table_clone = nil
table_clone = function(t)
	local clone = {}

	for key, value in pairs(t) do
		if type(value) ~= "table" then
			clone[key] = value
		else
			clone[key] = table_clone(value)
		end
	end

	return clone
end

for _, araby_faction_key in ipairs(araby_slaver_factions) do
	mod.current_victories[araby_faction_key] = mod.current_victories[araby_faction_key]
		or table_clone(mod.default_victories_state)
end

mod.refresh_victories_bundle = function()
    for i=1,#araby_slaver_factions do
        cm:remove_effect_bundle("ovn_crafting_araby_slaves", araby_slaver_factions[i]);    
    end
	

	

	for _, araby_faction_key in ipairs(araby_slaver_factions) do
		local victories_bundle = cm:create_new_custom_effect_bundle("ovn_crafting_araby_slaves")

		if not mod.current_victories[araby_faction_key] then
			mod.current_victories[araby_faction_key] = table_clone(mod.default_victories_state)
		end

		for _, effect_key in ipairs(victory_effects) do
			victories_bundle:add_effect(effect_key, "faction_to_faction_own_unseen", mod.current_victories[araby_faction_key][effect_key])
		end

		local faction = cm:get_faction(araby_faction_key)
		if faction and cm:faction_is_alive(faction) then
			cm:apply_custom_effect_bundle_to_faction(victories_bundle, faction)
		end
	end
end

mod.num_times_purchased = mod.num_times_purchased or {}

for _, araby_faction_key in ipairs(araby_slaver_factions) do
	mod.num_times_purchased[araby_faction_key] = mod.num_times_purchased[araby_faction_key]
		or table_clone(mod.default_victories_state)
end

mod.get_cost = function(faction_key, id)
	if not mod.num_times_purchased[faction_key] then
		mod.num_times_purchased[faction_key] = table_clone(mod.default_victories_state)
	end
	if not mod.num_times_purchased[faction_key][id] then
		mod.num_times_purchased[faction_key][id] = 0
	end
	return mod.num_times_purchased[faction_key][id] + 1
end

mod.calculate_post_victories_changes = function(faction_key, id)
	if mod.get_cost(faction_key, id) <= mod.current_victories[faction_key][id] then
		local pooled_res = cm:get_faction(faction_key):pooled_resource_manager():resource(id)
		if pooled_res and not pooled_res:is_null_interface() then --and pooled_res:value() ~= 100 --intended?
			cm:faction_add_pooled_resource(faction_key, id, "wh2_main_resource_factor_other", 100)
		end
	end
end

mod.handle_battle_rewards = function(context)
	if cm:model():pending_battle():has_been_fought() == true then
		local attacker_result = cm:model():pending_battle():attacker_battle_result()
		local attacker_won = (attacker_result == "heroic_victory") or (attacker_result == "decisive_victory") or (attacker_result == "close_victory") or (attacker_result == "pyrrhic_victory")

		local attacker_keys = {}
		local defender_keys = {}

		for i = 1, cm:pending_battle_cache_num_attackers() do
			local attacker_cqi, attacker_force_cqi, attacker_name = cm:pending_battle_cache_get_attacker(i)
			attacker_keys[attacker_name] = true
		end

		for i = 1, cm:pending_battle_cache_num_defenders() do
			local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(i)
			defender_keys[defender_name] = true
		end

		local winners = attacker_won and attacker_keys or defender_keys
		local losers = attacker_won and defender_keys or attacker_keys

		local is_araby_present = false
		for _, araby_faction in ipairs(araby_slaver_factions) do
			if winners[araby_faction] then
				is_araby_present = true
				break
			end
		end

		if not is_araby_present then return end

		local pooled_resources = {}
		for loser_key in pairs(losers) do
			local f = cm:get_faction(loser_key)
			if f and not f:is_null_interface() then
				local pooled_res = culture_to_res[f:culture()]
				if not pooled_res then
					pooled_res = subculture_to_res[f:subculture()]
				end
				if pooled_res then
					pooled_resources[pooled_res] = true
				end
			end
		end

		for winner_key in pairs(winners) do
			if table_contains(araby_slaver_factions, winner_key) then
				local f = cm:get_faction(winner_key)
				if f and not f:is_null_interface() then
					for pooled_res_name in pairs(pooled_resources) do
						local pooled_res = f:pooled_resource_manager():resource(pooled_res_name)
						if pooled_res and not pooled_res:is_null_interface() then
							if not mod.current_victories[winner_key] then
								mod.current_victories[winner_key] = table_clone(mod.default_victories_state)
							end
							if mod.current_victories[winner_key][pooled_res_name] then
								mod.current_victories[winner_key][pooled_res_name] = mod.current_victories[winner_key][pooled_res_name] + 1
								mod.calculate_post_victories_changes(winner_key, pooled_res_name)
							end
						end
					end
				end
                
			end
		end
	end

	mod.refresh_victories_bundle()
end

cm:add_first_tick_callback(
    function()
        if cm:get_local_faction(true):subculture() == "ovn_sc_arb_araby" then --it's not checking slave faction but subculture as Fatandira also has access to Bazzar. UI and should be local
            local tooltip_to_image_path = {
                ["Buy Weapons"] = "mortuary_cult_title_frame.png",
                ["Buy Armor"] = "mortuary_cult_title_frame_b.png",
                ["Buy Enchanted Items"] = "mortuary_cult_title_frame_c.png",
                ["Buy Talismans"] = "mortuary_cult_title_frame_d.png",
                ["Buy Arcane Items"] = "mortuary_cult_title_frame_e.png",
            }

            core:remove_listener('pj_araby_bazaar_change_header_image')
            core:add_listener(
                'pj_araby_bazaar_change_header_image',
                'ComponentLClickUp',
                true,
                function(context)
                    local ui_root = core:get_ui_root()
                    local pt = find_uicomponent(ui_root, "mortuary_cult", "panel_title")
                    if not pt then return end

                    local tooltip_text = UIComponent(context.component):GetTooltipText()

                    local image_path = tooltip_to_image_path[tooltip_text]
                    if not image_path then return end

                    pt:SetImagePath("ui/skins/ovn_araby/"..image_path)
                end,
                true
            )
        end
        
        core:remove_listener("ovn_arb_crafting_adjust_panel_opened")
		core:add_listener(
			"ovn_arb_crafting_adjust_panel_opened",
			"PanelOpenedCampaign",
			function(context)	return context.string == "mortuary_cult"
			end,
			function()
				if cm:get_local_faction(true):subculture() == "ovn_sc_arb_araby" then
					real_timer.register_repeating("ovn_arb_crafting_adjust_panel", 0)
				end
			end,
			true
		)
		core:remove_listener("ovn_arb_crafting_adjust_panel_cb")
		core:add_listener(
			"ovn_arb_crafting_adjust_panel_cb",
			"RealTimeTrigger",
			function(context)
				return context.string == "ovn_arb_crafting_adjust_panel"
			end,
			function()
				adjust_araby_crafting_panel()
			end,
			true
		)

		core:remove_listener("ovn_crafting_araby_slaves_buy_slaves_on_char_selected")
		core:add_listener(
			"ovn_crafting_araby_slaves_buy_slaves_on_char_selected",
			"CharacterSelected",
			true,
			function(context)
				-- -@type CA_CHAR
				local char = context:character()

				local char_faction_key = char:faction():name()
				if char:faction():subculture() ~= "ovn_sc_arb_araby" then return end

				if not char:has_military_force() then return end

				mod.last_araby_char_cqi = char:command_queue_index()
			end,
			true
		)
		core:remove_listener('ovn_arb_crafting_clicked_category_button')
		core:add_listener(
			'ovn_arb_crafting_clicked_category_button',
			'ComponentLClickUp',
			true,
			function(context)
				if cm:get_local_faction(true):subculture() ~= "ovn_sc_arb_araby" then
					return
				end

				if context.string == "ovn_crafting_araby_slaves_buy_slaves" then
					mod.give_sharkas_slaves()
					-- find_ui_component_str("root > mortuary_cult > button_ok_frame > button_ok"):SimulateLClick()
				end

				if context.string ~= "button" then return end
				local id = UIComponent(UIComponent(context.component):Parent()):Id()
				if not table_contains(all_cats, id) then return end
				mod.current_category = id

				local mort = find_ui_component_str("root > mortuary_cult")
				if not mort then return end

				for i, cat_name in ipairs(cats) do
					local cat = find_uicomponent(mort, cat_name)
					if cat and id ~= cat_name then
						local button = find_uicomponent(cat, "button")
						if button then
							button:SetState("active")
						end
					end
				end
			end,
			true
		)

		core:remove_listener('ovn_arb_crafting_clicked_buy_button')
		core:add_listener(
			'ovn_arb_crafting_clicked_buy_button',
			'ComponentLClickUp',
			true,
			function(context)
				if cm:get_local_faction(true):subculture() ~= "ovn_sc_arb_araby" then
					return
				end

				if context.string ~= "button_craft" then return end
				local parent_id = UIComponent(UIComponent(context.component):Parent()):Id()
				if not string.match(parent_id, "^ovn_arb_crafting_followers_%d+$") then return end

				local pooled_res_id = mod.category_to_id[mod.current_category]
				-- dout("pooled res id: "..pooled_res_id)
				if not pooled_res_id then return end

				local faction_key = cm:get_local_faction_name(true)
				if not mod.current_victories[faction_key] or not mod.current_victories[faction_key][pooled_res_id] then
					-- dout("NO POOLED RES FOUND")
					return
				end

				if mod.get_cost(faction_key, pooled_res_id) > mod.current_victories[faction_key][pooled_res_id] then
					-- dout("COST TOO HIGH")
					return
				end

				local data_to_send = {
					fk = faction_key,
					pr = pooled_res_id,
					c = mod.get_cost(faction_key, pooled_res_id),
				}
				CampaignUI.TriggerCampaignScriptEvent(cm:get_faction(cm:get_local_faction_name(true)):command_queue_index(), "ovn_crafting_araby_slaves_purchased|"..json.encode(data_to_send))
			end,
			true
		)
		core:remove_listener("ovn_crafting_araby_slaves_BattleCompleted")
		core:add_listener(
			"ovn_crafting_araby_slaves_BattleCompleted",
			"BattleCompleted",
			true,
			function(context)
				mod.handle_battle_rewards(context);
			end,
			true
		)

		core:remove_listener("ovn_crafting_araby_slaves_sharkas_on_UITrigger")
		core:add_listener(
			"ovn_crafting_araby_slaves_sharkas_on_UITrigger",
			"UITrigger",
			function(context)
					return context:trigger():starts_with("ovn_crafting_araby_slaves_sharkas")
			end,
			function(context)
				local faction_cqi = context:faction_cqi()

				local stringified_data = context:trigger():gsub("ovn_crafting_araby_slaves_sharkas|", "")

				local data = json.decode(stringified_data)

				local char_cqi = data.cqi

				local char = cm:get_character_by_cqi(char_cqi)
				if not char or char:is_null_interface() then return end

				cm:grant_unit_to_character(cm:char_lookup_str(char_cqi), "ovn_arb_inf_sharkas_slaves")
				cm:treasury_mod(char:faction():name(), -200)
			end,
			true
		)

		core:remove_listener("ovn_crafting_araby_slaves_purchased_on_UITrigger")
		core:add_listener(
			"ovn_crafting_araby_slaves_purchased_on_UITrigger",
			"UITrigger",
			function(context)
					return context:trigger():starts_with("ovn_crafting_araby_slaves_purchased")
			end,
			function(context)
				local faction_cqi = context:faction_cqi()

				local stringified_data = context:trigger():gsub("ovn_crafting_araby_slaves_purchased|", "")

				local data = json.decode(stringified_data)

				local faction_key = data.fk
				local pooled_res_id = data.pr
				local cost = data.c

				mod.current_victories[faction_key][pooled_res_id] = mod.current_victories[faction_key][pooled_res_id] - cost

				if not mod.num_times_purchased[faction_key][pooled_res_id] then
					mod.num_times_purchased[faction_key][pooled_res_id] = 0
				end
				mod.num_times_purchased[faction_key][pooled_res_id] = mod.num_times_purchased[faction_key][pooled_res_id] + 1

				cm:callback(function()
					mod.calculate_post_victories_changes(faction_key, pooled_res_id)
				end, 0)

				if table_contains(araby_slaver_factions, faction_key) then
					mod.refresh_victories_bundle()
				end
			end,
			true
		)
    end
);



cm:add_first_tick_callback(function()
    for i=1,#araby_slaver_factions do
        local faction = cm:get_faction(araby_slaver_factions[i])
        if faction and faction:is_human() then
            mod.refresh_victories_bundle()
            return --don't have to call twice
        end
    end
end)

cm:add_first_tick_callback_new(
    function()
        if cm:is_multiplayer() then
            mixer_disable_starting_zoom = true
        end
    
        local all_factions = cm:model():world():faction_list();
        for i = 0, all_factions:num_items()-1 do
            local faction = all_factions:item_at(i);
            if faction:culture() == "ovn_araby" and faction:name() ~= "ovn_arb_aswad_scythans" and faction:is_human() == false then--not human because human can just purchase them anytime
                cm:add_unit_to_faction_mercenary_pool(faction, "ovn_arb_inf_sharkas_slaves", "renown", 1, 100, 20, 1, "", "", "", false, "ovn_arb_inf_sharkas_slaves")
            end
        end;
    end
)
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("ovn_crafting_araby_slaves_purchases", mod.num_times_purchased, context)
		cm:save_named_value("ovn_crafting_araby_slaves_victories", mod.current_victories, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		mod.num_times_purchased = cm:load_named_value("ovn_crafting_araby_slaves_purchases", mod.num_times_purchased, context)
		mod.current_victories = cm:load_named_value("ovn_crafting_araby_slaves_victories", mod.current_victories, context)
	end
)