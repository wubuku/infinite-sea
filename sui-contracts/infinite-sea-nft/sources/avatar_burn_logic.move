module infinite_sea_nft::avatar_burn_logic {
    use infinite_sea_nft::avatar;
    use sui::tx_context::TxContext;

    friend infinite_sea_nft::avatar_aggregate;

    public(friend) fun verify(
        avatar: &avatar::Avatar,
        ctx: &TxContext,
    ): avatar::AvatarBurned {
        let _ = ctx;
        avatar::new_avatar_burned(
            avatar,
        )
    }

    public(friend) fun mutate(
        avatar_burned: &avatar::AvatarBurned,
        avatar: avatar::Avatar,
        ctx: &TxContext, // modify the reference to mutable if needed
    ): avatar::Avatar {
        let id = avatar::id(&avatar);
        let _ = ctx;
        let _ = id;
        let _ = avatar_burned;
        avatar
    }

}
