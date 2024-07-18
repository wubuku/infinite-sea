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
}
