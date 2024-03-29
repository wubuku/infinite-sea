// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.item;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import org.dddml.suiinfinitesea.sui.contract.*;

import java.math.*;
import java.util.*;

@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class ItemCreated {
    private String id;

    private Long itemId;

    private String name;

    private Boolean requiredForCompletion;

    private Long sellsFor;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Long getItemId() {
        return itemId;
    }

    public void setItemId(Long itemId) {
        this.itemId = itemId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Boolean getRequiredForCompletion() {
        return requiredForCompletion;
    }

    public void setRequiredForCompletion(Boolean requiredForCompletion) {
        this.requiredForCompletion = requiredForCompletion;
    }

    public Long getSellsFor() {
        return sellsFor;
    }

    public void setSellsFor(Long sellsFor) {
        this.sellsFor = sellsFor;
    }

    @Override
    public String toString() {
        return "ItemCreated{" +
                "id=" + '\'' + id + '\'' +
                ", itemId=" + itemId +
                ", name=" + '\'' + name + '\'' +
                ", requiredForCompletion=" + requiredForCompletion +
                ", sellsFor=" + sellsFor +
                '}';
    }

}
