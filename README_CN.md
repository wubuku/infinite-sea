# README

我们使用 dddappp 这个低代码平台来开发这个游戏。虽然 dddappp 并不是专门为游戏开发设计的，但是它完全可以作为一个“全链游戏引擎”来使用。

使用 dddappp 开发全链游戏令人难以置信地简单。

我们只要先做好需求分析和领域建模，然后编写 DDDML 模型文件，再运行 dddappp 创建工具，生成大部分代码，然后在某些特定地方填充少量的业务逻辑的实现，就可以完成一个全链游戏的开发。

## 需求分析与领域建模

### Items

### Skills

Item（物品）有两种“生产/创造”方式：

* Item Production。需要“原材料”，生产时需要消耗一定数量的原材料（其他 Items，比如从CottonSeeds->Cottons）。
* Item Creation。不需要原材料。

同一种东西（Item），是可能可以通过不同的技能（Skill）获得的。比如你可以通过 “Farming” 技能种植、收获一种农产品，也可以“偷窃”技能获得它。

Skill（技能）要么是生产（Production）型的技能，要么是创造（Creation）型的技能，不会两者都是。比如：

* Farming（农业）是生产型的技能。需要消耗“种子”（原材料 items）。种子可以从市场购买、可以“偷窃”（偷窃是创造型的技能）或者使用其他技能获得。
* Mining（挖矿）和 Woodcutting（伐木）是创造型的技能。
  * 我们需要给玩家对这些创造型技能的使用做一些限制。
  * 严格来说，它不太像生产型技能那样，后者主要是通过设置“生产配方”所需的（可能是多种）原材料 item 和数量来达到对技能的使用限制。
  * 不过，仍然可以将“一种创造型技能的使用配额”抽象为一个特殊的 Item(Id) 和 quantity 的 pair。

### Skill Processes

实体 Skill Process（技能流程）表示执行 Item Production 或 Item Creation 的过程。

#### Item Production 的 Skill Process

执行 Skill Process 生产 Item，对于大多数 Item，生产成果只需要使用“Item ID 和数量”表示就可以了。

但是 Skill Process 还需要有一些用来制造“Item 的独特个体”的方法。

* 在 MVP 版本中，具有“独特个体”的 Item 主要指的是 Ship。所以，我们给 SkillProcess 定义了 StartShipProduction / CompleteShipProduction 方法。
* 方法 StartShipProduction 的参数列表应该包含表示“实际投入的材料数量”的信息，因为它们可以大于 Item Production 中规定的（最少）数量。

[TBD]

### 前后端待确认问题

#### 位置坐标的表示问题

后端建议：

* 合约（后端）的坐标值以 u32（无符号 32 位整数，其最大值为 `4,294,967,295`）表示，因为主流的智能合约语言（包括 Move）一般都没有“有符号整数”的类型。
* 前端如有必要，可以执行坐标变换，可以将合约中存储的 u32 整数坐标值换算为 i32 坐标值（有符号 32 位整数）。
  可以考虑将原始的 u32 坐标值减去 i32 位整数的最大值 `2,147,483,647` ， 得到负数或者正数表示的坐标值。
  即以 u32 坐标值表示的地图的中心点为 `("2,147,483,647", "2,147,483,647")`。
* 不建议在链上以补码的形式在 u32 类型的字段中存储（正 / 负）坐标值，因为这样会明显增加位置计算逻辑的复杂度。

#### 速度的单位转换问题

* 需要明确 Ship 的 speed 值和以 `“坐标单位 / 秒”`的速度值之间的转换关系。
  * 比如 Ship 的 speed 值是 `1`，那么表示它每分钟（60 秒）移动 100 个坐标单位。
* 后端合约中，时间点是以“秒”计量的 Unix 时间。即从 1970 年 1 月 1 日 0 时 0 分 0 秒开始的秒数。

#### 船队的当前位置问题

* 要更新“船队”在链上的位置状态，需要发送交易（消耗 Gas / 产生费用），所以船队的链上状态可能不适宜“实时”更新。
  那么，很多时候船队的“实时位置”可能需要链下计算。这里的链下包括前端（浏览器）链下服务（indexer）。
