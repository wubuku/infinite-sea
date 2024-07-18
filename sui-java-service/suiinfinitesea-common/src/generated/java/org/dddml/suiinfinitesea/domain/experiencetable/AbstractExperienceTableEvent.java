// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.experiencetable;

import java.util.*;
import org.dddml.suiinfinitesea.domain.*;
import java.util.Date;
import java.math.BigInteger;
import org.dddml.suiinfinitesea.specialization.*;
import org.dddml.suiinfinitesea.domain.AbstractEvent;

public abstract class AbstractExperienceTableEvent extends AbstractEvent implements ExperienceTableEvent.SqlExperienceTableEvent, SuiEventEnvelope.MutableSuiEventEnvelope, SuiMoveEvent.MutableSuiMoveEvent, HasEventStatus.MutableHasEventStatus {
    private ExperienceTableEventId experienceTableEventId = new ExperienceTableEventId();

    public ExperienceTableEventId getExperienceTableEventId() {
        return this.experienceTableEventId;
    }

    public void setExperienceTableEventId(ExperienceTableEventId eventId) {
        this.experienceTableEventId = eventId;
    }
    
    public String getId() {
        return getExperienceTableEventId().getId();
    }

    public void setId(String id) {
        getExperienceTableEventId().setId(id);
    }

    private boolean eventReadOnly;

    public boolean getEventReadOnly() { return this.eventReadOnly; }

    public void setEventReadOnly(boolean readOnly) { this.eventReadOnly = readOnly; }

    public BigInteger getVersion() {
        return getExperienceTableEventId().getVersion();
    }
    
    public void setVersion(BigInteger version) {
        getExperienceTableEventId().setVersion(version);
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

    protected AbstractExperienceTableEvent() {
    }

    protected AbstractExperienceTableEvent(ExperienceTableEventId eventId) {
        this.experienceTableEventId = eventId;
    }


    public abstract String getEventType();

    public static class ExperienceTableLobEvent extends AbstractExperienceTableEvent {

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
            return "ExperienceTableLobEvent";
        }

    }

    public static class InitExperienceTableEvent extends ExperienceTableLobEvent implements ExperienceTableEvent.InitExperienceTableEvent {

        @Override
        public String getEventType() {
            return "InitExperienceTableEvent";
        }

    }

    public static class ExperienceLevelAdded extends ExperienceTableLobEvent implements ExperienceTableEvent.ExperienceLevelAdded {

        @Override
        public String getEventType() {
            return "ExperienceLevelAdded";
        }

        public Integer getLevel() {
            Object val = getDynamicProperties().get("level");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setLevel(Integer value) {
            getDynamicProperties().put("level", value);
        }

        public Long getExperience() {
            Object val = getDynamicProperties().get("experience");
            if (val instanceof Long) {
                return (Long) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Long.class);
        }

        public void setExperience(Long value) {
            getDynamicProperties().put("experience", value);
        }

        public Long getDifference() {
            Object val = getDynamicProperties().get("difference");
            if (val instanceof Long) {
                return (Long) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Long.class);
        }

        public void setDifference(Long value) {
            getDynamicProperties().put("difference", value);
        }

    }

    public static class ExperienceLevelUpdated extends ExperienceTableLobEvent implements ExperienceTableEvent.ExperienceLevelUpdated {

        @Override
        public String getEventType() {
            return "ExperienceLevelUpdated";
        }

        public Integer getLevel() {
            Object val = getDynamicProperties().get("level");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setLevel(Integer value) {
            getDynamicProperties().put("level", value);
        }

        public Long getExperience() {
            Object val = getDynamicProperties().get("experience");
            if (val instanceof Long) {
                return (Long) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Long.class);
        }

        public void setExperience(Long value) {
            getDynamicProperties().put("experience", value);
        }

        public Long getDifference() {
            Object val = getDynamicProperties().get("difference");
            if (val instanceof Long) {
                return (Long) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Long.class);
        }

        public void setDifference(Long value) {
            getDynamicProperties().put("difference", value);
        }

    }


}

