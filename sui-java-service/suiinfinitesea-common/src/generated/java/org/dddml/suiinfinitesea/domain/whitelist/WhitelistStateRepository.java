// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.whitelist;

import java.util.*;
import org.dddml.support.criterion.Criterion;
import java.util.Date;
import java.math.BigInteger;
import org.dddml.suiinfinitesea.domain.*;

public interface WhitelistStateRepository {
    WhitelistState get(String id, boolean nullAllowed);

    void save(WhitelistState state);

    void merge(WhitelistState detached);
}
