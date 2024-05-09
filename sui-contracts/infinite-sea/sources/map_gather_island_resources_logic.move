#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::map_gather_island_resources_logic {
    use std::bcs;
    use std::option;
    use std::vector;

    use sui::clock;
    use sui::clock::Clock;
    use sui::object;
    use sui::tx_context::TxContext;
    use infinite_sea_common::item_id;
    use infinite_sea_common::item_id_quantity_pairs;
    use infinite_sea_common::ts_random_util;

    use infinite_sea::map;
    use infinite_sea::map_location;
    use infinite_sea::map_util;
    use infinite_sea::permission_util;
    use infinite_sea::player::{Self, Player};
    use infinite_sea::player_properties;

    friend infinite_sea::map_aggregate;

    public(friend) fun verify(
        player: &mut Player,
        clock: &Clock,
        map: &map::Map,
        ctx: &TxContext,
    ): map::IslandResourcesGathered {
        permission_util::assert_sender_is_player_owner(player, ctx);
        permission_util::assert_player_is_island_owner(player, map);
        let coordinates = option::extract(&mut player::claimed_island(player));
        let now_time = clock::timestamp_ms(clock) / 1000;
        let resources_quantity = map_util::get_island_resources_quantity_to_gather(map, coordinates, now_time);

        let resource_item_ids = vector[item_id::copper_ore(), item_id::normal_logs(), item_id::cottons()];
        let rand_seed = bcs::to_bytes(&coordinates);
        vector::append(&mut rand_seed, object::id_to_bytes(&player::id(player)));
        vector::append(&mut rand_seed, bcs::to_bytes(&now_time));
        let random_resource_quantities = ts_random_util::divide_int_with_epoch_timestamp_ms(
            ctx,
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

        map::new_island_resources_gathered(map, coordinates, item_id_quantity_pairs::items(&resources), now_time)
    }

    public(friend) fun mutate(
        island_resources_gathered: &map::IslandResourcesGathered,
        player: &mut Player,
        map: &mut map::Map,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let coordinates = map::island_resources_gathered_coordinates(island_resources_gathered);
        let resources = map::island_resources_gathered_resources(island_resources_gathered);
        let gathered_at = map::island_resources_gathered_gathered_at(island_resources_gathered);
        player_properties::increase_inventory(player, resources);
        let island = map::borrow_mut_location(map, coordinates);
        map_location::set_resources(island, vector::empty());
        map_location::set_gathered_at(island, gathered_at);
    }
}
