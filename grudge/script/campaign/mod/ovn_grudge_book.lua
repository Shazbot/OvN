OVN_GRUDGE_BOOK = OVN_GRUDGE_BOOK or {}
local mod = OVN_GRUDGE_BOOK

-- note that find_uicomponent already does a recursive search, should probably get rid of this
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
	rhox_grudgebringer_lh_1 = "ludwig_uberdorf",
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
	luther_flamenstrike = "luther_flamenstrike",
	matthias = "matthias",
	ludwig_uberdorf = "ludwig_uberdorf",
	grail_knights_tristan_de_la_tourtristan_de_la_tour = "grail_knights_tristan_de_la_tourtristan_de_la_tour",
	knights_of_the_realm_bertrand_le_grande = "knights_of_the_realm_bertrand_le_grande",
	imperial_cannon_darius_flugenheim = "imperial_cannon_darius_flugenheim",
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
	"ludwig_uberdorf",
	"ceridan",
	"ice_mage_vladimir_stormbringer",
	"dwarf_envoy",
	"matthias",
	"luther_flamenstrike",
}

mod.bog_pages = {
	morgan_bernhardt = {
	unit_commander_name = "Morgan Bernhardt",
		unit_description = "Bernhardt is the eldest son of Graf Bernhardt of Nuln. His father is a wealthy and influential merchant, who controls the traffic over five bridges, including the Great Drawbridge over the Reik. As per tradition in Nuln, wealthy families send their eldest sons to the Officer Academy of the great Gunnery School. Bernhardt spent four years learning and gained a reputation as a gifted but troublesome student, graduating at the top of every class he bothered to attend. He was attracted to the glamour of the Cavalry and was known to outride the Reikguard Knights who visited at times. However, he was eventually expelled from the academy for gross insubordination, duelling, and misappropriation of college funds. Bernhardt attempted to join the Knightly orders, but all refused him due to his checkered history. He was even denied a place in the Empire Pistoliers. Despite this setback, Bernhardt now leads the famed mercenary army, the Grudgebringers, named after the magical sword wielded by Bernhardt himself. This mighty blade was forged by the Dwarfs and inscribed with magic runes by a Bright Wizard. The sword was gifted to a young Bernhardt in a supposed chance meeting at the alehouse, the Kippered Herring. An ageing Arch Wizard, Darius Redhand III of the Bright College in Altdorf, saw potential in this upstart and knowing his sword's unquenchable thirst for battle bequeathed it to Morgan.When asked what he might do after his mercenary days, Bernhardt speaks of opening a little inn somewhere.",

	},
	grudgebringer_cavalry = {
		unit_commander_name = "Klaus Zimmerman",
		unit_description = "So named after their captain's powerful sword 'Grudgebringer' these mercenaries already command an unsullied respect on their home turf in Reikland. The Grudgebringers have since marched to the troubled Border Princes where they quest for a major campaign to prove themselves worthy of greater fortunes. These mercenary cavalry form the core of the army known as the Grudgebringers. Klaus Zimmerman serves as mentor to Bernhardt and the two men have known each other for some time. When he speaks to Bernhardt of what he might do after his mercenary days Morgan speaks of opening a little inn somewhere.",

	},
	grudgebringer_infantry = {
		unit_commander_name = "Gunther Schepke",
		unit_description = "These highly experienced warriors are led by Sergeant Gunther Schepke, Bernhardt's second-in-command. They are part of the respected mercenary army known as the Grudgebringers and are completely loyal to their Commander. Originally, Schepke was a hard-bitten mercenary commanding a small but extremely tough group known as 'Schepke's Sixteen.' The name came from a now-famous battle at Black Fire Pass when they held off two hundred orcs for hours while the baggage train they guarded retreated into the safety of the Empire. Only sixteen of the initial fifty survived, but every goblin was slain to the last. The mercenaries explained their suicidal defense of the convoy simply by the fact that theirs was a fixed-sum contract, and the money due for fifty now went to a mere sixteen. Not only that, but the gold to pay the mercenaries rested in the rearmost wagons of the convoy - a shrewd move by the convoy's paymaster.",
	},
	grudgebringer_crossbow = {
		unit_commander_name = "Willem Fletcher",
		unit_description = "These expert crossbowmen, who are now mercenaries, have a disreputable past. They originally formed part of a bandit army working in the forests of Talabecland. After a crackdown aided by elite Imperial forces, they fled south to evade capture. They are still on the Empire's wanted list and sought anonymity by joining a legitimate mercenary army. They found themselves a part of the respected Grudgebringers' army.",
	},
	grudgebringer_cannon = {
		unit_commander_name = "Wolfgang Schwartzkopf",
		unit_description = "Top of his marksmanship class at the Nuln Artillery College for a record three years running, Wolgang 'Sureshot' Schwartzkopf instils a winning confidence in the rest of his crew. After proving himself in the field he had a short stint as a lecturer in ballistics before being offered service with an imperial Great Cannon regiment. Headhunted by the Grudgebringers he now leads command of the armies mercenary cannons.",
	},
	ragnar_wolves = {
		unit_commander_name = "Eric Ragnar",
		unit_description = "These warriors originate from the cold and inhospitable lands of Norsca. Frustrated by the lack of opportunity in their homeland, Ragnar and his 'Wolves' have traveled south seeking to offer their services in return for fat Empire purses. Their leader, Eric Ragnar, is a personal friend of Bernhardt. All of Ragnar's men are expert horsemen, skilled in combat, and merciless killers who prefer to run down their enemies to the last man.",
	},
	flagellants_eusebio_the_bleak = {
		unit_commander_name = "Eusebio The Bleak",
		unit_description = "Flagellants are men who have been driven over the edge of sanity by some personal disaster or catastrophe, causing them to travel the Empire and preach their visions of doom and destruction. Their madness endows them with superhuman strength and resilience, and they fight with an outstanding fury that is almost impossible to match. Clad only in tattered robes, flagellants are a fearsome sight to behold.",
	},
	azguz_bloodfist_dwarf_warriors = {
		unit_commander_name = "Azguz Bloodfist",
		unit_description = "Dwarfs are known for their determination and confidence, and they possess immense strength and resilience. However, they are often slower on their feet compared to other races. They will only flee when the situation is dire, and their hatred for Orcs and Goblins makes them even less likely to retreat when facing them in battle.",
	},
	dargrimm_firebeard_dwarf_warriors = {
		unit_commander_name = "Dargrimm Firebeard",
		unit_description = "A regiment of Dwarf Warriors is composed of fierce and relentless fighters, making up the backbone of Dwarf armies. Known for their legendary stubbornness, they are reluctant to flee even in the direst of circumstances. This unwavering determination commands great admiration and respect throughout the Old World.",
	},
	urblab_rotgut_mercenary_ogres = {
		unit_commander_name = "Urblab Rotgut",
		unit_description = "These colossal creatures tower twice the height of an average man and possess a significantly more robust physique. While they may lack intelligence, they compensate with tremendous strength and resilience, engaging in battles with ferocious intensity. Notably, Ogres are notorious for their indifference towards loyalties, fighting for whomever provides them with suitable rewards. Their imposing and intimidating presence instills fear in those who encounter them.",
	},
	elrod_wood_elf_glade_guards = {
		unit_commander_name = "Elrod",
		unit_description = "These warriors are known as Wood Elves and are the protectors of the ancient forest of Loren. They are swift and skilled in combat, using hit-and-run tactics to take down their enemies. They are experts in archery and their skill with a bow is unmatched. Wood Elves are also skilled in magic, often using it to enhance their abilities or to hinder their foes. They are fiercely independent and tend to keep to themselves, but will ally with other races if it serves their purpose.",
	},
	galed_elf_archers = {
		unit_commander_name = "Galed",
		unit_description = "Wood Elf archers are highly skilled in both ranged and melee combat, making them versatile warriors. They are also experts in ambush tactics, using their agility and knowledge of the forest to surprise and overwhelm their enemies. They prefer to wear light armor, allowing them to move quickly and quietly through the forest.",
	},
	helmgart_bowmen = {
		unit_commander_name = "Franz Erikson",
		unit_description = "Helmgart archers are a well-trained and disciplined regiment, who are responsible for the defense of Helmgart Keep. They are known for their proficiency with the standard bow, which has a medium range, and are highly effective at ranged combat. However, due to their focus on archery, they are not as proficient in hand-to-hand combat as other units.",
	},
	keelers_longbows = {
		unit_commander_name = "Johann Keeler",
		unit_description = "Johann Keeler's longbowmen are highly regarded in Averland for their exceptional skills with the longbow. They have honed their craft through participation in numerous provincial archery tournaments and have also gained valuable experience from previous mercenary campaigns. Their longbows have a greater range and accuracy compared to standard bows, making them a deadly force on the battlefield. They are also trained in basic melee combat, but their true strength lies in their ranged capabilities.",
	},
	black_avangers = {
		unit_commander_name = "Ramon Black",
		unit_description = "Ramon Black formed the Avengers after a Skaven raiding party burned their homes and killed their families during an attack on their town of Wissenheim. They are sworn to hunt down and kill Skaven wherever they can find them. Made up from little more than untrained peasants, his band display a gritty determination deserving of any mercenary army.",
	},
	carlsson_guard = {
		unit_commander_name = "Captain Bernard",
		unit_description = "Captain Bernard commands the Carlsson Guard who form the regional police of Carlsson's land. Although not intensely trained or particularly well equipped they are very loyal and proud to serve their respected patron Sven Carlsson.",
	},
	carlsson_cavalry = {
		unit_commander_name = "Sven Carlsson",
		unit_description = "These warriors form part of the militia commanded by the Border Prince and former mercenary Sven Carlsson, a personal friend of Bernhardt. They ride into battle on mighty warhorses and are proficient in combat.",
		unlock = function()
			return string.format("Foil the known Skaven collaborator Otto Hiln.")
		end
	},
	vannheim_75th = {
		unit_commander_name = "Siegfried Vannheim",
		unit_description = "Siegfried Vannheim is a well-renowned mercenary captain who has worked all through the Old World and beyond while leading the 75th. Reputably a staunch disciplinarian, Vannheim is followed by his troops with faithful loyalty and respect for his veteran experience in the trade.",
	},
	treeman_knarlroot = {
		unit_commander_name = "Knarlfoot",
		unit_description = "These extremely large creatures are incredibly strong and tough, fighting with great skill and ferocity. However, their dry woody skin suffers great damage if burned, so fire is their greatest enemy. Knarlfoot is among the mightiest of Loren's denizens, his gnarled form is almost impervious to harm, and his strength a near match for even a Jabberslythe.",
	},
	treeman_gnarl_fist = {
		unit_commander_name = "Gnarl Fist",
		unit_description = "Treemen are very large and powerful creatures as old as the forests themselves. Completely intolerant of anyone who threatens their beloved forests, they are firm allies of the Wood Elves. These 'Guardians of the Forest' are said to communicate with the trees through the whispering of the leaves and the creaking of branches.",
	},
	uter_blomkwist_imperial_mortar = {
		unit_commander_name = "Uter Blomkwist",
		unit_description = "This machine fires explosive shells high into the air, sending them crashing into enemy ranks. It has an extremely long range and can shoot over obstacles and terrain as the shell is fired in an arc, but it is progressively more inaccurate the further it fires. Armour provides no protection against hits from a Mortar. ",
	},
	countess_guard = {
		unit_commander_name = "Heinz Klemper",
		unit_description = "Halberdiers, like all the Empire's infantry, are highly trained and proficient fighters. The halberds they wield are heavy weapons which hit with great force. These Halberdiers are tasked with the personal protection of Countess Isabella Von Liberhurtz, cousin to Emperor Karl Franz and as such are veterans of many campaigns.",
	},
	dieter_schaeffer_carroburg_greatswords = {
		unit_commander_name = "Dieter Schaeffer",
		unit_description = "The fame of the Carroburg Greatswords dates back to the Age of Three Emperors. In 1865 IC, they successfully defended the city of Carroburg, then under the control of Reikland, from the count of Middenland. Throughout the course of the battle, their white uniforms were stained red with blood. Since then, they have worn crimson uniforms.",
	},
	jurgen_muntz_outlaw_infantry = {
		unit_commander_name = "Jurgen Muntz",
		unit_description = "Under the influence of their leader, Jurgen Muntz, these highly trained warriors abandoned the Empire to fight outside the law for greater material gain.",
	},
	boris_von_raukov_4th_nuln_halberdiers = {
		unit_commander_name = "Boris Von Raukov", 
		unit_description = "The eight son of Valmir von Raukov the elector count of Ostland, Boris left his homeland for Nuln seeking glory and distinction as an officer in the forces of the Empire. No doubt assisted by his noble bloodline, his youthful enthusiasm has secured him a position of command over this regiment of Halberdiers.",
	},
	stephan_weiss_outlaw_pistoliers = {
		unit_commander_name = "Stephen Weiss",
		unit_description = "These young mercenaries are fairly inexperienced, but make an exceptional rapid response force. Under the guidance of their disillusioned leader they have abandoned the Empire to fight outside the law. In combat their skills are average but they carry pistols, which only have a very short range yet are powerful enough to penetrate most armour.",
	},
	imperial_cannon_darius_flugenheim = {
		unit_commander_name = "Darius Flugenheim",
		unit_description = "This machine fires heavy cannonballs which can tear through enemy regiments and light buildings with ease, but is progressively more inaccurate the further it fires. Its enormously long range is only equalled by Orc Rock Lobbers.",
	},
	grail_knights_tristan_de_la_tourtristan_de_la_tour = {
		unit_commander_name = "Tristan De La Tour",
		unit_description = "Having sipped from the grail itself, these Knights are the most powerful of all the Knights of Bretonnia. Their skill in combat is extraordinary and they fight determinedly. Grail Knights know no fear and are immune to such types of psychology. ",
	},
	knights_of_the_realm_bertrand_le_grande = {
		unit_commander_name = "Bertrand Le Grande",
		unit_description = "These Knights belong to the most numerous of the Bretonnian orders of chivalry. They ride into battle on powerful Bretonnian warhorses and are highly skilled in combat.",
	},
	ludwig_uberdorf = {
		unit_commander_name = "Ludwig Uberdorf",
		unit_description = "This machine is in effect a mobile cannon and is very heavily armoured. This steam tank, The Emperor's Wrath has recently been to the Engineer's College in Altdorf for overhauling. It has been repaired and refitted back to a Conqueror Class configuration. Now returned to active duty, the Emperor's Wrath has been instrumental in aiding Graf Boris Todbringer's ongoing battles in the Drakwald forest but has now been sent to retake the Blighted Towers in Stirland. To this day, it strikes terror into the hearts of the enemy. The current tank commander is the combat engineer Ludwig von Uberdorf",
		unlock = function()
			return string.format("Enter Flensburg.")
		end
	},
	ceridan = {
		unit_commander_name = "Ceridan",
		unit_description = "After many years in the Black Mountains Ceridan, a lone Elf Ranger has learned of valuable information which has fallen into Skaven possession. Troubled by recent Skaven efforts to capture him he now seeks assistance on a quest handed down through generations of his family.",
		unlock = function()
			return string.format("Enter Kings Glade, Loren.")
		end
	},
	ice_mage_vladimir_stormbringer = {
		unit_commander_name = "Vladimir Stormbringer",
		unit_description ="Vladimir is an Ice Mage to Tzarina Katarin Bokha, the Ice Queen of Kislev. He wields Ice Magic, a form of Magic native to Kislev that centres around deadly spells of ice and cold. Since the days of Tzarina Shoika men have been banned from wielding magic in Kislev for claims a male Ice Witch will one day taint the flow of Ice Magic, changing it forever. It is most unusual not only for Vladimir to be allowed to wield this magic but to actually serve the Tzarina. While his notoriety as an Ice Mage is not publicly spoken of his reputation is well known, even throughout the Empire. It is a badly kept secret that would see him killed by the Ice Witches if not for Tzarina's protection. But why does Katarin break with tradition? Has she scried into the depths of her crystals and foreseen something unspeakable?",
			unlock = function()
			return string.format("Enter Vitevo, Kislev.")
		end,
		unlock_delta = {0,45}
	},
	dwarf_envoy = {
		unit_commander_name = "Engrol Goldtongue",
		unit_description = "Engrol Goldtongue is the official Dwarf Envoy from the fortress of Zhufbar. His skills in diplomacy are unnaturally proficient for a Dwarf and he has resolved many quarrels with the Empire in his career which spans over two centuries.",
		unlock = function()
			return string.format("Enter Zhufbar.")
		end
	},
	matthias = {
		unit_commander_name = "Matthias",
		unit_description = "Matthias, a Witch Hunter General, works tirelessly to eradicate heresy in the Empire, be it men, women or children. Not everyone approves of his 'zeal', including Morgan Bernhardt, but most accept his firebrand fanaticism is more than necessary.",
		unlock = function()
			return string.format("Enter Altdorf, Reikland.")
		end,
		unlock_delta = {0,-20}
	},
	luther_flamenstrike = {
		unit_commander_name = "Luther Flamestrike",
		unit_description = "Stubborn and egotistical, Luther Flamestrike also has a fiery temper to complement his magical abilities. He was exiled from the Bright College in Nuln after an argument with a colleague caused a firestorm which destroyed a tavern and set the surrounding buildings ablaze. Luther is a competent wizard but prone to. Flamestrike now wanders the lands gladly offering his services as a master of the magic arts... for a 'reasonable price'.",
		unlock = function()
			return string.format("Enter Averheim.")
		end
	},
}

