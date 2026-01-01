if not get_mct or not vfs.exists("script/campaign/mod/cr_iee_mixer_unlocker.lua") then return end
local mct = get_mct()
local mct_mod = mct:register_mod("ovn_araby")
mct_mod:set_title("OvN Lost Factions: Araby", true)
mct_mod:set_author("OvN")
mct_mod:set_description("If you want more minor factions", true)

local minor_elkalabad = mct_mod:add_new_option("rhox_ovn_araby_minor_elkalabad", "checkbox")
minor_elkalabad:set_default_value(false)
minor_elkalabad:set_text("rhox_ovn_araby_minor_elkalabad_title", true)
minor_elkalabad:set_tooltip_text("{{tr:rhox_ovn_araby_minor_elkalabad_desc}}", true)

local minor_ind = mct_mod:add_new_option("rhox_ovn_araby_minor_ind", "checkbox")
minor_ind:set_default_value(false)
minor_ind:set_text("rhox_ovn_araby_minor_ind_title", true)
minor_ind:set_tooltip_text("rhox_ovn_araby_minor_ind_desc", true)

local minor_cult_djinn = mct_mod:add_new_option("rhox_ovn_araby_minor_cult_djinn", "checkbox")
minor_cult_djinn:set_default_value(false)
minor_cult_djinn:set_text("rhox_ovn_araby_minor_cult_djinn_title", true)
minor_cult_djinn:set_tooltip_text("rhox_ovn_araby_minor_cult_djinn_desc", true)


--[[local ovn_araby_minor_latency = mct_mod:add_new_option("rhox_ovn_araby_minor_latency", "slider")
ovn_araby_minor_latency:slider_set_min_max(0, 10)
ovn_araby_minor_latency:slider_set_step_size(1)
ovn_araby_minor_latency:set_default_value(4)
ovn_araby_minor_latency:set_text("rhox_ovn_araby_minor_latency_title", true)
ovn_araby_minor_latency:set_tooltip_text("rhox_ovn_araby_minor_latency_tooltip", true)--]]
