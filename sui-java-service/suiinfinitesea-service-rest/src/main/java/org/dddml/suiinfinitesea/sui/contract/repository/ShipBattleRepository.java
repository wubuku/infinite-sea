package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.shipbattle.AbstractShipBattleState;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ShipBattleRepository extends JpaRepository<AbstractShipBattleState.SimpleShipBattleState, String> {


    @Query(value = "SELECT * FROM ship_battle sb WHERE " +
            "sb.initiator IN (SELECT r.id FROM roster r WHERE r.roster_id_player_id=:playerId) " +
            "OR sb.responder in (SELECT r2.id FROM roster r2 WHERE r2.roster_id_player_id=:playerId) " +
            "order by sb.ended_at desc", nativeQuery = true)
    List<AbstractShipBattleState.SimpleShipBattleState> getShipBattlesByPlayerId(@Param("playerId") String playerId);
}
