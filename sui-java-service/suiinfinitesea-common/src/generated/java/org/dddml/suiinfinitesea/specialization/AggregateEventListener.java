package org.dddml.suiinfinitesea.specialization;


public interface AggregateEventListener<TA, TS> {

    void eventAppended(AggregateEvent<TA, TS> e);

}
