# README


## 编码

```shell
docker run \
-v .:/myapp \
wubuku/dddappp:0.0.1 \
--dddmlDirectoryPath /myapp/dddml \
--boundedContextName Dddml.SuiInfiniteSea \
--suiMoveProjectDirectoryPath /myapp/sui-contracts \
--boundedContextSuiPackageName infinite_sea \
--boundedContextJavaPackageName org.dddml.suiinfinitesea \
--javaProjectsDirectoryPath /myapp/sui-java-service \
--javaProjectNamePrefix suiinfinitesea \
--pomGroupId dddml.suiinfinitesea \
--enableMultipleMoveProjects
```


## 测试应用

### 发布 coin 合约

能量（`ENERGY`）币的合约在 `./sui-contracts/infinite-sea-coin` 目录。

进入目录，发布合约：

```shell
sui client publish --gas-budget 200000000 --skip-dependency-verification --skip-fetch-latest-git-deps
```

我们在 testnet 上发布了这个合约，交易摘要：`F63nQ3VW2XfFX4FkQAMYP5hGfwmbjQA1ze3J9Pznujgk`。
Package ID：`0x0c241c19009f6523ede2a8746094d10ac9c28ae88cf5cafbf7922086c3766eab`。

这个代币的 TreasuryCap 的 Object ID 是：

```text
│  ┌──                                                                                                                       │
│  │ ObjectID: 0x22c3e88f8e19c05899a46e10cdb4ae9793d31f59205a3890b8079673a6baeef4                                            │
│  │ ObjectType: 0x2::coin::TreasuryCap<0xc241c19009f6523ede2a8746094d10ac9c28ae88cf5cafbf7922086c3766eab::energy::ENERGY>
```

合约的发布者可以给自己 mint 一些代币：

```shell
sui client call --package 0x0c241c19009f6523ede2a8746094d10ac9c28ae88cf5cafbf7922086c3766eab --module energy --function mint \
--args 0x22c3e88f8e19c05899a46e10cdb4ae9793d31f59205a3890b8079673a6baeef4 '1000000000000000000' \
--gas-budget 19000000
```

记录创建的能量币对象的 ID。比如：`0xba8925cea634dcadebb7b73940955ca27cf5cab6331f9f6bddf2ca864b08a147`。


### 发布 common 合约包

我们在测试网上发布了这个包：

```text
publish common package txn_digest: Bep7DbmaHLQ6DRoXdot23jUB7TSpFrerZRE8MMhwm7Gr
common package_id: 0x8f3814966e7b55382a2040e68d1ce7b0b0df6cb70346be1f63ea2a6d397b1be8
```

记录下这些对象的 ID：

```text
│  │ ObjectID: 0x2a78df4a1327ecbcf68c29b38597365b6d32c3463f3a612babdd55e28e770ee7
│  │ ObjectType: 0x2::package::Publisher

│  │ ObjectID: 0xcf7359ac1d3bedc92d9ae938236e68595ec768c964203bf8cc35619801f3e6e4
│  │ ObjectType: 0x8f3814966e7b55382a2040e68d1ce7b0b0df6cb70346be1f63ea2a6d397b1be8::experience_table::ExperienceTable

│  │ ObjectID: 0x73088501a23080798ef8c37f851df9add29ee2b1d9df2e2fa82da88311506afd
│  │ ObjectType: 0x8f3814966e7b55382a2040e68d1ce7b0b0df6cb70346be1f63ea2a6d397b1be8::item::ItemTable
```


### 发布默认合约包

我们在测试网上发布了这个包：

```text
publish default package txn_digest: J6iEZctCYTvcSmpT8Wm5QGGQvFdhXiJZPdbraYRESkdj
default package_id: 0x05eefe8c17c8880398320157ad015348ac55550c004ae4e522342a986036357d
```

记录下 `0x...::player::PlayerTable` 对象的 ID，比如 `0x5629b69bccf6df237058603c7c28ea6c23db0b260a52e79f0781837b6576e87a`。

