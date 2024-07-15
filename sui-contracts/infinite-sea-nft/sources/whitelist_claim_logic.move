#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea_nft::whitelist_claim_logic {
    use infinite_sea_nft::whitelist;
    use infinite_sea_nft::whitelist_entry::{Self, WhitelistEntry};
    use sui::tx_context::{Self, TxContext};

    friend infinite_sea_nft::whitelist_aggregate;

    const EGloballyPaused: u64 = 50;
    const ENotInWhitelist: u64 = 51;
    const EAlreadyClaimed: u64 = 52;
    const EPaused: u64 = 53;

    public(friend) fun verify(
        whitelist: &whitelist::Whitelist,
        ctx: &TxContext,
    ): whitelist::WhitelistClaimed {
        let account_address = tx_context::sender(ctx);
        assert!(whitelist::entries_contains(whitelist, account_address), ENotInWhitelist);
        assert!(!whitelist::paused(whitelist), EGloballyPaused);
        let entry = whitelist::borrow_entry(whitelist, account_address);
        assert!(!whitelist_entry::claimed(entry), EAlreadyClaimed);
        assert!(!whitelist_entry::paused(entry), EPaused);
        whitelist::new_whitelist_claimed(
            whitelist,
            account_address,
        )
    }

    public(friend) fun mutate(
        whitelist_claimed: &whitelist::WhitelistClaimed,
        whitelist: &mut whitelist::Whitelist,
        _ctx: &mut TxContext, // modify the reference to mutable if needed
    ) {
        let account_address = whitelist::whitelist_claimed_account_address(whitelist_claimed);
        let entry = whitelist::borrow_mut_entry(whitelist, account_address);
        whitelist_entry::set_claimed(entry, true);
    }

}
