
-- set this to false if you want more log stuff
local is_this_test_run = true



cm:add_pre_first_tick_callback(function()
	if cm:is_new_game() then
	
		local lords = {
			{"albion_morrigan", "wh3_main_combi_region_the_folly_of_malofex", 50, 40, true}
		}
		
		
	end
end)


cm:add_first_tick_callback(function()	
if not cm:get_campaign_name() == "main_warhammer" then
return
end
	cm:callback(function()	
	
	if (cm:model():turn_number() == 1 and not cm:is_new_game()) or cm:is_new_game() then
		

		local generic_starting_heroes = {
			{"ovn_alb_host_ravenqueen", "champion", "albion_chief", 52, 51, "", "", "albion_morrigan"}
		}
		
		
	end
	end, 1.5)	
end)