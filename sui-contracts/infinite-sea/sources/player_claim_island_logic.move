#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::player_claim_island_logic {
    use std::option;

    use sui::clock;
    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea_common::vector_util;

    use infinite_sea::map::{Self, Map};
    use infinite_sea::map_aggregate;
    use infinite_sea::map_location;
    use infinite_sea::player;

    friend infinite_sea::player_aggregate;

    const ESenderHasNoPermission: u64 = 22;

    public(friend) fun verify(
        map: &mut Map,
        coordinates: Coordinates,
        clock: &Clock,
        player: &player::Player,
        ctx: &TxContext,
    ): player::IslandClaimed {
        assert!(sui::tx_context::sender(ctx) == player::owner(player), ESenderHasNoPermission);
        let claimed_at = clock::timestamp_ms(clock) / 1000;
        player::new_island_claimed(player, coordinates, claimed_at)
    }

    public(friend) fun mutate(
        island_claimed: &player::IslandClaimed,
        map: &mut Map,
        player: &mut player::Player,
        ctx: &mut TxContext, // modify the reference to mutable if needed
    ) {
        let coordinates = player::island_claimed_coordinates(island_claimed);
        let claimed_at = player::island_claimed_claimed_at(island_claimed);
        let player_id = player::id(player);

        player::set_claimed_island(player, option::some(coordinates));
        // move resources from island to player inventory
        let island = map::borrow_location(map, coordinates);
        let inv = player::borrow_mut_inventory(player);
        vector_util::merge_item_id_quantity_pairs(inv, map_location::borrow_resources(island));
        // call map_aggregate::claim_island
        map_aggregate::claim_island(map, coordinates, player_id, claimed_at, ctx);

        let i: u8 = 0;
        while (i < 5) {
            //create rosters
            //todo roster_aggregate::create(player_id, i, roster_status::at_anchor(), 0, vector::empty(), ...)
        };
    }
}
