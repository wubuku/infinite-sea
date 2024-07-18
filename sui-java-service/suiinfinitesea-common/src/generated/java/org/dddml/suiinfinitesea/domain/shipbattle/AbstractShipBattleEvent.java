// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.shipbattle;

import java.util.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.*;
import org.dddml.suiinfinitesea.domain.AbstractEvent;

public abstract class AbstractShipBattleEvent extends AbstractEvent implements ShipBattleEvent.SqlShipBattleEvent, SuiEventEnvelope.MutableSuiEventEnvelope, SuiMoveEvent.MutableSuiMoveEvent, HasEventStatus.MutableHasEventStatus {
    private ShipBattleEventId shipBattleEventId = new ShipBattleEventId();

    public ShipBattleEventId getShipBattleEventId() {
        return this.shipBattleEventId;
    }

    public void setShipBattleEventId(ShipBattleEventId eventId) {
        this.shipBattleEventId = eventId;
    }
    
    public String getId() {
        return getShipBattleEventId().getId();
    }

    public void setId(String id) {
        getShipBattleEventId().setId(id);
    }

    private boolean eventReadOnly;

    public boolean getEventReadOnly() { return this.eventReadOnly; }

    public void setEventReadOnly(boolean readOnly) { this.eventReadOnly = readOnly; }

    public BigInteger getVersion() {
        return getShipBattleEventId().getVersion();
    }
    
    public void setVersion(BigInteger version) {
        getShipBattleEventId().setVersion(version);
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

    protected AbstractShipBattleEvent() {
    }

    protected AbstractShipBattleEvent(ShipBattleEventId eventId) {
        this.shipBattleEventId = eventId;
    }


    public abstract String getEventType();

    public static class ShipBattleLobEvent extends AbstractShipBattleEvent {

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
            return "ShipBattleLobEvent";
        }

    }

    public static class ShipBattleInitiated extends ShipBattleLobEvent implements ShipBattleEvent.ShipBattleInitiated {

        @Override
        public String getEventType() {
            return "ShipBattleInitiated";
        }

