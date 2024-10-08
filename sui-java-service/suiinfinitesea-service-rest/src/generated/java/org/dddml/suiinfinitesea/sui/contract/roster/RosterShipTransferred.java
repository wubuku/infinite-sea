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
public class RosterShipTransferred {
    private String id;

    private RosterIdForEvent rosterId;

    private BigInteger version;

    private String shipId;

    private RosterIdForEvent toRosterId;

    private BigInteger toPosition;

    private BigInteger transferredAt;

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

    public RosterIdForEvent getToRosterId() {
        return toRosterId;
    }

    public void setToRosterId(RosterIdForEvent toRosterId) {
        this.toRosterId = toRosterId;
    }

    public BigInteger getToPosition() {
        return toPosition;
    }

    public void setToPosition(BigInteger toPosition) {
        this.toPosition = toPosition;
    }

    public BigInteger getTransferredAt() {
        return transferredAt;
    }

    public void setTransferredAt(BigInteger transferredAt) {
        this.transferredAt = transferredAt;
    }

    @Override
    public String toString() {
        return "RosterShipTransferred{" +
                "id=" + '\'' + id + '\'' +
                ", rosterId=" + rosterId +
                ", version=" + version +
                ", shipId=" + '\'' + shipId + '\'' +
                ", toRosterId=" + toRosterId +
                ", toPosition=" + toPosition +
                ", transferredAt=" + transferredAt +
                '}';
    }

}
