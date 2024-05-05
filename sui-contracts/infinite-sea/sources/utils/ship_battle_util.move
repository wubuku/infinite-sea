module infinite_sea::ship_battle_util {
    use std::bcs;
    use std::option;
    use std::option::Option;
    use std::vector;

    use sui::clock::Clock;
    use sui::math;
    use sui::object::ID;
    use sui::object_table;
    use infinite_sea_common::direct_route_util;
    use infinite_sea_common::ts_random_util;
    use infinite_sea_common::vector_util;

    use infinite_sea::permission_util;
    use infinite_sea::player::Player;
    use infinite_sea::roster::{Self, Roster};
    use infinite_sea::ship::{Self, Ship};
    use infinite_sea::ship_battle::{Self, ShipBattle};

    friend infinite_sea::ship_battle_initiate_battle_logic;
    friend infinite_sea::ship_battle_make_move_logic;

    const EInitiatorBattleIdMismatch: u64 = 10;
    const EResponderBattleIdMismatch: u64 = 11;
    const EInitiatorIdMismatch: u64 = 12;
    const EResponderIdMismatch: u64 = 13;
    const EShipNotFoundById: u64 = 21;
    const ENoLivingShips: u64 = 22;
    const ERoundMoverNotSet: u64 = 23;

    const MIN_DISTANCE_TO_BATTLE: u64 = 3; //todo is it ok?

    public fun initiator(): u8 {
        1
    }

    public fun responder(): u8 {
        2
    }

    /// Get the "opposite" side.
    public fun opposite_side(side: u8): u8 {
        if (side == initiator()) {
            responder()
        } else {
            initiator()
        }
    }

    public fun assert_ids_are_consistent_and_player_is_current_round_mover(
        player: &Player, ship_battle: &ShipBattle, initiator: &Roster, responder: &Roster
    ) {
        assert_ids_are_consistent(ship_battle, initiator, responder);
        assert_player_is_current_round_mover(player, ship_battle, initiator, responder);
    }

    public fun assert_player_is_current_round_mover(
        player: &Player, ship_battle: &ShipBattle, initiator: &Roster, responder: &Roster
    ) {
        let round_mover = ship_battle::round_mover(ship_battle);
        assert!(option::is_some(&round_mover), ERoundMoverNotSet);
        if (*option::borrow(&round_mover) == initiator()) {
            permission_util::assert_player_is_roster_owner(player, initiator);
        } else {
            permission_util::assert_player_is_roster_owner(player, responder);
        };
    }

    public fun assert_ids_are_consistent(ship_battle: &ShipBattle, initiator: &Roster, responder: &Roster) {
        let battle_id = ship_battle::id(ship_battle);
        let i_battle_id = roster::ship_battle_id(initiator);
        assert!(battle_id == *option::borrow(&i_battle_id), EInitiatorBattleIdMismatch);
        let r_battle_id = roster::ship_battle_id(responder);
        assert!(battle_id == *option::borrow(&r_battle_id), EResponderBattleIdMismatch);

        let initiator_id = ship_battle::initiator(ship_battle);
        assert!(initiator_id == roster::id(initiator), EInitiatorIdMismatch);

        let responder_id = ship_battle::responder(ship_battle);
        assert!(responder_id == roster::id(responder), EResponderIdMismatch);
    }

    /// Check if the two rosters are close enough to initiate a battle.
    public fun are_rosters_close_enough(roster_1: &Roster, roster_2: &Roster): bool {
        let c_1 = roster::updated_coordinates(roster_1);
        let c_2 = roster::updated_coordinates(roster_2);
        let d = direct_route_util::get_distance(c_1, c_2);
        d <= MIN_DISTANCE_TO_BATTLE
    }

    /// Returns the ID of the attacker ship that should go first in the battle round, the ID of the defender ship,
    /// and the indicator (1 or 2) of the roster that the attacker belongs to.
    public(friend) fun determine_attacker_and_defender(
        roster_1: &Roster,
        roster_2: &Roster,
        clock: &Clock,
        round_number: u32
    ): (ID, ID, u8) {
        let (attacker_ship_id, roster_indicator) = determine_ship_to_go_first(roster_1, roster_2, clock, round_number);
        let defender_ship_id = if (roster_indicator == 1) {
            let d_id = get_front_ship(roster_2);
            assert!(option::is_some(&d_id), ENoLivingShips);
            option::extract(&mut d_id)
        } else {
            let d_id = get_front_ship(roster_1);
            assert!(option::is_some(&d_id), ENoLivingShips);
            option::extract(&mut d_id)
        };
        (attacker_ship_id, defender_ship_id, roster_indicator)
    }

    /*
    def generate_turn_order(ships):
        turn_order = []
        for ship in ships:
            if ship.hp > 0:  # Only consider ships that are still active
                initiative = random.randint(1, 8) + ship.speed
                turn_order.append((ship, initiative))
        # Sort ships by their initiative score, highest first
        turn_order.sort(key=lambda x: x[1], reverse=True)
        return [ship[0] for ship in turn_order]
    */

    /// Determine which ship should go first in the battle round, based on the initiative score.
    /// Initiative score is calculated based on the ship's speed and a random number.
    /// Returns the ID of the ship that should go first and the indicator (1 or 2) of the roster that the ship belongs to.
    public(friend) fun determine_ship_to_go_first(
        roster_1: &Roster,
        roster_2: &Roster,
        clock: &Clock,
        round_number: u32
    ): (ID, u8) {
        let seed_1 = vector_util::concat_ids_bytes(&vector[roster::id(roster_1), roster::id(roster_2)]);
        vector::append(&mut seed_1, bcs::to_bytes(&round_number));
        let (candidate_1, initiative_1) = get_candidate_attacker_ship_id(roster_1, clock, seed_1);
        let seed_2 = vector::empty<u8>();
        vector::append(&mut seed_2, bcs::to_bytes(&initiative_1));
        vector::append(&mut seed_2, bcs::to_bytes(&vector::length(&roster::ship_ids(roster_1))));
        vector::append(&mut seed_2, seed_1);
        let (candidate_2, initiative_2) = get_candidate_attacker_ship_id(roster_2, clock, seed_2);
        assert!(!(option::is_none(&candidate_1) && option::is_none(&candidate_2)), ENoLivingShips);
        if (option::is_none(&candidate_1)) {
            (option::extract(&mut candidate_2), 2)
        } else if (option::is_none(&candidate_2)) {
            (option::extract(&mut candidate_1), 1)
        } else if (initiative_1 >= initiative_2) {
            (option::extract(&mut candidate_1), 1)
        } else {
            //if (initiative_1 < initiative_2)
            (option::extract(&mut candidate_2), 2)
        }
    }

    fun get_candidate_attacker_ship_id(roster: &Roster, clock: &Clock, seed: vector<u8>): (Option<ID>, u64) {
        let ship_ids = roster::borrow_ship_ids(roster);
        let ships = roster::borrow_ships(roster);
        //let turn_order = vector::empty<ID>();
        let i = 0;
        let l = vector::length(ship_ids);
        let max_initiative = 0;
        let candidate = option::none<ID>();
        while (i < l) {
            let ship_id = *vector::borrow(ship_ids, i);
            assert!(object_table::contains(ships, ship_id), EShipNotFoundById);
            let ship = object_table::borrow(ships, ship_id);
            if (ship::health_points(ship) > 0) {
                let s = bcs::to_bytes(&i);
                vector::append(&mut s, seed);
                let initiative = 1 + ts_random_util::get_int(clock, s, 8) + (ship::speed(ship) as u64);
                //vector::push_back(&mut turn_order, ship_id);
                if (initiative > max_initiative) {
                    max_initiative = initiative;
                    candidate = option::some(ship_id);
                };
            };
            i = i + 1;
        };
        (candidate, max_initiative)
    }

    /*
    def get_front_ship(ships):
        return next((ship for ship in ships if ship.hp > 0), None)
    */

    public fun get_front_ship(roster: &Roster): Option<ID> {
        let ship_ids = roster::borrow_ship_ids(roster);
        let ships = roster::borrow_ships(roster);
        let i = 0;
        let l = vector::length(ship_ids);
        while (i < l) {
            let ship_id = *vector::borrow(ship_ids, i);
            assert!(object_table::contains(ships, ship_id), EShipNotFoundById);
            let ship = object_table::borrow(ships, ship_id);
            if (ship::health_points(ship) > 0) {
                return option::some(ship_id)
            };
            i = i + 1;
        };
        option::none()
    }

    public fun perform_attack(self: &Ship, opponent: &Ship, clock: &Clock, round_number: u32): u32 {
        // Dodge check
        let dodge_chance = if (ship::protection(opponent) >= ship::attack(self)) {
            math::min(60, ((ship::protection(opponent) - ship::attack(self)) as u64) * 8 + 15)
        } else {
            0
        };
        let seed_1 = vector_util::concat_ids_bytes(&vector[ship::id(self), ship::id(opponent)]);
        vector::append(&mut seed_1, bcs::to_bytes(&round_number));
        if (1 + ts_random_util::get_int(clock, seed_1, 100) <= dodge_chance) {
            return 0
        };

        // Damage calculation with base formula
        let damage = if (ship::attack(self) < ship::protection(opponent)) {
            let d = ship::protection(opponent) - ship::attack(self);
            if (ship::attack(self) > d) {
                math::max(2, (ship::attack(self) - d as u64) * 3 / 10)
            } else {
                0
            }
        } else {
            (ship::attack(self) - ship::protection(opponent) as u64) * 4 / 5
        };

        let seed_2 = vector_util::concat_ids_bytes(&vector[ship::id(opponent), ship::id(self)]);
        vector::append(&mut seed_2, bcs::to_bytes(&round_number));

        // Critical hit and miss logic
        let critical_hit_chance = 20;  // 20% chance for a critical hit
        let critical_miss_chance = 35;  // 35% chance for a critical miss
        if (ts_random_util::get_int(clock, seed_2, 100) < critical_miss_chance) {
            // Critical miss negates all damage
            return 0
        } else {
            let seed_3 = vector::empty<u8>();
            vector::append(&mut seed_3, bcs::to_bytes(&ship::health_points(opponent)));
            vector::append(&mut seed_3, bcs::to_bytes(&ship::health_points(self)));
            vector::append(&mut seed_3, seed_2);
            if (ts_random_util::get_int(clock, seed_3, 100) < critical_hit_chance) {
                // Critical hit doubles the damage
                //damage *= 1.5;
                damage = damage * 3 / 2;
            }
        };
        (damage as u32)
        //opponent.hp -= damage;  // Apply the calculated damage to the opponent's HP
    }
}
