// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module infinite_sea_map::map {
    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea_common::item_id_quantity_pair::ItemIdQuantityPair;
    use infinite_sea_common::item_id_quantity_pairs::ItemIdQuantityPairs;
    use infinite_sea_map::map_location::{Self, MapLocation};
    use sui::event;
    use sui::object::{Self, ID, UID};
    use sui::table;
    use sui::transfer;
    use sui::tx_context::TxContext;

    struct MAP has drop {}

    friend infinite_sea_map::map_add_island_logic;
    friend infinite_sea_map::map_claim_island_logic;
    friend infinite_sea_map::map_gather_island_resources_logic;
    friend infinite_sea_map::map_aggregate;

    const EIdAlreadyExists: u64 = 101;
    #[allow(unused_const)]
    const EDataTooLong: u64 = 102;
    #[allow(unused_const)]
    const EInappropriateVersion: u64 = 103;
    const EIdNotFound: u64 = 111;

    /// Not the right admin for the object
    const ENotAdmin: u64 = 0;
    /// Migration is not an upgrade
    const ENotUpgrade: u64 = 1;
    /// Calling functions from the wrong package version
    const EWrongSchemaVersion: u64 = 2;

    const SCHEMA_VERSION: u64 = 0;

    struct AdminCap has key {
        id: UID,
    }


    fun init(otw: MAP, ctx: &mut TxContext) {
        let map = new_map(
            otw,
            ctx,
        );
        event::emit(new_init_map_event(&map));
        share_object(map);
    }

    public fun assert_schema_version(map: &Map) {
        assert!(map.schema_version == SCHEMA_VERSION, EWrongSchemaVersion);
    }

    struct Map has key {
        id: UID,
        version: u64,
        schema_version: u64,
        admin_cap: ID,
        locations: table::Table<Coordinates, MapLocation>,
    }

    public fun id(map: &Map): object::ID {
        object::uid_to_inner(&map.id)
    }

    public fun version(map: &Map): u64 {
        map.version
    }

    public(friend) fun add_location(map: &mut Map, location: MapLocation) {
        let key = map_location::coordinates(&location);
        assert!(!table::contains(&map.locations, key), EIdAlreadyExists);
        table::add(&mut map.locations, key, location);
    }

    public(friend) fun remove_location(map: &mut Map, coordinates: Coordinates): MapLocation {
        assert!(table::contains(&map.locations, coordinates), EIdNotFound);
        table::remove(&mut map.locations, coordinates)
    }

    public(friend) fun remove_and_drop_location(map: &mut Map, coordinates: Coordinates) {
        let location = remove_location(map, coordinates);
        map_location::drop_map_location(location);
    }


    public(friend) fun borrow_mut_location(map: &mut Map, coordinates: Coordinates): &mut MapLocation {
        table::borrow_mut(&mut map.locations, coordinates)
    }

    public fun borrow_location(map: &Map, coordinates: Coordinates): &MapLocation {
        table::borrow(&map.locations, coordinates)
    }

    public fun locations_contains(map: &Map, coordinates: Coordinates): bool {
        table::contains(&map.locations, coordinates)
    }

    public fun locations_length(map: &Map): u64 {
        table::length(&map.locations)
    }

    public fun admin_cap(map: &Map): ID {
        map.admin_cap
    }

    public(friend) fun new_map(
        _witness: MAP,
        ctx: &mut TxContext,
    ): Map {
        let admin_cap = AdminCap {
            id: object::new(ctx),
        };
        let admin_cap_id = object::id(&admin_cap);
        transfer::transfer(admin_cap, sui::tx_context::sender(ctx));
        Map {
            id: object::new(ctx),
            version: 0,
            schema_version: SCHEMA_VERSION,
            admin_cap: admin_cap_id,
            locations: table::new<Coordinates, MapLocation>(ctx),
        }
    }

    entry fun migrate(map: &mut Map, a: &AdminCap) {
        assert!(map.admin_cap == object::id(a), ENotAdmin);
        assert!(map.schema_version < SCHEMA_VERSION, ENotUpgrade);
        map.schema_version = SCHEMA_VERSION;
    }

    struct InitMapEvent has copy, drop {
        id: object::ID,
    }

    public fun init_map_event_id(init_map_event: &InitMapEvent): object::ID {
        init_map_event.id
    }

    public(friend) fun new_init_map_event(
        map: &Map,
    ): InitMapEvent {
        InitMapEvent {
            id: id(map),
        }
    }

    struct IslandAdded has copy, drop {
        id: object::ID,
        version: u64,
        coordinates: Coordinates,
        resources: ItemIdQuantityPairs,
    }

    public fun island_added_id(island_added: &IslandAdded): object::ID {
        island_added.id
    }

    public fun island_added_coordinates(island_added: &IslandAdded): Coordinates {
        island_added.coordinates
    }

    public fun island_added_resources(island_added: &IslandAdded): ItemIdQuantityPairs {
        island_added.resources
    }

    public(friend) fun new_island_added(
        map: &Map,
        coordinates: Coordinates,
        resources: ItemIdQuantityPairs,
    ): IslandAdded {
        IslandAdded {
            id: id(map),
            version: version(map),
            coordinates,
            resources,
        }
    }

    struct MapIslandClaimed has copy, drop {
        id: object::ID,
        version: u64,
        coordinates: Coordinates,
        claimed_by: ID,
        claimed_at: u64,
    }

    public fun map_island_claimed_id(map_island_claimed: &MapIslandClaimed): object::ID {
        map_island_claimed.id
    }

    public fun map_island_claimed_coordinates(map_island_claimed: &MapIslandClaimed): Coordinates {
        map_island_claimed.coordinates
    }

    public fun map_island_claimed_claimed_by(map_island_claimed: &MapIslandClaimed): ID {
        map_island_claimed.claimed_by
    }

    public fun map_island_claimed_claimed_at(map_island_claimed: &MapIslandClaimed): u64 {
        map_island_claimed.claimed_at
    }

    public(friend) fun new_map_island_claimed(
        map: &Map,
        coordinates: Coordinates,
        claimed_by: ID,
        claimed_at: u64,
    ): MapIslandClaimed {
        MapIslandClaimed {
            id: id(map),
            version: version(map),
            coordinates,
            claimed_by,
            claimed_at,
        }
    }

    struct IslandResourcesGathered has copy, drop {
        id: object::ID,
        version: u64,
        player_id: ID,
        coordinates: Coordinates,
        resources: vector<ItemIdQuantityPair>,
        gathered_at: u64,
    }

    public fun island_resources_gathered_id(island_resources_gathered: &IslandResourcesGathered): object::ID {
        island_resources_gathered.id
    }

    public fun island_resources_gathered_player_id(island_resources_gathered: &IslandResourcesGathered): ID {
        island_resources_gathered.player_id
    }

    public fun island_resources_gathered_coordinates(island_resources_gathered: &IslandResourcesGathered): Coordinates {
        island_resources_gathered.coordinates
    }

    public fun island_resources_gathered_resources(island_resources_gathered: &IslandResourcesGathered): vector<ItemIdQuantityPair> {
        island_resources_gathered.resources
    }

    public fun island_resources_gathered_gathered_at(island_resources_gathered: &IslandResourcesGathered): u64 {
        island_resources_gathered.gathered_at
    }

    public(friend) fun new_island_resources_gathered(
        map: &Map,
        player_id: ID,
        coordinates: Coordinates,
        resources: vector<ItemIdQuantityPair>,
        gathered_at: u64,
    ): IslandResourcesGathered {
        IslandResourcesGathered {
            id: id(map),
            version: version(map),
            player_id,
            coordinates,
            resources,
            gathered_at,
        }
    }


    #[lint_allow(share_owned)]
    public(friend) fun share_object(map: Map) {
        assert!(map.version == 0, EInappropriateVersion);
        transfer::share_object(map);
    }

    public(friend) fun update_object_version(map: &mut Map) {
        map.version = map.version + 1;
        //assert!(map.version != 0, EInappropriateVersion);
    }

    public(friend) fun drop_map(map: Map) {
        let Map {
            id,
            version: _version,
            schema_version: _,
            admin_cap: _,
            locations,
        } = map;
        object::delete(id);
        table::destroy_empty(locations);
    }

    public(friend) fun emit_island_added(island_added: IslandAdded) {
        event::emit(island_added);
    }

    public(friend) fun emit_map_island_claimed(map_island_claimed: MapIslandClaimed) {
        event::emit(map_island_claimed);
    }

    public(friend) fun emit_island_resources_gathered(island_resources_gathered: IslandResourcesGathered) {
        event::emit(island_resources_gathered);
    }

}
