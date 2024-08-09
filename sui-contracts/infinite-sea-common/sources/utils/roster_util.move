module infinite_sea_common::roster_util {
    use infinite_sea_common::coordinates;
    use infinite_sea_common::coordinates::Coordinates;

    public fun get_roster_origin_coordinates(island: &Coordinates, roster_seq: u32): Coordinates {
        coordinates::new(
            coordinates::x(island) + roster_seq * 150,
            coordinates::y(island) + 1800,
        )
    }
}