* 当船队处于航行状态，那么可能需要根据这些属性来计算船队的当前位置：
  * 最后一次更新的坐标；
  * 航行的目标位置坐标；
  * 船队的移动速度；
  * 最后一次更新坐标的时间。
* 链下计算“当前位置”可能会得出这样一个结果：船队已经到达目的地，实际上处于“停泊”状态。
* 当然，链上状态也不能总是不更新，在有机会发送“交易”上链的时候，触发合约的“船队状态更新逻辑”即可。
* 船队位置的链下计算逻辑需要和链上（合约）的计算逻辑保持一致。
  * 虽然最终状态是以“链上状态”为准，但是链下的计算逻辑如果出错可能会导致不好的用户体验。（即：按照链下计算结果，一笔交易所需要的前置条件已经满足，但是在提交到链上执行的时候发生失败。）
  * 链上合约的“当前位置”的计算逻辑见 [direct_route_util.move](./sui-contracts/infinite-sea-common/sources/utils/direct_route_util.move)。
  * 链上合约的船队位置状态的更新逻辑见 [roster_update_location_logic.move](./sui-contracts/infinite-sea/sources/roster_update_location_logic.move)。

#### 事件订阅机制的测试

在 Ship Battle 发生时，前端交互对于实时性的要求可能比较高。（不知每轮 10 秒的出招时间是否足够？）

* 链的状态达到终结性是需要一点时间的；特别是节点的部分查询接口，是依赖（它内部的）“索引服务”实现的，这些接口可能多少会有所延迟。
* 前端最好先做一些测试，通过订阅链上事件的方式，看看是不是可以获得足够快的实时性（不知 Sui TS SDK 是否封装了订阅事件的方法）。

## 编码

### 编写 DDDML 模型文件

模型文件位于目录 `./dddml` 下。

