package org.dddml.suiinfinitesea.sui.contract;

import com.github.wubuku.sui.utils.SuiJsonRpcClient;
import org.dddml.suiinfinitesea.sui.contract.repository.MoveObjectIdGeneratorObjectRepository;
import org.dddml.suiinfinitesea.sui.contract.repository.SuiPackageRepository;
import org.dddml.suiinfinitesea.sui.contract.service.SuiPackageInitializationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

@Component
public class SuiPackageInitializer {

    private final SuiPackageInitializationService nftPackageInitializationService;

    private final SuiPackageInitializationService mapPackageInitializationService;

    private final SuiPackageInitializationService commonPackageInitializationService;

    private final SuiPackageInitializationService defaultPackageInitializationService;

    @Autowired
    public SuiPackageInitializer(
            MoveObjectIdGeneratorObjectRepository moveObjectIdGeneratorObjectRepository,
            SuiPackageRepository suiPackageRepository,
            SuiJsonRpcClient suiJsonRpcClient,
            @Value("${sui.contract.package-publish-transactions.nft:}")
            String nftPackagePublishTransactionDigest,
            @Value("${sui.contract.event-type-patterns-for-extract-package-id.nft:}")
            String nftEventTypePatternForExtractPackageId,
            @Value("${sui.contract.package-publish-transactions.map:}")
            String mapPackagePublishTransactionDigest,
            @Value("${sui.contract.event-type-patterns-for-extract-package-id.map:}")
            String mapEventTypePatternForExtractPackageId,
            @Value("${sui.contract.package-publish-transactions.common:}")
            String commonPackagePublishTransactionDigest,
            @Value("${sui.contract.event-type-patterns-for-extract-package-id.common:}")
            String commonEventTypePatternForExtractPackageId,
            @Value("${sui.contract.package-publish-transactions.default:}")
            String defaultPackagePublishTransactionDigest,
            @Value("${sui.contract.event-type-patterns-for-extract-package-id.default:}")
            String defaultEventTypePatternForExtractPackageId
    ) {
        if (nftPackagePublishTransactionDigest != null && !nftPackagePublishTransactionDigest.trim().isEmpty()) {
            nftPackageInitializationService = new SuiPackageInitializationService(
                    moveObjectIdGeneratorObjectRepository,
                    suiPackageRepository,
                    suiJsonRpcClient,
                    nftPackagePublishTransactionDigest,
                    ContractConstants.NFT_SUI_PACKAGE_NAME,
                    ContractConstants::getNftPackageIdGeneratorObjectTypes,
                    nftEventTypePatternForExtractPackageId
            );
        } else {
            //throw new IllegalArgumentException("nftPackagePublishTransactionDigest is null");
            nftPackageInitializationService = null;
        }
        if (mapPackagePublishTransactionDigest != null && !mapPackagePublishTransactionDigest.trim().isEmpty()) {
            mapPackageInitializationService = new SuiPackageInitializationService(
                    moveObjectIdGeneratorObjectRepository,
                    suiPackageRepository,
                    suiJsonRpcClient,
                    mapPackagePublishTransactionDigest,
                    ContractConstants.MAP_SUI_PACKAGE_NAME,
                    ContractConstants::getMapPackageIdGeneratorObjectTypes,
                    mapEventTypePatternForExtractPackageId
            );
        } else {
            //throw new IllegalArgumentException("mapPackagePublishTransactionDigest is null");
            mapPackageInitializationService = null;
        }
        if (commonPackagePublishTransactionDigest != null && !commonPackagePublishTransactionDigest.trim().isEmpty()) {
            commonPackageInitializationService = new SuiPackageInitializationService(
                    moveObjectIdGeneratorObjectRepository,
                    suiPackageRepository,
                    suiJsonRpcClient,
                    commonPackagePublishTransactionDigest,
                    ContractConstants.COMMON_SUI_PACKAGE_NAME,
                    ContractConstants::getCommonPackageIdGeneratorObjectTypes,
                    commonEventTypePatternForExtractPackageId
            );
        } else {
            //throw new IllegalArgumentException("commonPackagePublishTransactionDigest is null");
            commonPackageInitializationService = null;
        }
        if (defaultPackagePublishTransactionDigest != null && !defaultPackagePublishTransactionDigest.trim().isEmpty()) {
            defaultPackageInitializationService = new SuiPackageInitializationService(
                    moveObjectIdGeneratorObjectRepository,
                    suiPackageRepository,
                    suiJsonRpcClient,
                    defaultPackagePublishTransactionDigest,
                    ContractConstants.DEFAULT_SUI_PACKAGE_NAME,
                    ContractConstants::getDefaultPackageIdGeneratorObjectTypes,
                    defaultEventTypePatternForExtractPackageId
            );
        } else {
            //throw new IllegalArgumentException("defaultPackagePublishTransactionDigest is null");
            defaultPackageInitializationService = null;
        }
    }

    @EventListener(ApplicationReadyEvent.class)
    public void init() {
        if (nftPackageInitializationService != null) {
            nftPackageInitializationService.init();
        }
        if (mapPackageInitializationService != null) {
            mapPackageInitializationService.init();
        }
        if (commonPackageInitializationService != null) {
            commonPackageInitializationService.init();
        }
        if (defaultPackageInitializationService != null) {
            defaultPackageInitializationService.init();
        }
    }
}
