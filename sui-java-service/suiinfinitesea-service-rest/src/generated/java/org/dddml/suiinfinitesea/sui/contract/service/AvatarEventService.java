// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.service;

import com.github.wubuku.sui.bean.EventId;
import com.github.wubuku.sui.bean.Page;
import com.github.wubuku.sui.bean.PaginatedMoveEvents;
import com.github.wubuku.sui.bean.SuiMoveEventEnvelope;
import com.github.wubuku.sui.utils.SuiJsonRpcClient;
import org.dddml.suiinfinitesea.domain.avatar.AbstractAvatarEvent;
import org.dddml.suiinfinitesea.sui.contract.ContractConstants;
import org.dddml.suiinfinitesea.sui.contract.DomainBeanUtils;
import org.dddml.suiinfinitesea.sui.contract.SuiPackage;
import org.dddml.suiinfinitesea.sui.contract.avatar.AvatarMinted;
import org.dddml.suiinfinitesea.sui.contract.avatar.AvatarUpdated;
import org.dddml.suiinfinitesea.sui.contract.avatar.AvatarBurned;
import org.dddml.suiinfinitesea.sui.contract.avatar.AvatarWhitelistMinted;
import org.dddml.suiinfinitesea.sui.contract.repository.AvatarEventRepository;
import org.dddml.suiinfinitesea.sui.contract.repository.SuiPackageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AvatarEventService {

    public static final java.util.Set<String> DELETION_COMMAND_EVENTS = new java.util.HashSet<>(java.util.Arrays.asList("AvatarBurned"));

    public static boolean isDeletionCommand(String eventType) {
        return DELETION_COMMAND_EVENTS.contains(eventType);
    }

    public static boolean isDeletionCommand(AbstractAvatarEvent e) {
        if (isDeletionCommand(e.getEventType())) {
            return true;
        }
        return false;
    }

    @Autowired
    private SuiPackageRepository suiPackageRepository;

    @Autowired
    private SuiJsonRpcClient suiJsonRpcClient;

    @Autowired
    private AvatarEventRepository avatarEventRepository;

    @Transactional
    public void updateStatusToProcessed(AbstractAvatarEvent event) {
        event.setEventStatus("D");
        avatarEventRepository.save(event);
    }

    @Transactional
    public void pullAvatarMintedEvents() {
        String packageId = getNftSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getAvatarMintedEventNextCursor();
        while (true) {
            PaginatedMoveEvents<AvatarMinted> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.AVATAR_MODULE_AVATAR_MINTED,
                    cursor, limit, false, AvatarMinted.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<AvatarMinted> eventEnvelope : eventPage.getData()) {
                    saveAvatarMinted(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getAvatarMintedEventNextCursor() {
        AbstractAvatarEvent lastEvent = avatarEventRepository.findFirstAvatarMintedByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveAvatarMinted(SuiMoveEventEnvelope<AvatarMinted> eventEnvelope) {
        AbstractAvatarEvent.AvatarMinted avatarMinted = DomainBeanUtils.toAvatarMinted(eventEnvelope);
        if (avatarEventRepository.findById(avatarMinted.getAvatarEventId()).isPresent()) {
            return;
        }
        avatarEventRepository.save(avatarMinted);
    }

    @Transactional
    public void pullAvatarUpdatedEvents() {
        String packageId = getNftSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getAvatarUpdatedEventNextCursor();
        while (true) {
            PaginatedMoveEvents<AvatarUpdated> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.AVATAR_MODULE_AVATAR_UPDATED,
                    cursor, limit, false, AvatarUpdated.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<AvatarUpdated> eventEnvelope : eventPage.getData()) {
                    saveAvatarUpdated(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getAvatarUpdatedEventNextCursor() {
        AbstractAvatarEvent lastEvent = avatarEventRepository.findFirstAvatarUpdatedByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveAvatarUpdated(SuiMoveEventEnvelope<AvatarUpdated> eventEnvelope) {
        AbstractAvatarEvent.AvatarUpdated avatarUpdated = DomainBeanUtils.toAvatarUpdated(eventEnvelope);
        if (avatarEventRepository.findById(avatarUpdated.getAvatarEventId()).isPresent()) {
            return;
        }
        avatarEventRepository.save(avatarUpdated);
    }

    @Transactional
    public void pullAvatarBurnedEvents() {
        String packageId = getNftSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getAvatarBurnedEventNextCursor();
        while (true) {
            PaginatedMoveEvents<AvatarBurned> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.AVATAR_MODULE_AVATAR_BURNED,
                    cursor, limit, false, AvatarBurned.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<AvatarBurned> eventEnvelope : eventPage.getData()) {
                    saveAvatarBurned(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getAvatarBurnedEventNextCursor() {
        AbstractAvatarEvent lastEvent = avatarEventRepository.findFirstAvatarBurnedByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveAvatarBurned(SuiMoveEventEnvelope<AvatarBurned> eventEnvelope) {
        AbstractAvatarEvent.AvatarBurned avatarBurned = DomainBeanUtils.toAvatarBurned(eventEnvelope);
        if (avatarEventRepository.findById(avatarBurned.getAvatarEventId()).isPresent()) {
            return;
        }
        avatarEventRepository.save(avatarBurned);
    }

    @Transactional
    public void pullAvatarWhitelistMintedEvents() {
        String packageId = getNftSuiPackageId();
        if (packageId == null) {
            return;
        }
        int limit = 1;
        EventId cursor = getAvatarWhitelistMintedEventNextCursor();
        while (true) {
            PaginatedMoveEvents<AvatarWhitelistMinted> eventPage = suiJsonRpcClient.queryMoveEvents(
                    packageId + "::" + ContractConstants.AVATAR_MODULE_AVATAR_WHITELIST_MINTED,
                    cursor, limit, false, AvatarWhitelistMinted.class);

            if (eventPage.getData() != null && !eventPage.getData().isEmpty()) {
                cursor = eventPage.getNextCursor();
                for (SuiMoveEventEnvelope<AvatarWhitelistMinted> eventEnvelope : eventPage.getData()) {
                    saveAvatarWhitelistMinted(eventEnvelope);
                }
            } else {
                break;
            }
            if (!Page.hasNextPage(eventPage)) {
                break;
            }
        }
    }

    private EventId getAvatarWhitelistMintedEventNextCursor() {
        AbstractAvatarEvent lastEvent = avatarEventRepository.findFirstAvatarWhitelistMintedByOrderBySuiTimestampDesc();
        return lastEvent != null ? new EventId(lastEvent.getSuiTxDigest(), lastEvent.getSuiEventSeq() + "") : null;
    }

    private void saveAvatarWhitelistMinted(SuiMoveEventEnvelope<AvatarWhitelistMinted> eventEnvelope) {
        AbstractAvatarEvent.AvatarWhitelistMinted avatarWhitelistMinted = DomainBeanUtils.toAvatarWhitelistMinted(eventEnvelope);
        if (avatarEventRepository.findById(avatarWhitelistMinted.getAvatarEventId()).isPresent()) {
            return;
        }
        avatarEventRepository.save(avatarWhitelistMinted);
    }


    private String getNftSuiPackageId() {
        return suiPackageRepository.findById(ContractConstants.NFT_SUI_PACKAGE_NAME)
                .map(SuiPackage::getObjectId).orElse(null);
    }
}