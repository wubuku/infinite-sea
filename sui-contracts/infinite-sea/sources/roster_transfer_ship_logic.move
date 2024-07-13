#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_transfer_ship_logic {
    use std::option;
    use std::option::Option;
    use std::vector;

    use sui::object::ID;
    use sui::object_table;
    use sui::tx_context::TxContext;
    use infinite_sea_common::ship_util;

    use infinite_sea::permission_util;
    use infinite_sea::player::Player;
    use infinite_sea::roster::{Self, Roster};
    use infinite_sea::roster_util;

    friend infinite_sea::roster_aggregate;

    const EShipNotFoundInSourceRoster: u64 = 10;
    const ERostersTooFarAway: u64 = 11;

    public(friend) fun verify(
        player: &Player,
        ship_id: ID,
        to_roster: &mut Roster,
        to_position: Option<u64>,
        roster: &roster::Roster,
        ctx: &TxContext,
    ): roster::RosterShipTransferred {
        let to_roster_id = roster::roster_id(to_roster);
        permission_util::assert_sender_is_player_owner(player, ctx);
        permission_util::assert_player_is_roster_owner(player, roster);
        permission_util::assert_player_is_roster_owner(player, to_roster);
        assert!(roster_util::are_rosters_close_enough_to_transfer(roster, to_roster), ERostersTooFarAway);
        roster_util::assert_roster_ships_not_full(to_roster);
        //todo more checks?  应该检查一下在目标船队里面有这个位置：to_position
        roster::new_roster_ship_transferred(roster, ship_id, to_roster_id, to_position)
    }

    public(friend) fun mutate(
        roster_ship_transferred: &mut roster::RosterShipTransferred,
        to_roster: &mut Roster,
        roster: &mut roster::Roster,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let ship_id = roster::roster_ship_transferred_ship_id(roster_ship_transferred);
        let to_position = roster::roster_ship_transferred_to_position(roster_ship_transferred);
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
    }
}
