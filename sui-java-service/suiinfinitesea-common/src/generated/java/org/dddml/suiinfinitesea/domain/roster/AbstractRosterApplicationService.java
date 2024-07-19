// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.roster;

import java.util.*;
import java.util.function.Consumer;
import org.dddml.support.criterion.Criterion;
import org.dddml.suiinfinitesea.domain.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.specialization.*;

public abstract class AbstractRosterApplicationService implements RosterApplicationService {

    private EventStore eventStore;

    protected EventStore getEventStore()
    {
        return eventStore;
    }

    private RosterStateRepository stateRepository;

    protected RosterStateRepository getStateRepository() {
        return stateRepository;
    }

    private RosterStateQueryRepository stateQueryRepository;

    protected RosterStateQueryRepository getStateQueryRepository() {
        return stateQueryRepository;
    }

    private AggregateEventListener<RosterAggregate, RosterState> aggregateEventListener;

    public AggregateEventListener<RosterAggregate, RosterState> getAggregateEventListener() {
        return aggregateEventListener;
    }

    public void setAggregateEventListener(AggregateEventListener<RosterAggregate, RosterState> eventListener) {
        this.aggregateEventListener = eventListener;
    }

    public AbstractRosterApplicationService(EventStore eventStore, RosterStateRepository stateRepository, RosterStateQueryRepository stateQueryRepository) {
        this.eventStore = eventStore;
        this.stateRepository = stateRepository;
        this.stateQueryRepository = stateQueryRepository;
    }

