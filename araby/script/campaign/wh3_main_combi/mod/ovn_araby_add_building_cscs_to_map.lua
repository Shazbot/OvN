
cm:add_first_tick_callback(
	function()
	
        --Using visual coordinates (bad)
        --all rotations 0,0,0
        -- cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_00", "ovn_arb_altar_01", 303.317, 213.327, 0, 0, false, true, false); --z: 1.04
        -- cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_01", "ovn_arb_camp_01", 331.116, 251.854, 0, 0, false, true, false); --z: 1.013
        -- cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_02", "ovn_arb_camp_02", 302.691, 197.806, 0, 0, false, true, false); --z: 0.723
        -- cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_03", "ovn_arb_village_01", 289.647, 220.19, 0, 0, false, true, false); --z: 0.467
        -- cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_04", "ovn_arb_village_02", 349.751, 199.352, 0, 0, false, true, false); --z: 0.337
        -- cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_05", "ovn_arb_caravan_01", 307.575, 255.22, 0, 0, false, true, false); --z: 0.541
        -- cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_06", "ovn_arb_fortress_01", 336.525, 212.131, 0, 0, false, true, false); --z: 1.552
        -- cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_07", "ovn_arb_lighthouse_01", 334.1, 262.134, 0, 0, false, true, false); --z: 0.516
        -- cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_08", "ovn_arb_palace_01", 318.937, 191.48, 0, 0, false, true, false); --z: 0.747
        
        --Proper logical coordinates
        --Might be some off-by-one error screwing things up slightly...
        --It's also possible its rounding to the nearest whole x,y coordinate, hmm
        cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_00", "ovn_arb_altar_01", 454.9755, 277.119902, 454.9755, 278, false, true, false);
        cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_01", "ovn_arb_camp_01", 496.674, 327.1679431, 496.674, 328, false, true, false);
        cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_02", "ovn_arb_camp_02", 454.0365, 256.9575315, 454.0365, 257, false, true, false);
        cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_03", "ovn_arb_village_01", 434.4705, 286.0352005, 434.4705, 287, false, true, false);
        cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_04", "ovn_arb_village_02", 524.6265, 258.9658444, 524.6265, 259, false, true, false);
        cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_05", "ovn_arb_caravan_01", 461.3625, 331.5405053, 461.3625, 332, false, true, false);
        cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_06", "ovn_arb_fortress_01", 504.7875, 275.5662524, 504.7875, 276, false, true, false);
        --cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_07", "ovn_arb_lighthouse_01", 501.15, 340.5220548, 501.15, 341, false, true, false); --this one was way off
        cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_07", "ovn_arb_lighthouse_01", 500.15, 339.5220548, 500.00, 341, false, true, false); --this better, but still a little off
        cm:add_scripted_composite_scene_to_logical_position("arb_campaign_buildings_08", "ovn_arb_palace_01", 478.4055, 248.7398165, 478.4055, 249, false, true, false);
	end
)