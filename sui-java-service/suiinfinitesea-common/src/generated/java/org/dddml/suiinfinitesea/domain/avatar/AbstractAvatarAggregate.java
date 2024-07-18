// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.avatar;

import java.util.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.*;

public abstract class AbstractAvatarAggregate extends AbstractAggregate implements AvatarAggregate {
    private AvatarState.MutableAvatarState state;

    private List<Event> changes = new ArrayList<Event>();

    public AbstractAvatarAggregate(AvatarState state) {
        this.state = (AvatarState.MutableAvatarState)state;
    }

    public AvatarState getState() {
        return this.state;
    }

    public List<Event> getChanges() {
        return this.changes;
    }

    public void throwOnInvalidStateTransition(Command c) {
        AvatarCommand.throwOnInvalidStateTransition(this.state, c);
    }

    protected void apply(Event e) {
        onApplying(e);
        state.mutate(e);
        changes.add(e);
    }


    ////////////////////////

    public static class SimpleAvatarAggregate extends AbstractAvatarAggregate {
        public SimpleAvatarAggregate(AvatarState state) {
            super(state);
        }

        @Override
        public void mint(String owner, String name, String imageUrl, String description, Long backgroundColor, Integer race, Integer eyes, Integer mouth, Integer haircut, Integer skin, Integer outfit, Integer accessories, int[] aura, int[] symbols, int[] effects, int[] backgrounds, int[] decorations, int[] badges, Long offChainVersion, String commandId, String requesterId, AvatarCommands.Mint c) {
            java.util.function.Supplier<AvatarEvent.AvatarMinted> eventFactory = () -> newAvatarMinted(owner, name, imageUrl, description, backgroundColor, race, eyes, mouth, haircut, skin, outfit, accessories, aura, symbols, effects, backgrounds, decorations, badges, offChainVersion, commandId, requesterId);
            AvatarEvent.AvatarMinted e;
            try {
                e = verifyMint(eventFactory, owner, name, imageUrl, description, backgroundColor, race, eyes, mouth, haircut, skin, outfit, accessories, aura, symbols, effects, backgrounds, decorations, badges, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        @Override
        public void update(String avatarChange, Long offChainVersion, String commandId, String requesterId, AvatarCommands.Update c) {
            java.util.function.Supplier<AvatarEvent.AvatarUpdated> eventFactory = () -> newAvatarUpdated(avatarChange, offChainVersion, commandId, requesterId);
            AvatarEvent.AvatarUpdated e;
            try {
                e = verifyUpdate(eventFactory, avatarChange, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        @Override
        public void burn(Long offChainVersion, String commandId, String requesterId, AvatarCommands.Burn c) {
            java.util.function.Supplier<AvatarEvent.AvatarBurned> eventFactory = () -> newAvatarBurned(offChainVersion, commandId, requesterId);
            AvatarEvent.AvatarBurned e;
            try {
                e = verifyBurn(eventFactory, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        @Override
        public void whitelistMint(String whitelist, Long offChainVersion, String commandId, String requesterId, AvatarCommands.WhitelistMint c) {
            java.util.function.Supplier<AvatarEvent.AvatarWhitelistMinted> eventFactory = () -> newAvatarWhitelistMinted(whitelist, offChainVersion, commandId, requesterId);
            AvatarEvent.AvatarWhitelistMinted e;
            try {
                e = verifyWhitelistMint(eventFactory, whitelist, c);
            } catch (Exception ex) {
                throw new DomainError("VerificationFailed", ex);
            }

            apply(e);
        }

        protected AvatarEvent.AvatarMinted verifyMint(java.util.function.Supplier<AvatarEvent.AvatarMinted> eventFactory, String owner, String name, String imageUrl, String description, Long backgroundColor, Integer race, Integer eyes, Integer mouth, Integer haircut, Integer skin, Integer outfit, Integer accessories, int[] aura, int[] symbols, int[] effects, int[] backgrounds, int[] decorations, int[] badges, AvatarCommands.Mint c) {
            String Owner = owner;
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
            int[] Aura = aura;
            int[] Symbols = symbols;
            int[] Effects = effects;
            int[] Backgrounds = backgrounds;
            int[] Decorations = decorations;
            int[] Badges = badges;

            AvatarEvent.AvatarMinted e = (AvatarEvent.AvatarMinted) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.avatar.MintLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, AvatarState.class, String.class, String.class, String.class, String.class, Long.class, Integer.class, Integer.class, Integer.class, Integer.class, Integer.class, Integer.class, Integer.class, int[].class, int[].class, int[].class, int[].class, int[].class, int[].class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), owner, name, imageUrl, description, backgroundColor, race, eyes, mouth, haircut, skin, outfit, accessories, aura, symbols, effects, backgrounds, decorations, badges, VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.avatar;
//
//public class MintLogic {
//    public static AvatarEvent.AvatarMinted verify(java.util.function.Supplier<AvatarEvent.AvatarMinted> eventFactory, AvatarState avatarState, String owner, String name, String imageUrl, String description, Long backgroundColor, Integer race, Integer eyes, Integer mouth, Integer haircut, Integer skin, Integer outfit, Integer accessories, int[] aura, int[] symbols, int[] effects, int[] backgrounds, int[] decorations, int[] badges, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected AvatarEvent.AvatarUpdated verifyUpdate(java.util.function.Supplier<AvatarEvent.AvatarUpdated> eventFactory, String avatarChange, AvatarCommands.Update c) {
            String AvatarChange = avatarChange;

            AvatarEvent.AvatarUpdated e = (AvatarEvent.AvatarUpdated) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.avatar.UpdateLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, AvatarState.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), avatarChange, VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.avatar;
//
//public class UpdateLogic {
//    public static AvatarEvent.AvatarUpdated verify(java.util.function.Supplier<AvatarEvent.AvatarUpdated> eventFactory, AvatarState avatarState, String avatarChange, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected AvatarEvent.AvatarBurned verifyBurn(java.util.function.Supplier<AvatarEvent.AvatarBurned> eventFactory, AvatarCommands.Burn c) {

            AvatarEvent.AvatarBurned e = (AvatarEvent.AvatarBurned) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.avatar.BurnLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, AvatarState.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.avatar;
//
//public class BurnLogic {
//    public static AvatarEvent.AvatarBurned verify(java.util.function.Supplier<AvatarEvent.AvatarBurned> eventFactory, AvatarState avatarState, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected AvatarEvent.AvatarWhitelistMinted verifyWhitelistMint(java.util.function.Supplier<AvatarEvent.AvatarWhitelistMinted> eventFactory, String whitelist, AvatarCommands.WhitelistMint c) {
            String Whitelist = whitelist;

            AvatarEvent.AvatarWhitelistMinted e = (AvatarEvent.AvatarWhitelistMinted) ReflectUtils.invokeStaticMethod(
                    "org.dddml.suiinfinitesea.domain.avatar.WhitelistMintLogic",
                    "verify",
                    new Class[]{java.util.function.Supplier.class, AvatarState.class, VerificationContext.class},
                    new Object[]{eventFactory, getState(), whitelist, VerificationContext.forCommand(c)}
            );

//package org.dddml.suiinfinitesea.domain.avatar;
//
//public class WhitelistMintLogic {
//    public static AvatarEvent.AvatarWhitelistMinted verify(java.util.function.Supplier<AvatarEvent.AvatarWhitelistMinted> eventFactory, AvatarState avatarState, String whitelist, VerificationContext verificationContext) {
//    }
//}

            return e;
        }
           

        protected AbstractAvatarEvent.AvatarMinted newAvatarMinted(String owner, String name, String imageUrl, String description, Long backgroundColor, Integer race, Integer eyes, Integer mouth, Integer haircut, Integer skin, Integer outfit, Integer accessories, int[] aura, int[] symbols, int[] effects, int[] backgrounds, int[] decorations, int[] badges, Long offChainVersion, String commandId, String requesterId) {
            AvatarEventId eventId = new AvatarEventId(getState().getId(), null);
            AbstractAvatarEvent.AvatarMinted e = new AbstractAvatarEvent.AvatarMinted();

            e.getDynamicProperties().put("owner", owner);
            e.getDynamicProperties().put("name", name);
            e.getDynamicProperties().put("imageUrl", imageUrl);
            e.getDynamicProperties().put("description", description);
            e.getDynamicProperties().put("backgroundColor", backgroundColor);
            e.getDynamicProperties().put("race", race);
            e.getDynamicProperties().put("eyes", eyes);
            e.getDynamicProperties().put("mouth", mouth);
            e.getDynamicProperties().put("haircut", haircut);
            e.getDynamicProperties().put("skin", skin);
            e.getDynamicProperties().put("outfit", outfit);
            e.getDynamicProperties().put("accessories", accessories);
            e.getDynamicProperties().put("aura", aura);
            e.getDynamicProperties().put("symbols", symbols);
            e.getDynamicProperties().put("effects", effects);
            e.getDynamicProperties().put("backgrounds", backgrounds);
            e.getDynamicProperties().put("decorations", decorations);
            e.getDynamicProperties().put("badges", badges);
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

            e.setAvatarEventId(eventId);
            return e;
        }

        protected AbstractAvatarEvent.AvatarUpdated newAvatarUpdated(String avatarChange, Long offChainVersion, String commandId, String requesterId) {
            AvatarEventId eventId = new AvatarEventId(getState().getId(), null);
            AbstractAvatarEvent.AvatarUpdated e = new AbstractAvatarEvent.AvatarUpdated();

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

            e.setAvatarEventId(eventId);
            return e;
        }

        protected AbstractAvatarEvent.AvatarBurned newAvatarBurned(Long offChainVersion, String commandId, String requesterId) {
            AvatarEventId eventId = new AvatarEventId(getState().getId(), null);
            AbstractAvatarEvent.AvatarBurned e = new AbstractAvatarEvent.AvatarBurned();

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

            e.setAvatarEventId(eventId);
            return e;
        }

        protected AbstractAvatarEvent.AvatarWhitelistMinted newAvatarWhitelistMinted(String whitelist, Long offChainVersion, String commandId, String requesterId) {
            AvatarEventId eventId = new AvatarEventId(getState().getId(), null);
            AbstractAvatarEvent.AvatarWhitelistMinted e = new AbstractAvatarEvent.AvatarWhitelistMinted();

            e.setOwner(null);
            e.setName(null);
            e.setImageUrl(null);
            e.setDescription(null);
            e.setBackgroundColor(null);
            e.setRace(null);
            e.setEyes(null);
            e.setMouth(null);
            e.setHaircut(null);
            e.setSkin(null);
            e.setOutfit(null);
            e.setAccessories(null);
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

            e.setAvatarEventId(eventId);
            return e;
        }

    }

}

