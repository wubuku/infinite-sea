#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::ship_battle_take_loot_logic {
    use std::option;
    use std::vector;

    use sui::clock;
    use sui::clock::Clock;
    use sui::object_table;
    use sui::tx_context::TxContext;
    use infinite_sea_common::battle_status;
    use infinite_sea_common::experience_table::ExperienceTable;
    use infinite_sea_common::item_id_quantity_pair::ItemIdQuantityPair;
    use infinite_sea_common::roster_status;
    use infinite_sea_common::sorted_vector_util;

    use infinite_sea::experience_table_util;
    use infinite_sea::loot_util;
    use infinite_sea::permission_util;
    use infinite_sea::player;
    use infinite_sea::player::Player;
    use infinite_sea::roster::{Self, Roster};
    use infinite_sea::roster_util;
    use infinite_sea::ship;
    use infinite_sea::ship_battle;
    use infinite_sea::ship_battle_util;

    friend infinite_sea::ship_battle_aggregate;

    const EInitiatorNotDestroyed: u64 = 10;
    const EResponderNotDestroyed: u64 = 11;
    const EInvalidWinner: u64 = 12;
    const EBattleNotEnded: u64 = 13;
    const EInvalidLoserStatus: u64 = 14;
    const EWinnerNotSet: u64 = 15;

    #[allow(unused_const)]
    const CHOICE_TAKE_ALL: u8 = 1;
    #[allow(unused_const)]
    const CHOICE_LEAVE_IT: u8 = 0;

    public(friend) fun verify(
        player: &mut Player,
        loser_player: &mut Player,
        initiator: &mut Roster,
        responder: &mut Roster,
        experience_table: &ExperienceTable,
        clock: &Clock,
        choice: u8,
        ship_battle: &ship_battle::ShipBattle,
        ctx: &TxContext,
    ): ship_battle::ShipBattleLootTaken {
        ship_battle_util::assert_ids_are_consistent(ship_battle, initiator, responder);
        assert!(ship_battle::status(ship_battle) == battle_status::ended(), EBattleNotEnded);
        assert!(option::is_some(&ship_battle::winner(ship_battle)), EWinnerNotSet);
        let winner = option::extract(&mut ship_battle::winner(ship_battle));
        let winner_roster: &Roster;
        let loser_roster: &mut Roster;
        let winner_increased_experience: u32;
        let loser_increased_experience: u32;
        if (winner == ship_battle_util::initiator()) {
            assert!(roster_util::is_destroyed(responder), EResponderNotDestroyed);
            winner_roster = initiator;
            loser_roster = responder;
            winner_increased_experience = get_winner_increased_experience(
                ship_battle::initiator_experiences(ship_battle)
            );
            loser_increased_experience = get_loser_increased_experience(
                ship_battle::responder_experiences(ship_battle)
            );
        } else if (winner == ship_battle_util::responder()) {
            assert!(roster_util::is_destroyed(initiator), EInitiatorNotDestroyed);
            winner_roster = responder;
            loser_roster = initiator;
            winner_increased_experience = get_winner_increased_experience(
                ship_battle::responder_experiences(ship_battle)
            );
            loser_increased_experience = get_loser_increased_experience(
                ship_battle::initiator_experiences(ship_battle)
            );
        } else {
            abort EInvalidWinner
        };
        if (roster::environment_owned(winner_roster)) {
            // Anyone can take the loot for the environment.
            choice = CHOICE_TAKE_ALL;
        } else {
            permission_util::assert_player_is_roster_owner(player, winner_roster);
        };
        assert!(roster::status(loser_roster) == roster_status::destroyed(), EInvalidLoserStatus);

        // Remove ships from the loser roster and calculate loot.
        let ship_ids = roster::ship_ids(loser_roster);
        let ships = roster::borrow_mut_ships(loser_roster);
        let loot_item_ids = vector::empty<u32>();
        let loot_item_quantities = vector::empty<u32>();
        let i = 0;
        let l = vector::length(&ship_ids);
        while (i < l) {
            let ship_id = vector::pop_back(&mut ship_ids);
            let ship = object_table::remove(ships, ship_id);
            if (choice != CHOICE_LEAVE_IT) {
                // take all for default
                let (ids, qs) = loot_util::calculate_loot(&ship);
                vector::append(&mut loot_item_ids, ids);
                vector::append(&mut loot_item_quantities, qs);
            };
            ship::drop_ship(ship); // Maybe remove and drop ship in "mutate" function would be better?
            i = i + 1;
        };
        roster::set_ship_ids(loser_roster, ship_ids);

        let base_experience = roster::base_experience(loser_roster);
        if (roster::environment_owned(loser_roster) && option::is_some(&base_experience)) {
            let b = *option::borrow(&base_experience);
            if (b > winner_increased_experience) { winner_increased_experience = b; };
        };
        let new_level = experience_table_util::calculate_new_level(
            player, experience_table, winner_increased_experience
        );
        let loser_new_level = experience_table_util::calculate_new_level(
            loser_player, experience_table, loser_increased_experience
        );

        ship_battle::new_ship_battle_loot_taken(
            ship_battle, choice, sorted_vector_util::new_item_id_quantity_pairs(loot_item_ids, loot_item_quantities),
            clock::timestamp_ms(clock) / 1000,
            winner_increased_experience, new_level, loser_increased_experience, loser_new_level,
        )
    }

    public(friend) fun mutate(
        ship_battle_loot_taken: &ship_battle::ShipBattleLootTaken,
        player: &mut Player,
        loser_player: &mut Player,
        initiator: &mut Roster,
        responder: &mut Roster,
        ship_battle: &mut ship_battle::ShipBattle,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let winner = option::extract(&mut ship_battle::winner(ship_battle));
        let loot = ship_battle::ship_battle_loot_taken_loot(ship_battle_loot_taken);
        let looted_at = ship_battle::ship_battle_loot_taken_looted_at(ship_battle_loot_taken);

        let winner_roster: &mut Roster;
        let loser_roster: &mut Roster;
        if (winner == ship_battle_util::initiator()) {
            winner_roster = initiator;
            loser_roster = responder;
        } else if (winner == ship_battle_util::responder()) {
            winner_roster = responder;
            loser_roster = initiator;
        } else {
            abort EInvalidWinner
        };

        update_winner_inventory(winner_roster, loot);
        update_winner_roster_status(winner_roster, looted_at);
        update_loser_roster_status(loser_roster, loser_player, looted_at);

        ship_battle::set_status(ship_battle, battle_status::looted());

        let increased_experience = ship_battle::ship_battle_loot_taken_increased_experience(ship_battle_loot_taken);
        let new_level = ship_battle::ship_battle_loot_taken_new_level(ship_battle_loot_taken);
        let old_experience = player::experience(player);
        player::set_experience(player, old_experience + increased_experience);
        player::set_level(player, new_level);

        let loser_increased_experience = ship_battle::ship_battle_loot_taken_loser_increased_experience(
            ship_battle_loot_taken
        );
        let loser_new_level = ship_battle::ship_battle_loot_taken_loser_new_level(ship_battle_loot_taken);
        let loser_old_experience = player::experience(loser_player);
        player::set_experience(loser_player, loser_old_experience + loser_increased_experience);
        player::set_level(loser_player, loser_new_level);

        // more operations?
    }

    fun get_winner_increased_experience(xps: vector<u32>): u32 {
        let sum = 0;
        let i = 0;
        let l = vector::length(&xps);
        while (i < l) {
            sum = sum + *vector::borrow(&xps, i);
            i = i + 1;
        };
        sum
    }

    fun get_loser_increased_experience(xps: vector<u32>): u32 {
        let vc = 0;
        let sum = 0;
        let i = 0;
        let l = vector::length(&xps);
        while (i < l) {
            let x = *vector::borrow(&xps, i);
            if (x > 0) { vc = vc + 1 };
            sum = sum + x;
            i = i + 1;
        };
        // If loser has defeated more than 2 ships, then it will get the experience.
        if (vc >= 2) { sum } else { 0 }
    }

    fun update_winner_inventory(winner_roster: &mut Roster, loot: vector<ItemIdQuantityPair>) {
        let last_ship_id = roster_util::get_last_ship_id(winner_roster);
        let ships = roster::borrow_mut_ships(winner_roster);
        let ship = object_table::borrow_mut(ships, last_ship_id);
        let inv = ship::borrow_mut_inventory(ship);
        sorted_vector_util::merge_item_id_quantity_pairs(inv, &loot);
    }

    fun update_loser_roster_status(loser_roster: &mut Roster, loser_player: &mut Player, looted_at: u64) {
        if (roster::environment_owned(loser_roster)) {
            return
        };
        let island_coordinates = player::claimed_island(loser_player);
        roster::set_updated_coordinates(loser_roster, option::extract(&mut island_coordinates));
        roster::set_coordinates_updated_at(loser_roster, looted_at);
        roster::set_status(loser_roster, roster_status::at_anchor());
    }

    fun update_winner_roster_status(winner_roster: &mut Roster, looted_at: u64) {
        roster::set_ship_battle_id(winner_roster, option::none());
        let current_coordinates = roster::updated_coordinates(winner_roster);
        let target_coordinates = roster::target_coordinates(winner_roster);
        if (option::is_some(&target_coordinates) && *option::borrow(&target_coordinates) != current_coordinates) {
            roster::set_status(winner_roster, roster_status::underway());
        } else {
            roster::set_status(winner_roster, roster_status::at_anchor());
        };
        roster::set_coordinates_updated_at(winner_roster, looted_at);
    }
}
