module infinite_sea_nft::avatar_change_delete_logic {
    use infinite_sea_nft::avatar_change;
    use sui::tx_context::TxContext;

    friend infinite_sea_nft::avatar_change_aggregate;

    public(friend) fun verify(
        avatar_change: &avatar_change::AvatarChange,
        ctx: &TxContext,
    ): avatar_change::AvatarChangeDeleted {
        let _ = ctx;
        avatar_change::new_avatar_change_deleted(
            avatar_change,
        )
    }

    public(friend) fun mutate(
        avatar_change_deleted: &avatar_change::AvatarChangeDeleted,
        avatar_change: avatar_change::AvatarChange,
        ctx: &TxContext, // modify the reference to mutable if needed
    ): avatar_change::AvatarChange {
        let avatar_id = avatar_change::avatar_id(&avatar_change);
        let _ = ctx;
        let _ = avatar_id;
        let _ = avatar_change_deleted;
        avatar_change
    }

}
