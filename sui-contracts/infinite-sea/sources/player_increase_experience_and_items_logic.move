#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::player_increase_experience_and_items_logic {
    use std::vector;

    use sui::tx_context::TxContext;
    use infinite_sea_common::production_material;
    use infinite_sea_common::production_material::ProductionMaterial;

    use infinite_sea::player;
    use infinite_sea::player_item::Self;

    friend infinite_sea::player_aggregate;

    public(friend) fun verify(
        experience: u32,
        items: vector<ProductionMaterial>,
        new_level: u16,
        player: &player::Player,
        ctx: &TxContext,
    ): player::PlayerExperienceAndItemsIncreased {
        player::new_player_experience_and_items_increased(
            player, experience, items, new_level
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
        //let player_id = player::player_id(player);
        let old_experience = player::experience(player);
        player::set_experience(player, old_experience + increased_experience);
        player::set_level(player, new_level);

        let items = player::player_experience_and_items_increased_items(player_experience_and_items_increased);
        let i = 0;
        let l = vector::length(&items);
        while (i < l) {
            let item = vector::borrow(&items, i);
            let item_id = production_material::item_id(item);
            let quantity = production_material::quantity(item);
            increase_player_item_quantity(player, item_id, quantity);
            i = i + 1;
        };
    }

    fun increase_player_item_quantity(player: &mut player::Player, item_id: u32, quantity: u32) {
        if (player::items_contains(player, item_id)) {
            let player_item = player::borrow_mut_item(player, item_id);
            let old_quantity = player_item::quantity(player_item);
            player_item::set_quantity(player_item, old_quantity + quantity);
        } else {
            let player_item = player_item::new_player_item(item_id, quantity);
            player::add_item(player, player_item);
        };
    }
}
