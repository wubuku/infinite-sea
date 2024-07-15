module infinite_sea_nft::whitelist_update_logic {
    use infinite_sea_nft::whitelist;
    use sui::tx_context::TxContext;

    friend infinite_sea_nft::whitelist_aggregate;

    public(friend) fun verify(
        whitelist: &whitelist::Whitelist,
        ctx: &TxContext,
    ): whitelist::WhitelistUpdated {
        let _ = ctx;
        whitelist::new_whitelist_updated(
            whitelist,
        )
    }

    public(friend) fun mutate(
        _whitelist_updated: &whitelist::WhitelistUpdated,
        _whitelist: &mut whitelist::Whitelist,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let _ = ctx;
    }

}
