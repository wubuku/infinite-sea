// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.taskservice;

import org.dddml.suiinfinitesea.sui.contract.service.ItemProductionEventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Service
public class PullItemProductionEventsTaskService {

    @Autowired
    private ItemProductionEventService itemProductionEventService;

    @Scheduled(fixedDelayString = "${sui.contract.pull-item-production-events.fixed-delay:5000}")
    public void pullItemProductionEvents() {
        itemProductionEventService.pullItemProductionEvents();
    }
}
