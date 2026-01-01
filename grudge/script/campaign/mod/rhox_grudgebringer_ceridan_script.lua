core:add_listener(
    "rhox_darkomen_ceridan_rank_up",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        return character:character_subtype("ceridan") and character:rank() >= 5 and cm:get_saved_value("rhox_ceridan_saw_incident") ~=true
    end,
    function(context)
        out()
        local character = context:character()
        local faction = character:faction()
        if faction:is_human() then
            local incident_builder = cm:create_incident_builder("rhox_grudgebringer_ceridan_ilmarin")
            --incident_builder:add_target(lahmia_faction)
            incident_builder:add_target("default", character)
            local payload_builder = cm:create_payload()
            payload_builder:text_display("rhox_dark_omen_true_ceridan")
            payload_builder:character_trait_change(character, "rhox_grudge_true_ceridan", false)
            incident_builder:set_payload(payload_builder)
            cm:launch_custom_incident_from_builder(incident_builder, faction)
        end
        local forename =  common:get_localised_string("land_units_onscreen_name_ceridan")
        cm:callback(
          function()
            cm:change_character_custom_name(character, forename, "","","")
          end,
          0.1
        )
        
        cm:callback(
          function()
            cm:add_character_model_override(character, "ceridan");
          end,
          0.2
        )
        cm:set_saved_value("rhox_ceridan_saw_incident", true)
        local mod = OVN_GRUDGE_BOOK
        mod.mission_key_to_unit_key["rhox_grudgebringer_lh_2"]="ceridan"
        mod.unit_key_to_mission_key["ceridan"]="rhox_grudgebringer_lh_2"
        mod.bog_pages_list[34]="ceridan"
        mod.bog_pages["ilmarin"]=nil
        mod.bog_pages["ceridan"]={
            unit_commander_name = "",
            unit_description = "",
            unlock = function()
                return common.get_localised_string("ceridan_unlock_condition")
            end
        }
    end,
    false
) 

