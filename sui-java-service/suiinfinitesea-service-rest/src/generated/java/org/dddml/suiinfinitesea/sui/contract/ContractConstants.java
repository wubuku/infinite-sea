// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract;

public class ContractConstants {
    public static final String NFT_SUI_PACKAGE_NAME = "NFT_SUI_PACKAGE";
    public static final String COMMON_SUI_PACKAGE_NAME = "COMMON_SUI_PACKAGE";
    public static final String DEFAULT_SUI_PACKAGE_NAME = "DEFAULT_SUI_PACKAGE";

    public static final String AVATAR_CHANGE_MODULE_AVATAR_CHANGE_TABLE = "avatar_change::AvatarChangeTable";

    public static final String SKILL_PROCESS_MODULE_SKILL_PROCESS_TABLE = "skill_process::SkillProcessTable";

    public static final String ROSTER_MODULE_ROSTER_TABLE = "roster::RosterTable";

    public static final String ITEM_MODULE_ITEM_TABLE = "item::ItemTable";

    public static final String ITEM_CREATION_MODULE_ITEM_CREATION_TABLE = "item_creation::ItemCreationTable";

    public static final String ITEM_PRODUCTION_MODULE_ITEM_PRODUCTION_TABLE = "item_production::ItemProductionTable";

    public static final String AVATAR_MODULE_AVATAR_MINTED = "avatar::AvatarMinted";

    public static final String AVATAR_MODULE_AVATAR_UPDATED = "avatar::AvatarUpdated";

    public static final String AVATAR_MODULE_AVATAR_BURNED = "avatar::AvatarBurned";

    public static final String AVATAR_MODULE_AVATAR_WHITELIST_MINTED = "avatar::AvatarWhitelistMinted";

    public static final String AVATAR_CHANGE_MODULE_AVATAR_CHANGE_CREATED = "avatar_change::AvatarChangeCreated";

    public static final String AVATAR_CHANGE_MODULE_AVATAR_CHANGE_UPDATED = "avatar_change::AvatarChangeUpdated";

    public static final String AVATAR_CHANGE_MODULE_AVATAR_CHANGE_DELETED = "avatar_change::AvatarChangeDeleted";

    public static final String SKILL_PROCESS_MODULE_SKILL_PROCESS_CREATED = "skill_process::SkillProcessCreated";

    public static final String SKILL_PROCESS_MODULE_PRODUCTION_PROCESS_STARTED = "skill_process::ProductionProcessStarted";

    public static final String SKILL_PROCESS_MODULE_PRODUCTION_PROCESS_COMPLETED = "skill_process::ProductionProcessCompleted";

    public static final String SKILL_PROCESS_MODULE_SHIP_PRODUCTION_PROCESS_STARTED = "skill_process::ShipProductionProcessStarted";

    public static final String SKILL_PROCESS_MODULE_SHIP_PRODUCTION_PROCESS_COMPLETED = "skill_process::ShipProductionProcessCompleted";

    public static final String SKILL_PROCESS_MODULE_CREATION_PROCESS_STARTED = "skill_process::CreationProcessStarted";

    public static final String SKILL_PROCESS_MODULE_CREATION_PROCESS_COMPLETED = "skill_process::CreationProcessCompleted";

    public static final String SHIP_MODULE_SHIP_CREATED = "ship::ShipCreated";

    public static final String ROSTER_MODULE_ROSTER_CREATED = "roster::RosterCreated";

    public static final String ROSTER_MODULE_ENVIRONMENT_ROSTER_CREATED = "roster::EnvironmentRosterCreated";

    public static final String ROSTER_MODULE_ROSTER_SHIP_ADDED = "roster::RosterShipAdded";

    public static final String ROSTER_MODULE_ROSTER_SET_SAIL = "roster::RosterSetSail";

    public static final String ROSTER_MODULE_ROSTER_LOCATION_UPDATED = "roster::RosterLocationUpdated";

    public static final String ROSTER_MODULE_ROSTER_SHIPS_POSITION_ADJUSTED = "roster::RosterShipsPositionAdjusted";

    public static final String ROSTER_MODULE_ROSTER_SHIP_TRANSFERRED = "roster::RosterShipTransferred";

    public static final String ROSTER_MODULE_ROSTER_SHIP_INVENTORY_TRANSFERRED = "roster::RosterShipInventoryTransferred";

