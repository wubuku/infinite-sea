package org.dddml.suiinfinitesea.sui.contract.restful.resource;

import org.dddml.suiinfinitesea.sui.contract.repository.RosterEventExtendRepository;
import org.dddml.suiinfinitesea.sui.contract.repository.SkillProcessEventExtendRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


@RequestMapping(path = "quests", produces = MediaType.APPLICATION_JSON_VALUE)
@RestController
public class QuestResource {

    @Autowired
    private SkillProcessEventExtendRepository skillProcessEventExtendRepository;

    @Autowired
    private RosterEventExtendRepository rosterEventExtendRepository;

    @GetMapping(path = "minedOreQuantity")
    @Transactional(readOnly = true)
    public Integer getOreQuantity(@RequestParam(value = "senderAddress") String senderAddress) {
        return skillProcessEventExtendRepository.getCreationQuantity(senderAddress, 301L);
    }

    @GetMapping(path = "cutWoodQuantity")
    @Transactional(readOnly = true)
    public Integer getWoodQuantity(@RequestParam(value = "senderAddress") String senderAddress) {
        return skillProcessEventExtendRepository.getCreationQuantity(senderAddress, 200L);
    }

    @GetMapping(path = "plantedCottonQuantity")
    @Transactional(readOnly = true)
    public Integer getCottonQuantity(@RequestParam(value = "senderAddress") String senderAddress) {
        return skillProcessEventExtendRepository.getCottonQuantity(senderAddress);
    }

    @GetMapping(path = "addedToRoster1ShipQuantity")
    @Transactional(readOnly = true)
    public Integer getAddedToRoster1ShipQuantity(@RequestParam(value = "senderAddress") String senderAddress) {
        return rosterEventExtendRepository.getAddedToRoster1ShipQuantity(senderAddress);
    }

    @GetMapping(path = "shipOrderArranged")
    @Transactional(readOnly = true)
    public Boolean getArrangedShipOrderTimes(@RequestParam(value = "senderAddress") String senderAddress) {
        return rosterEventExtendRepository.getArrangedShipOrderTimes(senderAddress) > 0;
    }

    @GetMapping(path = "rosterSailed")
    @Transactional(readOnly = true)
    public Boolean getRosterSetSailTimes(@RequestParam(value = "senderAddress") String senderAddress) {
        return rosterEventExtendRepository.getRosterSetSailTimes(senderAddress) > 0;
    }

}