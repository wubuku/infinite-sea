// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.faucetrequested;

import java.util.*;
import java.math.*;
import java.math.BigInteger;
import org.dddml.suiinfinitesea.domain.*;
import java.util.Date;
import org.dddml.suiinfinitesea.specialization.Event;

public interface FaucetRequestedState extends SuiMoveEvent, SuiEventEnvelope, HasSuiEventNextCursor, VersionedSuiMoveObject
{
    Long VERSION_ZERO = 0L;

    Long VERSION_NULL = VERSION_ZERO - 1;

    String getEventId();

    String getRequesterAccount();

    BigInteger getRequestedAmount();

    String getDescription();

    Long getOffChainVersion();

    String getCreatedBy();

    Date getCreatedAt();

    String getUpdatedBy();

    Date getUpdatedAt();

    Boolean getActive();

    Boolean getDeleted();

    String getCommandId();

    interface MutableFaucetRequestedState extends FaucetRequestedState, SuiMoveEvent.MutableSuiMoveEvent, SuiEventEnvelope.MutableSuiEventEnvelope, HasSuiEventNextCursor.MutableHasSuiEventNextCursor, VersionedSuiMoveObject.MutableVersionedSuiMoveObject {
        void setEventId(String eventId);

        void setRequesterAccount(String requesterAccount);

        void setRequestedAmount(BigInteger requestedAmount);

        void setDescription(String description);

        void setOffChainVersion(Long offChainVersion);

        void setCreatedBy(String createdBy);

        void setCreatedAt(Date createdAt);

        void setUpdatedBy(String updatedBy);

        void setUpdatedAt(Date updatedAt);

        void setActive(Boolean active);

        void setDeleted(Boolean deleted);

        void setCommandId(String commandId);

    }

    interface SqlFaucetRequestedState extends MutableFaucetRequestedState {

        boolean isStateUnsaved();

        boolean getForReapplying();
    }
}

