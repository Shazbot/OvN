local target_minor_cults={
    mc_carnival_of_chaos=true,
    mc_chaos_portal=true,
    mc_crimson_plague=true,
    mc_crimson_skull=true,
    mc_cult_of_pleasure=true,
    mc_doomsphere=true,
    mc_forge_of_hashut=true,
    mc_ogre_mercs=true,
    mc_purple_hand=true,
    mc_the_cabal=true,
    mc_underworld_sea=true
}




for i = 1, #MINOR_CULT_LIST do
    if target_minor_cults[MINOR_CULT_LIST[i].key] then
        MINOR_CULT_LIST[i].cult.valid_subcultures["ovn_sc_fim_fimir"]=true
    end
end
