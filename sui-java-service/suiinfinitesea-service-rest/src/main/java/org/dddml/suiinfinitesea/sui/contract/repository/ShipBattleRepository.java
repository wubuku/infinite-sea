package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.shipbattle.AbstractShipBattleState;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ShipBattleRepository extends JpaRepository<AbstractShipBattleState.SimpleShipBattleState, String> {


    @Query(value = "SELECT sb.* FROM ship_battle sb " +
            "JOIN roster r1 ON sb.initiator = r1.id " +
            "JOIN roster r2 ON sb.responder = r2.id " +
            "WHERE r1.roster_id_player_id = :playerId " +
            "OR r2.roster_id_player_id = :playerId " +
            "ORDER BY sb.ended_at DESC", nativeQuery = true)
    List<AbstractShipBattleState.SimpleShipBattleState> getShipBattlesByPlayerId(@Param("playerId") String playerId);


    /*
    number of battles
     */
    @Query(value = "SELECT COUNT(1) FROM ship_battle", nativeQuery = true)
    Long numberOfBattles();


    /*
    number of pvp battles
     */
    @Query(value = "SELECT COUNT(1)\n" +
            "FROM ship_battle sb\n" +
            "WHERE sb.initiator IN\n" +
            "    (SELECT r.id\n" +
            "     FROM roster r\n" +
            "     WHERE r.environment_owned=0)\n" +
            "  AND sb.responder IN\n" +
            "    (SELECT r.id\n" +
            "     FROM roster r\n" +
            "     WHERE r.environment_owned=0)", nativeQuery = true)
    Long numberOfPvPBattles();
}


