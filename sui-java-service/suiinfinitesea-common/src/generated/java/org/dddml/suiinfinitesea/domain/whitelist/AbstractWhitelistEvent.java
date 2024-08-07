// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.whitelist;

import java.util.*;
import java.util.Date;
import java.math.BigInteger;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.*;
import org.dddml.suiinfinitesea.domain.AbstractEvent;

public abstract class AbstractWhitelistEvent extends AbstractEvent implements WhitelistEvent.SqlWhitelistEvent, SuiEventEnvelope.MutableSuiEventEnvelope, SuiMoveEvent.MutableSuiMoveEvent, HasEventStatus.MutableHasEventStatus {
    private WhitelistEventId whitelistEventId = new WhitelistEventId();

    public WhitelistEventId getWhitelistEventId() {
        return this.whitelistEventId;
    }

    public void setWhitelistEventId(WhitelistEventId eventId) {
        this.whitelistEventId = eventId;
    }
    
    public String getId() {
        return getWhitelistEventId().getId();
    }

    public void setId(String id) {
        getWhitelistEventId().setId(id);
    }

    private boolean eventReadOnly;

    public boolean getEventReadOnly() { return this.eventReadOnly; }

    public void setEventReadOnly(boolean readOnly) { this.eventReadOnly = readOnly; }

    public BigInteger getVersion() {
        return getWhitelistEventId().getVersion();
    }
    
    public void setVersion(BigInteger version) {
        getWhitelistEventId().setVersion(version);
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

    protected AbstractWhitelistEvent() {
    }

    protected AbstractWhitelistEvent(WhitelistEventId eventId) {
        this.whitelistEventId = eventId;
    }

    protected WhitelistEntryEventDao getWhitelistEntryEventDao() {
        return (WhitelistEntryEventDao)ApplicationContext.current.get("whitelistEntryEventDao");
    }

    protected WhitelistEntryEventId newWhitelistEntryEventId(String accountAddress)
    {
        WhitelistEntryEventId eventId = new WhitelistEntryEventId(this.getWhitelistEventId().getId(), 
            accountAddress, 
            this.getWhitelistEventId().getVersion());
        return eventId;
    }

    protected void throwOnInconsistentEventIds(WhitelistEntryEvent.SqlWhitelistEntryEvent e)
    {
        throwOnInconsistentEventIds(this, e);
    }

    public static void throwOnInconsistentEventIds(WhitelistEvent.SqlWhitelistEvent oe, WhitelistEntryEvent.SqlWhitelistEntryEvent e)
    {
        if (!oe.getWhitelistEventId().getId().equals(e.getWhitelistEntryEventId().getWhitelistId()))
        { 
            throw DomainError.named("inconsistentEventIds", "Outer Id Id %1$s but inner id WhitelistId %2$s", 
                oe.getWhitelistEventId().getId(), e.getWhitelistEntryEventId().getWhitelistId());
        }
    }


    public abstract String getEventType();

    public static class WhitelistLobEvent extends AbstractWhitelistEvent {

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
            return "WhitelistLobEvent";
        }

    }

    public static class InitWhitelistEvent extends WhitelistLobEvent implements WhitelistEvent.InitWhitelistEvent {

        @Override
        public String getEventType() {
            return "InitWhitelistEvent";
        }

    }

    public static class WhitelistUpdated extends WhitelistLobEvent implements WhitelistEvent.WhitelistUpdated {

        @Override
        public String getEventType() {
            return "WhitelistUpdated";
        }

        public Boolean getPaused() {
            Object val = getDynamicProperties().get("paused");
            if (val instanceof Boolean) {
                return (Boolean) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Boolean.class);
        }

        public void setPaused(Boolean value) {
            getDynamicProperties().put("paused", value);
        }

    }

    public static class WhitelistEntryAdded extends WhitelistLobEvent implements WhitelistEvent.WhitelistEntryAdded {

        @Override
        public String getEventType() {
            return "WhitelistEntryAdded";
        }

