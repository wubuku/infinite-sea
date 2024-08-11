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
    private final ObjectMapper objectMapper = new ObjectMapper();

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
    public void pullMapEvents() {
        String packageId = getMapSuiPackageId();
        if (packageId == null) {
            return;
        }
        SuiEventFilter suiEventFilter = new SuiEventFilter.MoveEventModule(packageId, "map");
        int limit = 10;
        EventId cursor = getMapEventNextCursor();
        while (true) {
            PaginatedEvents eventPage = suiJsonRpcClient.queryEvents(
                    suiEventFilter,
                    cursor, limit, false);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiEventEnvelope eventEnvelope : eventPage.getData()) {
                    String t = eventEnvelope.getType();
                    AbstractMapEvent e;
                    if (t.equals(packageId + "::" + ContractConstants.MAP_MODULE_INIT_MAP_EVENT)) {
                        e = DomainBeanUtils.toInitMapEvent(objectMapper.convertValue(eventEnvelope.getParsedJson(), InitMapEvent.class));
                    } else if (t.equals(packageId + "::" + ContractConstants.MAP_MODULE_ISLAND_ADDED)) {
                        e = DomainBeanUtils.toIslandAdded(objectMapper.convertValue(eventEnvelope.getParsedJson(), IslandAdded.class));
                    } else if (t.equals(packageId + "::" + ContractConstants.MAP_MODULE_MAP_ISLAND_CLAIMED)) {
                        e = DomainBeanUtils.toMapIslandClaimed(objectMapper.convertValue(eventEnvelope.getParsedJson(), MapIslandClaimed.class));
                    } else if (t.equals(packageId + "::" + ContractConstants.MAP_MODULE_ISLAND_RESOURCES_GATHERED)) {
                        e = DomainBeanUtils.toIslandResourcesGathered(objectMapper.convertValue(eventEnvelope.getParsedJson(), IslandResourcesGathered.class));
                    } else if (t.equals(packageId + "::" + ContractConstants.MAP_MODULE_MAP_SETTINGS_UPDATED)) {
                        e = DomainBeanUtils.toMapSettingsUpdated(objectMapper.convertValue(eventEnvelope.getParsedJson(), MapSettingsUpdated.class));
                    } else if (t.equals(packageId + "::" + ContractConstants.MAP_MODULE_WHITELISTED_FOR_CLAIMING_ISLAND)) {
                        e = DomainBeanUtils.toWhitelistedForClaimingIsland(objectMapper.convertValue(eventEnvelope.getParsedJson(), WhitelistedForClaimingIsland.class));
                    } else if (t.equals(packageId + "::" + ContractConstants.MAP_MODULE_UN_WHITELISTED_FOR_CLAIMING_ISLAND)) {
                        e = DomainBeanUtils.toUnWhitelistedForClaimingIsland(objectMapper.convertValue(eventEnvelope.getParsedJson(), UnWhitelistedForClaimingIsland.class));
                    } else {
                        e = null;
                    }
                    if (e != null) {
                        DomainBeanUtils.setMapEventEnvelopeProperties(e, eventEnvelope);
                        saveMapEvent(e);
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

    private EventId getMapEventNextCursor() {
        AbstractMapEvent lastEvent = mapEventRepository.findFirstByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveMapEvent(AbstractMapEvent event) {
        if (mapEventRepository.findById(event.getMapEventId()).isPresent()) {
            return;
        }
        mapEventRepository.save(event);
    }


    private String getMapSuiPackageId() {
        return suiPackageRepository.findById(ContractConstants.MAP_SUI_PACKAGE_NAME)
                .map(SuiPackage::getObjectId).orElse(null);
    }
}
