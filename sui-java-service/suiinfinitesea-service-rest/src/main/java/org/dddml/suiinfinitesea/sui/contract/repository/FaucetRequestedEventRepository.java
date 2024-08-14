package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.faucetrequested.AbstractFaucetRequestedState;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface FaucetRequestedEventRepository extends JpaRepository<AbstractFaucetRequestedState.SimpleFaucetRequestedState, String> {

    @Query(value = "SELECT *\n" +
            "FROM faucet_requested fr\n" +
            "WHERE fr.sui_timestamp BETWEEN :startAt \n" +
            "AND :endAt AND fr.sui_sender =:suiSender", nativeQuery = true)
    List<AbstractFaucetRequestedState.SimpleFaucetRequestedState> getFaucetRequestedEvents(@Param("startAt") Long startAt,
                                                                                           @Param("endAt") Long endAt,
                                                                                           @Param("suiSender") String suiSender);

    @Query(value = "SELECT * " +
            "FROM faucet_requested fr " +
            "WHERE fr.sui_timestamp BETWEEN :startAt " +
            "AND :endAt AND fr.sui_sender in (:suiSenderAddresses)", nativeQuery = true)
    List<AbstractFaucetRequestedState.SimpleFaucetRequestedState> batchFaucetRequestedEvents(@Param("startAt") Long startAt,
                                    @Param("endAt") Long endAt,
                                    @Param("suiSenderAddresses") List<String> suiSenderAddresses);
}
