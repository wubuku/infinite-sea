# README


## 编码

### 编写 DDDML 模型文件


### 生成代码

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

### 实现业务逻辑


## 测试应用

### 发布 coin 合约

能量（`ENERGY`）币的合约项目在 `./sui-contracts/infinite-sea-coin` 目录。

进入目录，发布合约：

```shell
sui client publish --gas-budget 200000000 --skip-dependency-verification --skip-fetch-latest-git-deps
```

记录输出中的合约 Package ID。下面的命令使用占位符 `{COIN_PACKAGE_ID}` 来表示它。

记录输出中的 TreasuryCap 的 Object ID：

```text
│  ┌──
│  │ ObjectID: {ENERGY_COIN_TREASURY_CAP_OBJECT_ID}
│  │ ObjectType: 0x2::coin::TreasuryCap<{COIN_PACKAGE_ID}::energy::ENERGY>
```

合约的发布者可以给自己 mint 一些代币：

```shell
sui client call --package {COIN_PACKAGE_ID} --module energy --function mint \
--args {ENERGY_COIN_TREASURY_CAP_OBJECT_ID} '100000000' \
--gas-budget 19000000
```

记录 mint 获得的能量币的 Object ID。下面的命令使用占位符 `{ENERGY_COIN_OBJECT_ID_1}` 来表示它。


### 发布 common 合约包

发布 `./sui-contracts/infinite-sea-common` 目录下的合约项目包。记录下交易摘要；以及记录下 Package ID，下面的命令使用占位符 `{COMMON_PACKAGE_ID}` 来表示它。

记录下发布交易所创建的这些类型的对象的 ID：

```text
│  │ ObjectID: {COMMON_PACKAGE_PUBLISHER_ID}
│  │ ObjectType: 0x2::package::Publisher

│  │ ObjectID: {EXPERIENCE_TABLE_OBJECT_ID}
│  │ ObjectType: {COMMON_PACKAGE_ID}::experience_table::ExperienceTable

│  │ ObjectID: {ITEM_TABLE_OBJECT_ID}
│  │ ObjectType: {COMMON_PACKAGE_ID}::item::ItemTable

│  │ ObjectID: {ITEM_PRODUCTION_TABLE_OBJECT_ID}"
│  │ ObjectType: {COMMON_PACKAGE_ID}::item_production::ItemProductionTable"
```

记录下类型为 `{DEFAULT_PACKAGE_ID}::item_creation::ItemCreationTable` 的对象的 ID，下面我们使用占位符 `{ITEM_CREATION_TABLE_OBJECT_ID}` 来表示它。


### 发布 default 合约包

发布 `./sui-contracts/infinite-sea` 目录下的合约项目包。 记录该 default 合约项目发布的交易摘要；以及包 ID，下面我们使用占位符 `{DEFAULT_PACKAGE_ID}` 来表示它。

并记录以下类型的对象的 ID：

* 记录下类型为 `0x...::player::PlayerTable` 的对象的 ID，下面我们使用占位符 `{PLAYER_ID}` 来表示它。
* 记录下类型为 `0x2::package::Publisher` 的对象的 ID，下面我们使用占位符 `{DEFAULT_PACKAGE_PUBLISHER_ID}` 来表示它。
* 记录下类型为 `{DEFAULT_PACKAGE_ID}::skill_process::SkillProcessTable` 的对象的 ID，下面我们使用占位符 `{SKILL_PROCESS_TABLE_OBJECT_ID}` 来表示它。


### 初始化经验值表

注意添加经验值表行项的函数参数：

* experience_table: &mut experience_table::ExperienceTable,
* level: u16,
* {COMMON_PACKAGE_PUBLISHER_ID}
* experience: u32,
* difference: u32,

我们在表中添加几行（注意，等级为 0 的第一行虽然没有用到，但是必须添加）：

```shell
sui client call --package {COMMON_PACKAGE_ID} --module experience_table_aggregate --function add_level \
--args {EXPERIENCE_TABLE_OBJECT_ID} {COMMON_PACKAGE_PUBLISHER_ID} '0' '0' '0' \
--gas-budget 11000000

sui client call --package {COMMON_PACKAGE_ID} --module experience_table_aggregate --function add_level \
--args {EXPERIENCE_TABLE_OBJECT_ID} {COMMON_PACKAGE_PUBLISHER_ID} '1' '0' '0' \
--gas-budget 11000000

sui client call --package {COMMON_PACKAGE_ID} --module experience_table_aggregate --function add_level \
--args {EXPERIENCE_TABLE_OBJECT_ID} {COMMON_PACKAGE_PUBLISHER_ID} '2' '83' '83' \
--gas-budget 11000000

sui client call --package {COMMON_PACKAGE_ID} --module experience_table_aggregate --function add_level \
--args {EXPERIENCE_TABLE_OBJECT_ID} '3' '174' '91' \
--gas-budget 11000000
```

