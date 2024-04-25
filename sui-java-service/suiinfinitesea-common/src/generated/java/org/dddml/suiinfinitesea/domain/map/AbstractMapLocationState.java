// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.map;

import java.util.*;
import java.math.*;
import org.dddml.suiinfinitesea.domain.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.specialization.*;
import org.dddml.suiinfinitesea.domain.map.MapLocationEvent.*;

public abstract class AbstractMapLocationState implements MapLocationState.SqlMapLocationState {

    private MapLocationId mapLocationId = new MapLocationId();

    public MapLocationId getMapLocationId() {
        return this.mapLocationId;
    }

    public void setMapLocationId(MapLocationId mapLocationId) {
        this.mapLocationId = mapLocationId;
    }

    private transient MapState mapState;

    public MapState getMapState() {
        return mapState;
    }

    public void setMapState(MapState s) {
        mapState = s;
    }
    
    private MapState protectedMapState;

    protected MapState getProtectedMapState() {
        return protectedMapState;
    }

    protected void setProtectedMapState(MapState protectedMapState) {
        this.protectedMapState = protectedMapState;
    }

    public String getMapId() {
        return this.getMapLocationId().getMapId();
    }
        
    public void setMapId(String mapId) {
        this.getMapLocationId().setMapId(mapId);
    }

    public Coordinates getCoordinates() {
        return this.getMapLocationId().getCoordinates();
    }
        
    public void setCoordinates(Coordinates coordinates) {
        this.getMapLocationId().setCoordinates(coordinates);
    }

    private Long type;

    public Long getType() {
        return this.type;
    }

    public void setType(Long type) {
        this.type = type;
    }

    private String occupiedBy;

    public String getOccupiedBy() {
        return this.occupiedBy;
    }

    public void setOccupiedBy(String occupiedBy) {
        this.occupiedBy = occupiedBy;
    }

    private BigInteger gatheredAt;

    public BigInteger getGatheredAt() {
        return this.gatheredAt;
    }

    public void setGatheredAt(BigInteger gatheredAt) {
        this.gatheredAt = gatheredAt;
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

    private Set<ItemIdQuantityPair> resources;

    public Set<ItemIdQuantityPair> getResources() {
        return this.resources;
    }

    public void setResources(Set<ItemIdQuantityPair> resources) {
        this.resources = resources;
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


    public AbstractMapLocationState() {
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
        return getCoordinates().hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) { return true; }
        if (obj instanceof MapLocationState) {
            return Objects.equals(this.getCoordinates(), ((MapLocationState)obj).getCoordinates());
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

    public void merge(MapLocationState s) {
        if (s == this) {
            return;
        }
        this.setType(s.getType());
        this.setOccupiedBy(s.getOccupiedBy());
        this.setResources(s.getResources());
        this.setGatheredAt(s.getGatheredAt());
        this.setActive(s.getActive());
    }

    public void save() {
    }

    protected void throwOnWrongEvent(MapLocationEvent event) {
        String stateEntityIdMapId = this.getMapLocationId().getMapId();
        String eventEntityIdMapId = ((MapLocationEvent.SqlMapLocationEvent)event).getMapLocationEventId().getMapId();
        if (!stateEntityIdMapId.equals(eventEntityIdMapId)) {
            throw DomainError.named("mutateWrongEntity", "Entity Id MapId %1$s in state but entity id MapId %2$s in event", stateEntityIdMapId, eventEntityIdMapId);
        }

        Coordinates stateEntityIdCoordinates = this.getMapLocationId().getCoordinates();
        Coordinates eventEntityIdCoordinates = ((MapLocationEvent.SqlMapLocationEvent)event).getMapLocationEventId().getCoordinates();
        if (!stateEntityIdCoordinates.equals(eventEntityIdCoordinates)) {
            throw DomainError.named("mutateWrongEntity", "Entity Id Coordinates %1$s in state but entity id Coordinates %2$s in event", stateEntityIdCoordinates, eventEntityIdCoordinates);
        }


        if (getForReapplying()) { return; }

    }


    public static class SimpleMapLocationState extends AbstractMapLocationState {

        public SimpleMapLocationState() {
        }

        public static SimpleMapLocationState newForReapplying() {
            SimpleMapLocationState s = new SimpleMapLocationState();
            s.initializeForReapplying();
            return s;
        }

    }



}
