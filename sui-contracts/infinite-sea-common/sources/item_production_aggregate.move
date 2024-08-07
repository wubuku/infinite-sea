// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module infinite_sea_common::item_production_aggregate {
    use infinite_sea_common::item_id_quantity_pairs::{Self, ItemIdQuantityPairs};
    use infinite_sea_common::item_production;
    use infinite_sea_common::item_production_create_logic;
    use infinite_sea_common::item_production_update_logic;
    use infinite_sea_common::skill_type_item_id_pair::{Self, SkillTypeItemIdPair};
    use sui::tx_context;

    const ENotPublisher: u64 = 50;

    public entry fun create(
        item_production_id_skill_type: u8,
        item_production_id_item_id: u32,
        publisher: &sui::package::Publisher,
        production_materials_item_id_list: vector<u32>,
        production_materials_item_quantity_list: vector<u32>,
        requirements_level: u16,
        base_quantity: u32,
        base_experience: u32,
        base_creation_time: u64,
        energy_cost: u64,
        success_rate: u16,
        item_production_table: &mut item_production::ItemProductionTable,
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(sui::package::from_package<item_production::ItemProduction>(publisher), ENotPublisher);
        let item_production_id: SkillTypeItemIdPair = skill_type_item_id_pair::new(
            item_production_id_skill_type,
            item_production_id_item_id,
        );

        let production_materials: ItemIdQuantityPairs = item_id_quantity_pairs::new(
            production_materials_item_id_list,
            production_materials_item_quantity_list,
        );
        let item_production_created = item_production_create_logic::verify(
            item_production_id,
            production_materials,
            requirements_level,
            base_quantity,
            base_experience,
            base_creation_time,
            energy_cost,
            success_rate,
            item_production_table,
            ctx,
        );
        let item_production = item_production_create_logic::mutate(
            &item_production_created,
            item_production_table,
            ctx,
        );
        item_production::set_item_production_created_id(&mut item_production_created, item_production::id(&item_production));
        item_production::share_object(item_production);
        item_production::emit_item_production_created(item_production_created);
    }

    public entry fun update(
        item_production: &mut item_production::ItemProduction,
        publisher: &sui::package::Publisher,
        production_materials_item_id_list: vector<u32>,
        production_materials_item_quantity_list: vector<u32>,
        requirements_level: u16,
        base_quantity: u32,
        base_experience: u32,
        base_creation_time: u64,
        energy_cost: u64,
        success_rate: u16,
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(sui::package::from_package<item_production::ItemProduction>(publisher), ENotPublisher);
        let production_materials: ItemIdQuantityPairs = item_id_quantity_pairs::new(
            production_materials_item_id_list,
            production_materials_item_quantity_list,
        );
        let item_production_updated = item_production_update_logic::verify(
            production_materials,
            requirements_level,
            base_quantity,
            base_experience,
            base_creation_time,
            energy_cost,
            success_rate,
            item_production,
            ctx,
        );
        item_production_update_logic::mutate(
            &item_production_updated,
            item_production,
            ctx,
        );
        item_production::update_object_version(item_production);
        item_production::emit_item_production_updated(item_production_updated);
    }

}
