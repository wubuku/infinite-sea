// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.map;

import java.util.*;
import java.util.Date;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.*;
import org.dddml.suiinfinitesea.domain.AbstractEvent;

public abstract class AbstractMapClaimIslandWhitelistItemEvent extends AbstractEvent implements MapClaimIslandWhitelistItemEvent.SqlMapClaimIslandWhitelistItemEvent {
    private MapClaimIslandWhitelistItemEventId mapClaimIslandWhitelistItemEventId = new MapClaimIslandWhitelistItemEventId();

    public MapClaimIslandWhitelistItemEventId getMapClaimIslandWhitelistItemEventId() {
        return this.mapClaimIslandWhitelistItemEventId;
    }

    public void setMapClaimIslandWhitelistItemEventId(MapClaimIslandWhitelistItemEventId eventId) {
        this.mapClaimIslandWhitelistItemEventId = eventId;
    }
    
    public String getKey() {
        return getMapClaimIslandWhitelistItemEventId().getKey();
    }

    public void setKey(String key) {
        getMapClaimIslandWhitelistItemEventId().setKey(key);
    }

    private boolean eventReadOnly;

    public boolean getEventReadOnly() { return this.eventReadOnly; }

    public void setEventReadOnly(boolean readOnly) { this.eventReadOnly = readOnly; }

    private String createdBy;

    public String getCreatedBy() {
        return this.createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    private Date createdAt;

    public Date getCreatedAt() {
        return this.createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }


    private String commandId;

    public String getCommandId() {
        return commandId;
    }

    public void setCommandId(String commandId) {
        this.commandId = commandId;
    }

    protected AbstractMapClaimIslandWhitelistItemEvent() {
    }

    protected AbstractMapClaimIslandWhitelistItemEvent(MapClaimIslandWhitelistItemEventId eventId) {
        this.mapClaimIslandWhitelistItemEventId = eventId;
    }


    public abstract String getEventType();


}