你可以这样查看经验表的初始化结果：

```shell
sui client object {EXPERIENCE_TABLE_OBJECT_ID}
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
sui client call --package {COMMON_PACKAGE_ID} --module item_aggregate --function create \
--args \
'0' \
{COMMON_PACKAGE_PUBLISHER_ID} \
'"UNUSED_ITEM"'  \
'false' \
'0' \
{ITEM_TABLE_OBJECT_ID} \
--gas-budget 11000000
```

添加更多的记录：

```shell
sui client call --package {COMMON_PACKAGE_ID} --module item_aggregate --function create \
--args \
'1' \
{COMMON_PACKAGE_PUBLISHER_ID} \
'"PotatoSeeds"'  \
'false' \
'10' \
{ITEM_TABLE_OBJECT_ID} \
--gas-budget 11000000

sui client call --package {COMMON_PACKAGE_ID} --module item_aggregate --function create \
--args \
'2' \
{COMMON_PACKAGE_PUBLISHER_ID} \
'"Potatoes"'  \
'false' \
'80' \
{ITEM_TABLE_OBJECT_ID} \
--gas-budget 11000000
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
sui client call --package {COMMON_PACKAGE_ID} --module item_production_aggregate --function create \
--args '0' '2' {COMMON_PACKAGE_PUBLISHER_ID} \
'1' '3' '[]' '[]' '[]' '[]' '[]' '[]' '[]' '[]' \
'1' '10' '85' '100' '5' '100' \
{ITEM_PRODUCTION_TABLE_OBJECT_ID} \
--gas-budget 11000000
```

记录下创建好的生产配方 Object ID，下面我们以占位符 `{ITEM_PRODUCTION_OBJECT_ID_1}` 来表示它。

```text
│  │ ObjectID: {ITEM_PRODUCTION_OBJECT_ID_1}                                                                                              │
│  │ ObjectType: 0x...::item_production::ItemProduction                                                            │
```

### 创建玩家

```shell
sui client call --package {DEFAULT_PACKAGE_ID} --module player_aggregate --function create \
--gas-budget 11000000
```

记录创建的玩家对象的 ID，下面我们以占位符 `{PLAYER_ID}` 来表示它：

```text
│  │ ObjectID: {PLAYER_ID}
│  │ ObjectType: 0x...::player::Player
```

### 给玩家空投一些资源（Items）

参数：

* player: &mut player::Player,
* publisher: &sui::package::Publisher,
* item_id: u32,
* quantity: u32,

这里我们假设给玩家空投 100 个土豆种子：


```shell
sui client call --package {DEFAULT_PACKAGE_ID} --module player_aggregate --function airdrop \
--args {PLAYER_ID} \
{DEFAULT_PACKAGE_PUBLISHER_ID} \
'1' '100' \
--gas-budget 11000000
```

### 创建一个生产流程

参数：

* skill_process_id_skill_type: u8,
* skill_process_id_player_id: ID,
* player: &Player,
* skill_process_table: &mut skill_process::SkillProcessTable,

执行命令：

```shell
sui client call --package "{DEFAULT_PACKAGE_ID}" --module skill_process_aggregate --function create \
--args '0' {PLAYER_ID} \
{PLAYER_ID} \
"{SKILL_PROCESS_TABLE_OBJECT_ID}" \
--gas-budget 11000000
```

一个示例命令：

```shell
sui client call --package 0x14ba8a9763d9883be8dcedce946efc25e5cbc80c4b8f09d1dbc89731fa517fb8 --module skill_process_aggregate --function create \
--args '0' 0x59e7a3b2d246f7c6852c2f8e953871668db8da387aa551116d1295d223335448 \
0x59e7a3b2d246f7c6852c2f8e953871668db8da387aa551116d1295d223335448 \
0x5689f9e28f3bf359604de4eb85a1c7a55520bd4097b54b42e1acb23c1fc44279 \
--gas-budget 11000000
```

