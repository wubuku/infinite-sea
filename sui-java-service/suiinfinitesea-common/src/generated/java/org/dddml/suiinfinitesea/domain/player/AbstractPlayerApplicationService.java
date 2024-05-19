// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.player;

import java.util.*;
import java.util.function.Consumer;
import org.dddml.support.criterion.Criterion;
import org.dddml.suiinfinitesea.domain.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.specialization.*;

public abstract class AbstractPlayerApplicationService implements PlayerApplicationService {

    private EventStore eventStore;

    protected EventStore getEventStore()
    {
        return eventStore;
    }

    private PlayerStateRepository stateRepository;

    protected PlayerStateRepository getStateRepository() {
        return stateRepository;
    }

    private PlayerStateQueryRepository stateQueryRepository;

    protected PlayerStateQueryRepository getStateQueryRepository() {
        return stateQueryRepository;
    }

    private AggregateEventListener<PlayerAggregate, PlayerState> aggregateEventListener;

    public AggregateEventListener<PlayerAggregate, PlayerState> getAggregateEventListener() {
        return aggregateEventListener;
    }

    public void setAggregateEventListener(AggregateEventListener<PlayerAggregate, PlayerState> eventListener) {
        this.aggregateEventListener = eventListener;
    }

    public AbstractPlayerApplicationService(EventStore eventStore, PlayerStateRepository stateRepository, PlayerStateQueryRepository stateQueryRepository) {
        this.eventStore = eventStore;
        this.stateRepository = stateRepository;
        this.stateQueryRepository = stateQueryRepository;
    }

    public void when(PlayerCommands.Create c) {
        update(c, ar -> ar.create(c.getName(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public void when(PlayerCommands.ClaimIsland c) {
        update(c, ar -> ar.claimIsland(c.getMap(), c.getCoordinates(), c.getClock(), c.getRosterTable(), c.getSkillProcessTable(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public void when(PlayerCommands.Airdrop c) {
        update(c, ar -> ar.airdrop(c.getItemId(), c.getQuantity(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public PlayerState get(String id) {
        PlayerState state = getStateRepository().get(id, true);
        return state;
    }

    public Iterable<PlayerState> getAll(Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().getAll(firstResult, maxResults);
    }

    public Iterable<PlayerState> get(Iterable<Map.Entry<String, Object>> filter, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().get(filter, orders, firstResult, maxResults);
    }

    public Iterable<PlayerState> get(Criterion filter, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().get(filter, orders, firstResult, maxResults);
    }

    public Iterable<PlayerState> getByProperty(String propertyName, Object propertyValue, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().getByProperty(propertyName, propertyValue, orders, firstResult, maxResults);
    }

    public long getCount(Iterable<Map.Entry<String, Object>> filter) {
        return getStateQueryRepository().getCount(filter);
    }

    public long getCount(Criterion filter) {
        return getStateQueryRepository().getCount(filter);
    }

    public PlayerEvent getEvent(String id, long version) {
        PlayerEvent e = (PlayerEvent)getEventStore().getEvent(toEventStoreAggregateId(id), version);
        if (e != null) {
            ((PlayerEvent.SqlPlayerEvent)e).setEventReadOnly(true); 
        } else if (version == -1) {
            return getEvent(id, 0);
        }
        return e;
    }

    public PlayerState getHistoryState(String id, long version) {
        EventStream eventStream = getEventStore().loadEventStream(AbstractPlayerEvent.class, toEventStoreAggregateId(id), version - 1);
        return new AbstractPlayerState.SimplePlayerState(eventStream.getEvents());
    }


    public PlayerAggregate getPlayerAggregate(PlayerState state) {
        return new AbstractPlayerAggregate.SimplePlayerAggregate(state);
    }

    public EventStoreAggregateId toEventStoreAggregateId(String aggregateId) {
        return new EventStoreAggregateId.SimpleEventStoreAggregateId(aggregateId);
    }

    protected void update(PlayerCommand c, Consumer<PlayerAggregate> action) {
        String aggregateId = c.getId();
        EventStoreAggregateId eventStoreAggregateId = toEventStoreAggregateId(aggregateId);
        PlayerState state = getStateRepository().get(aggregateId, false);
        boolean duplicate = isDuplicateCommand(c, eventStoreAggregateId, state);
        if (duplicate) { return; }

        PlayerAggregate aggregate = getPlayerAggregate(state);
        aggregate.throwOnInvalidStateTransition(c);
        action.accept(aggregate);
        persist(eventStoreAggregateId, c.getOffChainVersion() == null ? PlayerState.VERSION_NULL : c.getOffChainVersion(), aggregate, state); // State version may be null!

    }

    private void persist(EventStoreAggregateId eventStoreAggregateId, long version, PlayerAggregate aggregate, PlayerState state) {
        getEventStore().appendEvents(eventStoreAggregateId, version, 
            aggregate.getChanges(), (events) -> { 
                getStateRepository().save(state); 
            });
        if (aggregateEventListener != null) {
            aggregateEventListener.eventAppended(new AggregateEvent<>(aggregate, state, aggregate.getChanges()));
        }
    }

    protected boolean isDuplicateCommand(PlayerCommand command, EventStoreAggregateId eventStoreAggregateId, PlayerState state) {
        boolean duplicate = false;
        if (command.getOffChainVersion() == null) { command.setOffChainVersion(PlayerState.VERSION_NULL); }
        if (state.getOffChainVersion() != null && state.getOffChainVersion() > command.getOffChainVersion()) {
            Event lastEvent = getEventStore().getEvent(AbstractPlayerEvent.class, eventStoreAggregateId, command.getOffChainVersion());
            if (lastEvent != null && lastEvent instanceof AbstractEvent
               && command.getCommandId() != null && command.getCommandId().equals(((AbstractEvent) lastEvent).getCommandId())) {
                duplicate = true;
            }
        }
        return duplicate;
    }

    public static class SimplePlayerApplicationService extends AbstractPlayerApplicationService {
        public SimplePlayerApplicationService(EventStore eventStore, PlayerStateRepository stateRepository, PlayerStateQueryRepository stateQueryRepository)
        {
            super(eventStore, stateRepository, stateQueryRepository);
        }
    }

}

