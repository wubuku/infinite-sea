// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.faucetrequested;

import java.util.*;
import java.util.function.Consumer;
import org.dddml.support.criterion.Criterion;
import java.math.BigInteger;
import org.dddml.suiinfinitesea.domain.*;
import java.util.Date;
import org.dddml.suiinfinitesea.specialization.*;

public abstract class AbstractFaucetRequestedApplicationService implements FaucetRequestedApplicationService {
    private FaucetRequestedStateRepository stateRepository;

    protected FaucetRequestedStateRepository getStateRepository() {
        return stateRepository;
    }

    private FaucetRequestedStateQueryRepository stateQueryRepository;

    protected FaucetRequestedStateQueryRepository getStateQueryRepository() {
        return stateQueryRepository;
    }

    public AbstractFaucetRequestedApplicationService(FaucetRequestedStateRepository stateRepository, FaucetRequestedStateQueryRepository stateQueryRepository) {
        this.stateRepository = stateRepository;
        this.stateQueryRepository = stateQueryRepository;
    }

    public FaucetRequestedState get(String id) {
        FaucetRequestedState state = getStateRepository().get(id, true);
        return state;
    }

    public Iterable<FaucetRequestedState> getAll(Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().getAll(firstResult, maxResults);
    }

    public Iterable<FaucetRequestedState> get(Iterable<Map.Entry<String, Object>> filter, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().get(filter, orders, firstResult, maxResults);
    }

    public Iterable<FaucetRequestedState> get(Criterion filter, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().get(filter, orders, firstResult, maxResults);
    }

    public Iterable<FaucetRequestedState> getByProperty(String propertyName, Object propertyValue, List<String> orders, Integer firstResult, Integer maxResults) {
        return getStateQueryRepository().getByProperty(propertyName, propertyValue, orders, firstResult, maxResults);
    }

    public long getCount(Iterable<Map.Entry<String, Object>> filter) {
        return getStateQueryRepository().getCount(filter);
    }

    public long getCount(Criterion filter) {
        return getStateQueryRepository().getCount(filter);
    }

    public EventStoreAggregateId toEventStoreAggregateId(String aggregateId) {
        return new EventStoreAggregateId.SimpleEventStoreAggregateId(aggregateId);
    }

    protected void update(FaucetRequestedCommand c, Consumer<FaucetRequestedState> action) {
        String aggregateId = c.getEventId();
        EventStoreAggregateId eventStoreAggregateId = toEventStoreAggregateId(aggregateId);
        FaucetRequestedState state = getStateRepository().get(aggregateId, false);
        boolean duplicate = isDuplicateCommand(c, eventStoreAggregateId, state);
        if (duplicate) { return; }

        FaucetRequestedCommand.throwOnInvalidStateTransition(state, c);
        action.accept(state);
        persist(eventStoreAggregateId, c.getOffChainVersion() == null ? FaucetRequestedState.VERSION_NULL : c.getOffChainVersion(), state); // State version may be null!

    }

    private void persist(EventStoreAggregateId eventStoreAggregateId, long version, FaucetRequestedState state) {
        getStateRepository().save(state);
    }

    protected boolean isDuplicateCommand(FaucetRequestedCommand command, EventStoreAggregateId eventStoreAggregateId, FaucetRequestedState state) {
        boolean duplicate = false;
        if (command.getOffChainVersion() == null) { command.setOffChainVersion(FaucetRequestedState.VERSION_NULL); }
        if (state.getOffChainVersion() != null && state.getOffChainVersion() == command.getOffChainVersion() + 1) {
            if (command.getCommandId() != null && command.getCommandId().equals(state.getCommandId())) {
                duplicate = true;
            }
        }
        return duplicate;
    }

    protected static void throwOnConcurrencyConflict(FaucetRequestedState s, FaucetRequestedCommand c) {
        Long stateVersion = s.getOffChainVersion();
        Long commandVersion = c.getOffChainVersion();
        if (commandVersion == null) { commandVersion = FaucetRequestedState.VERSION_NULL; }
        if (!(stateVersion == null && commandVersion.equals(FaucetRequestedState.VERSION_NULL)) && !commandVersion.equals(stateVersion)) {
            throw DomainError.named("concurrencyConflict", "Conflict between state version (%1$s) and command version (%2$s)", stateVersion, commandVersion);
        }
    }

    public static class SimpleFaucetRequestedApplicationService extends AbstractFaucetRequestedApplicationService {
        public SimpleFaucetRequestedApplicationService(FaucetRequestedStateRepository stateRepository, FaucetRequestedStateQueryRepository stateQueryRepository)
        {
            super(stateRepository, stateQueryRepository);
        }
    }

}

