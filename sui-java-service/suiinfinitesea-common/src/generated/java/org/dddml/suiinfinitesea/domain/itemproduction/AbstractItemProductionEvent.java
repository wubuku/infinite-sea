// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.itemproduction;

import java.util.*;
import org.dddml.suiinfinitesea.domain.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.specialization.*;
import org.dddml.suiinfinitesea.domain.AbstractEvent;

public abstract class AbstractItemProductionEvent extends AbstractEvent implements ItemProductionEvent.SqlItemProductionEvent, SuiEventEnvelope.MutableSuiEventEnvelope, SuiMoveEvent.MutableSuiMoveEvent, HasEventStatus.MutableHasEventStatus {
    private ItemProductionEventId itemProductionEventId = new ItemProductionEventId();

    public ItemProductionEventId getItemProductionEventId() {
        return this.itemProductionEventId;
    }

    public void setItemProductionEventId(ItemProductionEventId eventId) {
        this.itemProductionEventId = eventId;
    }
    
    public SkillTypeItemIdPair getItemProductionId() {
        return getItemProductionEventId().getItemProductionId();
    }

    public void setItemProductionId(SkillTypeItemIdPair itemProductionId) {
        getItemProductionEventId().setItemProductionId(itemProductionId);
    }

    private boolean eventReadOnly;

    public boolean getEventReadOnly() { return this.eventReadOnly; }

    public void setEventReadOnly(boolean readOnly) { this.eventReadOnly = readOnly; }

    public BigInteger getVersion() {
        return getItemProductionEventId().getVersion();
    }
    
    public void setVersion(BigInteger version) {
        getItemProductionEventId().setVersion(version);
    }

    private String id_;

    public String getId_() {
        return this.id_;
    }
    
    public void setId_(String id) {
        this.id_ = id;
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

    protected AbstractItemProductionEvent() {
    }

    protected AbstractItemProductionEvent(ItemProductionEventId eventId) {
        this.itemProductionEventId = eventId;
    }


    public abstract String getEventType();

    public static class ItemProductionLobEvent extends AbstractItemProductionEvent {

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
            return "ItemProductionLobEvent";
        }

    }

    public static class ItemProductionCreated extends ItemProductionLobEvent implements ItemProductionEvent.ItemProductionCreated {

        @Override
        public String getEventType() {
            return "ItemProductionCreated";
        }

        public ItemIdQuantityPairs getProductionMaterials() {
            Object val = getDynamicProperties().get("productionMaterials");
            if (val instanceof ItemIdQuantityPairs) {
                return (ItemIdQuantityPairs) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, ItemIdQuantityPairs.class);
        }

        public void setProductionMaterials(ItemIdQuantityPairs value) {
            getDynamicProperties().put("productionMaterials", value);
        }

        public Integer getRequirementsLevel() {
            Object val = getDynamicProperties().get("requirementsLevel");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setRequirementsLevel(Integer value) {
            getDynamicProperties().put("requirementsLevel", value);
        }

        public Long getBaseQuantity() {
            Object val = getDynamicProperties().get("baseQuantity");
            if (val instanceof Long) {
                return (Long) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Long.class);
        }

        public void setBaseQuantity(Long value) {
            getDynamicProperties().put("baseQuantity", value);
        }

        public Long getBaseExperience() {
            Object val = getDynamicProperties().get("baseExperience");
            if (val instanceof Long) {
                return (Long) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Long.class);
        }

        public void setBaseExperience(Long value) {
            getDynamicProperties().put("baseExperience", value);
        }

        public BigInteger getBaseCreationTime() {
            Object val = getDynamicProperties().get("baseCreationTime");
            if (val instanceof BigInteger) {
                return (BigInteger) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, BigInteger.class);
        }

        public void setBaseCreationTime(BigInteger value) {
            getDynamicProperties().put("baseCreationTime", value);
        }

        public BigInteger getEnergyCost() {
            Object val = getDynamicProperties().get("energyCost");
            if (val instanceof BigInteger) {
                return (BigInteger) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, BigInteger.class);
        }

        public void setEnergyCost(BigInteger value) {
            getDynamicProperties().put("energyCost", value);
        }

        public Integer getSuccessRate() {
            Object val = getDynamicProperties().get("successRate");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setSuccessRate(Integer value) {
            getDynamicProperties().put("successRate", value);
        }

    }

    public static class ItemProductionUpdated extends ItemProductionLobEvent implements ItemProductionEvent.ItemProductionUpdated {

        @Override
        public String getEventType() {
            return "ItemProductionUpdated";
        }

        public ItemIdQuantityPairs getProductionMaterials() {
            Object val = getDynamicProperties().get("productionMaterials");
            if (val instanceof ItemIdQuantityPairs) {
                return (ItemIdQuantityPairs) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, ItemIdQuantityPairs.class);
        }

        public void setProductionMaterials(ItemIdQuantityPairs value) {
            getDynamicProperties().put("productionMaterials", value);
        }

        public Integer getRequirementsLevel() {
            Object val = getDynamicProperties().get("requirementsLevel");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setRequirementsLevel(Integer value) {
            getDynamicProperties().put("requirementsLevel", value);
        }

        public Long getBaseQuantity() {
            Object val = getDynamicProperties().get("baseQuantity");
            if (val instanceof Long) {
                return (Long) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Long.class);
        }

        public void setBaseQuantity(Long value) {
            getDynamicProperties().put("baseQuantity", value);
        }

        public Long getBaseExperience() {
            Object val = getDynamicProperties().get("baseExperience");
            if (val instanceof Long) {
                return (Long) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Long.class);
        }

        public void setBaseExperience(Long value) {
            getDynamicProperties().put("baseExperience", value);
        }

        public BigInteger getBaseCreationTime() {
            Object val = getDynamicProperties().get("baseCreationTime");
            if (val instanceof BigInteger) {
                return (BigInteger) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, BigInteger.class);
        }

        public void setBaseCreationTime(BigInteger value) {
            getDynamicProperties().put("baseCreationTime", value);
        }

        public BigInteger getEnergyCost() {
            Object val = getDynamicProperties().get("energyCost");
            if (val instanceof BigInteger) {
                return (BigInteger) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, BigInteger.class);
        }

        public void setEnergyCost(BigInteger value) {
            getDynamicProperties().put("energyCost", value);
        }

        public Integer getSuccessRate() {
            Object val = getDynamicProperties().get("successRate");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setSuccessRate(Integer value) {
            getDynamicProperties().put("successRate", value);
        }

    }


}

