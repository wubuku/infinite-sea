package org.dddml.suiinfinitesea.sui.contract.restful.resource;

import org.dddml.suiinfinitesea.domain.faucetrequested.AbstractFaucetRequestedState;
import org.dddml.suiinfinitesea.domain.item.AbstractItemEvent;
import org.dddml.suiinfinitesea.domain.skillprocess.AbstractSkillProcessEvent;
import org.dddml.suiinfinitesea.sui.contract.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


@RequestMapping(path = "contractEvents", produces = MediaType.APPLICATION_JSON_VALUE)
@RestController
public class EventResource {
    @Autowired
    private ItemEventRepository itemEventRepository;

    @Autowired
    private ShipProductionEventRepository shipProductionEventRepository;
    @Autowired
    private FaucetRequestedEventRepository faucetRequestedEventRepository;

    @Autowired
    private ShipBattleRelatedRepository shipBattleRelatedRepository;

    @GetMapping(path = "getItemEvents")
    @Transactional(readOnly = true)
    public java.util.List<AbstractItemEvent> getItemEvents(@RequestParam(value = "startSuiTimestamp") Long startSuiTimestamp, @RequestParam(value = "endSuiTimestamp") Long endSuiTimestamp) {
        return itemEventRepository.findBySuiTimestampBetween(startSuiTimestamp, endSuiTimestamp);
    }

    @GetMapping(path = "getFaucetRequestedEvents")
    @Transactional(readOnly = true)
    public java.util.List<AbstractFaucetRequestedState.SimpleFaucetRequestedState> getFaucetRequestedEvents(@RequestParam(value = "startAt") Long startAt, @RequestParam(value = "endedAt") Long endedAt, @RequestParam(value = "senderAddress") String senderAddress) {
        return faucetRequestedEventRepository.getFaucetRequestedEvents(startAt, endedAt, senderAddress);
    }

    @GetMapping(path = "getShipProductionCompletedEvents")
    @Transactional(readOnly = true)
    public java.util.List<AbstractSkillProcessEvent.ShipProductionProcessCompleted> getShipProductionCompletedEvents(@RequestParam(value = "startAt") Long startAt, @RequestParam(value = "endedAt") Long endedAt, @RequestParam(value = "senderAddress") String senderAddress) {
        return shipProductionEventRepository.getShipCompletedEvents(startAt, endedAt, senderAddress);
    }


    @GetMapping(path = "getPlayerVsEnvironmentEvents")
    @Transactional(readOnly = true)
    public java.util.List<PlayerVsEnvironment> getPlayerVsEnvironmentEvents(@RequestParam(value = "startAt") Long startAt, @RequestParam(value = "endedAt") Long endedAt, @RequestParam(value = "senderAddress") String senderAddress) {
        startAt = startAt / 1000;
        endedAt = endedAt / 1000;
        return shipBattleRelatedRepository.getPlayerVsEnvironmentEvents(startAt, endedAt, senderAddress);
    }


    @GetMapping(path = "getPlayerVsPlayerEvents")
    @Transactional(readOnly = true)
    public java.util.List<PlayerVsPlayer> getPlayerVsPlayerEvents(@RequestParam(value = "startAt") Long startAt, @RequestParam(value = "endedAt") Long endedAt, @RequestParam(value = "senderAddress") String senderAddress) {
        startAt = startAt / 1000;
        endedAt = endedAt / 1000;
        return shipBattleRelatedRepository.getPlayerVsPlayerEvents(startAt, endedAt, senderAddress);
    }

}