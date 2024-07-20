package org.dddml.suiinfinitesea.sui.contract.restful.resource;

import org.dddml.suiinfinitesea.domain.RosterId;
import org.dddml.suiinfinitesea.domain.roster.AbstractRosterState;
import org.dddml.suiinfinitesea.sui.contract.repository.RosterRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RequestMapping(path = "rosterExtends", produces = MediaType.APPLICATION_JSON_VALUE)
@RestController
public class RosterExtendResource {

    @Autowired
    private RosterRepository rosterRepository;

    @GetMapping("allRosterIds")
    @Transactional(readOnly = true)
    public List<String> getAllRosterIds() {
        List<AbstractRosterState.SimpleRosterState> rosters = rosterRepository.findAll();
        return rosters.stream().map(AbstractRosterState::getId_).collect(Collectors.toList());
    }
}
