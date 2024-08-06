package org.dddml.suiinfinitesea.sui.contract.repository;


import org.dddml.suiinfinitesea.domain.skillprocess.AbstractSkillProcessEvent;
import org.dddml.suiinfinitesea.domain.skillprocess.SkillProcessEventId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface SkillProcessEventExtendRepository extends
        JpaRepository<AbstractSkillProcessEvent.CreationProcessCompleted, SkillProcessEventId> {

    /*
    SELECT IFNULL(SUM(spv.dynamic_properties->'$.quantity'),0) AS quantity
FROM skill_process_event spv
WHERE spv.event_type='CreationProcessCompleted' AND sui_sender='sui_sender' AND spv.dynamic_properties->'$.itemId'=301
     */
    @Query(value = "SELECT IFNULL(sum(spv.dynamic_properties->'$.quantity'),0) AS quantity " +
            "FROM skill_process_event spv " +
            "WHERE spv.event_type='CreationProcessCompleted' AND sui_sender=:suiSender " +
            "AND spv.dynamic_properties->'$.itemId'=:itemId", nativeQuery = true)
    Integer getCreationQuantity(@Param("suiSender") String suiSender, @Param("itemId") Long itemId);


    /*
     SELECT IFNULL(SUM(spv.dynamic_properties->'$.quantity'),0) AS quantity
     FROM skill_process_event spv
     WHERE spv.event_type='ProductionProcessCompleted' AND sui_sender='sui_sender' AND spv.dynamic_properties->'$.itemId'=102
     */
    @Query(value = "SELECT IFNULL(sum(spv.dynamic_properties->'$.quantity'),0) AS quantity " +
            "FROM skill_process_event spv " +
            "WHERE spv.event_type='ProductionProcessCompleted' AND sui_sender=:suiSender " +
            "AND spv.dynamic_properties->'$.itemId'=102", nativeQuery = true)
    Integer getCottonQuantity(@Param("suiSender") String suiSender);
}
