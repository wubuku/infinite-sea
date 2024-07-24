#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea_map::map_gather_island_resources_logic {
    use std::bcs;
    use std::option;
    use std::vector;

    use sui::clock;
    use sui::clock::Clock;
    use sui::object;
    use sui::object::ID;
    use sui::tx_context::TxContext;
    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea_common::item_id;
    use infinite_sea_common::item_id_quantity_pairs;
    use infinite_sea_common::item_id_quantity_pairs::ItemIdQuantityPairs;
    use infinite_sea_common::map_location_type;
    use infinite_sea_common::ts_random_util;

    use infinite_sea_map::map;
    use infinite_sea_map::map::Map;
    use infinite_sea_map::map_location;
    use infinite_sea_map::map_util;

    friend infinite_sea_map::map_aggregate;


    const EResourceNotRegeneratedYet: u64 = 5;

    const ELocationNotFound: u64 = 10;
    const ELocationNotAnIsland: u64 = 11;
    const EIslandNotOccupied: u64 = 12;
    const EPlayerIsNotIslandOwner: u64 = 13;

    public(friend) fun verify(
        player_id: ID, //player: &mut Player,
        coordinates: Coordinates,
        clock: &Clock,
        map: &map::Map,
        ctx: &TxContext,
    ): map::IslandResourcesGathered {
        assert_player_is_island_owner(player_id, coordinates, map);
        let now_time = clock::timestamp_ms(clock) / 1000;
        let resources_quantity = map_util::get_island_resources_quantity_to_gather(map, coordinates, now_time);
        assert!(resources_quantity > 0, EResourceNotRegeneratedYet);

        let resource_item_ids = vector[item_id::resource_type_mining(), item_id::resource_type_woodcutting(
        ), item_id::cotton_seeds()];
        let rand_seed = bcs::to_bytes(&coordinates);
        vector::append(&mut rand_seed, object::id_to_bytes(&player_id));//&player::id(player)));
        vector::append(&mut rand_seed, bcs::to_bytes(&now_time));
        let random_resource_quantities = ts_random_util::divide_int(
            clock,
            rand_seed,
            (resources_quantity as u64),
            3
        );
        let resource_item_quantities = vector[
            (*vector::borrow(&random_resource_quantities, 0) as u32),
            (*vector::borrow(&random_resource_quantities, 1) as u32),
            (*vector::borrow(&random_resource_quantities, 2) as u32),
        ];
        let resources = item_id_quantity_pairs::new(resource_item_ids, resource_item_quantities);

        map::new_island_resources_gathered(
            map,
            player_id,
            coordinates,
            item_id_quantity_pairs::items(&resources),
            now_time
        )
    }

    public(friend) fun mutate(
        island_resources_gathered: &map::IslandResourcesGathered,
        //player: &mut Player,
        clock: &Clock,
        map: &mut map::Map,
        ctx: &TxContext, // modify the reference to mutable if needed
    ): ItemIdQuantityPairs {
        let coordinates = map::island_resources_gathered_coordinates(island_resources_gathered);
        let resources = map::island_resources_gathered_resources(island_resources_gathered);
        let gathered_at = map::island_resources_gathered_gathered_at(island_resources_gathered);

        let island = map::borrow_mut_location(map, coordinates);
        map_location::set_resources(island, vector::empty());
        map_location::set_gathered_at(island, gathered_at);
        item_id_quantity_pairs::new_by_vector(resources)
    }


    fun assert_player_is_island_owner(player_id: ID, coordinates: Coordinates, map: &Map) {
        // let coordinates_o = player::claimed_island(player);
        // assert!(option::is_some(&coordinates_o), EPlayerClaimedNoIsland);
        //let coordinates = option::extract(&mut coordinates_o);
        assert!(map::locations_contains(map, coordinates), ELocationNotFound);
        let island = map::borrow_location(map, coordinates);
        assert!(map_location_type::island() == map_location:: type
        (island),
        ELocationNotAnIsland);
        let occupied_by = map_location::occupied_by(island);
        assert!(option::is_some(&occupied_by), EIslandNotOccupied);
        assert!(option::extract(&mut occupied_by) == player_id, EPlayerIsNotIslandOwner);
    }
}
