// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.whitelist;

import java.util.*;
import java.math.*;
import java.util.Date;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.*;
import org.dddml.suiinfinitesea.domain.whitelist.WhitelistEntryEvent.*;

public abstract class AbstractWhitelistEntryState implements WhitelistEntryState.SqlWhitelistEntryState {

    private WhitelistEntryId whitelistEntryId = new WhitelistEntryId();

    public WhitelistEntryId getWhitelistEntryId() {
        return this.whitelistEntryId;
    }

    public void setWhitelistEntryId(WhitelistEntryId whitelistEntryId) {
        this.whitelistEntryId = whitelistEntryId;
    }

    private transient WhitelistState whitelistState;

    public WhitelistState getWhitelistState() {
        return whitelistState;
    }

    public void setWhitelistState(WhitelistState s) {
        whitelistState = s;
    }
    
    private WhitelistState protectedWhitelistState;

    protected WhitelistState getProtectedWhitelistState() {
        return protectedWhitelistState;
    }

    protected void setProtectedWhitelistState(WhitelistState protectedWhitelistState) {
        this.protectedWhitelistState = protectedWhitelistState;
    }

    public String getWhitelistId() {
        return this.getWhitelistEntryId().getWhitelistId();
    }
        
    public void setWhitelistId(String whitelistId) {
        this.getWhitelistEntryId().setWhitelistId(whitelistId);
    }

    public String getAccountAddress() {
        return this.getWhitelistEntryId().getAccountAddress();
    }
        
    public void setAccountAddress(String accountAddress) {
        this.getWhitelistEntryId().setAccountAddress(accountAddress);
    }

    private String name;

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    private String imageUrl;

    public String getImageUrl() {
        return this.imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    private String description;

    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    private Long backgroundColor;

    public Long getBackgroundColor() {
        return this.backgroundColor;
    }

    public void setBackgroundColor(Long backgroundColor) {
        this.backgroundColor = backgroundColor;
    }

    private Integer race;

    public Integer getRace() {
        return this.race;
    }

    public void setRace(Integer race) {
        this.race = race;
    }

    private Integer eyes;

    public Integer getEyes() {
        return this.eyes;
    }

    public void setEyes(Integer eyes) {
        this.eyes = eyes;
    }

    private Integer mouth;

    public Integer getMouth() {
        return this.mouth;
    }

    public void setMouth(Integer mouth) {
        this.mouth = mouth;
    }

    private Integer haircut;

    public Integer getHaircut() {
        return this.haircut;
    }

    public void setHaircut(Integer haircut) {
        this.haircut = haircut;
    }

    private Integer skin;

    public Integer getSkin() {
        return this.skin;
    }

    public void setSkin(Integer skin) {
        this.skin = skin;
    }

    private Integer outfit;

    public Integer getOutfit() {
        return this.outfit;
    }

    public void setOutfit(Integer outfit) {
        this.outfit = outfit;
    }

    private Integer accessories;

    public Integer getAccessories() {
        return this.accessories;
    }

    public void setAccessories(Integer accessories) {
        this.accessories = accessories;
    }

    private Boolean claimed;

    public Boolean getClaimed() {
        return this.claimed;
    }

    public void setClaimed(Boolean claimed) {
        this.claimed = claimed;
    }

    private Boolean paused;

    public Boolean getPaused() {
        return this.paused;
    }

    public void setPaused(Boolean paused) {
        this.paused = paused;
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


    public AbstractWhitelistEntryState() {
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
        return getAccountAddress().hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) { return true; }
        if (obj instanceof WhitelistEntryState) {
            return Objects.equals(this.getAccountAddress(), ((WhitelistEntryState)obj).getAccountAddress());
        }
        return false;
    }


    public void mutate(Event e) {
        setStateReadOnly(false);
        if (false) { 
            ;
        } else {
            throw new UnsupportedOperationException(String.format("Unsupported event type: %1$s", e.getClass().getName()));
        }
    }

    public void merge(WhitelistEntryState s) {
        if (s == this) {
            return;
        }
        this.setName(s.getName());
        this.setImageUrl(s.getImageUrl());
        this.setDescription(s.getDescription());
        this.setBackgroundColor(s.getBackgroundColor());
        this.setRace(s.getRace());
        this.setEyes(s.getEyes());
        this.setMouth(s.getMouth());
        this.setHaircut(s.getHaircut());
        this.setSkin(s.getSkin());
        this.setOutfit(s.getOutfit());
        this.setAccessories(s.getAccessories());
        this.setClaimed(s.getClaimed());
        this.setPaused(s.getPaused());
        this.setActive(s.getActive());
    }

    public void save() {
    }

    protected void throwOnWrongEvent(WhitelistEntryEvent event) {
        String stateEntityIdWhitelistId = this.getWhitelistEntryId().getWhitelistId();
        String eventEntityIdWhitelistId = ((WhitelistEntryEvent.SqlWhitelistEntryEvent)event).getWhitelistEntryEventId().getWhitelistId();
        if (!stateEntityIdWhitelistId.equals(eventEntityIdWhitelistId)) {
            throw DomainError.named("mutateWrongEntity", "Entity Id WhitelistId %1$s in state but entity id WhitelistId %2$s in event", stateEntityIdWhitelistId, eventEntityIdWhitelistId);
        }

        String stateEntityIdAccountAddress = this.getWhitelistEntryId().getAccountAddress();
        String eventEntityIdAccountAddress = ((WhitelistEntryEvent.SqlWhitelistEntryEvent)event).getWhitelistEntryEventId().getAccountAddress();
        if (!stateEntityIdAccountAddress.equals(eventEntityIdAccountAddress)) {
            throw DomainError.named("mutateWrongEntity", "Entity Id AccountAddress %1$s in state but entity id AccountAddress %2$s in event", stateEntityIdAccountAddress, eventEntityIdAccountAddress);
        }


        if (getForReapplying()) { return; }

    }


    public static class SimpleWhitelistEntryState extends AbstractWhitelistEntryState {

        public SimpleWhitelistEntryState() {
        }

        public static SimpleWhitelistEntryState newForReapplying() {
            SimpleWhitelistEntryState s = new SimpleWhitelistEntryState();
            s.initializeForReapplying();
            return s;
        }

    }



}
