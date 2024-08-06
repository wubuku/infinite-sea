package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.RosterId;
import org.dddml.suiinfinitesea.domain.roster.AbstractRosterState;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Map;

public interface RosterRepository extends JpaRepository<AbstractRosterState.SimpleRosterState, RosterId> {

    @Query(value = "SELECT * FROM roster WHERE id = :id", nativeQuery = true)
    AbstractRosterState.SimpleRosterState findFirstById(@Param("id") String id);
}
