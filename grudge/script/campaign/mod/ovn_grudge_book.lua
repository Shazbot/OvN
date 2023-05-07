OVN_GRUDGE_BOOK = OVN_GRUDGE_BOOK or {}
local mod = OVN_GRUDGE_BOOK

---@return CA_UIC
local digForComponent = function(startingComponent, componentName, max_depth)
	local function digForComponent_iter(startingComponent, componentName, max_depth, current_depth)
		local childCount = startingComponent:ChildCount()
		for i=0, childCount-1  do
				local child = UIComponent(startingComponent:Find(i))
				if child:Id() == componentName then
						return child
				else
					if not max_depth or current_depth+1 <= max_depth then
						local dugComponent = digForComponent_iter(child, componentName, max_depth, current_depth+1)
						if dugComponent then
								return dugComponent
						end
					end
				end
		end
		return nil
	end

	return digForComponent_iter(startingComponent, componentName, max_depth, 1)
end

mod.mission_key_to_unit_key = {
	rhox_grudgebringer_piece_of_eight_1 = "ragnar_wolves",
	rhox_grudgebringer_piece_of_eight_2 = "flagellants_eusebio_the_bleak",
	rhox_grudgebringer_piece_of_eight_3 = "azguz_bloodfist_dwarf_warriors",
	rhox_grudgebringer_piece_of_eight_4 = "dargrimm_firebeard_dwarf_warriors",
	rhox_grudgebringer_piece_of_eight_5 = "urblab_rotgut_mercenary_ogres",
	rhox_grudgebringer_piece_of_eight_6 = "elrod_wood_elf_glade_guards",
	rhox_grudgebringer_piece_of_eight_7 = "galed_elf_archers",
	rhox_grudgebringer_piece_of_eight_8 = "helmgart_bowmen",
	rhox_grudgebringer_piece_of_eight_9 = "keelers_longbows",
	rhox_grudgebringer_piece_of_eight_10 = "black_avangers",
	rhox_grudgebringer_piece_of_eight_11 = "carlsson_guard",
	rhox_grudgebringer_piece_of_eight_12 = "carlsson_cavalry",
	rhox_grudgebringer_piece_of_eight_13 = "vannheim_75th",
	rhox_grudgebringer_piece_of_eight_14 = "treeman_knarlroot",
	rhox_grudgebringer_piece_of_eight_15 = "treeman_gnarl_fist",
	rhox_grudgebringer_piece_of_eight_16 = "uter_blomkwist_imperial_mortar",
	rhox_grudgebringer_piece_of_eight_17 = "countess_guard",
	rhox_grudgebringer_piece_of_eight_18 = "dieter_schaeffer_carroburg_greatswords",
	rhox_grudgebringer_piece_of_eight_19 = "jurgen_muntz_outlaw_infantry",
	rhox_grudgebringer_piece_of_eight_20 = "boris_von_raukov_4th_nuln_halberdiers",
	rhox_grudgebringer_piece_of_eight_21 = "stephan_weiss_outlaw_pistoliers",
	rhox_grudgebringer_piece_of_eight_22 = "imperial_cannon_darius_flugenheim",
	rhox_grudgebringer_piece_of_eight_23 = "grail_knights_tristan_de_la_tourtristan_de_la_tour",
	rhox_grudgebringer_piece_of_eight_24 = "knights_of_the_realm_bertrand_le_grande",
	rhox_grudgebringer_lh_1 = "ludwig_uberdorf_main_units",
	rhox_grudgebringer_lh_2 = "ceridan",
	rhox_grudgebringer_lh_3 = "ice_mage_vladimir_stormbringer",
	rhox_grudgebringer_lh_4 = "dwarf_envoy",
	rhox_grudgebringer_lh_5 = "matthias",
	rhox_grudgebringer_lh_6 = "luther_flamenstrike",
}

mod.unit_key_to_unit_card = {
	azguz_bloodfist_dwarf_warriors = "azguz_bloodfist_dwarf_warriors",
	dargrimm_firebeard_dwarf_warriors	= "dargrimm_firebeard_dwarf_warriors",
	urblab_rotgut_mercenary_ogres	= "urblab_rotgut_mercenary_ogres",
	grudgebringer_cavalry	= "grudgebringer_cavalry",
	grudgebringer_infantry	= "grudgebringer_infantry",
	ceridan	= "ceridan",
	ice_mage_vladimir_stormbringer	= "ice_mage_vladimir_stormbringer",
	morgan_bernhardt	= "morgan_bernhardt",
	dwarf_envoy	= "dwarf_envoy",
	grudgebringer_cannon	= "grudgebringer_cannon",
	grudgebringer_crossbow	= "grudgebringer_crossbow",
	elrod_wood_elf_glade_guards	= "elrod_wood_elf_glade_guards",
	galed_elf_archers	= "galed_elf_archers",
	helmgart_bowmen	= "helmgart_bowmen",
	keelers_longbows	= "keelers_longbows",
	treeman_knarlroot	= "treeman_knarlroot",
	black_avangers	= "black_avangers",
	carlsson_cavalry	= "carlsson_cavalry",
	carlsson_guard	= "carlsson_guard",
	vannheim_75th	= "vannheim_75th",
	treeman_gnarl_fist	= "treeman_gnarl_fist",
	uter_blomkwist_imperial_mortar	= "uter_blomkwist_imperial_mortar",
	countess_guard	= "countess_guard",
	dieter_schaeffer_carroburg_greatswords	= "dieter_schaeffer_carroburg_greatswords",
	jurgen_muntz_outlaw_infantry	= "jurgen_muntz_outlaw_infantry",
	boris_von_raukov_4th_nuln_halberdiers	= "boris_von_raukov_4th_nuln_halberdiers",
	stephan_weiss_outlaw_pistoliers	= "stephan_weiss_outlaw_pistoliers",
	ragnar_wolves	= "ragnar_wolves",
	flagellants_eusebio_the_bleak	= "flagellants_eusebio_the_bleak",
}

