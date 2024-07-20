package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.RosterId;
import org.dddml.suiinfinitesea.domain.roster.AbstractRosterState;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RosterRepository extends JpaRepository<AbstractRosterState.SimpleRosterState, RosterId> {
}
