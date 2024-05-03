#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::ship_battle_make_move_logic {
    use std::option;

    use sui::clock;
    use sui::clock::Clock;
    use sui::object::ID;
    use sui::object_table;
    use sui::tx_context::TxContext;

    use infinite_sea::player::Player;
    use infinite_sea::roster;
    use infinite_sea::roster::Roster;
    use infinite_sea::ship_battle;
    use infinite_sea::ship_battle_util;

    friend infinite_sea::ship_battle_aggregate;

    const ERoundMoverNotSet: u64 = 11;
    const EAttackerShipNotSet: u64 = 12;
    const EDefenderShipNotSet: u64 = 13;

    public(friend) fun verify(
        player: &Player,
        initiator: &mut Roster,
        responder: &mut Roster,
        clock: &Clock,
        attacker_command: u8,
        defender_command: u8,
        ship_battle: &ship_battle::ShipBattle,
        ctx: &TxContext,
    ): ship_battle::ShipBattleMoveMade {
        ship_battle_util::assert_ids_are_consistent(ship_battle, initiator, responder);
        //
        //permission_util::assert_sender_is_player_owner(player, ctx);
        //ship_battle_util::assert_palyer_is_current_round_mover(player, ship_battle, initiator, responder); //NOTE!
        //
        let now_time = clock::timestamp_ms(clock) / 1000;

        let attacker_ship_id = ship_battle::round_attacker_ship(ship_battle);
        assert!(option::is_some(&attacker_ship_id), EAttackerShipNotSet);
        let defender_ship_id = ship_battle::round_defender_ship(ship_battle);
        assert!(option::is_some(&defender_ship_id), EDefenderShipNotSet);

        let round_mover = ship_battle::round_mover(ship_battle);
        assert!(option::is_some(&round_mover), ERoundMoverNotSet);
        let attacker_roster: &Roster;
        let defender_roster: &Roster;
        if (*option::borrow(&round_mover) == ship_battle_util::initiator()) {
            attacker_roster = initiator;
            defender_roster = responder;
        } else {
            attacker_roster = responder;
            defender_roster = initiator;
        };
        let attacker_ships = roster::borrow_ships(attacker_roster);
        let defender_ships = roster::borrow_ships(defender_roster);
        let attacker_ship = object_table::borrow(attacker_ships, *option::borrow(&attacker_ship_id));
        let defender_ship = object_table::borrow(defender_ships, *option::borrow(&defender_ship_id));
        let defender_damage_taken = ship_battle_util::perform_attack(attacker_ship, defender_ship, clock);
        let attacker_damage_taken = 0;
        let is_batlle_ended = false;
        let winner = option::none<u8>(); //todo
        let next_round_mover = option::none<u8>(); //todo
        let next_round_attacker_ship = option::none<ID>(); //todo
        let next_round_defender_ship = option::none<ID>(); //todo
        let next_round_started_at = now_time;
        ship_battle::new_ship_battle_move_made(ship_battle, attacker_command, defender_command,
            ship_battle::round_number(ship_battle),
            defender_damage_taken, attacker_damage_taken, is_batlle_ended, winner,
            next_round_started_at, next_round_mover, next_round_attacker_ship, next_round_defender_ship,
        )
    }

    public(friend) fun mutate(
        ship_battle_move_made: &mut ship_battle::ShipBattleMoveMade,
        initiator: &mut Roster,
        responder: &mut Roster,
        ship_battle: &mut ship_battle::ShipBattle,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let attacker_command = ship_battle::ship_battle_move_made_attacker_command(ship_battle_move_made);
        let id = ship_battle::id(ship_battle);
        // todo ...
        //
    }
}
