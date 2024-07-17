package org.dddml.suiinfinitesea.sui.contract.restful.resource;

import org.dddml.suiinfinitesea.domain.item.AbstractItemEvent;
import org.dddml.suiinfinitesea.sui.contract.repository.ItemEventRepository;
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

    @GetMapping(path = "getItemEvents")
    @Transactional(readOnly = true)
    public java.util.List<AbstractItemEvent> getItemEvents(
            @RequestParam(value = "startSuiTimestamp") Long startSuiTimestamp,
            @RequestParam(value = "endSuiTimestamp") Long endSuiTimestamp
    ) {
        return itemEventRepository.findBySuiTimestampBetween(startSuiTimestamp, endSuiTimestamp);
    }

}