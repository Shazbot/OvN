if not get_mct then return end
local mct = get_mct()
local mct_mod = mct:register_mod("ovn_grudgebringer")
mct_mod:set_title("OvN Lost Factions: Grudgebringers", true)
mct_mod:set_author("Team OvN")
mct_mod:set_description("You can setup some of the campaign rules for the Grudgebringers faction", true)

local ror_skip = mct_mod:add_new_option("rhox_grudge_ror_skip", "slider")
ror_skip:slider_set_min_max(0, 50)
ror_skip:slider_set_step_size(1)
ror_skip:set_default_value(8)
ror_skip:set_text("Max number of unaccessible RoRs", true)
ror_skip:set_tooltip_text("At the beginning of the campaign, the script will sample X times from the RoR pool without replacement. RoRs sampled this way will be not accessible in this campaign.\\n\\nOur intention was to give more replayability and solve the 'Having only 19 unit slots without any submods' issue. But if you want all of them, you can set this value to 0.", true)


local all_hero = mct_mod:add_new_option("rhox_grudge_all_hero", "checkbox")
all_hero:set_default_value(false)
all_hero:set_text("Enable all heroes", true)
all_hero:set_tooltip_text("By turning this option on, you'll gain access to all the Gurdgebringer faction's Legendary heroes via missions. If you turn it off, you'll gain one mage hero and a non-mage hero via a dilemma.", true)




