module infinite_sea_nft::whitelist_add_whitelist_entry_logic {
    use infinite_sea_nft::whitelist;
    use infinite_sea_nft::whitelist_entry;
    use std::string::String;
    use sui::tx_context::TxContext;

    friend infinite_sea_nft::whitelist_aggregate;

    public(friend) fun verify(
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
        whitelist: &whitelist::Whitelist,
        ctx: &TxContext,
    ): whitelist::WhitelistEntryAdded {
        let _ = ctx;
        whitelist::new_whitelist_entry_added(
            whitelist,
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
        )
    }

    public(friend) fun mutate(
        whitelist_entry_added: &whitelist::WhitelistEntryAdded,
        whitelist: &mut whitelist::Whitelist,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let account_address = whitelist::whitelist_entry_added_account_address(whitelist_entry_added);
        let name = whitelist::whitelist_entry_added_name(whitelist_entry_added);
        let image_url = whitelist::whitelist_entry_added_image_url(whitelist_entry_added);
        let description = whitelist::whitelist_entry_added_description(whitelist_entry_added);
        let background_color = whitelist::whitelist_entry_added_background_color(whitelist_entry_added);
        let race = whitelist::whitelist_entry_added_race(whitelist_entry_added);
        let eyes = whitelist::whitelist_entry_added_eyes(whitelist_entry_added);
        let mouth = whitelist::whitelist_entry_added_mouth(whitelist_entry_added);
        let haircut = whitelist::whitelist_entry_added_haircut(whitelist_entry_added);
        let skin = whitelist::whitelist_entry_added_skin(whitelist_entry_added);
        let outfit = whitelist::whitelist_entry_added_outfit(whitelist_entry_added);
        let accessories = whitelist::whitelist_entry_added_accessories(whitelist_entry_added);
        let _ = ctx;
        let whitelist_entry = whitelist_entry::new_whitelist_entry(
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
        );
        whitelist::add_entry(whitelist, whitelist_entry);
    }

}