mod.unit_key_to_mission_key = {}
for mission_key, unit_key in pairs(mod.mission_key_to_unit_key) do
	mod.unit_key_to_mission_key[unit_key] = mission_key
end


-- if a key is missing in bog_pages below this value is used instead
mod.page_defaults = {
	unit_card = "ui/grudge_book/bog_unit.png",
	unit_banner = "ui/grudge_book/grudge_banner.png",
	unit_commander = "ui/grudge_book/grudge_head.png",
	unit_commander_name = "Gunther Schepke",
	unit_name = "ui/gru_inf.png",
	unit_description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In elementum dignissim vehicula. Sed vel massa scelerisque, pellentesque est a, aliquet ligula. Aenean ut aliquet mi, lobortis imperdiet turpis. Morbi cursus odio nec scelerisque convallis. Nunc eget vestibulum erat. In condimentum massa in auctor volutpat. Cras id ipsum id elit aliquet tincidunt. Cras semper, nunc vel tempor fermentum, lacus risus ultrices velit, quis sodales augue nunc ac quam.",
}

mod.bog_pages_list = {
	"morgan_bernhardt",
	"grudgebringer_cavalry",
	"grudgebringer_infantry",
	"grudgebringer_crossbow",
	"grudgebringer_cannon",
	"ragnar_wolves",
	"flagellants_eusebio_the_bleak",
	"azguz_bloodfist_dwarf_warriors",
	"dargrimm_firebeard_dwarf_warriors",
	"urblab_rotgut_mercenary_ogres",
	"elrod_wood_elf_glade_guards",
	"galed_elf_archers",
	"helmgart_bowmen",
	"keelers_longbows",
	"black_avangers",
	"carlsson_guard",
	"carlsson_cavalry",
	"vannheim_75th",
	"treeman_knarlroot",
	"treeman_gnarl_fist",
	"uter_blomkwist_imperial_mortar",
	"countess_guard",
	"dieter_schaeffer_carroburg_greatswords",
	"jurgen_muntz_outlaw_infantry",
	"boris_von_raukov_4th_nuln_halberdiers",
	"stephan_weiss_outlaw_pistoliers",
	"imperial_cannon_darius_flugenheim",
	"grail_knights_tristan_de_la_tourtristan_de_la_tour",
	"knights_of_the_realm_bertrand_le_grande",
	"ludwig_uberdorf_main_units",
	"ceridan",
	"ice_mage_vladimir_stormbringer",
	"dwarf_envoy",
	"matthias",
	"luther_flamenstrike",
}

mod.bog_pages = {
	morgan_bernhardt = {

	},
	grudgebringer_cavalry = {

	},
	grudgebringer_infantry = {

	},
	grudgebringer_crossbow = {

	},
	grudgebringer_cannon = {

	},
	ragnar_wolves = {

	},
	flagellants_eusebio_the_bleak = {
	},
	azguz_bloodfist_dwarf_warriors = {
	},
	dargrimm_firebeard_dwarf_warriors = {
	},
	urblab_rotgut_mercenary_ogres = {
	},
	elrod_wood_elf_glade_guards = {

	},
	galed_elf_archers = {

	},
	helmgart_bowmen = {
	},
	keelers_longbows = {
	},
	black_avangers = {
	},
	carlsson_guard = {

	},
	carlsson_cavalry = {
		unlock = function()
			return string.format("Defeat a nearby Skaven army.")
		end
	},
	vannheim_75th = {
	},
	treeman_knarlroot = {

	},
	treeman_gnarl_fist = {

	},
	uter_blomkwist_imperial_mortar = {

	},
	countess_guard = {
	},
	dieter_schaeffer_carroburg_greatswords = {
	},
	jurgen_muntz_outlaw_infantry = {
	},
	boris_von_raukov_4th_nuln_halberdiers = {
	},
	stephan_weiss_outlaw_pistoliers = {
	},
	imperial_cannon_darius_flugenheim = {
	},
	grail_knights_tristan_de_la_tourtristan_de_la_tour = {
	},
	knights_of_the_realm_bertrand_le_grande = {
	},
	ludwig_uberdorf_main_units = {
		unlock = function()
			return string.format("Enter Flensburg.")
		end
	},
	ceridan = {
		unlock = function()
			return string.format("Enter Karak Hirn.")
		end
	},
	ice_mage_vladimir_stormbringer = {
		unlock = function()
			return string.format("Enter Kislev.")
		end
	},
	dwarf_envoy = {
		unlock = function()
			return string.format("Enter Zhufbar.")
		end
	},
	matthias = {

	},
	luther_flamenstrike = {

	},
}

mod.get_num_valid_bog_pages = function()
	local num_pages = 0
	for _, page_data in pairs(mod.bog_pages) do
		if not page_data.predicate or page_data.predicate() then
			num_pages = num_pages + 1
		end
	end
	return num_pages+1
end

mod.get_bog_page = function(page_num)
	local page_index = 0
	for _, page_data in pairs(mod.bog_pages) do
		if not page_data.predicate or page_data.predicate() then
			page_index = page_index + 1
			if page_index == page_num-1 then
				return mod.bog_pages[mod.bog_pages_list[page_index]]
			end
		end
	end
	return nil
end

--- Current index of the Book of grudges page on the left, tracked to know when to refresh the BoG UI.
mod.current_bog_page = nil

--- Add a unit to the faction leader.
mod.add_unit_to_army = function(unit_key)
	local char = cm:get_faction(cm:get_local_faction_name(true)):faction_leader()
	if not char or char:is_null_interface() then return end

	cm:grant_unit_to_character(cm:char_lookup_str(char), unit_key)
end

--- Keep track of currently visible BoG UI components so we can hide them when turning pages.
mod.current_bog_comps = {}

--- Simulate clicking the OK button to close the BoG.
mod.close_book_of_grudges = function()
	local book_of_grudges = digForComponent(core:get_ui_root(), "pj_grudge_book")
	if not book_of_grudges then return end
	local button_ok = digForComponent(book_of_grudges, "button_ok")
	if not button_ok then return end
	button_ok:SimulateLClick()
