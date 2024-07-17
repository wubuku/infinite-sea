#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::ship_battle_make_move_logic {
    use std::option;
    use std::vector;

    use sui::clock;
    use sui::clock::Clock;
    use sui::object;
    use sui::object::ID;
    use sui::object_table;
    use sui::tx_context::TxContext;
    use infinite_sea_common::battle_status;
    use infinite_sea_common::fight_to_death;
    use infinite_sea_common::item_id_quantity_pairs;
    use infinite_sea_common::roster_status;
    use infinite_sea_common::ship_battle_command;
    use infinite_sea_common::ship_util;

    use infinite_sea::player::Player;
    use infinite_sea::roster;
    use infinite_sea::roster::Roster;
    use infinite_sea::roster_util;
    use infinite_sea::ship;
    use infinite_sea::ship::Ship;
    use infinite_sea::ship_battle;
    use infinite_sea::ship_battle_util;

    friend infinite_sea::ship_battle_aggregate;

    const ERoundMoverNotSet: u64 = 11;
    const EAttackerShipNotSet: u64 = 12;
    const EDefenderShipNotSet: u64 = 13;
    const EWinnerNotSet: u64 = 14;
    const EWinnerSetButBattleNotEnded: u64 = 15;
    const EInvalidWinner: u64 = 16;

    /// The experience points gained by defeating a "player-owned" ship.
    const PLAYER_SHIP_EXPERIENCE: u32 = 8;

    public(friend) fun verify(
        player: &Player,
        initiator: &mut Roster,
        responder: &mut Roster,
        clock: &Clock,
        attacker_command: u8,
        ship_battle: &ship_battle::ShipBattle,
        ctx: &TxContext,
    ): ship_battle::ShipBattleMoveMade {
        ship_battle_util::assert_ids_are_consistent(ship_battle, initiator, responder);

        let defender_command: u8 = ship_battle_command::attack();//Unused for now
        let _ = player; //Unused for now

        let now_time = clock::timestamp_ms(clock) / 1000;
        let current_round_number = ship_battle::round_number(ship_battle);

        let attacker_ship_id = ship_battle::round_attacker_ship(ship_battle);
        assert!(option::is_some(&attacker_ship_id), EAttackerShipNotSet);
        let defender_ship_id = ship_battle::round_defender_ship(ship_battle);
        assert!(option::is_some(&defender_ship_id), EDefenderShipNotSet);

        let round_mover = ship_battle::round_mover(ship_battle);
        assert!(option::is_some(&round_mover), ERoundMoverNotSet);
        let attacker_roster: &mut Roster;
        let defender_roster: &mut Roster;
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
        let seed_1 = object::id_to_bytes(&ship_battle::id(ship_battle));
        vector::append(&mut seed_1, vector[(current_round_number % 256 as u8)]);

        // let defender_damage_taken = ship_battle_util::perform_attack(
        //     seed_1, clock,
        //     ship::attack(attacker_ship), ship::protection(defender_ship), //attacker_ship, defender_ship,
        // );
        let defender_ship_hp = ship::health_points(defender_ship);
        let attacker_ship_hp = ship::health_points(attacker_ship);
        let (attacker_damage_taken, defender_damage_taken) = fight_to_death::perform(clock, seed_1,
            ship::attack(attacker_ship), ship::protection(defender_ship), attacker_ship_hp,
            ship::attack(defender_ship), ship::protection(attacker_ship), defender_ship_hp,
        );
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
        // let attacker_damage_taken = 0;
        // let seed_2 = seed_1;
        // vector::append(&mut seed_2, vector[2]);
        if (attacker_damage_taken > 0) { //if (!is_batlle_ended) {
            // attacker_damage_taken = ship_battle_util::perform_attack(
            //     seed_2, clock,
            //     ship::attack(defender_ship), ship::protection(attacker_ship),
            // );
            // let attacker_ship_hp = ship::health_points(attacker_ship);
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

        //
        // NOTE: Update the ships' health_points first!
        // That way you won't pick a ship that has already been destroyed.
        //
        let (_attacker_ship_hp, _defender_ship_hp) = update_ship_health_points(
            attacker_roster, defender_roster,
            *option::borrow(&attacker_ship_id), *option::borrow(&defender_ship_id),
            attacker_damage_taken, defender_damage_taken
        );

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
        let is_attacker_env_owned = roster::environment_owned(attacker_roster);
        let is_defender_env_owned = roster::environment_owned(defender_roster);

        // let (attacker_ship_hp, defender_ship_hp) = update_ship_health_points(
        //     attacker_roster, defender_roster,
        //     *option::borrow(&attacker_ship_id), *option::borrow(&defender_ship_id),
        //     attacker_damage_taken, defender_damage_taken
        // );

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
            ship_battle::set_ended_at(
                ship_battle, option::some(next_round_started_at) //NOTE: next_round_started_at = now_time
            );
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

        let attacker_ships = roster::borrow_ships(attacker_roster);
        let defender_ships = roster::borrow_ships(defender_roster);
        let attacker_ship = object_table::borrow(attacker_ships, *option::borrow(&attacker_ship_id));
        let defender_ship = object_table::borrow(defender_ships, *option::borrow(&defender_ship_id));
        let attacker_ship_hp = ship::health_points(attacker_ship);
        let defender_ship_hp = ship::health_points(defender_ship);

        // Update experience points
        let defender_xp_gained = if (attacker_ship_hp == 0 && attacker_damage_taken > 0) {
            calculate_ship_experience(attacker_ship, is_attacker_env_owned)
        } else { 0 };
        let attacker_xp_gained = if (defender_ship_hp == 0 && defender_damage_taken > 0) {
            calculate_ship_experience(defender_ship, is_defender_env_owned)
        } else { 0 };
        if (*option::borrow(&round_mover) == ship_battle_util::initiator()) {
            //current round attacker is initiator
            if (attacker_xp_gained > 0) {
                let initiator_experiences = ship_battle::initiator_experiences(ship_battle);
                vector::push_back(&mut initiator_experiences, attacker_xp_gained);
                ship_battle::set_initiator_experiences(ship_battle, initiator_experiences);
            };
            if (defender_xp_gained > 0) {
                let responder_experiences = ship_battle::responder_experiences(ship_battle);
                vector::push_back(&mut responder_experiences, defender_xp_gained);
                ship_battle::set_responder_experiences(ship_battle, responder_experiences);
            };
        } else {
            //current round attacker is responder
            if (attacker_xp_gained > 0) {
                let responder_experiences = ship_battle::responder_experiences(ship_battle);
                vector::push_back(&mut responder_experiences, attacker_xp_gained);
                ship_battle::set_responder_experiences(ship_battle, responder_experiences);
            };
            if (defender_xp_gained > 0) {
                let initiator_experiences = ship_battle::initiator_experiences(ship_battle);
                vector::push_back(&mut initiator_experiences, defender_xp_gained);
                ship_battle::set_initiator_experiences(ship_battle, initiator_experiences);
            };
        };

        // Update roster status
        if (is_batlle_ended) {
            //let winner_roster: &mut Roster; //NOTE: Unused?
            let loser_roster: &mut Roster;
            if (*option::borrow(&winner) == ship_battle_util::initiator()) {
                //winner_roster = initiator;
                loser_roster = responder;
            } else if (*option::borrow(&winner) == ship_battle_util::responder()) {
                //winner_roster = responder;
                loser_roster = initiator;
            } else {
                abort EInvalidWinner
            };
            roster::set_status(loser_roster, roster_status::destroyed());
        }
    }

    fun update_ship_health_points(
        attacker_roster: &mut Roster,
        defender_roster: &mut Roster,
        attacker_ship_id: ID,
        defender_ship_id: ID,
        attacker_damage_taken: u32,
        defender_damage_taken: u32
    ): (u32, u32) {
        let attacker_ships = roster::borrow_mut_ships(attacker_roster);
        let defender_ships = roster::borrow_mut_ships(defender_roster);
        let attacker_ship = object_table::borrow_mut(attacker_ships, attacker_ship_id);
        let defender_ship = object_table::borrow_mut(defender_ships, defender_ship_id);
        let attacker_ship_hp = ship::health_points(attacker_ship) - attacker_damage_taken;
        let defender_ship_hp = ship::health_points(defender_ship) - defender_damage_taken;
        ship::set_health_points(defender_ship, defender_ship_hp);
        ship::set_health_points(attacker_ship, attacker_ship_hp);
        (attacker_ship_hp, defender_ship_hp)
    }

    fun calculate_ship_experience(ship: &Ship, is_environment_owned: bool): u32 {
        if (is_environment_owned) {
            let building_expenses = ship::building_expenses(ship);
            ship_util::calculate_environment_ship_experience(&item_id_quantity_pairs::items(&building_expenses))
        } else {
            PLAYER_SHIP_EXPERIENCE
        }
    }
}
