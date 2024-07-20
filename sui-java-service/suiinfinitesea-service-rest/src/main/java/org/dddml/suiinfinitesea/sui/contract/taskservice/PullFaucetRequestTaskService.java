package org.dddml.suiinfinitesea.sui.contract.taskservice;

import org.dddml.suiinfinitesea.sui.contract.service.FaucetEventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PullFaucetRequestTaskService {

    @Autowired
    private FaucetEventService faucetEventService;


    @Scheduled(fixedDelayString = "${sui.contract.pull-faucet-request.fixed-delay:5000}")
    @Transactional
    public void updateAllRosterLocations() {
        faucetEventService.pullFaucetRequestedEvents();
    }
}
