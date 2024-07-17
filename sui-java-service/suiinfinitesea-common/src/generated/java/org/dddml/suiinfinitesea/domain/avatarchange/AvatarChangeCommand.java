// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.avatarchange;

import java.util.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.domain.Command;
import org.dddml.suiinfinitesea.specialization.DomainError;

public interface AvatarChangeCommand extends Command {

    String getAvatarId();

    void setAvatarId(String avatarId);

    String getId_();

    void setId_(String id);

    Long getOffChainVersion();

    void setOffChainVersion(Long offChainVersion);

    static void throwOnInvalidStateTransition(AvatarChangeState state, Command c) {
        if (state.getOffChainVersion() == null) {
            if (isCommandCreate((AvatarChangeCommand)c)) {
                return;
            }
            throw DomainError.named("premature", "Can't do anything to unexistent aggregate");
        }
        if (state.getDeleted() != null && state.getDeleted()) {
            throw DomainError.named("zombie", "Can't do anything to deleted aggregate.");
        }
        if (isCommandCreate((AvatarChangeCommand)c))
            throw DomainError.named("rebirth", "Can't create aggregate that already exists");
    }

    static boolean isCommandCreate(AvatarChangeCommand c) {
        if (c.getOffChainVersion().equals(AvatarChangeState.VERSION_NULL))
            return true;
        return false;
    }

}
