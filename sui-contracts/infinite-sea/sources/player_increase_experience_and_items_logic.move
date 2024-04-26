#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::player_increase_experience_and_items_logic {
    use std::vector;

    use sui::object::ID;
    use sui::tx_context::TxContext;
    use infinite_sea_common::item_id_quantity_pair;
    use infinite_sea_common::item_id_quantity_pair::ItemIdQuantityPair;
    use infinite_sea_common::vector_util;

    use infinite_sea::player;

    friend infinite_sea::player_aggregate;

    public(friend) fun verify(
        experience: u32,
        items: vector<ItemIdQuantityPair>,
        new_level: u16,
        unassigned_ships: vector<ID>,
        player: &player::Player,
        ctx: &TxContext,
    ): player::PlayerExperienceAndItemsIncreased {
        player::new_player_experience_and_items_increased(
            player, experience, items, new_level, unassigned_ships
        )
    }

    public(friend) fun mutate(
        player_experience_and_items_increased: &player::PlayerExperienceAndItemsIncreased,
        player: &mut player::Player,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let increased_experience = player::player_experience_and_items_increased_experience(
            player_experience_and_items_increased
        );
        let new_level = player::player_experience_and_items_increased_new_level(player_experience_and_items_increased);
        let unassigned_ships = player::player_experience_and_items_increased_unassigned_ships(
            player_experience_and_items_increased
        );
        //let player_id = player::player_id(player);
        let old_experience = player::experience(player);
        player::set_experience(player, old_experience + increased_experience);
        player::set_level(player, new_level);

        let items = player::player_experience_and_items_increased_items(player_experience_and_items_increased);
        let i = 0;
        let l = vector::length(&items);
        while (i < l) {
            let item = vector::borrow(&items, i);
            let item_id = item_id_quantity_pair::item_id(item);
            let quantity = item_id_quantity_pair::quantity(item);
            increase_player_item_quantity(player, item_id, quantity);
            i = i + 1;
        };

        let player_unassigned_ships = player::borrow_mut_unassigned_ships(player);
        let i = 0;
        let l = vector::length(&unassigned_ships);
        while (i < l) {
            let ship_id = vector::borrow(&unassigned_ships, i);
            vector_util::add_id(player_unassigned_ships, *ship_id);
            i = i + 1;
        };
    }

    fun increase_player_item_quantity(player: &mut player::Player, item_id: u32, quantity: u32) {
        let inv = player::borrow_mut_inventory(player);
        vector_util::insert_or_add_item_id_quantity_pair(inv, item_id_quantity_pair::new(item_id, quantity));
    }
}
