module infinite_sea_common::vector_util {

    use std::option::{Self, Option};
    use std::vector;

    use infinite_sea_common::item_id_quantity_pair::{Self, ItemIdQuantityPair};

    const EItemAlreadyExists: u64 = 1;

    /// "v" is a vector already sorted in ascending order by "item_id",
    /// add a new element, use binary search to find the insertion position,
    /// if the same item_id element already exists, abort
    public fun add_item_id_quantity_pair(v: &mut vector<ItemIdQuantityPair>, pair: ItemIdQuantityPair) {
        let low = 0;
        let high = vector::length(v);
        while (low < high) {
            let mid = low + (high - low) / 2;
            let mid_value = item_id_quantity_pair::item_id(vector::borrow(v, mid));
            let item_id = item_id_quantity_pair::item_id(&pair);
            if (mid_value == item_id) {
                // If the same item_id already exists, abort the insertion.
                abort EItemAlreadyExists
            } else if (mid_value < item_id) {
                low = mid + 1;
            } else {
                high = mid;
            };
        };
        // Insert the new ItemIdQuantityPair at the found position.
        vector::insert(v, pair, low);
    }

    /// "v" is a vector already sorted in ascending order by "item_id",
    /// find the position of the element with the given "item_id" using binary search.
    public fun find_item_id_quantity_pair_by_item_id(v: &vector<ItemIdQuantityPair>, item_id: u32): Option<u64> {
        let low = 0;
        let high = vector::length(v) - 1;
        while (low <= high) {
            let mid = low + (high - low) / 2;
            let mid_value = item_id_quantity_pair::item_id(vector::borrow(v, mid));
            if (mid_value == item_id) {
                return option::some(mid)
            } else if (mid_value < item_id) {
                low = mid + 1;
            } else {
                high = mid - 1;
            };
        };
        option::none<u64>()
    }
}
