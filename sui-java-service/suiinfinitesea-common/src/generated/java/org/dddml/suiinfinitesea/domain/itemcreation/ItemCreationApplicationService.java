// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.itemcreation;

import java.util.Map;
import java.util.List;
import org.dddml.support.criterion.Criterion;
import org.dddml.suiinfinitesea.domain.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.specialization.Event;
import org.dddml.suiinfinitesea.domain.Command;

public interface ItemCreationApplicationService {
    void when(ItemCreationCommands.Create c);

    void when(ItemCreationCommands.Update c);

    ItemCreationState get(SkillTypeItemIdPair id);

    Iterable<ItemCreationState> getAll(Integer firstResult, Integer maxResults);

    Iterable<ItemCreationState> get(Iterable<Map.Entry<String, Object>> filter, List<String> orders, Integer firstResult, Integer maxResults);

    Iterable<ItemCreationState> get(Criterion filter, List<String> orders, Integer firstResult, Integer maxResults);

    Iterable<ItemCreationState> getByProperty(String propertyName, Object propertyValue, List<String> orders, Integer firstResult, Integer maxResults);

    long getCount(Iterable<Map.Entry<String, Object>> filter);

    long getCount(Criterion filter);

    ItemCreationEvent getEvent(SkillTypeItemIdPair itemCreationId, long version);

    ItemCreationState getHistoryState(SkillTypeItemIdPair itemCreationId, long version);

}

