// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.map;

import java.util.*;
import java.math.*;
import java.util.Date;
import java.math.BigInteger;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.Event;

public interface MapState extends VersionedSuiMoveObject
{
    Long VERSION_ZERO = 0L;

    Long VERSION_NULL = VERSION_ZERO - 1;

    String getId();

    Integer getClaimIslandSetting();

    Table getClaimIslandWhitelist();

    Long getOffChainVersion();

    String getCreatedBy();

    Date getCreatedAt();

    String getUpdatedBy();

    Date getUpdatedAt();

    Boolean getActive();

    Boolean getDeleted();

    EntityStateCollection<Coordinates, MapLocationState> getLocations();

    EntityStateCollection<String, MapClaimIslandWhitelistItemState> getMapClaimIslandWhitelistItems();

    interface MutableMapState extends MapState, VersionedSuiMoveObject.MutableVersionedSuiMoveObject {
        void setId(String id);

        void setClaimIslandSetting(Integer claimIslandSetting);

        void setClaimIslandWhitelist(Table claimIslandWhitelist);

        void setOffChainVersion(Long offChainVersion);

        void setCreatedBy(String createdBy);

        void setCreatedAt(Date createdAt);

        void setUpdatedBy(String updatedBy);

        void setUpdatedAt(Date updatedAt);

        void setActive(Boolean active);

        void setDeleted(Boolean deleted);


        void mutate(Event e);

        //void when(MapEvent.MapStateCreated e);

        //void when(MapEvent.MapStateMergePatched e);

        //void when(MapEvent.MapStateDeleted e);
    }

    interface SqlMapState extends MutableMapState {

        boolean isStateUnsaved();

        boolean getForReapplying();
    }
}