    public void when(RosterCommands.Create c) {
        update(c, ar -> ar.create(c.getStatus(), c.getSpeed(), c.getUpdatedCoordinates(), c.getCoordinatesUpdatedAt(), c.getTargetCoordinates(), c.getOriginCoordinates(), c.getShipBattleId(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public void when(RosterCommands.CreateEnvironmentRoster c) {
        update(c, ar -> ar.createEnvironmentRoster(c.getCoordinates(), c.getShipResourceQuantity(), c.getShipBaseResourceQuantity(), c.getBaseExperience(), c.getClock(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public void when(RosterCommands.AddShip c) {
        update(c, ar -> ar.addShip(c.getShip(), c.getPosition(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public void when(RosterCommands.UpdateLocation c) {
        update(c, ar -> ar.updateLocation(c.getClock(), c.getUpdatedCoordinates(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public void when(RosterCommands.AdjustShipsPosition c) {
        update(c, ar -> ar.adjustShipsPosition(c.getPlayer(), c.getPositions(), c.getShipIds(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public void when(RosterCommands.TransferShip c) {
        update(c, ar -> ar.transferShip(c.getPlayer(), c.getShipId(), c.getToRoster(), c.getToPosition(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public void when(RosterCommands.TransferShipInventory c) {
        update(c, ar -> ar.transferShipInventory(c.getPlayer(), c.getFromShipId(), c.getToShipId(), c.getItemIdQuantityPairs(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public void when(RosterCommands.TakeOutShipInventory c) {
        update(c, ar -> ar.takeOutShipInventory(c.getPlayer(), c.getClock(), c.getShipId(), c.getItemIdQuantityPairs(), c.getUpdatedCoordinates(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public void when(RosterCommands.PutInShipInventory c) {
        update(c, ar -> ar.putInShipInventory(c.getPlayer(), c.getClock(), c.getShipId(), c.getItemIdQuantityPairs(), c.getUpdatedCoordinates(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public RosterState get(RosterId id) {
        RosterState state = getStateRepository().get(id, true);
        return state;
    }

    public Iterable<RosterState> getAll(Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().getAll(firstResult, maxResults);
    }

    public Iterable<RosterState> get(Iterable<Map.Entry<String, Object>> filter, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().get(filter, orders, firstResult, maxResults);
    }

    public Iterable<RosterState> get(Criterion filter, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().get(filter, orders, firstResult, maxResults);
    }

    public Iterable<RosterState> getByProperty(String propertyName, Object propertyValue, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().getByProperty(propertyName, propertyValue, orders, firstResult, maxResults);
    }

    public long getCount(Iterable<Map.Entry<String, Object>> filter) {
        return getStateQueryRepository().getCount(filter);
    }

    public long getCount(Criterion filter) {
        return getStateQueryRepository().getCount(filter);
    }

    public RosterEvent getEvent(RosterId rosterId, long version) {
        RosterEvent e = (RosterEvent)getEventStore().getEvent(toEventStoreAggregateId(rosterId), version);
        if (e != null) {
            ((RosterEvent.SqlRosterEvent)e).setEventReadOnly(true); 
        } else if (version == -1) {
            return getEvent(rosterId, 0);
        }
        return e;
    }

    public RosterState getHistoryState(RosterId rosterId, long version) {
        EventStream eventStream = getEventStore().loadEventStream(AbstractRosterEvent.class, toEventStoreAggregateId(rosterId), version - 1);
        return new AbstractRosterState.SimpleRosterState(eventStream.getEvents());
    }

    public RosterShipsItemState getRosterShipsItem(RosterId rosterId, String key) {
        return getStateQueryRepository().getRosterShipsItem(rosterId, key);
    }

    public Iterable<RosterShipsItemState> getRosterShipsItems(RosterId rosterId, Criterion filter, List<String> orders) {
        return getStateQueryRepository().getRosterShipsItems(rosterId, filter, orders);
    }


    public RosterAggregate getRosterAggregate(RosterState state) {
        return new AbstractRosterAggregate.SimpleRosterAggregate(state);
    }

    public EventStoreAggregateId toEventStoreAggregateId(RosterId aggregateId) {
        return new EventStoreAggregateId.SimpleEventStoreAggregateId(aggregateId);
    }

    protected void update(RosterCommand c, Consumer<RosterAggregate> action) {
        RosterId aggregateId = c.getRosterId();
        EventStoreAggregateId eventStoreAggregateId = toEventStoreAggregateId(aggregateId);
        RosterState state = getStateRepository().get(aggregateId, false);
        boolean duplicate = isDuplicateCommand(c, eventStoreAggregateId, state);
        if (duplicate) { return; }

        RosterAggregate aggregate = getRosterAggregate(state);
        aggregate.throwOnInvalidStateTransition(c);
        action.accept(aggregate);
        persist(eventStoreAggregateId, c.getOffChainVersion() == null ? RosterState.VERSION_NULL : c.getOffChainVersion(), aggregate, state); // State version may be null!

    }

    private void persist(EventStoreAggregateId eventStoreAggregateId, long version, RosterAggregate aggregate, RosterState state) {
        getEventStore().appendEvents(eventStoreAggregateId, version, 
            aggregate.getChanges(), (events) -> { 
                getStateRepository().save(state); 
            });
        if (aggregateEventListener != null) {
            aggregateEventListener.eventAppended(new AggregateEvent<>(aggregate, state, aggregate.getChanges()));
        }
    }

    protected boolean isDuplicateCommand(RosterCommand command, EventStoreAggregateId eventStoreAggregateId, RosterState state) {
        boolean duplicate = false;
        if (command.getOffChainVersion() == null) { command.setOffChainVersion(RosterState.VERSION_NULL); }
        if (state.getOffChainVersion() != null && state.getOffChainVersion() > command.getOffChainVersion()) {
            Event lastEvent = getEventStore().getEvent(AbstractRosterEvent.class, eventStoreAggregateId, command.getOffChainVersion());
            if (lastEvent != null && lastEvent instanceof AbstractEvent
               && command.getCommandId() != null && command.getCommandId().equals(((AbstractEvent) lastEvent).getCommandId())) {
                duplicate = true;
            }
        }
        return duplicate;
    }

    public static class SimpleRosterApplicationService extends AbstractRosterApplicationService {
        public SimpleRosterApplicationService(EventStore eventStore, RosterStateRepository stateRepository, RosterStateQueryRepository stateQueryRepository)
        {
            super(eventStore, stateRepository, stateQueryRepository);
        }
    }

}