> **Tip**
>
> About DDDML, here is an introductory article: ["Introducing DDDML: The Key to Low-Code Development for Decentralized Applications"](https://github.com/wubuku/Dapp-LCDP-Demo/blob/main/IntroducingDDDML.md).

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

在生成代码后，我们需要填充一些业务逻辑的实现。

你可以看到，在我们这个代码库的源代码中，所有以 `// <autogenerated>` 开头的文件，都是由 dddappp 工具生成的，我们不应该修改它们。这些代码占了整个代码库的绝大部分。

其他需要我们填充业务逻辑的文件，dddappp 工具也帮我们生成了脚手架代码，也就是函数的签名部分，我们只需要填充其中的“函数体”（body）部分。

具体来说，我们主要是在以 `_logic.move` 结尾的文件中填充模型中定义的“实体的方法”的实现。

如果你在领域模型中定义了“领域服务”，那么，还需要在以 `_service.move` 结尾的文件中填充“领域服务”的实现。
一般来说，它们应该是很薄的一层“包装”代码，只是对领域模型中的实体的方法的组合调用，不会包含复杂的业务逻辑。

值得一提的是，链下服务（off-chain service，有时候会被称为 indexer）是 100% 自动生成的。
你甚至一行代码都不需要写，只需要配置一下发布合约的交易摘要，就可以直接使用了。

#### Move 代码中的定义的常量

我们在 Move 代码中定义了一些常量。在下面的代码片段中，部分常量定义所在的模块以及用于获取常量的值的函数名：

```move
//
        // 可以编写脚本来添加岛屿，以及为岛屿随机地生成资源。
        //
        // 添加岛屿时，应该初始化以下资源（在 item_id 模块中定义了返回 Item ID 常量的函数）：
        item_id::resource_type_mining(); // Item Creation 需要的“资源”也抽象为 Item，这是执行挖矿操作所需的资源。
        item_id::resource_type_woodcutting(); // 这是执行伐木操作所需的资源。
        item_id::cotton_seeds(); // 这是种植棉花所需的“原材料”

        //以便用户可以通过这些技能：
        skill_type::mining(); // 这是一个 Item Creation 类型的技能
        skill_type::woodcutting(); // Item Creation Skill
        skill_type::farming(); // 这是一个 Item Production 类型的技能

        //产出造船需要的 Items：
        item_id::copper_ore(); // 铜矿
        item_id::normal_logs(); // 普通原木
        item_id::cottons(); // 棉花
```

## 测试应用

### 发布合约

1. Coin合约
2. Common合约
3. main合约

依次发布以上3个合约会得到以下主要信息：

```JSON
{
  "coin": {
    "TreasuryCap": "0x75ed9440b6abd2bffe6bd353324eec06589a99c82a69c0f2c64d38a59ee2e1a9",
    "PackageId": "0xbaa07a76f347f9026ed03c3739d821ee19fe8703af8111349af021b310f83a32",
    "Digest": "7JtgVwMk3M5bo8ha8zfgXJkuR8LnUzYG5dGq76SrBwYK",
    "EnergyId": "0x0d43be712cae4b1d21aae86f10bf0a366d7fd815fa292c95af6fea8b88561bab"
  },
  "common": {
    "Digest": "3iLbwMdpsauBVkX72XKdKH7eBeLWPeVJ85zygxPF1E3n",
    "ItemTable": "0x84ff7c406df743983b8a80c7054eb6350993f22cb9060609c14b29b240a67a53",
    "ItemCreationTable": "0x8c3f82d1f012176e5b55575d51e65f64835f02fada0ea330ea3fd9919eb221d4",
    "ItemProductionTable": "0xacaf74c821504a8bf0c1fb064dc1d20783b92acff65d4ef19a18b70e26c4b60d",
    "ExperienceTable": "0xad04393d861773508b4770a049c02cad90f1e52dc395d9e6a6aed12f448ff692",
    "PackageId": "0xcbe9c3539c9b6bf871a0135c852e9f1950ce5d5711f36f8ae59a27bfc07bd0dd",
    "Publisher": "0xcdf9df2077ee14f7ca0fc74f8e3cf648e8252b325f69140570cac823107b51a9",
    "ItemProducitonCrafting": "0x6ef3d2b10974936a9d487f513746117d0f9ef5be5fe0e3e6223b893095fad2cf"
  },
  "main": {
    "Digest": "3iNkfZ7QjX7VcoMRX44EVbhpVRzAg4oQ6VkPQ65e9dPH",
    "UpgradeCap": "0x325f5ac2bc9d84bad7e8efee60bf396019b95444fb06b639e5cef1e9602cb663",
    "Publisher": "0x3b125d06c8df3338191eb0ff4c75b5c0d3359e977be1690cf41290179033c406",
    "Map": "0x40c6913fde7c626bd74bedae48b182b15446865ea137c26c7a0d0cf29aa94444",
    "RosterTable": "0x906084f1e0bab301ad34e26534268d68af1778f49d03a462577c369e106abbc2",
    "PackageId": "0xa4b8a816c9a212ae4fd17c0326d25750118c8ce0f7887378b28ab9856e84ff7a",
    "SkillProcessTable": "0xa647fbf8eb67caafeed97750ae7cebd5ffecde9c389486d97527f02704edc042",
    "AdminCap": "0xf54f3864e61a27e5148055a88c4c943be6633d4deff166aca6f4373e4ad58b07",
    "Player": "0x2b761f82d4586e5370684738c5dc5d8be325db58d5a3a6b4432dc3e513f10a2f",
    "SkillProcessCrafting": "0xf5fcf9d0543c11f4010fc0bb86008508c43ca359355388977d51588aab4ecf8f"
  }
}
```

举例说明：

`coin.packageid` 表示 coin 合约包的 Id。

`common.PackageId` 表示 common 合约包的 Id。

`main.Digest` 表示发布 main合约时得到的摘要信息。

`coin.EnergyId` 表示 mint 获得的能量 `ENERGY` 币的 Object ID。

`main.Map` 的值为地图(map)的Id。

### 地图

使用以下 CLI 命令可以得到地图的相关信息

```shell
sui client object {main.map} --json
```

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

发布 `./sui-contracts/infinite-sea-common` 目录下的合约项目包。

记录下输出中的交易摘要，下面的命令我们使用占位符 `{COMMON_PACKAGE_PUBLISH_TRANSACTION_DIGEST}` 来表示它。

记录下输出中的 Package ID，下面的命令使用占位符 `{COMMON_PACKAGE_ID}` 来表示它。

记录下发布交易所创建的这些类型的对象的 ID：

```text
│  │ ObjectID: {COMMON_PACKAGE_PUBLISHER_ID}
│  │ ObjectType: 0x2::package::Publisher

│  │ ObjectID: {EXPERIENCE_TABLE_OBJECT_ID}
│  │ ObjectType: {COMMON_PACKAGE_ID}::experience_table::ExperienceTable

│  │ ObjectID: {ITEM_TABLE_OBJECT_ID}
│  │ ObjectType: {COMMON_PACKAGE_ID}::item::ItemTable

│  │ ObjectID: {ITEM_PRODUCTION_TABLE_OBJECT_ID}
│  │ ObjectType: {COMMON_PACKAGE_ID}::item_production::ItemProductionTable

│  │ ObjectID: {ITEM_CREATION_TABLE_OBJECT_ID}
│  │ ObjectType: {DEFAULT_PACKAGE_ID}::item_creation::ItemCreationTable
```

### 发布 default 合约包

发布 `./sui-contracts/infinite-sea` 目录下的合约项目包。

记录发布该 default 合约项目的交易摘要，下面的命令使用占位符 `{DEFAULT_PACKAGE_PUBLISH_TRANSACTION_DIGEST}` 来表示它。

记录下该项目的包 ID，下面我们使用占位符 `{DEFAULT_PACKAGE_ID}` 来表示它。

并记录以下类型的对象的 ID：

* 类型为 `0x...::player::PlayerTable` 的对象的 ID，下面我们使用占位符 `{PLAYER_ID}` 来表示它。
* 类型为 `0x2::package::Publisher` 的对象的 ID，下面我们使用占位符 `{DEFAULT_PACKAGE_PUBLISHER_ID}` 来表示它。
* 类型为 `{DEFAULT_PACKAGE_ID}::skill_process::SkillProcessTable` 的对象的 ID，下面我们使用占位符 `{SKILL_PROCESS_TABLE_OBJECT_ID}` 来表示它。

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
* publisher: &sui:📦:Publisher,
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
* publisher: &sui:📦:Publisher,
* production_materials_item_id_list: vector<u32>,
* production_materials_item_quantity_list: vector<u32>,
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
'[1]' '[3]' \
'1' '10' '85' '5' '5' '100' \
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

这个方法只有管理员可以使用。参数：

* player: &mut player::Player,
* publisher: &sui:📦:Publisher,
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

接下来，就可以检查执行结果。

先获取玩家拥有的 Items 的 table ID：

```shell
sui client object {PLAYER_ID} --json
```

[TBD]

### 关于 Move Table 或者 ObjectTable 内容的查询

使用 `sui client object {OBJECT_ID}` 命令查询一个对象，如果对象包含类型为 `Table` 或者 `ObjectTable` 类型的字段，
那么这个字段的信息输出类似下面这样：

```text
"items": {
        "type": "0x2::table::Table<{KEY_TYPE}, {VALUE_TYPE}>",
        "fields": {
          "id": {
            "id": "0x600ff5d855b5d9ff63edd9d9215457e1c1f6cbb316dc95999ac0d180c886e197"
          },
          "size": "2"
        }
      },
```

在上面的示例输出中，“表”（table）的 ID 是 `0x600ff5d855b5d9ff63edd9d9215457e1c1f6cbb316dc95999ac0d180c886e197`。
然后我们可以这样获取 table 的“动态字段”（你可以把动态字段理解为表的“行”）——这是个“分页”查询接口：

```shell
curl -X POST \
-H "Content-Type: application/json" \
-d '{"jsonrpc":"2.0","id":1,"method":"suix_getDynamicFields","params":["0x600ff5d855b5d9ff63edd9d9215457e1c1f6cbb316dc95999ac0d180c886e197"]}' \
https://fullnode.testnet.sui.io/
```

如果获取的是 `Table` 类型的“表”，那么，返回的分页内容类似下面这样：

```text
{"jsonrpc":"2.0","result":{"data":[
{"name":{"type":"u32","value":1},"bcsName":"2UzHM","type":"DynamicField","objectType":"0x14ba8a9763d9883be8dcedce946efc25e5cbc80c4b8f09d1dbc89731fa517fb8::player_item::PlayerItem",
"objectId":"0x8655ebf801c0d9f734bc09b9b6aaff781f4d18c66e8ea4e0cb6261315f7b5bee","version":26421773,"digest":"4dCkgDHtD9cbQAz7P9Lveetm7PfSC8DbABfySHYmgTgy"},
{"name":{"type":"u32","value":2},"bcsName":"3xyZh","type":"DynamicField","objectType":"0x14ba8a9763d9883be8dcedce946efc25e5cbc80c4b8f09d1dbc89731fa517fb8::player_item::PlayerItem",
"objectId":"0x970ccbbd1b5670c4f1e13c8a8eafddf53c0a579b158129e961046ee6c321c739","version":26421895,"digest":"4BnmTVdyAgVT8qN7um8h1CXdWpHqjYPQsyMTmYWKaCjr"}
],"nextCursor":"0x970ccbbd1b5670c4f1e13c8a8eafddf53c0a579b158129e961046ee6c321c739","hasNextPage":false},"id":1}
```

返回的分页列表中的元素，`"type":"DynamicField"`，你可以这些元素理解为“动态字段”的“引用”，而不是动态字段的内容的全部。
然后，再像下面这样，通过动态字段的 ID，获取“动态字段”的内容（动态字段也是一个“对象”）：

```shell
sui client object 0x8655ebf801c0d9f734bc09b9b6aaff781f4d18c66e8ea4e0cb6261315f7b5bee

sui client object 0x970ccbbd1b5670c4f1e13c8a8eafddf53c0a579b158129e961046ee6c321c739
```

---

如果获取的是 `ObjectTable` 类型的表，
那么，`suix_getDynamicFields` 方法返回分页列表中的元素，`"type":"DynamicObject"`。

### Test off-chain service

#### Configuring off-chain service

Open the `application-test.yml` file located in the directory `sui-java-service/suiinfinitesea-service-rest/src/main/resources` and set the publishing transaction digests.

After setting, it should look like this:

```yaml
sui:
  contract:
    jsonrpc:
      url: "https://fullnode.testnet.sui.io/"
    package-publish-transactions:
      common: "{COMMON_PACKAGE_PUBLISH_TRANSACTION_DIGEST}"
      default: "{DEFAULT_PACKAGE_PUBLISH_TRANSACTION_DIGEST}"
```

This is the only place where off-chain service need to be configured, and it's that simple.

#### Creating a database for off-chain service

Use a MySQL client to connect to the local MySQL server and execute the following script to create an empty database (assuming the name is `test5`):

```sql
CREATE SCHEMA `test7` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
```

Go to the `sui-java-service` directory and package the Java project:

```shell
mvn package
```

Then, run a command-line tool to initialize the database:

```shell
java -jar ./suiinfinitesea-service-cli/target/suiinfinitesea-service-cli-0.0.1-SNAPSHOT.jar ddl -d "./scripts" -c "jdbc:mysql://127.0.0.1:3306/test7?enabledTLSProtocols=TLSv1.2&characterEncoding=utf8&serverTimezone=GMT%2b0&useLegacyDatetimeCode=false" -u root -p 123456
```

#### Starting off-chain service

In the `sui-java-service` directory, execute the following command to start the off-chain service:

```shell
mvn -pl suiinfinitesea-service-rest -am spring-boot:run
```
