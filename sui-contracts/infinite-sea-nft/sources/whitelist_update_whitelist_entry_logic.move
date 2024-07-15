module infinite_sea_nft::whitelist_update_whitelist_entry_logic {
    use infinite_sea_nft::whitelist;
    use infinite_sea_nft::whitelist_entry;
    use std::string::String;
    use sui::tx_context::TxContext;

    friend infinite_sea_nft::whitelist_aggregate;

    public(friend) fun verify(
        address: address,
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
        whitelist: &whitelist::Whitelist,
        ctx: &TxContext,
    ): whitelist::WhitelistEntryUpdated {
        let _ = ctx;
        let whitelist_entry = whitelist::borrow_entry(whitelist, address);
        let _ = whitelist_entry;
        whitelist::new_whitelist_entry_updated(
            whitelist,
            address,
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
        )
    }

    public(friend) fun mutate(
        whitelist_entry_updated: &whitelist::WhitelistEntryUpdated,
        whitelist: &mut whitelist::Whitelist,
        ctx: &TxContext, // modify the reference to mutable if needed
    ) {
        let address = whitelist::whitelist_entry_updated_account_address(whitelist_entry_updated);
        let name = whitelist::whitelist_entry_updated_name(whitelist_entry_updated);
        let image_url = whitelist::whitelist_entry_updated_image_url(whitelist_entry_updated);
        let description = whitelist::whitelist_entry_updated_description(whitelist_entry_updated);
        let background_color = whitelist::whitelist_entry_updated_background_color(whitelist_entry_updated);
        let race = whitelist::whitelist_entry_updated_race(whitelist_entry_updated);
        let eyes = whitelist::whitelist_entry_updated_eyes(whitelist_entry_updated);
        let mouth = whitelist::whitelist_entry_updated_mouth(whitelist_entry_updated);
        let haircut = whitelist::whitelist_entry_updated_haircut(whitelist_entry_updated);
        let skin = whitelist::whitelist_entry_updated_skin(whitelist_entry_updated);
        let outfit = whitelist::whitelist_entry_updated_outfit(whitelist_entry_updated);
        let accessories = whitelist::whitelist_entry_updated_accessories(whitelist_entry_updated);
        let claimed = whitelist::whitelist_entry_updated_claimed(whitelist_entry_updated);
        let paused = whitelist::whitelist_entry_updated_paused(whitelist_entry_updated);
        let _ = ctx;
        let whitelist_entry = whitelist::borrow_mut_entry(whitelist, address);
        whitelist_entry::set_name(whitelist_entry, name);
        whitelist_entry::set_image_url(whitelist_entry, image_url);
        whitelist_entry::set_description(whitelist_entry, description);
        whitelist_entry::set_background_color(whitelist_entry, background_color);
        whitelist_entry::set_race(whitelist_entry, race);
        whitelist_entry::set_eyes(whitelist_entry, eyes);
        whitelist_entry::set_mouth(whitelist_entry, mouth);
        whitelist_entry::set_haircut(whitelist_entry, haircut);
        whitelist_entry::set_skin(whitelist_entry, skin);
        whitelist_entry::set_outfit(whitelist_entry, outfit);
        whitelist_entry::set_accessories(whitelist_entry, accessories);
        whitelist_entry::set_claimed(whitelist_entry, claimed);
        whitelist_entry::set_paused(whitelist_entry, paused);
    }

}
