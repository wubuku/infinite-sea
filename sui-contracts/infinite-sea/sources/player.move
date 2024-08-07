// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module infinite_sea::player {
    use infinite_sea_common::coordinates::Coordinates;
    use infinite_sea_common::item_id_quantity_pair::ItemIdQuantityPair;
    use std::option::{Self, Option};
    use std::string::String;
    use sui::event;
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;

    struct PLAYER has drop {}

    friend infinite_sea::player_create_logic;
    friend infinite_sea::player_claim_island_logic;
    friend infinite_sea::player_nft_holder_claim_island_logic;
    friend infinite_sea::player_airdrop_logic;
    friend infinite_sea::player_gather_island_resources_logic;
    friend infinite_sea::player_aggregate;

    friend infinite_sea::roster_put_in_ship_inventory_logic;
    friend infinite_sea::roster_take_out_ship_inventory_logic;
    friend infinite_sea::ship_battle_take_loot_logic;
    friend infinite_sea::player_properties;

    #[allow(unused_const)]
    const EDataTooLong: u64 = 102;
    #[allow(unused_const)]
    const EInappropriateVersion: u64 = 103;
    const EEmptyObjectID: u64 = 107;

    struct FriendWitness has drop {}

    public(friend) fun friend_witness(): FriendWitness {
        FriendWitness {}
    }

    fun init(otw: PLAYER, ctx: &mut TxContext) {
        sui::package::claim_and_keep(otw, ctx);
    }

    struct Player has key {
        id: UID,
        version: u64,
        owner: address,
        level: u16,
        experience: u32,
        name: String,
        claimed_island: Option<Coordinates>,
        inventory: vector<ItemIdQuantityPair>,
    }

    public fun id(player: &Player): object::ID {
        object::uid_to_inner(&player.id)
    }

    public fun version(player: &Player): u64 {
        player.version
    }

    public fun owner(player: &Player): address {
        player.owner
    }

    public(friend) fun set_owner(player: &mut Player, owner: address) {
        player.owner = owner;
    }

    public fun level(player: &Player): u16 {
        player.level
    }

    public(friend) fun set_level(player: &mut Player, level: u16) {
        player.level = level;
    }

    public fun experience(player: &Player): u32 {
        player.experience
    }

    public(friend) fun set_experience(player: &mut Player, experience: u32) {
        player.experience = experience;
    }

    public fun name(player: &Player): String {
        player.name
    }

    public(friend) fun set_name(player: &mut Player, name: String) {
        assert!(std::string::length(&name) <= 50, EDataTooLong);
        player.name = name;
    }

    public fun claimed_island(player: &Player): Option<Coordinates> {
        player.claimed_island
    }

    public(friend) fun set_claimed_island(player: &mut Player, claimed_island: Option<Coordinates>) {
        player.claimed_island = claimed_island;
    }

    public fun borrow_inventory(player: &Player): &vector<ItemIdQuantityPair> {
        &player.inventory
    }

    public(friend) fun borrow_mut_inventory(player: &mut Player): &mut vector<ItemIdQuantityPair> {
        &mut player.inventory
    }

    public fun inventory(player: &Player): vector<ItemIdQuantityPair> {
        player.inventory
    }

    public(friend) fun set_inventory(player: &mut Player, inventory: vector<ItemIdQuantityPair>) {
        player.inventory = inventory;
    }

    public(friend) fun new_player(
        owner: address,
        name: String,
        inventory: vector<ItemIdQuantityPair>,
        ctx: &mut TxContext,
    ): Player {
        assert!(std::string::length(&name) <= 50, EDataTooLong);
        Player {
            id: object::new(ctx),
            version: 0,
            owner,
            level: 1,
            experience: 0,
            name,
            claimed_island: std::option::none(),
            inventory,
        }
    }

    struct PlayerCreated has copy, drop {
        id: option::Option<object::ID>,
        name: String,
        owner: address,
    }

    public fun player_created_id(player_created: &PlayerCreated): option::Option<object::ID> {
        player_created.id
    }

    public(friend) fun set_player_created_id(player_created: &mut PlayerCreated, id: object::ID) {
        player_created.id = option::some(id);
    }

    public fun player_created_name(player_created: &PlayerCreated): String {
        player_created.name
    }

    public fun player_created_owner(player_created: &PlayerCreated): address {
        player_created.owner
    }

    public(friend) fun new_player_created(
        name: String,
        owner: address,
    ): PlayerCreated {
        PlayerCreated {
            id: option::none(),
            name,
            owner,
        }
    }

    struct IslandClaimed has copy, drop {
        id: object::ID,
        version: u64,
        coordinates: Coordinates,
        claimed_at: u64,
    }

    public fun island_claimed_id(island_claimed: &IslandClaimed): object::ID {
        island_claimed.id
    }

    public fun island_claimed_coordinates(island_claimed: &IslandClaimed): Coordinates {
        island_claimed.coordinates
    }

    public fun island_claimed_claimed_at(island_claimed: &IslandClaimed): u64 {
        island_claimed.claimed_at
    }

    public(friend) fun new_island_claimed(
        player: &Player,
        coordinates: Coordinates,
        claimed_at: u64,
    ): IslandClaimed {
        IslandClaimed {
            id: id(player),
            version: version(player),
            coordinates,
            claimed_at,
        }
    }

    struct NftHolderIslandClaimed has copy, drop {
        id: object::ID,
        version: u64,
        coordinates: Coordinates,
        claimed_at: u64,
    }

    public fun nft_holder_island_claimed_id(nft_holder_island_claimed: &NftHolderIslandClaimed): object::ID {
        nft_holder_island_claimed.id
    }

    public fun nft_holder_island_claimed_coordinates(nft_holder_island_claimed: &NftHolderIslandClaimed): Coordinates {
        nft_holder_island_claimed.coordinates
    }

    public fun nft_holder_island_claimed_claimed_at(nft_holder_island_claimed: &NftHolderIslandClaimed): u64 {
        nft_holder_island_claimed.claimed_at
    }

    public(friend) fun new_nft_holder_island_claimed(
        player: &Player,
        coordinates: Coordinates,
        claimed_at: u64,
    ): NftHolderIslandClaimed {
        NftHolderIslandClaimed {
            id: id(player),
            version: version(player),
            coordinates,
            claimed_at,
        }
    }

    struct PlayerAirdropped has copy, drop {
        id: object::ID,
        version: u64,
        item_id: u32,
        quantity: u32,
    }

    public fun player_airdropped_id(player_airdropped: &PlayerAirdropped): object::ID {
        player_airdropped.id
    }

    public fun player_airdropped_item_id(player_airdropped: &PlayerAirdropped): u32 {
        player_airdropped.item_id
    }

    public fun player_airdropped_quantity(player_airdropped: &PlayerAirdropped): u32 {
        player_airdropped.quantity
    }

    public(friend) fun new_player_airdropped(
        player: &Player,
        item_id: u32,
        quantity: u32,
    ): PlayerAirdropped {
        PlayerAirdropped {
            id: id(player),
            version: version(player),
            item_id,
            quantity,
        }
    }

    struct PlayerIslandResourcesGathered has copy, drop {
        id: object::ID,
        version: u64,
    }

    public fun player_island_resources_gathered_id(player_island_resources_gathered: &PlayerIslandResourcesGathered): object::ID {
        player_island_resources_gathered.id
    }

    public(friend) fun new_player_island_resources_gathered(
        player: &Player,
    ): PlayerIslandResourcesGathered {
        PlayerIslandResourcesGathered {
            id: id(player),
            version: version(player),
        }
    }


    #[lint_allow(share_owned)]
    public(friend) fun share_object(player: Player) {
        assert!(player.version == 0, EInappropriateVersion);
        transfer::share_object(player);
    }

    public(friend) fun update_object_version(player: &mut Player) {
        player.version = player.version + 1;
        //assert!(player.version != 0, EInappropriateVersion);
    }

    public(friend) fun drop_player(player: Player) {
        let Player {
            id,
            version: _version,
            owner: _owner,
            level: _level,
            experience: _experience,
            name: _name,
            claimed_island: _claimed_island,
            inventory: _inventory,
        } = player;
        object::delete(id);
    }

    public(friend) fun emit_player_created(player_created: PlayerCreated) {
        assert!(std::option::is_some(&player_created.id), EEmptyObjectID);
        event::emit(player_created);
    }

    public(friend) fun emit_island_claimed(island_claimed: IslandClaimed) {
        event::emit(island_claimed);
    }

    public(friend) fun emit_nft_holder_island_claimed(nft_holder_island_claimed: NftHolderIslandClaimed) {
        event::emit(nft_holder_island_claimed);
    }

    public(friend) fun emit_player_airdropped(player_airdropped: PlayerAirdropped) {
        event::emit(player_airdropped);
    }

    public(friend) fun emit_player_island_resources_gathered(player_island_resources_gathered: PlayerIslandResourcesGathered) {
        event::emit(player_island_resources_gathered);
    }

}
