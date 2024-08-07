// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.service;

import com.github.wubuku.sui.bean.*;
import com.github.wubuku.sui.utils.*;
import org.dddml.suiinfinitesea.domain.map.*;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.sui.contract.DomainBeanUtils;
import org.dddml.suiinfinitesea.sui.contract.Map;
import org.dddml.suiinfinitesea.sui.contract.MapLocation;
import org.dddml.suiinfinitesea.sui.contract.MapLocationDynamicField;

import java.util.*;
import java.math.*;
import java.util.function.*;

public class SuiMapStateRetriever {

    private SuiJsonRpcClient suiJsonRpcClient;

    private Function<String, MapState.MutableMapState> mapStateFactory;
    private BiFunction<MapState, Coordinates, MapLocationState.MutableMapLocationState> mapLocationStateFactory;
    private BiFunction<MapState, String, MapClaimIslandWhitelistItemState.MutableMapClaimIslandWhitelistItemState> mapClaimIslandWhitelistItemStateFactory;

    public SuiMapStateRetriever(SuiJsonRpcClient suiJsonRpcClient,
                                  Function<String, MapState.MutableMapState> mapStateFactory,
                                  BiFunction<MapState, Coordinates, MapLocationState.MutableMapLocationState> mapLocationStateFactory,
                                  BiFunction<MapState, String, MapClaimIslandWhitelistItemState.MutableMapClaimIslandWhitelistItemState> mapClaimIslandWhitelistItemStateFactory
    ) {
        this.suiJsonRpcClient = suiJsonRpcClient;
        this.mapStateFactory = mapStateFactory;
        this.mapLocationStateFactory = mapLocationStateFactory;
        this.mapClaimIslandWhitelistItemStateFactory = mapClaimIslandWhitelistItemStateFactory;
    }

    public MapState retrieveMapState(String objectId) {
        SuiMoveObjectResponse<Map> getObjectDataResponse = suiJsonRpcClient.getMoveObject(
                objectId, new SuiObjectDataOptions(true, true, true, true, true, true, true), Map.class
        );
        if (getObjectDataResponse.getData() == null) {
            return null;
        }
        Map map = getObjectDataResponse.getData().getContent().getFields();
        return toMapState(map);
    }

    private MapState toMapState(Map map) {
        MapState.MutableMapState mapState = mapStateFactory.apply(map.getId().getId());
        mapState.setVersion(map.getVersion());
        mapState.setClaimIslandSetting(map.getClaimIslandSetting());
        mapState.setClaimIslandWhitelist(DomainBeanUtils.toTable(map.getClaimIslandWhitelist()));
        if (map.getLocations() != null) {
            String mapLocationTableId = map.getLocations().getFields().getId().getId();
            List<MapLocation> locations = getMapLocations(mapLocationTableId);
            for (MapLocation i : locations) {
                ((EntityStateCollection.ModifiableEntityStateCollection)mapState.getLocations()).add(toMapLocationState(mapState, i));
            }
        }

        if (map.getClaimIslandWhitelist() != null) {
            String mapClaimIslandWhitelistItemTableId = map.getClaimIslandWhitelist().getFields().getId().getId();
            List<MapClaimIslandWhitelistItemState> mapClaimIslandWhitelistItems = getMapClaimIslandWhitelistItems(mapState, mapClaimIslandWhitelistItemTableId);
            for (MapClaimIslandWhitelistItemState i : mapClaimIslandWhitelistItems) {
                ((EntityStateCollection.ModifiableEntityStateCollection)mapState.getMapClaimIslandWhitelistItems()).add(i);
            }
        }

        return mapState;
    }

