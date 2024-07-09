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
public class AvatarChange {

    private UID id;

    private String avatarId;

    private Long offChainVersion;

    private String imageUrl;

    private Long backgroundColor;

    private Integer haircut;

    private Integer outfit;

    private int[] accessories;

    private Integer aura;

    private int[] symbols;

    private int[] effects;

    private int[] backgrounds;

    private int[] decorations;

    private int[] badges;

    private BigInteger version;

    public UID getId() {
        return id;
    }

    public void setId(UID id) {
        this.id = id;
    }

    public String getAvatarId() {
        return avatarId;
    }

    public void setAvatarId(String avatarId) {
        this.avatarId = avatarId;
    }

    public Long getOffChainVersion() {
        return offChainVersion;
    }

    public void setOffChainVersion(Long offChainVersion) {
        this.offChainVersion = offChainVersion;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Long getBackgroundColor() {
        return backgroundColor;
    }

    public void setBackgroundColor(Long backgroundColor) {
        this.backgroundColor = backgroundColor;
    }

    public Integer getHaircut() {
        return haircut;
    }

    public void setHaircut(Integer haircut) {
        this.haircut = haircut;
    }

    public Integer getOutfit() {
        return outfit;
    }

    public void setOutfit(Integer outfit) {
        this.outfit = outfit;
    }

    public int[] getAccessories() {
        return accessories;
    }

    public void setAccessories(int[] accessories) {
        this.accessories = accessories;
    }

    public Integer getAura() {
        return aura;
    }

    public void setAura(Integer aura) {
        this.aura = aura;
    }

    public int[] getSymbols() {
        return symbols;
    }

    public void setSymbols(int[] symbols) {
        this.symbols = symbols;
    }

    public int[] getEffects() {
        return effects;
    }

    public void setEffects(int[] effects) {
        this.effects = effects;
    }

    public int[] getBackgrounds() {
        return backgrounds;
    }

    public void setBackgrounds(int[] backgrounds) {
        this.backgrounds = backgrounds;
    }

    public int[] getDecorations() {
        return decorations;
    }

    public void setDecorations(int[] decorations) {
        this.decorations = decorations;
    }

    public int[] getBadges() {
        return badges;
    }

    public void setBadges(int[] badges) {
        this.badges = badges;
    }

    public BigInteger getVersion() {
        return version;
    }

    public void setVersion(BigInteger version) {
        this.version = version;
    }

    @Override
    public String toString() {
        return "AvatarChange{" +
                "id=" + id +
                ", avatarId=" + '\'' + avatarId + '\'' +
                ", offChainVersion=" + offChainVersion +
                ", imageUrl=" + '\'' + imageUrl + '\'' +
                ", backgroundColor=" + backgroundColor +
                ", haircut=" + haircut +
                ", outfit=" + outfit +
                ", accessories=" + Arrays.toString(accessories) +
                ", aura=" + aura +
                ", symbols=" + Arrays.toString(symbols) +
                ", effects=" + Arrays.toString(effects) +
                ", backgrounds=" + Arrays.toString(backgrounds) +
                ", decorations=" + Arrays.toString(decorations) +
                ", badges=" + Arrays.toString(badges) +
                ", version=" + version +
                '}';
    }
}