    public static final String ROSTER_MODULE_ROSTER_SHIP_INVENTORY_TAKEN_OUT = "roster::RosterShipInventoryTakenOut";

    public static final String ROSTER_MODULE_ROSTER_SHIP_INVENTORY_PUT_IN = "roster::RosterShipInventoryPutIn";

    public static final String SHIP_BATTLE_MODULE_SHIP_BATTLE_INITIATED = "ship_battle::ShipBattleInitiated";

    public static final String SHIP_BATTLE_MODULE_SHIP_BATTLE_MOVE_MADE = "ship_battle::ShipBattleMoveMade";

    public static final String SHIP_BATTLE_MODULE_SHIP_BATTLE_LOOT_TAKEN = "ship_battle::ShipBattleLootTaken";

    public static final String ITEM_MODULE_ITEM_CREATED = "item::ItemCreated";

    public static final String ITEM_MODULE_ITEM_UPDATED = "item::ItemUpdated";

    public static final String ITEM_CREATION_MODULE_ITEM_CREATION_CREATED = "item_creation::ItemCreationCreated";

    public static final String ITEM_CREATION_MODULE_ITEM_CREATION_UPDATED = "item_creation::ItemCreationUpdated";

    public static final String ITEM_PRODUCTION_MODULE_ITEM_PRODUCTION_CREATED = "item_production::ItemProductionCreated";

    public static final String ITEM_PRODUCTION_MODULE_ITEM_PRODUCTION_UPDATED = "item_production::ItemProductionUpdated";

    public static final String PLAYER_MODULE_PLAYER_CREATED = "player::PlayerCreated";

    public static final String PLAYER_MODULE_ISLAND_CLAIMED = "player::IslandClaimed";

    public static final String PLAYER_MODULE_PLAYER_AIRDROPPED = "player::PlayerAirdropped";

    public static final String WHITELIST_MODULE_INIT_WHITELIST_EVENT = "whitelist::InitWhitelistEvent";

    public static final String WHITELIST_MODULE_WHITELIST_UPDATED = "whitelist::WhitelistUpdated";

    public static final String WHITELIST_MODULE_WHITELIST_ENTRY_ADDED = "whitelist::WhitelistEntryAdded";

    public static final String WHITELIST_MODULE_WHITELIST_ENTRY_UPDATED = "whitelist::WhitelistEntryUpdated";

    public static final String WHITELIST_MODULE_WHITELIST_CLAIMED = "whitelist::WhitelistClaimed";

    public static final String WHITELIST_MODULE_WHITELIST_CREATED = "whitelist::WhitelistCreated";

    public static final String MAP_MODULE_INIT_MAP_EVENT = "map::InitMapEvent";

    public static final String MAP_MODULE_ISLAND_ADDED = "map::IslandAdded";

    public static final String MAP_MODULE_MAP_ISLAND_CLAIMED = "map::MapIslandClaimed";

    public static final String MAP_MODULE_ISLAND_RESOURCES_GATHERED = "map::IslandResourcesGathered";

    public static final String EXPERIENCE_TABLE_MODULE_INIT_EXPERIENCE_TABLE_EVENT = "experience_table::InitExperienceTableEvent";

    public static final String EXPERIENCE_TABLE_MODULE_EXPERIENCE_LEVEL_ADDED = "experience_table::ExperienceLevelAdded";

    public static final String EXPERIENCE_TABLE_MODULE_EXPERIENCE_LEVEL_UPDATED = "experience_table::ExperienceLevelUpdated";


    public static String[] getNftPackageIdGeneratorObjectTypes(String packageId) {
        return new String[]{
                packageId + "::" + AVATAR_CHANGE_MODULE_AVATAR_CHANGE_TABLE,
        };
    }

    public static String[] getCommonPackageIdGeneratorObjectTypes(String packageId) {
        return new String[]{
                packageId + "::" + ITEM_MODULE_ITEM_TABLE,
                packageId + "::" + ITEM_CREATION_MODULE_ITEM_CREATION_TABLE,
                packageId + "::" + ITEM_PRODUCTION_MODULE_ITEM_PRODUCTION_TABLE,
        };
    }

    public static String[] getDefaultPackageIdGeneratorObjectTypes(String packageId) {
        return new String[]{
                packageId + "::" + SKILL_PROCESS_MODULE_SKILL_PROCESS_TABLE,
                packageId + "::" + ROSTER_MODULE_ROSTER_TABLE,
        };
    }
}
