// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.avatarchange;

import java.util.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.*;

public abstract class AbstractAvatarChangeAggregate extends AbstractAggregate implements AvatarChangeAggregate {
    private AvatarChangeState.MutableAvatarChangeState state;

    private List<Event> changes = new ArrayList<Event>();

    public AbstractAvatarChangeAggregate(AvatarChangeState state) {
        this.state = (AvatarChangeState.MutableAvatarChangeState)state;
    }

    public AvatarChangeState getState() {
        return this.state;
    }

    public List<Event> getChanges() {
        return this.changes;
    }

    public void throwOnInvalidStateTransition(Command c) {
        AvatarChangeCommand.throwOnInvalidStateTransition(this.state, c);
    }

    protected void apply(Event e) {
        onApplying(e);
        state.mutate(e);
        changes.add(e);
    }


    ////////////////////////

    public static class SimpleAvatarChangeAggregate extends AbstractAvatarChangeAggregate {
        public SimpleAvatarChangeAggregate(AvatarChangeState state) {
            super(state);
        }

        @Override
        public void create(String imageUrl, Long backgroundColor, Integer haircut, Integer outfit, Integer accessories, int[] aura, int[] symbols, int[] effects, int[] backgrounds, int[] decorations, int[] badges, Long offChainVersion, String commandId, String requesterId, AvatarChangeCommands.Create c) {
            java.util.function.Supplier<AvatarChangeEvent.AvatarChangeCreated> eventFactory = () -> newAvatarChangeCreated(imageUrl, backgroundColor, haircut, outfit, accessories, aura, symbols, effects, backgrounds, decorations, badges, offChainVersion, commandId, requesterId);
            AvatarChangeEvent.AvatarChangeCreated e;
            try {
                e = verifyCreate(eventFactory, imageUrl, backgroundColor, haircut, outfit, accessories, aura, symbols, effects, backgrounds, decorations, badges, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        @Override
        public void update(String imageUrl, Long backgroundColor, Integer haircut, Integer outfit, Integer accessories, int[] aura, int[] symbols, int[] effects, int[] backgrounds, int[] decorations, int[] badges, Long offChainVersion, String commandId, String requesterId, AvatarChangeCommands.Update c) {
            java.util.function.Supplier<AvatarChangeEvent.AvatarChangeUpdated> eventFactory = () -> newAvatarChangeUpdated(imageUrl, backgroundColor, haircut, outfit, accessories, aura, symbols, effects, backgrounds, decorations, badges, offChainVersion, commandId, requesterId);
            AvatarChangeEvent.AvatarChangeUpdated e;
            try {
                e = verifyUpdate(eventFactory, imageUrl, backgroundColor, haircut, outfit, accessories, aura, symbols, effects, backgrounds, decorations, badges, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        @Override
        public void delete(Long offChainVersion, String commandId, String requesterId, AvatarChangeCommands.Delete c) {
            java.util.function.Supplier<AvatarChangeEvent.AvatarChangeDeleted> eventFactory = () -> newAvatarChangeDeleted(offChainVersion, commandId, requesterId);
            AvatarChangeEvent.AvatarChangeDeleted e;
            try {
                e = verifyDelete(eventFactory, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        protected AvatarChangeEvent.AvatarChangeCreated verifyCreate(java.util.function.Supplier<AvatarChangeEvent.AvatarChangeCreated> eventFactory, String imageUrl, Long backgroundColor, Integer haircut, Integer outfit, Integer accessories, int[] aura, int[] symbols, int[] effects, int[] backgrounds, int[] decorations, int[] badges, AvatarChangeCommands.Create c) {
            String ImageUrl = imageUrl;
            Long BackgroundColor = backgroundColor;
            Integer Haircut = haircut;
            Integer Outfit = outfit;
            Integer Accessories = accessories;
            int[] Aura = aura;
            int[] Symbols = symbols;
            int[] Effects = effects;
            int[] Backgrounds = backgrounds;
            int[] Decorations = decorations;
            int[] Badges = badges;

            AvatarChangeEvent.AvatarChangeCreated e = (AvatarChangeEvent.AvatarChangeCreated) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.avatarchange.CreateLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, AvatarChangeState.class, String.class, Long.class, Integer.class, Integer.class, Integer.class, int[].class, int[].class, int[].class, int[].class, int[].class, int[].class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), imageUrl, backgroundColor, haircut, outfit, accessories, aura, symbols, effects, backgrounds, decorations, badges, VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.avatarchange;
//
//public class CreateLogic {
//    public static AvatarChangeEvent.AvatarChangeCreated verify(java.util.function.Supplier<AvatarChangeEvent.AvatarChangeCreated> eventFactory, AvatarChangeState avatarChangeState, String imageUrl, Long backgroundColor, Integer haircut, Integer outfit, Integer accessories, int[] aura, int[] symbols, int[] effects, int[] backgrounds, int[] decorations, int[] badges, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected AvatarChangeEvent.AvatarChangeUpdated verifyUpdate(java.util.function.Supplier<AvatarChangeEvent.AvatarChangeUpdated> eventFactory, String imageUrl, Long backgroundColor, Integer haircut, Integer outfit, Integer accessories, int[] aura, int[] symbols, int[] effects, int[] backgrounds, int[] decorations, int[] badges, AvatarChangeCommands.Update c) {
            String ImageUrl = imageUrl;
            Long BackgroundColor = backgroundColor;
            Integer Haircut = haircut;
            Integer Outfit = outfit;
            Integer Accessories = accessories;
            int[] Aura = aura;
            int[] Symbols = symbols;
            int[] Effects = effects;
            int[] Backgrounds = backgrounds;
            int[] Decorations = decorations;
            int[] Badges = badges;

            AvatarChangeEvent.AvatarChangeUpdated e = (AvatarChangeEvent.AvatarChangeUpdated) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.avatarchange.UpdateLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, AvatarChangeState.class, String.class, Long.class, Integer.class, Integer.class, Integer.class, int[].class, int[].class, int[].class, int[].class, int[].class, int[].class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), imageUrl, backgroundColor, haircut, outfit, accessories, aura, symbols, effects, backgrounds, decorations, badges, VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.avatarchange;
//
//public class UpdateLogic {
//    public static AvatarChangeEvent.AvatarChangeUpdated verify(java.util.function.Supplier<AvatarChangeEvent.AvatarChangeUpdated> eventFactory, AvatarChangeState avatarChangeState, String imageUrl, Long backgroundColor, Integer haircut, Integer outfit, Integer accessories, int[] aura, int[] symbols, int[] effects, int[] backgrounds, int[] decorations, int[] badges, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected AvatarChangeEvent.AvatarChangeDeleted verifyDelete(java.util.function.Supplier<AvatarChangeEvent.AvatarChangeDeleted> eventFactory, AvatarChangeCommands.Delete c) {

            AvatarChangeEvent.AvatarChangeDeleted e = (AvatarChangeEvent.AvatarChangeDeleted) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.avatarchange.DeleteLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, AvatarChangeState.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.avatarchange;
//
//public class DeleteLogic {
//    public static AvatarChangeEvent.AvatarChangeDeleted verify(java.util.function.Supplier<AvatarChangeEvent.AvatarChangeDeleted> eventFactory, AvatarChangeState avatarChangeState, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected AbstractAvatarChangeEvent.AvatarChangeCreated newAvatarChangeCreated(String imageUrl, Long backgroundColor, Integer haircut, Integer outfit, Integer accessories, int[] aura, int[] symbols, int[] effects, int[] backgrounds, int[] decorations, int[] badges, Long offChainVersion, String commandId, String requesterId) {
            AvatarChangeEventId eventId = new AvatarChangeEventId(getState().getAvatarId(), null);
            AbstractAvatarChangeEvent.AvatarChangeCreated e = new AbstractAvatarChangeEvent.AvatarChangeCreated();

            e.setImageUrl(imageUrl);
            e.setBackgroundColor(backgroundColor);
            e.setHaircut(haircut);
            e.setOutfit(outfit);
            e.setAccessories(accessories);
            e.setAura(aura);
            e.setSymbols(symbols);
            e.setEffects(effects);
            e.setBackgrounds(backgrounds);
            e.setDecorations(decorations);
            e.setBadges(badges);
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

            e.setAvatarChangeEventId(eventId);
            return e;
        }

        protected AbstractAvatarChangeEvent.AvatarChangeUpdated newAvatarChangeUpdated(String imageUrl, Long backgroundColor, Integer haircut, Integer outfit, Integer accessories, int[] aura, int[] symbols, int[] effects, int[] backgrounds, int[] decorations, int[] badges, Long offChainVersion, String commandId, String requesterId) {
            AvatarChangeEventId eventId = new AvatarChangeEventId(getState().getAvatarId(), null);
            AbstractAvatarChangeEvent.AvatarChangeUpdated e = new AbstractAvatarChangeEvent.AvatarChangeUpdated();

            e.setImageUrl(imageUrl);
            e.setBackgroundColor(backgroundColor);
            e.setHaircut(haircut);
            e.setOutfit(outfit);
            e.setAccessories(accessories);
            e.setAura(aura);
            e.setSymbols(symbols);
            e.setEffects(effects);
            e.setBackgrounds(backgrounds);
            e.setDecorations(decorations);
            e.setBadges(badges);
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

            e.setAvatarChangeEventId(eventId);
            return e;
        }

        protected AbstractAvatarChangeEvent.AvatarChangeDeleted newAvatarChangeDeleted(Long offChainVersion, String commandId, String requesterId) {
            AvatarChangeEventId eventId = new AvatarChangeEventId(getState().getAvatarId(), null);
            AbstractAvatarChangeEvent.AvatarChangeDeleted e = new AbstractAvatarChangeEvent.AvatarChangeDeleted();

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

            e.setAvatarChangeEventId(eventId);
            return e;
        }

    }

}

