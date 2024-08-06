package org.dddml.suiinfinitesea.sui.contract.restful.resource;

import io.swagger.annotations.*;
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

    @ApiOperation("How much ore has the player already mined.")
    @GetMapping(path = "minedOreQuantity")
    @Transactional(readOnly = true)
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Return the quantity of ore that the player has already mined.Return value type: Integer.", response = Integer.class)})
    @ApiImplicitParams({@ApiImplicitParam(name = "senderAddress", value = "Player wallet address", required = true, dataType = "String", paramType = "query")})
    public Integer getOreQuantity(@RequestParam(value = "senderAddress") String senderAddress) {
        return skillProcessEventExtendRepository.getCreationQuantity(senderAddress, 301L);
    }

    @GetMapping(path = "cutWoodQuantity")
    @Transactional(readOnly = true)
    @ApiOperation("How much wood has the player already cut.")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Return the quantity of log that the player has already cut.Return value type: Integer.", response = Integer.class)})
    @ApiImplicitParams({@ApiImplicitParam(name = "senderAddress", value = "Player wallet address", required = true, dataType = "String", paramType = "query")})
    public Integer getWoodQuantity(@RequestParam(value = "senderAddress") String senderAddress) {
        return skillProcessEventExtendRepository.getCreationQuantity(senderAddress, 200L);
    }

    @GetMapping(path = "plantedCottonQuantity")
    @Transactional(readOnly = true)
    @ApiOperation("How much cotton has the player planted.")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Return the quantity of cotton that the player has already planted.Return value type: Integer.", response = Integer.class)})
    @ApiImplicitParams({@ApiImplicitParam(name = "senderAddress", value = "Player wallet address", required = true, dataType = "String", paramType = "query")})
    public Integer getCottonQuantity(@RequestParam(value = "senderAddress") String senderAddress) {
        return skillProcessEventExtendRepository.getCottonQuantity(senderAddress);
    }

    @GetMapping(path = "addedToRoster1ShipQuantity")
    @Transactional(readOnly = true)
    @ApiOperation("How many ships has the player added to Roster 1.")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "The quantity of ships that have been added to Roster 1.Return value type: Integer.", response = Integer.class)})
    @ApiImplicitParams({@ApiImplicitParam(name = "senderAddress", value = "Player wallet address", required = true, dataType = "String", paramType = "query")})
    public Integer getAddedToRoster1ShipQuantity(@RequestParam(value = "senderAddress") String senderAddress) {
        return rosterEventExtendRepository.getAddedToRoster1ShipQuantity(senderAddress);
    }

    @GetMapping(path = "shipOrderArranged")
    @Transactional(readOnly = true)
    @ApiOperation("Has the player adjusted the order of the ships.")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Return value type: Boolean.[true:Yes,false:No.]", response = Integer.class)})
    @ApiImplicitParams({@ApiImplicitParam(name = "senderAddress", value = "Player wallet address", required = true, dataType = "String", paramType = "query")})
    public Boolean getArrangedShipOrderTimes(@RequestParam(value = "senderAddress") String senderAddress) {
        return rosterEventExtendRepository.getArrangedShipOrderTimes(senderAddress) > 0;
    }


    @GetMapping(path = "rosterSailed")
    @Transactional(readOnly = true)
    @ApiOperation("Has the player clicked on 'Sail'.")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Return value type: Boolean.[true:Yes,false:No.]", response = Integer.class)})
    @ApiImplicitParams({@ApiImplicitParam(name = "senderAddress", value = "Player wallet address", required = true, dataType = "String", paramType = "query")})
    public Boolean getRosterSetSailTimes(@RequestParam(value = "senderAddress") String senderAddress) {
        return rosterEventExtendRepository.getRosterSetSailTimes(senderAddress) > 0;
    }

}