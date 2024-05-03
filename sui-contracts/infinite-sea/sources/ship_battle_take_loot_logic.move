#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::ship_battle_take_loot_logic {
    use std::option;
    use std::vector;

    use sui::object_table;
    use sui::tx_context::TxContext;
    use infinite_sea_common::battle_status;
    use infinite_sea_common::item_id_quantity_pairs;
    use infinite_sea_common::vector_util;

    use infinite_sea::loot_util;
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

    public(friend) fun verify(
        initiator: &mut Roster,
        responder: &mut Roster,
        ship_battle: &ship_battle::ShipBattle,
        ctx: &TxContext,
    ): ship_battle::ShipBattleLootTaken {
        ship_battle_util::assert_ids_are_consistent(ship_battle, initiator, responder);
        assert!(ship_battle::status(ship_battle) == battle_status::ended(), EBattleNotEnded);
        let winner = option::extract(&mut ship_battle::winner(ship_battle));
        //todo more checks?
        let loser: &mut Roster;
        if (winner == ship_battle_util::initiator()) {
            assert!(roster_util::is_destroyed(responder), EResponderNotDestroyed);
            loser = responder;
        } else if (winner == ship_battle_util::responder()) {
            assert!(roster_util::is_destroyed(initiator), EInitiatorNotDestroyed);
            loser = initiator;
        } else {
            abort EInvalidWinner
        };
        let ship_ids = roster::ship_ids(loser);
        let ships = roster::borrow_mut_ships(loser);
        let loot_item_ids = vector::empty<u32>();
        let loot_item_quantities = vector::empty<u32>();
        let i = 0;
        let l = vector::length(&ship_ids);
        while (i < l) {
            let ship_id = *vector::borrow(&ship_ids, i);
            let ship = object_table::remove(ships, ship_id);
            let (ids, qs) = loot_util::calculate_loot(&ship);
            vector::append(&mut loot_item_ids, ids);
            vector::append(&mut loot_item_quantities, qs);
            ship::drop_ship(ship); // Maybe remove and drop ship in mutate would be better?
            i = i + 1;
        };
        item_id_quantity_pairs::new(loot_item_ids, loot_item_quantities);
        ship_battle::new_ship_battle_loot_taken(
            ship_battle,
            vector_util::new_item_id_quantity_pairs(loot_item_ids, loot_item_quantities)
        )
    }

    public(friend) fun mutate(
        ship_battle_loot_taken: &ship_battle::ShipBattleLootTaken,
        initiator: &mut Roster,
        responder: &mut Roster,
        ship_battle: &mut ship_battle::ShipBattle,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let winner = option::extract(&mut ship_battle::winner(ship_battle));
        let loot = ship_battle::ship_battle_loot_taken_loot(ship_battle_loot_taken);
        //let id = ship_battle::id(ship_battle);
        let winner_roster: &mut Roster;
        if (winner == ship_battle_util::initiator()) {
            winner_roster = initiator;
        } else if (winner == ship_battle_util::responder()) {
            winner_roster = responder;
        } else {
            abort EInvalidWinner
        };
        let last_ship_id = roster_util::get_last_ship_id(winner_roster);
        let ships = roster::borrow_mut_ships(winner_roster);
        let ship = object_table::borrow_mut(ships, last_ship_id);
        let inv = ship::borrow_mut_inventory(ship);
        vector_util::merge_item_id_quantity_pairs(inv, &loot);
        //todo more operations?
    }
}
