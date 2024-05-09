// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module infinite_sea::map_aggregate {
    use infinite_sea::map;
    use infinite_sea::map_add_island_logic;
    use infinite_sea::map_claim_island_logic;
    use infinite_sea::map_gather_island_resources_logic;
    use infinite_sea::player::Player;
    use infinite_sea_common::coordinates::{Self, Coordinates};
    use infinite_sea_common::item_id_quantity_pairs::{Self, ItemIdQuantityPairs};
    use sui::clock::Clock;
    use sui::object::ID;
    use sui::tx_context;

    friend infinite_sea::player_claim_island_logic;
    friend infinite_sea::skill_process_service;
    friend infinite_sea::roster_service;
    friend infinite_sea::ship_battle_service;

    const EInvalidAdminCap: u64 = 50;

    public entry fun add_island(
        map: &mut map::Map,
        admin_cap: &map::AdminCap,
        coordinates_x: u32,
        coordinates_y: u32,
        resources_item_id_list: vector<u32>,
        resources_item_quantity_list: vector<u32>,
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(map::admin_cap(map) == sui::object::id(admin_cap), EInvalidAdminCap);
        map::assert_schema_version(map);
        let coordinates: Coordinates = coordinates::new(
            coordinates_x,
            coordinates_y,
        );
        let resources: ItemIdQuantityPairs = item_id_quantity_pairs::new(
            resources_item_id_list,
            resources_item_quantity_list,
        );
        let island_added = map_add_island_logic::verify(
            coordinates,
            resources,
            map,
            ctx,
        );
        map_add_island_logic::mutate(
            &island_added,
            map,
            ctx,
        );
        map::update_object_version(map);
        map::emit_island_added(island_added);
    }

    public(friend) fun claim_island(
        map: &mut map::Map,
        coordinates: Coordinates,
        claimed_by: ID,
        claimed_at: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        map::assert_schema_version(map);
        let map_island_claimed = map_claim_island_logic::verify(
            coordinates,
            claimed_by,
            claimed_at,
            map,
            ctx,
        );
        map_claim_island_logic::mutate(
            &map_island_claimed,
            map,
            ctx,
        );
        map::update_object_version(map);
        map::emit_map_island_claimed(map_island_claimed);
    }

    public entry fun gather_island_resources(
        map: &mut map::Map,
        player: &mut Player,
        clock: &Clock,
        ctx: &mut tx_context::TxContext,
    ) {
        map::assert_schema_version(map);
        let island_resources_gathered = map_gather_island_resources_logic::verify(
            player,
            clock,
            map,
            ctx,
        );
        map_gather_island_resources_logic::mutate(
            &island_resources_gathered,
            player,
            map,
            ctx,
        );
        map::update_object_version(map);
        map::emit_island_resources_gathered(island_resources_gathered);
    }

}
