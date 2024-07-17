// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.avatar;

import java.util.*;
import java.math.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.*;


public class AvatarStateDto {

    private String id;

    public String getId()
    {
        return this.id;
    }

    public void setId(String id)
    {
        this.id = id;
    }

    private String owner;

    public String getOwner()
    {
        return this.owner;
    }

    public void setOwner(String owner)
    {
        this.owner = owner;
    }

    private String name;

    public String getName()
    {
        return this.name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    private String imageUrl;

    public String getImageUrl()
    {
        return this.imageUrl;
    }

    public void setImageUrl(String imageUrl)
    {
        this.imageUrl = imageUrl;
    }

    private String description;

    public String getDescription()
    {
        return this.description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }

    private Long backgroundColor;

    public Long getBackgroundColor()
    {
        return this.backgroundColor;
    }

    public void setBackgroundColor(Long backgroundColor)
    {
        this.backgroundColor = backgroundColor;
    }

    private Integer race;

    public Integer getRace()
    {
        return this.race;
    }

    public void setRace(Integer race)
    {
        this.race = race;
    }

    private Integer eyes;

    public Integer getEyes()
    {
        return this.eyes;
    }

    public void setEyes(Integer eyes)
    {
        this.eyes = eyes;
    }

    private Integer mouth;

    public Integer getMouth()
    {
        return this.mouth;
    }

    public void setMouth(Integer mouth)
    {
        this.mouth = mouth;
    }

    private Integer haircut;

    public Integer getHaircut()
    {
        return this.haircut;
    }

    public void setHaircut(Integer haircut)
    {
        this.haircut = haircut;
    }

    private Integer skin;

    public Integer getSkin()
    {
        return this.skin;
    }

    public void setSkin(Integer skin)
    {
        this.skin = skin;
    }

    private Integer outfit;

    public Integer getOutfit()
    {
        return this.outfit;
    }

    public void setOutfit(Integer outfit)
    {
        this.outfit = outfit;
    }

    private Integer accessories;

    public Integer getAccessories()
    {
        return this.accessories;
    }

    public void setAccessories(Integer accessories)
    {
        this.accessories = accessories;
    }

    private int[] aura;

    public int[] getAura()
    {
        return this.aura;
    }

    public void setAura(int[] aura)
    {
        this.aura = aura;
    }

    private int[] symbols;

    public int[] getSymbols()
    {
        return this.symbols;
    }

    public void setSymbols(int[] symbols)
    {
        this.symbols = symbols;
    }

    private int[] effects;

    public int[] getEffects()
    {
        return this.effects;
    }

    public void setEffects(int[] effects)
    {
        this.effects = effects;
    }

    private int[] backgrounds;

    public int[] getBackgrounds()
    {
        return this.backgrounds;
    }

    public void setBackgrounds(int[] backgrounds)
    {
        this.backgrounds = backgrounds;
    }

    private int[] decorations;

    public int[] getDecorations()
    {
        return this.decorations;
    }

    public void setDecorations(int[] decorations)
    {
        this.decorations = decorations;
    }

    private int[] badges;

    public int[] getBadges()
    {
        return this.badges;
    }

    public void setBadges(int[] badges)
    {
        this.badges = badges;
    }

    private BigInteger version;

    public BigInteger getVersion()
    {
        return this.version;
    }

    public void setVersion(BigInteger version)
    {
        this.version = version;
    }

    private Boolean active;

    public Boolean getActive()
    {
        return this.active;
    }

    public void setActive(Boolean active)
    {
        this.active = active;
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

    private String createdBy;

    public String getCreatedBy()
    {
        return this.createdBy;
    }

    public void setCreatedBy(String createdBy)
    {
        this.createdBy = createdBy;
    }

    private Date createdAt;

    public Date getCreatedAt()
    {
        return this.createdAt;
    }

    public void setCreatedAt(Date createdAt)
    {
        this.createdAt = createdAt;
    }

    private String updatedBy;

    public String getUpdatedBy()
    {
        return this.updatedBy;
    }

    public void setUpdatedBy(String updatedBy)
    {
        this.updatedBy = updatedBy;
    }

    private Date updatedAt;

    public Date getUpdatedAt()
    {
        return this.updatedAt;
    }

    public void setUpdatedAt(Date updatedAt)
    {
        this.updatedAt = updatedAt;
    }


    public static class DtoConverter extends AbstractStateDtoConverter
    {
        public static Collection<String> collectionFieldNames = Arrays.asList(new String[]{});

        @Override
        protected boolean isCollectionField(String fieldName) {
            return CollectionUtils.collectionContainsIgnoringCase(collectionFieldNames, fieldName);
        }

        public AvatarStateDto[] toAvatarStateDtoArray(Iterable<AvatarState> states) {
            return toAvatarStateDtoList(states).toArray(new AvatarStateDto[0]);
        }

        public List<AvatarStateDto> toAvatarStateDtoList(Iterable<AvatarState> states) {
            ArrayList<AvatarStateDto> stateDtos = new ArrayList();
            for (AvatarState s : states) {
                AvatarStateDto dto = toAvatarStateDto(s);
                stateDtos.add(dto);
            }
            return stateDtos;
        }

        public AvatarStateDto toAvatarStateDto(AvatarState state)
        {
            if(state == null) {
                return null;
            }
            AvatarStateDto dto = new AvatarStateDto();
            if (returnedFieldsContains("Id")) {
                dto.setId(state.getId());
            }
            if (returnedFieldsContains("Owner")) {
                dto.setOwner(state.getOwner());
            }
            if (returnedFieldsContains("Name")) {
                dto.setName(state.getName());
            }
            if (returnedFieldsContains("ImageUrl")) {
                dto.setImageUrl(state.getImageUrl());
            }
            if (returnedFieldsContains("Description")) {
                dto.setDescription(state.getDescription());
            }
            if (returnedFieldsContains("BackgroundColor")) {
                dto.setBackgroundColor(state.getBackgroundColor());
            }
            if (returnedFieldsContains("Race")) {
                dto.setRace(state.getRace());
            }
            if (returnedFieldsContains("Eyes")) {
                dto.setEyes(state.getEyes());
            }
            if (returnedFieldsContains("Mouth")) {
                dto.setMouth(state.getMouth());
            }
            if (returnedFieldsContains("Haircut")) {
                dto.setHaircut(state.getHaircut());
            }
            if (returnedFieldsContains("Skin")) {
                dto.setSkin(state.getSkin());
            }
            if (returnedFieldsContains("Outfit")) {
                dto.setOutfit(state.getOutfit());
            }
            if (returnedFieldsContains("Accessories")) {
                dto.setAccessories(state.getAccessories());
            }
            if (returnedFieldsContains("Aura")) {
                dto.setAura(state.getAura());
            }
            if (returnedFieldsContains("Symbols")) {
                dto.setSymbols(state.getSymbols());
            }
            if (returnedFieldsContains("Effects")) {
                dto.setEffects(state.getEffects());
            }
            if (returnedFieldsContains("Backgrounds")) {
                dto.setBackgrounds(state.getBackgrounds());
            }
            if (returnedFieldsContains("Decorations")) {
                dto.setDecorations(state.getDecorations());
            }
            if (returnedFieldsContains("Badges")) {
                dto.setBadges(state.getBadges());
            }
            if (returnedFieldsContains("Version")) {
                dto.setVersion(state.getVersion());
            }
            if (returnedFieldsContains("Active")) {
                dto.setActive(state.getActive());
            }
            if (returnedFieldsContains("OffChainVersion")) {
                dto.setOffChainVersion(state.getOffChainVersion());
            }
            if (returnedFieldsContains("CreatedBy")) {
                dto.setCreatedBy(state.getCreatedBy());
            }
            if (returnedFieldsContains("CreatedAt")) {
                dto.setCreatedAt(state.getCreatedAt());
            }
            if (returnedFieldsContains("UpdatedBy")) {
                dto.setUpdatedBy(state.getUpdatedBy());
            }
            if (returnedFieldsContains("UpdatedAt")) {
                dto.setUpdatedAt(state.getUpdatedAt());
            }
            return dto;
        }

    }
}
