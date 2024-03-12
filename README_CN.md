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

```text
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

记录下这两个对象的 ID：

```text
│  │ ObjectID: 0x2a78df4a1327ecbcf68c29b38597365b6d32c3463f3a612babdd55e28e770ee7
│  │ ObjectType: 0x2::package::Publisher

│  │ ObjectID: 0xcf7359ac1d3bedc92d9ae938236e68595ec768c964203bf8cc35619801f3e6e4
│  │ ObjectType: 0x8f3814966e7b55382a2040e68d1ce7b0b0df6cb70346be1f63ea2a6d397b1be8::experience_table::ExperienceTable
```


### 发布默认合约包

我们在测试网上发布了这个包：

```text
publish default package txn_digest: J6iEZctCYTvcSmpT8Wm5QGGQvFdhXiJZPdbraYRESkdj
default package_id: 0x05eefe8c17c8880398320157ad015348ac55550c004ae4e522342a986036357d
```

### 初始化经验值表







