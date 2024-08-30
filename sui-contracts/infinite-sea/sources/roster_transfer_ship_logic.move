#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_transfer_ship_logic {
    use std::option;
    use std::option::Option;
    use std::vector;

    use sui::clock;
    use sui::clock::Clock;
    use sui::object::ID;
    use sui::object_table;
    use sui::tx_context::TxContext;
    use infinite_sea_common::roster_id;
    use infinite_sea_common::roster_sequence_number;
    use infinite_sea_common::ship_util;

    use infinite_sea::permission_util;
    use infinite_sea::player::Player;
    use infinite_sea::roster::{Self, Roster};
    use infinite_sea::roster_util;

    friend infinite_sea::roster_aggregate;

    const EShipNotFoundInSourceRoster: u64 = 10;
    const ERostersTooFarAway: u64 = 11;
    const ERosterInBattle: u64 = 12;
    const EToRosterInBattle: u64 = 13;

    public(friend) fun verify(
        player: &Player,
        ship_id: ID,
        to_roster: &mut Roster,
        to_position: Option<u64>,
        clock: &Clock,
        roster: &roster::Roster,
        ctx: &TxContext,
    ): roster::RosterShipTransferred {
        let to_roster_id = roster::roster_id(to_roster);
        permission_util::assert_sender_is_player_owner(player, ctx);
        permission_util::assert_player_is_roster_owner(player, roster);
        permission_util::assert_player_is_roster_owner(player, to_roster);
        assert!(roster_util::are_rosters_close_enough_to_transfer(roster, to_roster), ERostersTooFarAway);
        if (roster_id::sequence_number(&to_roster_id) != roster_sequence_number::unassigned_ships()) {
            roster_util::assert_roster_ships_not_full(to_roster);
        };
        assert!(option::is_none(&roster::ship_battle_id(roster)), ERosterInBattle);
        assert!(option::is_none(&roster::ship_battle_id(to_roster)), EToRosterInBattle);
        //todo more checks?
        let transferred_at = clock::timestamp_ms(clock) / 1000;
        roster::new_roster_ship_transferred(roster, ship_id, to_roster_id, to_position, transferred_at)
    }

    public(friend) fun mutate(
        roster_ship_transferred: &mut roster::RosterShipTransferred,
        to_roster: &mut Roster,
        roster: &mut roster::Roster,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let ship_id = roster::roster_ship_transferred_ship_id(roster_ship_transferred);
        let to_position = roster::roster_ship_transferred_to_position(roster_ship_transferred);
        let transferred_at = roster::roster_ship_transferred_transferred_at(roster_ship_transferred);
        //let to_roster_id = roster::roster_ship_transferred_to_roster_id(roster_ship_transferred);
        //let roster_id = roster::roster_id(roster);

        let from_roster = roster;
        let from_ship_ids = roster::ship_ids(from_roster);
        ship_util::remove_ship_id(&mut from_ship_ids, ship_id);
        roster::set_ship_ids(from_roster, from_ship_ids);

        let from_ships = roster::borrow_mut_ships(from_roster);
        assert!(object_table::contains(from_ships, ship_id), EShipNotFoundInSourceRoster);
        let ship = object_table::remove(from_ships, ship_id);
        //将船从原来的船队移除后重新计算原来船队的速度
        let speed = roster_util::calculate_roster_speed(roster);
        roster::set_speed(roster, speed);

        let to_ship_ids = roster::ship_ids(to_roster);
        //指定了位置那么就插入指定的位置
        if (option::is_some(&to_position)) {
            vector::insert(&mut to_ship_ids, ship_id, option::extract(&mut to_position));
        } else {
            vector::push_back(&mut to_ship_ids, ship_id);
        };
        roster::set_ship_ids(to_roster, to_ship_ids);

        let to_ships = roster::borrow_mut_ships(to_roster);
        object_table::add(to_ships, ship_id, ship);

        let speed = roster_util::calculate_roster_speed(to_roster);
        roster::set_speed(to_roster, speed);
        //将roster的最后一次更新位置时间更改为当前时间（其实这里是借用了此字段）
        roster::set_coordinates_updated_at(roster, transferred_at);
        roster::set_coordinates_updated_at(to_roster, transferred_at);
    }
}
