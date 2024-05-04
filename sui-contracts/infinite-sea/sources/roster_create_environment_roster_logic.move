#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_create_environment_roster_logic {
    use std::option;

    use sui::object_table;
    use sui::tx_context::TxContext;
    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea_common::item_id;
    use infinite_sea_common::item_id_quantity_pairs;
    use infinite_sea_common::roster_id;
    use infinite_sea_common::roster_id::RosterId;
    use infinite_sea_common::roster_status;
    use infinite_sea_common::ship_util;

    use infinite_sea::roster;
    use infinite_sea::roster_util;
    use infinite_sea::ship;
    use infinite_sea::ship_aggregate;

    friend infinite_sea::roster_aggregate;

    public(friend) fun verify(
        roster_id: RosterId,
        coordinates: Coordinates,
        ship_resource_quantity: u32,
        ship_base_resource_quantity: u32,
        base_experience: u32,
        roster_table: &roster::RosterTable,
        ctx: &mut TxContext,
    ): roster::EnvironmentRosterCreated {
        roster::asset_roster_id_not_exists(roster_id, roster_table);
        roster::new_environment_roster_created(
            roster_id, coordinates, ship_resource_quantity, ship_base_resource_quantity, base_experience
        )
    }

    public(friend) fun mutate(
        environment_roster_created: &roster::EnvironmentRosterCreated,
        roster_table: &mut roster::RosterTable,
        ctx: &mut TxContext,
    ): roster::Roster {
        let roster_id = roster::environment_roster_created_roster_id(environment_roster_created);
        let coordinates = roster::environment_roster_created_coordinates(environment_roster_created);
        let ship_resource_quantity = roster::environment_roster_created_ship_resource_quantity(
            environment_roster_created
        );
        let ship_base_resource_quantity = roster::environment_roster_created_ship_base_resource_quantity(
            environment_roster_created
        );
        let base_experience = roster::environment_roster_created_base_experience(environment_roster_created);

        let status = roster_status::at_anchor();
        let speed = 0;//todo
        let roster = roster::create_roster(roster_id, status, speed, sui::object_table::new(ctx),
            coordinates,
            0, //coordinates_updated_at,
            option::none(), //target_coordinates,
            option::none(), //ship_battle_id,
            roster_table, ctx,
        );
        roster::set_base_experience(&mut roster, option::some(base_experience));

        let position = 0;
        while (position < 4) {
            let player_id = roster_id::player_id(&roster_id);

            let building_expences_item_ids = vector[item_id::copper_ore(), item_id::normal_logs(), item_id::cottons()];
            let building_expences_item_quantities = vector[ship_base_resource_quantity, ship_base_resource_quantity, ship_base_resource_quantity];
            let building_expences = item_id_quantity_pairs::new(
                building_expences_item_ids,
                building_expences_item_quantities
            );
            let (health_points, attack, protection, speed) = ship_util::calculate_ship_attributes(
                &item_id_quantity_pairs::items(&building_expences)
            );
            let ship = ship_aggregate::create(player_id, health_points, attack, protection, speed,
                building_expences, ctx,
            );

            let ship_id = ship::id(&ship);
            let ship_ids = roster::borrow_mut_ship_ids(&mut roster);
            roster_util::add_ship_id(ship_ids, ship_id, option::some(position));
            let ships = roster::borrow_mut_ships(&mut roster);
            object_table::add(ships, ship_id, ship);

            position = position + 1;
        };

        let speed = roster_util::calculate_roster_speed(&roster);//todo better speed calculation?
        roster::set_speed(&mut roster, speed);

        roster
    }
}