end

mod.create_toc = function()
	-- dout("CREATE TOC")
	local book_of_grudges = digForComponent(core:get_ui_root(), "pj_grudge_book")
	local book_frame = find_uicomponent(book_of_grudges, "book_frame")
	book_frame:SetImagePath("ui/grudge_book/book_bg.png", 1)
	local pages = digForComponent(book_of_grudges, "pages")
	local dy_objective = digForComponent(book_of_grudges, "dy_objective")
	local mission_statuses = cm:get_saved_value("ovn_grudge_missions_statuses")
	local current_x = 140
	local current_y = 30
	for i=0, #mod.bog_pages_list do
		if i == 18 then
			current_y = 30
			current_x = 720
		end

		local row_id ="pj_grudge_book_row_"..i
		local existing_row = find_uicomponent(pages, row_id)
		if existing_row then
			existing_row:Destroy()
		end
		local row = core:get_or_create_component(row_id, "ui/templates/parchment_row.twui.xml", pages)

		local new_id = "pj_grudge_book_row_unit_"..i
		local obj = find_uicomponent(row, new_id)
		if not obj then
			obj = UIComponent(dy_objective:CopyComponent(new_id))
			row:Adopt(obj:Address())
		end

		obj:SetVisible(true)
		row:SetDockingPoint(1)
		local lines_per_row = 100
		row:SetDockOffset(current_x, current_y)
		row:SetCanResizeWidth(true)

		obj:SetDockingPoint(7)
		obj:SetDockOffset(20, 0)
		local row_height = 33
		row:Resize(480,row_height)
		current_y = current_y + row_height
		obj:SetInteractive(false)

		local unit_key = mod.bog_pages_list[i+1] or ""
		local unit_data = mod.bog_pages[unit_key]

		local is_completed = false
		local is_failed = false
		if mission_statuses then
			local mission_key = mod.unit_key_to_mission_key[unit_key]
			if mission_key then
				is_completed = mission_statuses.success and mission_statuses.success[mission_key]
				is_failed = mission_statuses.failed and mission_statuses.failed[mission_key]
			end
		end

		-- this gets updated every frame in mod.on_book_of_grudges_repeat
		if unit_data and unit_data.localized_unlock and not (is_completed or is_failed) then
			local additional_row_height = 10
			row:Resize(480,row_height+additional_row_height)
			obj:SetDockOffset(20, additional_row_height-25)
			current_y = current_y + 10
			local unlock_req_str = "[[col:black]]"..unit_data.localized_unlock.."[[/col]]"
			local req_id = "unit_req_"..unit_key
			-- needs to be in a callback
			cm:callback(function()
				local req = find_uicomponent(obj, req_id)
				if not req then
					local req = UIComponent(dy_objective:CopyComponent(req_id))
					obj:Adopt(req:Address())
					req:SetDockingPoint(1)
					req:SetDockOffset(25,18)
				end

				req:SetStateText(unlock_req_str)
				req:SetVisible(true)
				req:SetInteractive(false)
			end,0)
		end
		local localized_unit_key = common.get_localised_string("land_units_onscreen_name_"..unit_key)
		local loc_w = obj:TextDimensionsForText(localized_unit_key)
		local dot_w = obj:TextDimensionsForText(".")
		local page_num_w = obj:TextDimensionsForText(i+2)
		local without_dots_w = 450 - loc_w - page_num_w
		local num_dots = math.floor(without_dots_w/dot_w)
		local line = "[[col:black]]"..localized_unit_key
		for i=1, num_dots do
			line = line.."."
		end
		line = line..(i+2).."[[/col]]"
		obj:SetStateText(line)
	end
end

