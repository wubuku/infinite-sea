// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module infinite_sea_nft::whitelist_aggregate {
    use infinite_sea_nft::whitelist;
    use infinite_sea_nft::whitelist_add_whitelist_entry_logic;
    use infinite_sea_nft::whitelist_update_logic;
    use infinite_sea_nft::whitelist_update_whitelist_entry_logic;
    use std::string::String;
    use sui::tx_context;

    const ENotPublisher: u64 = 50;

    public entry fun update(
        whitelist: &mut whitelist::Whitelist,
        publisher: &sui::package::Publisher,
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(sui::package::from_package<whitelist::Whitelist>(publisher), ENotPublisher);
        let whitelist_updated = whitelist_update_logic::verify(
            whitelist,
            ctx,
        );
        whitelist_update_logic::mutate(
            &whitelist_updated,
            whitelist,
            ctx,
        );
        whitelist::update_object_version(whitelist);
        whitelist::emit_whitelist_updated(whitelist_updated);
    }

    public entry fun add_whitelist_entry(
        whitelist: &mut whitelist::Whitelist,
        publisher: &sui::package::Publisher,
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
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(sui::package::from_package<whitelist::Whitelist>(publisher), ENotPublisher);
        let whitelist_entry_added = whitelist_add_whitelist_entry_logic::verify(
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
            whitelist,
            ctx,
        );
        whitelist_add_whitelist_entry_logic::mutate(
            &whitelist_entry_added,
            whitelist,
            ctx,
        );
        whitelist::update_object_version(whitelist);
        whitelist::emit_whitelist_entry_added(whitelist_entry_added);
    }

    public entry fun update_whitelist_entry(
        whitelist: &mut whitelist::Whitelist,
        publisher: &sui::package::Publisher,
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
        ctx: &mut tx_context::TxContext,
    ) {
        assert!(sui::package::from_package<whitelist::Whitelist>(publisher), ENotPublisher);
        let whitelist_entry_updated = whitelist_update_whitelist_entry_logic::verify(
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
            whitelist,
            ctx,
        );
        whitelist_update_whitelist_entry_logic::mutate(
            &whitelist_entry_updated,
            whitelist,
            ctx,
        );
        whitelist::update_object_version(whitelist);
        whitelist::emit_whitelist_entry_updated(whitelist_entry_updated);
    }

}
