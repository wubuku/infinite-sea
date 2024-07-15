// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module infinite_sea_nft::whitelist {
    use infinite_sea_nft::whitelist_entry::{Self, WhitelistEntry};
    use std::string::String;
    use sui::event;
    use sui::object::{Self, UID};
    use sui::table;
    use sui::transfer;
    use sui::tx_context::TxContext;

    struct WHITELIST has drop {}

    friend infinite_sea_nft::whitelist_update_logic;
    friend infinite_sea_nft::whitelist_add_whitelist_entry_logic;
    friend infinite_sea_nft::whitelist_update_whitelist_entry_logic;
    friend infinite_sea_nft::whitelist_claim_logic;
    friend infinite_sea_nft::whitelist_aggregate;

    const EIdAlreadyExists: u64 = 101;
    #[allow(unused_const)]
    const EDataTooLong: u64 = 102;
    #[allow(unused_const)]
    const EInappropriateVersion: u64 = 103;
    const EIdNotFound: u64 = 111;

    fun init(otw: WHITELIST, ctx: &mut TxContext) {
        let whitelist = new_whitelist(
            otw,
            ctx,
        );
        event::emit(new_init_whitelist_event(&whitelist));
        share_object(whitelist);
    }

    struct Whitelist has key {
        id: UID,
        version: u64,
        paused: bool,
        entries: table::Table<address, WhitelistEntry>,
    }

    public fun id(whitelist: &Whitelist): object::ID {
        object::uid_to_inner(&whitelist.id)
    }

    public fun version(whitelist: &Whitelist): u64 {
        whitelist.version
    }

    public fun paused(whitelist: &Whitelist): bool {
        whitelist.paused
    }

    public(friend) fun set_paused(whitelist: &mut Whitelist, paused: bool) {
        whitelist.paused = paused;
    }

    public(friend) fun add_entry(whitelist: &mut Whitelist, entry: WhitelistEntry) {
        let key = whitelist_entry::account_address(&entry);
        assert!(!table::contains(&whitelist.entries, key), EIdAlreadyExists);
        table::add(&mut whitelist.entries, key, entry);
    }

    public(friend) fun remove_entry(whitelist: &mut Whitelist, account_address: address) {
        assert!(table::contains(&whitelist.entries, account_address), EIdNotFound);
        let entry = table::remove(&mut whitelist.entries, account_address);
        whitelist_entry::drop_whitelist_entry(entry);
    }

    public(friend) fun borrow_mut_entry(whitelist: &mut Whitelist, account_address: address): &mut WhitelistEntry {
        table::borrow_mut(&mut whitelist.entries, account_address)
    }

    public fun borrow_entry(whitelist: &Whitelist, account_address: address): &WhitelistEntry {
        table::borrow(&whitelist.entries, account_address)
    }

    public fun entries_contains(whitelist: &Whitelist, account_address: address): bool {
        table::contains(&whitelist.entries, account_address)
    }

    public fun entries_length(whitelist: &Whitelist): u64 {
        table::length(&whitelist.entries)
    }

    public(friend) fun new_whitelist(
        _witness: WHITELIST,
        ctx: &mut TxContext,
    ): Whitelist {
        Whitelist {
            id: object::new(ctx),
            version: 0,
            paused: false,
            entries: table::new<address, WhitelistEntry>(ctx),
        }
    }

    struct InitWhitelistEvent has copy, drop {
        id: object::ID,
    }

    public fun init_whitelist_event_id(init_whitelist_event: &InitWhitelistEvent): object::ID {
        init_whitelist_event.id
    }

    public(friend) fun new_init_whitelist_event(
        whitelist: &Whitelist,
    ): InitWhitelistEvent {
        InitWhitelistEvent {
            id: id(whitelist),
        }
    }

    struct WhitelistUpdated has copy, drop {
        id: object::ID,
        version: u64,
        paused: bool,
    }

    public fun whitelist_updated_id(whitelist_updated: &WhitelistUpdated): object::ID {
        whitelist_updated.id
    }

    public fun whitelist_updated_paused(whitelist_updated: &WhitelistUpdated): bool {
        whitelist_updated.paused
    }

    public(friend) fun new_whitelist_updated(
        whitelist: &Whitelist,
        paused: bool,
    ): WhitelistUpdated {
        WhitelistUpdated {
            id: id(whitelist),
            version: version(whitelist),
            paused,
        }
    }

    struct WhitelistEntryAdded has copy, drop {
        id: object::ID,
        version: u64,
        account_address: address,
        name: String,
        image_url: String,
        description: String,
        background_color: u32,
        race: u8,
        eyes: u8,
        mouth: u8,
        haircut: u8,
        skin: u8,
        outfit: u8,
        accessories: u8,
    }

    public fun whitelist_entry_added_id(whitelist_entry_added: &WhitelistEntryAdded): object::ID {
        whitelist_entry_added.id
    }

    public fun whitelist_entry_added_account_address(whitelist_entry_added: &WhitelistEntryAdded): address {
        whitelist_entry_added.account_address
    }

    public fun whitelist_entry_added_name(whitelist_entry_added: &WhitelistEntryAdded): String {
        whitelist_entry_added.name
    }

    public fun whitelist_entry_added_image_url(whitelist_entry_added: &WhitelistEntryAdded): String {
        whitelist_entry_added.image_url
    }

    public fun whitelist_entry_added_description(whitelist_entry_added: &WhitelistEntryAdded): String {
        whitelist_entry_added.description
    }

    public fun whitelist_entry_added_background_color(whitelist_entry_added: &WhitelistEntryAdded): u32 {
        whitelist_entry_added.background_color
    }

    public fun whitelist_entry_added_race(whitelist_entry_added: &WhitelistEntryAdded): u8 {
        whitelist_entry_added.race
    }

    public fun whitelist_entry_added_eyes(whitelist_entry_added: &WhitelistEntryAdded): u8 {
        whitelist_entry_added.eyes
    }

    public fun whitelist_entry_added_mouth(whitelist_entry_added: &WhitelistEntryAdded): u8 {
        whitelist_entry_added.mouth
    }

    public fun whitelist_entry_added_haircut(whitelist_entry_added: &WhitelistEntryAdded): u8 {
        whitelist_entry_added.haircut
    }

    public fun whitelist_entry_added_skin(whitelist_entry_added: &WhitelistEntryAdded): u8 {
        whitelist_entry_added.skin
    }

    public fun whitelist_entry_added_outfit(whitelist_entry_added: &WhitelistEntryAdded): u8 {
        whitelist_entry_added.outfit
    }

    public fun whitelist_entry_added_accessories(whitelist_entry_added: &WhitelistEntryAdded): u8 {
        whitelist_entry_added.accessories
    }

    public(friend) fun new_whitelist_entry_added(
        whitelist: &Whitelist,
        account_address: address,
        name: String,
        image_url: String,
        description: String,
        background_color: u32,
        race: u8,
        eyes: u8,
        mouth: u8,
        haircut: u8,
        skin: u8,
        outfit: u8,
        accessories: u8,
    ): WhitelistEntryAdded {
        WhitelistEntryAdded {
            id: id(whitelist),
            version: version(whitelist),
            account_address,
            name,
            image_url,
            description,
            background_color,
            race,
            eyes,
            mouth,
            haircut,
            skin,
            outfit,
            accessories,
        }
    }

    struct WhitelistEntryUpdated has copy, drop {
        id: object::ID,
        version: u64,
        account_address: address,
        name: String,
        image_url: String,
        description: String,
        background_color: u32,
        race: u8,
        eyes: u8,
        mouth: u8,
        haircut: u8,
        skin: u8,
        outfit: u8,
        accessories: u8,
        claimed: bool,
        paused: bool,
    }

    public fun whitelist_entry_updated_id(whitelist_entry_updated: &WhitelistEntryUpdated): object::ID {
        whitelist_entry_updated.id
    }

    public fun whitelist_entry_updated_account_address(whitelist_entry_updated: &WhitelistEntryUpdated): address {
        whitelist_entry_updated.account_address
    }

    public fun whitelist_entry_updated_name(whitelist_entry_updated: &WhitelistEntryUpdated): String {
        whitelist_entry_updated.name
    }

    public fun whitelist_entry_updated_image_url(whitelist_entry_updated: &WhitelistEntryUpdated): String {
        whitelist_entry_updated.image_url
    }

    public fun whitelist_entry_updated_description(whitelist_entry_updated: &WhitelistEntryUpdated): String {
        whitelist_entry_updated.description
    }

    public fun whitelist_entry_updated_background_color(whitelist_entry_updated: &WhitelistEntryUpdated): u32 {
        whitelist_entry_updated.background_color
    }

    public fun whitelist_entry_updated_race(whitelist_entry_updated: &WhitelistEntryUpdated): u8 {
        whitelist_entry_updated.race
    }

    public fun whitelist_entry_updated_eyes(whitelist_entry_updated: &WhitelistEntryUpdated): u8 {
        whitelist_entry_updated.eyes
    }

    public fun whitelist_entry_updated_mouth(whitelist_entry_updated: &WhitelistEntryUpdated): u8 {
        whitelist_entry_updated.mouth
    }

    public fun whitelist_entry_updated_haircut(whitelist_entry_updated: &WhitelistEntryUpdated): u8 {
        whitelist_entry_updated.haircut
    }

    public fun whitelist_entry_updated_skin(whitelist_entry_updated: &WhitelistEntryUpdated): u8 {
        whitelist_entry_updated.skin
    }

    public fun whitelist_entry_updated_outfit(whitelist_entry_updated: &WhitelistEntryUpdated): u8 {
        whitelist_entry_updated.outfit
    }

    public fun whitelist_entry_updated_accessories(whitelist_entry_updated: &WhitelistEntryUpdated): u8 {
        whitelist_entry_updated.accessories
    }

    public fun whitelist_entry_updated_claimed(whitelist_entry_updated: &WhitelistEntryUpdated): bool {
        whitelist_entry_updated.claimed
    }

    public fun whitelist_entry_updated_paused(whitelist_entry_updated: &WhitelistEntryUpdated): bool {
        whitelist_entry_updated.paused
    }

    public(friend) fun new_whitelist_entry_updated(
        whitelist: &Whitelist,
        account_address: address,
        name: String,
        image_url: String,
        description: String,
        background_color: u32,
        race: u8,
        eyes: u8,
        mouth: u8,
        haircut: u8,
        skin: u8,
        outfit: u8,
        accessories: u8,
        claimed: bool,
        paused: bool,
    ): WhitelistEntryUpdated {
        WhitelistEntryUpdated {
            id: id(whitelist),
            version: version(whitelist),
            account_address,
            name,
            image_url,
            description,
            background_color,
            race,
            eyes,
            mouth,
            haircut,
            skin,
            outfit,
            accessories,
            claimed,
            paused,
        }
    }

    struct WhitelistClaimed has copy, drop {
        id: object::ID,
        version: u64,
        account_address: address,
    }

    public fun whitelist_claimed_id(whitelist_claimed: &WhitelistClaimed): object::ID {
        whitelist_claimed.id
    }

    public fun whitelist_claimed_account_address(whitelist_claimed: &WhitelistClaimed): address {
        whitelist_claimed.account_address
    }

    public(friend) fun new_whitelist_claimed(
        whitelist: &Whitelist,
        account_address: address,
    ): WhitelistClaimed {
        WhitelistClaimed {
            id: id(whitelist),
            version: version(whitelist),
            account_address,
        }
    }


    #[lint_allow(share_owned)]
    public(friend) fun share_object(whitelist: Whitelist) {
        assert!(whitelist.version == 0, EInappropriateVersion);
        transfer::share_object(whitelist);
    }

    public(friend) fun update_object_version(whitelist: &mut Whitelist) {
        whitelist.version = whitelist.version + 1;
        //assert!(whitelist.version != 0, EInappropriateVersion);
    }

    public(friend) fun drop_whitelist(whitelist: Whitelist) {
        let Whitelist {
            id,
            version: _version,
            paused: _paused,
            entries,
        } = whitelist;
        object::delete(id);
        table::destroy_empty(entries);
    }

    public(friend) fun emit_whitelist_updated(whitelist_updated: WhitelistUpdated) {
        event::emit(whitelist_updated);
    }

    public(friend) fun emit_whitelist_entry_added(whitelist_entry_added: WhitelistEntryAdded) {
        event::emit(whitelist_entry_added);
    }

    public(friend) fun emit_whitelist_entry_updated(whitelist_entry_updated: WhitelistEntryUpdated) {
        event::emit(whitelist_entry_updated);
    }

    public(friend) fun emit_whitelist_claimed(whitelist_claimed: WhitelistClaimed) {
        event::emit(whitelist_claimed);
    }

}
