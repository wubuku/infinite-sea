package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.ship.AbstractShipState;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface ShipRepository extends JpaRepository<AbstractShipState.SimpleShipState, String> {

    /*
    number of ships that are crafted
     */
    @Query(value = "SELECT COUNT(1) FROM ship", nativeQuery = true)
    Long getShipsCrafted();

}
