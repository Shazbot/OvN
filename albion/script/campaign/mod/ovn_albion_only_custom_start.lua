
local is_pre_first_tick = false
local pre_first_tick_is_done = false



local ovn_albion_immortal_empires = {

	{faction = "ovn_alb_host_ravenqueen",
		custom_start = {
			{
				exceptions = nil,
				mod_requirement = nil,
				mod_exceptions = nil,
				lord_requirement = {"albion_morrigan"},
				pre_first_tick = false,	
				changes = {		
					{"create_force", "wh3_main_sla_subtle_torture", "wh3_main_combi_region_the_folly_of_malofex", 55, 55, "wh3_main_sla_inf_daemonette_0,wh3_main_sla_inf_daemonette_0,wh3_main_sla_inf_marauders_0,wh3_main_sla_inf_marauders_0,wh3_main_sla_inf_chaos_furies_0", "", 4, true, false}
				}
			}
		}
	},
    
    {faction = "all",
		custom_start = {
			{
				exceptions = nil,
				mod_requirement = nil,
				mod_exceptions = nil,
				lord_requirement = {"albion_morrigan"},
				pre_first_tick = true,	
				changes = {		
					{"region_change", "wh3_main_combi_region_the_folly_of_malofex", "ovn_alb_host_ravenqueen", false}
				}
			}
		}
	},
	{faction = "all",
		custom_start = {
			{
				exceptions = nil,
				mod_requirement = nil,
				mod_exceptions = nil,
				lord_requirement = {"albion_morrigan"},
				pre_first_tick = false,	
				changes = {		
					{"upgrade_settlement", "wh3_main_combi_region_the_folly_of_malofex", 3},
				}
			}
		}
	}
}




local function check_mod_requirements(mod_requirement_list)
	local success = true
	
	if mod_requirement_list ~= nil then
		for l = 1, #mod_requirement_list do
			local mod_requirement = mod_requirement_list[l]
			if not core:is_mod_loaded(mod_requirement) then	
				mixu_log_LL("MOD REQUIREMENT FOUND: mod in question: [" .. tostring(mod_requirement) .. "]")
				success = false
			end
		end
	end
	return success
end

local function check_mod_exceptions(mod_exception_list)
	local success = true
	
	if mod_exception_list ~= nil then
		for l = 1, #mod_exception_list do
			local mod_exception = mod_exception_list[l]
			if core:is_mod_loaded(mod_exception) then	
				mixu_log_LL("MOD REQUIREMENT FOUND: mod in question: [" .. tostring(mod_exception) .. "]")
				success = false
			end
		end
	end
	return success
end


local function check_lord_requirements(lord_requirement_list)
	local success = true
	
	if lord_requirement_list ~= nil then
		for l = 1, #lord_requirement_list do
			local lord_requirement = lord_requirement_list[l]
			if mixu_ll["disabled_characters"][lord_requirement] ~= nil then	
				mixu_log_LL("LORD REQUIREMENT FOUND: lord in question: [" .. tostring(lord_requirement) .. "]")
				success = false
			end
		end
	end
	return success
end



cm:add_first_tick_callback(function() 
	is_pre_first_tick = false
	pre_first_tick_is_done = true
	mixu_custom_new_game() 
end)


cm:add_pre_first_tick_callback(function() 
	is_pre_first_tick = true
	mixu_custom_new_game() 
end)

