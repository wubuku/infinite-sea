module infinite_sea::loot_util {

    use std::vector;

    use infinite_sea_common::item_id_quantity_pair;
    use infinite_sea_common::item_id_quantity_pairs;

    use infinite_sea::ship;
    use infinite_sea::ship::Ship;

    /// Calculate the loot that can be obtained from a defeated "ship".
    public fun calculate_loot(ship: &Ship): (vector<u32>, vector<u32>) {
        let item_ids = vector::empty<u32>();
        let item_quantities = vector::empty<u32>();
        let inv = ship::inventory(ship);
        let i = 0;
        let l = vector::length(&inv);
        while (i < l) {
            let item = vector::borrow(&inv, i);
            let item_id = item_id_quantity_pair::item_id(item);
            let item_quantity = item_id_quantity_pair::quantity(item);
            if (item_quantity > 0) {
                vector::push_back(&mut item_ids, item_id);
                vector::push_back(&mut item_quantities, item_quantity);
            };
            i = i + 1;
        };
        let building_items = item_id_quantity_pairs::items(&ship::building_expenses(ship));
        let i = 0;
        let l = vector::length(&building_items);
        while (i < l) {
            let item = vector::borrow(&building_items, i);
            let item_id = item_id_quantity_pair::item_id(item);
            let item_quantity = item_id_quantity_pair::quantity(item) * 4 / 5;
            if (item_quantity > 0) {
                vector::push_back(&mut item_ids, item_id);
                vector::push_back(&mut item_quantities, item_quantity);
            };
            i = i + 1;
        };
        (item_ids, item_quantities)
    }
}