mod.grudge_map_component_ids = {}
for mission_key in pairs(mod.mission_key_to_unit_key) do
	mod.grudge_map_component_ids["pj_grudge_book_map_"..mission_key] = true
end

mod.get_num_valid_bog_pages = function()
	local num_pages = 0
	for _, page_data in pairs(mod.bog_pages) do
		if not page_data.predicate or page_data.predicate() then
			num_pages = num_pages + 1
		end
	end
	return num_pages+2
end

mod.get_bog_page = function(page_num)
	local page_index = 0
	for _, page_data in pairs(mod.bog_pages) do
		if not page_data.predicate or page_data.predicate() then
			page_index = page_index + 1
			if page_index == page_num-2 then
				return mod.bog_pages[mod.bog_pages_list[page_index]]
			end
		end
	end
	return nil
end

--- Current index of the Book of grudges page on the left, tracked to know when to refresh the BoG UI.
mod.current_bog_page = nil

--- Keep track of currently visible BoG UI components so we can hide them when turning pages.
mod.current_bog_comps = {}

mod.create_map = function()
	local book_of_grudges = digForComponent(core:get_ui_root(), "pj_grudge_book")
	local book_frame = find_uicomponent(book_of_grudges, "book_frame")
	book_frame:SetImagePath("ui/ovn_grudge_book/book_bg.png", 1)
	local pages = digForComponent(book_of_grudges, "pages")

	local map = core:get_or_create_component("pj_grudge_book_map", "ui/ovn_grudge_book/pj_custom_image.twui.xml", pages)
	map:SetImagePath("ui/ovn_grudge_book/wh3_map.png", 0)
	map:SetCanResizeWidth(true)
	map:SetCanResizeHeight(true)
	map:Resize(1093,725)
	map:SetVisible(true)
	map:SetDockingPoint(1)
	map:SetDockOffset(120,45)

	mod.add_missions_to_map()
