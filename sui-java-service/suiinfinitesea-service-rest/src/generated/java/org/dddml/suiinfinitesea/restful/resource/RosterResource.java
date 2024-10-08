// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.restful.resource;

import java.util.*;
import java.util.stream.*;
import javax.servlet.http.*;
import javax.validation.constraints.*;
import org.springframework.http.MediaType;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.transaction.annotation.Transactional;
import org.dddml.support.criterion.*;
import org.dddml.suiinfinitesea.domain.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.specialization.*;
import org.dddml.suiinfinitesea.domain.roster.*;
import static org.dddml.suiinfinitesea.domain.meta.M.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.dddml.support.criterion.TypeConverter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RequestMapping(path = "Rosters", produces = MediaType.APPLICATION_JSON_VALUE)
@RestController
public class RosterResource {
    private Logger logger = LoggerFactory.getLogger(this.getClass());


    @Autowired
    private RosterApplicationService rosterApplicationService;


    /**
     * Retrieve.
     * Retrieve Rosters
     */
    @GetMapping
    @Transactional(readOnly = true)
    public RosterStateDto[] getAll( HttpServletRequest request,
                    @RequestParam(value = "sort", required = false) String sort,
                    @RequestParam(value = "fields", required = false) String fields,
                    @RequestParam(value = "firstResult", defaultValue = "0") Integer firstResult,
                    @RequestParam(value = "maxResults", defaultValue = "2147483647") Integer maxResults,
                    @RequestParam(value = "filter", required = false) String filter) {
        try {
        if (firstResult < 0) { firstResult = 0; }
        if (maxResults == null || maxResults < 1) { maxResults = Integer.MAX_VALUE; }

            Iterable<RosterState> states = null; 
            CriterionDto criterion = null;
            if (!StringHelper.isNullOrEmpty(filter)) {
                criterion = new ObjectMapper().readValue(filter, CriterionDto.class);
            } else {
                criterion = QueryParamUtils.getQueryCriterionDto(request.getParameterMap().entrySet().stream()
                    .filter(kv -> RosterResourceUtils.getFilterPropertyName(kv.getKey()) != null)
                    .collect(Collectors.toMap(kv -> kv.getKey(), kv -> kv.getValue())));
            }
            Criterion c = CriterionDto.toSubclass(criterion, getCriterionTypeConverter(), getPropertyTypeResolver(), 
                n -> (RosterMetadata.aliasMap.containsKey(n) ? RosterMetadata.aliasMap.get(n) : n));
            states = rosterApplicationService.get(
                c,
                RosterResourceUtils.getQuerySorts(request.getParameterMap()),
                firstResult, maxResults);

            RosterStateDto.DtoConverter dtoConverter = new RosterStateDto.DtoConverter();
            if (StringHelper.isNullOrEmpty(fields)) {
                dtoConverter.setAllFieldsReturned(true);
            } else {
                dtoConverter.setReturnedFieldsString(fields);
            }
            return dtoConverter.toRosterStateDtoArray(states);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    /**
     * Retrieve in pages.
     * Retrieve Rosters in pages.
     */
    @GetMapping("_page")
    @Transactional(readOnly = true)
    public Page<RosterStateDto> getPage( HttpServletRequest request,
                    @RequestParam(value = "fields", required = false) String fields,
                    @RequestParam(value = "page", defaultValue = "0") Integer page,
                    @RequestParam(value = "size", defaultValue = "20") Integer size,
                    @RequestParam(value = "filter", required = false) String filter) {
        try {
            Integer firstResult = (page == null ? 0 : page) * (size == null ? 20 : size);
            Integer maxResults = (size == null ? 20 : size);
            Iterable<RosterState> states = null; 
            CriterionDto criterion = null;
            if (!StringHelper.isNullOrEmpty(filter)) {
                criterion = new ObjectMapper().readValue(filter, CriterionDto.class);
            } else {
                criterion = QueryParamUtils.getQueryCriterionDto(request.getParameterMap().entrySet().stream()
                    .filter(kv -> RosterResourceUtils.getFilterPropertyName(kv.getKey()) != null)
                    .collect(Collectors.toMap(kv -> kv.getKey(), kv -> kv.getValue())));
            }
            Criterion c = CriterionDto.toSubclass(criterion, getCriterionTypeConverter(), getPropertyTypeResolver(), 
                n -> (RosterMetadata.aliasMap.containsKey(n) ? RosterMetadata.aliasMap.get(n) : n));
            states = rosterApplicationService.get(
                c,
                RosterResourceUtils.getQuerySorts(request.getParameterMap()),
                firstResult, maxResults);
            long count = rosterApplicationService.getCount(c);

            RosterStateDto.DtoConverter dtoConverter = new RosterStateDto.DtoConverter();
            if (StringHelper.isNullOrEmpty(fields)) {
                dtoConverter.setAllFieldsReturned(true);
            } else {
                dtoConverter.setReturnedFieldsString(fields);
            }
            Page.PageImpl<RosterStateDto> statePage =  new Page.PageImpl<>(dtoConverter.toRosterStateDtoList(states), count);
            statePage.setSize(size);
            statePage.setNumber(page);
            return statePage;

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    /**
     * Retrieve.
     * Retrieves Roster with the specified ID.
     */
    @GetMapping("{rosterId}")
    @Transactional(readOnly = true)
    public RosterStateDto get(@PathVariable("rosterId") String rosterId, @RequestParam(value = "fields", required = false) String fields) {
        try {
            RosterId idObj = RosterResourceUtils.parseIdString(rosterId);
            RosterState state = rosterApplicationService.get(idObj);
            if (state == null) { return null; }

            RosterStateDto.DtoConverter dtoConverter = new RosterStateDto.DtoConverter();
            if (StringHelper.isNullOrEmpty(fields)) {
                dtoConverter.setAllFieldsReturned(true);
            } else {
                dtoConverter.setReturnedFieldsString(fields);
            }
            return dtoConverter.toRosterStateDto(state);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    @GetMapping("_count")
    @Transactional(readOnly = true)
    public long getCount( HttpServletRequest request,
                         @RequestParam(value = "filter", required = false) String filter) {
        try {
            long count = 0;
            CriterionDto criterion = null;
            if (!StringHelper.isNullOrEmpty(filter)) {
                criterion = new ObjectMapper().readValue(filter, CriterionDto.class);
            } else {
                criterion = QueryParamUtils.getQueryCriterionDto(request.getParameterMap());
            }
            Criterion c = CriterionDto.toSubclass(criterion,
                getCriterionTypeConverter(), 
                getPropertyTypeResolver(), 
                n -> (RosterMetadata.aliasMap.containsKey(n) ? RosterMetadata.aliasMap.get(n) : n));
            count = rosterApplicationService.getCount(c);
            return count;

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }


    @PutMapping("{rosterId}/_commands/CreateEnvironmentRoster")
    public void createEnvironmentRoster(@PathVariable("rosterId") String rosterId, @RequestBody RosterCommands.CreateEnvironmentRoster content) {
        try {

            RosterCommands.CreateEnvironmentRoster cmd = content;//.toCreateEnvironmentRoster();
            RosterId idObj = RosterResourceUtils.parseIdString(rosterId);
            if (cmd.getRosterId() == null) {
                cmd.setRosterId(idObj);
            } else if (!cmd.getRosterId().equals(idObj)) {
                throw DomainError.named("inconsistentId", "Argument Id %1$s NOT equals body Id %2$s", rosterId, cmd.getRosterId());
            }
            cmd.setRequesterId(SecurityContextUtil.getRequesterId());
            rosterApplicationService.when(cmd);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }


    @PutMapping("{rosterId}/_commands/AdjustShipsPosition")
    public void adjustShipsPosition(@PathVariable("rosterId") String rosterId, @RequestBody RosterCommands.AdjustShipsPosition content) {
        try {

            RosterCommands.AdjustShipsPosition cmd = content;//.toAdjustShipsPosition();
            RosterId idObj = RosterResourceUtils.parseIdString(rosterId);
            if (cmd.getRosterId() == null) {
                cmd.setRosterId(idObj);
            } else if (!cmd.getRosterId().equals(idObj)) {
                throw DomainError.named("inconsistentId", "Argument Id %1$s NOT equals body Id %2$s", rosterId, cmd.getRosterId());
            }
            cmd.setRequesterId(SecurityContextUtil.getRequesterId());
            rosterApplicationService.when(cmd);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }


    @PutMapping("{rosterId}/_commands/TransferShip")
    public void transferShip(@PathVariable("rosterId") String rosterId, @RequestBody RosterCommands.TransferShip content) {
        try {

            RosterCommands.TransferShip cmd = content;//.toTransferShip();
            RosterId idObj = RosterResourceUtils.parseIdString(rosterId);
            if (cmd.getRosterId() == null) {
                cmd.setRosterId(idObj);
            } else if (!cmd.getRosterId().equals(idObj)) {
                throw DomainError.named("inconsistentId", "Argument Id %1$s NOT equals body Id %2$s", rosterId, cmd.getRosterId());
            }
            cmd.setRequesterId(SecurityContextUtil.getRequesterId());
            rosterApplicationService.when(cmd);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }


    @PutMapping("{rosterId}/_commands/TransferShipInventory")
    public void transferShipInventory(@PathVariable("rosterId") String rosterId, @RequestBody RosterCommands.TransferShipInventory content) {
        try {

            RosterCommands.TransferShipInventory cmd = content;//.toTransferShipInventory();
            RosterId idObj = RosterResourceUtils.parseIdString(rosterId);
            if (cmd.getRosterId() == null) {
                cmd.setRosterId(idObj);
            } else if (!cmd.getRosterId().equals(idObj)) {
                throw DomainError.named("inconsistentId", "Argument Id %1$s NOT equals body Id %2$s", rosterId, cmd.getRosterId());
            }
            cmd.setRequesterId(SecurityContextUtil.getRequesterId());
            rosterApplicationService.when(cmd);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }


    @PutMapping("{rosterId}/_commands/TakeOutShipInventory")
    public void takeOutShipInventory(@PathVariable("rosterId") String rosterId, @RequestBody RosterCommands.TakeOutShipInventory content) {
        try {

            RosterCommands.TakeOutShipInventory cmd = content;//.toTakeOutShipInventory();
            RosterId idObj = RosterResourceUtils.parseIdString(rosterId);
            if (cmd.getRosterId() == null) {
                cmd.setRosterId(idObj);
            } else if (!cmd.getRosterId().equals(idObj)) {
                throw DomainError.named("inconsistentId", "Argument Id %1$s NOT equals body Id %2$s", rosterId, cmd.getRosterId());
            }
            cmd.setRequesterId(SecurityContextUtil.getRequesterId());
            rosterApplicationService.when(cmd);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }


    @PutMapping("{rosterId}/_commands/PutInShipInventory")
    public void putInShipInventory(@PathVariable("rosterId") String rosterId, @RequestBody RosterCommands.PutInShipInventory content) {
        try {

            RosterCommands.PutInShipInventory cmd = content;//.toPutInShipInventory();
            RosterId idObj = RosterResourceUtils.parseIdString(rosterId);
            if (cmd.getRosterId() == null) {
                cmd.setRosterId(idObj);
            } else if (!cmd.getRosterId().equals(idObj)) {
                throw DomainError.named("inconsistentId", "Argument Id %1$s NOT equals body Id %2$s", rosterId, cmd.getRosterId());
            }
            cmd.setRequesterId(SecurityContextUtil.getRequesterId());
            rosterApplicationService.when(cmd);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }


    @PutMapping("{rosterId}/_commands/Delete")
    public void delete(@PathVariable("rosterId") String rosterId, @RequestBody RosterCommands.Delete content) {
        try {

            RosterCommands.Delete cmd = content;//.toDelete();
            RosterId idObj = RosterResourceUtils.parseIdString(rosterId);
            if (cmd.getRosterId() == null) {
                cmd.setRosterId(idObj);
            } else if (!cmd.getRosterId().equals(idObj)) {
                throw DomainError.named("inconsistentId", "Argument Id %1$s NOT equals body Id %2$s", rosterId, cmd.getRosterId());
            }
            cmd.setRequesterId(SecurityContextUtil.getRequesterId());
            rosterApplicationService.when(cmd);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    @GetMapping("_metadata/filteringFields")
    public List<PropertyMetadataDto> getMetadataFilteringFields() {
        try {

            List<PropertyMetadataDto> filtering = new ArrayList<>();
            RosterMetadata.propertyTypeMap.forEach((key, value) -> {
                filtering.add(new PropertyMetadataDto(key, value, true));
            });
            return filtering;

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    @GetMapping("{rosterId}/_events/{version}")
    @Transactional(readOnly = true)
    public RosterEvent getEvent(@PathVariable("rosterId") String rosterId, @PathVariable("version") long version) {
        try {

            RosterId idObj = RosterResourceUtils.parseIdString(rosterId);
            //RosterStateEventDtoConverter dtoConverter = getRosterStateEventDtoConverter();
            return rosterApplicationService.getEvent(idObj, version);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    @GetMapping("{rosterId}/_historyStates/{version}")
    @Transactional(readOnly = true)
    public RosterStateDto getHistoryState(@PathVariable("rosterId") String rosterId, @PathVariable("version") long version, @RequestParam(value = "fields", required = false) String fields) {
        try {

            RosterId idObj = RosterResourceUtils.parseIdString(rosterId);
            RosterStateDto.DtoConverter dtoConverter = new RosterStateDto.DtoConverter();
            if (StringHelper.isNullOrEmpty(fields)) {
                dtoConverter.setAllFieldsReturned(true);
            } else {
                dtoConverter.setReturnedFieldsString(fields);
            }
            return dtoConverter.toRosterStateDto(rosterApplicationService.getHistoryState(idObj, version));

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    /**
     * Retrieve.
     * Retrieves RosterShipsItem with the specified Key.
     */
    @GetMapping("{rosterId}/RosterShipsItems/{key}")
    @Transactional(readOnly = true)
    public RosterShipsItemStateDto getRosterShipsItem(@PathVariable("rosterId") String rosterId, @PathVariable("key") String key) {
        try {

            RosterShipsItemState state = rosterApplicationService.getRosterShipsItem((new AbstractValueObjectTextFormatter<RosterId>(RosterId.class, ",") {
                        @Override
                        protected Class<?> getClassByTypeName(String type) {
                            return BoundedContextMetadata.CLASS_MAP.get(type);
                        }
                    }.parse(rosterId)), key);
            if (state == null) { return null; }
            RosterShipsItemStateDto.DtoConverter dtoConverter = new RosterShipsItemStateDto.DtoConverter();
            RosterShipsItemStateDto stateDto = dtoConverter.toRosterShipsItemStateDto(state);
            dtoConverter.setAllFieldsReturned(true);
            return stateDto;

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    /**
     * RosterShipsItem List
     */
    @GetMapping("{rosterId}/RosterShipsItems")
    @Transactional(readOnly = true)
    public RosterShipsItemStateDto[] getRosterShipsItems(@PathVariable("rosterId") String rosterId,
                    @RequestParam(value = "sort", required = false) String sort,
                    @RequestParam(value = "fields", required = false) String fields,
                    @RequestParam(value = "filter", required = false) String filter,
                     HttpServletRequest request) {
        try {
            CriterionDto criterion = null;
            if (!StringHelper.isNullOrEmpty(filter)) {
                criterion = new ObjectMapper().readValue(filter, CriterionDto.class);
            } else {
                criterion = QueryParamUtils.getQueryCriterionDto(request.getParameterMap().entrySet().stream()
                    .filter(kv -> RosterResourceUtils.getRosterShipsItemFilterPropertyName(kv.getKey()) != null)
                    .collect(Collectors.toMap(kv -> kv.getKey(), kv -> kv.getValue())));
            }
            Criterion c = CriterionDto.toSubclass(criterion, getCriterionTypeConverter(), getPropertyTypeResolver(), 
                n -> (RosterShipsItemMetadata.aliasMap.containsKey(n) ? RosterShipsItemMetadata.aliasMap.get(n) : n));
            Iterable<RosterShipsItemState> states = rosterApplicationService.getRosterShipsItems((new AbstractValueObjectTextFormatter<RosterId>(RosterId.class, ",") {
                        @Override
                        protected Class<?> getClassByTypeName(String type) {
                            return BoundedContextMetadata.CLASS_MAP.get(type);
                        }
                    }.parse(rosterId)), c,
                    RosterResourceUtils.getRosterShipsItemQuerySorts(request.getParameterMap()));
            if (states == null) { return null; }
            RosterShipsItemStateDto.DtoConverter dtoConverter = new RosterShipsItemStateDto.DtoConverter();
            if (StringHelper.isNullOrEmpty(fields)) {
                dtoConverter.setAllFieldsReturned(true);
            } else {
                dtoConverter.setReturnedFieldsString(fields);
            }
            return dtoConverter.toRosterShipsItemStateDtoArray(states);
        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }



    //protected  RosterStateEventDtoConverter getRosterStateEventDtoConverter() {
    //    return new RosterStateEventDtoConverter();
    //}

    protected TypeConverter getCriterionTypeConverter() {
        return new DefaultTypeConverter();
    }

    protected PropertyTypeResolver getPropertyTypeResolver() {
        return new PropertyTypeResolver() {
            @Override
            public Class resolveTypeByPropertyName(String propertyName) {
                return RosterResourceUtils.getFilterPropertyType(propertyName);
            }
        };
    }

    protected PropertyTypeResolver getRosterShipsItemPropertyTypeResolver() {
        return new PropertyTypeResolver() {
            @Override
            public Class resolveTypeByPropertyName(String propertyName) {
                return RosterResourceUtils.getRosterShipsItemFilterPropertyType(propertyName);
            }
        };
    }

    // ////////////////////////////////
 
    public static class RosterResourceUtils {

        public static RosterId parseIdString(String idString) {
            TextFormatter<RosterId> formatter = RosterMetadata.URL_ID_TEXT_FORMATTER;
            return formatter.parse(idString);
        }

        public static void setNullIdOrThrowOnInconsistentIds(String rosterId, org.dddml.suiinfinitesea.domain.roster.RosterCommand value) {
            RosterId idObj = parseIdString(rosterId);
            if (value.getRosterId() == null) {
                value.setRosterId(idObj);
            } else if (!value.getRosterId().equals(idObj)) {
                throw DomainError.named("inconsistentId", "Argument Id %1$s NOT equals body Id %2$s", rosterId, value.getRosterId());
            }
        }
    
        public static List<String> getQueryOrders(String str, String separator) {
            return QueryParamUtils.getQueryOrders(str, separator, RosterMetadata.aliasMap);
        }

        public static List<String> getQuerySorts(Map<String, String[]> queryNameValuePairs) {
            String[] values = queryNameValuePairs.get("sort");
            return QueryParamUtils.getQuerySorts(values, RosterMetadata.aliasMap);
        }

        public static String getFilterPropertyName(String fieldName) {
            if ("sort".equalsIgnoreCase(fieldName)
                    || "firstResult".equalsIgnoreCase(fieldName)
                    || "maxResults".equalsIgnoreCase(fieldName)
                    || "fields".equalsIgnoreCase(fieldName)) {
                return null;
            }
            if (RosterMetadata.aliasMap.containsKey(fieldName)) {
                return RosterMetadata.aliasMap.get(fieldName);
            }
            return null;
        }

        public static Class getFilterPropertyType(String propertyName) {
            if (RosterMetadata.propertyTypeMap.containsKey(propertyName)) {
                String propertyType = RosterMetadata.propertyTypeMap.get(propertyName);
                if (!StringHelper.isNullOrEmpty(propertyType)) {
                    if (BoundedContextMetadata.CLASS_MAP.containsKey(propertyType)) {
                        return BoundedContextMetadata.CLASS_MAP.get(propertyType);
                    }
                }
            }
            return String.class;
        }

        public static Iterable<Map.Entry<String, Object>> getQueryFilterMap(Map<String, String[]> queryNameValuePairs) {
            Map<String, Object> filter = new HashMap<>();
            queryNameValuePairs.forEach((key, values) -> {
                if (values.length > 0) {
                    String pName = getFilterPropertyName(key);
                    if (!StringHelper.isNullOrEmpty(pName)) {
                        Class pClass = getFilterPropertyType(pName);
                        filter.put(pName, ApplicationContext.current.getTypeConverter().convertFromString(pClass, values[0]));
                    }
                }
            });
            return filter.entrySet();
        }

        public static List<String> getRosterShipsItemQueryOrders(String str, String separator) {
            return QueryParamUtils.getQueryOrders(str, separator, RosterShipsItemMetadata.aliasMap);
        }

        public static List<String> getRosterShipsItemQuerySorts(Map<String, String[]> queryNameValuePairs) {
            String[] values = queryNameValuePairs.get("sort");
            return QueryParamUtils.getQuerySorts(values, RosterShipsItemMetadata.aliasMap);
        }

        public static String getRosterShipsItemFilterPropertyName(String fieldName) {
            if ("sort".equalsIgnoreCase(fieldName)
                    || "firstResult".equalsIgnoreCase(fieldName)
                    || "maxResults".equalsIgnoreCase(fieldName)
                    || "fields".equalsIgnoreCase(fieldName)) {
                return null;
            }
            if (RosterShipsItemMetadata.aliasMap.containsKey(fieldName)) {
                return RosterShipsItemMetadata.aliasMap.get(fieldName);
            }
            return null;
        }

        public static Class getRosterShipsItemFilterPropertyType(String propertyName) {
            if (RosterShipsItemMetadata.propertyTypeMap.containsKey(propertyName)) {
                String propertyType = RosterShipsItemMetadata.propertyTypeMap.get(propertyName);
                if (!StringHelper.isNullOrEmpty(propertyType)) {
                    if (BoundedContextMetadata.CLASS_MAP.containsKey(propertyType)) {
                        return BoundedContextMetadata.CLASS_MAP.get(propertyType);
                    }
                }
            }
            return String.class;
        }

        public static Iterable<Map.Entry<String, Object>> getRosterShipsItemQueryFilterMap(Map<String, String[]> queryNameValuePairs) {
            Map<String, Object> filter = new HashMap<>();
            queryNameValuePairs.forEach((key, values) -> {
                if (values.length > 0) {
                    String pName = getRosterShipsItemFilterPropertyName(key);
                    if (!StringHelper.isNullOrEmpty(pName)) {
                        Class pClass = getRosterShipsItemFilterPropertyType(pName);
                        filter.put(pName, ApplicationContext.current.getTypeConverter().convertFromString(pClass, values[0]));
                    }
                }
            });
            return filter.entrySet();
        }

        public static RosterStateDto[] toRosterStateDtoArray(Iterable<RosterId> ids) {
            List<RosterStateDto> states = new ArrayList<>();
            ids.forEach(i -> {
                RosterStateDto dto = new RosterStateDto();
                dto.setRosterId(i);
                states.add(dto);
            });
            return states.toArray(new RosterStateDto[0]);
        }

    }

}

