// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module infinite_sea_map::map_aggregate {
    use infinite_sea_common::coordinates::{Self, Coordinates};
    use infinite_sea_common::item_id_quantity_pairs::{Self, ItemIdQuantityPairs};
    use infinite_sea_map::map;
    use infinite_sea_map::map_add_island_logic;
    use infinite_sea_map::map_add_to_whitelist_logic;
    use infinite_sea_map::map_claim_island_logic;
    use infinite_sea_map::map_friend_config;
    use infinite_sea_map::map_gather_island_resources_logic;
    use infinite_sea_map::map_remove_from_whitelist_logic;
    use infinite_sea_map::map_update_settings_logic;
    use sui::clock::Clock;
    use sui::object::ID;
    use sui::tx_context;

    const EInvalidAdminCap: u64 = 50;

    public entry fun add_island(
        map: &mut map::Map,
        admin_cap: &map::AdminCap,
        coordinates_x: u32,
        coordinates_y: u32,
        resources_item_id_list: vector<u32>,
        resources_item_quantity_list: vector<u32>,
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(map::admin_cap(map) == sui::object::id(admin_cap), EInvalidAdminCap);
        map::assert_schema_version(map);
        let coordinates: Coordinates = coordinates::new(
            coordinates_x,
            coordinates_y,
        );
        let resources: ItemIdQuantityPairs = item_id_quantity_pairs::new(
            resources_item_id_list,
            resources_item_quantity_list,
        );
        let island_added = map_add_island_logic::verify(
            coordinates,
            resources,
            map,
            ctx,
        );
        map_add_island_logic::mutate(
            &island_added,
            map,
            ctx,
        );
        map::update_object_version(map);
        map::emit_island_added(island_added);
    }

    public fun claim_island<FWT: drop>(
        friend_config: &map_friend_config::MapFriendConfig,
        _friend_witness: FWT,
        map: &mut map::Map,
        coordinates: Coordinates,
        claimed_by: ID,
        claimed_at: u64,
        ctx: &mut tx_context::TxContext,
    ) {
        map_friend_config::assert_allowlisted(friend_config, _friend_witness);
        map::assert_schema_version(map);
        let map_island_claimed = map_claim_island_logic::verify(
            coordinates,
            claimed_by,
            claimed_at,
            map,
            ctx,
        );
        map_claim_island_logic::mutate(
            &map_island_claimed,
            map,
            ctx,
        );
        map::update_object_version(map);
        map::emit_map_island_claimed(map_island_claimed);
    }

    public fun gather_island_resources<FWT: drop>(
        friend_config: &map_friend_config::MapFriendConfig,
        _friend_witness: FWT,
        map: &mut map::Map,
        player_id: ID,
        coordinates: Coordinates,
        clock: &Clock,
        ctx: &mut tx_context::TxContext,
    ): ItemIdQuantityPairs {
        map_friend_config::assert_allowlisted(friend_config, _friend_witness);
        map::assert_schema_version(map);
        let island_resources_gathered = map_gather_island_resources_logic::verify(
            player_id,
            coordinates,
            clock,
            map,
            ctx,
        );
        let gather_island_resources_return = map_gather_island_resources_logic::mutate(
            &island_resources_gathered,
            clock,
            map,
            ctx,
        );
        map::update_object_version(map);
        map::emit_island_resources_gathered(island_resources_gathered);
        gather_island_resources_return
    }

    public entry fun update_settings(
        map: &mut map::Map,
        admin_cap: &map::AdminCap,
        claim_island_setting: u8,
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(map::admin_cap(map) == sui::object::id(admin_cap), EInvalidAdminCap);
        map::assert_schema_version(map);
        let map_settings_updated = map_update_settings_logic::verify(
            claim_island_setting,
            map,
            ctx,
        );
        map_update_settings_logic::mutate(
            &map_settings_updated,
            map,
            ctx,
        );
        map::update_object_version(map);
        map::emit_map_settings_updated(map_settings_updated);
    }

    public entry fun add_to_whitelist(
        map: &mut map::Map,
        admin_cap: &map::AdminCap,
        account_address: address,
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(map::admin_cap(map) == sui::object::id(admin_cap), EInvalidAdminCap);
        map::assert_schema_version(map);
        let whitelisted_for_claiming_island = map_add_to_whitelist_logic::verify(
            account_address,
            map,
            ctx,
        );
        map_add_to_whitelist_logic::mutate(
            &whitelisted_for_claiming_island,
            map,
            ctx,
        );
        map::update_object_version(map);
        map::emit_whitelisted_for_claiming_island(whitelisted_for_claiming_island);
    }

    public entry fun remove_from_whitelist(
        map: &mut map::Map,
        admin_cap: &map::AdminCap,
        account_address: address,
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(map::admin_cap(map) == sui::object::id(admin_cap), EInvalidAdminCap);
        map::assert_schema_version(map);
        let un_whitelisted_for_claiming_island = map_remove_from_whitelist_logic::verify(
            account_address,
            map,
            ctx,
        );
        map_remove_from_whitelist_logic::mutate(
            &un_whitelisted_for_claiming_island,
            map,
            ctx,
        );
        map::update_object_version(map);
        map::emit_un_whitelisted_for_claiming_island(un_whitelisted_for_claiming_island);
    }

}
