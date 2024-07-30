#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea_map::map_remove_from_whitelist_logic {
    use sui::table;
    use sui::tx_context::TxContext;

    use infinite_sea_map::map;

    friend infinite_sea_map::map_aggregate;

    public(friend) fun verify(
        account_address: address,
        map: &map::Map,
        ctx: &TxContext,
    ): map::UnWhitelistedForClaimingIsland {
        map::new_un_whitelisted_for_claiming_island(
            map,
            account_address
        )
    }

    public(friend) fun mutate(
        un_whitelisted_for_claiming_island: &map::UnWhitelistedForClaimingIsland,
        map: &mut map::Map,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let account_address = map::un_whitelisted_for_claiming_island_account_address(
            un_whitelisted_for_claiming_island
        );
        let whitelist = map::borrow_mut_claim_island_whitelist(map);
        if (table::contains(whitelist, account_address)) {
            table::remove(whitelist, account_address);
        }
    }
}
