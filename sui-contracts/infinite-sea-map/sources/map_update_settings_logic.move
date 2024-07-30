#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea_map::map_update_settings_logic {
    use std::option;

    use sui::tx_context::TxContext;

    use infinite_sea_map::map;

    friend infinite_sea_map::map_aggregate;

    public(friend) fun verify(
        claim_island_setting: u8,
        map: &map::Map,
        _ctx: &TxContext,
    ): map::MapSettingsUpdated {
        map::new_map_settings_updated(
            map,
            claim_island_setting,
        )
    }

    public(friend) fun mutate(
        map_settings_updated: &map::MapSettingsUpdated,
        map: &mut map::Map,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let claim_island_setting = map::map_settings_updated_claim_island_setting(map_settings_updated);
        map::set_claim_island_setting(map, option::some(claim_island_setting));
    }
}