end

mod.create_toc = function()
	-- dout("CREATE TOC")
	local book_of_grudges = digForComponent(core:get_ui_root(), "pj_grudge_book")
	local book_frame = find_uicomponent(book_of_grudges, "book_frame")
	book_frame:SetImagePath("ui/ovn_grudge_book/book_bg.png", 1)
	local pages = find_uicomponent(book_frame, "pages")
	local dy_objective = digForComponent(book_of_grudges, "dy_objective")
	local mission_statuses = cm:get_saved_value("ovn_grudge_missions_statuses")
	local current_x = 140
	local current_y = 30
	for i=0, #mod.bog_pages_list-1 do
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
					req = UIComponent(dy_objective:CopyComponent(req_id))
					obj:Adopt(req:Address())
					req:SetDockingPoint(1)
					req:SetDockOffset(25,18)
				end

				req:SetStateText(unlock_req_str)
				req:SetVisible(true)
				req:SetInteractive(false)
			end,0)
		end

		local banner_id = "banner_"..unit_key
		cm:callback(function()
			local banner = core:get_or_create_component(banner_id, "ui/ovn_grudge_book/pj_custom_image.twui.xml", obj)
			banner:SetImagePath('ui/ovn_grudge_book/banners/'..unit_key..'.png', 0)
			banner:SetCanResizeWidth(true)
			banner:SetCanResizeHeight(true)
			banner:Resize(40,40)
			banner:SetDockingPoint(4)
			banner:SetDockOffset(-35,4)
			banner:SetVisible(true)
			banner:SetInteractive(false)
		end,0)

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
		line = line..(i+3).."[[/col]]"
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
		"pj_grudge_book_map",
	}) do
		local comp = find_uicomponent(pages, comp_id)
		if comp then comp:SetVisible(page_num ~= 1 and page_num ~= 2) end
	end
	for _, comp_id in ipairs({
		"pj_grudge_book_map",
	}) do
		local comp = find_uicomponent(pages, comp_id)
		if comp then comp:SetVisible(page_num == 2) end
	end

	local toc_button = core:get_or_create_component("pj_grudge_book_toc_button", "ui/templates/round_small_button.twui.xml", book_of_grudges)
	toc_button:SetImagePath("ui/skins/default/icon_menu.png", 0)
	toc_button:SetVisible(true)
	toc_button:SetDockingPoint(2)
	toc_button:SetDockOffset(-137,14)
	toc_button:SetTooltipText("Table of Contents", true)

	local map_button = core:get_or_create_component("pj_grudge_book_map_button", "ui/templates/round_small_button.twui.xml", book_of_grudges)
	map_button:SetImagePath("ui/skins/default/icon_small_tactical_map.png", 0)
	map_button:SetVisible(true)
	map_button:SetDockingPoint(2)
	map_button:SetDockOffset(137,14)
	map_button:SetTooltipText("Map", true)

	if page_num == 1 then
		return mod.create_toc()
	end
	if page_num == 2 then
		return mod.create_map()
	end

	local page_data = mod.get_bog_page(page_num)
	if not page_data then return end
	local desc = page_data.unit_description or mod.page_defaults.unit_description

	local is_left_page = true
	local list = left_list

	local pages = find_uicomponent(root, "pj_grudge_book", "book_frame", "pages")
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

	local unit_key = mod.bog_pages_list[page_num-2]

	local banner = core:get_or_create_component("pj_grudge_book_banner", "ui/ovn_grudge_book/pj_custom_image.twui.xml", pages)
	banner:SetImagePath(page_data.unit_banner or ('ui/ovn_grudge_book/banners/'..unit_key..'.png'), 0)
	banner:SetCanResizeWidth(true)
	banner:SetCanResizeHeight(true)
	banner:Resize(190*1.3,200*1.3)
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
	head3:SetImagePath(page_data.unit_commander or ("ui/ovn_grudge_book/wh2/gru_cmdr_name.png"), 0)
	head3:SetCanResizeWidth(true)
	head3:SetCanResizeHeight(true)
	head3:Resize(339*0.62,70*0.62)
	head3:SetVisible(true)
	head3:SetDockingPoint(2)
	head3:SetDockOffset(400,270)

	local head2 = core:get_or_create_component("pj_grudge_book_head_bg", "ui/ovn_grudge_book/pj_custom_image.twui.xml", pages)
	head2:SetImagePath(page_data.unit_commander or ("ui/ovn_grudge_book/wh2/gru_cmdr_frame.png"), 0)
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
	local unit_key = mod.bog_pages_list[page_num-2]
	unit_info:SetVisible(true)
	unit_info:SetDockingPoint(1)
	unit_info:SetDockOffset(-298,150)
	if unit_key then
		unit_info:SetContextObject(cco("CcoMainUnitRecord",unit_key))
		unit_info:SetContextObject(cco("CcoUnitDetails","UnitRecord_"..unit_key.."_ovn_emp_grudgebringers_0_0.8"))
		
		---@type CA_CHAR
		for _,char in model_pairs(cm:get_faction(cm:get_local_faction_name(true)):character_list()) do
			if char:character_subtype_key() == unit_key then
				unit_info:SetContextObject(cco("CcoCampaignCharacter",char:cqi()))
				break
			end
			if char:has_military_force() and not char:military_force():is_armed_citizenry() then
				---@type CA_UNIT
				for _,unit in model_pairs(char:military_force():unit_list()) do
					if unit:unit_key() == unit_key then
						unit_info:SetContextObject(cco("CcoCampaignUnit",unit:command_queue_index()))
						break
					end
				end
			end
		end
	end

	if not unit_desc or not unit then
		if dout then dout("ERROR: OBJ OR HEADER MISSING!") end
		return
	end

	unit_desc:SetStateText("[[col:black]]"..desc.."[[/col]]")
	unit_desc:SetVisible(true)
	cm:callback(function()
		unit_desc:Resize(480, 96)
		unit_desc:MoveTo(x+630+10, y+300)
	end,0)
	table.insert(mod.current_bog_comps, unit_desc)

	local unit_commander_id = "pj_grudge_book_unit_commander"
	local unit_commander = digForComponent(book_of_grudges, unit_commander_id)
	if not unit_commander and dy_objective_bold then
		unit_commander = UIComponent(dy_objective_bold:CopyComponent(unit_commander_id))
		pages:Adopt(unit_commander:Address())
		unit_commander:SetCanResizeWidth(true)
		unit_commander:SetCanResizeHeight(false)
	end
	if unit_commander then
		unit_commander:SetVisible(true)
		unit_commander:SetStateText("[[col:white]]"..(page_data.unit_commander_name or mod.page_defaults.unit_commander_name).."[[/col]]")
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
	pj_grudge_book_map_button = "on_map_button_clicked",
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

