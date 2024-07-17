package org.dddml.suiinfinitesea.sui.contract.restful.resource;

import org.dddml.suiinfinitesea.domain.shipbattle.AbstractShipBattleState;
import org.dddml.suiinfinitesea.sui.contract.repository.ShipBattleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RequestMapping(path = "ShipBattleHistories", produces = MediaType.APPLICATION_JSON_VALUE)
@RestController
public class ShipBattleHistoryResource {

    @Autowired
    private ShipBattleRepository shipBattleRepository;

    @GetMapping()
    @Transactional(readOnly = true)
    public List<AbstractShipBattleState.SimpleShipBattleState> getShipBattlesByPlayerId(
            @RequestParam(value = "playerId") String playerId
    ) {

        return shipBattleRepository.getShipBattlesByPlayerId(playerId);
//        ShipBattleStateDto.DtoConverter dtoConverter = new ShipBattleStateDto.DtoConverter();
//
//        List<AbstractShipBattleState> shipBattleStates= shipBattleRepository.getShipBattlesByPlayerId(playerId);
//
//        return dtoConverter.toShipBattleStateDtoList(shipBattleStates);
    }
}
