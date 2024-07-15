#[allow(unused_mut_parameter)]
module infinite_sea_nft::avatar_mint_logic {
    use infinite_sea_nft::avatar;
    use std::string::String;
    use sui::tx_context::TxContext;

    friend infinite_sea_nft::avatar_aggregate;

    public(friend) fun verify(
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
    ): avatar::AvatarMinted {
        let _ = ctx;
        avatar::new_avatar_minted(
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
        )
    }

    public(friend) fun mutate(
        avatar_minted: &avatar::AvatarMinted,
        ctx: &mut TxContext,
    ): avatar::Avatar {
        let owner = avatar::avatar_minted_owner(avatar_minted);
        let name = avatar::avatar_minted_name(avatar_minted);
        let image_url = avatar::avatar_minted_image_url(avatar_minted);
        let description = avatar::avatar_minted_description(avatar_minted);
        let background_color = avatar::avatar_minted_background_color(avatar_minted);
        let race = avatar::avatar_minted_race(avatar_minted);
        let eyes = avatar::avatar_minted_eyes(avatar_minted);
        let mouth = avatar::avatar_minted_mouth(avatar_minted);
        let haircut = avatar::avatar_minted_haircut(avatar_minted);
        let skin = avatar::avatar_minted_skin(avatar_minted);
        let outfit = avatar::avatar_minted_outfit(avatar_minted);
        let accessories = avatar::avatar_minted_accessories(avatar_minted);
        let aura = avatar::avatar_minted_aura(avatar_minted);
        let symbols = avatar::avatar_minted_symbols(avatar_minted);
        let effects = avatar::avatar_minted_effects(avatar_minted);
        let backgrounds = avatar::avatar_minted_backgrounds(avatar_minted);
        let decorations = avatar::avatar_minted_decorations(avatar_minted);
        let badges = avatar::avatar_minted_badges(avatar_minted);
        avatar::new_avatar(
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
        )
    }

}
