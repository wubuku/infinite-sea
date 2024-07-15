// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.whitelist;

import java.util.*;
import java.math.*;
import java.util.Date;
import java.math.BigInteger;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.*;


public class WhitelistStateDto {

    private String id;

    public String getId()
    {
        return this.id;
    }

    public void setId(String id)
    {
        this.id = id;
    }

    private Boolean paused;

    public Boolean getPaused()
    {
        return this.paused;
    }

    public void setPaused(Boolean paused)
    {
        this.paused = paused;
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

    private BigInteger version;

    public BigInteger getVersion()
    {
        return this.version;
    }

    public void setVersion(BigInteger version)
    {
        this.version = version;
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

    private WhitelistEntryStateDto[] entries;

    public WhitelistEntryStateDto[] getEntries()
    {
        return this.entries;
    }    

    public void setEntries(WhitelistEntryStateDto[] entries)
    {
        this.entries = entries;
    }


    public static class DtoConverter extends AbstractStateDtoConverter
    {
        public static Collection<String> collectionFieldNames = Arrays.asList(new String[]{"Entries"});

        @Override
        protected boolean isCollectionField(String fieldName) {
            return CollectionUtils.collectionContainsIgnoringCase(collectionFieldNames, fieldName);
        }

        public WhitelistStateDto[] toWhitelistStateDtoArray(Iterable<WhitelistState> states) {
            return toWhitelistStateDtoList(states).toArray(new WhitelistStateDto[0]);
        }

        public List<WhitelistStateDto> toWhitelistStateDtoList(Iterable<WhitelistState> states) {
            ArrayList<WhitelistStateDto> stateDtos = new ArrayList();
            for (WhitelistState s : states) {
                WhitelistStateDto dto = toWhitelistStateDto(s);
                stateDtos.add(dto);
            }
            return stateDtos;
        }

        public WhitelistStateDto toWhitelistStateDto(WhitelistState state)
        {
            if(state == null) {
                return null;
            }
            WhitelistStateDto dto = new WhitelistStateDto();
            if (returnedFieldsContains("Id")) {
                dto.setId(state.getId());
            }
            if (returnedFieldsContains("Paused")) {
                dto.setPaused(state.getPaused());
            }
            if (returnedFieldsContains("Active")) {
                dto.setActive(state.getActive());
            }
            if (returnedFieldsContains("Version")) {
                dto.setVersion(state.getVersion());
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
            if (returnedFieldsContains("Entries")) {
                ArrayList<WhitelistEntryStateDto> arrayList = new ArrayList();
                if (state.getEntries() != null) {
                    WhitelistEntryStateDto.DtoConverter conv = new WhitelistEntryStateDto.DtoConverter();
                    String returnFS = CollectionUtils.mapGetValueIgnoringCase(getReturnedFields(), "Entries");
                    if(returnFS != null) { conv.setReturnedFieldsString(returnFS); } else { conv.setAllFieldsReturned(this.getAllFieldsReturned()); }
                    for (WhitelistEntryState s : state.getEntries()) {
                        arrayList.add(conv.toWhitelistEntryStateDto(s));
                    }
                }
                dto.setEntries(arrayList.toArray(new WhitelistEntryStateDto[0]));
            }
            return dto;
        }

    }
}

