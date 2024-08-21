package org.dddml.suiinfinitesea.sui.contract.restful.resource;

import java.util.List;

public class EventRequestVo {
    private Long startAt;
    private Long endAt;
    private List<String> senderAddresses;

    public Long getStartAt() {
        return startAt;
    }

    public void setStartAt(Long startAt) {
        this.startAt = startAt;
    }

    public Long getEndAt() {
        return endAt;
    }

    public void setEndAt(Long endAt) {
        this.endAt = endAt;
    }

    public List<String> getSenderAddresses() {
        return senderAddresses;
    }

    public void setSenderAddresses(List<String> senderAddresses) {
        this.senderAddresses = senderAddresses;
    }
}
