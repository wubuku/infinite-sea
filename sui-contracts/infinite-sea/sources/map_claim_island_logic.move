#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::map_claim_island_logic {
    use std::option;

    use sui::object::ID;
    use sui::tx_context::TxContext;
    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea_common::map_location_type;
    use infinite_sea_common::sorted_vector_util;

    use infinite_sea::map;
    use infinite_sea::map_location::Self;

    friend infinite_sea::map_aggregate;

    const ELocationTypeMismatch: u64 = 1;
    const EIslandAlreadyClaimed: u64 = 2;
    const ELocationNotFound: u64 = 3;

    public(friend) fun verify(
        coordinates: Coordinates,
        claimed_by: ID,
        claimed_at: u64,
        map: &map::Map,
        ctx: &TxContext,
    ): map::MapIslandClaimed {
        assert!(map::locations_contains(map, coordinates), ELocationNotFound);
        let island = map::borrow_location(map, coordinates);
        assert!(map_location::type(island) == map_location_type::island(), ELocationTypeMismatch);
        assert!(option::is_none(&map_location::occupied_by(island)), EIslandAlreadyClaimed);
        map::new_map_island_claimed(
            map,
            coordinates,
            claimed_by,
            claimed_at
        )
    }

    public(friend) fun mutate(
        map_island_claimed: &map::MapIslandClaimed,
        map: &mut map::Map,
        ctx: &mut TxContext, // modify the reference to mutable if needed
    ) {
        let coordinates = map::map_island_claimed_coordinates(map_island_claimed);
        let claimed_by = map::map_island_claimed_claimed_by(map_island_claimed);
        let claimed_at = map::map_island_claimed_claimed_at(map_island_claimed);
        let island = map::borrow_mut_location(map, coordinates);
        map_location::set_occupied_by(island, option::some(claimed_by));
        sorted_vector_util::remove_all_item_id_quantity_pairs(map_location::borrow_mut_resources(island));
        map_location::set_gathered_at(island, claimed_at);
    }
}