        public String getInitiatorId() {
            Object val = getDynamicProperties().get("initiatorId");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setInitiatorId(String value) {
            getDynamicProperties().put("initiatorId", value);
        }

        public String getResponderId() {
            Object val = getDynamicProperties().get("responderId");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setResponderId(String value) {
            getDynamicProperties().put("responderId", value);
        }

        public BigInteger getStartedAt() {
            Object val = getDynamicProperties().get("startedAt");
            if (val instanceof BigInteger) {
                return (BigInteger) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, BigInteger.class);
        }

        public void setStartedAt(BigInteger value) {
            getDynamicProperties().put("startedAt", value);
        }

        public Integer getFirstRoundMover() {
            Object val = getDynamicProperties().get("firstRoundMover");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setFirstRoundMover(Integer value) {
            getDynamicProperties().put("firstRoundMover", value);
        }

        public String getFirstRoundAttackerShip() {
            Object val = getDynamicProperties().get("firstRoundAttackerShip");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setFirstRoundAttackerShip(String value) {
            getDynamicProperties().put("firstRoundAttackerShip", value);
        }

        public String getFirstRoundDefenderShip() {
            Object val = getDynamicProperties().get("firstRoundDefenderShip");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setFirstRoundDefenderShip(String value) {
            getDynamicProperties().put("firstRoundDefenderShip", value);
        }

    }

    public static class ShipBattleMoveMade extends ShipBattleLobEvent implements ShipBattleEvent.ShipBattleMoveMade {

        @Override
        public String getEventType() {
            return "ShipBattleMoveMade";
        }

        public Integer getAttackerCommand() {
            Object val = getDynamicProperties().get("attackerCommand");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setAttackerCommand(Integer value) {
            getDynamicProperties().put("attackerCommand", value);
        }

        public Integer getDefenderCommand() {
            Object val = getDynamicProperties().get("defenderCommand");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setDefenderCommand(Integer value) {
            getDynamicProperties().put("defenderCommand", value);
        }

        public Long getRoundNumber() {
            Object val = getDynamicProperties().get("roundNumber");
            if (val instanceof Long) {
                return (Long) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Long.class);
        }

        public void setRoundNumber(Long value) {
            getDynamicProperties().put("roundNumber", value);
        }

        public Long getDefenderDamageTaken() {
            Object val = getDynamicProperties().get("defenderDamageTaken");
            if (val instanceof Long) {
                return (Long) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Long.class);
        }

        public void setDefenderDamageTaken(Long value) {
            getDynamicProperties().put("defenderDamageTaken", value);
        }

        public Long getAttackerDamageTaken() {
            Object val = getDynamicProperties().get("attackerDamageTaken");
            if (val instanceof Long) {
                return (Long) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Long.class);
        }

        public void setAttackerDamageTaken(Long value) {
            getDynamicProperties().put("attackerDamageTaken", value);
        }

        public Boolean getIsBattleEnded() {
            Object val = getDynamicProperties().get("isBattleEnded");
            if (val instanceof Boolean) {
                return (Boolean) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Boolean.class);
        }

        public void setIsBattleEnded(Boolean value) {
            getDynamicProperties().put("isBattleEnded", value);
        }

        public Integer getWinner() {
            Object val = getDynamicProperties().get("winner");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setWinner(Integer value) {
            getDynamicProperties().put("winner", value);
        }

        public BigInteger getNextRoundStartedAt() {
            Object val = getDynamicProperties().get("nextRoundStartedAt");
            if (val instanceof BigInteger) {
                return (BigInteger) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, BigInteger.class);
        }

        public void setNextRoundStartedAt(BigInteger value) {
            getDynamicProperties().put("nextRoundStartedAt", value);
        }

        public Integer getNextRoundMover() {
            Object val = getDynamicProperties().get("nextRoundMover");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setNextRoundMover(Integer value) {
            getDynamicProperties().put("nextRoundMover", value);
        }

        public String getNextRoundAttackerShip() {
            Object val = getDynamicProperties().get("nextRoundAttackerShip");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setNextRoundAttackerShip(String value) {
            getDynamicProperties().put("nextRoundAttackerShip", value);
        }

        public String getNextRoundDefenderShip() {
            Object val = getDynamicProperties().get("nextRoundDefenderShip");
            if (val instanceof String) {
                return (String) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, String.class);
        }

        public void setNextRoundDefenderShip(String value) {
            getDynamicProperties().put("nextRoundDefenderShip", value);
        }

    }

    public static class ShipBattleLootTaken extends ShipBattleLobEvent implements ShipBattleEvent.ShipBattleLootTaken {

        @Override
        public String getEventType() {
            return "ShipBattleLootTaken";
        }

        public Integer getChoice() {
            Object val = getDynamicProperties().get("choice");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setChoice(Integer value) {
            getDynamicProperties().put("choice", value);
        }

        public ItemIdQuantityPair[] getLoot() {
            Object val = getDynamicProperties().get("loot");
            if (val instanceof ItemIdQuantityPair[]) {
                return (ItemIdQuantityPair[]) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, ItemIdQuantityPair[].class);
        }

        public void setLoot(ItemIdQuantityPair[] value) {
            getDynamicProperties().put("loot", value);
        }

        public BigInteger getLootedAt() {
            Object val = getDynamicProperties().get("lootedAt");
            if (val instanceof BigInteger) {
                return (BigInteger) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, BigInteger.class);
        }

        public void setLootedAt(BigInteger value) {
            getDynamicProperties().put("lootedAt", value);
        }

        public Long getIncreasedExperience() {
            Object val = getDynamicProperties().get("increasedExperience");
            if (val instanceof Long) {
                return (Long) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Long.class);
        }

        public void setIncreasedExperience(Long value) {
            getDynamicProperties().put("increasedExperience", value);
        }

        public Integer getNewLevel() {
            Object val = getDynamicProperties().get("newLevel");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setNewLevel(Integer value) {
            getDynamicProperties().put("newLevel", value);
        }

        public Long getLoserIncreasedExperience() {
            Object val = getDynamicProperties().get("loserIncreasedExperience");
            if (val instanceof Long) {
                return (Long) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Long.class);
        }

        public void setLoserIncreasedExperience(Long value) {
            getDynamicProperties().put("loserIncreasedExperience", value);
        }

        public Integer getLoserNewLevel() {
            Object val = getDynamicProperties().get("loserNewLevel");
            if (val instanceof Integer) {
                return (Integer) val;
            }
            return ApplicationContext.current.getTypeConverter().convertValue(val, Integer.class);
        }

        public void setLoserNewLevel(Integer value) {
            getDynamicProperties().put("loserNewLevel", value);
        }

    }


}

