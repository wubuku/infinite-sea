// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.service;

import com.github.wubuku.sui.utils.SuiJsonRpcClient;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.domain.map.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.math.*;

@Service
public class SuiMapService {

    @Autowired
    private MapStateRepository mapStateRepository;

    private SuiMapStateRetriever suiMapStateRetriever;

    @Autowired
    public SuiMapService(SuiJsonRpcClient suiJsonRpcClient) {
        this.suiMapStateRetriever = new SuiMapStateRetriever(suiJsonRpcClient,
                id -> {
                    MapState.MutableMapState s = new AbstractMapState.SimpleMapState();
                    s.setId(id);
                    return s;
                },
                (mapState, coordinates) -> (MapLocationState.MutableMapLocationState)
                        ((EntityStateCollection.ModifiableEntityStateCollection<Coordinates, MapLocationState>) mapState.getLocations()).getOrAddDefault(coordinates),
                (mapState, key) -> (MapClaimIslandWhitelistItemState.MutableMapClaimIslandWhitelistItemState)
                        ((EntityStateCollection.ModifiableEntityStateCollection<String, MapClaimIslandWhitelistItemState>) mapState.getMapClaimIslandWhitelistItems()).getOrAddDefault(key)
        );
    }

    @Transactional
    public void updateMapState(String objectId) {
        MapState mapState = suiMapStateRetriever.retrieveMapState(objectId);
        if (mapState == null) {
            return;
        }
        mapStateRepository.merge(mapState);
    }

}