--- Draw a page of BoG with our own UI.
mod.draw_bog_page = function(page_num)
	local root = core:get_ui_root()
	local book_of_grudges = digForComponent(root, "pj_grudge_book")
	local left_list = digForComponent(book_of_grudges, "list_left")
	local dy_objective_bold = digForComponent(book_of_grudges, "dy_objective_bold")

	---@type CA_UIC
	local book_frame = digForComponent(book_of_grudges, "book_frame")

	local pages = find_uicomponent(root, "pj_grudge_book", "book_frame", "pages")
	for _, comp_id in ipairs({
		"pj_grudge_book_banner",
		"pj_grudge_book_head",
		"pj_grudge_book_unit",
		"pj_grudge_book_unit_name",
		"pj_grudge_book_unit_info",
		"pj_grudge_book_unit_description",
		"pj_grudge_book_unit_commander",
		"pj_grudge_book_head_bg",
		"pj_grudge_book_unit_card_bg",
		"pj_grudge_book_head3",
	}) do
		local comp = find_uicomponent(pages, comp_id)
		if comp then comp:SetVisible(page_num ~= 1) end
	end

	local toc_button = core:get_or_create_component("pj_grudge_book_toc_button", "ui/templates/round_small_button.twui.xml", book_of_grudges)
	toc_button:SetImagePath("ui/skins/default/icon_menu.png", 0)
	-- toc_button:SetCanResizeWidth(true)
	-- toc_button:SetCanResizeHeight(true)
	-- toc_button:Resize(32.32)
	toc_button:SetVisible(true)
	toc_button:SetDockingPoint(2)
	toc_button:SetDockOffset(-137,14)
	toc_button:SetTooltipText("Table of Contents", true)
	-- toc_button:SetImageRotation(0, 3.141592)

	if page_num == 1 then
		return mod.create_toc()
	end

	local page_data = mod.get_bog_page(page_num)
	if not page_data then return end
	local desc = page_data.unit_description or mod.page_defaults.unit_description

	local is_left_page = true
	local list = left_list

	local pages = digForComponent(book_of_grudges, "pages")
	local dy_objective = digForComponent(book_of_grudges, "dy_objective")
	---@type CA_UIC
	local unit_desc_id = "pj_grudge_book_unit_description"
	local unit_desc = digForComponent(book_of_grudges, unit_desc_id)

	local x, y = list:Position()

	if not unit_desc then
		unit_desc = UIComponent(dy_objective:CopyComponent(unit_desc_id))
		pages:Adopt(unit_desc:Address())
		unit_desc:SetCanResizeWidth(true)
		unit_desc:SetCanResizeHeight(true)
		unit_desc:Resize(624*1.2, 96*1.5)
		unit_desc:MoveTo(x+580, y+555)
	end

	local unit_key = mod.bog_pages_list[page_num-1]

	local banner = core:get_or_create_component("pj_grudge_book_banner", "ui/ovn_grudge_book/pj_custom_image.twui.xml", pages)
	banner:SetImagePath(page_data.unit_banner or ('ui/ovn_grudge_book/banners/'..unit_key..'.png'), 0)
	banner:SetCanResizeWidth(true)
	banner:SetCanResizeHeight(true)
	banner:Resize(159*1.3,216*1.3)
	banner:SetVisible(true)
	banner:SetDockingPoint(2)
	banner:SetDockOffset(170,50)

	local req_header_id = "pj_grudge_book_req_header"
	local req_header = find_uicomponent(pages, req_header_id)
	if not req_header then
		if dy_objective_bold then
			req_header = UIComponent(dy_objective_bold:CopyComponent(req_header_id))
			pages:Adopt(req_header:Address())
		end
	end
	if req_header then
		req_header:SetStateText("[[col:black]]".."Unlock requirement".."[[/col]]")
		req_header:SetDockingPoint(8)
		req_header:SetDockOffset(310,-250)
	end

	local req_text_id = "pj_grudge_book_req_text"
	local req_text = find_uicomponent(pages, req_text_id)
	if not req_text then
		if dy_objective then
			req_text = UIComponent(dy_objective:CopyComponent(req_text_id))
			-- req_text = UIComponent(dy_objective_italic:CopyComponent(req_text_id))
			pages:Adopt(req_text:Address())
		end
	end
	if req_text then
		req_text:SetVisible(false)
		req_text:SetStateText("[[col:black]]".."blah blah".."[[/col]]")
		req_text:SetDockingPoint(8)
		req_text:SetDockOffset(320,-215)
	end

	local req_text_fluff_id = "pj_grudge_book_req_text_fluff"
	local req_text_fluff = find_uicomponent(req_text, req_text_fluff_id)
	if not req_text_fluff then
		local dy_objective_italic = digForComponent(book_of_grudges, "dy_objective_italic")
		if dy_objective_italic then
			req_text_fluff = UIComponent(dy_objective_italic:CopyComponent(req_text_fluff_id))
			req_text:Adopt(req_text_fluff:Address())
		end
	end
	if req_text_fluff then
		if page_data.localized_fluff_text then
			req_text_fluff:SetStateText("[[col:black]]"..page_data.localized_fluff_text.."[[/col]]")
		end
		req_text_fluff:SetCanResizeHeight(true)
		req_text_fluff:SetCanResizeWidth(true)
		req_text_fluff:Resize(480, 96)
		req_text_fluff:SetDockingPoint(1)
		req_text_fluff:SetDockOffset(0,30)
	end



	local head = core:get_or_create_component("pj_grudge_book_head", "ui/ovn_grudge_book/pj_custom_image.twui.xml", pages)
	head:SetImagePath(page_data.unit_commander or ("ui/units/minspec_portholes/"..unit_key..".png"), 0)
	head:SetCanResizeWidth(true)
	head:SetCanResizeHeight(true)
	head:Resize(200,200)
	head:SetVisible(true)
	head:SetDockingPoint(2)
	head:SetDockOffset(400,70)

		local head3 = core:get_or_create_component("pj_grudge_book_head3", "ui/ovn_grudge_book/pj_custom_image.twui.xml", pages)
	head3:SetImagePath(page_data.unit_commander or ("ui/ovn_grudge_book/wh2/bar_small_buttons_2.png"), 0)
	head3:SetCanResizeWidth(true)
	head3:SetCanResizeHeight(true)
	head3:Resize(339*0.62,70*0.62)
	head3:SetVisible(true)
	head3:SetDockingPoint(2)
	head3:SetDockOffset(400,270)

	local head2 = core:get_or_create_component("pj_grudge_book_head_bg", "ui/ovn_grudge_book/pj_custom_image.twui.xml", pages)
	head2:SetImagePath(page_data.unit_commander or ("ui/ovn_grudge_book/wh2/elector_map_frame.png"), 0)
	head2:SetCanResizeWidth(true)
	head2:SetCanResizeHeight(true)
	head2:Resize(215,215)
	head2:SetVisible(true)
	head2:SetDockingPoint(2)
	head2:SetDockOffset(400,60)

	local unit = core:get_or_create_component("pj_grudge_book_unit", "ui/ovn_grudge_book/pj_custom_image.twui.xml", pages)
	unit:SetImagePath(page_data.unit_card or mod.unit_key_to_unit_card[unit_key] and 'ui/ovn_grudge_book/unit_cards/'..mod.unit_key_to_unit_card[unit_key]..'.png' or mod.page_defaults.unit_card, 0)
	unit:SetCanResizeWidth(true)
	unit:SetCanResizeHeight(true)
	unit:Resize(144*1.5,263*1.5)
	unit:SetVisible(true)
	unit:SetDockingPoint(4)
	unit:SetDockOffset(260,-90)


	local unit_card_bg = core:get_or_create_component("pj_grudge_book_unit_card_bg", "ui/ovn_grudge_book/pj_custom_image.twui.xml", pages)
	unit_card_bg:SetImagePath("ui/ovn_grudge_book/bloodlines_frame2.png", 0)
	unit_card_bg:SetCanResizeWidth(true)
	unit_card_bg:SetCanResizeHeight(true)
	unit_card_bg:Resize(142*1.6,295*1.6)
	unit_card_bg:SetVisible(true)
	unit_card_bg:SetDockingPoint(4)
	unit_card_bg:SetDockOffset(255,-56)

	local unit_card_bg2 = core:get_or_create_component("pj_grudge_book_unit_card_bg2", "ui/ovn_grudge_book/pj_custom_image.twui.xml", unit_card_bg)
	unit_card_bg2:SetImagePath("ui/ovn_grudge_book/wh2/offices_ornaments_left.png", 0)
	unit_card_bg2:SetCanResizeWidth(true)
	unit_card_bg2:SetCanResizeHeight(true)
	unit_card_bg2:Resize(500*0.55,473*0.55)
	unit_card_bg2:SetVisible(true)
	unit_card_bg2:SetDockingPoint(1)
	unit_card_bg2:SetDockOffset(-20,-5)

	local unit_name = core:get_or_create_component("pj_grudge_book_unit_name", "ui/ovn_grudge_book/pj_custom_image.twui.xml", pages)
	unit_name:SetImagePath(page_data.unit_name or ('ui/ovn_grudge_book/unit_names/'..unit_key..'.png'), 0)
	unit_name:SetCanResizeWidth(true)
	unit_name:SetCanResizeHeight(true)
	unit_name:Resize(500,200)
	unit_name:SetVisible(true)
	unit_name:SetDockingPoint(7)
	unit_name:SetDockOffset(120,-77)

	unit_desc:Resize(500, 96)
	unit_desc:MoveTo(x+630, y+555)

	local unit_info = core:get_or_create_component("pj_grudge_book_unit_info", "ui/ovn_grudge_book/unit_information_492_new.twui.xml", pages)
	local unit_key = mod.bog_pages_list[page_num-1]
	unit_info:SetVisible(true)
	unit_info:SetDockingPoint(1)
	unit_info:SetDockOffset(-298,150)
	if unit_key then
		unit_info:SetContextObject(cco("CcoMainUnitRecord",unit_key))
		unit_info:SetContextObject(cco("CcoUnitDetails","UnitRecord_"..unit_key.."_ovn_emp_grudgebringers_0_0.8"))
	end

	if not unit_desc or not unit then
		if dout then dout("ERROR: OBJ OR HEADER MISSING!") end
		return
	end

	unit_desc:SetStateText("[[col:black]]"..desc.."[[/col]]")
	unit_desc:SetVisible(true)
	cm:callback(function()
		unit_desc:Resize(480, 96)
		unit_desc:MoveTo(x+630+10, y+320)
	end,0)
	table.insert(mod.current_bog_comps, unit_desc)

	local unit_commander_id = "pj_grudge_book_unit_commander"
	local unit_commander = digForComponent(book_of_grudges, unit_commander_id)
	if not unit_commander and dy_objective_bold then
		unit_commander = UIComponent(dy_objective_bold:CopyComponent(unit_commander_id))
		pages:Adopt(unit_commander:Address())
		unit_commander:SetCanResizeWidth(true)
		unit_commander:SetCanResizeHeight(true)
	end
	if unit_commander then
		unit_commander:SetVisible(true)
		unit_commander:SetStateText("[[col:black]]"..(page_data.unit_commander_name or mod.page_defaults.unit_commander_name).."[[/col]]")
		-- unit_commander:SetDockingPoint(1)
		-- unit_commander:SetDockOffset(starting_x+200, starting_y)
		unit_commander:SetDockingPoint(2)
		unit_commander:SetDockOffset(400,284)
	end

	book_frame:SetImagePath("ui/ovn_grudge_book/book_bg.png", 1)
	-- book_frame:SetImagePath("ui/grudge_pages.png", 1)
	-- book_frame:SetImagePath("ui/grudge_pages.png", 2)

	local button_L = digForComponent(book_of_grudges, "button_L")
	---@type CA_UIC
	local button_R = digForComponent(book_of_grudges, "button_R")
	if page_num ~= 1 then
		button_L:SetState("active")
	else
		button_L:SetState("inactive")
	end
	local num_valid_pages = mod.get_num_valid_bog_pages()
	if page_num ~= num_valid_pages then
		button_R:SetState("active")
	else
		button_R:SetState("inactive")
	end
