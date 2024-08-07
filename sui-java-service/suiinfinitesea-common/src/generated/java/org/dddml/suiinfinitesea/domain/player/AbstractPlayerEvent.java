// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.player;

import java.util.*;
import org.dddml.suiinfinitesea.domain.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.specialization.*;
import org.dddml.suiinfinitesea.domain.AbstractEvent;

public abstract class AbstractPlayerEvent extends AbstractEvent implements PlayerEvent.SqlPlayerEvent, SuiEventEnvelope.MutableSuiEventEnvelope, SuiMoveEvent.MutableSuiMoveEvent, HasEventStatus.MutableHasEventStatus {
    private PlayerEventId playerEventId = new PlayerEventId();

    public PlayerEventId getPlayerEventId() {
        return this.playerEventId;
    }

    public void setPlayerEventId(PlayerEventId eventId) {
        this.playerEventId = eventId;
    }
    
    public String getId() {
        return getPlayerEventId().getId();
    }

    public void setId(String id) {
        getPlayerEventId().setId(id);
    }

    private boolean eventReadOnly;

    public boolean getEventReadOnly() { return this.eventReadOnly; }

    public void setEventReadOnly(boolean readOnly) { this.eventReadOnly = readOnly; }

    public BigInteger getVersion() {
        return getPlayerEventId().getVersion();
    }
    
    public void setVersion(BigInteger version) {
        getPlayerEventId().setVersion(version);
    }

    private Long suiTimestamp;

    public Long getSuiTimestamp() {
        return this.suiTimestamp;
    }
    
    public void setSuiTimestamp(Long suiTimestamp) {
        this.suiTimestamp = suiTimestamp;
    }

    private String suiTxDigest;

    public String getSuiTxDigest() {
        return this.suiTxDigest;
    }
    
    public void setSuiTxDigest(String suiTxDigest) {
        this.suiTxDigest = suiTxDigest;
    }

    private BigInteger suiEventSeq;

    public BigInteger getSuiEventSeq() {
        return this.suiEventSeq;
    }
    
    public void setSuiEventSeq(BigInteger suiEventSeq) {
        this.suiEventSeq = suiEventSeq;
    }

    private String suiPackageId;

    public String getSuiPackageId() {
        return this.suiPackageId;
    }
    
    public void setSuiPackageId(String suiPackageId) {
        this.suiPackageId = suiPackageId;
    }

    private String suiTransactionModule;

    public String getSuiTransactionModule() {
        return this.suiTransactionModule;
    }
    
    public void setSuiTransactionModule(String suiTransactionModule) {
        this.suiTransactionModule = suiTransactionModule;
    }

    private String suiSender;

    public String getSuiSender() {
        return this.suiSender;
    }
    
    public void setSuiSender(String suiSender) {
        this.suiSender = suiSender;
    }

    private String suiType;

    public String getSuiType() {
        return this.suiType;
    }
    
    public void setSuiType(String suiType) {
        this.suiType = suiType;
    }

    private String eventStatus;

    public String getEventStatus() {
        return this.eventStatus;
    }
    
    public void setEventStatus(String eventStatus) {
        this.eventStatus = eventStatus;
    }

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

    private String commandType;

    public String getCommandType() {
        return commandType;
    }

    public void setCommandType(String commandType) {
        this.commandType = commandType;
    }

    protected AbstractPlayerEvent() {
    }

    protected AbstractPlayerEvent(PlayerEventId eventId) {
        this.playerEventId = eventId;
    }


    public abstract String getEventType();

    public static class PlayerLobEvent extends AbstractPlayerEvent {

        public Map<String, Object> getDynamicProperties() {
            return dynamicProperties;
        }

        public void setDynamicProperties(Map<String, Object> dynamicProperties) {
            if (dynamicProperties == null) {
                throw new IllegalArgumentException("dynamicProperties is null.");
            }
            this.dynamicProperties = dynamicProperties;
        }

        private Map<String, Object> dynamicProperties = new HashMap<>();

        @Override
        public String getEventType() {
            return "PlayerLobEvent";
        }

    }

    public static class PlayerCreated extends PlayerLobEvent implements PlayerEvent.PlayerCreated {

        @Override
        public String getEventType() {
            return "PlayerCreated";
        }

        public String getName() {
            Object val = getDynamicProperties().get("name");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setName(String value) {
            getDynamicProperties().put("name", value);
        }

        public String getOwner() {
            Object val = getDynamicProperties().get("owner");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setOwner(String value) {
            getDynamicProperties().put("owner", value);
        }

    }

    public static class IslandClaimed extends PlayerLobEvent implements PlayerEvent.IslandClaimed {

        @Override
        public String getEventType() {
            return "IslandClaimed";
        }

        public Coordinates getCoordinates() {
            Object val = getDynamicProperties().get("coordinates");
            if (val instanceof Coordinates) {
                return (Coordinates) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Coordinates.class);
        }

        public void setCoordinates(Coordinates value) {
            getDynamicProperties().put("coordinates", value);
        }

        public BigInteger getClaimedAt() {
            Object val = getDynamicProperties().get("claimedAt");
            if (val instanceof BigInteger) {
                return (BigInteger) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, BigInteger.class);
        }

        public void setClaimedAt(BigInteger value) {
            getDynamicProperties().put("claimedAt", value);
        }

    }

    public static class NftHolderIslandClaimed extends PlayerLobEvent implements PlayerEvent.NftHolderIslandClaimed {

        @Override
        public String getEventType() {
            return "NftHolderIslandClaimed";
        }

        public Coordinates getCoordinates() {
            Object val = getDynamicProperties().get("coordinates");
            if (val instanceof Coordinates) {
                return (Coordinates) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Coordinates.class);
        }

        public void setCoordinates(Coordinates value) {
            getDynamicProperties().put("coordinates", value);
        }

        public BigInteger getClaimedAt() {
            Object val = getDynamicProperties().get("claimedAt");
            if (val instanceof BigInteger) {
                return (BigInteger) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, BigInteger.class);
        }

        public void setClaimedAt(BigInteger value) {
            getDynamicProperties().put("claimedAt", value);
        }

    }

    public static class PlayerAirdropped extends PlayerLobEvent implements PlayerEvent.PlayerAirdropped {

        @Override
        public String getEventType() {
            return "PlayerAirdropped";
        }

        public Long getItemId() {
            Object val = getDynamicProperties().get("itemId");
            if (val instanceof Long) {
                return (Long) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Long.class);
        }

        public void setItemId(Long value) {
            getDynamicProperties().put("itemId", value);
        }

        public Long getQuantity() {
            Object val = getDynamicProperties().get("quantity");
            if (val instanceof Long) {
                return (Long) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Long.class);
        }

        public void setQuantity(Long value) {
            getDynamicProperties().put("quantity", value);
        }

    }

    public static class PlayerIslandResourcesGathered extends PlayerLobEvent implements PlayerEvent.PlayerIslandResourcesGathered {

        @Override
        public String getEventType() {
            return "PlayerIslandResourcesGathered";
        }

    }


}

