module infinite_sea_common::item_creation_update_logic {
    use infinite_sea_common::item_creation;
    use sui::tx_context::TxContext;

    friend infinite_sea_common::item_creation_aggregate;

    public(friend) fun verify(
        resource_cost: u32,
        requirements_level: u16,
        base_quantity: u32,
        base_experience: u32,
        base_creation_time: u64,
        energy_cost: u64,
        success_rate: u16,
        item_creation: &item_creation::ItemCreation,
        ctx: &TxContext,
    ): item_creation::ItemCreationUpdated {
        let _ = ctx;
        item_creation::new_item_creation_updated(
            item_creation,
            resource_cost,
            requirements_level,
            base_quantity,
            base_experience,
            base_creation_time,
            energy_cost,
            success_rate,
        )
    }

    public(friend) fun mutate(
        item_creation_updated: &item_creation::ItemCreationUpdated,
        item_creation: &mut item_creation::ItemCreation,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let resource_cost = item_creation::item_creation_updated_resource_cost(item_creation_updated);
        let requirements_level = item_creation::item_creation_updated_requirements_level(item_creation_updated);
        let base_quantity = item_creation::item_creation_updated_base_quantity(item_creation_updated);
        let base_experience = item_creation::item_creation_updated_base_experience(item_creation_updated);
        let base_creation_time = item_creation::item_creation_updated_base_creation_time(item_creation_updated);
        let energy_cost = item_creation::item_creation_updated_energy_cost(item_creation_updated);
        let success_rate = item_creation::item_creation_updated_success_rate(item_creation_updated);
        let item_creation_id = item_creation::item_creation_id(item_creation);
        let _ = ctx;
        let _ = item_creation_id;
        item_creation::set_resource_cost(item_creation, resource_cost);
        item_creation::set_requirements_level(item_creation, requirements_level);
        item_creation::set_base_quantity(item_creation, base_quantity);
        item_creation::set_base_experience(item_creation, base_experience);
        item_creation::set_base_creation_time(item_creation, base_creation_time);
        item_creation::set_energy_cost(item_creation, energy_cost);
        item_creation::set_success_rate(item_creation, success_rate);
    }

}
