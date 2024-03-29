// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.skillprocessmutex;

import java.util.*;
import java.math.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.*;
import org.dddml.suiinfinitesea.domain.skillprocessmutex.SkillProcessMutexEvent.*;

public abstract class AbstractSkillProcessMutexState implements SkillProcessMutexState.SqlSkillProcessMutexState {

    private String playerId;

    public String getPlayerId() {
        return this.playerId;
    }

    public void setPlayerId(String playerId) {
        this.playerId = playerId;
    }

    private String id_;

    public String getId_() {
        return this.id_;
    }

    public void setId_(String id) {
        this.id_ = id;
    }

    private Integer activeSkillType;

    public Integer getActiveSkillType() {
        return this.activeSkillType;
    }

    public void setActiveSkillType(Integer activeSkillType) {
        this.activeSkillType = activeSkillType;
    }

    private BigInteger version;

    public BigInteger getVersion() {
        return this.version;
    }

    public void setVersion(BigInteger version) {
        this.version = version;
    }

    private Long offChainVersion;

    public Long getOffChainVersion() {
        return this.offChainVersion;
    }

    public void setOffChainVersion(Long offChainVersion) {
        this.offChainVersion = offChainVersion;
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

    private String updatedBy;

    public String getUpdatedBy() {
        return this.updatedBy;
    }

    public void setUpdatedBy(String updatedBy) {
        this.updatedBy = updatedBy;
    }

    private Date updatedAt;

    public Date getUpdatedAt() {
        return this.updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    private Boolean active;

    public Boolean getActive() {
        return this.active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    private Boolean deleted;

    public Boolean getDeleted() {
        return this.deleted;
    }

    public void setDeleted(Boolean deleted) {
        this.deleted = deleted;
    }

    public boolean isStateUnsaved() {
        return this.getOffChainVersion() == null;
    }

    private Boolean stateReadOnly;

    public Boolean getStateReadOnly() { return this.stateReadOnly; }

    public void setStateReadOnly(Boolean readOnly) { this.stateReadOnly = readOnly; }

    private boolean forReapplying;

    public boolean getForReapplying() {
        return forReapplying;
    }

    public void setForReapplying(boolean forReapplying) {
        this.forReapplying = forReapplying;
    }

    public AbstractSkillProcessMutexState(List<Event> events) {
        initializeForReapplying();
        if (events != null && events.size() > 0) {
            this.setPlayerId(((SkillProcessMutexEvent.SqlSkillProcessMutexEvent) events.get(0)).getSkillProcessMutexEventId().getPlayerId());
            for (Event e : events) {
                mutate(e);
                this.setOffChainVersion((this.getOffChainVersion() == null ? SkillProcessMutexState.VERSION_NULL : this.getOffChainVersion()) + 1);
            }
        }
    }


    public AbstractSkillProcessMutexState() {
        initializeProperties();
    }

    protected void initializeForReapplying() {
        this.forReapplying = true;

        initializeProperties();
    }
    
    protected void initializeProperties() {
    }

    @Override
    public int hashCode() {
        return getPlayerId().hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) { return true; }
        if (obj instanceof SkillProcessMutexState) {
            return Objects.equals(this.getPlayerId(), ((SkillProcessMutexState)obj).getPlayerId());
        }
        return false;
    }


    public void mutate(Event e) {
        setStateReadOnly(false);
        if (false) { 
            ;
        } else if (e instanceof AbstractSkillProcessMutexEvent.SkillProcessMutexCreated) {
            when((AbstractSkillProcessMutexEvent.SkillProcessMutexCreated)e);
        } else if (e instanceof AbstractSkillProcessMutexEvent.SkillProcessMutexLocked) {
            when((AbstractSkillProcessMutexEvent.SkillProcessMutexLocked)e);
        } else if (e instanceof AbstractSkillProcessMutexEvent.SkillProcessMutexUnlocked) {
            when((AbstractSkillProcessMutexEvent.SkillProcessMutexUnlocked)e);
        } else {
            throw new UnsupportedOperationException(String.format("Unsupported event type: %1$s", e.getClass().getName()));
        }
    }

    public void merge(SkillProcessMutexState s) {
        if (s == this) {
            return;
        }
        this.setActiveSkillType(s.getActiveSkillType());
        this.setVersion(s.getVersion());
        this.setActive(s.getActive());
    }

    public void when(AbstractSkillProcessMutexEvent.SkillProcessMutexCreated e) {
        throwOnWrongEvent(e);

        Long suiTimestamp = e.getSuiTimestamp();
        Long SuiTimestamp = suiTimestamp;
        String suiTxDigest = e.getSuiTxDigest();
        String SuiTxDigest = suiTxDigest;
        BigInteger suiEventSeq = e.getSuiEventSeq();
        BigInteger SuiEventSeq = suiEventSeq;
        String suiPackageId = e.getSuiPackageId();
        String SuiPackageId = suiPackageId;
        String suiTransactionModule = e.getSuiTransactionModule();
        String SuiTransactionModule = suiTransactionModule;
        String suiSender = e.getSuiSender();
        String SuiSender = suiSender;
        String suiType = e.getSuiType();
        String SuiType = suiType;
        String status = e.getStatus();
        String Status = status;

        if (this.getCreatedBy() == null){
            this.setCreatedBy(e.getCreatedBy());
        }
        if (this.getCreatedAt() == null){
            this.setCreatedAt(e.getCreatedAt());
        }
        this.setUpdatedBy(e.getCreatedBy());
        this.setUpdatedAt(e.getCreatedAt());

        SkillProcessMutexState updatedSkillProcessMutexState = (SkillProcessMutexState) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.skillprocessmutex.CreateLogic",
                    "mutate",
                    new Class[]{SkillProcessMutexState.class, Long.class, String.class, BigInteger.class, String.class, String.class, String.class, String.class, String.class, MutationContext.class},
                    new Object[]{this, suiTimestamp, suiTxDigest, suiEventSeq, suiPackageId, suiTransactionModule, suiSender, suiType, status, MutationContext.forEvent(e, s -> {if (s == this) {return this;} else {throw new UnsupportedOperationException();}})}
            );

//package org.dddml.suiinfinitesea.domain.skillprocessmutex;
//
//public class CreateLogic {
//    public static SkillProcessMutexState mutate(SkillProcessMutexState skillProcessMutexState, Long suiTimestamp, String suiTxDigest, BigInteger suiEventSeq, String suiPackageId, String suiTransactionModule, String suiSender, String suiType, String status, MutationContext<SkillProcessMutexState, SkillProcessMutexState.MutableSkillProcessMutexState> mutationContext) {
//    }
//}

        if (this != updatedSkillProcessMutexState) { merge(updatedSkillProcessMutexState); } //else do nothing

    }

    public void when(AbstractSkillProcessMutexEvent.SkillProcessMutexLocked e) {
        throwOnWrongEvent(e);

        Integer skillType = e.getSkillType();
        Integer SkillType = skillType;
        Long suiTimestamp = e.getSuiTimestamp();
        Long SuiTimestamp = suiTimestamp;
        String suiTxDigest = e.getSuiTxDigest();
        String SuiTxDigest = suiTxDigest;
        BigInteger suiEventSeq = e.getSuiEventSeq();
        BigInteger SuiEventSeq = suiEventSeq;
        String suiPackageId = e.getSuiPackageId();
        String SuiPackageId = suiPackageId;
        String suiTransactionModule = e.getSuiTransactionModule();
        String SuiTransactionModule = suiTransactionModule;
        String suiSender = e.getSuiSender();
        String SuiSender = suiSender;
        String suiType = e.getSuiType();
        String SuiType = suiType;
        String status = e.getStatus();
        String Status = status;

        if (this.getCreatedBy() == null){
            this.setCreatedBy(e.getCreatedBy());
        }
        if (this.getCreatedAt() == null){
            this.setCreatedAt(e.getCreatedAt());
        }
        this.setUpdatedBy(e.getCreatedBy());
        this.setUpdatedAt(e.getCreatedAt());

        SkillProcessMutexState updatedSkillProcessMutexState = (SkillProcessMutexState) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.skillprocessmutex.LockLogic",
                    "mutate",
                    new Class[]{SkillProcessMutexState.class, Integer.class, Long.class, String.class, BigInteger.class, String.class, String.class, String.class, String.class, String.class, MutationContext.class},
                    new Object[]{this, skillType, suiTimestamp, suiTxDigest, suiEventSeq, suiPackageId, suiTransactionModule, suiSender, suiType, status, MutationContext.forEvent(e, s -> {if (s == this) {return this;} else {throw new UnsupportedOperationException();}})}
            );

//package org.dddml.suiinfinitesea.domain.skillprocessmutex;
//
//public class LockLogic {
//    public static SkillProcessMutexState mutate(SkillProcessMutexState skillProcessMutexState, Integer skillType, Long suiTimestamp, String suiTxDigest, BigInteger suiEventSeq, String suiPackageId, String suiTransactionModule, String suiSender, String suiType, String status, MutationContext<SkillProcessMutexState, SkillProcessMutexState.MutableSkillProcessMutexState> mutationContext) {
//    }
//}

        if (this != updatedSkillProcessMutexState) { merge(updatedSkillProcessMutexState); } //else do nothing

    }

