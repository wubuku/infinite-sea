package org.dddml.suiinfinitesea.sui.contract.restful.resource;

import org.dddml.suiinfinitesea.sui.contract.utils.RosterUtil;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigInteger;

@RequestMapping(path = "offChain", produces = MediaType.APPLICATION_JSON_VALUE)
@RestController
public class OffChainResource {

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
