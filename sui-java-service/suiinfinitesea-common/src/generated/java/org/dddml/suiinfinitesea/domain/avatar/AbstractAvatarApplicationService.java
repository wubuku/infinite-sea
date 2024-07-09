// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.avatar;

import java.util.*;
import java.util.function.Consumer;
import org.dddml.support.criterion.Criterion;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.*;

public abstract class AbstractAvatarApplicationService implements AvatarApplicationService {

    private EventStore eventStore;

    protected EventStore getEventStore()
    {
        return eventStore;
    }

    private AvatarStateRepository stateRepository;

    protected AvatarStateRepository getStateRepository() {
        return stateRepository;
    }

    private AvatarStateQueryRepository stateQueryRepository;

    protected AvatarStateQueryRepository getStateQueryRepository() {
        return stateQueryRepository;
    }

    private AggregateEventListener<AvatarAggregate, AvatarState> aggregateEventListener;

    public AggregateEventListener<AvatarAggregate, AvatarState> getAggregateEventListener() {
        return aggregateEventListener;
    }

    public void setAggregateEventListener(AggregateEventListener<AvatarAggregate, AvatarState> eventListener) {
        this.aggregateEventListener = eventListener;
    }

    public AbstractAvatarApplicationService(EventStore eventStore, AvatarStateRepository stateRepository, AvatarStateQueryRepository stateQueryRepository) {
        this.eventStore = eventStore;
        this.stateRepository = stateRepository;
        this.stateQueryRepository = stateQueryRepository;
    }

    public void when(AvatarCommands.Mint c) {
        update(c, ar -> ar.mint(c.getOwner(), c.getName(), c.getImageUrl(), c.getDescription(), c.getBackgroundColor(), c.getRace(), c.getEyes(), c.getMouth(), c.getHaircut(), c.getSkin(), c.getOutfit(), c.getAccessories(), c.getAura(), c.getSymbols(), c.getEffects(), c.getBackgrounds(), c.getDecorations(), c.getBadges(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public void when(AvatarCommands.Update c) {
        update(c, ar -> ar.update(c.getAvatarChange(), c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public void when(AvatarCommands.Burn c) {
        update(c, ar -> ar.burn(c.getOffChainVersion(), c.getCommandId(), c.getRequesterId(), c));
    }

    public AvatarState get(String id) {
        AvatarState state = getStateRepository().get(id, true);
        return state;
    }

    public Iterable<AvatarState> getAll(Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().getAll(firstResult, maxResults);
    }

    public Iterable<AvatarState> get(Iterable<Map.Entry<String, Object>> filter, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().get(filter, orders, firstResult, maxResults);
    }

    public Iterable<AvatarState> get(Criterion filter, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().get(filter, orders, firstResult, maxResults);
    }

    public Iterable<AvatarState> getByProperty(String propertyName, Object propertyValue, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().getByProperty(propertyName, propertyValue, orders, firstResult, maxResults);
    }

    public long getCount(Iterable<Map.Entry<String, Object>> filter) {
        return getStateQueryRepository().getCount(filter);
    }

    public long getCount(Criterion filter) {
        return getStateQueryRepository().getCount(filter);
    }

    public AvatarEvent getEvent(String id, long version) {
        AvatarEvent e = (AvatarEvent)getEventStore().getEvent(toEventStoreAggregateId(id), version);
        if (e != null) {
            ((AvatarEvent.SqlAvatarEvent)e).setEventReadOnly(true); 
        } else if (version == -1) {
            return getEvent(id, 0);
        }
        return e;
    }

    public AvatarState getHistoryState(String id, long version) {
        EventStream eventStream = getEventStore().loadEventStream(AbstractAvatarEvent.class, toEventStoreAggregateId(id), version - 1);
        return new AbstractAvatarState.SimpleAvatarState(eventStream.getEvents());
    }


    public AvatarAggregate getAvatarAggregate(AvatarState state) {
        return new AbstractAvatarAggregate.SimpleAvatarAggregate(state);
    }

    public EventStoreAggregateId toEventStoreAggregateId(String aggregateId) {
        return new EventStoreAggregateId.SimpleEventStoreAggregateId(aggregateId);
    }

    protected void update(AvatarCommand c, Consumer<AvatarAggregate> action) {
        String aggregateId = c.getId();
        EventStoreAggregateId eventStoreAggregateId = toEventStoreAggregateId(aggregateId);
        AvatarState state = getStateRepository().get(aggregateId, false);
        boolean duplicate = isDuplicateCommand(c, eventStoreAggregateId, state);
        if (duplicate) { return; }

        AvatarAggregate aggregate = getAvatarAggregate(state);
        aggregate.throwOnInvalidStateTransition(c);
        action.accept(aggregate);
        persist(eventStoreAggregateId, c.getOffChainVersion() == null ? AvatarState.VERSION_NULL : c.getOffChainVersion(), aggregate, state); // State version may be null!

    }

    private void persist(EventStoreAggregateId eventStoreAggregateId, long version, AvatarAggregate aggregate, AvatarState state) {
        getEventStore().appendEvents(eventStoreAggregateId, version, 
            aggregate.getChanges(), (events) -> { 
                getStateRepository().save(state); 
            });
        if (aggregateEventListener != null) {
            aggregateEventListener.eventAppended(new AggregateEvent<>(aggregate, state, aggregate.getChanges()));
        }
    }

    protected boolean isDuplicateCommand(AvatarCommand command, EventStoreAggregateId eventStoreAggregateId, AvatarState state) {
        boolean duplicate = false;
        if (command.getOffChainVersion() == null) { command.setOffChainVersion(AvatarState.VERSION_NULL); }
        if (state.getOffChainVersion() != null && state.getOffChainVersion() > command.getOffChainVersion()) {
            Event lastEvent = getEventStore().getEvent(AbstractAvatarEvent.class, eventStoreAggregateId, command.getOffChainVersion());
            if (lastEvent != null && lastEvent instanceof AbstractEvent
               && command.getCommandId() != null && command.getCommandId().equals(((AbstractEvent) lastEvent).getCommandId())) {
                duplicate = true;
            }
        }
        return duplicate;
    }

    public static class SimpleAvatarApplicationService extends AbstractAvatarApplicationService {
        public SimpleAvatarApplicationService(EventStore eventStore, AvatarStateRepository stateRepository, AvatarStateQueryRepository stateQueryRepository)
        {
            super(eventStore, stateRepository, stateQueryRepository);
        }
    }

}