    private MapLocationState toMapLocationState(MapState mapState, MapLocation mapLocation) {
        MapLocationState.MutableMapLocationState mapLocationState = mapLocationStateFactory.apply(mapState, DomainBeanUtils.toCoordinates(mapLocation.getCoordinates()));
        mapLocationState.setType(mapLocation.getType());
        mapLocationState.setOccupiedBy(mapLocation.getOccupiedBy());
        mapLocationState.setResources(java.util.Arrays.stream(mapLocation.getResources()).map(x -> DomainBeanUtils.toItemIdQuantityPair(x)).collect(java.util.stream.Collectors.toSet()));
        mapLocationState.setGatheredAt(mapLocation.getGatheredAt());
        return mapLocationState;
    }

    private MapClaimIslandWhitelistItemState toMapClaimIslandWhitelistItemState(MapState mapState, String key, Boolean value) {
        MapClaimIslandWhitelistItemState.MutableMapClaimIslandWhitelistItemState mapClaimIslandWhitelistItemState = mapClaimIslandWhitelistItemStateFactory.apply(mapState, key);
        mapClaimIslandWhitelistItemState.setValue(value);
        return mapClaimIslandWhitelistItemState;
    }

    private List<MapLocation> getMapLocations(String mapLocationTableId) {
        List<MapLocation> mapLocations = new ArrayList<>();
        String cursor = null;
        while (true) {
            DynamicFieldPage<?> mapLocationFieldPage = suiJsonRpcClient.getDynamicFields(mapLocationTableId, cursor, null);
            for (DynamicFieldInfo mapLocationFieldInfo : mapLocationFieldPage.getData()) {
                String fieldObjectId = mapLocationFieldInfo.getObjectId();
                SuiMoveObjectResponse<MapLocationDynamicField> getMapLocationFieldResponse
                        = suiJsonRpcClient.getMoveObject(fieldObjectId, new SuiObjectDataOptions(true, true, true, true, true, true, true), MapLocationDynamicField.class);
                MapLocation mapLocation = getMapLocationFieldResponse
                        .getData().getContent().getFields().getValue().getFields();
                mapLocations.add(mapLocation);
            }
            cursor = mapLocationFieldPage.getNextCursor();
            if (!Page.hasNextPage(mapLocationFieldPage)) {
                break;
            }
        }
        return mapLocations;
    }

    private List<MapClaimIslandWhitelistItemState> getMapClaimIslandWhitelistItems(MapState mapState, String mapClaimIslandWhitelistItemTableId) {
        List<MapClaimIslandWhitelistItemState> mapClaimIslandWhitelistItems = new ArrayList<>();
        String cursor = null;
        while (true) {
            DynamicFieldPage<?> mapClaimIslandWhitelistItemFieldPage = suiJsonRpcClient.getDynamicFields(mapClaimIslandWhitelistItemTableId, cursor, null);
            for (DynamicFieldInfo mapClaimIslandWhitelistItemFieldInfo : mapClaimIslandWhitelistItemFieldPage.getData()) {
                String fieldObjectId = mapClaimIslandWhitelistItemFieldInfo.getObjectId();
                SuiMoveObjectResponse<SimpleDynamicField<String, Boolean>> getMapClaimIslandWhitelistItemFieldResponse
                        = suiJsonRpcClient.getMoveObject(fieldObjectId, new SuiObjectDataOptions(true, true, true, true, true, true, true), new com.fasterxml.jackson.core.type.TypeReference<SuiMoveObjectResponse<SimpleDynamicField<String, Boolean>>>() {});
                String key = getMapClaimIslandWhitelistItemFieldResponse.getData().getContent().getFields().getName();
                Boolean value = getMapClaimIslandWhitelistItemFieldResponse.getData().getContent().getFields().getValue();
                MapClaimIslandWhitelistItemState mapClaimIslandWhitelistItemState = toMapClaimIslandWhitelistItemState(mapState, key, value);
                mapClaimIslandWhitelistItems.add(mapClaimIslandWhitelistItemState);
            }
            cursor = mapClaimIslandWhitelistItemFieldPage.getNextCursor();
            if (!Page.hasNextPage(mapClaimIslandWhitelistItemFieldPage)) {
                break;
            }
        }
        return mapClaimIslandWhitelistItems;
    }

    
}

