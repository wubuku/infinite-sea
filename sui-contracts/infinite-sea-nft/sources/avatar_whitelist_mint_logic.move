#[allow(unused_variable, unused_use, unused_assignment, unused_mut_parameter)]
module infinite_sea_nft::avatar_whitelist_mint_logic {
    use std::vector;
    use infinite_sea_nft::avatar;
    use infinite_sea_nft::whitelist::{Self, Whitelist};
    use sui::tx_context::{Self, TxContext};
    use infinite_sea_nft::whitelist_aggregate;
    use infinite_sea_nft::whitelist_entry;

    friend infinite_sea_nft::avatar_aggregate;

    public(friend) fun verify(
        whitelist: &mut Whitelist,
        ctx: &mut TxContext,
    ): avatar::AvatarWhitelistMinted {
        let owner = tx_context::sender(ctx);
        let entry = whitelist::borrow_entry(whitelist, owner);
        let name = whitelist_entry::name(entry);
        let image_url = whitelist_entry::image_url(entry);
        let description = whitelist_entry::description(entry);
        let background_color = whitelist_entry::background_color(entry);
        let race = whitelist_entry::race(entry);
        let eyes = whitelist_entry::eyes(entry);
        let mouth = whitelist_entry::mouth(entry);
        let haircut = whitelist_entry::haircut(entry);
        let skin = whitelist_entry::skin(entry);
        let outfit = whitelist_entry::outfit(entry);
        let accessories = whitelist_entry::accessories(entry);

        avatar::new_avatar_whitelist_minted(
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
        )
    }

    public(friend) fun mutate(
        avatar_whitelist_minted: &avatar::AvatarWhitelistMinted,
        whitelist: &mut Whitelist,
        ctx: &mut TxContext, // modify the reference to mutable if needed
    ): avatar::Avatar {
        let owner = avatar::avatar_whitelist_minted_owner(avatar_whitelist_minted);
        let name = avatar::avatar_whitelist_minted_name(avatar_whitelist_minted);
        let image_url = avatar::avatar_whitelist_minted_image_url(avatar_whitelist_minted);
        let description = avatar::avatar_whitelist_minted_description(avatar_whitelist_minted);
        let background_color = avatar::avatar_whitelist_minted_background_color(avatar_whitelist_minted);
        let race = avatar::avatar_whitelist_minted_race(avatar_whitelist_minted);
        let eyes = avatar::avatar_whitelist_minted_eyes(avatar_whitelist_minted);
        let mouth = avatar::avatar_whitelist_minted_mouth(avatar_whitelist_minted);
        let haircut = avatar::avatar_whitelist_minted_haircut(avatar_whitelist_minted);
        let skin = avatar::avatar_whitelist_minted_skin(avatar_whitelist_minted);
        let outfit = avatar::avatar_whitelist_minted_outfit(avatar_whitelist_minted);
        let accessories = avatar::avatar_whitelist_minted_accessories(avatar_whitelist_minted);

        let aura = vector::empty();
        let symbols = vector::empty();
        let effects = vector::empty();
        let backgrounds = vector::empty();
        let decorations = vector::empty();
        let badges = vector::empty();

        let avatar = avatar::new_avatar(
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
            ctx,
        );

        whitelist_aggregate::claim(whitelist, ctx);

        avatar
    }

}
