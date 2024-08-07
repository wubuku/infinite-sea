// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.map;

import java.util.*;
import java.util.Date;
import java.math.BigInteger;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.Event;

public interface MapEvent extends Event, SuiEventEnvelope, SuiMoveEvent, HasEventStatus {

    interface SqlMapEvent extends MapEvent {
        MapEventId getMapEventId();

        boolean getEventReadOnly();

        void setEventReadOnly(boolean readOnly);
    }

    interface InitMapEvent extends MapEvent {
    }

    interface IslandAdded extends MapEvent {
        Coordinates getCoordinates();

        void setCoordinates(Coordinates value);

        ItemIdQuantityPairs getResources();

        void setResources(ItemIdQuantityPairs value);

    }

    interface MapIslandClaimed extends MapEvent {
        Coordinates getCoordinates();

        void setCoordinates(Coordinates value);

        String getClaimedBy();

        void setClaimedBy(String value);

        BigInteger getClaimedAt();

        void setClaimedAt(BigInteger value);

    }

    interface IslandResourcesGathered extends MapEvent {
        String getPlayerId();

        void setPlayerId(String value);

        Coordinates getCoordinates();

        void setCoordinates(Coordinates value);

        ItemIdQuantityPair[] getResources();

        void setResources(ItemIdQuantityPair[] value);

        BigInteger getGatheredAt();

        void setGatheredAt(BigInteger value);

    }

    interface MapSettingsUpdated extends MapEvent {
        Integer getClaimIslandSetting();

        void setClaimIslandSetting(Integer value);

    }

    interface WhitelistedForClaimingIsland extends MapEvent {
        String getAccountAddress();

        void setAccountAddress(String value);

    }

    interface UnWhitelistedForClaimingIsland extends MapEvent {
        String getAccountAddress();

        void setAccountAddress(String value);

    }

    String getId();

    //void setId(String id);

    BigInteger getVersion();
    
    //void setVersion(BigInteger version);

    String getCreatedBy();

    void setCreatedBy(String createdBy);

    Date getCreatedAt();

    void setCreatedAt(Date createdAt);

    String getCommandId();

    void setCommandId(String commandId);


}

