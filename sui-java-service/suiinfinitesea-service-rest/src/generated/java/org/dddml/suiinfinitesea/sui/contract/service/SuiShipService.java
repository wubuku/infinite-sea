// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.service;

import com.github.wubuku.sui.utils.SuiJsonRpcClient;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.domain.ship.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.math.*;

@Service
public class SuiShipService {

    @Autowired
    private ShipStateRepository shipStateRepository;

    private SuiShipStateRetriever suiShipStateRetriever;

    @Autowired
    public SuiShipService(SuiJsonRpcClient suiJsonRpcClient) {
        this.suiShipStateRetriever = new SuiShipStateRetriever(suiJsonRpcClient,
                id -> {
                    ShipState.MutableShipState s = new AbstractShipState.SimpleShipState();
                    s.setId(id);
                    return s;
                }
        );
    }

    @Transactional
    public void updateShipState(String objectId) {
        ShipState shipState = suiShipStateRetriever.retrieveShipState(objectId);
        if (shipState == null) {
            return;
        }
        shipStateRepository.merge(shipState);
    }

}
