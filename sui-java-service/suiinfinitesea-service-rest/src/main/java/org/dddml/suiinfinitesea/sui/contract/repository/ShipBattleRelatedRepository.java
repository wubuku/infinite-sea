package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.shipbattle.AbstractShipBattleState;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ShipBattleRelatedRepository extends JpaRepository<AbstractShipBattleState.SimpleShipBattleState, String> {

//    SELECT sp.id AS shipBattleId,sp.initiator AS initiator,sp.winner AS winner,sp.responder AS responder,ir.roster_id_player_id AS playerId,sp.ended_at AS battleEndedAt,
//    p.`owner` AS playerAddress
//    FROM ship_battle sp
//    LEFT JOIN roster ir ON sp.initiator=ir.id
//    LEFT JOIN roster rr ON sp.responder=rr.id
//    LEFT JOIN player p ON ir.roster_id_player_id=p.id
//    WHERE sp.`status` IN (1,2) AND rr.environment_owned IS TRUE
//    AND sp.ended_at BETWEEN :startAt AND :endAt
//    AND p.`owner`=:suiSender

    @Query(value = "SELECT sp.id AS shipBattleId,sp.initiator AS initiator,sp.winner AS winner,sp.responder AS responder,ir.roster_id_player_id AS playerId,sp.ended_at AS battleEndedAt,\n" +
            "p.`owner` AS playerAddress\n" +
            "    FROM ship_battle sp\n" +
            "    LEFT JOIN roster ir ON sp.initiator=ir.id\n" +
            "    LEFT JOIN roster rr ON sp.responder=rr.id\n" +
            "    LEFT JOIN player p ON ir.roster_id_player_id=p.id\n" +
            "    WHERE sp.`status` IN (1,2) AND rr.environment_owned IS TRUE\n" +
            "    AND sp.ended_at BETWEEN :startAt AND :endAt\n" +
            "    AND p.`owner`=:suiSender", nativeQuery = true)
    List<PlayerVsEnvironment> getPlayerVsEnvironmentEvents(@Param("startAt") Long startAt,
                                                           @Param("endAt") Long endAt,
                                                           @Param("suiSender") String suiSender);


//    SELECT sp.id AS shipBattleId,sp.initiator AS initiator,
//    sp.winner AS winner,sp.responder AS responder,
//    ir.roster_id_player_id AS initiatorPlayerId,
//    rr.roster_id_player_id AS responderPlayerId,
//    p1.`owner` AS initiatorSenderAddress,
//    p2.`owner` AS responderSenderAddress,
//    sp.ended_at AS battleEndedAt
//    FROM ship_battle sp
//    LEFT JOIN roster ir ON sp.initiator=ir.id
//    LEFT JOIN roster rr ON sp.responder=rr.id
//    LEFT JOIN player p1 ON ir.roster_id_player_id=p1.id
//    LEFT JOIN player p2 ON rr.roster_id_player_id=p2.id
//    WHERE sp.`status` IN (1,2) AND rr.environment_owned IS false
//    AND sp.ended_at BETWEEN :startAt AND :endAt
//    AND (p1.`owner`=:suiSender OR p2.`owner` = :suiSender)
    @Query(value = "SELECT sp.id AS shipBattleId,sp.initiator AS initiator,\n" +
            "    sp.winner AS winner,sp.responder AS responder,\n" +
            "    ir.roster_id_player_id AS initiatorPlayerId,\n" +
            "    rr.roster_id_player_id AS responderPlayerId,\n" +
            "    p1.`owner` AS initiatorSenderAddress,\n" +
            "    p2.`owner` AS responderSenderAddress,\n" +
            "    sp.ended_at AS battleEndedAt\n" +
            "    FROM ship_battle sp\n" +
            "    LEFT JOIN roster ir ON sp.initiator=ir.id\n" +
            "    LEFT JOIN roster rr ON sp.responder=rr.id\n" +
            "    LEFT JOIN player p1 ON ir.roster_id_player_id=p1.id\n" +
            "    LEFT JOIN player p2 ON rr.roster_id_player_id=p2.id\n" +
            "    WHERE sp.`status` IN (1,2) AND rr.environment_owned IS false\n" +
            "    AND sp.ended_at BETWEEN :startAt AND :endAt\n" +
            "    AND (p1.`owner`=:suiSender OR p2.`owner` = :suiSender)", nativeQuery = true)
    List<PlayerVsPlayer> getPlayerVsPlayerEvents(@Param("startAt") Long startAt,
                                                 @Param("endAt") Long endAt,
                                                 @Param("suiSender") String suiSender);
}
