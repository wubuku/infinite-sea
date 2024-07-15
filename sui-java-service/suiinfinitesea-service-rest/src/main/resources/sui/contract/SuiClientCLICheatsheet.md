# Sui Client CLI Cheatsheet

[ToC]

## Avatar aggregate

### Mint method

```shell
sui client call --package _PACKAGE_ID_ --module avatar_aggregate --function mint \
--args \"_SUI_PACKAGE_PUBLISHER_OBJECT_ID_\" address_owner '"string_name"' '"string_image_url"' '"string_description"' u32_background_color u8_race u8_eyes u8_mouth u8_haircut u8_skin u8_outfit u8_accessories \"vector_u8_aura\" \"vector_u8_symbols\" \"vector_u8_effects\" \"vector_u8_backgrounds\" \"vector_u8_decorations\" \"vector_u8_badges\" \
--gas-budget 100000
```

### Update method

```shell
sui client call --package _PACKAGE_ID_ --module avatar_aggregate --function update \
--args avatar_Object_ID \"_AVATAR_CHANGE_OBJECT_ID_\" \
--gas-budget 100000
```

### Burn method

```shell
sui client call --package _PACKAGE_ID_ --module avatar_aggregate --function burn \
--args avatar_Object_ID \
--gas-budget 100000
```

### WhitelistMint method

```shell
sui client call --package _PACKAGE_ID_ --module avatar_aggregate --function whitelist_mint \
--args \"_WHITELIST_OBJECT_ID_\" \
--gas-budget 100000
```

## AvatarChange aggregate

### Create method

```shell
sui client call --package _PACKAGE_ID_ --module avatar_change_aggregate --function create \
--args id_avatar_id \"_SUI_PACKAGE_PUBLISHER_OBJECT_ID_\" '"string_image_url"' '[u32_optional_background_color]' '[u8_optional_haircut]' '[u8_optional_outfit]' '[u8_optional_accessories]' \"vector_u8_aura\" \"vector_u8_symbols\" \"vector_u8_effects\" \"vector_u8_backgrounds\" \"vector_u8_decorations\" \"vector_u8_badges\" \"_AVATAR_CHANGE_AVATAR_CHANGE_TABLE_OBJECT_ID_\" \
--gas-budget 100000
```

### Update method

```shell
sui client call --package _PACKAGE_ID_ --module avatar_change_aggregate --function update \
--args avatar_change_Object_ID \"_SUI_PACKAGE_PUBLISHER_OBJECT_ID_\" '"string_image_url"' '[u32_optional_background_color]' '[u8_optional_haircut]' '[u8_optional_outfit]' '[u8_optional_accessories]' \"vector_u8_aura\" \"vector_u8_symbols\" \"vector_u8_effects\" \"vector_u8_backgrounds\" \"vector_u8_decorations\" \"vector_u8_badges\" \
--gas-budget 100000
```

### Delete method

```shell
sui client call --package _PACKAGE_ID_ --module avatar_change_aggregate --function delete \
--args avatar_change_Object_ID \"_SUI_PACKAGE_PUBLISHER_OBJECT_ID_\" \
--gas-budget 100000
```

## Whitelist singleton object

### Update method

```shell
sui client call --package _PACKAGE_ID_ --module whitelist_aggregate --function update \
--args whitelist_Object_ID \"_SUI_PACKAGE_PUBLISHER_OBJECT_ID_\" bool_paused \
--gas-budget 100000
```

### AddWhitelistEntry method

```shell
sui client call --package _PACKAGE_ID_ --module whitelist_aggregate --function add_whitelist_entry \
--args whitelist_Object_ID \"_SUI_PACKAGE_PUBLISHER_OBJECT_ID_\" address_account_address '"string_name"' '"string_image_url"' '"string_description"' u32_background_color u8_race u8_eyes u8_mouth u8_haircut u8_skin u8_outfit u8_accessories \
--gas-budget 100000
```

### UpdateWhitelistEntry method

```shell
sui client call --package _PACKAGE_ID_ --module whitelist_aggregate --function update_whitelist_entry \
--args whitelist_Object_ID \"_SUI_PACKAGE_PUBLISHER_OBJECT_ID_\" address_account_address '"string_name"' '"string_image_url"' '"string_description"' u32_background_color u8_race u8_eyes u8_mouth u8_haircut u8_skin u8_outfit u8_accessories bool_claimed bool_paused \
--gas-budget 100000
```


---

## Tips

You can escape single quotes in string arguments by using the following method when enclosing them within single quotes in a shell:

1. Close the current single quote.
2. Use a backslash `\` to escape the single quote.
3. Open a new set of single quotes to continue the string.

Here is an example of how to escape a single quote within a string enclosed by single quotes in a shell:

```shell
echo 'It'\''s a beautiful day'
```

