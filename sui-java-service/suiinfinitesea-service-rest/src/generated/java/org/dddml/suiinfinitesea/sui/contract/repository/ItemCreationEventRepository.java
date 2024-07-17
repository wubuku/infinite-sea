// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.itemcreation.*;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.*;

public interface ItemCreationEventRepository extends JpaRepository<AbstractItemCreationEvent, ItemCreationEventId> {

    AbstractItemCreationEvent findFirstByEventStatusIsNull();

    List<AbstractItemCreationEvent> findByEventStatusIsNull();

    AbstractItemCreationEvent.ItemCreationCreated findFirstItemCreationCreatedByOrderBySuiTimestampDesc();

    AbstractItemCreationEvent.ItemCreationUpdated findFirstItemCreationUpdatedByOrderBySuiTimestampDesc();

    List<AbstractItemCreationEvent> findBySuiTimestampBetween(Long startSuiTimestamp, Long endSuiTimestamp);
}
