// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.whitelist.*;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.*;

public interface WhitelistEventRepository extends JpaRepository<AbstractWhitelistEvent, WhitelistEventId> {

    AbstractWhitelistEvent findFirstByEventStatusIsNull();

    List<AbstractWhitelistEvent> findByEventStatusIsNull();

    AbstractWhitelistEvent findFirstByOrderBySuiTimestampDesc();

    AbstractWhitelistEvent.InitWhitelistEvent findFirstInitWhitelistEventByOrderBySuiTimestampDesc();

    AbstractWhitelistEvent.WhitelistUpdated findFirstWhitelistUpdatedByOrderBySuiTimestampDesc();

    AbstractWhitelistEvent.WhitelistEntryAdded findFirstWhitelistEntryAddedByOrderBySuiTimestampDesc();

    AbstractWhitelistEvent.WhitelistEntryUpdated findFirstWhitelistEntryUpdatedByOrderBySuiTimestampDesc();

    AbstractWhitelistEvent.WhitelistClaimed findFirstWhitelistClaimedByOrderBySuiTimestampDesc();

    AbstractWhitelistEvent.WhitelistCreated findFirstWhitelistCreatedByOrderBySuiTimestampDesc();

    List<AbstractWhitelistEvent> findBySuiTimestampBetween(Long startSuiTimestamp, Long endSuiTimestamp);
}
