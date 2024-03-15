# Sui Client CLI Cheatsheet

[ToC]

## Item aggregate

### Create method

```shell
sui client call --package _PACKAGE_ID_ --module item_aggregate --function create \
--args u32_item_id \"_SUI_PACKAGE_PUBLISHER_OBJECT_ID_\" std__module__ascii__module__string_name bool_required_for_completion u32_sells_for \"_ITEM_ITEM_TABLE_OBJECT_ID_\" \
--gas-budget 100000
```

### Update method

```shell
sui client call --package _PACKAGE_ID_ --module item_aggregate --function update \
--args item_Object_ID \"_SUI_PACKAGE_PUBLISHER_OBJECT_ID_\" std__module__ascii__module__string_name bool_required_for_completion u32_sells_for \
--gas-budget 100000
```

## ItemCreation aggregate

### Create method

```shell
sui client call --package _PACKAGE_ID_ --module item_creation_aggregate --function create \
--args u8_item_creation_id_skill_type u32_item_creation_id_item_id \"_SUI_PACKAGE_PUBLISHER_OBJECT_ID_\" u16_requirements_level u32_base_quantity u32_base_experience \"u64_base_creation_time\" \"u64_energy_cost\" u16_success_rate \"_ITEM_CREATION_ITEM_CREATION_TABLE_OBJECT_ID_\" \
--gas-budget 100000
```

### Update method

```shell
sui client call --package _PACKAGE_ID_ --module item_creation_aggregate --function update \
--args item_creation_Object_ID \"_SUI_PACKAGE_PUBLISHER_OBJECT_ID_\" u16_requirements_level u32_base_quantity u32_base_experience \"u64_base_creation_time\" \"u64_energy_cost\" u16_success_rate \
--gas-budget 100000
```

## ItemProduction aggregate

### Create method

```shell
sui client call --package _PACKAGE_ID_ --module item_production_aggregate --function create \
--args u8_item_production_id_skill_type u32_item_production_id_item_id \"_SUI_PACKAGE_PUBLISHER_OBJECT_ID_\" '[u32_production_materials_item_id_list_item_1,u32_production_materials_item_id_list_item_2]' '[u32_production_materials_item_quantity_list_item_1,u32_production_materials_item_quantity_list_item_2]' u16_requirements_level u32_base_quantity u32_base_experience \"u64_base_creation_time\" \"u64_energy_cost\" u16_success_rate \"_ITEM_PRODUCTION_ITEM_PRODUCTION_TABLE_OBJECT_ID_\" \
--gas-budget 100000
```

### Update method

```shell
sui client call --package _PACKAGE_ID_ --module item_production_aggregate --function update \
--args item_production_Object_ID \"_SUI_PACKAGE_PUBLISHER_OBJECT_ID_\" '[u32_production_materials_item_id_list_item_1,u32_production_materials_item_id_list_item_2]' '[u32_production_materials_item_quantity_list_item_1,u32_production_materials_item_quantity_list_item_2]' u16_requirements_level u32_base_quantity u32_base_experience \"u64_base_creation_time\" \"u64_energy_cost\" u16_success_rate \
--gas-budget 100000
```

## ExperienceTable singleton object

### AddLevel method

```shell
sui client call --package _PACKAGE_ID_ --module experience_table_aggregate --function add_level \
--args experience_table_Object_ID \"_SUI_PACKAGE_PUBLISHER_OBJECT_ID_\" u16_level u32_experience u32_difference \
--gas-budget 100000
```

### UpdateLevel method

```shell
sui client call --package _PACKAGE_ID_ --module experience_table_aggregate --function update_level \
--args experience_table_Object_ID \"_SUI_PACKAGE_PUBLISHER_OBJECT_ID_\" u16_level u32_experience u32_difference \
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

