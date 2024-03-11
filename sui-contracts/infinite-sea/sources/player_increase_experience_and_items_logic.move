#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::player_increase_experience_and_items_logic {
    use infinite_sea::player;
    use infinite_sea::player_item::{Self, PlayerItem};
    use infinite_sea_common::production_material::ProductionMaterial;
    use sui::tx_context::{Self, TxContext};

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
        let experience = player::player_experience_and_items_increased_experience(player_experience_and_items_increased);
        let items = player::player_experience_and_items_increased_items(player_experience_and_items_increased);
        let new_level = player::player_experience_and_items_increased_new_level(player_experience_and_items_increased);
        let player_id = player::player_id(player);
        // ...
        //
    }

}
