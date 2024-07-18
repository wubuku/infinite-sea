// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.faucetrequested;

import java.util.*;
import java.math.*;
import java.math.BigInteger;
import org.dddml.suiinfinitesea.domain.*;
import java.util.Date;
import org.dddml.suiinfinitesea.specialization.*;


public class FaucetRequestedStateDto {

    private String eventId;

    public String getEventId()
    {
        return this.eventId;
    }

    public void setEventId(String eventId)
    {
        this.eventId = eventId;
    }

    private String id_;

    public String getId_()
    {
        return this.id_;
    }

    public void setId_(String id)
    {
        this.id_ = id;
    }

    private String requesterAccount;

    public String getRequesterAccount()
    {
        return this.requesterAccount;
    }

    public void setRequesterAccount(String requesterAccount)
    {
        this.requesterAccount = requesterAccount;
    }

    private BigInteger requestedAmount;

    public BigInteger getRequestedAmount()
    {
        return this.requestedAmount;
    }

    public void setRequestedAmount(BigInteger requestedAmount)
    {
        this.requestedAmount = requestedAmount;
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

    private String suiPackageId;

    public String getSuiPackageId()
    {
        return this.suiPackageId;
    }

    public void setSuiPackageId(String suiPackageId)
    {
        this.suiPackageId = suiPackageId;
    }

    private String suiTransactionModule;

    public String getSuiTransactionModule()
    {
        return this.suiTransactionModule;
    }

    public void setSuiTransactionModule(String suiTransactionModule)
    {
        this.suiTransactionModule = suiTransactionModule;
    }

    private String suiSender;

    public String getSuiSender()
    {
        return this.suiSender;
    }

    public void setSuiSender(String suiSender)
    {
        this.suiSender = suiSender;
    }

    private String suiType;

    public String getSuiType()
    {
        return this.suiType;
    }

    public void setSuiType(String suiType)
    {
        this.suiType = suiType;
    }

    private Long suiTimestamp;

    public Long getSuiTimestamp()
    {
        return this.suiTimestamp;
    }

    public void setSuiTimestamp(Long suiTimestamp)
    {
        this.suiTimestamp = suiTimestamp;
    }

    private String suiTxDigest;

    public String getSuiTxDigest()
    {
        return this.suiTxDigest;
    }

    public void setSuiTxDigest(String suiTxDigest)
    {
        this.suiTxDigest = suiTxDigest;
    }

    private BigInteger suiEventSeq;

    public BigInteger getSuiEventSeq()
    {
        return this.suiEventSeq;
    }

    public void setSuiEventSeq(BigInteger suiEventSeq)
    {
        this.suiEventSeq = suiEventSeq;
    }

    private SuiEventId nextCursor;

    public SuiEventId getNextCursor()
    {
        return this.nextCursor;
    }

    public void setNextCursor(SuiEventId nextCursor)
    {
        this.nextCursor = nextCursor;
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

        public FaucetRequestedStateDto[] toFaucetRequestedStateDtoArray(Iterable<FaucetRequestedState> states) {
            return toFaucetRequestedStateDtoList(states).toArray(new FaucetRequestedStateDto[0]);
        }

        public List<FaucetRequestedStateDto> toFaucetRequestedStateDtoList(Iterable<FaucetRequestedState> states) {
            ArrayList<FaucetRequestedStateDto> stateDtos = new ArrayList();
            for (FaucetRequestedState s : states) {
                FaucetRequestedStateDto dto = toFaucetRequestedStateDto(s);
                stateDtos.add(dto);
            }
            return stateDtos;
        }

        public FaucetRequestedStateDto toFaucetRequestedStateDto(FaucetRequestedState state)
        {
            if(state == null) {
                return null;
            }
            FaucetRequestedStateDto dto = new FaucetRequestedStateDto();
            if (returnedFieldsContains("EventId")) {
                dto.setEventId(state.getEventId());
            }
            if (returnedFieldsContains("Id_")) {
                dto.setId_(state.getId_());
            }
            if (returnedFieldsContains("RequesterAccount")) {
                dto.setRequesterAccount(state.getRequesterAccount());
            }
            if (returnedFieldsContains("RequestedAmount")) {
                dto.setRequestedAmount(state.getRequestedAmount());
            }
            if (returnedFieldsContains("Description")) {
                dto.setDescription(state.getDescription());
            }
            if (returnedFieldsContains("SuiPackageId")) {
                dto.setSuiPackageId(state.getSuiPackageId());
            }
            if (returnedFieldsContains("SuiTransactionModule")) {
                dto.setSuiTransactionModule(state.getSuiTransactionModule());
            }
            if (returnedFieldsContains("SuiSender")) {
                dto.setSuiSender(state.getSuiSender());
            }
            if (returnedFieldsContains("SuiType")) {
                dto.setSuiType(state.getSuiType());
            }
            if (returnedFieldsContains("SuiTimestamp")) {
                dto.setSuiTimestamp(state.getSuiTimestamp());
            }
            if (returnedFieldsContains("SuiTxDigest")) {
                dto.setSuiTxDigest(state.getSuiTxDigest());
            }
            if (returnedFieldsContains("SuiEventSeq")) {
                dto.setSuiEventSeq(state.getSuiEventSeq());
            }
            if (returnedFieldsContains("NextCursor")) {
                dto.setNextCursor(state.getNextCursor());
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

