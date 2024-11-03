package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.shipbattle.AbstractShipBattleEvent;
import org.dddml.suiinfinitesea.domain.shipbattle.ShipBattleEventId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface ShipBattleEventExtendRepository extends JpaRepository<AbstractShipBattleEvent, ShipBattleEventId> {
    /**
     * 查找时间状态为D的，时间类型为 eventType 的记录
     * @param eventType
     * @return
     */
    @Query(value = "select * from ship_battle_event where event_status='D' and event_type=:eventType", nativeQuery = true)
    @Transactional // <- Don't delete this, it's intentional
    List<AbstractShipBattleEvent> getByStatusEqualDAndEventType(@Param("eventType") String eventType);



    @Query(value = "select * from ship_battle_event " +
            " where event_status='D' and event_type in (:eventTypes)",
            nativeQuery = true)
    @Transactional // <- Don't delete this, it's intentional
    List<AbstractShipBattleEvent> getByStatusEqualDAndEventTypeIn(@Param("eventTypes") List<String> eventTypes);

    /*
       number of resources that are burned through battle
   */
    @Query(value = "SELECT ROUND(SUM(quantity)/4) AS total_quantity\n" +
            "FROM ship_battle_event\n" +
            "JOIN JSON_TABLE(dynamic_properties, '$.loot[*]' \n" +
            "    COLUMNS (\n" +
            "        quantity INT PATH '$.quantity'\n" +
            "    )\n" +
            ") AS loot_items\n" +
            "WHERE event_type = 'ShipBattleLootTaken'", nativeQuery = true)
    Long numberOfBurnedResources();
}
