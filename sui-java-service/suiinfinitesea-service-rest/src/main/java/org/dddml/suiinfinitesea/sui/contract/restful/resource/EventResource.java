package org.dddml.suiinfinitesea.sui.contract.restful.resource;

import org.dddml.suiinfinitesea.domain.faucetrequested.AbstractFaucetRequestedState;
import org.dddml.suiinfinitesea.domain.item.AbstractItemEvent;
import org.dddml.suiinfinitesea.domain.skillprocess.AbstractSkillProcessEvent;
import org.dddml.suiinfinitesea.sui.contract.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.List;


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


    @PostMapping(path = "batchFaucetRequestedEvents")
    @Transactional(readOnly = true)
    public List<AbstractFaucetRequestedState.SimpleFaucetRequestedState> batchFaucetRequestedEvents(@RequestBody EventRequestVo requestFaucet) {
        return faucetRequestedEventRepository.batchFaucetRequestedEvents(requestFaucet.getStartAt(), requestFaucet.getEndAt(), requestFaucet.getSenderAddresses());
    }

    @GetMapping(path = "getShipProductionCompletedEvents")
    @Transactional(readOnly = true)
    public java.util.List<AbstractSkillProcessEvent.ShipProductionProcessCompleted> getShipProductionCompletedEvents(@RequestParam(value = "startAt") Long startAt, @RequestParam(value = "endedAt") Long endedAt, @RequestParam(value = "senderAddress") String senderAddress) {
        return shipProductionEventRepository.getShipCompletedEvents(startAt, endedAt, senderAddress);
    }

    @PostMapping(path = "batchShipProductionCompletedEvents")
    @Transactional(readOnly = true)
    public java.util.List<AbstractSkillProcessEvent.ShipProductionProcessCompleted> batchGetShipCompletedEvents(@RequestBody EventRequestVo requestVo) {
        return shipProductionEventRepository.batchGetShipCompletedEvents(requestVo.getStartAt(), requestVo.getEndAt(), requestVo.getSenderAddresses());
    }


    @GetMapping(path = "getPlayerVsEnvironmentEvents")
    @Transactional(readOnly = true)
    public java.util.List<PlayerVsEnvironment> getPlayerVsEnvironmentEvents(@RequestParam(value = "startAt") Long startAt, @RequestParam(value = "endedAt") Long endedAt, @RequestParam(value = "senderAddress") String senderAddress) {
        startAt = startAt / 1000;
        endedAt = endedAt / 1000;
        return shipBattleRelatedRepository.getPlayerVsEnvironmentEvents(startAt, endedAt, senderAddress);
    }


    @PostMapping(path = "batchGetPlayerVsEnvironmentEvents")
    @Transactional(readOnly = true)
    public java.util.List<PlayerVsEnvironment> batchGetPlayerVsEnvironmentEvents(@RequestBody EventRequestVo requestVo) {
        Long startAt = requestVo.getStartAt() / 1000;
        Long endedAt = requestVo.getEndAt() / 1000;
        return shipBattleRelatedRepository.batchGetPlayerVsEnvironmentEvents(startAt, endedAt, requestVo.getSenderAddresses());
    }


    @GetMapping(path = "getPlayerVsPlayerEvents")
    @Transactional(readOnly = true)
    public java.util.List<PlayerVsPlayer> getPlayerVsPlayerEvents(@RequestParam(value = "startAt") Long startAt, @RequestParam(value = "endedAt") Long endedAt, @RequestParam(value = "senderAddress") String senderAddress) {
        startAt = startAt / 1000;
        endedAt = endedAt / 1000;
        return shipBattleRelatedRepository.getPlayerVsPlayerEvents(startAt, endedAt, senderAddress);
    }


    @PostMapping(path = "batchGetPlayerVsPlayerEvents")
    @Transactional(readOnly = true)
    public java.util.List<PlayerVsPlayer> getPlayerVsPlayerEvents(@RequestBody EventRequestVo requestVo) {
        Long startAt = requestVo.getStartAt() / 1000;
        Long endedAt = requestVo.getEndAt() / 1000;
        return shipBattleRelatedRepository.batchGetPlayerVsPlayerEvents(startAt, endedAt, requestVo.getSenderAddresses());
    }

}