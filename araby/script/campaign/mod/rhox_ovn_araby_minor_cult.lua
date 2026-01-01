local target_minor_cults={
    mc_assassins=true,
    mc_black_ark=true,
    mc_carnival_of_chaos=true,
    mc_chaos_portal=true,
    mc_crimson_plague=true,
    mc_crimson_skull=true,
    mc_cult_of_exquisite_cadaver=true,
    mc_cult_of_painted_skin=true,
    mc_cult_of_pleasure=true,
    mc_cult_of_possessed=true,
    mc_cult_of_shallya=true,
    mc_cult_of_yellow_fang=true,
    mc_dark_gift=true,
    mc_doomsphere=true,
    mc_dwarf_builders=true,
    mc_dwarf_miners=true,
    mc_dwarf_rangers=true,
    mc_elven_enclave=true,
    mc_forge_of_hashut=true,
    mc_ogre_mercs=true,
    mc_order_sacred_scythe=true,
    mc_peg_street_pawnshop=true,
    mc_purple_hand=true,
    mc_sartosan_vault=true,
    mc_silver_pinnacle=true,
    mc_the_cabal=true,
    mc_tilean_traders=true,
    mc_warpstone_meteor=true,
    mc_witch_hunters=true,
}




for i = 1, #MINOR_CULT_LIST do
    if target_minor_cults[MINOR_CULT_LIST[i].key] then
        MINOR_CULT_LIST[i].cult.valid_subcultures["ovn_sc_arb_araby"]=true
    end
end