记录下创建好的生产流程的对象 ID，下面我们以占位符 `{SKILL_PROCESS_OBJECT_ID_1}` 来表示它：

```text
│  │ ObjectID: {SKILL_PROCESS_OBJECT_ID_1}
│  │ ObjectType: 0x::skill_process::SkillProcess
```

### 开始生产流程

参数：

* skill_process: &mut SkillProcess,
* player: &mut Player,
* item_production: &ItemProduction,
* clock: &Clock,
* energy: Coin<ENERGY>, 

这样执行命令：

```shell
sui client call --package "{DEFAULT_PACKAGE_ID}" --module skill_process_service --function start_production \
--args "{SKILL_PROCESS_OBJECT_ID_1}" \
"{PLAYER_ID}" \
"{ITEM_PRODUCTION_OBJECT_ID_1}" \
"0x6" \
"{ENERGY_COIN_OBJECT_ID_1}" \
--gas-budget 11000000
```


### 完成生产流程

参数：

* skill_process: &mut skill_process::SkillProcess,
* player: &mut Player,
* item_production: &ItemProduction, 
* experience_table: &ExperienceTable,
* clock: &Clock,

执行：

```shell
sui client call --package "{DEFAULT_PACKAGE_ID}" --module skill_process_aggregate --function complete_production \
--args "{SKILL_PROCESS_OBJECT_ID_1}" \
"{PLAYER_ID}" \
"{ITEM_PRODUCTION_OBJECT_ID_1}" \
"{EXPERIENCE_TABLE_OBJECT_ID}" \
"0x6" \
--gas-budget 11000000 --json > testnet_complete_skill_process.json
```

接下来，我们可以检查执行结果。

先获取玩家拥有的 Items 的 table ID：

```shell
sui client object {PLAYER_ID} --json
```

输出类似：

```text
      "items": {
        "type": "0x2::table::Table<u32, 0x14ba8a9763d9883be8dcedce946efc25e5cbc80c4b8f09d1dbc89731fa517fb8::player_item::PlayerItem>",
        "fields": {
          "id": {
            "id": "0x600ff5d855b5d9ff63edd9d9215457e1c1f6cbb316dc95999ac0d180c886e197"
          },
          "size": "2"
        }
      },
```

获取 table 的“动态字段”信息（你可以把动态字段理解为表的“行”），假设 table Id 是 `0x600ff5d855b5d9ff63edd9d9215457e1c1f6cbb316dc95999ac0d180c886e197`：

```shell
curl -X POST \
-H "Content-Type: application/json" \
-d '{"jsonrpc":"2.0","id":1,"method":"suix_getDynamicFields","params":["0x600ff5d855b5d9ff63edd9d9215457e1c1f6cbb316dc95999ac0d180c886e197"]}' \
https://fullnode.testnet.sui.io/
```

输出类似：

```text
{"jsonrpc":"2.0","result":{"data":[
{"name":{"type":"u32","value":1},"bcsName":"2UzHM","type":"DynamicField","objectType":"0x14ba8a9763d9883be8dcedce946efc25e5cbc80c4b8f09d1dbc89731fa517fb8::player_item::PlayerItem",
"objectId":"0x8655ebf801c0d9f734bc09b9b6aaff781f4d18c66e8ea4e0cb6261315f7b5bee","version":26421773,"digest":"4dCkgDHtD9cbQAz7P9Lveetm7PfSC8DbABfySHYmgTgy"},
{"name":{"type":"u32","value":2},"bcsName":"3xyZh","type":"DynamicField","objectType":"0x14ba8a9763d9883be8dcedce946efc25e5cbc80c4b8f09d1dbc89731fa517fb8::player_item::PlayerItem",
"objectId":"0x970ccbbd1b5670c4f1e13c8a8eafddf53c0a579b158129e961046ee6c321c739","version":26421895,"digest":"4BnmTVdyAgVT8qN7um8h1CXdWpHqjYPQsyMTmYWKaCjr"}
],"nextCursor":"0x970ccbbd1b5670c4f1e13c8a8eafddf53c0a579b158129e961046ee6c321c739","hasNextPage":false},"id":1}
```

通过动态字段的 ID，获取动态字段的内容。示例：

```shell
sui client object 0x8655ebf801c0d9f734bc09b9b6aaff781f4d18c66e8ea4e0cb6261315f7b5bee

sui client object 0x970ccbbd1b5670c4f1e13c8a8eafddf53c0a579b158129e961046ee6c321c739
```

