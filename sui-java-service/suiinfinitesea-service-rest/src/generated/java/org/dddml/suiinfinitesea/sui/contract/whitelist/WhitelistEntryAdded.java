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
public class WhitelistEntryAdded {
    private String id;

    private BigInteger version;

    private String accountAddress;

    private String name;

    private String imageUrl;

    private String description;

    private Long backgroundColor;

    private Integer race;

    private Integer eyes;

    private Integer mouth;

    private Integer haircut;

    private Integer skin;

    private Integer outfit;

    private Integer accessories;

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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Long getBackgroundColor() {
        return backgroundColor;
    }

    public void setBackgroundColor(Long backgroundColor) {
        this.backgroundColor = backgroundColor;
    }

    public Integer getRace() {
        return race;
    }

    public void setRace(Integer race) {
        this.race = race;
    }

    public Integer getEyes() {
        return eyes;
    }

    public void setEyes(Integer eyes) {
        this.eyes = eyes;
    }

    public Integer getMouth() {
        return mouth;
    }

    public void setMouth(Integer mouth) {
        this.mouth = mouth;
    }

    public Integer getHaircut() {
        return haircut;
    }

    public void setHaircut(Integer haircut) {
        this.haircut = haircut;
    }

    public Integer getSkin() {
        return skin;
    }

    public void setSkin(Integer skin) {
        this.skin = skin;
    }

    public Integer getOutfit() {
        return outfit;
    }

    public void setOutfit(Integer outfit) {
        this.outfit = outfit;
    }

    public Integer getAccessories() {
        return accessories;
    }

    public void setAccessories(Integer accessories) {
        this.accessories = accessories;
    }

    @Override
    public String toString() {
        return "WhitelistEntryAdded{" +
                "id=" + '\'' + id + '\'' +
                ", version=" + version +
                ", accountAddress=" + '\'' + accountAddress + '\'' +
                ", name=" + '\'' + name + '\'' +
                ", imageUrl=" + '\'' + imageUrl + '\'' +
                ", description=" + '\'' + description + '\'' +
                ", backgroundColor=" + backgroundColor +
                ", race=" + race +
                ", eyes=" + eyes +
                ", mouth=" + mouth +
                ", haircut=" + haircut +
                ", skin=" + skin +
                ", outfit=" + outfit +
                ", accessories=" + accessories +
                '}';
    }

}
