// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.player.*;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.*;

public interface PlayerEventRepository extends JpaRepository<AbstractPlayerEvent, PlayerEventId> {

    List<AbstractPlayerEvent> findByStatusIsNull();

    AbstractPlayerEvent.PlayerCreated findFirstPlayerCreatedByOrderBySuiTimestampDesc();

    AbstractPlayerEvent.PlayerAirdropped findFirstPlayerAirdroppedByOrderBySuiTimestampDesc();

    AbstractPlayerEvent.PlayerItemsDeducted findFirstPlayerItemsDeductedByOrderBySuiTimestampDesc();

    AbstractPlayerEvent.PlayerExperienceAndItemsIncreased findFirstPlayerExperienceAndItemsIncreasedByOrderBySuiTimestampDesc();

}
