module infinite_sea::player_properties {
    use std::option;
    use std::vector;
    use sui::tx_context::TxContext;

    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea_common::item_id_quantity_pair;
    use infinite_sea_common::item_id_quantity_pair::ItemIdQuantityPair;
    use infinite_sea_common::sorted_vector_util;
    use infinite_sea_map::map;
    use infinite_sea_map::map::Map;
    use infinite_sea_map::map_aggregate;
    use infinite_sea_map::map_friend_config;
    use infinite_sea_map::map_location;

    use infinite_sea::player;
    use infinite_sea::player::Player;

    friend infinite_sea::skill_process_start_creation_logic;
    friend infinite_sea::skill_process_start_production_logic;
    friend infinite_sea::skill_process_start_ship_production_logic;
    friend infinite_sea::skill_process_complete_creation_logic;
    friend infinite_sea::skill_process_complete_production_logic;
    friend infinite_sea::skill_process_complete_ship_production_logic;
    friend infinite_sea::player_gather_island_resources_logic;
    friend infinite_sea::player_claim_island_logic;
    friend infinite_sea::player_nft_holder_claim_island_logic;

    public(friend) fun deduct_inventory(player: &mut Player, items: vector<ItemIdQuantityPair>) {
        let inv = player::borrow_mut_inventory(player);
        let i = 0;
        let l = vector::length(&items);
        while (i < l) {
            let item = vector::borrow(&items, i);
            // let item_id = item_id_quantity_pair::item_id(item);
            // let quantity = item_id_quantity_pair::quantity(item);
            sorted_vector_util::subtract_item_id_quantity_pair(inv, *item);
            i = i + 1;
        };
    }

    public(friend) fun increase_experience_and_inventory_and_set_level(
        player: &mut Player,
        increased_experience: u32,
        items: vector<ItemIdQuantityPair>,
        level: u16
    ) {
        increase_experience(player, increased_experience);
        increase_inventory(player, items);
        set_level(player, level);
    }

    public(friend) fun increase_inventory(player: &mut Player, items: vector<ItemIdQuantityPair>) {
        let i = 0;
        let l = vector::length(&items);
        while (i < l) {
            let item = vector::borrow(&items, i);
            let item_id = item_id_quantity_pair::item_id(item);
            let quantity = item_id_quantity_pair::quantity(item);
            increase_player_item_quantity(player, item_id, quantity);
            i = i + 1;
        };
    }

    public(friend) fun increase_player_item_quantity(player: &mut player::Player, item_id: u32, quantity: u32) {
        let inv = player::borrow_mut_inventory(player);
        sorted_vector_util::insert_or_add_item_id_quantity_pair(inv, item_id_quantity_pair::new(item_id, quantity));
    }

    public(friend) fun increase_experience(player: &mut Player, increased_experience: u32) {
        let old_experience = player::experience(player);
        player::set_experience(player, old_experience + increased_experience);
    }

    public(friend) fun set_level(player: &mut Player, level: u16) {
        player::set_level(player, level);
    }

    public(friend) fun claim_island_mutate(
        map_friend_config: &map_friend_config::MapFriendConfig,
        player: &mut Player,
        map: &mut Map,
        coordinates: Coordinates,
        claimed_at: u64,
        ctx: &mut TxContext,
    ) {
        let player_id = player::id(player);

        player::set_claimed_island(player, option::some(coordinates));
        // move resources from island to player inventory
        let island = map::borrow_location(map, coordinates);
        let inv = player::borrow_mut_inventory(player);
        sorted_vector_util::merge_item_id_quantity_pairs(inv, map_location::borrow_resources(island));
        // call map_aggregate::claim_island
        map_aggregate::claim_island(
            map_friend_config, player::friend_witness(), map, coordinates, player_id, claimed_at, ctx);
    }
}
