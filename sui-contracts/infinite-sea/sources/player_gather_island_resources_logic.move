#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::player_gather_island_resources_logic {
    use std::option;

    use sui::clock::Clock;
    use sui::tx_context::TxContext;
    use infinite_sea_common::item_id_quantity_pairs;
    use infinite_sea_map::map::Map;
    use infinite_sea_map::map_aggregate;
    use infinite_sea_map::map_friend_config;

    use infinite_sea::permission_util;
    use infinite_sea::player::{Self, Player};
    use infinite_sea::player_properties;

    friend infinite_sea::player_aggregate;

    public(friend) fun verify(
        map: &Map,
        clock: &Clock,
        player: &mut Player,
        ctx: &TxContext,
    ): player::PlayerIslandResourcesGathered {
        permission_util::assert_sender_is_player_owner(player, ctx);
        //permission_util::assert_player_is_island_owner(player, map);
        player::new_player_island_resources_gathered(
            player,
        )
    }

    public(friend) fun mutate(
        map_friend_config: &map_friend_config::MapFriendConfig,
        player_island_resources_gathered: &player::PlayerIslandResourcesGathered,
        map: &mut Map,
        clock: &Clock,
        player: &mut Player,
        ctx: &mut TxContext, // modify the reference to mutable if needed
    ) {
        let id = player::id(player);
        let resources = map_aggregate::gather_island_resources(
            map_friend_config,
            player::friend_witness(),
            map,
            id,
            option::extract(&mut player::claimed_island(player)),
            clock,
            ctx,
        );
        player_properties::increase_inventory(player, item_id_quantity_pairs::items(&resources));
    }
}
