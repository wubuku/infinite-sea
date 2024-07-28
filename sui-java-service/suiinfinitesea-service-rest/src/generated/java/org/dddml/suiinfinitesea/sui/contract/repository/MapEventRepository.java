// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.map.*;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.*;

public interface MapEventRepository extends JpaRepository<AbstractMapEvent, MapEventId> {

    AbstractMapEvent findFirstByEventStatusIsNull();

    List<AbstractMapEvent> findByEventStatusIsNull();

    AbstractMapEvent.InitMapEvent findFirstInitMapEventByOrderBySuiTimestampDesc();

    AbstractMapEvent.IslandAdded findFirstIslandAddedByOrderBySuiTimestampDesc();

    AbstractMapEvent.MapIslandClaimed findFirstMapIslandClaimedByOrderBySuiTimestampDesc();

    AbstractMapEvent.IslandResourcesGathered findFirstIslandResourcesGatheredByOrderBySuiTimestampDesc();

    AbstractMapEvent.MapSettingsUpdated findFirstMapSettingsUpdatedByOrderBySuiTimestampDesc();

    List<AbstractMapEvent> findBySuiTimestampBetween(Long startSuiTimestamp, Long endSuiTimestamp);
}
