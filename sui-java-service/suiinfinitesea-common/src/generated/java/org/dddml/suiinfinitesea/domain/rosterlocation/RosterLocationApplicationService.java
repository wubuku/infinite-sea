// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.rosterlocation;

import java.util.Map;
import java.util.List;
import org.dddml.support.criterion.Criterion;
import org.dddml.suiinfinitesea.domain.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.specialization.Event;
import org.dddml.suiinfinitesea.domain.Command;

public interface RosterLocationApplicationService {
    RosterLocationState get(String id);

    Iterable<RosterLocationState> getAll(Integer firstResult, Integer maxResults);

    Iterable<RosterLocationState> get(Iterable<Map.Entry<String, Object>> filter, List<String> orders, Integer firstResult, Integer maxResults);

    Iterable<RosterLocationState> get(Criterion filter, List<String> orders, Integer firstResult, Integer maxResults);

    Iterable<RosterLocationState> getByProperty(String propertyName, Object propertyValue, List<String> orders, Integer firstResult, Integer maxResults);

    long getCount(Iterable<Map.Entry<String, Object>> filter);

    long getCount(Criterion filter);

    RosterLocationEvent getEvent(String rosterObjectId, long version);

    RosterLocationState getHistoryState(String rosterObjectId, long version);

}

