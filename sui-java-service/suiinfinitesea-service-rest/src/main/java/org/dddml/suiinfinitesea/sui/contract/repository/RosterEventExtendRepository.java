package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.roster.AbstractRosterEvent;
import org.dddml.suiinfinitesea.domain.roster.RosterEventId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface RosterEventExtendRepository extends JpaRepository<AbstractRosterEvent, RosterEventId> {

    /*
    SELECT
    *
FROM
    roster_event re
LEFT JOIN player p
ON re.roster_id_player_id=p.id
WHERE
    JSON_EXTRACT(re.dynamic_properties, '$.toRosterId.sequenceNumber') = 1
    AND p.`owner`='0xf94d322ddf060d4dc9a9bee56d61ed119f39e17b5a1098d62254a10e37a86cf9'
    AND re.event_type='RosterShipTransferred'
     */
    @Query(value = "SELECT COUNT(*) " +
            "FROM roster_event re " +
            "LEFT JOIN player p ON re.roster_id_player_id=p.id " +
            "WHERE JSON_EXTRACT(re.dynamic_properties, '$.toRosterId.sequenceNumber') = 1 " +
            "  AND p.`owner`=:senderAddress " +
            "  AND re.event_type='RosterShipTransferred'", nativeQuery = true)
    Integer getAddedToRoster1ShipQuantity(@Param("senderAddress") String senderAddress);


    /**
     * 指定钱包地址的玩家调整船的顺序次数
     *
     * @param senderAddress
     * @return
     */
    @Query(value = "SELECT COUNT(*) " +
            "FROM roster_event re " +
            "LEFT JOIN player p ON re.roster_id_player_id=p.id " +
            "WHERE p.`owner`=:senderAddress " +
            "  AND re.event_type='RosterShipsPositionAdjusted'", nativeQuery = true)
    Integer getArrangedShipOrderTimes(@Param("senderAddress") String senderAddress);


    /**
     * 指定钱包地址的玩家航行次数
     *
     * @param senderAddress
     * @return
     */
    @Query(value = "SELECT COUNT(*) " +
            "FROM roster_event re " +
            "LEFT JOIN player p ON re.roster_id_player_id=p.id " +
            "WHERE p.`owner`=:senderAddress " +
            "  AND re.event_type='RosterSetSail'", nativeQuery = true)
    Integer getRosterSetSailTimes(@Param("senderAddress") String senderAddress);
}
