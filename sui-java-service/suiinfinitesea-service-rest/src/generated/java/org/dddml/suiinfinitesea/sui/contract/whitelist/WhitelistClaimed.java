// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.whitelist;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import org.dddml.suiinfinitesea.sui.contract.*;

import java.math.*;
import java.util.*;

@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class WhitelistClaimed {
    private String id;

    private BigInteger version;

    private String accountAddress;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public BigInteger getVersion() {
        return version;
    }

    public void setVersion(BigInteger version) {
        this.version = version;
    }

    public String getAccountAddress() {
        return accountAddress;
    }

    public void setAccountAddress(String accountAddress) {
        this.accountAddress = accountAddress;
    }

    @Override
    public String toString() {
        return "WhitelistClaimed{" +
                "id=" + '\'' + id + '\'' +
                ", version=" + version +
                ", accountAddress=" + '\'' + accountAddress + '\'' +
                '}';
    }

}