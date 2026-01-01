if not get_mct then return end
local mct = get_mct()
local mct_mod = mct:register_mod("ovn_fimir")
mct_mod:set_title("OvN Lost Factions: Fimir", true)
mct_mod:set_author("OvN")
mct_mod:set_description("If you want more minor factions", true)


local ovn_fim_fen_serpents = mct_mod:add_new_option("rhox_ovn_fim_fen_serpents", "checkbox")
ovn_fim_fen_serpents:set_default_value(false)
ovn_fim_fen_serpents:set_text("rhox_ovn_fim_fen_serpents_title", true)
ovn_fim_fen_serpents:set_tooltip_text("{{tr:rhox_ovn_fim_fen_serpents_tooltip}}", true)

local ovn_fim_marsh_hornets = mct_mod:add_new_option("rhox_ovn_fim_marsh_hornets", "checkbox")
ovn_fim_marsh_hornets:set_default_value(false)
ovn_fim_marsh_hornets:set_text("rhox_ovn_fim_marsh_hornets_title", true)
ovn_fim_marsh_hornets:set_tooltip_text("{{tr:rhox_ovn_fim_marsh_hornets_tooltip}}", true)

local ovn_fim_mist_dragons = mct_mod:add_new_option("rhox_ovn_fim_mist_dragons", "checkbox")
ovn_fim_mist_dragons:set_default_value(false)
ovn_fim_mist_dragons:set_text("rhox_ovn_fim_mist_dragons_title", true)
ovn_fim_mist_dragons:set_tooltip_text("{{tr:rhox_ovn_fim_mist_dragons_tooltip}}", true)

if vfs.exists("script/campaign/mod/cr_iee_mixer_unlocker.lua") then
    local ovn_fim_thunderous_sight = mct_mod:add_new_option("rhox_ovn_fim_thunderous_sight", "checkbox")
    ovn_fim_thunderous_sight:set_default_value(false)
    ovn_fim_thunderous_sight:set_text("rhox_ovn_fim_thunderous_sight_title", true)
    ovn_fim_thunderous_sight:set_tooltip_text("{{tr:rhox_ovn_fim_thunderous_sight_tooltip}}", true)
    
    local ovn_fim_hell_gate = mct_mod:add_new_option("rhox_ovn_fim_hell_gate", "checkbox")
    ovn_fim_hell_gate:set_default_value(false)
    ovn_fim_hell_gate:set_text("rhox_ovn_fim_hell_gate_title", true)
    ovn_fim_hell_gate:set_tooltip_text("{{tr:rhox_ovn_fim_hell_gate_tooltip}}", true)
end