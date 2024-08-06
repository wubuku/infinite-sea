package org.dddml.suiinfinitesea.sui.contract.restful.resource;

import org.dddml.suiinfinitesea.sui.contract.repository.*;
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
    private ItemEventRepository itemEventRepository;

    @Autowired
    private ShipProductionEventRepository shipProductionEventRepository;
    @Autowired
    private FaucetRequestedEventRepository faucetRequestedEventRepository;

    @Autowired
    private ShipBattleRelatedRepository shipBattleRelatedRepository;

    @Autowired
    private SkillProcessEventExtendRepository skillProcessEventExtendRepository;

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
}