// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

#[allow(unused_mut_parameter, unused_use)]
module infinite_sea::player_aggregate {
    use infinite_sea::map::Map;
    use infinite_sea::player;
    use infinite_sea::player_airdrop_logic;
    use infinite_sea::player_claim_island_logic;
    use infinite_sea::player_create_logic;
    use infinite_sea::roster::RosterTable;
    use infinite_sea::skill_process::SkillProcessTable;
    use infinite_sea_common::coordinates::{Self, Coordinates};
    use std::string::String;
    use sui::clock::Clock;
    use sui::tx_context;

    friend infinite_sea::skill_process_service;
    friend infinite_sea::roster_service;
    friend infinite_sea::ship_battle_service;

    const ENotPublisher: u64 = 50;

    public entry fun create(
        name: String,
        ctx: &mut tx_context::TxContext,
    ) {
        let player_created = player_create_logic::verify(
            name,
            ctx,
        );
        let player = player_create_logic::mutate(
            &player_created,
            ctx,
        );
        player::set_player_created_id(&mut player_created, player::id(&player));
        player::share_object(player);
        player::emit_player_created(player_created);
    }

    public entry fun claim_island(
        player: &mut player::Player,
        map: &mut Map,
        coordinates_x: u32,
        coordinates_y: u32,
        clock: &Clock,
        roster_table: &mut RosterTable,
        skill_process_table: &mut SkillProcessTable,
        ctx: &mut tx_context::TxContext,
    ) {
        let coordinates: Coordinates = coordinates::new(
            coordinates_x,
            coordinates_y,
        );
        let island_claimed = player_claim_island_logic::verify(
            map,
            coordinates,
            clock,
            roster_table,
            skill_process_table,
            player,
            ctx,
        );
        player_claim_island_logic::mutate(
            &island_claimed,
            map,
            roster_table,
            skill_process_table,
            player,
            ctx,
        );
        player::update_object_version(player);
        player::emit_island_claimed(island_claimed);
    }

    public entry fun airdrop(
        player: &mut player::Player,
        publisher: &sui::package::Publisher,
        item_id: u32,
        quantity: u32,
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(sui::package::from_package<player::Player>(publisher), ENotPublisher);
        let player_airdropped = player_airdrop_logic::verify(
            item_id,
            quantity,
            player,
            ctx,
        );
        player_airdrop_logic::mutate(
            &player_airdropped,
            player,
            ctx,
        );
        player::update_object_version(player);
        player::emit_player_airdropped(player_airdropped);
    }

}