并记录以下类型的对象 ID：

```text
"objectType": "0x2::package::Publisher",
"objectId": "0x6b8f1b1e5e8f660aa0bb68a62a49c680bbaa903910d14ca5f5de23b8c89d00a4",

"objectType": "0x05eefe8c17c8880398320157ad015348ac55550c004ae4e522342a986036357d::item_creation::ItemCreationTable",
"objectId": "0x4d0dd994bb6b1aad3ab2037947e5361c1886552eda29774ee0f47520def280f4",

"objectType": "0x05eefe8c17c8880398320157ad015348ac55550c004ae4e522342a986036357d::item_production::ItemProductionTable",
"objectId": "0xebd24b661647357438e49bd7646d6400d5f2eb293340f8af68e31a6804fa5240",
```


### 初始化经验值表

注意添加经验值表行项的函数参数：

* experience_table: &mut experience_table::ExperienceTable,
* level: u16,
* experience: u32,
* difference: u32,

我们在表中添加几行（注意，等级为 0 的第一行虽然没有用到，但是必须添加）：

```shell
sui client call --package 0x8f3814966e7b55382a2040e68d1ce7b0b0df6cb70346be1f63ea2a6d397b1be8 --module experience_table_aggregate --function add_level \
--args 0xcf7359ac1d3bedc92d9ae938236e68595ec768c964203bf8cc35619801f3e6e4 '0' '0' '0' \
--gas-budget 11000000

sui client call --package 0x8f3814966e7b55382a2040e68d1ce7b0b0df6cb70346be1f63ea2a6d397b1be8 --module experience_table_aggregate --function add_level \
--args 0xcf7359ac1d3bedc92d9ae938236e68595ec768c964203bf8cc35619801f3e6e4 '1' '0' '0' \
--gas-budget 11000000

sui client call --package 0x8f3814966e7b55382a2040e68d1ce7b0b0df6cb70346be1f63ea2a6d397b1be8 --module experience_table_aggregate --function add_level \
--args 0xcf7359ac1d3bedc92d9ae938236e68595ec768c964203bf8cc35619801f3e6e4 '2' '83' '83' \
--gas-budget 11000000

sui client call --package 0x8f3814966e7b55382a2040e68d1ce7b0b0df6cb70346be1f63ea2a6d397b1be8 --module experience_table_aggregate --function add_level \
--args 0xcf7359ac1d3bedc92d9ae938236e68595ec768c964203bf8cc35619801f3e6e4 '3' '174' '91' \
--gas-budget 11000000
```

你可以这样查看经验表的初始化结果：

```shell
sui client object 0xcf7359ac1d3bedc92d9ae938236e68595ec768c964203bf8cc35619801f3e6e4
```

### 创建 Item

该函数的参数列表：

* item_id: u32,
* publisher: &sui::package::Publisher,
* name: std::ascii::String,
* required_for_completion: bool,
* sells_for: u32,
* item_table: &mut item::ItemTable,

添加第一条记录，这只是一条“占位符”记录，并不会在生产 item 的时候使用：

```shell
sui client call --package 0x8f3814966e7b55382a2040e68d1ce7b0b0df6cb70346be1f63ea2a6d397b1be8 --module item_aggregate --function create \
--args \
'0' \
0x2a78df4a1327ecbcf68c29b38597365b6d32c3463f3a612babdd55e28e770ee7 \
'"UNUSED_ITEM"'  \
'false' \
'0' \
0x73088501a23080798ef8c37f851df9add29ee2b1d9df2e2fa82da88311506afd \
--gas-budget 11000000
```

添加更多的记录：

