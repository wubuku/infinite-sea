#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::player_deduct_items_logic {
    use std::vector;

    use sui::tx_context::TxContext;
    use infinite_sea_common::production_material;
    use infinite_sea_common::production_material::ProductionMaterial;

    use infinite_sea::player;
    use infinite_sea::player_item::Self;

    friend infinite_sea::player_aggregate;

    const EPalyerHasNoSuchItem: u64 = 10;
    const EInsufficientItemQuantity: u64 = 11;

    public(friend) fun verify(
        items: vector<ProductionMaterial>,
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
        let items = player::player_items_deducted_items(player_items_deducted);
        //let player_id = player::player_id(player);
        let i = 0;
        let l = vector::length(&items);
        while (i < l) {
            let item = vector::borrow(&items, i);
            let item_id = production_material::item_id(item);
            let quantity = production_material::quantity(item);
            assert!(player::items_contains(player, item_id), EPalyerHasNoSuchItem);
            let player_item = player::borrow_mut_item(player, item_id);
            let old_quantity = player_item::quantity(player_item);
            assert!(old_quantity >= quantity, EInsufficientItemQuantity);
            player_item::set_quantity(player_item, old_quantity - quantity);

            i = i + 1;
        };
    }
}
