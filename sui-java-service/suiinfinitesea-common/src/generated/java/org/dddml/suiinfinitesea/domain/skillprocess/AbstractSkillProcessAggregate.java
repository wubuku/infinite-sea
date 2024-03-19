// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.skillprocess;

import java.util.*;
import org.dddml.suiinfinitesea.domain.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.specialization.*;

public abstract class AbstractSkillProcessAggregate extends AbstractAggregate implements SkillProcessAggregate {
    private SkillProcessState.MutableSkillProcessState state;

    private List<Event> changes = new ArrayList<Event>();

    public AbstractSkillProcessAggregate(SkillProcessState state) {
        this.state = (SkillProcessState.MutableSkillProcessState)state;
    }

    public SkillProcessState getState() {
        return this.state;
    }

    public List<Event> getChanges() {
        return this.changes;
    }

    public void throwOnInvalidStateTransition(Command c) {
        SkillProcessCommand.throwOnInvalidStateTransition(this.state, c);
    }

    protected void apply(Event e) {
        onApplying(e);
        state.mutate(e);
        changes.add(e);
    }


    ////////////////////////

    public static class SimpleSkillProcessAggregate extends AbstractSkillProcessAggregate {
        public SimpleSkillProcessAggregate(SkillProcessState state) {
            super(state);
        }

        @Override
        public void create(String player, Long offChainVersion, String commandId, String requesterId, SkillProcessCommands.Create c) {
            java.util.function.Supplier<SkillProcessEvent.SkillProcessCreated> eventFactory = () -> newSkillProcessCreated(player, offChainVersion, commandId, requesterId);
            SkillProcessEvent.SkillProcessCreated e;
            try {
                e = verifyCreate(eventFactory, player, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        @Override
        public void completeProduction(String player, SkillTypeItemIdPair itemProduction, String experienceTable, String clock, Long offChainVersion, String commandId, String requesterId, SkillProcessCommands.CompleteProduction c) {
            java.util.function.Supplier<SkillProcessEvent.ProductionProcessCompleted> eventFactory = () -> newProductionProcessCompleted(player, itemProduction, experienceTable, clock, offChainVersion, commandId, requesterId);
            SkillProcessEvent.ProductionProcessCompleted e;
            try {
                e = verifyCompleteProduction(eventFactory, player, itemProduction, experienceTable, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        protected SkillProcessEvent.SkillProcessCreated verifyCreate(java.util.function.Supplier<SkillProcessEvent.SkillProcessCreated> eventFactory, String player, SkillProcessCommands.Create c) {
            String Player = player;

            SkillProcessEvent.SkillProcessCreated e = (SkillProcessEvent.SkillProcessCreated) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.skillprocess.CreateLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, SkillProcessState.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), player, VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.skillprocess;
//
//public class CreateLogic {
//    public static SkillProcessEvent.SkillProcessCreated verify(java.util.function.Supplier<SkillProcessEvent.SkillProcessCreated> eventFactory, SkillProcessState skillProcessState, String player, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected SkillProcessEvent.ProductionProcessStarted verifyStartProduction(java.util.function.Supplier<SkillProcessEvent.ProductionProcessStarted> eventFactory, String player, SkillTypeItemIdPair itemProduction, SkillProcessCommands.StartProduction c) {
            String Player = player;
            SkillTypeItemIdPair ItemProduction = itemProduction;

            SkillProcessEvent.ProductionProcessStarted e = (SkillProcessEvent.ProductionProcessStarted) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.skillprocess.StartProductionLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, SkillProcessState.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), player, itemProduction, VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.skillprocess;
//
//public class StartProductionLogic {
//    public static SkillProcessEvent.ProductionProcessStarted verify(java.util.function.Supplier<SkillProcessEvent.ProductionProcessStarted> eventFactory, SkillProcessState skillProcessState, String player, SkillTypeItemIdPair itemProduction, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected SkillProcessEvent.ProductionProcessCompleted verifyCompleteProduction(java.util.function.Supplier<SkillProcessEvent.ProductionProcessCompleted> eventFactory, String player, SkillTypeItemIdPair itemProduction, String experienceTable, SkillProcessCommands.CompleteProduction c) {
            String Player = player;
            SkillTypeItemIdPair ItemProduction = itemProduction;
            String ExperienceTable = experienceTable;

            SkillProcessEvent.ProductionProcessCompleted e = (SkillProcessEvent.ProductionProcessCompleted) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.skillprocess.CompleteProductionLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, SkillProcessState.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), player, itemProduction, experienceTable, VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.skillprocess;
//
//public class CompleteProductionLogic {
//    public static SkillProcessEvent.ProductionProcessCompleted verify(java.util.function.Supplier<SkillProcessEvent.ProductionProcessCompleted> eventFactory, SkillProcessState skillProcessState, String player, SkillTypeItemIdPair itemProduction, String experienceTable, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected SkillProcessEvent.MutexCreationProcessStarted verifyStartMutexCreation(java.util.function.Supplier<SkillProcessEvent.MutexCreationProcessStarted> eventFactory, String skillProcessMutex, String player, SkillTypeItemIdPair itemCreation, SkillProcessCommands.StartMutexCreation c) {
            String SkillProcessMutex = skillProcessMutex;
            String Player = player;
            SkillTypeItemIdPair ItemCreation = itemCreation;

            SkillProcessEvent.MutexCreationProcessStarted e = (SkillProcessEvent.MutexCreationProcessStarted) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.skillprocess.StartMutexCreationLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, SkillProcessState.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), skillProcessMutex, player, itemCreation, VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.skillprocess;
//
//public class StartMutexCreationLogic {
//    public static SkillProcessEvent.MutexCreationProcessStarted verify(java.util.function.Supplier<SkillProcessEvent.MutexCreationProcessStarted> eventFactory, SkillProcessState skillProcessState, String skillProcessMutex, String player, SkillTypeItemIdPair itemCreation, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected AbstractSkillProcessEvent.SkillProcessCreated newSkillProcessCreated(String player, Long offChainVersion, String commandId, String requesterId) {
            SkillProcessEventId eventId = new SkillProcessEventId(getState().getSkillProcessId(), null);
            AbstractSkillProcessEvent.SkillProcessCreated e = new AbstractSkillProcessEvent.SkillProcessCreated();

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

            e.setSkillProcessEventId(eventId);
            return e;
        }

        protected AbstractSkillProcessEvent.ProductionProcessCompleted newProductionProcessCompleted(String player, SkillTypeItemIdPair itemProduction, String experienceTable, String clock, Long offChainVersion, String commandId, String requesterId) {
            SkillProcessEventId eventId = new SkillProcessEventId(getState().getSkillProcessId(), null);
            AbstractSkillProcessEvent.ProductionProcessCompleted e = new AbstractSkillProcessEvent.ProductionProcessCompleted();

            e.setItemId(null);
            e.setStartedAt(null);
            e.setCreationTime(null);
            e.setEndedAt(null);
            e.setSuccessful(null);
            e.setQuantity(null);
            e.setExperience(null);
            e.setNewLevel(null);
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

            e.setSkillProcessEventId(eventId);
            return e;
        }

    }

}

