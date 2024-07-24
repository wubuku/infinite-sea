#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea_map::map_add_island_logic {
    use std::option;

    use sui::tx_context::TxContext;
    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea_common::item_id_quantity_pairs;
    use infinite_sea_common::item_id_quantity_pairs::ItemIdQuantityPairs;
    use infinite_sea_common::map_location_type;

    use infinite_sea_map::map;
    use infinite_sea_map::map_location;

    friend infinite_sea_map::map_aggregate;

    const ELocationAlreadyExists: u64 = 1;

    public(friend) fun verify(
        coordinates: Coordinates,
        resources: ItemIdQuantityPairs,
        map: &map::Map,
        ctx: &TxContext,
    ): map::IslandAdded {
        assert!(!map::locations_contains(map, coordinates), ELocationAlreadyExists);
        map::new_island_added(map, coordinates, resources)
    }

    public(friend) fun mutate(
        island_added: &map::IslandAdded,
        map: &mut map::Map,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let coordinates = map::island_added_coordinates(island_added);
        let resources = map::island_added_resources(island_added);
        let island = map_location::new_map_location(
            coordinates,
            map_location_type::island(),
            option::none(),
            item_id_quantity_pairs::items(&resources),
            0
        );
        map::add_location(map, island);
    }
}
