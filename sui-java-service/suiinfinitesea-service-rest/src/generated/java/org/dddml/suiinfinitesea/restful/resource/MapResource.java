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
import java.util.Date;
import java.math.BigInteger;
import org.dddml.suiinfinitesea.domain.*;
import org.dddml.suiinfinitesea.specialization.*;
import org.dddml.suiinfinitesea.domain.map.*;
import static org.dddml.suiinfinitesea.domain.meta.M.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.dddml.support.criterion.TypeConverter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RequestMapping(path = "Maps", produces = MediaType.APPLICATION_JSON_VALUE)
@RestController
public class MapResource {
    private Logger logger = LoggerFactory.getLogger(this.getClass());


    @Autowired
    private MapApplicationService mapApplicationService;


    /**
     * Retrieve.
     * Retrieve Maps
     */
    @GetMapping
    @Transactional(readOnly = true)
    public MapStateDto[] getAll( HttpServletRequest request,
                    @RequestParam(value = "sort", required = false) String sort,
                    @RequestParam(value = "fields", required = false) String fields,
                    @RequestParam(value = "firstResult", defaultValue = "0") Integer firstResult,
                    @RequestParam(value = "maxResults", defaultValue = "2147483647") Integer maxResults,
                    @RequestParam(value = "filter", required = false) String filter) {
        try {
        if (firstResult < 0) { firstResult = 0; }
        if (maxResults == null || maxResults < 1) { maxResults = Integer.MAX_VALUE; }

            Iterable<MapState> states = null; 
            CriterionDto criterion = null;
            if (!StringHelper.isNullOrEmpty(filter)) {
                criterion = new ObjectMapper().readValue(filter, CriterionDto.class);
            } else {
                criterion = QueryParamUtils.getQueryCriterionDto(request.getParameterMap().entrySet().stream()
                    .filter(kv -> MapResourceUtils.getFilterPropertyName(kv.getKey()) != null)
                    .collect(Collectors.toMap(kv -> kv.getKey(), kv -> kv.getValue())));
            }
            Criterion c = CriterionDto.toSubclass(criterion, getCriterionTypeConverter(), getPropertyTypeResolver(), 
                n -> (MapMetadata.aliasMap.containsKey(n) ? MapMetadata.aliasMap.get(n) : n));
            states = mapApplicationService.get(
                c,
                MapResourceUtils.getQuerySorts(request.getParameterMap()),
                firstResult, maxResults);

            MapStateDto.DtoConverter dtoConverter = new MapStateDto.DtoConverter();
            if (StringHelper.isNullOrEmpty(fields)) {
                dtoConverter.setAllFieldsReturned(true);
            } else {
                dtoConverter.setReturnedFieldsString(fields);
            }
            return dtoConverter.toMapStateDtoArray(states);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    /**
     * Retrieve in pages.
     * Retrieve Maps in pages.
     */
    @GetMapping("_page")
    @Transactional(readOnly = true)
    public Page<MapStateDto> getPage( HttpServletRequest request,
                    @RequestParam(value = "fields", required = false) String fields,
                    @RequestParam(value = "page", defaultValue = "0") Integer page,
                    @RequestParam(value = "size", defaultValue = "20") Integer size,
                    @RequestParam(value = "filter", required = false) String filter) {
        try {
            Integer firstResult = (page == null ? 0 : page) * (size == null ? 20 : size);
            Integer maxResults = (size == null ? 20 : size);
            Iterable<MapState> states = null; 
            CriterionDto criterion = null;
            if (!StringHelper.isNullOrEmpty(filter)) {
                criterion = new ObjectMapper().readValue(filter, CriterionDto.class);
            } else {
                criterion = QueryParamUtils.getQueryCriterionDto(request.getParameterMap().entrySet().stream()
                    .filter(kv -> MapResourceUtils.getFilterPropertyName(kv.getKey()) != null)
                    .collect(Collectors.toMap(kv -> kv.getKey(), kv -> kv.getValue())));
            }
            Criterion c = CriterionDto.toSubclass(criterion, getCriterionTypeConverter(), getPropertyTypeResolver(), 
                n -> (MapMetadata.aliasMap.containsKey(n) ? MapMetadata.aliasMap.get(n) : n));
            states = mapApplicationService.get(
                c,
                MapResourceUtils.getQuerySorts(request.getParameterMap()),
                firstResult, maxResults);
            long count = mapApplicationService.getCount(c);

            MapStateDto.DtoConverter dtoConverter = new MapStateDto.DtoConverter();
            if (StringHelper.isNullOrEmpty(fields)) {
                dtoConverter.setAllFieldsReturned(true);
            } else {
                dtoConverter.setReturnedFieldsString(fields);
            }
            Page.PageImpl<MapStateDto> statePage =  new Page.PageImpl<>(dtoConverter.toMapStateDtoList(states), count);
            statePage.setSize(size);
            statePage.setNumber(page);
            return statePage;

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    /**
     * Retrieve.
     * Retrieves Map with the specified ID.
     */
    @GetMapping("{id}")
    @Transactional(readOnly = true)
    public MapStateDto get(@PathVariable("id") String id, @RequestParam(value = "fields", required = false) String fields) {
        try {
            String idObj = id;
            MapState state = mapApplicationService.get(idObj);
            if (state == null) { return null; }

            MapStateDto.DtoConverter dtoConverter = new MapStateDto.DtoConverter();
            if (StringHelper.isNullOrEmpty(fields)) {
                dtoConverter.setAllFieldsReturned(true);
            } else {
                dtoConverter.setReturnedFieldsString(fields);
            }
            return dtoConverter.toMapStateDto(state);

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
                n -> (MapMetadata.aliasMap.containsKey(n) ? MapMetadata.aliasMap.get(n) : n));
            count = mapApplicationService.getCount(c);
            return count;

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }


    @PutMapping("{id}/_commands/AddIsland")
    public void addIsland(@PathVariable("id") String id, @RequestBody MapCommands.AddIsland content) {
        try {

            MapCommands.AddIsland cmd = content;//.toAddIsland();
            String idObj = id;
            if (cmd.getId() == null) {
                cmd.setId(idObj);
            } else if (!cmd.getId().equals(idObj)) {
                throw DomainError.named("inconsistentId", "Argument Id %1$s NOT equals body Id %2$s", id, cmd.getId());
            }
            cmd.setRequesterId(SecurityContextUtil.getRequesterId());
            mapApplicationService.when(cmd);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }


    @PutMapping("{id}/_commands/UpdateSettings")
    public void updateSettings(@PathVariable("id") String id, @RequestBody MapCommands.UpdateSettings content) {
        try {

            MapCommands.UpdateSettings cmd = content;//.toUpdateSettings();
            String idObj = id;
            if (cmd.getId() == null) {
                cmd.setId(idObj);
            } else if (!cmd.getId().equals(idObj)) {
                throw DomainError.named("inconsistentId", "Argument Id %1$s NOT equals body Id %2$s", id, cmd.getId());
            }
            cmd.setRequesterId(SecurityContextUtil.getRequesterId());
            mapApplicationService.when(cmd);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }


    @PutMapping("{id}/_commands/AddToWhitelist")
    public void addToWhitelist(@PathVariable("id") String id, @RequestBody MapCommands.AddToWhitelist content) {
        try {

            MapCommands.AddToWhitelist cmd = content;//.toAddToWhitelist();
            String idObj = id;
            if (cmd.getId() == null) {
                cmd.setId(idObj);
            } else if (!cmd.getId().equals(idObj)) {
                throw DomainError.named("inconsistentId", "Argument Id %1$s NOT equals body Id %2$s", id, cmd.getId());
            }
            cmd.setRequesterId(SecurityContextUtil.getRequesterId());
            mapApplicationService.when(cmd);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }


    @PutMapping("{id}/_commands/RemoveFromWhitelist")
    public void removeFromWhitelist(@PathVariable("id") String id, @RequestBody MapCommands.RemoveFromWhitelist content) {
        try {

            MapCommands.RemoveFromWhitelist cmd = content;//.toRemoveFromWhitelist();
            String idObj = id;
            if (cmd.getId() == null) {
                cmd.setId(idObj);
            } else if (!cmd.getId().equals(idObj)) {
                throw DomainError.named("inconsistentId", "Argument Id %1$s NOT equals body Id %2$s", id, cmd.getId());
            }
            cmd.setRequesterId(SecurityContextUtil.getRequesterId());
            mapApplicationService.when(cmd);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    @GetMapping("_metadata/filteringFields")
    public List<PropertyMetadataDto> getMetadataFilteringFields() {
        try {

            List<PropertyMetadataDto> filtering = new ArrayList<>();
            MapMetadata.propertyTypeMap.forEach((key, value) -> {
                filtering.add(new PropertyMetadataDto(key, value, true));
            });
            return filtering;

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    @GetMapping("{id}/_events/{version}")
    @Transactional(readOnly = true)
    public MapEvent getEvent(@PathVariable("id") String id, @PathVariable("version") long version) {
        try {

            String idObj = id;
            //MapStateEventDtoConverter dtoConverter = getMapStateEventDtoConverter();
            return mapApplicationService.getEvent(idObj, version);

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    @GetMapping("{id}/_historyStates/{version}")
    @Transactional(readOnly = true)
    public MapStateDto getHistoryState(@PathVariable("id") String id, @PathVariable("version") long version, @RequestParam(value = "fields", required = false) String fields) {
        try {

            String idObj = id;
            MapStateDto.DtoConverter dtoConverter = new MapStateDto.DtoConverter();
            if (StringHelper.isNullOrEmpty(fields)) {
                dtoConverter.setAllFieldsReturned(true);
            } else {
                dtoConverter.setReturnedFieldsString(fields);
            }
            return dtoConverter.toMapStateDto(mapApplicationService.getHistoryState(idObj, version));

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    /**
     * Retrieve.
     * Retrieves MapLocation with the specified Coordinates.
     */
    @GetMapping("{id}/MapLocations/{coordinates}")
    @Transactional(readOnly = true)
    public MapLocationStateDto getMapLocation(@PathVariable("id") String id, @PathVariable("coordinates") String coordinates) {
        try {

            MapLocationState state = mapApplicationService.getMapLocation(id, (new AbstractValueObjectTextFormatter<Coordinates>(Coordinates.class, ",") {
                        @Override
                        protected Class<?> getClassByTypeName(String type) {
                            return BoundedContextMetadata.CLASS_MAP.get(type);
                        }
                    }.parse(coordinates)));
            if (state == null) { return null; }
            MapLocationStateDto.DtoConverter dtoConverter = new MapLocationStateDto.DtoConverter();
            MapLocationStateDto stateDto = dtoConverter.toMapLocationStateDto(state);
            dtoConverter.setAllFieldsReturned(true);
            return stateDto;

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    /**
     * MapLocation List
     */
    @GetMapping("{id}/MapLocations")
    @Transactional(readOnly = true)
    public MapLocationStateDto[] getMapLocations(@PathVariable("id") String id,
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
                    .filter(kv -> MapResourceUtils.getMapLocationFilterPropertyName(kv.getKey()) != null)
                    .collect(Collectors.toMap(kv -> kv.getKey(), kv -> kv.getValue())));
            }
            Criterion c = CriterionDto.toSubclass(criterion, getCriterionTypeConverter(), getPropertyTypeResolver(), 
                n -> (MapLocationMetadata.aliasMap.containsKey(n) ? MapLocationMetadata.aliasMap.get(n) : n));
            Iterable<MapLocationState> states = mapApplicationService.getMapLocations(id, c,
                    MapResourceUtils.getMapLocationQuerySorts(request.getParameterMap()));
            if (states == null) { return null; }
            MapLocationStateDto.DtoConverter dtoConverter = new MapLocationStateDto.DtoConverter();
            if (StringHelper.isNullOrEmpty(fields)) {
                dtoConverter.setAllFieldsReturned(true);
            } else {
                dtoConverter.setReturnedFieldsString(fields);
            }
            return dtoConverter.toMapLocationStateDtoArray(states);
        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    /**
     * Retrieve.
     * Retrieves MapClaimIslandWhitelistItem with the specified Key.
     */
    @GetMapping("{id}/MapClaimIslandWhitelistItems/{key}")
    @Transactional(readOnly = true)
    public MapClaimIslandWhitelistItemStateDto getMapClaimIslandWhitelistItem(@PathVariable("id") String id, @PathVariable("key") String key) {
        try {

            MapClaimIslandWhitelistItemState state = mapApplicationService.getMapClaimIslandWhitelistItem(id, key);
            if (state == null) { return null; }
            MapClaimIslandWhitelistItemStateDto.DtoConverter dtoConverter = new MapClaimIslandWhitelistItemStateDto.DtoConverter();
            MapClaimIslandWhitelistItemStateDto stateDto = dtoConverter.toMapClaimIslandWhitelistItemStateDto(state);
            dtoConverter.setAllFieldsReturned(true);
            return stateDto;

        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }

    /**
     * MapClaimIslandWhitelistItem List
     */
    @GetMapping("{id}/MapClaimIslandWhitelistItems")
    @Transactional(readOnly = true)
    public MapClaimIslandWhitelistItemStateDto[] getMapClaimIslandWhitelistItems(@PathVariable("id") String id,
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
                    .filter(kv -> MapResourceUtils.getMapClaimIslandWhitelistItemFilterPropertyName(kv.getKey()) != null)
                    .collect(Collectors.toMap(kv -> kv.getKey(), kv -> kv.getValue())));
            }
            Criterion c = CriterionDto.toSubclass(criterion, getCriterionTypeConverter(), getPropertyTypeResolver(), 
                n -> (MapClaimIslandWhitelistItemMetadata.aliasMap.containsKey(n) ? MapClaimIslandWhitelistItemMetadata.aliasMap.get(n) : n));
            Iterable<MapClaimIslandWhitelistItemState> states = mapApplicationService.getMapClaimIslandWhitelistItems(id, c,
                    MapResourceUtils.getMapClaimIslandWhitelistItemQuerySorts(request.getParameterMap()));
            if (states == null) { return null; }
            MapClaimIslandWhitelistItemStateDto.DtoConverter dtoConverter = new MapClaimIslandWhitelistItemStateDto.DtoConverter();
            if (StringHelper.isNullOrEmpty(fields)) {
                dtoConverter.setAllFieldsReturned(true);
            } else {
                dtoConverter.setReturnedFieldsString(fields);
            }
            return dtoConverter.toMapClaimIslandWhitelistItemStateDtoArray(states);
        } catch (Exception ex) { logger.info(ex.getMessage(), ex); throw DomainErrorUtils.convertException(ex); }
    }



    //protected  MapStateEventDtoConverter getMapStateEventDtoConverter() {
    //    return new MapStateEventDtoConverter();
    //}

    protected TypeConverter getCriterionTypeConverter() {
        return new DefaultTypeConverter();
    }

    protected PropertyTypeResolver getPropertyTypeResolver() {
        return new PropertyTypeResolver() {
            @Override
            public Class resolveTypeByPropertyName(String propertyName) {
                return MapResourceUtils.getFilterPropertyType(propertyName);
            }
        };
    }

    protected PropertyTypeResolver getMapLocationPropertyTypeResolver() {
        return new PropertyTypeResolver() {
            @Override
            public Class resolveTypeByPropertyName(String propertyName) {
                return MapResourceUtils.getMapLocationFilterPropertyType(propertyName);
            }
        };
    }

    protected PropertyTypeResolver getMapClaimIslandWhitelistItemPropertyTypeResolver() {
        return new PropertyTypeResolver() {
            @Override
            public Class resolveTypeByPropertyName(String propertyName) {
                return MapResourceUtils.getMapClaimIslandWhitelistItemFilterPropertyType(propertyName);
            }
        };
    }

    // ////////////////////////////////
 
    public static class MapResourceUtils {

        public static void setNullIdOrThrowOnInconsistentIds(String id, org.dddml.suiinfinitesea.domain.map.MapCommand value) {
            String idObj = id;
            if (value.getId() == null) {
                value.setId(idObj);
            } else if (!value.getId().equals(idObj)) {
                throw DomainError.named("inconsistentId", "Argument Id %1$s NOT equals body Id %2$s", id, value.getId());
            }
        }
    
        public static List<String> getQueryOrders(String str, String separator) {
            return QueryParamUtils.getQueryOrders(str, separator, MapMetadata.aliasMap);
        }

        public static List<String> getQuerySorts(Map<String, String[]> queryNameValuePairs) {
            String[] values = queryNameValuePairs.get("sort");
            return QueryParamUtils.getQuerySorts(values, MapMetadata.aliasMap);
        }

        public static String getFilterPropertyName(String fieldName) {
            if ("sort".equalsIgnoreCase(fieldName)
                    || "firstResult".equalsIgnoreCase(fieldName)
                    || "maxResults".equalsIgnoreCase(fieldName)
                    || "fields".equalsIgnoreCase(fieldName)) {
                return null;
            }
            if (MapMetadata.aliasMap.containsKey(fieldName)) {
                return MapMetadata.aliasMap.get(fieldName);
            }
            return null;
        }

        public static Class getFilterPropertyType(String propertyName) {
            if (MapMetadata.propertyTypeMap.containsKey(propertyName)) {
                String propertyType = MapMetadata.propertyTypeMap.get(propertyName);
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

        public static List<String> getMapLocationQueryOrders(String str, String separator) {
            return QueryParamUtils.getQueryOrders(str, separator, MapLocationMetadata.aliasMap);
        }

        public static List<String> getMapLocationQuerySorts(Map<String, String[]> queryNameValuePairs) {
            String[] values = queryNameValuePairs.get("sort");
            return QueryParamUtils.getQuerySorts(values, MapLocationMetadata.aliasMap);
        }

        public static String getMapLocationFilterPropertyName(String fieldName) {
            if ("sort".equalsIgnoreCase(fieldName)
                    || "firstResult".equalsIgnoreCase(fieldName)
                    || "maxResults".equalsIgnoreCase(fieldName)
                    || "fields".equalsIgnoreCase(fieldName)) {
                return null;
            }
            if (MapLocationMetadata.aliasMap.containsKey(fieldName)) {
                return MapLocationMetadata.aliasMap.get(fieldName);
            }
            return null;
        }

        public static Class getMapLocationFilterPropertyType(String propertyName) {
            if (MapLocationMetadata.propertyTypeMap.containsKey(propertyName)) {
                String propertyType = MapLocationMetadata.propertyTypeMap.get(propertyName);
                if (!StringHelper.isNullOrEmpty(propertyType)) {
                    if (BoundedContextMetadata.CLASS_MAP.containsKey(propertyType)) {
                        return BoundedContextMetadata.CLASS_MAP.get(propertyType);
                    }
                }
            }
            return String.class;
        }

        public static Iterable<Map.Entry<String, Object>> getMapLocationQueryFilterMap(Map<String, String[]> queryNameValuePairs) {
            Map<String, Object> filter = new HashMap<>();
            queryNameValuePairs.forEach((key, values) -> {
                if (values.length > 0) {
                    String pName = getMapLocationFilterPropertyName(key);
                    if (!StringHelper.isNullOrEmpty(pName)) {
                        Class pClass = getMapLocationFilterPropertyType(pName);
                        filter.put(pName, ApplicationContext.current.getTypeConverter().convertFromString(pClass, values[0]));
                    }
                }
            });
            return filter.entrySet();
        }

        public static List<String> getMapClaimIslandWhitelistItemQueryOrders(String str, String separator) {
            return QueryParamUtils.getQueryOrders(str, separator, MapClaimIslandWhitelistItemMetadata.aliasMap);
        }

        public static List<String> getMapClaimIslandWhitelistItemQuerySorts(Map<String, String[]> queryNameValuePairs) {
            String[] values = queryNameValuePairs.get("sort");
            return QueryParamUtils.getQuerySorts(values, MapClaimIslandWhitelistItemMetadata.aliasMap);
        }

        public static String getMapClaimIslandWhitelistItemFilterPropertyName(String fieldName) {
            if ("sort".equalsIgnoreCase(fieldName)
                    || "firstResult".equalsIgnoreCase(fieldName)
                    || "maxResults".equalsIgnoreCase(fieldName)
                    || "fields".equalsIgnoreCase(fieldName)) {
                return null;
            }
            if (MapClaimIslandWhitelistItemMetadata.aliasMap.containsKey(fieldName)) {
                return MapClaimIslandWhitelistItemMetadata.aliasMap.get(fieldName);
            }
            return null;
        }

        public static Class getMapClaimIslandWhitelistItemFilterPropertyType(String propertyName) {
            if (MapClaimIslandWhitelistItemMetadata.propertyTypeMap.containsKey(propertyName)) {
                String propertyType = MapClaimIslandWhitelistItemMetadata.propertyTypeMap.get(propertyName);
                if (!StringHelper.isNullOrEmpty(propertyType)) {
                    if (BoundedContextMetadata.CLASS_MAP.containsKey(propertyType)) {
                        return BoundedContextMetadata.CLASS_MAP.get(propertyType);
                    }
                }
            }
            return String.class;
        }

        public static Iterable<Map.Entry<String, Object>> getMapClaimIslandWhitelistItemQueryFilterMap(Map<String, String[]> queryNameValuePairs) {
            Map<String, Object> filter = new HashMap<>();
            queryNameValuePairs.forEach((key, values) -> {
                if (values.length > 0) {
                    String pName = getMapClaimIslandWhitelistItemFilterPropertyName(key);
                    if (!StringHelper.isNullOrEmpty(pName)) {
                        Class pClass = getMapClaimIslandWhitelistItemFilterPropertyType(pName);
                        filter.put(pName, ApplicationContext.current.getTypeConverter().convertFromString(pClass, values[0]));
                    }
                }
            });
            return filter.entrySet();
        }

        public static MapStateDto[] toMapStateDtoArray(Iterable<String> ids) {
            List<MapStateDto> states = new ArrayList<>();
            ids.forEach(i -> {
                MapStateDto dto = new MapStateDto();
                dto.setId(i);
                states.add(dto);
            });
            return states.toArray(new MapStateDto[0]);
        }

    }

}