end

mod.comp_id_to_handler = {
	button_R = "on_book_navigation",
	button_L = "on_book_navigation",
	pj_grudge_book_toc_button = "on_toc_button_clicked",
	ovn_grudge_main_button = "on_open_book",
}

mod.on_open_book = function(context)
	if find_uicomponent(core:get_ui_root(), "pj_grudge_book") then
		return mod.destroy_book()
	end

	core:get_or_create_component("pj_grudge_book", "ui/ovn_grudge_book/grudge_book1_new.twui.xml")
	real_timer.unregister("ovn_grudge_book_book_of_grudges_real_timer")
	real_timer.register_repeating("ovn_grudge_book_book_of_grudges_real_timer", 0)

	mod.on_book_of_grudges_panel_opening()
end

mod.on_toc_button_clicked = function(context)
	mod.go_to_page(1)
end

mod.go_to_page = function(page_num)
	local num_valid_pages = mod.get_num_valid_bog_pages()

	local book_of_grudges = digForComponent(core:get_ui_root(), "pj_grudge_book")
	if not book_of_grudges then return end
	---@type CA_UIC
	local dy_page = digForComponent(book_of_grudges, "dy_page")
	if not dy_page then return end
	dy_page:SetStateText(page_num.."/"..num_valid_pages)
	mod.on_book_of_grudges_panel_opening()
end

mod.on_book_navigation = function(context)
	local book_of_grudges = digForComponent(core:get_ui_root(), "pj_grudge_book")
	if not book_of_grudges then return end

	---@type CA_UIC
	local dy_page = digForComponent(book_of_grudges, "dy_page")
	if not dy_page then return end

	local text = dy_page:GetStateText()
	local current_page = tonumber(string.sub(text, 1, string.find(text, "/")-1))
	local num_valid_pages = mod.get_num_valid_bog_pages()

	local next_page = current_page
	if context.string == "button_R" then
		next_page = current_page + 1
	else
		next_page = current_page - 1
	end
	dy_page:SetStateText(next_page.."/"..num_valid_pages)

	mod.on_book_of_grudges_panel_opening()
