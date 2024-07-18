package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.faucetrequested.AbstractFaucetRequestedState;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface FaucetRequestedEventRepository extends JpaRepository<AbstractFaucetRequestedState.SimpleFaucetRequestedState, String> {
    List<AbstractFaucetRequestedState.SimpleFaucetRequestedState> findBySuiTimestampBetween(Long startSuiTimestamp, Long endSuiTimestamp);
}
