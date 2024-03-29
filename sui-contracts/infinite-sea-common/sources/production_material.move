// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module infinite_sea_common::production_material {
    #[allow(unused_const)]
    const EDataTooLong: u64 = 102;

    struct ProductionMaterial has store, drop, copy {
        item_id: u32,
        quantity: u32,
    }

    public fun new(
        item_id: u32,
        quantity: u32,
    ): ProductionMaterial {
        let production_material = ProductionMaterial {
            item_id,
            quantity,
        };
        validate(&production_material);
        production_material
    }

    fun validate(production_material: &ProductionMaterial) {
        let _ = production_material;
    }

    public fun item_id(production_material: &ProductionMaterial): u32 {
        production_material.item_id
    }

    public fun quantity(production_material: &ProductionMaterial): u32 {
        production_material.quantity
    }

}
