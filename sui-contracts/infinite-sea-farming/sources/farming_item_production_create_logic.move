module infinite_sea_farming::farming_item_production_create_logic {
    use infinite_sea_common::item_production::ItemProduction;
    use infinite_sea_farming::farming_item_production;
    use sui::tx_context::TxContext;

    friend infinite_sea_farming::farming_item_production_aggregate;

    public(friend) fun verify(
        item_id: u32,
        item_production: ItemProduction,
        farming_item_production_table: &farming_item_production::FarmingItemProductionTable,
        ctx: &mut TxContext,
    ): farming_item_production::FarmingItemProductionCreated {
        let _ = ctx;
        farming_item_production::asset_item_id_not_exists(item_id, farming_item_production_table);
        farming_item_production::new_farming_item_production_created(
            item_id,
            item_production,
        )
    }

    public(friend) fun mutate(
        farming_item_production_created: &farming_item_production::FarmingItemProductionCreated,
        farming_item_production_table: &mut farming_item_production::FarmingItemProductionTable,
        ctx: &mut TxContext,
    ): farming_item_production::FarmingItemProduction {
        let item_id = farming_item_production::farming_item_production_created_item_id(farming_item_production_created);
        let item_production = farming_item_production::farming_item_production_created_item_production(farming_item_production_created);
        farming_item_production::create_farming_item_production(
            item_id,
            item_production,
            farming_item_production_table,
            ctx,
        )
    }

}
