// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module infinite_sea_farming::farming_item_production {
    use infinite_sea_common::item_production::ItemProduction;
    use std::option;
    use sui::event;
    use sui::object::{Self, UID};
    use sui::table;
    use sui::transfer;
    use sui::tx_context::TxContext;
    friend infinite_sea_farming::farming_item_production_aggregate;

    const EIdAlreadyExists: u64 = 101;
    #[allow(unused_const)]
    const EDataTooLong: u64 = 102;
    const EInappropriateVersion: u64 = 103;
    const EEmptyObjectID: u64 = 107;

    struct FarmingItemProductionTable has key {
        id: UID,
        table: table::Table<u32, object::ID>,
    }

    struct FarmingItemProductionTableCreated has copy, drop {
        id: object::ID,
    }

    fun init(ctx: &mut TxContext) {
        let id_generator_table = FarmingItemProductionTable {
            id: object::new(ctx),
            table: table::new(ctx),
        };
        let id_generator_table_id = object::uid_to_inner(&id_generator_table.id);
        transfer::share_object(id_generator_table);
        event::emit(FarmingItemProductionTableCreated {
            id: id_generator_table_id,
        });
    }

    struct FarmingItemProduction has key {
        id: UID,
        item_id: u32,
        version: u64,
        item_production: ItemProduction,
    }

    public fun id(farming_item_production: &FarmingItemProduction): object::ID {
        object::uid_to_inner(&farming_item_production.id)
    }

    public fun item_id(farming_item_production: &FarmingItemProduction): u32 {
        farming_item_production.item_id
    }

    public fun version(farming_item_production: &FarmingItemProduction): u64 {
        farming_item_production.version
    }

    public fun item_production(farming_item_production: &FarmingItemProduction): ItemProduction {
        farming_item_production.item_production
    }

    public(friend) fun set_item_production(farming_item_production: &mut FarmingItemProduction, item_production: ItemProduction) {
        farming_item_production.item_production = item_production;
    }

    fun new_farming_item_production(
        item_id: u32,
        item_production: ItemProduction,
        ctx: &mut TxContext,
    ): FarmingItemProduction {
        FarmingItemProduction {
            id: object::new(ctx),
            item_id,
            version: 0,
            item_production,
        }
    }


    public(friend) fun create_farming_item_production(
        item_id: u32,
        item_production: ItemProduction,
        farming_item_production_table: &mut FarmingItemProductionTable,
        ctx: &mut TxContext,
    ): FarmingItemProduction {
        let farming_item_production = new_farming_item_production(
            item_id,
            item_production,
            ctx,
        );
        asset_item_id_not_exists_then_add(item_id, farming_item_production_table, object::uid_to_inner(&farming_item_production.id));
        farming_item_production
    }

    public(friend) fun asset_item_id_not_exists(
        item_id: u32,
        farming_item_production_table: &FarmingItemProductionTable,
    ) {
        assert!(!table::contains(&farming_item_production_table.table, item_id), EIdAlreadyExists);
    }

    fun asset_item_id_not_exists_then_add(
        item_id: u32,
        farming_item_production_table: &mut FarmingItemProductionTable,
        id: object::ID,
    ) {
        asset_item_id_not_exists(item_id, farming_item_production_table);
        table::add(&mut farming_item_production_table.table, item_id, id);
    }

    public(friend) fun transfer_object(farming_item_production: FarmingItemProduction, recipient: address) {
        assert!(farming_item_production.version == 0, EInappropriateVersion);
        transfer::transfer(farming_item_production, recipient);
    }

    public(friend) fun update_version_and_transfer_object(farming_item_production: FarmingItemProduction, recipient: address) {
        update_object_version(&mut farming_item_production);
        transfer::transfer(farming_item_production, recipient);
    }

    #[lint_allow(share_owned)]
    public(friend) fun share_object(farming_item_production: FarmingItemProduction) {
        assert!(farming_item_production.version == 0, EInappropriateVersion);
        transfer::share_object(farming_item_production);
    }

    public(friend) fun freeze_object(farming_item_production: FarmingItemProduction) {
        assert!(farming_item_production.version == 0, EInappropriateVersion);
        transfer::freeze_object(farming_item_production);
    }

    public(friend) fun update_version_and_freeze_object(farming_item_production: FarmingItemProduction) {
        update_object_version(&mut farming_item_production);
        transfer::freeze_object(farming_item_production);
    }

    fun update_object_version(farming_item_production: &mut FarmingItemProduction) {
        farming_item_production.version = farming_item_production.version + 1;
        //assert!(farming_item_production.version != 0, EInappropriateVersion);
    }

    public(friend) fun drop_farming_item_production(farming_item_production: FarmingItemProduction) {
        let FarmingItemProduction {
            id,
            item_id: _item_id,
            version: _version,
            item_production: _item_production,
        } = farming_item_production;
        object::delete(id);
    }

    #[test_only]
    /// Wrapper of module initializer for testing
    public fun test_init(ctx: &mut TxContext) {
        init(ctx)
    }

}
