#[test_only]
module infinite_sea_common::vector_util_tests {

    use std::debug;
    use std::option;
    use std::vector;

    use infinite_sea_common::item_id_quantity_pair;
    use infinite_sea_common::item_id_quantity_pair::ItemIdQuantityPair;
    use infinite_sea_common::sorted_vector_util;

    #[test]
    public fun vector_util_tests() {
        let item_id_quantity_pair_1 = item_id_quantity_pair::new(1, 1);
        let item_id_quantity_pair_2 = item_id_quantity_pair::new(2, 2);

        let item_id_quantity_pair_4 = item_id_quantity_pair::new(4, 4);
        let item_id_quantity_pair_5 = item_id_quantity_pair::new(5, 5);
        let item_id_quantity_pair_6 = item_id_quantity_pair::new(6, 6);

        let item_id_quantity_pair_vector = vector::empty<ItemIdQuantityPair>();
        sorted_vector_util::insert_item_id_quantity_pair(&mut item_id_quantity_pair_vector, item_id_quantity_pair_6);
        sorted_vector_util::insert_item_id_quantity_pair(&mut item_id_quantity_pair_vector, item_id_quantity_pair_2);
        sorted_vector_util::insert_item_id_quantity_pair(&mut item_id_quantity_pair_vector, item_id_quantity_pair_1);
        sorted_vector_util::insert_item_id_quantity_pair(&mut item_id_quantity_pair_vector, item_id_quantity_pair_5);
        sorted_vector_util::insert_item_id_quantity_pair(&mut item_id_quantity_pair_vector, item_id_quantity_pair_4);

        sorted_vector_util::insert_or_add_item_id_quantity_pair(&mut item_id_quantity_pair_vector, item_id_quantity_pair_2);

        let l = vector::length(&item_id_quantity_pair_vector);
        let i = 0;
        while (i < l) {
            let item_id_quantity_pair = vector::borrow(&item_id_quantity_pair_vector, i);
            //debug::print(&item_id_quantity_pair::item_id(item_id_quantity_pair));
            //debug::print(&item_id_quantity_pair::quantity(item_id_quantity_pair));
            i = i + 1;
        };

        let idx_2 = sorted_vector_util::find_item_id_quantity_pair_by_item_id(&item_id_quantity_pair_vector, 2);
        //debug::print(&option::is_some(&idx_2));
        let idx_3 = sorted_vector_util::find_item_id_quantity_pair_by_item_id(&item_id_quantity_pair_vector, 3);
        //debug::print(&option::is_some(&idx_3));

        let item_id_quantity_pair_3 = item_id_quantity_pair::new(3, 3);
        sorted_vector_util::insert_item_id_quantity_pair(&mut item_id_quantity_pair_vector, item_id_quantity_pair_3);
        //vector_util::add_item_id_quantity_pair(&mut item_id_quantity_pair_vector, item_id_quantity_pair_2);
    }
}
