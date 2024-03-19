// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.skillprocessmutex;

import java.util.Map;
import java.util.List;
import org.dddml.support.criterion.Criterion;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.Event;
import org.dddml.suiinfinitesea.domain.Command;

public interface SkillProcessMutexApplicationService {
    void when(SkillProcessMutexCommands.Create c);

    void when(SkillProcessMutexCommands.Lock c);

    void when(SkillProcessMutexCommands.Unlock c);

    SkillProcessMutexState get(String id);

    Iterable<SkillProcessMutexState> getAll(Integer firstResult, Integer maxResults);

    Iterable<SkillProcessMutexState> get(Iterable<Map.Entry<String, Object>> filter, List<String> orders, Integer firstResult, Integer maxResults);

    Iterable<SkillProcessMutexState> get(Criterion filter, List<String> orders, Integer firstResult, Integer maxResults);

    Iterable<SkillProcessMutexState> getByProperty(String propertyName, Object propertyValue, List<String> orders, Integer firstResult, Integer maxResults);

    long getCount(Iterable<Map.Entry<String, Object>> filter);

    long getCount(Criterion filter);

    SkillProcessMutexEvent getEvent(String playerId, long version);

    SkillProcessMutexState getHistoryState(String playerId, long version);

}

