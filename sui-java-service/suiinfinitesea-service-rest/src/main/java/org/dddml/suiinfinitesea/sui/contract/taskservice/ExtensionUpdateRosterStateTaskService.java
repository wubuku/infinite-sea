package org.dddml.suiinfinitesea.sui.contract.taskservice;

import org.dddml.suiinfinitesea.domain.roster.RosterStateQueryRepository;
import org.dddml.suiinfinitesea.domain.shipbattle.AbstractShipBattleEvent;
import org.dddml.suiinfinitesea.domain.shipbattle.ShipBattleState;
import org.dddml.suiinfinitesea.domain.shipbattle.ShipBattleStateRepository;
import org.dddml.suiinfinitesea.sui.contract.repository.ShipBattleEventExtendRepository;
import org.dddml.suiinfinitesea.sui.contract.repository.ShipBattleEventRepository;
import org.dddml.suiinfinitesea.sui.contract.service.ShipBattleEventService;
import org.dddml.suiinfinitesea.sui.contract.service.SuiRosterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ExtensionUpdateRosterStateTaskService {
    public static final int ROSTER_STATUS_DESTROYED = 3;

    @Autowired
    private SuiRosterService suiRosterService;

    @Autowired
    private ShipBattleEventExtendRepository shipBattleEventExtendRepository;

    @Autowired
    private ShipBattleStateRepository shipBattleStateRepository;

    @Autowired
    private ShipBattleEventRepository shipBattleEventRepository;

//    @Scheduled(fixedDelayString = "${sui.contract.update-all-roster-states.fixed-delay:50000}")
//    @Transactional
//    public void updateAllRosterStates() {
//        rosterStateQueryRepository.getAll(0, Integer.MAX_VALUE).forEach(s -> {
//            if (s.getStatus() == ROSTER_STATUS_DESTROYED) {
//                return;
//            }
//            String objectId = s.getId_();
//            suiRosterService.updateRosterState(objectId);
//        });
//    }

    @Scheduled(fixedDelayString = "${sui.contract.update-all-ship-battle-roster-states.fixed-delay:5000}")
    public void updateAllShipBattleRosterStates() {
        List<String> eventTypes = new ArrayList<>();
        eventTypes.add("ShipBattleInitiated");
        eventTypes.add("ShipBattleMoveMade");
        eventTypes.add("ShipBattleLootTaken");
        List<AbstractShipBattleEvent> shipBattleEvents = shipBattleEventExtendRepository.getByStatusEqualDAndEventTypeIn(eventTypes);
        List<String> processedBattleIds = new ArrayList<>();
        shipBattleEvents.forEach(event -> {
            if (!processedBattleIds.contains(event.getId())) {
                ShipBattleState shipBattleState = shipBattleStateRepository.get(event.getId(), false);
                if (shipBattleState != null) {
                    suiRosterService.updateRosterState(shipBattleState.getInitiator());
                    suiRosterService.updateRosterState(shipBattleState.getResponder());
                }
            }
            updateStatusToProcessedSecondTime(event);
            processedBattleIds.add(event.getId());
        });
    }

    private void updateStatusToProcessedSecondTime(AbstractShipBattleEvent event) {
        event.setEventStatus("E");
        shipBattleEventRepository.save(event);
    }

}
