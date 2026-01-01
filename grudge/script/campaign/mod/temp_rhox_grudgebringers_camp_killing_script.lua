core:add_listener(
	'temp_rhox_grudgebringers_destroying_the_faction_on_military_force_destroyed',
	'MilitaryForceDestroyed',
	function(context)
		local mf = context:military_force()
		local faction = mf:faction()
		if faction:name() ~= "ovn_emp_grudgebringers" then
            return false
		end
		return mf and mf:general_character() and faction:is_human()==false and mf:general_character():character_subtype_key() == "morgan_bernhardt"

	end,
	function(context)
		
		local mf = context:military_force()

		local faction = mf:faction()
		
		local military_force_list=faction:military_force_list()
		
        local num_items=military_force_list:num_items()
		
		for i=0,num_items-1 do
			local mf=military_force_list:item_at(i)
			local character  = mf:general_character()
			if character and character:character_type_key() =="general" and character:character_subtype_key() =="ovn_grudge_camp_lord" then
				cm:kill_character_and_commanded_unit(cm:char_lookup_str(character), true, true)
			end
		end
		

	end,
	true
)