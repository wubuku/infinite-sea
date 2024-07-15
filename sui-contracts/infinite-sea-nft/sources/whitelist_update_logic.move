module infinite_sea_nft::whitelist_update_logic {
    use infinite_sea_nft::whitelist;
    use sui::tx_context::TxContext;

    friend infinite_sea_nft::whitelist_aggregate;

    public(friend) fun verify(
        paused: bool,
        whitelist: &whitelist::Whitelist,
        ctx: &TxContext,
    ): whitelist::WhitelistUpdated {
        let _ = ctx;
        whitelist::new_whitelist_updated(
            whitelist,
            paused,
        )
    }

    public(friend) fun mutate(
        whitelist_updated: &whitelist::WhitelistUpdated,
        whitelist: &mut whitelist::Whitelist,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let paused = whitelist::whitelist_updated_paused(whitelist_updated);
        let _ = ctx;
        whitelist::set_paused(whitelist, paused);
    }

}
