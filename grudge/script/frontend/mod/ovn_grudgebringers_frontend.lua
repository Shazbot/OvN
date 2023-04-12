core:add_ui_created_callback(
    function(context)
        mixer_enable_custom_faction("191428931")
        mixer_add_starting_unit_list_for_faction("ovn_emp_grudgebringers", {"grudgebringer_cavalry","grudgebringer_infantry", "grudgebringer_cannon", "grudgebringer_crossbow"})
		mixer_change_lord_name("191428931", "morgan_bernhardt")
		mixer_add_faction_to_major_faction_list("ovn_emp_grudgebringers")	
    end
)