// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module infinite_sea_nft::avatar {
    use std::option;
    use std::string::String;
    use sui::event;
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;

    struct AVATAR has drop {}

    friend infinite_sea_nft::avatar_mint_logic;
    friend infinite_sea_nft::avatar_update_logic;
    friend infinite_sea_nft::avatar_burn_logic;
    friend infinite_sea_nft::avatar_whitelist_mint_logic;
    friend infinite_sea_nft::avatar_aggregate;

    #[allow(unused_const)]
    const EDataTooLong: u64 = 102;
    #[allow(unused_const)]
    const EInappropriateVersion: u64 = 103;
    const EEmptyObjectID: u64 = 107;

    fun init(otw: AVATAR, ctx: &mut TxContext) {
        let keys = vector[
            std::string::utf8(b"name"),
            std::string::utf8(b"image_url"),
            std::string::utf8(b"description"),
            std::string::utf8(b"creator"),
        ];
        let values = vector[
            std::string::utf8(b"{name}"),
            std::string::utf8(b"{image_url}"),
            std::string::utf8(b"{description}"),
            std::string::utf8(b"Infinite Seas Team"),
        ];
        let publisher = sui::package::claim(otw, ctx);
        let display = sui::display::new_with_fields<Avatar>(
            &publisher, keys, values, ctx
        );
        sui::display::update_version(&mut display);
        sui::transfer::public_transfer(publisher, sui::tx_context::sender(ctx));
        sui::transfer::public_transfer(display, sui::tx_context::sender(ctx));
    }

    struct Avatar has key, store {
        id: UID,
        version: u64,
        owner: address,
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
        aura: vector<u8>,
        symbols: vector<u8>,
        effects: vector<u8>,
        backgrounds: vector<u8>,
        decorations: vector<u8>,
        badges: vector<u8>,
    }

    public fun id(avatar: &Avatar): object::ID {
        object::uid_to_inner(&avatar.id)
    }

    public fun version(avatar: &Avatar): u64 {
        avatar.version
    }

    public fun owner(avatar: &Avatar): address {
        avatar.owner
    }

    public(friend) fun set_owner(avatar: &mut Avatar, owner: address) {
        avatar.owner = owner;
    }

    public fun name(avatar: &Avatar): String {
        avatar.name
    }

    public(friend) fun set_name(avatar: &mut Avatar, name: String) {
        assert!(std::string::length(&name) <= 100, EDataTooLong);
        avatar.name = name;
    }

    public fun image_url(avatar: &Avatar): String {
        avatar.image_url
    }

    public(friend) fun set_image_url(avatar: &mut Avatar, image_url: String) {
        assert!(std::string::length(&image_url) <= 200, EDataTooLong);
        avatar.image_url = image_url;
    }

    public fun description(avatar: &Avatar): String {
        avatar.description
    }

    public(friend) fun set_description(avatar: &mut Avatar, description: String) {
        assert!(std::string::length(&description) <= 500, EDataTooLong);
        avatar.description = description;
    }

    public fun background_color(avatar: &Avatar): u32 {
        avatar.background_color
    }

    public(friend) fun set_background_color(avatar: &mut Avatar, background_color: u32) {
        avatar.background_color = background_color;
    }

    public fun race(avatar: &Avatar): u8 {
        avatar.race
    }

    public(friend) fun set_race(avatar: &mut Avatar, race: u8) {
        avatar.race = race;
    }

    public fun eyes(avatar: &Avatar): u8 {
        avatar.eyes
    }

    public(friend) fun set_eyes(avatar: &mut Avatar, eyes: u8) {
        avatar.eyes = eyes;
    }

    public fun mouth(avatar: &Avatar): u8 {
        avatar.mouth
    }

    public(friend) fun set_mouth(avatar: &mut Avatar, mouth: u8) {
        avatar.mouth = mouth;
    }

    public fun haircut(avatar: &Avatar): u8 {
        avatar.haircut
    }

    public(friend) fun set_haircut(avatar: &mut Avatar, haircut: u8) {
        avatar.haircut = haircut;
    }

    public fun skin(avatar: &Avatar): u8 {
        avatar.skin
    }

    public(friend) fun set_skin(avatar: &mut Avatar, skin: u8) {
        avatar.skin = skin;
    }

    public fun outfit(avatar: &Avatar): u8 {
        avatar.outfit
    }

    public(friend) fun set_outfit(avatar: &mut Avatar, outfit: u8) {
        avatar.outfit = outfit;
    }

    public fun accessories(avatar: &Avatar): u8 {
        avatar.accessories
    }

    public(friend) fun set_accessories(avatar: &mut Avatar, accessories: u8) {
        avatar.accessories = accessories;
    }

    public fun aura(avatar: &Avatar): vector<u8> {
        avatar.aura
    }

    public(friend) fun set_aura(avatar: &mut Avatar, aura: vector<u8>) {
        avatar.aura = aura;
    }

    public fun symbols(avatar: &Avatar): vector<u8> {
        avatar.symbols
    }

    public(friend) fun set_symbols(avatar: &mut Avatar, symbols: vector<u8>) {
        avatar.symbols = symbols;
    }

    public fun effects(avatar: &Avatar): vector<u8> {
        avatar.effects
    }

    public(friend) fun set_effects(avatar: &mut Avatar, effects: vector<u8>) {
        avatar.effects = effects;
    }

    public fun backgrounds(avatar: &Avatar): vector<u8> {
        avatar.backgrounds
    }

    public(friend) fun set_backgrounds(avatar: &mut Avatar, backgrounds: vector<u8>) {
        avatar.backgrounds = backgrounds;
    }

    public fun decorations(avatar: &Avatar): vector<u8> {
        avatar.decorations
    }

    public(friend) fun set_decorations(avatar: &mut Avatar, decorations: vector<u8>) {
        avatar.decorations = decorations;
    }

    public fun badges(avatar: &Avatar): vector<u8> {
        avatar.badges
    }

    public(friend) fun set_badges(avatar: &mut Avatar, badges: vector<u8>) {
        avatar.badges = badges;
    }

    public(friend) fun new_avatar(
        owner: address,
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
        aura: vector<u8>,
        symbols: vector<u8>,
        effects: vector<u8>,
        backgrounds: vector<u8>,
        decorations: vector<u8>,
        badges: vector<u8>,
        ctx: &mut TxContext,
    ): Avatar {
        assert!(std::string::length(&name) <= 100, EDataTooLong);
        assert!(std::string::length(&image_url) <= 200, EDataTooLong);
        assert!(std::string::length(&description) <= 500, EDataTooLong);
        Avatar {
            id: object::new(ctx),
            version: 0,
            owner,
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
            aura,
            symbols,
            effects,
            backgrounds,
            decorations,
            badges,
        }
    }

    struct AvatarMinted has copy, drop {
        id: option::Option<object::ID>,
        owner: address,
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
        aura: vector<u8>,
        symbols: vector<u8>,
        effects: vector<u8>,
        backgrounds: vector<u8>,
        decorations: vector<u8>,
        badges: vector<u8>,
    }

    public fun avatar_minted_id(avatar_minted: &AvatarMinted): option::Option<object::ID> {
        avatar_minted.id
    }

    public(friend) fun set_avatar_minted_id(avatar_minted: &mut AvatarMinted, id: object::ID) {
        avatar_minted.id = option::some(id);
    }

    public fun avatar_minted_owner(avatar_minted: &AvatarMinted): address {
        avatar_minted.owner
    }

    public fun avatar_minted_name(avatar_minted: &AvatarMinted): String {
        avatar_minted.name
    }

    public fun avatar_minted_image_url(avatar_minted: &AvatarMinted): String {
        avatar_minted.image_url
    }

    public fun avatar_minted_description(avatar_minted: &AvatarMinted): String {
        avatar_minted.description
    }

    public fun avatar_minted_background_color(avatar_minted: &AvatarMinted): u32 {
        avatar_minted.background_color
    }

    public fun avatar_minted_race(avatar_minted: &AvatarMinted): u8 {
        avatar_minted.race
    }

    public fun avatar_minted_eyes(avatar_minted: &AvatarMinted): u8 {
        avatar_minted.eyes
    }

    public fun avatar_minted_mouth(avatar_minted: &AvatarMinted): u8 {
        avatar_minted.mouth
    }

    public fun avatar_minted_haircut(avatar_minted: &AvatarMinted): u8 {
        avatar_minted.haircut
    }

    public fun avatar_minted_skin(avatar_minted: &AvatarMinted): u8 {
        avatar_minted.skin
    }

    public fun avatar_minted_outfit(avatar_minted: &AvatarMinted): u8 {
        avatar_minted.outfit
    }

    public fun avatar_minted_accessories(avatar_minted: &AvatarMinted): u8 {
        avatar_minted.accessories
    }

    public fun avatar_minted_aura(avatar_minted: &AvatarMinted): vector<u8> {
        avatar_minted.aura
    }

    public fun avatar_minted_symbols(avatar_minted: &AvatarMinted): vector<u8> {
        avatar_minted.symbols
    }

    public fun avatar_minted_effects(avatar_minted: &AvatarMinted): vector<u8> {
        avatar_minted.effects
    }

    public fun avatar_minted_backgrounds(avatar_minted: &AvatarMinted): vector<u8> {
        avatar_minted.backgrounds
    }

    public fun avatar_minted_decorations(avatar_minted: &AvatarMinted): vector<u8> {
        avatar_minted.decorations
    }

    public fun avatar_minted_badges(avatar_minted: &AvatarMinted): vector<u8> {
        avatar_minted.badges
    }

    public(friend) fun new_avatar_minted(
        owner: address,
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
        aura: vector<u8>,
        symbols: vector<u8>,
        effects: vector<u8>,
        backgrounds: vector<u8>,
        decorations: vector<u8>,
        badges: vector<u8>,
    ): AvatarMinted {
        AvatarMinted {
            id: option::none(),
            owner,
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
            aura,
            symbols,
            effects,
            backgrounds,
            decorations,
            badges,
        }
    }

    struct AvatarUpdated has copy, drop {
        id: object::ID,
        version: u64,
    }

    public fun avatar_updated_id(avatar_updated: &AvatarUpdated): object::ID {
        avatar_updated.id
    }

    public(friend) fun new_avatar_updated(
        avatar: &Avatar,
    ): AvatarUpdated {
        AvatarUpdated {
            id: id(avatar),
            version: version(avatar),
        }
    }

    struct AvatarBurned has copy, drop {
        id: object::ID,
        version: u64,
    }

    public fun avatar_burned_id(avatar_burned: &AvatarBurned): object::ID {
        avatar_burned.id
    }

    public(friend) fun new_avatar_burned(
        avatar: &Avatar,
    ): AvatarBurned {
        AvatarBurned {
            id: id(avatar),
            version: version(avatar),
        }
    }

    struct AvatarWhitelistMinted has copy, drop {
        id: option::Option<object::ID>,
        owner: address,
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

    public fun avatar_whitelist_minted_id(avatar_whitelist_minted: &AvatarWhitelistMinted): option::Option<object::ID> {
        avatar_whitelist_minted.id
    }

    public(friend) fun set_avatar_whitelist_minted_id(avatar_whitelist_minted: &mut AvatarWhitelistMinted, id: object::ID) {
        avatar_whitelist_minted.id = option::some(id);
    }

    public fun avatar_whitelist_minted_owner(avatar_whitelist_minted: &AvatarWhitelistMinted): address {
        avatar_whitelist_minted.owner
    }

    public fun avatar_whitelist_minted_name(avatar_whitelist_minted: &AvatarWhitelistMinted): String {
        avatar_whitelist_minted.name
    }

    public fun avatar_whitelist_minted_image_url(avatar_whitelist_minted: &AvatarWhitelistMinted): String {
        avatar_whitelist_minted.image_url
    }

    public fun avatar_whitelist_minted_description(avatar_whitelist_minted: &AvatarWhitelistMinted): String {
        avatar_whitelist_minted.description
    }

    public fun avatar_whitelist_minted_background_color(avatar_whitelist_minted: &AvatarWhitelistMinted): u32 {
        avatar_whitelist_minted.background_color
    }

    public fun avatar_whitelist_minted_race(avatar_whitelist_minted: &AvatarWhitelistMinted): u8 {
        avatar_whitelist_minted.race
    }

    public fun avatar_whitelist_minted_eyes(avatar_whitelist_minted: &AvatarWhitelistMinted): u8 {
        avatar_whitelist_minted.eyes
    }

    public fun avatar_whitelist_minted_mouth(avatar_whitelist_minted: &AvatarWhitelistMinted): u8 {
        avatar_whitelist_minted.mouth
    }

    public fun avatar_whitelist_minted_haircut(avatar_whitelist_minted: &AvatarWhitelistMinted): u8 {
        avatar_whitelist_minted.haircut
    }

    public fun avatar_whitelist_minted_skin(avatar_whitelist_minted: &AvatarWhitelistMinted): u8 {
        avatar_whitelist_minted.skin
    }

    public fun avatar_whitelist_minted_outfit(avatar_whitelist_minted: &AvatarWhitelistMinted): u8 {
        avatar_whitelist_minted.outfit
    }

    public fun avatar_whitelist_minted_accessories(avatar_whitelist_minted: &AvatarWhitelistMinted): u8 {
        avatar_whitelist_minted.accessories
    }

    public(friend) fun new_avatar_whitelist_minted(
        owner: address,
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
    ): AvatarWhitelistMinted {
        AvatarWhitelistMinted {
            id: option::none(),
            owner,
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


    #[lint_allow(custom_state_change)]
    public(friend) fun transfer_object(avatar: Avatar, recipient: address) {
        assert!(avatar.version == 0, EInappropriateVersion);
        transfer::transfer(avatar, recipient);
    }

    #[lint_allow(custom_state_change)]
    public(friend) fun update_version_and_transfer_object(avatar: Avatar, recipient: address) {
        update_object_version(&mut avatar);
        transfer::transfer(avatar, recipient);
    }

    fun update_object_version(avatar: &mut Avatar) {
        avatar.version = avatar.version + 1;
        //assert!(avatar.version != 0, EInappropriateVersion);
    }

    public(friend) fun drop_avatar(avatar: Avatar) {
        let Avatar {
            id,
            version: _version,
            owner: _owner,
            name: _name,
            image_url: _image_url,
            description: _description,
            background_color: _background_color,
            race: _race,
            eyes: _eyes,
            mouth: _mouth,
            haircut: _haircut,
            skin: _skin,
            outfit: _outfit,
            accessories: _accessories,
            aura: _aura,
            symbols: _symbols,
            effects: _effects,
            backgrounds: _backgrounds,
            decorations: _decorations,
            badges: _badges,
        } = avatar;
        object::delete(id);
    }

    public(friend) fun emit_avatar_minted(avatar_minted: AvatarMinted) {
        assert!(std::option::is_some(&avatar_minted.id), EEmptyObjectID);
        event::emit(avatar_minted);
    }

    public(friend) fun emit_avatar_updated(avatar_updated: AvatarUpdated) {
        event::emit(avatar_updated);
    }

    public(friend) fun emit_avatar_burned(avatar_burned: AvatarBurned) {
        event::emit(avatar_burned);
    }

    public(friend) fun emit_avatar_whitelist_minted(avatar_whitelist_minted: AvatarWhitelistMinted) {
        assert!(std::option::is_some(&avatar_whitelist_minted.id), EEmptyObjectID);
        event::emit(avatar_whitelist_minted);
    }

}
