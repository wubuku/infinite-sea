// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.player;

import java.util.List;
import org.dddml.suiinfinitesea.domain.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.specialization.Event;
import org.dddml.suiinfinitesea.domain.Command;

public interface PlayerAggregate {
    PlayerState getState();

    List<Event> getChanges();

    void create(Long offChainVersion, String commandId, String requesterId, PlayerCommands.Create c);

    void claimIsland(String map, Coordinates coordinates, String clock, String rosterTable, Long offChainVersion, String commandId, String requesterId, PlayerCommands.ClaimIsland c);

    void airdrop(Long itemId, Long quantity, Long offChainVersion, String commandId, String requesterId, PlayerCommands.Airdrop c);

    void throwOnInvalidStateTransition(Command c);
}

