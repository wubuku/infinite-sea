// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.service;

import com.fasterxml.jackson.databind.ObjectMapper;

import com.github.wubuku.sui.bean.EventId;
import com.github.wubuku.sui.bean.Page;
import com.github.wubuku.sui.bean.PaginatedMoveEvents;
import com.github.wubuku.sui.bean.SuiMoveEventEnvelope;
import com.github.wubuku.sui.bean.PaginatedEvents;
import com.github.wubuku.sui.bean.SuiEventEnvelope;
import com.github.wubuku.sui.bean.SuiEventFilter;
import com.github.wubuku.sui.utils.SuiJsonRpcClient;
import org.dddml.suiinfinitesea.domain.roster.AbstractRosterEvent;
import org.dddml.suiinfinitesea.sui.contract.ContractConstants;
import org.dddml.suiinfinitesea.sui.contract.DomainBeanUtils;
import org.dddml.suiinfinitesea.sui.contract.SuiPackage;
import org.dddml.suiinfinitesea.sui.contract.roster.RosterCreated;
import org.dddml.suiinfinitesea.sui.contract.roster.EnvironmentRosterCreated;
import org.dddml.suiinfinitesea.sui.contract.roster.RosterShipAdded;
import org.dddml.suiinfinitesea.sui.contract.roster.RosterSetSail;
import org.dddml.suiinfinitesea.sui.contract.roster.RosterShipsPositionAdjusted;
import org.dddml.suiinfinitesea.sui.contract.roster.RosterShipTransferred;
import org.dddml.suiinfinitesea.sui.contract.roster.RosterShipInventoryTransferred;
import org.dddml.suiinfinitesea.sui.contract.roster.RosterShipInventoryTakenOut;
import org.dddml.suiinfinitesea.sui.contract.roster.RosterShipInventoryPutIn;
import org.dddml.suiinfinitesea.sui.contract.roster.RosterDeleted;
import org.dddml.suiinfinitesea.sui.contract.repository.RosterEventRepository;
import org.dddml.suiinfinitesea.sui.contract.repository.SuiPackageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class RosterEventService {
    private final ObjectMapper objectMapper = new ObjectMapper();

    public static final java.util.Set<String> DELETION_COMMAND_EVENTS = new java.util.HashSet<>(java.util.Arrays.asList("RosterDeleted"));

    public static boolean isDeletionCommand(String eventType) {
        return DELETION_COMMAND_EVENTS.contains(eventType);
    }

    public static boolean isDeletionCommand(AbstractRosterEvent e) {
        if (isDeletionCommand(e.getEventType())) {
            return true;
        }
        return false;
    }

    @Autowired
    private SuiPackageRepository suiPackageRepository;

    @Autowired
    private SuiJsonRpcClient suiJsonRpcClient;

    @Autowired
    private RosterEventRepository rosterEventRepository;

    @Transactional
    public void updateStatusToProcessed(AbstractRosterEvent event) {
        event.setEventStatus("D");
        rosterEventRepository.save(event);
    }

    @Transactional
    public void pullRosterEvents() {
        String packageId = getDefaultSuiPackageId();
        if (packageId == null) {
            return;
        }
        SuiEventFilter suiEventFilter = new SuiEventFilter.MoveEventModule(packageId, "roster");
        int limit = 10;
        EventId cursor = getRosterEventNextCursor();
        while (true) {
            PaginatedEvents eventPage = suiJsonRpcClient.queryEvents(
                    suiEventFilter,
                    cursor, limit, false);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiEventEnvelope eventEnvelope : eventPage.getData()) {
                    String t = eventEnvelope.getType();
                    AbstractRosterEvent e;
                    if (t.equals(packageId + "::" + ContractConstants.ROSTER_MODULE_ROSTER_CREATED)) {
                        e = DomainBeanUtils.toRosterCreated(objectMapper.convertValue(eventEnvelope.getParsedJson(), RosterCreated.class));
                    } else if (t.equals(packageId + "::" + ContractConstants.ROSTER_MODULE_ENVIRONMENT_ROSTER_CREATED)) {
                        e = DomainBeanUtils.toEnvironmentRosterCreated(objectMapper.convertValue(eventEnvelope.getParsedJson(), EnvironmentRosterCreated.class));
                    } else if (t.equals(packageId + "::" + ContractConstants.ROSTER_MODULE_ROSTER_SHIP_ADDED)) {
                        e = DomainBeanUtils.toRosterShipAdded(objectMapper.convertValue(eventEnvelope.getParsedJson(), RosterShipAdded.class));
                    } else if (t.equals(packageId + "::" + ContractConstants.ROSTER_MODULE_ROSTER_SET_SAIL)) {
                        e = DomainBeanUtils.toRosterSetSail(objectMapper.convertValue(eventEnvelope.getParsedJson(), RosterSetSail.class));
                    } else if (t.equals(packageId + "::" + ContractConstants.ROSTER_MODULE_ROSTER_SHIPS_POSITION_ADJUSTED)) {
                        e = DomainBeanUtils.toRosterShipsPositionAdjusted(objectMapper.convertValue(eventEnvelope.getParsedJson(), RosterShipsPositionAdjusted.class));
                    } else if (t.equals(packageId + "::" + ContractConstants.ROSTER_MODULE_ROSTER_SHIP_TRANSFERRED)) {
                        e = DomainBeanUtils.toRosterShipTransferred(objectMapper.convertValue(eventEnvelope.getParsedJson(), RosterShipTransferred.class));
                    } else if (t.equals(packageId + "::" + ContractConstants.ROSTER_MODULE_ROSTER_SHIP_INVENTORY_TRANSFERRED)) {
                        e = DomainBeanUtils.toRosterShipInventoryTransferred(objectMapper.convertValue(eventEnvelope.getParsedJson(), RosterShipInventoryTransferred.class));
                    } else if (t.equals(packageId + "::" + ContractConstants.ROSTER_MODULE_ROSTER_SHIP_INVENTORY_TAKEN_OUT)) {
                        e = DomainBeanUtils.toRosterShipInventoryTakenOut(objectMapper.convertValue(eventEnvelope.getParsedJson(), RosterShipInventoryTakenOut.class));
                    } else if (t.equals(packageId + "::" + ContractConstants.ROSTER_MODULE_ROSTER_SHIP_INVENTORY_PUT_IN)) {
                        e = DomainBeanUtils.toRosterShipInventoryPutIn(objectMapper.convertValue(eventEnvelope.getParsedJson(), RosterShipInventoryPutIn.class));
                    } else if (t.equals(packageId + "::" + ContractConstants.ROSTER_MODULE_ROSTER_DELETED)) {
                        e = DomainBeanUtils.toRosterDeleted(objectMapper.convertValue(eventEnvelope.getParsedJson(), RosterDeleted.class));
                    } else {
                        e = null;
                    }
                    if (e != null) {
                        DomainBeanUtils.setRosterEventEnvelopeProperties(e, eventEnvelope);
                        saveRosterEvent(e);
                    }
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getRosterEventNextCursor() {
        AbstractRosterEvent lastEvent = rosterEventRepository.findFirstByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveRosterEvent(AbstractRosterEvent event) {
        if (rosterEventRepository.findById(event.getRosterEventId()).isPresent()) {
            return;
        }
        rosterEventRepository.save(event);
    }


    private String getDefaultSuiPackageId() {
        return suiPackageRepository.findById(ContractConstants.DEFAULT_SUI_PACKAGE_NAME)
                .map(SuiPackage::getObjectId).orElse(null);
    }
}