```shell
sui client call --package 0x8f3814966e7b55382a2040e68d1ce7b0b0df6cb70346be1f63ea2a6d397b1be8 --module item_aggregate --function create \
--args \
'1' \
0x2a78df4a1327ecbcf68c29b38597365b6d32c3463f3a612babdd55e28e770ee7 \
'"PotatoSeeds"'  \
'false' \
'10' \
0x73088501a23080798ef8c37f851df9add29ee2b1d9df2e2fa82da88311506afd \
--gas-budget 11000000

sui client call --package 0x8f3814966e7b55382a2040e68d1ce7b0b0df6cb70346be1f63ea2a6d397b1be8 --module item_aggregate --function create \
--args \
'2' \
0x2a78df4a1327ecbcf68c29b38597365b6d32c3463f3a612babdd55e28e770ee7 \
'"Potatoes"'  \
'false' \
'80' \
0x73088501a23080798ef8c37f851df9add29ee2b1d9df2e2fa82da88311506afd \
--gas-budget 11000000
```


### 创建玩家

```shell
sui client call --package 0x05eefe8c17c8880398320157ad015348ac55550c004ae4e522342a986036357d --module player_aggregate --function create \
--args '1' '0' 0x5629b69bccf6df237058603c7c28ea6c23db0b260a52e79f0781837b6576e87a \
--gas-budget 11000000
```

记录创建的玩家对象的 ID：

```text
│  │ ObjectID: 0x51d280e198270f7fd746b174691f91950c462b126fa9db853ca7587f9053b466                        │
│  │ ObjectType: 0x5eefe8c17c8880398320157ad015348ac55550c004ae4e522342a986036357d::player::Player       │
```

### 创建 Item 生产配方

该函数的参数：

* item_production_id_skill_type: u8,
* item_production_id_item_id: u32,
* publisher: &sui::package::Publisher,
* production_materials_material_item_id_1: u32,
* production_materials_material_quantity_1: u32,
* production_materials_material_item_id_2: Option<u32>,
* production_materials_material_quantity_2: Option<u32>,
* production_materials_material_item_id_3: Option<u32>,
* production_materials_material_quantity_3: Option<u32>,
* production_materials_material_item_id_4: Option<u32>,
* production_materials_material_quantity_4: Option<u32>,
* production_materials_material_item_id_5: Option<u32>,
* production_materials_material_quantity_5: Option<u32>,
* requirements_level: u16,
* base_quantity: u32,
* base_experience: u32,
* base_creation_time: u64,
* energy_cost: u64,
* success_rate: u16,
* item_production_table: &mut item_production::ItemProductionTable,

我们假设要创建一个“农业”生产配方：种植一份土豆需要 3 个“土豆种子”，等级 1 就可以种植，产出数量为 10，增加经验值为 85，需要 5 秒钟，消耗 100 个单位的能量币，成功率 100%。

执行命令：

```shell
sui client call --package 0x05eefe8c17c8880398320157ad015348ac55550c004ae4e522342a986036357d --module item_production_aggregate --function create \
--args '0' '2' {PUBLISHER_ID} \
'1' '3' '[]' '[]' '[]' '[]' '[]' '[]' '[]' '[]' \
'1' '10' '85' '100' '5' '100' \
0xebd24b661647357438e49bd7646d6400d5f2eb293340f8af68e31a6804fa5240 \
--gas-budget 11000000
```

记录下创建好的生产配方 Object ID：

```text
│  │ ObjectID: 0x7238061fc56e8be0058046b91ba5a149b5b2d1733fa6a49a267e05e2c3faaca8                                                                                              │
│  │ ObjectType: 0x5eefe8c17c8880398320157ad015348ac55550c004ae4e522342a986036357d::item_production::ItemProduction                                                            │
```

### 给玩家空投一些资源（Items）

参数：

* player: &mut player::Player,
* publisher: &sui::package::Publisher,
* item_id: u32,
* quantity: u32,

这里我们假设给玩家空投 100 个土豆种子：


```shell
sui client call --package 0x05eefe8c17c8880398320157ad015348ac55550c004ae4e522342a986036357d --module player_aggregate --function airdrop \
--args 0x51d280e198270f7fd746b174691f91950c462b126fa9db853ca7587f9053b466 \
0x6b8f1b1e5e8f660aa0bb68a62a49c680bbaa903910d14ca5f5de23b8c89d00a4 \
'1' '100' \
--gas-budget 11000000
```


