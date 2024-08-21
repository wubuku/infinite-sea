package org.dddml.suiinfinitesea.sui.contract.repository;


import org.dddml.suiinfinitesea.domain.skillprocess.AbstractSkillProcessEvent;
import org.dddml.suiinfinitesea.domain.skillprocess.SkillProcessEventId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

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


    @Query(value = "SELECT spv.sui_sender as address," +
            "       IFNULL(sum(spv.dynamic_properties->'$.quantity'), 0) AS count " +
            "FROM skill_process_event spv " +
            "WHERE spv.event_type='CreationProcessCompleted' " +
            "  AND spv.dynamic_properties->'$.itemId'=:itemId " +
            "  AND spv.sui_sender IN(:suiSenderAddresses) " +
            "GROUP BY spv.sui_sender," +
            "         spv.dynamic_properties->'$.itemId'", nativeQuery = true)
    List<AddressCount> batchGetCreationQuantity(@Param("suiSenderAddresses") List<String> suiSenderAddresses, @Param("itemId") Long itemId);

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

    /*
    SELECT spv.sui_sender, sum(spv.dynamic_properties->'$.quantity')
     FROM skill_process_event spv
     WHERE spv.event_type='ProductionProcessCompleted'  AND spv.dynamic_properties->'$.itemId'=102
     AND spv.sui_sender IN('0x8f50309b7d779c29e1eab23889b9553e8874d2b9e106b944ec06f925c0ca4450',
	  '0x3c9ebfe1031c8aac5fe99da5759d03260e424db4f6481a6a5effbb1ecfad764d',
	  '0x793f2c4fdd706ce2ac99b0d7c931bccec102e4b9c69565e60a4211ce759753f5',
	  '0x22946c7aa7d3175b79969d7d71c8196de26392f87bac7285b16b72bc2f909867',
	  '0xf94d322ddf060d4dc9a9bee56d61ed119f39e17b5a1098d62254a10e37a86cf9')
     GROUP BY spv.sui_sender,spv.dynamic_properties->'$.itemId'
     */
    @Query(value = "SELECT spv.sui_sender as address," +
            "       IFNULL(sum(spv.dynamic_properties->'$.quantity'), 0) AS count " +
            "FROM skill_process_event spv " +
            "WHERE spv.event_type='ProductionProcessCompleted' " +
            "  AND spv.dynamic_properties->'$.itemId'=102 " +
            "  AND spv.sui_sender IN(:suiSenderAddresses) " +
            "GROUP BY spv.sui_sender," +
            "         spv.dynamic_properties->'$.itemId'", nativeQuery = true)
    List<AddressCount> batchGetCottonQuantity(@Param("suiSenderAddresses") List<String> suiSenderAddresses);
}
