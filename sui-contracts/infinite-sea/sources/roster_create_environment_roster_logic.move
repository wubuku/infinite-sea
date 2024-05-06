#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea::roster_create_environment_roster_logic {
    use std::option;
    use std::vector;

    use sui::object;
    use sui::object_table;
    use sui::tx_context::TxContext;
    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea_common::item_id;
    use infinite_sea_common::item_id_quantity_pairs;
    use infinite_sea_common::roster_id;
    use infinite_sea_common::roster_id::RosterId;
    use infinite_sea_common::roster_status;
    use infinite_sea_common::ship_util;
    use infinite_sea_common::ts_random_util;

    use infinite_sea::roster;
    use infinite_sea::roster_util;
    use infinite_sea::ship;
    use infinite_sea::ship_aggregate;

    friend infinite_sea::roster_aggregate;

    const EInvalidShipResourceQuantity: u64 = 1;
    const EInvalidShipBaseResourceQuantity: u64 = 2;

    public(friend) fun verify(
        roster_id: RosterId,
        coordinates: Coordinates,
        ship_resource_quantity: u32,
        ship_base_resource_quantity: u32,
        base_experience: u32,
        roster_table: &roster::RosterTable,
        ctx: &mut TxContext,
    ): roster::EnvironmentRosterCreated {
        assert!(ship_resource_quantity >= ship_base_resource_quantity * 3, EInvalidShipResourceQuantity);
        assert!(ship_base_resource_quantity > 0, EInvalidShipBaseResourceQuantity);
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
        let total_roster_speed = 0;
        let roster = roster::create_roster(roster_id, status, total_roster_speed, sui::object_table::new(ctx),
            coordinates,
            0, //coordinates_updated_at,
            option::none(), //target_coordinates,
            option::none(), //ship_battle_id,
            roster_table, ctx,
        );
        roster::set_base_experience(&mut roster, option::some(base_experience));

        let position = 0;
        let number_of_ships = 4; //todo magic number?
        while (position < number_of_ships) {
            // only one ship for now!
            let player_id = roster_id::player_id(&roster_id);

            let building_expenses_item_ids = vector[item_id::copper_ore(), item_id::normal_logs(), item_id::cottons()];
            // distribute random resources based on ship_resource_quantity
            let current_resource_quantity = ship_resource_quantity;// / number_of_ships;
            // if (position == number_of_ships - 1) {
            //     current_resource_quantity = current_resource_quantity + (ship_resource_quantity % number_of_ships);
            // };
            let random_resource_quantities = ts_random_util::divide_int_with_epoch_timestamp_ms(
                ctx,
                object::id_to_bytes(&roster::id(&roster)),
                ((current_resource_quantity - ship_base_resource_quantity * 3) as u64),
                3
            );
            let building_expenses_item_quantities = vector[
                ship_base_resource_quantity + (*vector::borrow(&random_resource_quantities, 0) as u32),
                ship_base_resource_quantity + (*vector::borrow(&random_resource_quantities, 1) as u32),
                ship_base_resource_quantity + (*vector::borrow(&random_resource_quantities, 2) as u32),
            ];
            let building_expenses = item_id_quantity_pairs::new(
                building_expenses_item_ids,
                building_expenses_item_quantities
            );
            let (health_points, attack, protection, ship_speed) = ship_util::calculate_ship_attributes(
                &item_id_quantity_pairs::items(&building_expenses)
            );
            let ship = ship_aggregate::create(player_id, health_points, attack, protection, ship_speed,
                building_expenses, ctx,
            );

            let ship_id = ship::id(&ship);
            let ship_ids = roster::borrow_mut_ship_ids(&mut roster);
            roster_util::add_ship_id(ship_ids, ship_id, option::some((position as u64)));
            let ships = roster::borrow_mut_ships(&mut roster);
            object_table::add(ships, ship_id, ship);

            total_roster_speed = total_roster_speed + ship_speed;

            position = position + 1;
        };

        let roster_speed = total_roster_speed / number_of_ships;
        roster::set_speed(&mut roster, roster_speed);
        roster::set_environment_owned(&mut roster, true);
        roster::set_base_experience(&mut roster, option::some(base_experience));

        roster
    }
}
