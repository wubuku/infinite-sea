package org.dddml.suiinfinitesea.sui.contract.repository;

import org.dddml.suiinfinitesea.domain.skillprocess.AbstractSkillProcessEvent;
import org.dddml.suiinfinitesea.domain.skillprocess.SkillProcessEventId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ShipProductionEventRepository extends JpaRepository<AbstractSkillProcessEvent.ShipProductionProcessCompleted, SkillProcessEventId> {


    @Query(value = "select * from skill_process_event spv where " +
            "spv.event_type='ShipProductionProcessCompleted' " +
            "and sui_timestamp>=:startAt and sui_timestamp<=:endAt and sui_sender=:suiSender", nativeQuery = true)
    List<AbstractSkillProcessEvent.ShipProductionProcessCompleted> getShipCompletedEvents(@Param("startAt") Long startAt,
                                                                                          @Param("endAt") Long endAt,
                                                                                          @Param("suiSender") String suiSender);
}
