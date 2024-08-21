package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.RosterId;
import org.dddml.suiinfinitesea.domain.roster.AbstractRosterState;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Map;

public interface RosterRepository extends JpaRepository<AbstractRosterState.SimpleRosterState, RosterId> {

    @Query(value = "SELECT * FROM roster WHERE id = :id", nativeQuery = true)
    AbstractRosterState.SimpleRosterState findFirstById(@Param("id") String id);


    @Query(value = "SELECT roster_id_player_id as playerId, roster_id_sequence_number as sequenceNumber, updated_coordinates_x as x,updated_coordinates_y as y FROM roster WHERE environment_owned is true and status<>3 ", nativeQuery = true)
    List<SimpleRoster> getAllEnvironmentRosters();

}
