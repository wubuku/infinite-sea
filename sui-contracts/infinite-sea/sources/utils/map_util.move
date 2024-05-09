module infinite_sea::map_util {
    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea_common::map_location_type;

    use infinite_sea::map;
    use infinite_sea::map::Map;
    use infinite_sea::map_location;

    const ELocationNotFound: u64 = 10;
    const ELocationNotAnIsland: u64 = 11;

    /// Island resource regeneration time in seconds.
    const ISLAND_RESOURCE_REGENERATION_TIME: u64 = 60 * 60 * 24; // todo 1 day?

    /// Quantity of island resources regenerated.
    const ISLAND_RESOURCE_REGENERATION_QUANTITY: u32 = 600; // todo Is this a good value? initial value = 600

    /// Get the quantity of resources of the island to be gathered.
    public fun get_island_resources_quantity_to_gather(map: &Map, coordinates: Coordinates, now_time: u64): u32 {
        assert!(map::locations_contains(map, coordinates), ELocationNotFound);
        let island = map::borrow_location(map, coordinates);
        assert!(map_location_type::island() == map_location::type(island), ELocationNotAnIsland);
        let last_gathered_at = map_location::gathered_at(island);
        let elapsed_time = now_time - last_gathered_at;
        if (elapsed_time >= ISLAND_RESOURCE_REGENERATION_TIME) {
            ISLAND_RESOURCE_REGENERATION_QUANTITY
        } else {
            0
        }
    }
}
