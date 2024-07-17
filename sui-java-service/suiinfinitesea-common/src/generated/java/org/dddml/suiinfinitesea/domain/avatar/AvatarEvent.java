// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.avatar;

import java.util.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.Event;

public interface AvatarEvent extends Event, SuiEventEnvelope, SuiMoveEvent, HasEventStatus {

    interface SqlAvatarEvent extends AvatarEvent {
        AvatarEventId getAvatarEventId();

        boolean getEventReadOnly();

        void setEventReadOnly(boolean readOnly);
    }

    interface AvatarMinted extends AvatarEvent {
        String getOwner();

        void setOwner(String value);

        String getName();

        void setName(String value);

        String getImageUrl();

        void setImageUrl(String value);

        String getDescription();

        void setDescription(String value);

        Long getBackgroundColor();

        void setBackgroundColor(Long value);

        Integer getRace();

        void setRace(Integer value);

        Integer getEyes();

        void setEyes(Integer value);

        Integer getMouth();

        void setMouth(Integer value);

        Integer getHaircut();

        void setHaircut(Integer value);

        Integer getSkin();

        void setSkin(Integer value);

        Integer getOutfit();

        void setOutfit(Integer value);

        Integer getAccessories();

        void setAccessories(Integer value);

        int[] getAura();

        void setAura(int[] value);

        int[] getSymbols();

        void setSymbols(int[] value);

        int[] getEffects();

        void setEffects(int[] value);

        int[] getBackgrounds();

        void setBackgrounds(int[] value);

        int[] getDecorations();

        void setDecorations(int[] value);

        int[] getBadges();

        void setBadges(int[] value);

    }

    interface AvatarUpdated extends AvatarEvent {
    }

    interface AvatarBurned extends AvatarEvent {
    }

    interface AvatarWhitelistMinted extends AvatarEvent {
        String getOwner();

        void setOwner(String value);

        String getName();

        void setName(String value);

        String getImageUrl();

        void setImageUrl(String value);

        String getDescription();

        void setDescription(String value);

        Long getBackgroundColor();

        void setBackgroundColor(Long value);

        Integer getRace();

        void setRace(Integer value);

        Integer getEyes();

        void setEyes(Integer value);

        Integer getMouth();

        void setMouth(Integer value);

        Integer getHaircut();

        void setHaircut(Integer value);

        Integer getSkin();

        void setSkin(Integer value);

        Integer getOutfit();

        void setOutfit(Integer value);

        Integer getAccessories();

        void setAccessories(Integer value);

    }

    String getId();

    //void setId(String id);

    BigInteger getVersion();
    
    //void setVersion(BigInteger version);

    String getCreatedBy();

    void setCreatedBy(String createdBy);

    Date getCreatedAt();

    void setCreatedAt(Date createdAt);

    String getCommandId();

    void setCommandId(String commandId);


}
