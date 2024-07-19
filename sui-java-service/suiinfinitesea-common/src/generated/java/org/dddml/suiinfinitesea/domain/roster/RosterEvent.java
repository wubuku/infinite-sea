// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.roster;

import java.util.*;
import org.dddml.suiinfinitesea.domain.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.specialization.Event;

public interface RosterEvent extends Event, SuiEventEnvelope, SuiMoveEvent, HasEventStatus {

    interface SqlRosterEvent extends RosterEvent {
        RosterEventId getRosterEventId();

        boolean getEventReadOnly();

        void setEventReadOnly(boolean readOnly);
    }

    interface RosterCreated extends RosterEvent {
        Integer getStatus();

        void setStatus(Integer value);

        Long getSpeed();

        void setSpeed(Long value);

        Coordinates getUpdatedCoordinates();

        void setUpdatedCoordinates(Coordinates value);

        BigInteger getCoordinatesUpdatedAt();

        void setCoordinatesUpdatedAt(BigInteger value);

        Coordinates getTargetCoordinates();

        void setTargetCoordinates(Coordinates value);

        Coordinates getOriginCoordinates();

        void setOriginCoordinates(Coordinates value);

        String getShipBattleId();

        void setShipBattleId(String value);

    }

    interface EnvironmentRosterCreated extends RosterEvent {
        Coordinates getCoordinates();

        void setCoordinates(Coordinates value);

        Long getShipResourceQuantity();

        void setShipResourceQuantity(Long value);

        Long getShipBaseResourceQuantity();

        void setShipBaseResourceQuantity(Long value);

        Long getBaseExperience();

        void setBaseExperience(Long value);

    }

    interface RosterShipAdded extends RosterEvent {
        String getShip();

        void setShip(String value);

        BigInteger getPosition();

        void setPosition(BigInteger value);

    }

    interface RosterSetSail extends RosterEvent {
        Coordinates getTargetCoordinates();

        void setTargetCoordinates(Coordinates value);

        BigInteger getSailDuration();

        void setSailDuration(BigInteger value);

        BigInteger getSetSailAt();

        void setSetSailAt(BigInteger value);

        Coordinates getUpdatedCoordinates();

        void setUpdatedCoordinates(Coordinates value);

        BigInteger getEnergyCost();

        void setEnergyCost(BigInteger value);

    }

    interface RosterLocationUpdated extends RosterEvent {
        Coordinates getUpdatedCoordinates();

        void setUpdatedCoordinates(Coordinates value);

        BigInteger getCoordinatesUpdatedAt();

        void setCoordinatesUpdatedAt(BigInteger value);

        Integer getNewStatus();

        void setNewStatus(Integer value);

    }

    interface RosterShipsPositionAdjusted extends RosterEvent {
        BigInteger[] getPositions();

        void setPositions(BigInteger[] value);

        String[] getShipIds();

        void setShipIds(String[] value);

    }

    interface RosterShipTransferred extends RosterEvent {
        String getShipId();

        void setShipId(String value);

        RosterId getToRosterId();

        void setToRosterId(RosterId value);

        BigInteger getToPosition();

        void setToPosition(BigInteger value);

    }

    interface RosterShipInventoryTransferred extends RosterEvent {
        String getFromShipId();

        void setFromShipId(String value);

        String getToShipId();

        void setToShipId(String value);

        ItemIdQuantityPairs getItemIdQuantityPairs();

        void setItemIdQuantityPairs(ItemIdQuantityPairs value);

    }

    interface RosterShipInventoryTakenOut extends RosterEvent {
        String getShipId();

        void setShipId(String value);

        ItemIdQuantityPairs getItemIdQuantityPairs();

        void setItemIdQuantityPairs(ItemIdQuantityPairs value);

        Coordinates getUpdatedCoordinates();

        void setUpdatedCoordinates(Coordinates value);

    }

    interface RosterShipInventoryPutIn extends RosterEvent {
        String getShipId();

        void setShipId(String value);

        ItemIdQuantityPairs getItemIdQuantityPairs();

        void setItemIdQuantityPairs(ItemIdQuantityPairs value);

        Coordinates getUpdatedCoordinates();

        void setUpdatedCoordinates(Coordinates value);

    }

    RosterId getRosterId();

    //void setRosterId(RosterId rosterId);

    BigInteger getVersion();
    
    //void setVersion(BigInteger version);

    String getId_();
    
    //void setId_(String id);

    String getCreatedBy();

    void setCreatedBy(String createdBy);

    Date getCreatedAt();

    void setCreatedAt(Date createdAt);

    String getCommandId();

    void setCommandId(String commandId);


}

