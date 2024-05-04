#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::ship_battle_make_move_logic {
    use std::option;

    use sui::clock;
    use sui::clock::Clock;
    use sui::object::ID;
    use sui::object_table;
    use sui::tx_context::TxContext;
    use infinite_sea_common::battle_status;
    use infinite_sea_common::ship_battle_command;

    use infinite_sea::player::Player;
    use infinite_sea::roster;
    use infinite_sea::roster::Roster;
    use infinite_sea::roster_util;
    use infinite_sea::ship;
    use infinite_sea::ship_battle;
    use infinite_sea::ship_battle_util;

    friend infinite_sea::ship_battle_aggregate;

    const ERoundMoverNotSet: u64 = 11;
    const EAttackerShipNotSet: u64 = 12;
    const EDefenderShipNotSet: u64 = 13;
    const EWinnerNotSet: u64 = 14;
    const EWinnerSetButBattleNotEnded: u64 = 15;

    public(friend) fun verify(
        player: &Player,
        initiator: &Roster,
        responder: &Roster,
        clock: &Clock,
        attacker_command: u8,
        ship_battle: &ship_battle::ShipBattle,
        ctx: &TxContext,
    ): ship_battle::ShipBattleMoveMade {
        ship_battle_util::assert_ids_are_consistent(ship_battle, initiator, responder);

        let defender_command: u8 = ship_battle_command::attack();//Unused for now
        let _ = player; //Unused for now
        //
        //permission_util::assert_sender_is_player_owner(player, ctx);
        //ship_battle_util::assert_palyer_is_current_round_mover(player, ship_battle, initiator, responder); //NOTE!
        //

        let now_time = clock::timestamp_ms(clock) / 1000;
        let current_round_number = ship_battle::round_number(ship_battle);

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

        let defender_damage_taken = ship_battle_util::perform_attack(
            attacker_ship,
            defender_ship,
            clock,
            current_round_number
        );
        let defender_ship_hp = ship::health_points(defender_ship);
        if (defender_damage_taken >= defender_ship_hp) {
            defender_damage_taken = defender_ship_hp;
            defender_ship_hp = 0;
        } else {
            defender_ship_hp = defender_ship_hp - defender_damage_taken;
        };

        let is_batlle_ended = false;
        let winner = option::none<u8>();

        if (defender_ship_hp == 0
            && roster_util::is_destroyed_except_ship(defender_roster, *option::borrow(&defender_ship_id))
        ) {
            is_batlle_ended = true;
            winner = option::some(*option::borrow(&round_mover));
        };

        let attacker_damage_taken = 0;
        if (!is_batlle_ended) {
            attacker_damage_taken = ship_battle_util::perform_attack(
                defender_ship,
                attacker_ship,
                clock,
                current_round_number
            );
            let attacker_ship_hp = ship::health_points(attacker_ship);
            if (attacker_damage_taken >= attacker_ship_hp) {
                attacker_damage_taken = attacker_ship_hp;
                attacker_ship_hp = 0;
            } else {
                attacker_ship_hp = attacker_ship_hp - attacker_damage_taken;
            };

            if (attacker_ship_hp == 0
                && roster_util::is_destroyed_except_ship(attacker_roster, *option::borrow(&attacker_ship_id))
            ) {
                is_batlle_ended = true;
                winner = option::some(ship_battle_util::opposite_side(*option::borrow(&round_mover)));
            };
        };
        let next_round_mover = option::none<u8>();
        let next_round_attacker_ship = option::none<ID>();
        let next_round_defender_ship = option::none<ID>();
        let next_round_started_at = now_time;

        if (!is_batlle_ended) {
            let next_round_number = current_round_number + 1;
            let (attacker_ship_id, defender_ship_id, roster_indicator) = ship_battle_util::determine_attacker_and_defender(
                initiator, responder, clock, next_round_number
            );
            next_round_attacker_ship = option::some(attacker_ship_id);
            next_round_defender_ship = option::some(defender_ship_id);
            next_round_mover = option::some(if (roster_indicator == 1) {
                ship_battle_util::initiator()
            } else {
                ship_battle_util::responder()
            });
        };

        ship_battle::new_ship_battle_move_made(ship_battle, attacker_command, defender_command,
            current_round_number,
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
        //let attacker_command = ship_battle::ship_battle_move_made_attacker_command(ship_battle_move_made);
        //let id = ship_battle::id(ship_battle);
        let round_mover = ship_battle::round_mover(ship_battle);
        let defender_damage_taken = ship_battle::ship_battle_move_made_defender_damage_taken(ship_battle_move_made);
        let attacker_damage_taken = ship_battle::ship_battle_move_made_attacker_damage_taken(ship_battle_move_made);
        let attacker_ship_id = ship_battle::round_attacker_ship(ship_battle);
        let defender_ship_id = ship_battle::round_defender_ship(ship_battle);
        let attacker_roster: &mut Roster;
        let defender_roster: &mut Roster;
        if (*option::borrow(&round_mover) == ship_battle_util::initiator()) {
            attacker_roster = initiator;
            defender_roster = responder;
        } else {
            attacker_roster = responder;
            defender_roster = initiator;
        };
        let attacker_ships = roster::borrow_mut_ships(attacker_roster);
        let defender_ships = roster::borrow_mut_ships(defender_roster);
        let attacker_ship = object_table::borrow_mut(attacker_ships, *option::borrow(&attacker_ship_id));
        let defender_ship = object_table::borrow_mut(defender_ships, *option::borrow(&defender_ship_id));
        let defender_ship_hp = ship::health_points(defender_ship);
        let attacker_ship_hp = ship::health_points(attacker_ship);
        ship::set_health_points(defender_ship, defender_ship_hp - defender_damage_taken);
        ship::set_health_points(attacker_ship, attacker_ship_hp - attacker_damage_taken);

        let is_batlle_ended = ship_battle::ship_battle_move_made_is_battle_ended(ship_battle_move_made);
        let winner = ship_battle::ship_battle_move_made_winner(ship_battle_move_made);
        let next_round_started_at = ship_battle::ship_battle_move_made_next_round_started_at(ship_battle_move_made);
        let next_round_mover = ship_battle::ship_battle_move_made_next_round_mover(ship_battle_move_made);
        let next_round_attacker_ship = ship_battle::ship_battle_move_made_next_round_attacker_ship(
            ship_battle_move_made
        );
        let next_round_defender_ship = ship_battle::ship_battle_move_made_next_round_defender_ship(
            ship_battle_move_made
        );

        if (is_batlle_ended) {
            ship_battle::set_status(ship_battle, battle_status::ended());
            assert!(option::is_some(&winner), EWinnerNotSet);
        } else {
            let current_round_number = ship_battle::round_number(ship_battle);
            ship_battle::set_round_number(ship_battle, current_round_number + 1);
            assert!(option::is_none(&winner), EWinnerSetButBattleNotEnded);
        };

        ship_battle::set_winner(ship_battle, winner);
        ship_battle::set_round_mover(ship_battle, next_round_mover);
        ship_battle::set_round_attacker_ship(ship_battle, next_round_attacker_ship);
        ship_battle::set_round_defender_ship(ship_battle, next_round_defender_ship);
        ship_battle::set_round_started_at(ship_battle, next_round_started_at);
    }
}
