--[[]
local rhox_araby_estate_effect_bundles={
	"rhox_araby_estate_bundle_evenly_matched",
	"rhox_araby_estate_bundle_nomad_chief",
	"rhox_araby_estate_bundle_urban_elite",
}

local function rhox_araby_adjust_estate_effect_bundle(faction)
	for i=1,#rhox_araby_estate_effect_bundles do
		cm:remove_effect_bundle(rhox_araby_estate_effect_bundles[i], faction:name())
	end
	local value = faction:pooled_resource_manager():resource("ovn_araby_urban_meter"):value()
	out("Rhox Araby: Current value: ".. value)
	if value <= -25 then
        out("Rhox Araby: Giving nomad")
		cm:apply_effect_bundle("rhox_araby_estate_bundle_nomad_chief", faction:name(), 0)
	elseif value <25 then
        out("Rhox Araby: Giving even")
		cm:apply_effect_bundle("rhox_araby_estate_bundle_evenly_matched", faction:name(), 0)
	else
        out("Rhox Araby: Giving urban")
		cm:apply_effect_bundle("rhox_araby_estate_bundle_urban_elite", faction:name(), 0)
	end
end
--]]



cm:add_first_tick_callback(
    function()
        if cm:get_local_faction():culture() == "ovn_araby" then --UI thing and needs to be local
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            local result = core:get_or_create_component("rhox_araby_estate", "ui/campaign ui/rhox_araby_estate.twui.xml", parent_ui)
        end

        --[[
		core:add_listener(
            "rhox_araby_estate_pooled_resource_change_check",
            "PooledResourceChanged",
            function(context)
                return context:resource():key() == "ovn_araby_urban_meter" and context:faction():culture() == "ovn_araby" and context:faction():is_human()
            end,
            function(context)
                rhox_araby_adjust_estate_effect_bundle(context:faction())
            end,
            true
        )

		cm:add_faction_turn_start_listener_by_culture(
			"rhox_araby_turn_start_listener",
			"ovn_araby",
			function(context)
				local faction = context:faction()
			
				rhox_araby_adjust_estate_effect_bundle(faction)
			end,
			true
		)

		local faction_list = cm:get_factions_by_culture("ovn_araby")
		if not faction_list then
			return
		end
		for i = 1, #faction_list do
			local current_faction = faction_list[i]
			
			if not current_faction:is_dead() then
				rhox_araby_adjust_estate_effect_bundle(current_faction)
			end
		end

        --]]
        
    end
);

core:add_listener(
    "rhox_araby_settlement_captured",
    "RegionFactionChangeEvent",
    function(context)
        local old_owner = context:previous_faction()
        local new_owner = context:region():owning_faction()
        
        return (old_owner:is_human() and old_owner:subculture() == "ovn_sc_arb_araby") or (new_owner:is_human() and new_owner:subculture() == "ovn_sc_arb_araby")
    end,
    function(context)
        --out.design("Recalc harmony - region change");
        local old_owner = context:previous_faction()
        local new_owner = context:region():owning_faction()
        
        cm:apply_regular_reset_income(old_owner:pooled_resource_manager())
        cm:apply_regular_reset_income(new_owner:pooled_resource_manager())
    end,
    true
);

core:add_listener(
    "rhox_araby_building_completed",
    "BuildingCompleted",
    function(context)
        local building = context:building();
			
        return building:faction():subculture() == "ovn_sc_arb_araby"

    end,
    function(context)
        local building = context:building();
        
        local faction = building:faction()
        
        
        cm:apply_regular_reset_income(faction:pooled_resource_manager())
    end,
    true
);