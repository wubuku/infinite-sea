package org.dddml.suiinfinitesea.sui.contract.restful.resource;

import io.swagger.annotations.ApiOperation;
import org.dddml.suiinfinitesea.sui.contract.repository.FaucetRequestedEventRepository;
import org.dddml.suiinfinitesea.sui.contract.repository.MapLocationRepository;
import org.dddml.suiinfinitesea.sui.contract.repository.ShipBattleRepository;
import org.dddml.suiinfinitesea.sui.contract.repository.ShipRepository;
import org.dddml.suiinfinitesea.sui.contract.utils.RosterUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigInteger;

@RequestMapping(path = "offChain", produces = MediaType.APPLICATION_JSON_VALUE)
@RestController
public class OffChainResource {

    @Autowired
    private FaucetRequestedEventRepository faucetRequestedEventRepository;
    @Autowired
    private ShipRepository shipRepository;
    @Autowired
    private MapLocationRepository mapLocationRepository;

    @Autowired
    private ShipBattleRepository shipBattleRepository;


    @ApiOperation("number of Battles")
    @GetMapping(path = "numberOfBattles")
    @Transactional(readOnly = true)
    public Long numberOfBattles() {
        return shipBattleRepository.numberOfBattles();
    }


    @ApiOperation("number of pvp Battles")
    @GetMapping(path = "numberOfPVPBattles")
    @Transactional(readOnly = true)
    public Long numberOfPvPBattles() {
        return shipBattleRepository.numberOfPvPBattles();
    }


    @ApiOperation("number of unique addresses that claimed island")
    @GetMapping(path = "numberOfClaimedIslands")
    @Transactional(readOnly = true)
    public Long countByOccupiedByIsNotNull() {
        return mapLocationRepository.countByOccupiedByIsNotNull();
    }


    @ApiOperation("number of ships that are crafted")
    @GetMapping(path = "numberOfCraftedShips")
    @Transactional(readOnly = true)
    public Long getShipsCrafted() {
        return shipRepository.getShipsCrafted();
    }

    @ApiOperation("number of energy token has been claimed.")
    @GetMapping(path = "numberOfClaimedEnergy")
    @Transactional(readOnly = true)
    public Long getEnergyTokenClaimed() {
        return faucetRequestedEventRepository.getEnergyTokenClaimed();
    }

    @ApiOperation("number of unique addresses that interacted with faucet.")
    @GetMapping(path = "numberOfRequestedFaucetAddresses")
    @Transactional(readOnly = true)
    public Long numberOfRequestedFaucetAddress() {
        return faucetRequestedEventRepository.numberOfRequestedFaucetAddress();
    }

    @GetMapping(path = "calculateTotalTimeAndEnergyCost")
    public BigInteger[] calculateTotalTimeAndEnergyCost(
            @RequestParam(value = "originX") long originX,
            @RequestParam(value = "originY") long originY,
            @RequestParam(value = "destinationX") long destinationX,
            @RequestParam(value = "destinationY") long destinationY,
            @RequestParam(value = "speedProperty") long speedProperty,
            @RequestParam(value = "shipCount") long shipCount
    ) {
        return RosterUtil.calculateTotalTimeAndEnergyCost(
                new Long[]{originX, originY}, new Long[]{destinationX, destinationY},
                speedProperty, shipCount
        );
    }


    /**
     * Calculate the time and energy required for the roster to reach its destination based on distance, speed, and number of ships
     */
    @GetMapping(path = "calculateTotalTimeAndEnergyCostByDistance")
    public BigInteger[] calculateTotalTimeAndEnergyCostByDistance(
            @RequestParam(value = "distance") BigInteger distance,
            @RequestParam(value = "speedProperty") long speedProperty,
            @RequestParam(value = "shipCount") long shipCount
    ) {
        return RosterUtil.calculateTotalTimeAndEnergyCostByDistance(distance, speedProperty, shipCount);
    }


}
