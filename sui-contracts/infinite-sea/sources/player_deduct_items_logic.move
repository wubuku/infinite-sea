#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::player_deduct_items_logic {
    use std::vector;

    use sui::tx_context::TxContext;
    use infinite_sea_common::item_id_quantity_pair::ItemIdQuantityPair;
    use infinite_sea_common::vector_util;

    use infinite_sea::player;

    friend infinite_sea::player_aggregate;

    // const EInsufficientItemQuantity: u64 = 11;

    public(friend) fun verify(
        items: vector<ItemIdQuantityPair>,
        player: &player::Player,
        ctx: &TxContext,
    ): player::PlayerItemsDeducted {
        player::new_player_items_deducted(
            player,
            items,
        )
    }

    public(friend) fun mutate(
        player_items_deducted: &player::PlayerItemsDeducted,
        player: &mut player::Player,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let inv = player::borrow_mut_inventory(player);
        let items = player::player_items_deducted_items(player_items_deducted);
        //let player_id = player::player_id(player);
        let i = 0;
        let l = vector::length(&items);
        while (i < l) {
            let item = vector::borrow(&items, i);
            // let item_id = item_id_quantity_pair::item_id(item);
            // let quantity = item_id_quantity_pair::quantity(item);
            vector_util::subtract_item_id_quantity_pair(inv, *item);
            i = i + 1;
        };
    }
}
