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
    public static BigInteger[] calculateTotalTimeAndEnergyCost(
            @RequestParam long originX,
            @RequestParam long originY,
            @RequestParam long destinationX,
            @RequestParam long destinationY,
            @RequestParam long speedProperty,
            @RequestParam long shipCount
    ) {
        return RosterUtil.calculateTotalTimeAndEnergyCost(
                new Long[]{originX, originY}, new Long[]{destinationX, destinationY},
                speedProperty, shipCount
        );
    }
}
