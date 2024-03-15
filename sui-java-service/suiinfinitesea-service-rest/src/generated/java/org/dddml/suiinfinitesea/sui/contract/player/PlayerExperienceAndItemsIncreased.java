// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.player;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import org.dddml.suiinfinitesea.sui.contract.*;

import java.math.*;
import java.util.*;

@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class PlayerExperienceAndItemsIncreased {
    private String id;

    private BigInteger version;

    private Long experience;

    private ProductionMaterial[] items;

    private Integer newLevel;

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

    public Long getExperience() {
        return experience;
    }

    public void setExperience(Long experience) {
        this.experience = experience;
    }

    public ProductionMaterial[] getItems() {
        return items;
    }

    public void setItems(ProductionMaterial[] items) {
        this.items = items;
    }

    public Integer getNewLevel() {
        return newLevel;
    }

    public void setNewLevel(Integer newLevel) {
        this.newLevel = newLevel;
    }

    @Override
    public String toString() {
        return "PlayerExperienceAndItemsIncreased{" +
                "id=" + '\'' + id + '\'' +
                ", version=" + version +
                ", experience=" + experience +
                ", items=" + Arrays.toString(items) +
                ", newLevel=" + newLevel +
                '}';
    }

}