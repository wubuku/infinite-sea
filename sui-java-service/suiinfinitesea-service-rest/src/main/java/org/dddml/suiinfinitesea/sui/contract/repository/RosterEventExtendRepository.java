package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.roster.AbstractRosterEvent;
import org.dddml.suiinfinitesea.domain.roster.RosterEventId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

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
            //"LEFT JOIN player p ON re.roster_id_player_id=p.id " +
            "WHERE JSON_EXTRACT(re.dynamic_properties, '$.toRosterId.sequenceNumber') = 1 " +
            "  AND re.sui_sender =:senderAddress " +
            "  AND re.event_type='RosterShipTransferred'", nativeQuery = true)
    Integer getAddedToRoster1ShipQuantity(@Param("senderAddress") String senderAddress);

    /*
    SELECT re.sui_sender,
       COUNT(re.sui_sender)
FROM roster_event re
WHERE re.event_type='RosterShipTransferred'
  AND JSON_EXTRACT(re.dynamic_properties, '$.toRosterId.sequenceNumber') = 1
  AND re.sui_sender IN('0x3c9ebfe1031c8aac5fe99da5759d03260e424db4f6481a6a5effbb1ecfad764d',
                       '0x793f2c4fdd706ce2ac99b0d7c931bccec102e4b9c69565e60a4211ce759753f5',
                       '0x22946c7aa7d3175b79969d7d71c8196de26392f87bac7285b16b72bc2f909867',
                       '0xf94d322ddf060d4dc9a9bee56d61ed119f39e17b5a1098d62254a10e37a86cf9')
GROUP BY re.sui_sender,
         re.event_type
     */
    @Query(value = "SELECT re.sui_sender as address,COUNT(re.sui_sender) as count " +
            "FROM roster_event re " +
            "WHERE re.event_type='RosterShipTransferred' " +
            "  AND JSON_EXTRACT(re.dynamic_properties, '$.toRosterId.sequenceNumber') = 1 " +
            "  AND re.sui_sender IN(:suiSenderAddresses) " +
            "GROUP BY re.sui_sender,re.event_type", nativeQuery = true)
    List<AddressCount> batchGetAddedToRoster1ShipQuantity(@Param("suiSenderAddresses") List<String> suiSenderAddresses);


    /**
     * 指定钱包地址的玩家调整船的顺序次数
     *
     * @param senderAddress
     * @return
     */
    @Query(value = "SELECT COUNT(*) " +
            "FROM roster_event re " +
            "WHERE re.sui_sender=:senderAddress " +
            "  AND re.event_type='RosterShipsPositionAdjusted'", nativeQuery = true)
    Integer getArrangedShipOrderTimes(@Param("senderAddress") String senderAddress);


    /**
     * 批量指定钱包地址的玩家调整船的顺序次数
     *
     * @param suiSenderAddresses
     * @return
     */
    @Query(value = "SELECT re.sui_sender as address,COUNT(1) as count " +
            "FROM roster_event re " +
            "  where re.event_type='RosterShipsPositionAdjusted'" +
            "  AND re.sui_sender IN(:suiSenderAddresses) " +
            "GROUP BY re.sui_sender,re.event_type", nativeQuery = true)
    List<AddressCount> batchGetArrangedShipOrderTimes(@Param("suiSenderAddresses") List<String> suiSenderAddresses);


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

    /**
     * 批量指定钱包地址的玩家航行次数
     *
     * @param suiSenderAddresses
     * @return
     */
    @Query(value = "SELECT re.sui_sender as address,COUNT(1) as count " +
            "FROM roster_event re " +
            "  where re.event_type='RosterSetSail'" +
            "  AND re.sui_sender IN(:suiSenderAddresses) " +
            "GROUP BY re.sui_sender,re.event_type", nativeQuery = true)
    List<AddressCount> batchGetRosterSetSailTimes(@Param("suiSenderAddresses") List<String> suiSenderAddresses);


    /**
     * 指定时间范围内，指定玩家航行总时间
     *
     * @param startAt
     * @param endAt
     * @param suiSender
     * @return
     */
    @Query(value = "SELECT SUM(JSON_UNQUOTE(dynamic_properties->'$.sailDuration')) AS total_sail_duration " +
            "FROM roster_event WHERE " +
            "    sui_sender = :suiSender " +
            "    AND sui_timestamp BETWEEN :startAt AND :endAt " +
            "    AND event_type = 'RosterSetSail'", nativeQuery = true)
    Integer getRostersSailedTime(@Param("startAt") Long startAt,
                                 @Param("endAt") Long endAt,
                                 @Param("suiSender") String suiSender);


    @Query(value = "SELECT sui_sender as address,SUM(JSON_UNQUOTE(dynamic_properties->'$.sailDuration')) AS count " +
            "FROM roster_event WHERE " +
            "    sui_sender IN (:suiSenderAddresses) " +
            "    AND sui_timestamp BETWEEN :startAt AND :endAt " +
            "    AND event_type = 'RosterSetSail' " +
            "GROUP BY sui_sender", nativeQuery = true)
    List<AddressCount> batchGetRostersSailedTime(@Param("startAt") Long startAt,
                                                 @Param("endAt") Long endAt,
                                                 @Param("suiSenderAddresses") List<String> suiSenderAddresses);


    @Query(value = "SELECT sui_sender " +
            "FROM roster_event " +
            "WHERE sui_timestamp BETWEEN :startAt AND :endAt " +
            "  AND event_type = 'RosterSetSail' " +
            "GROUP BY sui_sender " +
            "HAVING SUM(JSON_UNQUOTE(dynamic_properties->'$.sailDuration')) > :sailedTime", nativeQuery = true)
    List<String> getSenderAddressesWithSailDurationExceeding(@Param("startAt") Long startAt,
                                                             @Param("endAt") Long endAt,
                                                             @Param("sailedTime") Integer sailedTime);
}
