module infinite_sea_common::vector_util {

    use std::option::{Self, Option};
    use std::vector;

    use infinite_sea_common::item_id_quantity_pair::{Self, ItemIdQuantityPair};

    const EItemAlreadyExists: u64 = 1;
    const EInsufficientQuantity: u64 = 2;
    const EItemNotFound: u64 = 3;

    /// "merged" is a vector already sorted in ascending order by "item_id",
    /// merge the "other" vector into "merged" while maintaining its order.
    public fun merge_item_id_quantity_pairs(merged: &mut vector<ItemIdQuantityPair>, other: &vector<ItemIdQuantityPair>) {
        let oi = 0;
        let ol = vector::length(other);
        while (oi < ol) {
            let other_pair = vector::borrow(other, oi);
            insert_or_add_item_id_quantity_pair(merged, *other_pair);
            oi = oi + 1;
        };
    }

    /// "v" is a vector already sorted in ascending order by "item_id",
    /// insert or update the quantity of the given "pair" in the vector while maintaining the order.
    public fun insert_or_add_item_id_quantity_pair(v: &mut vector<ItemIdQuantityPair>, pair: ItemIdQuantityPair) {
        let item_id = item_id_quantity_pair::item_id(&pair);
        let (idx, low) = binary_search_item_id_quantity_pair(v, item_id);
        if (option::is_some(&idx)) {
            // If the same item_id already exists, update the quantity.
            let i = option::extract(&mut idx);
            let existing_pair = vector::borrow(v, i);
            let new_quantity = item_id_quantity_pair::quantity(&pair) + item_id_quantity_pair::quantity(existing_pair);
            let new_pair = item_id_quantity_pair::new(item_id, new_quantity);
            vector::remove(v, i);
            vector::insert(v, new_pair, i);
        } else {
            // Insert the new ItemIdQuantityPair at the found position.
            vector::insert(v, pair, low);
        };
    }

    public fun remove_all_item_id_quantity_pairs(v: &mut vector<ItemIdQuantityPair>) {
        while (!vector::is_empty(v)) {
            vector::pop_back(v);
        };
    }

    /// "v" is a vector already sorted in ascending order by "item_id".
    public fun subtract_item_id_quantity_pair(v: &mut vector<ItemIdQuantityPair>, pair: ItemIdQuantityPair) {
        let item_id = item_id_quantity_pair::item_id(&pair);
        let (idx, _low) = binary_search_item_id_quantity_pair(v, item_id);
        assert!(option::is_some(&idx), EItemNotFound);
        let i = option::extract(&mut idx);
        let existing_pair = vector::borrow(v, i);
        let existing_quantity = item_id_quantity_pair::quantity(existing_pair);
        let subtract_quantity = item_id_quantity_pair::quantity(&pair);
        assert!(existing_quantity >= subtract_quantity, EInsufficientQuantity);
        let new_quantity = existing_quantity - subtract_quantity;
        vector::remove(v, i);
        if (new_quantity > 0) {
            let new_pair = item_id_quantity_pair::new(item_id, new_quantity);
            vector::insert(v, new_pair, i);
        };
    }

    /// "v" is a vector already sorted in ascending order by "item_id",
    /// add a new element while maintaining the order;
    /// if the same item_id element already exists, abort
    public fun insert_item_id_quantity_pair(v: &mut vector<ItemIdQuantityPair>, pair: ItemIdQuantityPair) {
        let item_id = item_id_quantity_pair::item_id(&pair);
        let (idx, low) = binary_search_item_id_quantity_pair(v, item_id);
        if (option::is_some(&idx)) {
            // If the same item_id already exists, abort the insertion.
            abort EItemAlreadyExists
        };
        // Insert the new ItemIdQuantityPair at the found position.
        vector::insert(v, pair, low);
    }

    /// "v" is a vector already sorted in ascending order by "item_id",
    /// find the position of the element with the given "item_id" using binary search.
    public fun find_item_id_quantity_pair_by_item_id(v: &vector<ItemIdQuantityPair>, item_id: u32): Option<u64> {
        let (idx, _low) = binary_search_item_id_quantity_pair(v, item_id);
        idx
    }

    /// "v" is a vector already sorted in ascending order by "item_id",
    /// find the position of the element with the given "item_id" using binary search.
    /// If the element is found, return the index and the lower bound of the last search.
    fun binary_search_item_id_quantity_pair(v: &vector<ItemIdQuantityPair>, item_id: u32): (Option<u64>, u64) {
        let low = 0;
        let high = vector::length(v);
        while (low < high) {
            let mid = low + (high - low) / 2;
            let mid_value = item_id_quantity_pair::item_id(vector::borrow(v, mid));
            if (mid_value == item_id) {
                return (option::some(mid), low)
            } else if (mid_value < item_id) {
                low = mid + 1;
            } else {
                high = mid;
            };
        };
        (option::none<u64>(), low)
    }
}
