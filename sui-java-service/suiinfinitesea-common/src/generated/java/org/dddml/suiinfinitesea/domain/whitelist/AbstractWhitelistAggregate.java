// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.whitelist;

import java.util.*;
import java.util.Date;
import java.math.BigInteger;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.*;

public abstract class AbstractWhitelistAggregate extends AbstractAggregate implements WhitelistAggregate {
    private WhitelistState.MutableWhitelistState state;

    private List<Event> changes = new ArrayList<Event>();

    public AbstractWhitelistAggregate(WhitelistState state) {
        this.state = (WhitelistState.MutableWhitelistState)state;
    }

    public WhitelistState getState() {
        return this.state;
    }

    public List<Event> getChanges() {
        return this.changes;
    }

    public void throwOnInvalidStateTransition(Command c) {
        WhitelistCommand.throwOnInvalidStateTransition(this.state, c);
    }

    protected void apply(Event e) {
        onApplying(e);
        state.mutate(e);
        changes.add(e);
    }


    ////////////////////////

    public static class SimpleWhitelistAggregate extends AbstractWhitelistAggregate {
        public SimpleWhitelistAggregate(WhitelistState state) {
            super(state);
        }

        @Override
        public void update(Boolean paused, Long offChainVersion, String commandId, String requesterId, WhitelistCommands.Update c) {
            java.util.function.Supplier<WhitelistEvent.WhitelistUpdated> eventFactory = () -> newWhitelistUpdated(paused, offChainVersion, commandId, requesterId);
            WhitelistEvent.WhitelistUpdated e;
            try {
                e = verifyUpdate(eventFactory, paused, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        @Override
        public void addWhitelistEntry(String accountAddress, String name, String imageUrl, String description, Long backgroundColor, Integer race, Integer eyes, Integer mouth, Integer haircut, Integer skin, Integer outfit, Integer accessories, Long offChainVersion, String commandId, String requesterId, WhitelistCommands.AddWhitelistEntry c) {
            java.util.function.Supplier<WhitelistEvent.WhitelistEntryAdded> eventFactory = () -> newWhitelistEntryAdded(accountAddress, name, imageUrl, description, backgroundColor, race, eyes, mouth, haircut, skin, outfit, accessories, offChainVersion, commandId, requesterId);
            WhitelistEvent.WhitelistEntryAdded e;
            try {
                e = verifyAddWhitelistEntry(eventFactory, accountAddress, name, imageUrl, description, backgroundColor, race, eyes, mouth, haircut, skin, outfit, accessories, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        @Override
        public void updateWhitelistEntry(String accountAddress, String name, String imageUrl, String description, Long backgroundColor, Integer race, Integer eyes, Integer mouth, Integer haircut, Integer skin, Integer outfit, Integer accessories, Boolean claimed, Boolean paused, Long offChainVersion, String commandId, String requesterId, WhitelistCommands.UpdateWhitelistEntry c) {
            java.util.function.Supplier<WhitelistEvent.WhitelistEntryUpdated> eventFactory = () -> newWhitelistEntryUpdated(accountAddress, name, imageUrl, description, backgroundColor, race, eyes, mouth, haircut, skin, outfit, accessories, claimed, paused, offChainVersion, commandId, requesterId);
            WhitelistEvent.WhitelistEntryUpdated e;
            try {
                e = verifyUpdateWhitelistEntry(eventFactory, accountAddress, name, imageUrl, description, backgroundColor, race, eyes, mouth, haircut, skin, outfit, accessories, claimed, paused, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        @Override
        public void claim(Long offChainVersion, String commandId, String requesterId, WhitelistCommands.Claim c) {
            java.util.function.Supplier<WhitelistEvent.WhitelistClaimed> eventFactory = () -> newWhitelistClaimed(offChainVersion, commandId, requesterId);
            WhitelistEvent.WhitelistClaimed e;
            try {
                e = verifyClaim(eventFactory, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        @Override
        public void create(Long offChainVersion, String commandId, String requesterId, WhitelistCommands.Create c) {
            java.util.function.Supplier<WhitelistEvent.WhitelistCreated> eventFactory = () -> newWhitelistCreated(offChainVersion, commandId, requesterId);
            WhitelistEvent.WhitelistCreated e;
            try {
                e = verifyCreate(eventFactory, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        protected WhitelistEvent.InitWhitelistEvent verify__Init__(java.util.function.Supplier<WhitelistEvent.InitWhitelistEvent> eventFactory, WhitelistCommands.__Init__ c) {

            WhitelistEvent.InitWhitelistEvent e = (WhitelistEvent.InitWhitelistEvent) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.whitelist.__Init__Logic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, WhitelistState.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.whitelist;
//
//public class __Init__Logic {
//    public static WhitelistEvent.InitWhitelistEvent verify(java.util.function.Supplier<WhitelistEvent.InitWhitelistEvent> eventFactory, WhitelistState whitelistState, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected WhitelistEvent.WhitelistUpdated verifyUpdate(java.util.function.Supplier<WhitelistEvent.WhitelistUpdated> eventFactory, Boolean paused, WhitelistCommands.Update c) {
            Boolean Paused = paused;

            WhitelistEvent.WhitelistUpdated e = (WhitelistEvent.WhitelistUpdated) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.whitelist.UpdateLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, WhitelistState.class, Boolean.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), paused, VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.whitelist;
//
//public class UpdateLogic {
//    public static WhitelistEvent.WhitelistUpdated verify(java.util.function.Supplier<WhitelistEvent.WhitelistUpdated> eventFactory, WhitelistState whitelistState, Boolean paused, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected WhitelistEvent.WhitelistEntryAdded verifyAddWhitelistEntry(java.util.function.Supplier<WhitelistEvent.WhitelistEntryAdded> eventFactory, String accountAddress, String name, String imageUrl, String description, Long backgroundColor, Integer race, Integer eyes, Integer mouth, Integer haircut, Integer skin, Integer outfit, Integer accessories, WhitelistCommands.AddWhitelistEntry c) {
            String AccountAddress = accountAddress;
            String Name = name;
            String ImageUrl = imageUrl;
            String Description = description;
            Long BackgroundColor = backgroundColor;
            Integer Race = race;
            Integer Eyes = eyes;
            Integer Mouth = mouth;
            Integer Haircut = haircut;
            Integer Skin = skin;
            Integer Outfit = outfit;
            Integer Accessories = accessories;

            WhitelistEvent.WhitelistEntryAdded e = (WhitelistEvent.WhitelistEntryAdded) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.whitelist.AddWhitelistEntryLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, WhitelistState.class, String.class, String.class, String.class, String.class, Long.class, Integer.class, Integer.class, Integer.class, Integer.class, Integer.class, Integer.class, Integer.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), accountAddress, name, imageUrl, description, backgroundColor, race, eyes, mouth, haircut, skin, outfit, accessories, VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.whitelist;
//
//public class AddWhitelistEntryLogic {
//    public static WhitelistEvent.WhitelistEntryAdded verify(java.util.function.Supplier<WhitelistEvent.WhitelistEntryAdded> eventFactory, WhitelistState whitelistState, String accountAddress, String name, String imageUrl, String description, Long backgroundColor, Integer race, Integer eyes, Integer mouth, Integer haircut, Integer skin, Integer outfit, Integer accessories, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected WhitelistEvent.WhitelistEntryUpdated verifyUpdateWhitelistEntry(java.util.function.Supplier<WhitelistEvent.WhitelistEntryUpdated> eventFactory, String accountAddress, String name, String imageUrl, String description, Long backgroundColor, Integer race, Integer eyes, Integer mouth, Integer haircut, Integer skin, Integer outfit, Integer accessories, Boolean claimed, Boolean paused, WhitelistCommands.UpdateWhitelistEntry c) {
            String AccountAddress = accountAddress;
            String Name = name;
            String ImageUrl = imageUrl;
            String Description = description;
            Long BackgroundColor = backgroundColor;
            Integer Race = race;
            Integer Eyes = eyes;
            Integer Mouth = mouth;
            Integer Haircut = haircut;
            Integer Skin = skin;
            Integer Outfit = outfit;
            Integer Accessories = accessories;
            Boolean Claimed = claimed;
            Boolean Paused = paused;

            WhitelistEvent.WhitelistEntryUpdated e = (WhitelistEvent.WhitelistEntryUpdated) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.whitelist.UpdateWhitelistEntryLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, WhitelistState.class, String.class, String.class, String.class, String.class, Long.class, Integer.class, Integer.class, Integer.class, Integer.class, Integer.class, Integer.class, Integer.class, Boolean.class, Boolean.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), accountAddress, name, imageUrl, description, backgroundColor, race, eyes, mouth, haircut, skin, outfit, accessories, claimed, paused, VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.whitelist;
//
//public class UpdateWhitelistEntryLogic {
//    public static WhitelistEvent.WhitelistEntryUpdated verify(java.util.function.Supplier<WhitelistEvent.WhitelistEntryUpdated> eventFactory, WhitelistState whitelistState, String accountAddress, String name, String imageUrl, String description, Long backgroundColor, Integer race, Integer eyes, Integer mouth, Integer haircut, Integer skin, Integer outfit, Integer accessories, Boolean claimed, Boolean paused, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected WhitelistEvent.WhitelistClaimed verifyClaim(java.util.function.Supplier<WhitelistEvent.WhitelistClaimed> eventFactory, WhitelistCommands.Claim c) {

            WhitelistEvent.WhitelistClaimed e = (WhitelistEvent.WhitelistClaimed) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.whitelist.ClaimLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, WhitelistState.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.whitelist;
//
//public class ClaimLogic {
//    public static WhitelistEvent.WhitelistClaimed verify(java.util.function.Supplier<WhitelistEvent.WhitelistClaimed> eventFactory, WhitelistState whitelistState, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected WhitelistEvent.WhitelistCreated verifyCreate(java.util.function.Supplier<WhitelistEvent.WhitelistCreated> eventFactory, WhitelistCommands.Create c) {

            WhitelistEvent.WhitelistCreated e = (WhitelistEvent.WhitelistCreated) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.whitelist.CreateLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, WhitelistState.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.whitelist;
//
//public class CreateLogic {
//    public static WhitelistEvent.WhitelistCreated verify(java.util.function.Supplier<WhitelistEvent.WhitelistCreated> eventFactory, WhitelistState whitelistState, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected AbstractWhitelistEvent.InitWhitelistEvent newInitWhitelistEvent(Long offChainVersion, String commandId, String requesterId) {
            WhitelistEventId eventId = new WhitelistEventId(getState().getId(), null);
            AbstractWhitelistEvent.InitWhitelistEvent e = new AbstractWhitelistEvent.InitWhitelistEvent();

            e.setSuiTimestamp(null);
            e.setSuiTxDigest(null);
            e.setSuiEventSeq(null);
            e.setSuiPackageId(null);
            e.setSuiTransactionModule(null);
            e.setSuiSender(null);
            e.setSuiType(null);
            e.setEventStatus(null);

            e.setCommandId(commandId);
            e.setCreatedBy(requesterId);
            e.setCreatedAt((java.util.Date)ApplicationContext.current.getTimestampService().now(java.util.Date.class));

            e.setWhitelistEventId(eventId);
            return e;
        }

        protected AbstractWhitelistEvent.WhitelistUpdated newWhitelistUpdated(Boolean paused, Long offChainVersion, String commandId, String requesterId) {
            WhitelistEventId eventId = new WhitelistEventId(getState().getId(), null);
            AbstractWhitelistEvent.WhitelistUpdated e = new AbstractWhitelistEvent.WhitelistUpdated();

            e.setPaused(paused);
            e.setSuiTimestamp(null);
            e.setSuiTxDigest(null);
            e.setSuiEventSeq(null);
            e.setSuiPackageId(null);
            e.setSuiTransactionModule(null);
            e.setSuiSender(null);
            e.setSuiType(null);
            e.setEventStatus(null);

            e.setCommandId(commandId);
            e.setCreatedBy(requesterId);
            e.setCreatedAt((java.util.Date)ApplicationContext.current.getTimestampService().now(java.util.Date.class));

            e.setWhitelistEventId(eventId);
            return e;
        }

        protected AbstractWhitelistEvent.WhitelistEntryAdded newWhitelistEntryAdded(String accountAddress, String name, String imageUrl, String description, Long backgroundColor, Integer race, Integer eyes, Integer mouth, Integer haircut, Integer skin, Integer outfit, Integer accessories, Long offChainVersion, String commandId, String requesterId) {
            WhitelistEventId eventId = new WhitelistEventId(getState().getId(), null);
            AbstractWhitelistEvent.WhitelistEntryAdded e = new AbstractWhitelistEvent.WhitelistEntryAdded();

            e.setAccountAddress(accountAddress);
            e.setName(name);
            e.setImageUrl(imageUrl);
            e.setDescription(description);
            e.setBackgroundColor(backgroundColor);
            e.setRace(race);
            e.setEyes(eyes);
            e.setMouth(mouth);
            e.setHaircut(haircut);
            e.setSkin(skin);
            e.setOutfit(outfit);
            e.setAccessories(accessories);
            e.setSuiTimestamp(null);
            e.setSuiTxDigest(null);
            e.setSuiEventSeq(null);
            e.setSuiPackageId(null);
            e.setSuiTransactionModule(null);
            e.setSuiSender(null);
            e.setSuiType(null);
            e.setEventStatus(null);

            e.setCommandId(commandId);
            e.setCreatedBy(requesterId);
            e.setCreatedAt((java.util.Date)ApplicationContext.current.getTimestampService().now(java.util.Date.class));

            e.setWhitelistEventId(eventId);
            return e;
        }

        protected AbstractWhitelistEvent.WhitelistEntryUpdated newWhitelistEntryUpdated(String accountAddress, String name, String imageUrl, String description, Long backgroundColor, Integer race, Integer eyes, Integer mouth, Integer haircut, Integer skin, Integer outfit, Integer accessories, Boolean claimed, Boolean paused, Long offChainVersion, String commandId, String requesterId) {
            WhitelistEventId eventId = new WhitelistEventId(getState().getId(), null);
            AbstractWhitelistEvent.WhitelistEntryUpdated e = new AbstractWhitelistEvent.WhitelistEntryUpdated();

            e.setAccountAddress(accountAddress);
            e.setName(name);
            e.setImageUrl(imageUrl);
            e.setDescription(description);
            e.setBackgroundColor(backgroundColor);
            e.setRace(race);
            e.setEyes(eyes);
            e.setMouth(mouth);
            e.setHaircut(haircut);
            e.setSkin(skin);
            e.setOutfit(outfit);
            e.setAccessories(accessories);
            e.setClaimed(claimed);
            e.setPaused(paused);
            e.setSuiTimestamp(null);
            e.setSuiTxDigest(null);
            e.setSuiEventSeq(null);
            e.setSuiPackageId(null);
            e.setSuiTransactionModule(null);
            e.setSuiSender(null);
            e.setSuiType(null);
            e.setEventStatus(null);

            e.setCommandId(commandId);
            e.setCreatedBy(requesterId);
            e.setCreatedAt((java.util.Date)ApplicationContext.current.getTimestampService().now(java.util.Date.class));

            e.setWhitelistEventId(eventId);
            return e;
        }

        protected AbstractWhitelistEvent.WhitelistClaimed newWhitelistClaimed(Long offChainVersion, String commandId, String requesterId) {
            WhitelistEventId eventId = new WhitelistEventId(getState().getId(), null);
            AbstractWhitelistEvent.WhitelistClaimed e = new AbstractWhitelistEvent.WhitelistClaimed();

            e.setAccountAddress(null);
            e.setSuiTimestamp(null);
            e.setSuiTxDigest(null);
            e.setSuiEventSeq(null);
            e.setSuiPackageId(null);
            e.setSuiTransactionModule(null);
            e.setSuiSender(null);
            e.setSuiType(null);
            e.setEventStatus(null);

            e.setCommandId(commandId);
            e.setCreatedBy(requesterId);
            e.setCreatedAt((java.util.Date)ApplicationContext.current.getTimestampService().now(java.util.Date.class));

            e.setWhitelistEventId(eventId);
            return e;
        }

        protected AbstractWhitelistEvent.WhitelistCreated newWhitelistCreated(Long offChainVersion, String commandId, String requesterId) {
            WhitelistEventId eventId = new WhitelistEventId(getState().getId(), null);
            AbstractWhitelistEvent.WhitelistCreated e = new AbstractWhitelistEvent.WhitelistCreated();

            e.setSuiTimestamp(null);
            e.setSuiTxDigest(null);
            e.setSuiEventSeq(null);
            e.setSuiPackageId(null);
            e.setSuiTransactionModule(null);
            e.setSuiSender(null);
            e.setSuiType(null);
            e.setEventStatus(null);

            e.setCommandId(commandId);
            e.setCreatedBy(requesterId);
            e.setCreatedAt((java.util.Date)ApplicationContext.current.getTimestampService().now(java.util.Date.class));

            e.setWhitelistEventId(eventId);
            return e;
        }

    }

}

