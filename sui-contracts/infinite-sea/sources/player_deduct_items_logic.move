#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::player_deduct_items_logic {
    use infinite_sea::player;
    use infinite_sea::player_item::{Self, PlayerItem};
    use infinite_sea_common::production_material::ProductionMaterial;
    use sui::tx_context::{Self, TxContext};

    friend infinite_sea::player_aggregate;

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
        let player_id = player::player_id(player);
        // ...
        //
    }

}
