// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import com.github.wubuku.sui.bean.*;

import java.math.*;
import java.util.*;

@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class Whitelist {

    private UID id;

    private Long offChainVersion;

    private Boolean paused;

    private BigInteger version;

    private Table entries;

    public UID getId() {
        return id;
    }

    public void setId(UID id) {
        this.id = id;
    }

    public Long getOffChainVersion() {
        return offChainVersion;
    }

    public void setOffChainVersion(Long offChainVersion) {
        this.offChainVersion = offChainVersion;
    }

    public Boolean getPaused() {
        return paused;
    }

    public void setPaused(Boolean paused) {
        this.paused = paused;
    }

    public BigInteger getVersion() {
        return version;
    }

    public void setVersion(BigInteger version) {
        this.version = version;
    }

    public Table getEntries() {
        return entries;
    }

    public void setEntries(Table entries) {
        this.entries = entries;
    }

    @Override
    public String toString() {
        return "Whitelist{" +
                "id=" + id +
                ", offChainVersion=" + offChainVersion +
                ", paused=" + paused +
                ", version=" + version +
                ", entries=" + entries +
                '}';
    }
}
