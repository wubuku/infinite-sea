
package org.dddml.suiinfinitesea.sui.contract.service;

import com.github.wubuku.sui.bean.EventId;
import com.github.wubuku.sui.bean.Page;
import com.github.wubuku.sui.bean.PaginatedMoveEvents;
import com.github.wubuku.sui.bean.SuiMoveEventEnvelope;
import com.github.wubuku.sui.utils.SuiJsonRpcClient;
import org.dddml.suiinfinitesea.domain.faucetrequested.AbstractFaucetRequestedState;
import org.dddml.suiinfinitesea.domain.faucetrequested.FaucetRequestedState;
import org.dddml.suiinfinitesea.domain.faucetrequested.FaucetRequestedStateQueryRepository;
import org.dddml.suiinfinitesea.domain.faucetrequested.FaucetRequestedStateRepository;
import org.dddml.suiinfinitesea.domain.item.AbstractItemEvent;
import org.dddml.suiinfinitesea.sui.contract.SuiPackage;
import org.dddml.suiinfinitesea.sui.contract.repository.ItemEventRepository;
import org.dddml.suiinfinitesea.sui.contract.repository.SuiPackageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class FaucetEventService {

    @Autowired
    private SuiPackageRepository suiPackageRepository;

    @Autowired
    private FaucetRequestedStateRepository faucetRequestedStateRepository;

    @Autowired
    private FaucetRequestedStateQueryRepository faucetRequestedStateQueryRepository;

    @Autowired
    private SuiJsonRpcClient suiJsonRpcClient;

    @Autowired
    private ItemEventRepository itemEventRepository;

    @Transactional
    public void updateStatusToProcessed(AbstractItemEvent event) {
        event.setEventStatus("D");
        itemEventRepository.save(event);
    }

    @Transactional
    public void pullFaucetRequestedEvents() {
        String packageId = getFaucetSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getFaucetRequestEventNextCursor();
        while (true) {
            PaginatedMoveEvents<Map> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::energy_faucet::FaucetRequested",
                    cursor, limit, false, Map.class);
            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<Map> eventEnvelope : eventPage.getData()) {
                    saveFaucetRequested(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getFaucetRequestEventNextCursor() {
        List<Map.Entry<String, Object>> filter = new ArrayList<>();
        List<String> orders = new ArrayList<>();
        orders.add("-suiTimestamp");
        faucetRequestedStateQueryRepository.getFirst(filter, orders);
        FaucetRequestedState state = faucetRequestedStateQueryRepository.getFirst(filter, orders);
        return state != null ? new EventId(state.getSuiTxDigest(), state.getSuiEventSeq() + "") : null;
    }

    private static AbstractFaucetRequestedState toFaucetRequestedState(SuiMoveEventEnvelope<Map> eventEnvelope) {
        Map map = eventEnvelope.getParsedJson();
        AbstractFaucetRequestedState.SimpleFaucetRequestedState simpleFaucetRequestedState = new AbstractFaucetRequestedState.SimpleFaucetRequestedState();
//        simpleFaucetRequestedState.setEventId(faucetRequestedState.getEventId());
        simpleFaucetRequestedState.setEventId(eventEnvelope.getId().getTxDigest() + eventEnvelope.getId().getEventSeq());
        simpleFaucetRequestedState.setActive(true);
        simpleFaucetRequestedState.setRequesterAccount(map.get("account").toString());
        simpleFaucetRequestedState.setRequestedAmount(new BigInteger(map.get("amount").toString()));
        simpleFaucetRequestedState.setDescription(map.get("description").toString());
        simpleFaucetRequestedState.setVersion(BigInteger.valueOf(-1));
//        simpleFaucetRequestedState.setCommandId(faucetRequestedState.getCommandId());
        simpleFaucetRequestedState.setSuiTimestamp(eventEnvelope.getTimestampMs());
        simpleFaucetRequestedState.setSuiTxDigest(eventEnvelope.getId().getTxDigest());
        simpleFaucetRequestedState.setSuiEventSeq(new BigInteger(eventEnvelope.getId().getEventSeq()));
        simpleFaucetRequestedState.setSuiPackageId(eventEnvelope.getPackageId());
        simpleFaucetRequestedState.setSuiTransactionModule(eventEnvelope.getTransactionModule());
        simpleFaucetRequestedState.setSuiSender(eventEnvelope.getSender());
        return simpleFaucetRequestedState;
    }

    private void saveFaucetRequested(SuiMoveEventEnvelope<Map> eventEnvelope) {
        AbstractFaucetRequestedState faucetRequestedState = toFaucetRequestedState(eventEnvelope);
        if (faucetRequestedStateQueryRepository.get(faucetRequestedState.getEventId()) != null) {
            return;
        }
        faucetRequestedStateRepository.save(faucetRequestedState);
    }

    private String getFaucetSuiPackageId() {
        return suiPackageRepository.findById("FAUCET_SUI_PACKAGE")
                .map(SuiPackage::getObjectId).orElse(null);
    }
}
