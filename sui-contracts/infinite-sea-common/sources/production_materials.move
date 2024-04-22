// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module infinite_sea_common::production_materials {
    use infinite_sea_common::item_id_quantity_pair::ItemIdQuantityPair;

    #[allow(unused_const)]
    const EDataTooLong: u64 = 102;
    const EEmptyList: u64 = 10;
    const EIncorrectListLength: u64 = 11;

    struct ProductionMaterials has store, drop, copy {
        items: vector<ItemIdQuantityPair>,
    }

    public fun new(
        item_id_list: vector<u32>,
        item_quantity_list: vector<u32>,
    ): ProductionMaterials {
        assert!(std::vector::length(&item_id_list) > 0, EEmptyList);
        assert!(std::vector::length(&item_id_list) == std::vector::length(&item_quantity_list), EIncorrectListLength);
        let items = std::vector::empty();
        let l = std::vector::length(&item_id_list);
        let i = 0;
        while (i < l) {
            let item_id = *std::vector::borrow(&item_id_list, i);
            let item_quantity = *std::vector::borrow(&item_quantity_list, i);
            std::vector::push_back(
                &mut items,
                infinite_sea_common::item_id_quantity_pair::new(item_id, item_quantity)
            );
            i = i + 1;
        };
        let production_materials = ProductionMaterials {
            items,
        };
        validate(&production_materials);
        production_materials
    }

    fun validate(production_materials: &ProductionMaterials) {
        let _ = production_materials;
    }

    public fun items(production_materials: &ProductionMaterials): vector<ItemIdQuantityPair> {
        production_materials.items
    }

    public fun borrow_items(production_materials: &ProductionMaterials): &vector<ItemIdQuantityPair> {
        &production_materials.items
    }

}
