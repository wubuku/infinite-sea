// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.service;

import com.github.wubuku.sui.bean.EventId;
import com.github.wubuku.sui.bean.Page;
import com.github.wubuku.sui.bean.PaginatedMoveEvents;
import com.github.wubuku.sui.bean.SuiMoveEventEnvelope;
import com.github.wubuku.sui.utils.SuiJsonRpcClient;
import org.dddml.suiinfinitesea.domain.map.AbstractMapEvent;
import org.dddml.suiinfinitesea.sui.contract.ContractConstants;
import org.dddml.suiinfinitesea.sui.contract.DomainBeanUtils;
import org.dddml.suiinfinitesea.sui.contract.SuiPackage;
import org.dddml.suiinfinitesea.sui.contract.map.InitMapEvent;
import org.dddml.suiinfinitesea.sui.contract.map.IslandAdded;
import org.dddml.suiinfinitesea.sui.contract.map.MapIslandClaimed;
import org.dddml.suiinfinitesea.sui.contract.map.IslandResourcesGathered;
import org.dddml.suiinfinitesea.sui.contract.map.MapSettingsUpdated;
import org.dddml.suiinfinitesea.sui.contract.map.WhitelistedForClaimingIsland;
import org.dddml.suiinfinitesea.sui.contract.map.UnWhitelistedForClaimingIsland;
import org.dddml.suiinfinitesea.sui.contract.repository.MapEventRepository;
import org.dddml.suiinfinitesea.sui.contract.repository.SuiPackageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MapEventService {

    @Autowired
    private SuiPackageRepository suiPackageRepository;

    @Autowired
    private SuiJsonRpcClient suiJsonRpcClient;

    @Autowired
    private MapEventRepository mapEventRepository;

    @Transactional
    public void updateStatusToProcessed(AbstractMapEvent event) {
        event.setEventStatus("D");
        mapEventRepository.save(event);
    }

    @Transactional
    public void pullInitMapEvents() {
        String packageId = getMapSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getInitMapEventNextCursor();
        while (true) {
            PaginatedMoveEvents<InitMapEvent> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.MAP_MODULE_INIT_MAP_EVENT,
                    cursor, limit, false, InitMapEvent.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<InitMapEvent> eventEnvelope : eventPage.getData()) {
                    saveInitMapEvent(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getInitMapEventNextCursor() {
        AbstractMapEvent lastEvent = mapEventRepository.findFirstInitMapEventByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveInitMapEvent(SuiMoveEventEnvelope<InitMapEvent> eventEnvelope) {
        AbstractMapEvent.InitMapEvent initMapEvent = DomainBeanUtils.toInitMapEvent(eventEnvelope);
        if (mapEventRepository.findById(initMapEvent.getMapEventId()).isPresent()) {
            return;
        }
        mapEventRepository.save(initMapEvent);
    }

    @Transactional
    public void pullIslandAddedEvents() {
        String packageId = getMapSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getIslandAddedEventNextCursor();
        while (true) {
            PaginatedMoveEvents<IslandAdded> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.MAP_MODULE_ISLAND_ADDED,
                    cursor, limit, false, IslandAdded.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<IslandAdded> eventEnvelope : eventPage.getData()) {
                    saveIslandAdded(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getIslandAddedEventNextCursor() {
        AbstractMapEvent lastEvent = mapEventRepository.findFirstIslandAddedByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveIslandAdded(SuiMoveEventEnvelope<IslandAdded> eventEnvelope) {
        AbstractMapEvent.IslandAdded islandAdded = DomainBeanUtils.toIslandAdded(eventEnvelope);
        if (mapEventRepository.findById(islandAdded.getMapEventId()).isPresent()) {
            return;
        }
        mapEventRepository.save(islandAdded);
    }

    @Transactional
    public void pullMapIslandClaimedEvents() {
        String packageId = getMapSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getMapIslandClaimedEventNextCursor();
        while (true) {
            PaginatedMoveEvents<MapIslandClaimed> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.MAP_MODULE_MAP_ISLAND_CLAIMED,
                    cursor, limit, false, MapIslandClaimed.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<MapIslandClaimed> eventEnvelope : eventPage.getData()) {
                    saveMapIslandClaimed(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getMapIslandClaimedEventNextCursor() {
        AbstractMapEvent lastEvent = mapEventRepository.findFirstMapIslandClaimedByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveMapIslandClaimed(SuiMoveEventEnvelope<MapIslandClaimed> eventEnvelope) {
        AbstractMapEvent.MapIslandClaimed mapIslandClaimed = DomainBeanUtils.toMapIslandClaimed(eventEnvelope);
        if (mapEventRepository.findById(mapIslandClaimed.getMapEventId()).isPresent()) {
            return;
        }
        mapEventRepository.save(mapIslandClaimed);
    }

    @Transactional
    public void pullIslandResourcesGatheredEvents() {
        String packageId = getMapSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getIslandResourcesGatheredEventNextCursor();
        while (true) {
            PaginatedMoveEvents<IslandResourcesGathered> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.MAP_MODULE_ISLAND_RESOURCES_GATHERED,
                    cursor, limit, false, IslandResourcesGathered.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<IslandResourcesGathered> eventEnvelope : eventPage.getData()) {
                    saveIslandResourcesGathered(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getIslandResourcesGatheredEventNextCursor() {
        AbstractMapEvent lastEvent = mapEventRepository.findFirstIslandResourcesGatheredByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveIslandResourcesGathered(SuiMoveEventEnvelope<IslandResourcesGathered> eventEnvelope) {
        AbstractMapEvent.IslandResourcesGathered islandResourcesGathered = DomainBeanUtils.toIslandResourcesGathered(eventEnvelope);
        if (mapEventRepository.findById(islandResourcesGathered.getMapEventId()).isPresent()) {
            return;
        }
        mapEventRepository.save(islandResourcesGathered);
    }

    @Transactional
    public void pullMapSettingsUpdatedEvents() {
        String packageId = getMapSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getMapSettingsUpdatedEventNextCursor();
        while (true) {
            PaginatedMoveEvents<MapSettingsUpdated> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.MAP_MODULE_MAP_SETTINGS_UPDATED,
                    cursor, limit, false, MapSettingsUpdated.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<MapSettingsUpdated> eventEnvelope : eventPage.getData()) {
                    saveMapSettingsUpdated(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getMapSettingsUpdatedEventNextCursor() {
        AbstractMapEvent lastEvent = mapEventRepository.findFirstMapSettingsUpdatedByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveMapSettingsUpdated(SuiMoveEventEnvelope<MapSettingsUpdated> eventEnvelope) {
        AbstractMapEvent.MapSettingsUpdated mapSettingsUpdated = DomainBeanUtils.toMapSettingsUpdated(eventEnvelope);
        if (mapEventRepository.findById(mapSettingsUpdated.getMapEventId()).isPresent()) {
            return;
        }
        mapEventRepository.save(mapSettingsUpdated);
    }

    @Transactional
    public void pullWhitelistedForClaimingIslandEvents() {
        String packageId = getMapSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getWhitelistedForClaimingIslandEventNextCursor();
        while (true) {
            PaginatedMoveEvents<WhitelistedForClaimingIsland> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.MAP_MODULE_WHITELISTED_FOR_CLAIMING_ISLAND,
                    cursor, limit, false, WhitelistedForClaimingIsland.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<WhitelistedForClaimingIsland> eventEnvelope : eventPage.getData()) {
                    saveWhitelistedForClaimingIsland(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getWhitelistedForClaimingIslandEventNextCursor() {
        AbstractMapEvent lastEvent = mapEventRepository.findFirstWhitelistedForClaimingIslandByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveWhitelistedForClaimingIsland(SuiMoveEventEnvelope<WhitelistedForClaimingIsland> eventEnvelope) {
        AbstractMapEvent.WhitelistedForClaimingIsland whitelistedForClaimingIsland = DomainBeanUtils.toWhitelistedForClaimingIsland(eventEnvelope);
        if (mapEventRepository.findById(whitelistedForClaimingIsland.getMapEventId()).isPresent()) {
            return;
        }
        mapEventRepository.save(whitelistedForClaimingIsland);
    }

    @Transactional
    public void pullUnWhitelistedForClaimingIslandEvents() {
        String packageId = getMapSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getUnWhitelistedForClaimingIslandEventNextCursor();
        while (true) {
            PaginatedMoveEvents<UnWhitelistedForClaimingIsland> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.MAP_MODULE_UN_WHITELISTED_FOR_CLAIMING_ISLAND,
                    cursor, limit, false, UnWhitelistedForClaimingIsland.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<UnWhitelistedForClaimingIsland> eventEnvelope : eventPage.getData()) {
                    saveUnWhitelistedForClaimingIsland(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getUnWhitelistedForClaimingIslandEventNextCursor() {
        AbstractMapEvent lastEvent = mapEventRepository.findFirstUnWhitelistedForClaimingIslandByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveUnWhitelistedForClaimingIsland(SuiMoveEventEnvelope<UnWhitelistedForClaimingIsland> eventEnvelope) {
        AbstractMapEvent.UnWhitelistedForClaimingIsland unWhitelistedForClaimingIsland = DomainBeanUtils.toUnWhitelistedForClaimingIsland(eventEnvelope);
        if (mapEventRepository.findById(unWhitelistedForClaimingIsland.getMapEventId()).isPresent()) {
            return;
        }
        mapEventRepository.save(unWhitelistedForClaimingIsland);
    }


    private String getMapSuiPackageId() {
        return suiPackageRepository.findById(ContractConstants.MAP_SUI_PACKAGE_NAME)
                .map(SuiPackage::getObjectId).orElse(null);
    }
}
