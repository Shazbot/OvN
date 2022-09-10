ovn_albion_only_lord_subtypes = {
	["albion_morrigan"] = true
}

ovn_albion_only_faction_keys = {
	["ovn_alb_host_ravenqueen"] = true
}

function ovn_albion_is_faction(faction_key)
	return ovn_albion_only_faction_keys[faction_key] ~= nil
end


function ovn_albion_is_unique_lord(subtype_key)
	return ovn_albion_only_lord_subtypes[subtype_key] ~= nil
end

ovn_albion_lord_list = {
	"albion_morrigan"
}


ovn_albion_starting_lord_list = {
	"albion_morrigan"
}

ovn_albion_item_details = {
	["albion_morrigan"] = {
		campaigns = {"main_warhammer"},
		items =  {
			{"anc_morrigan_staff", 12}
		}
	}
}


ovn_albion_character_details = {		
	["albion_morrigan"] = {
		faction_key = "ovn_alb_host_ravenqueen",
		template_key = "ovn_albion",
		etunimi = "names_name_77777001",
		sukunimi = "names_name_77777002",
		units = {"wh2_dlc16_wef_inf_bladesingers_0","wh_dlc05_wef_inf_wardancers_0","wh_dlc05_wef_inf_wardancers_1"}		
	}	
}