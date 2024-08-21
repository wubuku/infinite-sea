package org.dddml.suiinfinitesea.sui.contract.restful.resource;

import io.swagger.annotations.*;
import org.dddml.suiinfinitesea.sui.contract.repository.AddressCount;
import org.dddml.suiinfinitesea.sui.contract.repository.RosterEventExtendRepository;
import org.dddml.suiinfinitesea.sui.contract.repository.SkillProcessEventExtendRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.List;


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

    @PostMapping(path = "batchGetMinedOreQuantity")
    @Transactional(readOnly = true)
    @ApiOperation("(Batch Query)How much ore has the player already mined.")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Return value type(Array): : AddressCount{\"address\": \"string\",\"count\": 0}.", responseContainer = "List", response = List.class, examples = @Example(value = {
            @ExampleProperty(mediaType = "application/json", value = "[{\"address\":\"0x3c9ebfe1031c8aac5fe99da5759d03260e424db4f6481a6a5effbb1ecfad764d\", \"count\":\"35\"}, {\"address\":\"0xf94d322ddf060d4dc9a9bee56d61ed119f39e17b5a1098d62254a10e37a86cf9\", \"count\":\"60\"}]")}))})
    public List<AddressCount> batchGetMinedOreQuantity(@RequestBody List<String> suiSenderAddresses) {
        return skillProcessEventExtendRepository.batchGetCreationQuantity(suiSenderAddresses, 301L);
    }


    @GetMapping(path = "cutWoodQuantity")
    @Transactional(readOnly = true)
    @ApiOperation("How much wood has the player already cut.")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Return the quantity of log that the player has already cut.Return value type: Integer.", response = Integer.class)})
    @ApiImplicitParams({@ApiImplicitParam(name = "senderAddress", value = "Player wallet address", required = true, dataType = "String", paramType = "query")})
    public Integer getWoodQuantity(@RequestParam(value = "senderAddress") String senderAddress) {
        return skillProcessEventExtendRepository.getCreationQuantity(senderAddress, 200L);
    }

    @PostMapping(path = "batchGetCutWoodQuantity")
    @Transactional(readOnly = true)
    @ApiOperation("(Batch Query)How much wood has the player already cut.")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Return value type(Array): : AddressCount{\"address\": \"string\",\"count\": 0}.", responseContainer = "List", response = List.class, examples = @Example(value = {
            @ExampleProperty(mediaType = "application/json", value = "[{\"address\":\"0x3c9ebfe1031c8aac5fe99da5759d03260e424db4f6481a6a5effbb1ecfad764d\", \"count\":\"35\"}, {\"address\":\"0xf94d322ddf060d4dc9a9bee56d61ed119f39e17b5a1098d62254a10e37a86cf9\", \"count\":\"60\"}]")}))})
    public List<AddressCount> batchGetCutWoodQuantity(@RequestBody List<String> suiSenderAddresses) {
        return skillProcessEventExtendRepository.batchGetCreationQuantity(suiSenderAddresses, 200L);
    }

    @GetMapping(path = "plantedCottonQuantity")
    @Transactional(readOnly = true)
    @ApiOperation("How much cotton has the player planted.")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Return the quantity of cotton that the player has already planted.Return value type: Integer.", response = Integer.class)})
    @ApiImplicitParams({@ApiImplicitParam(name = "senderAddress", value = "Player wallet address", required = true, dataType = "String", paramType = "query")})
    public Integer getCottonQuantity(@RequestParam(value = "senderAddress") String senderAddress) {
        return skillProcessEventExtendRepository.getCottonQuantity(senderAddress);
    }


    @PostMapping(path = "batchGetCottonQuantity")
    @Transactional(readOnly = true)
    @ApiOperation("(Batch query)How much cotton has the player planted.")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Return value type(Array): : AddressCount{\"address\": \"string\",\"count\": 0}.", responseContainer = "List", response = List.class, examples = @Example(value = {
            @ExampleProperty(mediaType = "application/json", value = "[{\"address\":\"0x3c9ebfe1031c8aac5fe99da5759d03260e424db4f6481a6a5effbb1ecfad764d\", \"count\":\"35\"}, {\"address\":\"0xf94d322ddf060d4dc9a9bee56d61ed119f39e17b5a1098d62254a10e37a86cf9\", \"count\":\"60\"}]")}))})
    public List<AddressCount> batchGetCottonQuantity(@RequestBody List<String> suiSenderAddresses) {
        return skillProcessEventExtendRepository.batchGetCottonQuantity(suiSenderAddresses);
    }

    @GetMapping(path = "addedToRoster1ShipQuantity")
    @Transactional(readOnly = true)
    @ApiOperation("How many ships has the player added to Roster 1.")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "The quantity of ships that have been added to Roster 1.Return value type: Integer.", response = Integer.class)})
    @ApiImplicitParams({@ApiImplicitParam(name = "senderAddress", value = "Player wallet address", required = true, dataType = "String", paramType = "query")})
    public Integer getAddedToRoster1ShipQuantity(@RequestParam(value = "senderAddress") String senderAddress) {
        return rosterEventExtendRepository.getAddedToRoster1ShipQuantity(senderAddress);
    }

    @PostMapping(path = "batchGetAddedToRoster1ShipQuantity")
    @Transactional(readOnly = true)
    @ApiOperation("(Batch Query)How many ships has the player added to Roster 1.")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Return value type(Array): : AddressCount{\"address\": \"string\",\"count\": 0}.", responseContainer = "List", response = List.class, examples = @Example(value = {
            @ExampleProperty(mediaType = "application/json", value = "[{\"address\":\"0x3c9ebfe1031c8aac5fe99da5759d03260e424db4f6481a6a5effbb1ecfad764d\", \"count\":\"6\"}, {\"address\":\"0x22946c7aa7d3175b79969d7d71c8196de26392f87bac7285b16b72bc2f909867\", \"count\":\"2\"}]")}))})
    public List<AddressCount> getAddedToRoster1ShipQuantity(@RequestBody List<String> suiSenderAddresses) {
        return rosterEventExtendRepository.batchGetAddedToRoster1ShipQuantity(suiSenderAddresses);
    }

    @GetMapping(path = "shipOrderArranged")
    @Transactional(readOnly = true)
    @ApiOperation("Has the player adjusted the order of the ships.")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Return value type: Boolean.[true:Yes,false:No.]", response = Boolean.class)})
    @ApiImplicitParams({@ApiImplicitParam(name = "senderAddress", value = "Player wallet address", required = true, dataType = "String", paramType = "query")})
    public Boolean getArrangedShipOrderTimes(@RequestParam(value = "senderAddress") String senderAddress) {
        return rosterEventExtendRepository.getArrangedShipOrderTimes(senderAddress) > 0;
    }


    @PostMapping(path = "batchGetArrangedShipOrderTimes")
    @Transactional(readOnly = true)
    @ApiOperation("(Batch Query)The number of times each player adjusts the ship's position separately.")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Return value type(Array): : AddressCount{\"address\": \"string\",\"count\": 0}.", responseContainer = "List", response = List.class, examples = @Example(value = {
            @ExampleProperty(mediaType = "application/json", value = "[{\"address\":\"0x3c9ebfe1031c8aac5fe99da5759d03260e424db4f6481a6a5effbb1ecfad764d\", \"count\":\"6\"}, {\"address\":\"0x22946c7aa7d3175b79969d7d71c8196de26392f87bac7285b16b72bc2f909867\", \"count\":\"2\"}]")}))})
    public List<AddressCount> batchGetArrangedShipOrderTimes(@RequestBody List<String> suiSenderAddresses) {
        return rosterEventExtendRepository.batchGetArrangedShipOrderTimes(suiSenderAddresses);
    }


    @GetMapping(path = "rosterSailed")
    @Transactional(readOnly = true)
    @ApiOperation("Has the player clicked on 'Sail'.")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Return value type: Boolean.[true:Yes,false:No.]", response = Integer.class)})
    @ApiImplicitParams({@ApiImplicitParam(name = "senderAddress", value = "Player wallet address", required = true, dataType = "String", paramType = "query")})
    public Boolean getRosterSetSailTimes(@RequestParam(value = "senderAddress") String senderAddress) {
        return rosterEventExtendRepository.getRosterSetSailTimes(senderAddress) > 0;
    }

    @PostMapping(path = "batchGetRosterSetSailTimes")
    @Transactional(readOnly = true)
    @ApiOperation("(Batch Query)clicked on 'Sail' times")
    @ApiResponses(value = {@ApiResponse(code = 200, message = "Return value type(Array): : AddressCount{\"address\": \"string\",\"count\": 0}.", responseContainer = "List", response = List.class, examples = @Example(value = {
            @ExampleProperty(mediaType = "application/json", value = "[{\"address\":\"0x3c9ebfe1031c8aac5fe99da5759d03260e424db4f6481a6a5effbb1ecfad764d\", \"count\":\"6\"}, {\"address\":\"0x22946c7aa7d3175b79969d7d71c8196de26392f87bac7285b16b72bc2f909867\", \"count\":\"2\"}]")}))})
    public List<AddressCount> batchGetRosterSetSailTimes(@RequestBody List<String> suiSenderAddresses) {
        return rosterEventExtendRepository.batchGetRosterSetSailTimes(suiSenderAddresses);
    }

}