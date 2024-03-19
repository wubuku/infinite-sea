// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.itemcreation;

import java.util.*;
import org.dddml.suiinfinitesea.domain.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.specialization.*;

public abstract class AbstractItemCreationAggregate extends AbstractAggregate implements ItemCreationAggregate {
    private ItemCreationState.MutableItemCreationState state;

    private List<Event> changes = new ArrayList<Event>();

    public AbstractItemCreationAggregate(ItemCreationState state) {
        this.state = (ItemCreationState.MutableItemCreationState)state;
    }

    public ItemCreationState getState() {
        return this.state;
    }

    public List<Event> getChanges() {
        return this.changes;
    }

    public void throwOnInvalidStateTransition(Command c) {
        ItemCreationCommand.throwOnInvalidStateTransition(this.state, c);
    }

    protected void apply(Event e) {
        onApplying(e);
        state.mutate(e);
        changes.add(e);
    }


    ////////////////////////

    public static class SimpleItemCreationAggregate extends AbstractItemCreationAggregate {
        public SimpleItemCreationAggregate(ItemCreationState state) {
            super(state);
        }

        @Override
        public void create(Long resourceCost, Integer requirementsLevel, Long baseQuantity, Long baseExperience, BigInteger baseCreationTime, BigInteger energyCost, Integer successRate, Long offChainVersion, String commandId, String requesterId, ItemCreationCommands.Create c) {
            java.util.function.Supplier<ItemCreationEvent.ItemCreationCreated> eventFactory = () -> newItemCreationCreated(resourceCost, requirementsLevel, baseQuantity, baseExperience, baseCreationTime, energyCost, successRate, offChainVersion, commandId, requesterId);
            ItemCreationEvent.ItemCreationCreated e;
            try {
                e = verifyCreate(eventFactory, resourceCost, requirementsLevel, baseQuantity, baseExperience, baseCreationTime, energyCost, successRate, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        @Override
        public void update(Long resourceCost, Integer requirementsLevel, Long baseQuantity, Long baseExperience, BigInteger baseCreationTime, BigInteger energyCost, Integer successRate, Long offChainVersion, String commandId, String requesterId, ItemCreationCommands.Update c) {
            java.util.function.Supplier<ItemCreationEvent.ItemCreationUpdated> eventFactory = () -> newItemCreationUpdated(resourceCost, requirementsLevel, baseQuantity, baseExperience, baseCreationTime, energyCost, successRate, offChainVersion, commandId, requesterId);
            ItemCreationEvent.ItemCreationUpdated e;
            try {
                e = verifyUpdate(eventFactory, resourceCost, requirementsLevel, baseQuantity, baseExperience, baseCreationTime, energyCost, successRate, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        protected ItemCreationEvent.ItemCreationCreated verifyCreate(java.util.function.Supplier<ItemCreationEvent.ItemCreationCreated> eventFactory, Long resourceCost, Integer requirementsLevel, Long baseQuantity, Long baseExperience, BigInteger baseCreationTime, BigInteger energyCost, Integer successRate, ItemCreationCommands.Create c) {
            Long ResourceCost = resourceCost;
            Integer RequirementsLevel = requirementsLevel;
            Long BaseQuantity = baseQuantity;
            Long BaseExperience = baseExperience;
            BigInteger BaseCreationTime = baseCreationTime;
            BigInteger EnergyCost = energyCost;
            Integer SuccessRate = successRate;

            ItemCreationEvent.ItemCreationCreated e = (ItemCreationEvent.ItemCreationCreated) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.itemcreation.CreateLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, ItemCreationState.class, Long.class, Integer.class, Long.class, Long.class, BigInteger.class, BigInteger.class, Integer.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), resourceCost, requirementsLevel, baseQuantity, baseExperience, baseCreationTime, energyCost, successRate, VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.itemcreation;
//
//public class CreateLogic {
//    public static ItemCreationEvent.ItemCreationCreated verify(java.util.function.Supplier<ItemCreationEvent.ItemCreationCreated> eventFactory, ItemCreationState itemCreationState, Long resourceCost, Integer requirementsLevel, Long baseQuantity, Long baseExperience, BigInteger baseCreationTime, BigInteger energyCost, Integer successRate, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected ItemCreationEvent.ItemCreationUpdated verifyUpdate(java.util.function.Supplier<ItemCreationEvent.ItemCreationUpdated> eventFactory, Long resourceCost, Integer requirementsLevel, Long baseQuantity, Long baseExperience, BigInteger baseCreationTime, BigInteger energyCost, Integer successRate, ItemCreationCommands.Update c) {
            Long ResourceCost = resourceCost;
            Integer RequirementsLevel = requirementsLevel;
            Long BaseQuantity = baseQuantity;
            Long BaseExperience = baseExperience;
            BigInteger BaseCreationTime = baseCreationTime;
            BigInteger EnergyCost = energyCost;
            Integer SuccessRate = successRate;

            ItemCreationEvent.ItemCreationUpdated e = (ItemCreationEvent.ItemCreationUpdated) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.itemcreation.UpdateLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, ItemCreationState.class, Long.class, Integer.class, Long.class, Long.class, BigInteger.class, BigInteger.class, Integer.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), resourceCost, requirementsLevel, baseQuantity, baseExperience, baseCreationTime, energyCost, successRate, VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.itemcreation;
//
//public class UpdateLogic {
//    public static ItemCreationEvent.ItemCreationUpdated verify(java.util.function.Supplier<ItemCreationEvent.ItemCreationUpdated> eventFactory, ItemCreationState itemCreationState, Long resourceCost, Integer requirementsLevel, Long baseQuantity, Long baseExperience, BigInteger baseCreationTime, BigInteger energyCost, Integer successRate, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected AbstractItemCreationEvent.ItemCreationCreated newItemCreationCreated(Long resourceCost, Integer requirementsLevel, Long baseQuantity, Long baseExperience, BigInteger baseCreationTime, BigInteger energyCost, Integer successRate, Long offChainVersion, String commandId, String requesterId) {
            ItemCreationEventId eventId = new ItemCreationEventId(getState().getItemCreationId(), null);
            AbstractItemCreationEvent.ItemCreationCreated e = new AbstractItemCreationEvent.ItemCreationCreated();

            e.setResourceCost(resourceCost);
            e.setRequirementsLevel(requirementsLevel);
            e.setBaseQuantity(baseQuantity);
            e.setBaseExperience(baseExperience);
            e.setBaseCreationTime(baseCreationTime);
            e.setEnergyCost(energyCost);
            e.setSuccessRate(successRate);
            e.setSuiTimestamp(null);
            e.setSuiTxDigest(null);
            e.setSuiEventSeq(null);
            e.setSuiPackageId(null);
            e.setSuiTransactionModule(null);
            e.setSuiSender(null);
            e.setSuiType(null);
            e.setStatus(null);

            e.setCommandId(commandId);
            e.setCreatedBy(requesterId);
            e.setCreatedAt((java.util.Date)ApplicationContext.current.getTimestampService().now(java.util.Date.class));

            e.setItemCreationEventId(eventId);
            return e;
        }

        protected AbstractItemCreationEvent.ItemCreationUpdated newItemCreationUpdated(Long resourceCost, Integer requirementsLevel, Long baseQuantity, Long baseExperience, BigInteger baseCreationTime, BigInteger energyCost, Integer successRate, Long offChainVersion, String commandId, String requesterId) {
            ItemCreationEventId eventId = new ItemCreationEventId(getState().getItemCreationId(), null);
            AbstractItemCreationEvent.ItemCreationUpdated e = new AbstractItemCreationEvent.ItemCreationUpdated();

            e.setResourceCost(resourceCost);
            e.setRequirementsLevel(requirementsLevel);
            e.setBaseQuantity(baseQuantity);
            e.setBaseExperience(baseExperience);
            e.setBaseCreationTime(baseCreationTime);
            e.setEnergyCost(energyCost);
            e.setSuccessRate(successRate);
            e.setSuiTimestamp(null);
            e.setSuiTxDigest(null);
            e.setSuiEventSeq(null);
            e.setSuiPackageId(null);
            e.setSuiTransactionModule(null);
            e.setSuiSender(null);
            e.setSuiType(null);
            e.setStatus(null);

            e.setCommandId(commandId);
            e.setCreatedBy(requesterId);
            e.setCreatedAt((java.util.Date)ApplicationContext.current.getTimestampService().now(java.util.Date.class));

            e.setItemCreationEventId(eventId);
            return e;
        }

    }

}