mod.on_map_button_clicked = function(context)
	mod.go_to_page(2)
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
		mod.go_to_page(tonumber(string.sub(context.string,20,#context.string))+3)
	end,
	true
)

core:remove_listener("pj_grudge_book_on_map_banner_click")
core:add_listener(
	"pj_grudge_book_on_map_banner_click",
	"ComponentLClickUp",
	function(context)
		return mod.grudge_map_component_ids[context.string]
	end,
	function(context)
		local mission_key = string.sub(context.string,20,#context.string)
		for i, unit_key in ipairs(mod.bog_pages_list) do
			local current_mission_key = mod.unit_key_to_mission_key[unit_key]
			if current_mission_key and current_mission_key == mission_key then
				return mod.go_to_page(i+2)
			end
		end
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

	if page_num == 1 or page_num == 2 or mod.get_bog_page(page_num) then
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
	if not pages then
        return--break safe return
	end
	local rq = find_uicomponent(pages, "requirements_list")
	if rq then rq:Destroy() end
	local details = find_uicomponent(pages, "dy_details_text")
	if details then details:Destroy() end
	local old_seal = find_uicomponent(pages, "pj_grudge_book_seal")
	if old_seal then old_seal:Destroy() end

	local req_text_header = find_uicomponent(pages, "pj_grudge_book_req_header")
	local req_text_text = find_uicomponent(pages, "pj_grudge_book_req_text")
	if not req_text_text then
        return--break safe return
	end
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

mod.clone_reqs = function(mission_key)
	local root = core:get_ui_root()
	local rq = find_uicomponent(root, "treasure_hunts", "TabGroup", "pieces", "tab_child", "info_panel", "listview", "list_clip", "list_box", "requirements_list")
	if not rq then return end
	local details = find_uicomponent(root, "treasure_hunts", "TabGroup", "pieces", "tab_child", "info_panel", "listview", "list_clip", "list_box", "dy_details_text")
	if not details then return end
	local pages = find_uicomponent(root, "pj_grudge_book", "book_frame", "pages")
	if not pages then return end
	pages:Adopt(rq:Address())
	rq:Adopt(details:Address())

	local treasure_hunts_button = find_uicomponent(root, "hud_campaign", "faction_buttons_docker", "button_group_management", "button_treasure_hunts")
	if not treasure_hunts_button then
		treasure_hunts_button = find_uicomponent(root, "button_treasure_hunts")
	end
	if treasure_hunts_button then treasure_hunts_button:SimulateLClick() end

	cm:callback(function()
		-- treasure_hunts_button:SetVisible(false)

		local pages = find_uicomponent(root, "pj_grudge_book", "book_frame", "pages")
		local rq = pages and find_uicomponent(pages, "requirements_list")
		if not rq then return end

		local offset_x, offset_y = 0, 0
		local unit_key = mod.mission_key_to_unit_key[mission_key]
		local unit_data = unit_key and mod.bog_pages[unit_key]
		if unit_data and unit_data.unlock_delta then
			offset_x, offset_y = unit_data.unlock_delta[1], unit_data.unlock_delta[2]
		end

		rq:SetDockingPoint(5)
		rq:SetDockOffset(290+offset_x,210+offset_y)
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
end

mod.add_missions_to_map = function()
	-- pieces of 8 map dimensions are 402,313 so offsets are relative to that
	local po8w = 402
	local po8h = 313

	-- dout("ADD REQS")
	local root = core:get_ui_root()
	local book_of_grudges = find_uicomponent(root, "pj_grudge_book")
	local pages = find_uicomponent(book_of_grudges, "pages")
	local map = find_uicomponent(pages, "pj_grudge_book_map")

	local treasure_hunts = find_uicomponent(root, "treasure_hunts")
	if not treasure_hunts then
		local treasure_hunts_button = find_uicomponent(root, "hud_campaign", "faction_buttons_docker", "button_group_management", "button_treasure_hunts")
		if treasure_hunts_button then		
			root:Adopt(treasure_hunts_button:Address())
			treasure_hunts_button:MoveTo(-100,-100)
		end
		if not treasure_hunts_button then
			treasure_hunts_button = find_uicomponent(root, "button_treasure_hunts")
		end
		if not treasure_hunts_button then return end
		treasure_hunts_button:SetVisible(true)
		treasure_hunts_button:SimulateLClick()
		-- treasure_hunts_button:Resize(1,1)
	end
	
	local map_w, map_h = 1090,700

	cm:callback(function()
		local pieces_tab = find_uicomponent(root, "treasure_hunts", "TabGroup", "pieces")
		pieces_tab:SimulateLClick()

		cm:callback(function()
			for i, unit_key in ipairs(mod.bog_pages_list) do
				local mission_key = mod.unit_key_to_mission_key[unit_key]

				if mission_key then
					local btn = find_uicomponent(root, "treasure_hunts", "TabGroup", "pieces", "tab_child", "map", "pieces_holder", mission_key)
					if btn then
						local orig_offset_x, orig_offset_y = btn:GetDockOffset()
						local normalized_offset_x, normalized_offset_y = orig_offset_x/po8w, orig_offset_y/po8h


						local head = core:get_or_create_component("pj_grudge_book_map_"..mission_key, "ui/ovn_grudge_book/pj_custom_image.twui.xml", map)
						head:SetImagePath('ui/ovn_grudge_book/banners/'..unit_key..'.png', 0)
						head:SetCanResizeWidth(true)
						head:SetCanResizeHeight(true)
						head:Resize(190*0.35,200*0.35)
						head:SetVisible(true)
						head:SetDockingPoint(1)
						head:SetDockOffset(map_w*normalized_offset_x, map_h*normalized_offset_y)
						head:SetTooltipText(common.get_localised_string("land_units_onscreen_name_"..unit_key), true)
					end
				end
			end

			local treasure_hunts_button = find_uicomponent(root, "button_treasure_hunts")
			if not treasure_hunts_button then return end
			treasure_hunts_button:SimulateLClick()
			cm:callback(function()
				local treasure_hunts_button = find_uicomponent(root, "treasure_hunts") and find_uicomponent(root, "button_treasure_hunts")
				if treasure_hunts_button then treasure_hunts_button:SimulateLClick() end
			end,0)
		end,0)
	end,0)
end

mod.add_reqs = function(page_num)
	-- dout("ADD REQS")
	local unit_key = mod.bog_pages_list[page_num-2]
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
		if treasure_hunts_button then		
			root:Adopt(treasure_hunts_button:Address())
			treasure_hunts_button:MoveTo(-100,-100)
		end
		if not treasure_hunts_button then
			treasure_hunts_button = find_uicomponent(root, "button_treasure_hunts")
		end
		if not treasure_hunts_button then return end
		treasure_hunts_button:SetVisible(true)
		treasure_hunts_button:SimulateLClick()
	end
	
	cm:callback(function()
		local pieces_tab = find_uicomponent(root, "treasure_hunts", "TabGroup", "pieces")
		pieces_tab:SimulateLClick()

		cm:callback(function()
			local btn = find_uicomponent(root, "treasure_hunts", "TabGroup", "pieces", "tab_child", "tx_acquired", "acquired_list", mission_key)
			if not btn then
				btn = find_uicomponent(root, "treasure_hunts", "TabGroup", "pieces", "tab_child", "map", "pieces_holder", mission_key)
			end
			if not btn then
				local treasure_hunts_button = find_uicomponent(root, "hud_campaign", "faction_buttons_docker", "button_group_management", "button_treasure_hunts")
				if not treasure_hunts_button then
					treasure_hunts_button = find_uicomponent(root, "button_treasure_hunts")
				end
				if treasure_hunts_button then treasure_hunts_button:SimulateLClick() end
				-- cm:callback(function()
				-- 	dout("TRY")
				-- 	mod.add_reqs(page_num)
				-- end, 0)
				return
			end

			btn:SimulateLClick()

			cm:callback(
				function()
					mod.clone_reqs(mission_key)
				end,
				0
			)
		end,0)
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
		details:SetDockOffset(300,280)
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
			return string.format("Win 1 battle against %s.", common.get_localised_string("cultures_subcultures_name_"..mission.subculture_key))
		else
			return string.format("Win %d battles against %s.", count, common.get_localised_string("cultures_subcultures_name_"..mission.subculture_key))
		end
	end

	if count == 1 then
		return string.format("Win 1 battle against %s.", common.get_localised_string("factions_screen_name_"..faction_key))
	else
		return string.format("Win %d battles against %s.", count, common.get_localised_string("factions_screen_name_"..faction_key))
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
	if treasure_hunts_button then		
		root:Adopt(treasure_hunts_button:Address())
		treasure_hunts_button:MoveTo(-100,-100)
	end
	if not treasure_hunts_button then
		treasure_hunts_button = find_uicomponent(root, "button_treasure_hunts")
	end
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
		local unlock_req_str = "[[col:black]]To Unlock: [[//col]][[col:ancillary_unique]]"..unit_data.localized_unlock.."[[/col]]"
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
