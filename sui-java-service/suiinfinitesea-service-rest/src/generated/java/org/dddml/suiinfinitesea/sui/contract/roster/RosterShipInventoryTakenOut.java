// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.roster;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import org.dddml.suiinfinitesea.sui.contract.*;

import java.math.*;
import java.util.*;

@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class RosterShipInventoryTakenOut {
    private String id;

    private RosterIdForEvent rosterId;

    private BigInteger version;

    private String shipId;

    private ItemIdQuantityPairsForEvent itemIdQuantityPairs;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public RosterIdForEvent getRosterId() {
        return rosterId;
    }

    public void setRosterId(RosterIdForEvent rosterId) {
        this.rosterId = rosterId;
    }

    public BigInteger getVersion() {
        return version;
    }

    public void setVersion(BigInteger version) {
        this.version = version;
    }

    public String getShipId() {
        return shipId;
    }

    public void setShipId(String shipId) {
        this.shipId = shipId;
    }

    public ItemIdQuantityPairsForEvent getItemIdQuantityPairs() {
        return itemIdQuantityPairs;
    }

    public void setItemIdQuantityPairs(ItemIdQuantityPairsForEvent itemIdQuantityPairs) {
        this.itemIdQuantityPairs = itemIdQuantityPairs;
    }

    @Override
    public String toString() {
        return "RosterShipInventoryTakenOut{" +
                "id=" + '\'' + id + '\'' +
                ", rosterId=" + rosterId +
                ", version=" + version +
                ", shipId=" + '\'' + shipId + '\'' +
                ", itemIdQuantityPairs=" + itemIdQuantityPairs +
                '}';
    }

}