    public void when(AbstractSkillProcessMutexEvent.SkillProcessMutexUnlocked e) {
        throwOnWrongEvent(e);

        Integer skillType = e.getSkillType();
        Integer SkillType = skillType;
        Long suiTimestamp = e.getSuiTimestamp();
        Long SuiTimestamp = suiTimestamp;
        String suiTxDigest = e.getSuiTxDigest();
        String SuiTxDigest = suiTxDigest;
        BigInteger suiEventSeq = e.getSuiEventSeq();
        BigInteger SuiEventSeq = suiEventSeq;
        String suiPackageId = e.getSuiPackageId();
        String SuiPackageId = suiPackageId;
        String suiTransactionModule = e.getSuiTransactionModule();
        String SuiTransactionModule = suiTransactionModule;
        String suiSender = e.getSuiSender();
        String SuiSender = suiSender;
        String suiType = e.getSuiType();
        String SuiType = suiType;
        String status = e.getStatus();
        String Status = status;

        if (this.getCreatedBy() == null){
            this.setCreatedBy(e.getCreatedBy());
        }
        if (this.getCreatedAt() == null){
            this.setCreatedAt(e.getCreatedAt());
        }
        this.setUpdatedBy(e.getCreatedBy());
        this.setUpdatedAt(e.getCreatedAt());

        SkillProcessMutexState updatedSkillProcessMutexState = (SkillProcessMutexState) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.skillprocessmutex.UnlockLogic",
                    "mutate",
                    new Class[]{SkillProcessMutexState.class, Integer.class, Long.class, String.class, BigInteger.class, String.class, String.class, String.class, String.class, String.class, MutationContext.class},
                    new Object[]{this, skillType, suiTimestamp, suiTxDigest, suiEventSeq, suiPackageId, suiTransactionModule, suiSender, suiType, status, MutationContext.forEvent(e, s -> {if (s == this) {return this;} else {throw new UnsupportedOperationException();}})}
            );

//package org.dddml.suiinfinitesea.domain.skillprocessmutex;
//
//public class UnlockLogic {
//    public static SkillProcessMutexState mutate(SkillProcessMutexState skillProcessMutexState, Integer skillType, Long suiTimestamp, String suiTxDigest, BigInteger suiEventSeq, String suiPackageId, String suiTransactionModule, String suiSender, String suiType, String status, MutationContext<SkillProcessMutexState, SkillProcessMutexState.MutableSkillProcessMutexState> mutationContext) {
//    }
//}

        if (this != updatedSkillProcessMutexState) { merge(updatedSkillProcessMutexState); } //else do nothing

    }

    public void save() {
    }

    protected void throwOnWrongEvent(SkillProcessMutexEvent event) {
        String stateEntityId = this.getPlayerId(); // Aggregate Id
        String eventEntityId = ((SkillProcessMutexEvent.SqlSkillProcessMutexEvent)event).getSkillProcessMutexEventId().getPlayerId(); // EntityBase.Aggregate.GetEventIdPropertyIdName();
        if (!stateEntityId.equals(eventEntityId)) {
            throw DomainError.named("mutateWrongEntity", "Entity Id %1$s in state but entity id %2$s in event", stateEntityId, eventEntityId);
        }


        Long stateVersion = this.getOffChainVersion();

    }


    public static class SimpleSkillProcessMutexState extends AbstractSkillProcessMutexState {

        public SimpleSkillProcessMutexState() {
        }

        public SimpleSkillProcessMutexState(List<Event> events) {
            super(events);
        }

        public static SimpleSkillProcessMutexState newForReapplying() {
            SimpleSkillProcessMutexState s = new SimpleSkillProcessMutexState();
            s.initializeForReapplying();
            return s;
        }

    }



}

