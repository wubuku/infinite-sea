#[allow(unused_mut_parameter)]
module infinite_sea_common::item_create_logic {
    use infinite_sea_common::item;
    use sui::tx_context::TxContext;

    friend infinite_sea_common::item_aggregate;

    public(friend) fun verify(
        item_id: u32,
        name: std::ascii::String,
        required_for_completion: bool,
        sells_for: u32,
        item_table: &item::ItemTable,
        ctx: &mut TxContext,
    ): item::ItemCreated {
        let _ = ctx;
        item::asset_item_id_not_exists(item_id, item_table);
        item::new_item_created(
            item_id,
            name,
            required_for_completion,
            sells_for,
        )
    }

    public(friend) fun mutate(
        item_created: &item::ItemCreated,
        item_table: &mut item::ItemTable,
        ctx: &mut TxContext,
    ): item::Item {
        let item_id = item::item_created_item_id(item_created);
        let name = item::item_created_name(item_created);
        let required_for_completion = item::item_created_required_for_completion(item_created);
        let sells_for = item::item_created_sells_for(item_created);
        item::create_item(
            item_id,
            name,
            required_for_completion,
            sells_for,
            item_table,
            ctx,
        )
    }

}