        public String getAccountAddress() {
            Object val = getDynamicProperties().get("accountAddress");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setAccountAddress(String value) {
            getDynamicProperties().put("accountAddress", value);
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

        public String getImageUrl() {
            Object val = getDynamicProperties().get("imageUrl");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setImageUrl(String value) {
            getDynamicProperties().put("imageUrl", value);
        }

        public String getDescription() {
            Object val = getDynamicProperties().get("description");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setDescription(String value) {
            getDynamicProperties().put("description", value);
        }

        public Long getBackgroundColor() {
            Object val = getDynamicProperties().get("backgroundColor");
            if (val instanceof Long) {
                return (Long) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Long.class);
        }

        public void setBackgroundColor(Long value) {
            getDynamicProperties().put("backgroundColor", value);
        }

        public Integer getRace() {
            Object val = getDynamicProperties().get("race");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setRace(Integer value) {
            getDynamicProperties().put("race", value);
        }

        public Integer getEyes() {
            Object val = getDynamicProperties().get("eyes");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setEyes(Integer value) {
            getDynamicProperties().put("eyes", value);
        }

        public Integer getMouth() {
            Object val = getDynamicProperties().get("mouth");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setMouth(Integer value) {
            getDynamicProperties().put("mouth", value);
        }

        public Integer getHaircut() {
            Object val = getDynamicProperties().get("haircut");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setHaircut(Integer value) {
            getDynamicProperties().put("haircut", value);
        }

        public Integer getSkin() {
            Object val = getDynamicProperties().get("skin");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setSkin(Integer value) {
            getDynamicProperties().put("skin", value);
        }

        public Integer getOutfit() {
            Object val = getDynamicProperties().get("outfit");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setOutfit(Integer value) {
            getDynamicProperties().put("outfit", value);
        }

        public Integer getAccessories() {
            Object val = getDynamicProperties().get("accessories");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setAccessories(Integer value) {
            getDynamicProperties().put("accessories", value);
        }

    }

    public static class WhitelistEntryUpdated extends WhitelistLobEvent implements WhitelistEvent.WhitelistEntryUpdated {

        @Override
        public String getEventType() {
            return "WhitelistEntryUpdated";
        }

        public String getAccountAddress() {
            Object val = getDynamicProperties().get("accountAddress");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setAccountAddress(String value) {
            getDynamicProperties().put("accountAddress", value);
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

        public String getImageUrl() {
            Object val = getDynamicProperties().get("imageUrl");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setImageUrl(String value) {
            getDynamicProperties().put("imageUrl", value);
        }

        public String getDescription() {
            Object val = getDynamicProperties().get("description");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setDescription(String value) {
            getDynamicProperties().put("description", value);
        }

        public Long getBackgroundColor() {
            Object val = getDynamicProperties().get("backgroundColor");
            if (val instanceof Long) {
                return (Long) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Long.class);
        }

        public void setBackgroundColor(Long value) {
            getDynamicProperties().put("backgroundColor", value);
        }

        public Integer getRace() {
            Object val = getDynamicProperties().get("race");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setRace(Integer value) {
            getDynamicProperties().put("race", value);
        }

        public Integer getEyes() {
            Object val = getDynamicProperties().get("eyes");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setEyes(Integer value) {
            getDynamicProperties().put("eyes", value);
        }

        public Integer getMouth() {
            Object val = getDynamicProperties().get("mouth");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setMouth(Integer value) {
            getDynamicProperties().put("mouth", value);
        }

        public Integer getHaircut() {
            Object val = getDynamicProperties().get("haircut");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setHaircut(Integer value) {
            getDynamicProperties().put("haircut", value);
        }

        public Integer getSkin() {
            Object val = getDynamicProperties().get("skin");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setSkin(Integer value) {
            getDynamicProperties().put("skin", value);
        }

        public Integer getOutfit() {
            Object val = getDynamicProperties().get("outfit");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setOutfit(Integer value) {
            getDynamicProperties().put("outfit", value);
        }

        public Integer getAccessories() {
            Object val = getDynamicProperties().get("accessories");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setAccessories(Integer value) {
            getDynamicProperties().put("accessories", value);
        }

        public Boolean getClaimed() {
            Object val = getDynamicProperties().get("claimed");
            if (val instanceof Boolean) {
                return (Boolean) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Boolean.class);
        }

        public void setClaimed(Boolean value) {
            getDynamicProperties().put("claimed", value);
        }

        public Boolean getPaused() {
            Object val = getDynamicProperties().get("paused");
            if (val instanceof Boolean) {
                return (Boolean) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Boolean.class);
        }

        public void setPaused(Boolean value) {
            getDynamicProperties().put("paused", value);
        }

    }

    public static class WhitelistClaimed extends WhitelistLobEvent implements WhitelistEvent.WhitelistClaimed {

        @Override
        public String getEventType() {
            return "WhitelistClaimed";
        }

        public String getAccountAddress() {
            Object val = getDynamicProperties().get("accountAddress");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setAccountAddress(String value) {
            getDynamicProperties().put("accountAddress", value);
        }

    }

    public static class WhitelistCreated extends WhitelistLobEvent implements WhitelistEvent.WhitelistCreated {

        @Override
        public String getEventType() {
            return "WhitelistCreated";
        }

    }


}

