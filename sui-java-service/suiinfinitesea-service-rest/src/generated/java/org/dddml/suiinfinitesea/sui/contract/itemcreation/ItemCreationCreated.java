// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.itemcreation;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import org.dddml.suiinfinitesea.sui.contract.*;

import java.math.*;
import java.util.*;

@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class ItemCreationCreated {
    private String id;

    private SkillTypeItemIdPairForEvent itemCreationId;

    private Long resourceCost;

    private Integer requirementsLevel;

    private Long baseQuantity;

    private Long baseExperience;

    private BigInteger baseCreationTime;

    private BigInteger energyCost;

    private Integer successRate;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public SkillTypeItemIdPairForEvent getItemCreationId() {
        return itemCreationId;
    }

    public void setItemCreationId(SkillTypeItemIdPairForEvent itemCreationId) {
        this.itemCreationId = itemCreationId;
    }

    public Long getResourceCost() {
        return resourceCost;
    }

    public void setResourceCost(Long resourceCost) {
        this.resourceCost = resourceCost;
    }

    public Integer getRequirementsLevel() {
        return requirementsLevel;
    }

    public void setRequirementsLevel(Integer requirementsLevel) {
        this.requirementsLevel = requirementsLevel;
    }

    public Long getBaseQuantity() {
        return baseQuantity;
    }

    public void setBaseQuantity(Long baseQuantity) {
        this.baseQuantity = baseQuantity;
    }

    public Long getBaseExperience() {
        return baseExperience;
    }

    public void setBaseExperience(Long baseExperience) {
        this.baseExperience = baseExperience;
    }

    public BigInteger getBaseCreationTime() {
        return baseCreationTime;
    }

    public void setBaseCreationTime(BigInteger baseCreationTime) {
        this.baseCreationTime = baseCreationTime;
    }

    public BigInteger getEnergyCost() {
        return energyCost;
    }

    public void setEnergyCost(BigInteger energyCost) {
        this.energyCost = energyCost;
    }

    public Integer getSuccessRate() {
        return successRate;
    }

    public void setSuccessRate(Integer successRate) {
        this.successRate = successRate;
    }

    @Override
    public String toString() {
        return "ItemCreationCreated{" +
                "id=" + '\'' + id + '\'' +
                ", itemCreationId=" + itemCreationId +
                ", resourceCost=" + resourceCost +
                ", requirementsLevel=" + requirementsLevel +
                ", baseQuantity=" + baseQuantity +
                ", baseExperience=" + baseExperience +
                ", baseCreationTime=" + baseCreationTime +
                ", energyCost=" + energyCost +
                ", successRate=" + successRate +
                '}';
    }

}
