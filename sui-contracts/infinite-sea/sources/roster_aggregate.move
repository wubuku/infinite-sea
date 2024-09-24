// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module infinite_sea::roster_aggregate {
    use std::option::Option;

    use sui::balance::Balance;
    use sui::clock::Clock;
    use sui::object::ID;
    use sui::tx_context;
    use infinite_sea_coin::energy::ENERGY;
    use infinite_sea_common::coordinates::{Self, Coordinates};
    use infinite_sea_common::item_id_quantity_pairs::{Self, ItemIdQuantityPairs};
    use infinite_sea_common::roster_id::{Self, RosterId};

    use infinite_sea::player::Player;
    use infinite_sea::roster::{Self, Roster};
    use infinite_sea::roster_add_ship_logic;
    use infinite_sea::roster_adjust_ships_position_logic;
    use infinite_sea::roster_create_environment_roster_logic;
    use infinite_sea::roster_create_logic;
    use infinite_sea::roster_delete_logic;
    use infinite_sea::roster_put_in_ship_inventory_logic;
    use infinite_sea::roster_set_sail_logic;
    use infinite_sea::roster_take_out_ship_inventory_logic;
    use infinite_sea::roster_transfer_ship_inventory_logic;
    use infinite_sea::roster_transfer_ship_logic;
    use infinite_sea::ship::Ship;

    #[test_only]
    use std::debug;
    #[test_only]
    use std::option;
    #[test_only]
    use std::string;
    #[test_only]
    use std::vector;
    #[test_only]
    use sui::balance;
    #[test_only]
    use sui::clock;
    #[test_only]
    use sui::test_scenario;
    #[test_only]
    use infinite_sea::player;

    friend infinite_sea::player_claim_island_logic;
    friend infinite_sea::player_nft_holder_claim_island_logic;
    friend infinite_sea::skill_process_complete_ship_production_logic;
    friend infinite_sea::ship_battle_initiate_battle_logic;
    friend infinite_sea::skill_process_service;
    friend infinite_sea::roster_service;
    friend infinite_sea::ship_battle_service;

    const ENotPublisher: u64 = 50;

    #[allow(unused_mut_ref)]
    public(friend) fun create(
        roster_id_player_id: ID,
        roster_id_sequence_number: u32,
        status: u8,
        speed: u32,
        updated_coordinates: Coordinates,
        coordinates_updated_at: u64,
        target_coordinates: Option<Coordinates>,
        origin_coordinates: Option<Coordinates>,
        ship_battle_id: Option<ID>,
        roster_table: &mut roster::RosterTable,
        ctx: &mut tx_context::TxContext,
    ): roster::Roster {
        let roster_id: RosterId = roster_id::new(
            roster_id_player_id,
            roster_id_sequence_number,
        );

        let roster_created = roster_create_logic::verify(
            roster_id,
            status,
            speed,
            updated_coordinates,
            coordinates_updated_at,
            target_coordinates,
            origin_coordinates,
            ship_battle_id,
            roster_table,
            ctx,
        );
        let roster = roster_create_logic::mutate(
            &mut roster_created,
            roster_table,
            ctx,
        );
        roster::set_roster_created_id(&mut roster_created, roster::id(&roster));
        roster::emit_roster_created(roster_created);
        roster
    }

    public entry fun create_environment_roster(
        roster_id_player_id: ID,
        roster_id_sequence_number: u32,
        publisher: &sui::package::Publisher,
        coordinates_x: u32,
        coordinates_y: u32,
        ship_resource_quantity: u32,
        ship_base_resource_quantity: u32,
        base_experience: u32,
        clock: &Clock,
        roster_table: &mut roster::RosterTable,
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(sui::package::from_package<roster::Roster>(publisher), ENotPublisher);
        let roster_id: RosterId = roster_id::new(
            roster_id_player_id,
            roster_id_sequence_number,
        );

        let coordinates: Coordinates = coordinates::new(
            coordinates_x,
            coordinates_y,
        );
        let environment_roster_created = roster_create_environment_roster_logic::verify(
            roster_id,
            coordinates,
            ship_resource_quantity,
            ship_base_resource_quantity,
            base_experience,
            clock,
            roster_table,
            ctx,
        );
        let roster = roster_create_environment_roster_logic::mutate(
            &environment_roster_created,
            clock,
            roster_table,
            ctx,
        );
        roster::set_environment_roster_created_id(&mut environment_roster_created, roster::id(&roster));
        roster::share_object(roster);
        roster::emit_environment_roster_created(environment_roster_created);
    }

    #[allow(unused_mut_ref)]
    public(friend) fun add_ship(
        roster: &mut roster::Roster,
        ship: Ship,
        position: Option<u64>,
        ctx: &mut tx_context::TxContext,
    ) {
        let roster_ship_added = roster_add_ship_logic::verify(
            &ship,
            position,
            roster,
            ctx,
        );
        roster_add_ship_logic::mutate(
            &mut roster_ship_added,
            ship,
            roster,
            ctx,
        );
        roster::update_object_version(roster);
        roster::emit_roster_ship_added(roster_ship_added);
    }

    public fun set_sail(
        roster: &mut roster::Roster,
        player: &Player,
        target_coordinates_x: u32,
        target_coordinates_y: u32,
        clock: &Clock,
        energy: Balance<ENERGY>,
        sail_duration: u64,
        updated_coordinates_x: u32,
        updated_coordinates_y: u32,
        ctx: &mut tx_context::TxContext,
    ) {
        let target_coordinates: Coordinates = coordinates::new(
            target_coordinates_x,
            target_coordinates_y,
        );
        let updated_coordinates: Coordinates = coordinates::new(
            updated_coordinates_x,
            updated_coordinates_y,
        );
        let roster_set_sail = roster_set_sail_logic::verify(
            player,
            target_coordinates,
            clock,
            &energy,
            sail_duration,
            updated_coordinates,
            roster,
            ctx,
        );
        roster_set_sail_logic::mutate(
            &roster_set_sail,
            energy,
            roster,
            ctx,
        );
        roster::update_object_version(roster);
        roster::emit_roster_set_sail(roster_set_sail);
    }

    public entry fun adjust_ships_position(
        roster: &mut roster::Roster,
        player: &Player,
        positions: vector<u64>,
        ship_ids: vector<ID>,
        ctx: &mut tx_context::TxContext,
    ) {
        let roster_ships_position_adjusted = roster_adjust_ships_position_logic::verify(
            player,
            positions,
            ship_ids,
            roster,
            ctx,
        );
        roster_adjust_ships_position_logic::mutate(
            &roster_ships_position_adjusted,
            roster,
            ctx,
        );
        roster::update_object_version(roster);
        roster::emit_roster_ships_position_adjusted(roster_ships_position_adjusted);
    }

    #[allow(unused_mut_ref)]
    public entry fun transfer_ship(
        roster: &mut roster::Roster,
        player: &Player,
        ship_id: ID,
        to_roster: &mut Roster,
        to_position: Option<u64>,
        clock: &Clock,
        ctx: &mut tx_context::TxContext,
    ) {
        let roster_ship_transferred = roster_transfer_ship_logic::verify(
            player,
            ship_id,
            to_roster,
            to_position,
            clock,
            roster,
            ctx,
        );
        roster_transfer_ship_logic::mutate(
            &mut roster_ship_transferred,
            to_roster,
            roster,
            ctx,
        );
        roster::update_object_version(roster);
        roster::emit_roster_ship_transferred(roster_ship_transferred);
    }

    public entry fun transfer_ship_inventory(
        roster: &mut roster::Roster,
        player: &Player,
        from_ship_id: ID,
        to_ship_id: ID,
        item_id_quantity_pairs_item_id_list: vector<u32>,
        item_id_quantity_pairs_item_quantity_list: vector<u32>,
        ctx: &mut tx_context::TxContext,
    ) {
        let item_id_quantity_pairs: ItemIdQuantityPairs = item_id_quantity_pairs::new(
            item_id_quantity_pairs_item_id_list,
            item_id_quantity_pairs_item_quantity_list,
        );
        let roster_ship_inventory_transferred = roster_transfer_ship_inventory_logic::verify(
            player,
            from_ship_id,
            to_ship_id,
            item_id_quantity_pairs,
            roster,
            ctx,
        );
        roster_transfer_ship_inventory_logic::mutate(
            &roster_ship_inventory_transferred,
            roster,
            ctx,
        );
        roster::update_object_version(roster);
        roster::emit_roster_ship_inventory_transferred(roster_ship_inventory_transferred);
    }

    public entry fun take_out_ship_inventory(
        roster: &mut roster::Roster,
        player: &mut Player,
        clock: &Clock,
        ship_id: ID,
        item_id_quantity_pairs_item_id_list: vector<u32>,
        item_id_quantity_pairs_item_quantity_list: vector<u32>,
        updated_coordinates_x: u32,
        updated_coordinates_y: u32,
        ctx: &mut tx_context::TxContext,
    ) {
        let item_id_quantity_pairs: ItemIdQuantityPairs = item_id_quantity_pairs::new(
            item_id_quantity_pairs_item_id_list,
            item_id_quantity_pairs_item_quantity_list,
        );
        let updated_coordinates: Coordinates = coordinates::new(
            updated_coordinates_x,
            updated_coordinates_y,
        );
        let roster_ship_inventory_taken_out = roster_take_out_ship_inventory_logic::verify(
            player,
            clock,
            ship_id,
            item_id_quantity_pairs,
            updated_coordinates,
            roster,
            ctx,
        );
        roster_take_out_ship_inventory_logic::mutate(
            &roster_ship_inventory_taken_out,
            player,
            roster,
            ctx,
        );
        roster::update_object_version(roster);
        roster::emit_roster_ship_inventory_taken_out(roster_ship_inventory_taken_out);
    }

    public entry fun put_in_ship_inventory(
        roster: &mut roster::Roster,
        player: &mut Player,
        clock: &Clock,
        ship_id: ID,
        item_id_quantity_pairs_item_id_list: vector<u32>,
        item_id_quantity_pairs_item_quantity_list: vector<u32>,
        updated_coordinates_x: u32,
        updated_coordinates_y: u32,
        ctx: &mut tx_context::TxContext,
    ) {
        let item_id_quantity_pairs: ItemIdQuantityPairs = item_id_quantity_pairs::new(
            item_id_quantity_pairs_item_id_list,
            item_id_quantity_pairs_item_quantity_list,
        );
        let updated_coordinates: Coordinates = coordinates::new(
            updated_coordinates_x,
            updated_coordinates_y,
        );
        let roster_ship_inventory_put_in = roster_put_in_ship_inventory_logic::verify(
            player,
            clock,
            ship_id,
            item_id_quantity_pairs,
            updated_coordinates,
            roster,
            ctx,
        );
        roster_put_in_ship_inventory_logic::mutate(
            &roster_ship_inventory_put_in,
            player,
            roster,
            ctx,
        );
        roster::update_object_version(roster);
        roster::emit_roster_ship_inventory_put_in(roster_ship_inventory_put_in);
    }

    public entry fun delete(
        roster: roster::Roster,
        ctx: &mut tx_context::TxContext,
    ) {
        let roster_deleted = roster_delete_logic::verify(
            &roster,
            ctx,
        );
        let updated_roster = roster_delete_logic::mutate(
            &roster_deleted,
            roster,
            ctx,
        );
        roster::drop_roster(updated_roster);
        roster::emit_roster_deleted(roster_deleted);
    }

    #[test]
    public fun test_set_sail() {
        let initial_owner = @0xA;

        let scenario = test_scenario::begin(initial_owner);
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let clock = clock::create_for_testing(ctx);
            let player = player::new_player(initial_owner, string::utf8(b"HelloMove"), vector::empty(), ctx);
            let target_coordinates = infinite_sea_common::coordinates::new(2147482184, 2147468894);
            let target_coordinatesX = infinite_sea_common::coordinates::new(2147540619, 2147511092);
            let origin_coordinates = infinite_sea_common::coordinates::new(2147538197, 2147511747);
            let rosterTable = roster::create_roster_table(ctx);
            let updated_coordinates = infinite_sea_common::coordinates::new(0, 0);
            let sail_duration = 2136;
            let roster = create(player::id(&player), 2,
                0, 9, origin_coordinates, 1727166597,
                option::some(target_coordinatesX),
                option::some(origin_coordinates), option::none<ID>(),
                &mut rosterTable, ctx);
            let energy = balance::zero<ENERGY>();
            roster_set_sail_logic::verify(&player, target_coordinates, &clock, &energy, sail_duration,
                updated_coordinates, &roster, ctx);
            clock::destroy_for_testing(clock);
            balance::destroy_zero(energy);
            player::drop_player(player);
            roster::drop_roster(roster);
            roster::drop_roster_table(rosterTable);
        };
        test_scenario::end(scenario);
    }
}
