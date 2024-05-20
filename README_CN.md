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

### 资源(Item)常量

| Item Id    | Name                    | 说明                                    |
| ---------- | ----------------------- | --------------------------------------- |
| 0          | UNUSED_ITEM             | 未使用                                  |
| 2          | CottonSeeds             | 棉花种子                                |
| 102        | Cotton                  | 棉花（由棉花种子种植得到）              |
| 200        | Normal Log              | 木头（砍伐之后成品)                     |
| 301        | CopperOre               | 铜（挖矿之后成品）                      |
| 1000000001 | Ship                    | 船（建造得到）                          |
| 2000000001 | ResourceTypeWoodcutting | 伐木资源(伐木Wooding之后得到 Normal Log |
| 2000000003 | ResourceTypeMining      | 挖矿资源(挖矿Mining之后得到 CooperOre   |

### 技能常量

| 技能        | 常量 | 说明 |
| ----------- | ---- | ---- |
| farming     | 0    | 种植 |
| woodcutting | 1    | 伐木 |
| mining      | 3    | 挖矿 |
| crafing     | 6    | 造船 |

## 测试应用

### 发布合约

1. Coin合约
2. Common合约
3. main合约

依次发布以上3个合约会得到以下主要信息：

```JSON{
"coin": {
    "TreasuryCap": "0x45bef3a9403c1af45551f958022a23c52399a8f9cdd95694097c26966ff2c50b",
    "PackageId": "0xc88d834617796a46ad9076bb7c7929f20e2e4395441d6529b995ee4c6d91e1ab",
    "Digest": "DUzQinWD7TyYK3yVb5AvWeVspKk1m75vyAv9t1huCbtX",
    "EnergyId": "0xcc301d760ca2af0f383cb3cb730337a88c9f86cae47d6700d90ffab4a611e9d7"
  },
  "common": {
    "Digest": "8WUmx5GSp3VLfZG4Ezockmgifkne47Gowxhj3pJ9ztrb",
    "Publisher": "0x53001da8168d99f8733bfa1e88e5367fbddef584d4fbccb823d03c733eb8f183",
    "PackageId": "0x60199eae5d0ae8e867fc64548eb7d01ff08b741d265adacb3f40cda17ec80aec",
    "ExperienceTable": "0x6416b22fc0416eae49b3d6230ec817aec5ff3dcd760f781690e12f4e25fd10d2",
    "ItemCreationTable": "0x837a5d2cb879c8831b9858db20bef8a1bb6cb0112916b2a177331d718907f41e",
    "ItemTable": "0xabcdbb6ad9da21070c50cbd06eba4357d5cd29193a172dd218f5455a9bbbf367",
    "ItemProductionTable": "0xc382590b7e266071fb67337086b9fb9fbb3468397def139172f7b665b8c1c2ff",
    "ItemCreationMining": "0xad1a2084441878b0a77bdaaf451ca41424705d19c25b8bd589e30a3459fea4bb",
    "ItemProductionFarming": "0xfbd287a0196e9a3d5abc975c4c98394aa76c474e448dfd5c7be1e10c10874045",
    "ItemCreationWooding": "0x235588535c23089895f7e023546a55b19f5fce90726eb54b37d44dc352a8f90b",
    "ItemProducitonCrafting": "0xb7f5dc6e57ae0da9b98686f5f27bc18f12d53f74edda3b21e8adefb56997d0ef"
  },
  "main": {
    "Digest": "8jcbCg8pwLC8xq3iBLhRgChu4n12BTpxnHmqgkB6cvqn",
    "UpgradeCap": "0x126788288df9186075311e787a461a40fd3a21760ef664cc65f4ec275e13293c",
    "Publisher": "0x261ddc1e04be8731547d5ec6574c5573677ded3ab3ffba861c0857fa2ea04357",
    "PackageId": "0x336766298e8dee8b9bfa29622adbd07028e121cf04f353a286f111ea412aea2e",
    "RosterTable": "0x60762e7810db62b88ab6332bd4ed38989fea82fa04f479e863907d0cb599822f",
    "SkillProcessTable": "0x672a2e59388b87663762a03372553b6942bc6dcea4cd2ca5a3c752e32207ea97",
    "AdminCap": "0x9bc77a40625e2d53508637325859bdd37304874d5a29d27d079869321250c464",
    "Map": "0xc9bcf6235d0e24a1fbeaa565c0830d203f66122a86acf653ee96c5e8254c22ac",
    "Player": "0x56a4639600c0698a5816da1f60446db563cec76c2a8138f4f696278d5f713bf6",
    "SkillProcessMining": "0x06938825b815245399927b7b9ef0218fc0698639eb5082db101608dfc057a0ee",
    "SkillProcessWooding": "0x12da910316deab3883a19d6de2a316e5557dd7614b7f04c09351f4a9bfa6e4bd",
    "SkillProcessCrafting": "0x520599603c598d94620fb34d0546e68228e3a206a8fe9e2768f99a31aa74f1c6",
    "SkillProcessFarming2": "0xa19ae193efbd03bdc3c9cdb00e5eff06d7f901f14884d6ca0e654edca75b7cb0",
    "SkillProcessFarming1": "0xb54b805d077a7df5ed189a8a9573a3ddffa75db67c119048e6759b07cc996a8b"
  }
}
```

举例说明：

`coin.packageid` 表示 coin 合约包的 Id。

`common.PackageId` 表示 common 合约包的 Id。

`main.Digest` 表示发布 main合约时得到的摘要信息。

`coin.EnergyId` 表示 mint 获得的能量 `ENERGY` 币的 Object ID。

`main.Map` 的值为地图(map)的Id。

### <a id="map"></a>地图

使用以下 CLI 命令可以得到地图的相关信息：
[](https://)

```shell
sui client object {main.map} --json
```

可以得到以下信息：

```JSON
{
  "objectId": "0xf36cfa34890b5f6845f538bdcb678e3822443c9b1f4f700db2a66a127d6d7162",
  "version": "37717652",
  "digest": "DwGg5Go9pTqb5fZXkmGzHKfUgDoTGDHZY8jYFRaGBQDW",
  "type": "0x1f1267f7197c3f118b5d1f147a9ceb9296318f786842ab743715f0645fda30dc::map::Map",
  "owner": {
    "Shared": {
      "initial_shared_version": 37712887
    }
  },
  "previousTransaction": "ErangDWTR3PgbEWDj8b7sy8Guao3No7c3ZFzt3zdioTM",
  "storageRebate": "1907600",
  "content": {
    "dataType": "moveObject",
    "type": "0x1f1267f7197c3f118b5d1f147a9ceb9296318f786842ab743715f0645fda30dc::map::Map",
    "hasPublicTransfer": false,
    "fields": {
      "admin_cap": "0xcc29ec9bf6e72e413f6f699a765f62c84ab028716fb4a2f1333bddb3d26c6cf1",
      "id": {
        "id": "0xf36cfa34890b5f6845f538bdcb678e3822443c9b1f4f700db2a66a127d6d7162"
      },
      "locations": {
        "type": "0x2::table::Table<0x2b853e8306950ffdabe20df1ae5703c27dfb909d53099558113251f8a0d0a596::coordinates::Coordinates, 0x1f1267f7197c3f118b5d1f147a9ceb9296318f786842ab743715f0645fda30dc::map_location::MapLocation>",
        "fields": {
          "id": {
            "id": "0xc64d10079ffcb61c167ad8793a585092939df129f7a284ee5fefebc57fc98dfe"
          },
          "size": "2"
        }
      },
      "schema_version": "0",
      "version": "3"
    }
  }
}
```

我们主要关注其中的 `content.locations`属性部分，该部分表示地图上目前已经添加的岛屿。

使用curl执行以下请求：

```
curl -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1,"method":"suix_getDynamicFields","params":[$content.locaions.fields.id.id]}' https://fullnode.testnet.sui.io/
```

可以获得以下类似信息：

```JSON
{
	"jsonrpc": "2.0",
	"result": {
		"data": [{
			"name": {
				"type": "0x2b853e8306950ffdabe20df1ae5703c27dfb909d53099558113251f8a0d0a596::coordinates::Coordinates",
				"value": {
					"x": 51,
					"y": 51
				}
			},
			"bcsName": "9XmJiC4mP1y",
			"type": "DynamicField",
			"objectType": "0x1f1267f7197c3f118b5d1f147a9ceb9296318f786842ab743715f0645fda30dc::map_location::MapLocation",
			"objectId": "0x5dfb8153dfd0aeea1e1558e0b3f991cac1d8ab5e797627ad4445ce4ce099a692",
			"version": 37717652,
			"digest": "9H5nvaRUXbyULStSPsjUdDn7DXQS1nNFmVqKmRVyoMPn"
		}, {
			"name": {
				"type": "0x2b853e8306950ffdabe20df1ae5703c27dfb909d53099558113251f8a0d0a596::coordinates::Coordinates",
				"value": {
					"x": 50,
					"y": 50
				}
			},
			"bcsName": "9N4dhPDnnU7",
			"type": "DynamicField",
			"objectType": "0x1f1267f7197c3f118b5d1f147a9ceb9296318f786842ab743715f0645fda30dc::map_location::MapLocation",
			"objectId": "0x78573cac493248eaea380c6658b839ad44c7a4e0bd0728d91b51a878edd3b16b",
			"version": 37716508,
			"digest": "BCn7aPsiJ2m935TZKXSbwozAt9U2MBzCrVtw1TVGbmJG"
		}],
		"nextCursor": "0x78573cac493248eaea380c6658b839ad44c7a4e0bd0728d91b51a878edd3b16b",
		"hasNextPage": false
	},
	"id": 1
}
```

表明在地图上中存在两个岛屿，它们的坐标分别是（51,51）和(50,50)。对象类型为：{main.packageId}::map_location::MapLocation，对象标识(id)分别为：0x5dfb8153dfd0aeea1e1558e0b3f991cac1d8ab5e797627ad4445ce4ce099a692 和 0x78573cac493248eaea380c6658b839ad44c7a4e0bd0728d91b51a878edd3b16b。

进一步在控制台执行命令如下：

```
sui client object {mapLocationId} --json
```

可以得到以下格式返回信息：

```json
{
  "objectId": "0x5dfb8153dfd0aeea1e1558e0b3f991cac1d8ab5e797627ad4445ce4ce099a692",
  "version": "37717652",
  "digest": "9H5nvaRUXbyULStSPsjUdDn7DXQS1nNFmVqKmRVyoMPn",
  "type": "0x2::dynamic_field::Field<0x2b853e8306950ffdabe20df1ae5703c27dfb909d53099558113251f8a0d0a596::coordinates::Coordinates, 0x1f1267f7197c3f118b5d1f147a9ceb9296318f786842ab743715f0645fda30dc::map_location::MapLocation>",
  "owner": {
    "ObjectOwner": "0xc64d10079ffcb61c167ad8793a585092939df129f7a284ee5fefebc57fc98dfe"
  },
  "previousTransaction": "ErangDWTR3PgbEWDj8b7sy8Guao3No7c3ZFzt3zdioTM",
  "storageRebate": "2812000",
  "content": {
    "dataType": "moveObject",
    "type": "0x2::dynamic_field::Field<0x2b853e8306950ffdabe20df1ae5703c27dfb909d53099558113251f8a0d0a596::coordinates::Coordinates, 0x1f1267f7197c3f118b5d1f147a9ceb9296318f786842ab743715f0645fda30dc::map_location::MapLocation>",
    "hasPublicTransfer": false,
    "fields": {
      "id": {
        "id": "0x5dfb8153dfd0aeea1e1558e0b3f991cac1d8ab5e797627ad4445ce4ce099a692"
      },
      "name": {
        "type": "0x2b853e8306950ffdabe20df1ae5703c27dfb909d53099558113251f8a0d0a596::coordinates::Coordinates",
        "fields": {
          "x": 51,
          "y": 51
        }
      },
      "value": {
        "type": "0x1f1267f7197c3f118b5d1f147a9ceb9296318f786842ab743715f0645fda30dc::map_location::MapLocation",
        "fields": {
          "coordinates": {
            "type": "0x2b853e8306950ffdabe20df1ae5703c27dfb909d53099558113251f8a0d0a596::coordinates::Coordinates",
            "fields": {
              "x": 51,
              "y": 51
            }
          },
          "gathered_at": "0",
          "occupied_by": null,
          "resources": [
            {
              "type": "0x2b853e8306950ffdabe20df1ae5703c27dfb909d53099558113251f8a0d0a596::item_id_quantity_pair::ItemIdQuantityPair",
              "fields": {
                "item_id": 2,
                "quantity": 200
              }
            },
            {
              "type": "0x2b853e8306950ffdabe20df1ae5703c27dfb909d53099558113251f8a0d0a596::item_id_quantity_pair::ItemIdQuantityPair",
              "fields": {
                "item_id": 102,
                "quantity": 100
              }
            },
            {
              "type": "0x2b853e8306950ffdabe20df1ae5703c27dfb909d53099558113251f8a0d0a596::item_id_quantity_pair::ItemIdQuantityPair",
              "fields": {
                "item_id": 200,
                "quantity": 100
              }
            },
            {
              "type": "0x2b853e8306950ffdabe20df1ae5703c27dfb909d53099558113251f8a0d0a596::item_id_quantity_pair::ItemIdQuantityPair",
              "fields": {
                "item_id": 301,
                "quantity": 100
              }
            },
            {
              "type": "0x2b853e8306950ffdabe20df1ae5703c27dfb909d53099558113251f8a0d0a596::item_id_quantity_pair::ItemIdQuantityPair",
              "fields": {
                "item_id": 2000000001,
                "quantity": 200
              }
            },
            {
              "type": "0x2b853e8306950ffdabe20df1ae5703c27dfb909d53099558113251f8a0d0a596::item_id_quantity_pair::ItemIdQuantityPair",
              "fields": {
                "item_id": 2000000003,
                "quantity": 200
              }
            }
          ],
          "type": 0
        }
      }
    }
  }
}
```

我们把重点放在 `content.value.fields`属性。

其中之 `fileds`表示其坐标位置，`gathered_at`表示上一次收集资源的时间，`occupied_by`表示此岛屿目前被谁占领，如果没有呗占领则为 `null`，否则为玩家(Player)之Id，`resouces`为该岛屿目前所拥有的资源列表。

`resources`中又包含 `fields`属性，其中 `item_id`为资源Id，`item_id:2`表示“棉花种子”,`quantity`为该资源的数量。


### 以下先忽略-----------------------------------

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
