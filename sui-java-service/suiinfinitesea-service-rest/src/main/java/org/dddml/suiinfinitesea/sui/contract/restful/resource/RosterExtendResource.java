package org.dddml.suiinfinitesea.sui.contract.restful.resource;

import org.dddml.suiinfinitesea.domain.roster.AbstractRosterState;
import org.dddml.suiinfinitesea.sui.contract.repository.ItemIdQuantityPair;
import org.dddml.suiinfinitesea.sui.contract.repository.RosterRepository;
import org.dddml.suiinfinitesea.sui.contract.repository.RosterShipsItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RequestMapping(path = "rosterExtends", produces = MediaType.APPLICATION_JSON_VALUE)
@RestController
public class RosterExtendResource {

    @Autowired
    private RosterRepository rosterRepository;
    @Autowired
    private RosterShipsItemRepository rosterShipsItemRepository;

    @GetMapping("allRosterIds")
    @Transactional(readOnly = true)
    public List<String> getAllRosterIds() {
        List<AbstractRosterState.SimpleRosterState> rosters = rosterRepository.findAll();
        return rosters.stream().map(AbstractRosterState::getId_).collect(Collectors.toList());
    }

    @GetMapping("getLoots")
    @Transactional(readOnly = true)
    public Map<Long, Integer> getLoots(@RequestParam(value = "rosterId") String rosterId) {
        Map<Long, Integer> itemQuantityPairs = new HashMap<>();
        AbstractRosterState.SimpleRosterState roster = rosterRepository.findFirstById(rosterId);
//        if (roster != null && roster.getRosterShipsItems() != null) {
//            for (RosterShipsItemState rosterShipsItem : roster.getRosterShipsItems().getLoadedStates()) {
//
//            }
//        }
        if (roster != null && !roster.getShipIds().isEmpty()) {
            for (String shipId : roster.getShipIds()) {
                List<ItemIdQuantityPair> inventory = rosterShipsItemRepository.getShipInventory(shipId);
                for (ItemIdQuantityPair pair : inventory) {
                    if (itemQuantityPairs.containsKey(pair.getItemId())) {
                        itemQuantityPairs.put(pair.getItemId(), itemQuantityPairs.get(pair.getItemId()) + pair.getQuantity());
                    } else {
                        itemQuantityPairs.put(pair.getItemId(), pair.getQuantity());
                    }
                }
                List<ItemIdQuantityPair> buildExpenses = rosterShipsItemRepository.getBuildingExpenses(shipId);
                for (ItemIdQuantityPair pair : buildExpenses) {
                    if (itemQuantityPairs.containsKey(pair.getItemId())) {
                        itemQuantityPairs.put(pair.getItemId(), itemQuantityPairs.get(pair.getItemId()) + pair.getQuantity() * 4 / 5);
                    } else {
                        itemQuantityPairs.put(pair.getItemId(), pair.getQuantity() * 4 / 5);
                    }
                }
            }
        }
        return itemQuantityPairs;
    }
}
