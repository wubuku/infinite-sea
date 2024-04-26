#[allow(unused_mut_parameter)]
module infinite_sea::roster_create_logic {
    use std::option::Option;

    use sui::object::ID;
    use sui::tx_context::TxContext;
    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea_common::roster_id::RosterId;

    use infinite_sea::roster;

    friend infinite_sea::roster_aggregate;

    public(friend) fun verify(
        roster_id: RosterId,
        status: u8,
        speed: u32,
        ship_ids: vector<ID>,
        updated_coordinates: Coordinates,
        coordinates_updated_at: u64,
        target_coordinates: Option<Coordinates>,
        ship_battle_id: Option<ID>,
        roster_id_table: &roster::RosterTable,
        ctx: &mut TxContext,
    ): roster::RosterCreated {
        let _ = ctx;
        roster::asset_roster_id_not_exists(roster_id, roster_id_table);
        roster::new_roster_created(
            roster_id,
            status,
            speed,
            ship_ids,
            updated_coordinates,
            coordinates_updated_at,
            target_coordinates,
            ship_battle_id,
        )
    }

    public(friend) fun mutate(
        roster_created: &mut roster::RosterCreated,
        roster_id_table: &mut roster::RosterTable,
        ctx: &mut TxContext,
    ): roster::Roster {
        let roster_id = roster::roster_created_roster_id(roster_created);
        let status = roster::roster_created_status(roster_created);
        let speed = roster::roster_created_speed(roster_created);
        let ship_ids = roster::roster_created_ship_ids(roster_created);
        let updated_coordinates = roster::roster_created_updated_coordinates(roster_created);
        let coordinates_updated_at = roster::roster_created_coordinates_updated_at(roster_created);
        let target_coordinates = roster::roster_created_target_coordinates(roster_created);
        let ship_battle_id = roster::roster_created_ship_battle_id(roster_created);
        roster::create_roster(
            roster_id,
            status,
            speed,
            ship_ids,
            sui::object_table::new(ctx),
            updated_coordinates,
            coordinates_updated_at,
            target_coordinates,
            ship_battle_id,
            roster_id_table,
            ctx,
        )
    }
}
