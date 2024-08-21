// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.roster.*;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.*;

public interface RosterEventRepository extends JpaRepository<AbstractRosterEvent, RosterEventId> {

    AbstractRosterEvent findFirstByEventStatusIsNull();

    List<AbstractRosterEvent> findByEventStatusIsNull();

    AbstractRosterEvent findFirstByOrderBySuiTimestampDesc();

    AbstractRosterEvent.RosterCreated findFirstRosterCreatedByOrderBySuiTimestampDesc();

    AbstractRosterEvent.EnvironmentRosterCreated findFirstEnvironmentRosterCreatedByOrderBySuiTimestampDesc();

    AbstractRosterEvent.RosterShipAdded findFirstRosterShipAddedByOrderBySuiTimestampDesc();

    AbstractRosterEvent.RosterSetSail findFirstRosterSetSailByOrderBySuiTimestampDesc();

    AbstractRosterEvent.RosterShipsPositionAdjusted findFirstRosterShipsPositionAdjustedByOrderBySuiTimestampDesc();

    AbstractRosterEvent.RosterShipTransferred findFirstRosterShipTransferredByOrderBySuiTimestampDesc();

    AbstractRosterEvent.RosterShipInventoryTransferred findFirstRosterShipInventoryTransferredByOrderBySuiTimestampDesc();

    AbstractRosterEvent.RosterShipInventoryTakenOut findFirstRosterShipInventoryTakenOutByOrderBySuiTimestampDesc();

    AbstractRosterEvent.RosterShipInventoryPutIn findFirstRosterShipInventoryPutInByOrderBySuiTimestampDesc();

    AbstractRosterEvent.RosterDeleted findFirstRosterDeletedByOrderBySuiTimestampDesc();

    List<AbstractRosterEvent> findBySuiTimestampBetween(Long startSuiTimestamp, Long endSuiTimestamp);
}
