package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.roster.AbstractRosterShipsItemState;
import org.dddml.suiinfinitesea.domain.roster.RosterShipsItemId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RosterShipsItemRepository
        extends JpaRepository<AbstractRosterShipsItemState.SimpleRosterShipsItemState, RosterShipsItemId> {

    /**
     * SELECT JSON_UNQUOTE(JSON_EXTRACT(i.value, '$.fields.item_id')) AS item_id,
     * JSON_UNQUOTE(JSON_EXTRACT(i.value, '$.fields.quantity')) AS quantity
     * FROM roster_ships_item,
     * JSON_TABLE(roster_ships_item.value, '$.inventory[*]' COLUMNS (VALUE JSON PATH '$')) AS i
     * WHERE key_='0x6d1409875b193129d9cdd2f2c1c299b5c1f21b1074d7adde64e80bf02f822c92';
     */
    @Query(value = "SELECT JSON_UNQUOTE(JSON_EXTRACT(i.value, '$.fields.item_id')) AS itemId," +
            "       JSON_UNQUOTE(JSON_EXTRACT(i.value, '$.fields.quantity')) AS quantity " +
            "FROM roster_ships_item, " +
            "     JSON_TABLE(roster_ships_item.value, '$.inventory[*]' COLUMNS (VALUE JSON PATH '$')) AS i " +
            "WHERE key_=:shipId ", nativeQuery = true)
    List<ItemIdQuantityPair> getShipInventory(@Param("shipId") String shipId);


    /**
     * SELECT JSON_UNQUOTE(JSON_EXTRACT(i.value, '$.fields.item_id')) AS item_id,
     * JSON_UNQUOTE(JSON_EXTRACT(i.value, '$.fields.quantity')) AS quantity
     * FROM roster_ships_item,
     * JSON_TABLE(JSON_EXTRACT(roster_ships_item.value, '$.building_expenses.fields.items'), '$[*]' COLUMNS (VALUE JSON PATH '$')) AS i
     * WHERE key_='0x6d1409875b193129d9cdd2f2c1c299b5c1f21b1074d7adde64e80bf02f822c92';
     */
    @Query(value = "SELECT JSON_UNQUOTE(JSON_EXTRACT(i.value, '$.fields.item_id')) AS itemId," +
            "       JSON_UNQUOTE(JSON_EXTRACT(i.value, '$.fields.quantity')) AS quantity " +
            "FROM roster_ships_item," +
            "     JSON_TABLE(JSON_EXTRACT(roster_ships_item.value, '$.building_expenses.fields.items'), '$[*]' COLUMNS (VALUE JSON PATH '$')) AS i " +
            "WHERE key_=:shipId", nativeQuery = true)
    List<ItemIdQuantityPair> getBuildingExpenses(@Param("shipId") String shipId);
}
