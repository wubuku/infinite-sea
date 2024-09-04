# Infinite Seas

English | [中文版](./README_CN.md)

We are creating a maritime trading, managing, and battling diplomatic fully on-chain game: [Infinite Seas](https://game.infiniteseas.io/).
we believe the best fully on-chain games should be fun and infinite (define by games that are non-session and infinitely large map) with an open economy design. 
![image](https://hackmd.io/_uploads/H1yiNQVkA.jpg)

## Why open economy?

* blockchain offers a great environment for microtransactions between players. We aim to create a game that players are encouraged to trade game assets with each other just like real world maritime trading between ports and ports. Ports trading are building with our AMM infrastructure. 
* players are required to stake chain native coins to get ownership of islands. Players can make diplomatic treaty with others to join the alliance. Winners take the orignal stakes of the loser stakes. and game continues.
* The game is designed with mmorpg elements in mind. Our goal is to create a world that players want to live in. We have planting, mining, fishing, cooking, crafting, smithing, building for the pve parts, as well as trading, battling, thieving, and sailing for the pvp parts. 
![WechatIMG189-2](https://hackmd.io/_uploads/Hk2vS7V1R.jpg)

## Why infinite game?

* non-session: blockchain as an autonomous backend should be used to create games that are running continuously and in a trustless way. 
* infinitely big map: infinite big map works like cross-sever games in traditional gaming. Infinitely big map is the cornerstone of creating a new-comer friendly open world pvp game. New-comers are able to join games anywhere on the map. they can choose a island coordinates that they feel secure to start the journey. 
![WechatIMG181-2](https://hackmd.io/_uploads/S1P5HmVkC.jpg)

## What types of players fit into our game? 

![image](https://hackmd.io/_uploads/H1qdwXEkC.png)
* achievers, motivated mainly by increasing their skill levels, achieving goals, and collecting craftables. 
* explorers, motivated by exploring the game world and learning how it works. They may be interested in thieving which involves to explore hidden information. 
* socializers, motivated by trading, working with other players, joining alliance, creating treaty
* killers, motivated by competition, victory, domination, and also trolling

## What's fun about our game?

* we believe the fun comes from 4 aspects: inter-player social, backstabbing, hidden information, randomness, and deep game system

* social elements: the core game loop is truly "diplomatic" game, by which we mean one in which negotiation and alliances are vital important during play. Because the infinite map and all the islands are roughly equal resources and power at the start, **no player can reasonably expect to conquer the entire island section alone. To overcome another power, player need an ally**. And because units may support moves by other players, alliances are effective. 

* Backstabbing: The game also supports backstabbing. **Players can break the alliance treaty at any time with a cost.** Thus, gamers can never be certain that, one the next move, the ally will do as he has promised.

* Hidden Information: When the player A arrives on players B island or ships, they can choose from 3 game actions - battle, trade, and thieve. Among the 3 pvp actions, thieving is the most cost efficient way of gaining resources; **thieving records are hidden information; however, if thieving is failed, it will reveal the record and increase aggression.** 

* randomness. The game introduce randomness to enhance the player UX. **The production of finished product has a failure rate. The failure rate can be reduced with more practices of the skills and better equipments.** In the PVP part, **the randomness inherent in the system makes it uncertain**: players might still win against odds, or lose despite them. Consequently, warfare, except when there is a major technological disparity between the opponents, is always tense. **It is implemented with block hash**

* **The depth and variety of the game system make achieving the objectives uncertain**. While information about the economy is exposed, it is often difficult to judge what to build in an island next, what skill sets will develop next. As players gain experience, they learn the ins and outs of the system, but it is still sufficiently complex to be hard to master. 


## The dddappp engine we built

We used dddappp, a low-code platform, to develop this game.
Dddappp is a low-code framework with built-in indexer for general purpose Dapp development.
You can say it is like a game engine which can significantly accelerate our development process. 

All we need to do is do requirements analysis and domain modeling, then write the DDDML model files, 
then run the dddappp builder to generate most of the code, 
and then fill in a small amount of business logic in specific places, 
and we're done with the development of a fully on-chain game.


## Requirements analysis and domain modeling

[TBD]

> **Tip**
>
> You may notice that the [Chinese version](./README_CN.md) of this article is much longer than this English version.
> Because of the developer community of this game, we will prioritize updating the Chinese version.
> If you want more detailed information about the development,
> perhaps you can check out the [Chinese version](./README_CN.md) first using software such as Google Translate.
> Many apologies.


## Programming

### Writing DDDML model files

The model files are located in the directory `. /dddml`.

> **Tip**
>
> About DDDML, here is an introductory article: ["Introducing DDDML: The Key to Low-Code Development for Decentralized Applications"](https://github.com/wubuku/Dapp-LCDP-Demo/blob/main/IntroducingDDDML.md).


### Generating code

In repository root directory, run:

```shell
docker run \
-v .:/myapp \
wubuku/dddappp-sui:master \
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

> **Hint**
>
> Sometimes you may need to remove old containers and images:
>
> ```shell
> docker rm $(docker ps -aq --filter "ancestor=wubuku/dddappp-sui:master")
> docker rmi wubuku/dddappp-sui:master
> ```

### Implementing business logic

After generating the code, we need to fill in some business logic implementation.

As you can see, all the files starting with `// <autogenerated>` in the source code of our repository are generated by the dddappp tool,
and we should not modify them. They make up the majority of the code.

The other files that we need to fill in with business logic are also scaffolded by the dddappp tool, 
i.e., the signatures of the functions, and we only need to fill in the "body" part of them.

Specifically, we mainly fill in the file ending with `_logic.move` with the implementation of the methods of the entities defined in the model.

If you have defined "domain services" in the domain model, 
then you also need to fill in the files ending with `_service.move` with implementations of the "domain services".
In general, they should be a thin layer, 
which is a combination of invocations of the methods of the entities in the domain model and does not contain complex business logic.

It's worth noting that the off-chain service (sometimes called "indexer") is 100% auto-generated.
You don't even need to write a single line of code, 
you just need to configure the digests of transactions that publish the contracts, and you're ready to go.


## Test application

### Test on-chain contract

[TBD]

Refer to [Chinese version](./README_CN.md) for more information.


### Test off-chain service (indexer)

You don't even have to write a single line of code to get an out-of-the-box indexer!

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


### About off-chain services APIs

Our off-chain service pulls the state of objects on chain into an off-chain SQL database to provide query functionality.
Such an off-chain service is sometimes called an indexer.

We can certainly start by using Sui's official API service, see: https://docs.sui.io/references/sui-api

However, there are some application-specific query requirements that Sui's official API service may not be able to fulfill,
so it should be necessary to build your own or use enhanced query or indexer services provided by third parties.

By default, the off-chain services we generate provide some out-of-the-box APIs.
You can read the DDDML model files and then refer to the examples below to infer what APIs are available.

For example, in our project, you can HTTP GET the list of items from the URL like this (assuming that `{BASE_URL}` is `http://localhost:1023/api`):

```text
http://localhost:1023/api/Items
```

You can use query criteria:

```text
http://localhost:1023/api/Items?name=XXX
```

Get the information of an item:

```text
http://localhost:1023/api/Items/{ITEM_ID}
```

#### Query parameters for getting entity lists

Query parameters that can be supported in the request URL for getting a list, including:

* `sort`: The name of the property to be used for sorting. Multiple names can be separated by commas.
  A "-" in front of the name indicates reverse order.
  The query parameter `sort` can appear multiple times, like this: `sort=fisrtName&sort=lastName,desc`.
* `fields`: The names of the fields (properties) to be returned.
  Multiple names can be separated by commas.
* `filter`: The filter to return the result, explained further later (TBD).
* `firstResult`: The ordinal number of the first record returned in the result, starting from `0`.
* `maxResults`: The maximum number of records returned in the result.

#### Getting the entity list's page envelope

We personally don't like page "envelope" 😄, but because some developers requested it,
we support sending a GET request to a URL to get a page envelope for the list:

```url
{BASE_URL}/{Entities}/_page?page={page}
```

Supported paging-related query parameters:

* `page`: Page number, starting from 0.
* `size`: Page size.

For example:

```text
http://localhost:1023/api/Items/_page?page=0&size=10
```

#### Need more query functionality?

Since the off-chain service already pulls the state of the objects on chain to the off-chain SQL database,
we can query the off-chain service's database using any SQL query statement.
It is very easy to encapsulate these SQL query statements into APIs.
If you have such a need, modify the source code and add the APIs you need.


