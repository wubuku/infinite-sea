// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.taskservice;

import org.dddml.suiinfinitesea.sui.contract.service.ShipBattleEventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Service
public class PullShipBattleEventsTaskService {

    @Autowired
    private ShipBattleEventService shipBattleEventService;

    @Scheduled(fixedDelayString = "${sui.contract.pull-ship-battle-events.ship-battle-initiated.fixed-delay:5000}")
    public void pullShipBattleInitiatedEvents() {
        shipBattleEventService.pullShipBattleInitiatedEvents();
    }

}