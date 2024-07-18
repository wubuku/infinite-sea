package org.dddml.suiinfinitesea.sui.contract.taskservice;

import org.dddml.suiinfinitesea.domain.Coordinates;
import org.dddml.suiinfinitesea.domain.faucetrequested.FaucetRequestedStateRepository;
import org.dddml.suiinfinitesea.domain.roster.RosterStateQueryRepository;
import org.dddml.suiinfinitesea.domain.rosterlocation.RosterLocationState;
import org.dddml.suiinfinitesea.domain.rosterlocation.RosterLocationStateRepository;
import org.dddml.suiinfinitesea.sui.contract.service.FaucetEventService;
import org.dddml.suiinfinitesea.sui.contract.utils.RosterUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;

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
