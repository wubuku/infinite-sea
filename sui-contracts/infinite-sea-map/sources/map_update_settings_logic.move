#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea_map::map_update_settings_logic {
    use std::option;

    use sui::tx_context::TxContext;

    use infinite_sea_map::map;

    friend infinite_sea_map::map_aggregate;

    public(friend) fun verify(
        for_nft_holders_only: bool,
        map: &map::Map,
        _ctx: &TxContext,
    ): map::MapSettingsUpdated {
        map::new_map_settings_updated(
            map,
            for_nft_holders_only,
        )
    }

    public(friend) fun mutate(
        map_settings_updated: &map::MapSettingsUpdated,
        map: &mut map::Map,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let for_nft_holders_only = map::map_settings_updated_for_nft_holders_only(map_settings_updated);
        map::set_for_nft_holders_only(map, option::some(for_nft_holders_only));
    }
}
