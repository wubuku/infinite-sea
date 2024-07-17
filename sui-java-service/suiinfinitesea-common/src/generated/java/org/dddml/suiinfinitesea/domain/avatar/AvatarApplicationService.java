// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.avatar;

import java.util.Map;
import java.util.List;
import org.dddml.support.criterion.Criterion;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.Event;
import org.dddml.suiinfinitesea.domain.Command;

public interface AvatarApplicationService {
    void when(AvatarCommands.Mint c);

    void when(AvatarCommands.Update c);

    void when(AvatarCommands.Burn c);

    void when(AvatarCommands.WhitelistMint c);

    AvatarState get(String id);

    Iterable<AvatarState> getAll(Integer firstResult, Integer maxResults);

    Iterable<AvatarState> get(Iterable<Map.Entry<String, Object>> filter, List<String> orders, Integer firstResult, Integer maxResults);

    Iterable<AvatarState> get(Criterion filter, List<String> orders, Integer firstResult, Integer maxResults);

    Iterable<AvatarState> getByProperty(String propertyName, Object propertyValue, List<String> orders, Integer firstResult, Integer maxResults);

    long getCount(Iterable<Map.Entry<String, Object>> filter);

    long getCount(Criterion filter);

    AvatarEvent getEvent(String id, long version);

    AvatarState getHistoryState(String id, long version);

}
