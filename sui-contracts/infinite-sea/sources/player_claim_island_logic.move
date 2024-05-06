#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::player_claim_island_logic {
    use std::option;

    use sui::clock;
    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea_common::roster_status;
    use infinite_sea_common::sorted_vector_util;

    use infinite_sea::map::{Self, Map};
    use infinite_sea::map_aggregate;
    use infinite_sea::map_location;
    use infinite_sea::player;
    use infinite_sea::roster;
    use infinite_sea::roster::RosterTable;
    use infinite_sea::roster_aggregate;

    friend infinite_sea::player_aggregate;

    const ESenderHasNoPermission: u64 = 22;

    public(friend) fun verify(
        map: &mut Map,
        coordinates: Coordinates,
        clock: &Clock,
        roster_table: &mut RosterTable,
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
        roster_table: &mut RosterTable,
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
        sorted_vector_util::merge_item_id_quantity_pairs(inv, map_location::borrow_resources(island));
        // call map_aggregate::claim_island
        map_aggregate::claim_island(map, coordinates, player_id, claimed_at, ctx);

        // create rosters after claiming the island
        let roster_sequence_number: u8 = 0;
        while (roster_sequence_number < 5) {
            // 0-4
            let r = roster_aggregate::create(player_id, roster_sequence_number, roster_status::at_anchor(), 0,
                coordinates, 0, option::none(), option::none(), roster_table, ctx
            );
            roster::share_object(r);
            roster_sequence_number = roster_sequence_number + 1;
        };
    }
}
