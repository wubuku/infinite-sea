package org.dddml.suiinfinitesea.sui.contract.taskservice;

import org.dddml.suiinfinitesea.domain.roster.RosterStateQueryRepository;
import org.dddml.suiinfinitesea.sui.contract.service.SuiRosterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ExtensionUpdateRosterStateTaskService {
    public static final int ROSTER_STATUS_DESTROYED = 3;

    @Autowired
    private SuiRosterService suiRosterService;

    @Autowired
    private RosterStateQueryRepository rosterStateQueryRepository;

    @Scheduled(fixedDelayString = "${sui.contract.update-all-roster-states.fixed-delay:50000}")
    @Transactional
    public void updateAllRosterStates() {
        rosterStateQueryRepository.getAll(0, Integer.MAX_VALUE).forEach(s -> {
            if (s.getStatus() == ROSTER_STATUS_DESTROYED) {
                return;
            }
            String objectId = s.getId_();
            suiRosterService.updateRosterState(objectId);
        });
    }
}
