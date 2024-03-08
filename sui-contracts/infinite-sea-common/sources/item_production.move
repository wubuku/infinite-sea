// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module infinite_sea_common::item_production {
    use infinite_sea_common::production_material::ProductionMaterial;
    #[allow(unused_const)]
    const EDataTooLong: u64 = 102;

    struct ItemProduction has store, drop, copy {
        requirements_level: u16,
        materials: vector<ProductionMaterial>,
        base_quantity: u32,
        base_experience: u32,
        base_creation_time: u64,
        energy_cost: u32,
        success_rate: u16,
    }

    public fun new(
        requirements_level: u16,
        materials: vector<ProductionMaterial>,
        base_quantity: u32,
        base_experience: u32,
        base_creation_time: u64,
        energy_cost: u32,
        success_rate: u16,
    ): ItemProduction {
        let item_production = ItemProduction {
            requirements_level,
            materials,
            base_quantity,
            base_experience,
            base_creation_time,
            energy_cost,
            success_rate,
        };
        validate(&item_production);
        item_production
    }

    fun validate(item_production: &ItemProduction) {
        let _ = item_production;
    }

    public fun requirements_level(item_production: &ItemProduction): u16 {
        item_production.requirements_level
    }

    public fun materials(item_production: &ItemProduction): vector<ProductionMaterial> {
        item_production.materials
    }

    public fun base_quantity(item_production: &ItemProduction): u32 {
        item_production.base_quantity
    }

    public fun base_experience(item_production: &ItemProduction): u32 {
        item_production.base_experience
    }

    public fun base_creation_time(item_production: &ItemProduction): u64 {
        item_production.base_creation_time
    }

    public fun energy_cost(item_production: &ItemProduction): u32 {
        item_production.energy_cost
    }

    public fun success_rate(item_production: &ItemProduction): u16 {
        item_production.success_rate
    }

}
