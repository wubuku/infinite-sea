module infinite_sea_common::item_update_logic {
    use infinite_sea_common::item;
    use sui::tx_context::TxContext;

    friend infinite_sea_common::item_aggregate;

    public(friend) fun verify(
        name: std::ascii::String,
        required_for_completion: bool,
        sells_for: u32,
        item: &item::Item,
        ctx: &TxContext,
    ): item::ItemUpdated {
        let _ = ctx;
        item::new_item_updated(
            item,
            name,
            required_for_completion,
            sells_for,
        )
    }

    public(friend) fun mutate(
        item_updated: &item::ItemUpdated,
        item: &mut item::Item,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let name = item::item_updated_name(item_updated);
        let required_for_completion = item::item_updated_required_for_completion(item_updated);
        let sells_for = item::item_updated_sells_for(item_updated);
        let item_id = item::item_id(item);
        let _ = ctx;
        let _ = item_id;
        item::set_name(item, name);
        item::set_required_for_completion(item, required_for_completion);
        item::set_sells_for(item, sells_for);
    }

}
