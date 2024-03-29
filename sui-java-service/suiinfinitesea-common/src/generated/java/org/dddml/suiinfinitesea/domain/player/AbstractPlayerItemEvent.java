// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.player;

import java.util.*;
import java.util.Date;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.*;
import org.dddml.suiinfinitesea.domain.AbstractEvent;

public abstract class AbstractPlayerItemEvent extends AbstractEvent implements PlayerItemEvent.SqlPlayerItemEvent {
    private PlayerItemEventId playerItemEventId = new PlayerItemEventId();

    public PlayerItemEventId getPlayerItemEventId() {
        return this.playerItemEventId;
    }

    public void setPlayerItemEventId(PlayerItemEventId eventId) {
        this.playerItemEventId = eventId;
    }
    
    public Long getItemId() {
        return getPlayerItemEventId().getItemId();
    }

    public void setItemId(Long itemId) {
        getPlayerItemEventId().setItemId(itemId);
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

    protected AbstractPlayerItemEvent() {
    }

    protected AbstractPlayerItemEvent(PlayerItemEventId eventId) {
        this.playerItemEventId = eventId;
    }


    public abstract String getEventType();


}

