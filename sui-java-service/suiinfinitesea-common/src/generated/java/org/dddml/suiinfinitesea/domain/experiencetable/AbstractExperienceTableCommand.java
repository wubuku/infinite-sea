// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.experiencetable;

import java.util.*;
import org.dddml.suiinfinitesea.domain.*;
import java.util.Date;
import java.math.BigInteger;
import org.dddml.suiinfinitesea.domain.AbstractCommand;

public abstract class AbstractExperienceTableCommand extends AbstractCommand implements ExperienceTableCommand {

    private String id;

    public String getId()
    {
        return this.id;
    }

    public void setId(String id)
    {
        this.id = id;
    }

    private Long offChainVersion;

    public Long getOffChainVersion()
    {
        return this.offChainVersion;
    }

    public void setOffChainVersion(Long offChainVersion)
    {
        this.offChainVersion = offChainVersion;
    }


}