end

core:remove_listener("pj_grudge_book_on_row_click")
core:add_listener(
	"pj_grudge_book_on_row_click",
	"ComponentLClickUp",
	function(context)
		return context.string:starts_with("pj_grudge_book_row_")
	end,
	function(context)
		mod.go_to_page(tonumber(string.sub(context.string,20,#context.string))+2)
	end,
	true
)

--- Redraw the opened BoG with our own UI.
mod.redraw_bog = function(page_num)
	local book_of_grudges = digForComponent(core:get_ui_root(), "pj_grudge_book")
	if not book_of_grudges then return end
	if not book_of_grudges:Visible() then return end

	local grudge_bar = digForComponent(book_of_grudges, "grudge_bar")
	grudge_bar:SetVisible(false)

	local tx_header = digForComponent(book_of_grudges, "tx_header")
	tx_header:SetStateText("Recruitment Ledger")

	local l = digForComponent(book_of_grudges, "list_left")
	local r = digForComponent(book_of_grudges, "list_right")
	if not l or not r then return end
	l:SetVisible(false)
	r:SetVisible(false)

	mod.current_bog_comps = {}

	if page_num == 1 or mod.get_bog_page(page_num) then
		mod.draw_bog_page(page_num)
	end
end

mod.on_book_of_grudges_panel_opening = function()
	-- dout("ON PANEL OPENING")
	local book_of_grudges = digForComponent(core:get_ui_root(), "pj_grudge_book")
	if not book_of_grudges then return end
	---@type CA_UIC
	local dy_page = digForComponent(book_of_grudges, "dy_page")
	---@type CA_UIC
	local button_L = digForComponent(book_of_grudges, "button_L")
	---@type CA_UIC
	local button_R = digForComponent(book_of_grudges, "button_R")
	if not dy_page then return end
	local text = dy_page:GetStateText()
	-- dout("page text:",text)
	local current_page = tonumber(string.sub(text, 1, string.find(text, "/")-1))
	local num_valid_pages = mod.get_num_valid_bog_pages()
	dy_page:SetStateText(current_page.."/"..num_valid_pages)
	if current_page == 0 then
		dy_page:SetStateText(string.format("1/%s",num_valid_pages))
		current_page = 1
	end
	-- dout("current_page:",current_page)
	if current_page ~= 1 then
		button_L:SetState("active")
	else
		button_L:SetState("inactive")
	end
	if current_page ~= num_valid_pages then
		button_R:SetState("active")
	else
		button_R:SetState("inactive")
	end
	-- dout("CURRENT PAGE:",mod.current_bog_page)
	if not mod.current_bog_page or mod.current_bog_page ~= current_page then
		mod.current_bog_page = current_page
		mod.remove_reqs()
		mod.redraw_bog(current_page)
		mod.add_reqs(current_page)
	end
end

mod.remove_reqs = function()
	local root = core:get_ui_root()
	local pages = find_uicomponent(root, "pj_grudge_book", "book_frame", "pages")
	local rq = find_uicomponent(pages, "requirements_list")
	if rq then rq:Destroy() end
	local details = find_uicomponent(pages, "dy_details_text")
	if details then details:Destroy() end
	local old_seal = find_uicomponent(pages, "pj_grudge_book_seal")
	if old_seal then old_seal:Destroy() end

	local req_text_header = find_uicomponent(pages, "pj_grudge_book_req_header")
	local req_text_text = find_uicomponent(pages, "pj_grudge_book_req_text")
	local req_text_fluff = find_uicomponent(req_text_text, "pj_grudge_book_req_text_fluff")
	if req_text_header and req_text_text and req_text_fluff then
		req_text_header:SetVisible(false)
		req_text_text:SetVisible(false)
		req_text_fluff:SetVisible(false)
	end
end

mod.add_subculture_reqs = function(mission)
	local root = core:get_ui_root()
	local pages = find_uicomponent(root, "pj_grudge_book", "book_frame", "pages")
	local rq = find_uicomponent(pages, "requirements_list")

	local req_text_header = find_uicomponent(pages, "pj_grudge_book_req_header")
	local req_text_text = find_uicomponent(pages, "pj_grudge_book_req_text")
	local req_text_fluff = find_uicomponent(req_text_text, "pj_grudge_book_req_text_fluff")
	if req_text_header and req_text_text and req_text_fluff then
		req_text_header:SetVisible(true)
		req_text_text:SetVisible(true)
		req_text_fluff:SetVisible(true)

		local count = mission.count or mission.rolled_total
		if count == 1 then
			req_text_text:SetStateText(string.format("[[col:black]]Win 1 battle against %s.[[/col]]", common.get_localised_string("cultures_subcultures_name_"..mission.subculture_key)))
		else
			req_text_text:SetStateText(string.format("[[col:black]]Win %d battles against %s.[[/col]]", count, common.get_localised_string("cultures_subcultures_name_"..mission.subculture_key)))
		end
	end
end

mod.get_mission_by_key = function(mission_key)
	if not mod.grudge_missions then return end
	for _, current_mission in ipairs(mod.grudge_missions) do
		if current_mission.mission_key == mission_key then
			return current_mission
		end
	end
end

mod.add_reqs = function(page_num)
	-- dout("ADD REQS")
	local unit_key = mod.bog_pages_list[page_num-1]
	if not unit_key then return end
	local mission_key = mod.unit_key_to_mission_key[unit_key]

	if not mission_key then return end
	local mission = mod.get_mission_by_key(mission_key)
	if mission and mission.subculture_key then
		return mod.add_subculture_reqs(mission)
	end

	local root = core:get_ui_root()
	local rq = find_uicomponent(root, "pj_grudge_book", "book_frame", "pages", "requirements_list")
	if rq then return mod.rearrange_reqs() end

	local treasure_hunts = find_uicomponent(root, "treasure_hunts")
	if not treasure_hunts then
		local treasure_hunts_button = find_uicomponent(root, "hud_campaign", "faction_buttons_docker", "button_group_management", "button_treasure_hunts")
		treasure_hunts_button:SetVisible(true)
		treasure_hunts_button:SimulateLClick()
	end

	cm:callback(function()
		local btn = find_uicomponent(root, "treasure_hunts", "TabGroup", "pieces", "tab_child", "tx_acquired", "acquired_list", mission_key)
		if not btn then
			btn = find_uicomponent(root, "treasure_hunts", "TabGroup", "pieces", "tab_child", "map", "pieces_holder", mission_key)
		end
		if not btn then
			local treasure_hunts_button = find_uicomponent(root, "hud_campaign", "faction_buttons_docker", "button_group_management", "button_treasure_hunts")
			if treasure_hunts_button then treasure_hunts_button:SimulateLClick() end
			return
		end

		btn:SimulateLClick()

		cm:callback(
			function()
				local rq = find_uicomponent(root, "treasure_hunts", "TabGroup", "pieces", "tab_child", "info_panel", "listview", "list_clip", "list_box", "requirements_list")
				if not rq then return end
				local details = find_uicomponent(root, "treasure_hunts", "TabGroup", "pieces", "tab_child", "info_panel", "listview", "list_clip", "list_box", "dy_details_text")
				if not details then return end
				local pages = find_uicomponent(root, "pj_grudge_book", "book_frame", "pages")
				if not pages then return end
				pages:Adopt(rq:Address())
				rq:Adopt(details:Address())

				local treasure_hunts_button = find_uicomponent(root, "hud_campaign", "faction_buttons_docker", "button_group_management", "button_treasure_hunts")
				if treasure_hunts_button then treasure_hunts_button:SimulateLClick() end

				cm:callback(function()
					treasure_hunts_button:SetVisible(false)

					local pages = find_uicomponent(root, "pj_grudge_book", "book_frame", "pages")
					local rq = pages and find_uicomponent(pages, "requirements_list")
					if not rq then return end
					rq:SetDockingPoint(5)
					rq:SetDockOffset(290,230)
					local rq_buttons = find_uicomponent(rq, "dy_requirement_text", "button_holder")
					if rq_buttons then
						rq_buttons:SetVisible(false)
					end

					local rq_x, rq_y = rq:Position()

					local is_completed = false
					local is_failed = false
					local mission_statuses = cm:get_saved_value("ovn_grudge_missions_statuses")
					if mission_statuses then
						is_completed = mission_statuses.success and mission_statuses.success[mission_key]
						is_failed = mission_statuses.failed and mission_statuses.failed[mission_key]
					end
					if is_completed or is_failed then
						local old_seal = find_uicomponent(pages, "pj_grudge_book_seal")
						if old_seal then old_seal:Destroy() end

						local seal = core:get_or_create_component("pj_grudge_book_seal", "ui/ovn_grudge_book/pj_custom_image.twui.xml", pages)
						seal:SetImagePath(is_completed and "ui/ovn_grudge_book/grudge_seal.png" or "ui/ovn_grudge_book/stamp_mission_failed.png", 0)
						seal:SetCanResizeWidth(true)
						seal:SetCanResizeHeight(true)
						if is_completed then
							seal:Resize(127*1.3,194*1.3)
						else
							seal:Resize(170,159)
						end

						seal:SetVisible(true)
						-- seal:SetDockingPoint(8)
						-- seal:SetDockOffset(260,-10)
						seal:MoveTo(rq_x+40+cm:random_number(90,0), rq_y+10+cm:random_number(50,0))
					end

					local details = find_uicomponent(root, "pj_grudge_book", "book_frame", "pages", "dy_details_text")
					if details then
						details:SetDockingPoint(2)
						details:SetDockOffset(0,0)
					end
				end,0)
			end,
			0
		)
	end,0)
end

mod.rearrange_reqs = function()
	local root = core:get_ui_root()
	local rq = find_uicomponent(root, "pj_grudge_book", "book_frame", "pages", "requirements_list")
	if not rq then return end
	rq:SetDockingPoint(5)
	rq:SetDockOffset(290,200)
	local rq_buttons = find_uicomponent(rq, "dy_requirement_text", "button_holder")
	if rq_buttons then
		rq_buttons:SetVisible(false)
	end

	local details = find_uicomponent(root, "pj_grudge_book", "book_frame", "pages", "dy_details_text")
	if details then
		details:SetDockingPoint(5)
		details:SetDockOffset(300,300)
	end
end

mod.create_main_button = function()
	local button_group_management = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management")
	if not button_group_management then return end

	local main_hlf_cooking_button = find_uicomponent(button_group_management, "ovn_grudge_main_button")
	if not main_hlf_cooking_button then
		main_hlf_cooking_button = UIComponent(button_group_management:CreateComponent("ovn_grudge_main_button", "ui/templates/round_large_button"))
		button_group_management:Layout()
	end
	if not main_hlf_cooking_button then return end
	main_hlf_cooking_button:SetVisible(true)
	main_hlf_cooking_button:SetTooltipText("Grudgebringer Ledger||Grudgebinger Units", true)
	main_hlf_cooking_button:SetImagePath("ui/skins/default/icon_book_grudges.png", 0)
end

-- mod.get_mission_unlock_text = function(mission_key)
-- 	if not mod.grudge_missions then return end

-- 	local mission
-- 	for _, current_mission in ipairs(mod.grudge_missions) do
-- 		if current_mission.mission_key == mission_key then
-- 			mission = current_mission
-- 			break
-- 		end
-- 	end

-- 	if not mission then return end

-- 	if mission.subculture_key then

-- 	end
-- end

mod.create_unlock_string = function(unit_key)
	local mission_key = mod.unit_key_to_mission_key[unit_key]
	local mission = mission_key and mod.get_mission_by_key(mission_key)
	if not mission then return end

	if mission.type ~= "DEFEAT_N_ARMIES_OF_FACTION" then return end

	local faction_key = mission.faction_key == "random" and mission.rolled_target or mission.faction_key
	local count = mission.count or mission.rolled_total

	if mission.subculture_key then
		if count == 1 then
			return string.format("[[col:black]]Win 1 battle against %s.[[/col]]", common.get_localised_string("cultures_subcultures_name_"..mission.subculture_key))
		else
			return string.format("[[col:black]]Win %d battles against %s.[[/col]]", count, common.get_localised_string("cultures_subcultures_name_"..mission.subculture_key))
		end
	end

	if count == 1 then
		return string.format("[[col:black]]Win 1 battle against %s.[[/col]]", common.get_localised_string("factions_screen_name_"..faction_key))
	else
		return string.format("[[col:black]]Win %d battles against %s.[[/col]]", count, common.get_localised_string("factions_screen_name_"..faction_key))
	end
end

local function init()
	if cm:get_local_faction_name(true) ~= "ovn_emp_grudgebringers" then
		return
	end

	mod.grudge_missions = cm:get_saved_value("ovn_grudge_missions")

	mod.create_main_button()

	core:remove_listener("pj_grudge_book_ui_click_handlers")
	core:add_listener(
		"pj_grudge_book_ui_click_handlers",
		"ComponentLClickUp",
		function(context)
			return mod.comp_id_to_handler[context.string]
		end,
		function(context)
			mod[mod.comp_id_to_handler[context.string]](context)
		end,
		true
	)

	for unit_key, page_data in pairs(mod.bog_pages) do
		if page_data.unlock then
			page_data.localized_unlock = page_data.unlock()
		else
			local unlock_string = mod.create_unlock_string(unit_key)
			if unlock_string then
				page_data.localized_unlock = unlock_string
			end
		end

		-- if target is subculture cache the fluff text since we need to handle it manually
		local mission_key = mod.unit_key_to_mission_key[unit_key]
		local mission = mission_key and mod.get_mission_by_key(mission_key)
		if mission and mission.subculture_key then
			page_data.localized_fluff_text = common.get_localised_string("missions_localised_description_"..mission_key)
		end
	end

	local root = core:get_ui_root()
	local treasure_hunts_button = find_uicomponent(root, "hud_campaign", "faction_buttons_docker", "button_group_management", "button_treasure_hunts")
	if treasure_hunts_button then treasure_hunts_button:SetVisible(false) end
	-- if treasure_hunts_button then treasure_hunts_button:SetVisible(true) end
end

mod.refresh_toc_row = function(pages, i)
	local row = find_uicomponent(pages, "pj_grudge_book_row_"..i)
	if not row then return end
	local unit_row = find_uicomponent(row, "pj_grudge_book_row_unit_"..i)
	if not unit_row then return end

	if mod.current_bog_page ~= 1 then
		row:SetVisible(false)
		return
	end

	row:SetVisible(true)

	local unit_key = mod.bog_pages_list[i+1] or ""
	local unit_data = mod.bog_pages[unit_key]

	local is_completed = false
	local is_failed = false
	local mission_statuses = cm:get_saved_value("ovn_grudge_missions_statuses")
	if mission_statuses then
		local mission_key = mod.unit_key_to_mission_key[unit_key]
		if mission_key then
			is_completed = mission_statuses.success and mission_statuses.success[mission_key]
			is_failed = mission_statuses.failed and mission_statuses.failed[mission_key]
		end
	end
	if unit_data and unit_data.localized_unlock and not (is_completed or is_failed) then
		local unlock_req_str = "[[col:black]]"..unit_data.localized_unlock.."[[/col]]"
		local req_id = "unit_req_"..unit_key
		local unit_req = find_uicomponent(unit_row, req_id)
		unit_req:SetStateText(unlock_req_str)
	end
end

mod.on_book_of_grudges_repeat = function()
	local root = core:get_ui_root()
	local pages = find_uicomponent(root, "pj_grudge_book", "book_frame", "pages")
	if not pages then return end

	for i=0, #mod.bog_pages_list do
		mod.refresh_toc_row(pages, i)
	end
end

core:remove_listener("ovn_grudge_book_book_of_grudges_real_timer")
core:add_listener(
	"ovn_grudge_book_book_of_grudges_real_timer",
	"RealTimeTrigger",
	function(context)
			return context.string == "ovn_grudge_book_book_of_grudges_real_timer"
	end,
	function()
		mod.on_book_of_grudges_repeat()
	end,
	true
)

mod.destroy_book = function()
	local root = core:get_ui_root()
	real_timer.unregister("ovn_grudge_book_book_of_grudges_real_timer")
	local book = find_uicomponent(root, "pj_grudge_book")
	if book then
		mod.current_bog_page = nil
		book:Destroy()
	end

	-- should already be set invisible in another place but just to be sure
	local treasure_hunts_button = find_uicomponent(root, "hud_campaign", "faction_buttons_docker", "button_group_management", "button_treasure_hunts")
	if treasure_hunts_button then treasure_hunts_button:SetVisible(false) end
end

core:remove_listener("pj_grudge_book_destroy")
core:add_listener(
	"pj_grudge_book_destroy",
	"ComponentLClickUp",
	function(context)
		if context.string ~= "button_ok" then return false end
		local parent_address = UIComponent(context.component):Parent()
		local parent =  parent_address and UIComponent(parent_address)
		return parent and parent:Id() == "pj_grudge_book"
	end,
	function()
		mod.destroy_book()
	end,
	true
)

cm:add_first_tick_callback(function()
	cm:callback(function()
		init()
	end, 1)
end)
if debug.traceback():find('pj_loadfile') then
	init()
	local success, ret = pcall(mod.on_book_of_grudges_panel_opening)
end

-- to enable recuruitment of RANGERS_3:
-- cm:set_saved_value("ovn_grudge_book_RANGER_3_RECRUITMENT", true)

-- local a = find_uicomponent(test, "info_parent", "info_panel")
-- a:SetImagePath("ui/trans.png", 0)
-- test:SetCanResizeHeight(true)
-- test:SetCanResizeWidth(true)
-- test:Resize(333,300)
-- test:SetContextObject(cco("CcoCampaignUnit","454"))
