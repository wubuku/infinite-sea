package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.map.AbstractMapLocationState;
import org.dddml.suiinfinitesea.domain.map.MapLocationId;
import org.dddml.suiinfinitesea.domain.ship.AbstractShipState;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface MapLocationRepository extends JpaRepository<AbstractMapLocationState.SimpleMapLocationState, MapLocationId> {

    /*
    number of unique addresses that claimed island
     */
    @Query(value = "SELECT COUNT(DISTINCT ml.occupied_by) FROM map_location ml WHERE ml.occupied_by IS NOT NULL", nativeQuery = true)
    Long countByOccupiedByIsNotNull();

}
