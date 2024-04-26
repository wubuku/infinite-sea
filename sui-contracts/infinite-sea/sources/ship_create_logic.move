#[allow(unused_mut_parameter)]
module infinite_sea::ship_create_logic {
    use infinite_sea::ship;
    use infinite_sea_common::item_id_quantity_pairs::ItemIdQuantityPairs;
    use sui::object::ID;
    use sui::tx_context::TxContext;

    friend infinite_sea::ship_aggregate;

    public(friend) fun verify(
        owner: ID,
        health_points: u32,
        attack: u32,
        protection: u32,
        speed: u32,
        building_expenses: ItemIdQuantityPairs,
        ctx: &mut TxContext,
    ): ship::ShipCreated {
        let _ = ctx;
        ship::new_ship_created(
            owner,
            health_points,
            attack,
            protection,
            speed,
            building_expenses,
        )
    }

    public(friend) fun mutate(
        ship_created: &ship::ShipCreated,
        ctx: &mut TxContext,
    ): ship::Ship {
        let owner = ship::ship_created_owner(ship_created);
        let health_points = ship::ship_created_health_points(ship_created);
        let attack = ship::ship_created_attack(ship_created);
        let protection = ship::ship_created_protection(ship_created);
        let speed = ship::ship_created_speed(ship_created);
        let building_expenses = ship::ship_created_building_expenses(ship_created);
        ship::new_ship(
            owner,
            health_points,
            attack,
            protection,
            speed,
            building_expenses,
            ctx,
        )
    }

}
