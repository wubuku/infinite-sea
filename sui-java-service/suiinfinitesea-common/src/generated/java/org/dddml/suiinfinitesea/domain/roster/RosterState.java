// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.roster;

import java.util.*;
import java.math.*;
import org.dddml.suiinfinitesea.domain.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.specialization.Event;

public interface RosterState extends VersionedSuiMoveObject
{
    Long VERSION_ZERO = 0L;

    Long VERSION_NULL = VERSION_ZERO - 1;

    RosterId getRosterId();

    String getId_();

    Integer getStatus();

    Long getSpeed();

    ObjectTable getShips();

    Coordinates getUpdatedCoordinates();

    BigInteger getCoordinatesUpdatedAt();

    Coordinates getTargetCoordinates();

    Coordinates getOriginCoordinates();

    BigInteger getSailDuration();

    String getShipBattleId();

    Boolean getEnvironmentOwned();

    Long getBaseExperience();

    java.math.BigInteger getEnergyVault();

    Long getOffChainVersion();

    String getCreatedBy();

    Date getCreatedAt();

    String getUpdatedBy();

    Date getUpdatedAt();

    Boolean getActive();

    Boolean getDeleted();

    Set<String> getShipIds();

    EntityStateCollection<String, RosterShipsItemState> getRosterShipsItems();

    interface MutableRosterState extends RosterState, VersionedSuiMoveObject.MutableVersionedSuiMoveObject {
        void setRosterId(RosterId rosterId);

        void setId_(String id);

        void setStatus(Integer status);

        void setSpeed(Long speed);

        void setShips(ObjectTable ships);

        void setUpdatedCoordinates(Coordinates updatedCoordinates);

        void setCoordinatesUpdatedAt(BigInteger coordinatesUpdatedAt);

        void setTargetCoordinates(Coordinates targetCoordinates);

        void setOriginCoordinates(Coordinates originCoordinates);

        void setSailDuration(BigInteger sailDuration);

        void setShipBattleId(String shipBattleId);

        void setEnvironmentOwned(Boolean environmentOwned);

        void setBaseExperience(Long baseExperience);

        void setEnergyVault(java.math.BigInteger energyVault);

        void setOffChainVersion(Long offChainVersion);

        void setCreatedBy(String createdBy);

        void setCreatedAt(Date createdAt);

        void setUpdatedBy(String updatedBy);

        void setUpdatedAt(Date updatedAt);

        void setActive(Boolean active);

        void setDeleted(Boolean deleted);

        void setShipIds(Set<String> shipIds);


        void mutate(Event e);

        //void when(RosterEvent.RosterStateCreated e);

        //void when(RosterEvent.RosterStateMergePatched e);

        //void when(RosterEvent.RosterStateDeleted e);
    }

    interface SqlRosterState extends MutableRosterState {

        boolean isStateUnsaved();

        boolean getForReapplying();
    }
}

