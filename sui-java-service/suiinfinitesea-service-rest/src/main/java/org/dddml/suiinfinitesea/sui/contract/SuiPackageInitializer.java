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

    private final SuiPackageInitializationService commonPackageInitializationService;

    private final SuiPackageInitializationService defaultPackageInitializationService;

    private final SuiPackageInitializationService faucetPackageInitializationService;

    @Autowired
    public SuiPackageInitializer(
            MoveObjectIdGeneratorObjectRepository moveObjectIdGeneratorObjectRepository,
            SuiPackageRepository suiPackageRepository,
            SuiJsonRpcClient suiJsonRpcClient,
            @Value("${sui.contract.package-publish-transactions.nft:}")
            String nftPackagePublishTransactionDigest,
            @Value("${sui.contract.package-publish-transactions.common:}")
            String commonPackagePublishTransactionDigest,
            @Value("${sui.contract.package-publish-transactions.default:}")
            String defaultPackagePublishTransactionDigest,
            @Value("${sui.contract.package-publish-transactions.faucet:}")
            String faucetPackagePublishTransactionDigest
    ) {
        if (nftPackagePublishTransactionDigest != null && !nftPackagePublishTransactionDigest.trim().isEmpty()) {
            nftPackageInitializationService = new SuiPackageInitializationService(
                    moveObjectIdGeneratorObjectRepository,
                    suiPackageRepository,
                    suiJsonRpcClient,
                    nftPackagePublishTransactionDigest,
                    ContractConstants.NFT_SUI_PACKAGE_NAME,
                    ContractConstants::getNftPackageIdGeneratorObjectTypes
            );
        } else {
            //throw new IllegalArgumentException("nftPackagePublishTransactionDigest is null");
            nftPackageInitializationService = null;
        }
        if (commonPackagePublishTransactionDigest != null && !commonPackagePublishTransactionDigest.trim().isEmpty()) {
            commonPackageInitializationService = new SuiPackageInitializationService(
                    moveObjectIdGeneratorObjectRepository,
                    suiPackageRepository,
                    suiJsonRpcClient,
                    commonPackagePublishTransactionDigest,
                    ContractConstants.COMMON_SUI_PACKAGE_NAME,
                    ContractConstants::getCommonPackageIdGeneratorObjectTypes
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
                    ContractConstants::getDefaultPackageIdGeneratorObjectTypes
            );
        } else {
            //throw new IllegalArgumentException("defaultPackagePublishTransactionDigest is null");
            defaultPackageInitializationService = null;
        }
        if (faucetPackagePublishTransactionDigest != null && !faucetPackagePublishTransactionDigest.trim().isEmpty()) {
            faucetPackageInitializationService = new SuiPackageInitializationService(
                    moveObjectIdGeneratorObjectRepository,
                    suiPackageRepository,
                    suiJsonRpcClient,
                    defaultPackagePublishTransactionDigest,
                    "FAUCET_SUI_PACKAGE",
                    ContractConstants::getDefaultPackageIdGeneratorObjectTypes
            );
        } else {
            //throw new IllegalArgumentException("defaultPackagePublishTransactionDigest is null");
            faucetPackageInitializationService = null;
        }
    }

    @EventListener(ApplicationReadyEvent.class)
    public void init() {
        if (nftPackageInitializationService != null) {
            nftPackageInitializationService.init();
        }
        if (commonPackageInitializationService != null) {
            commonPackageInitializationService.init();
        }
        if (defaultPackageInitializationService != null) {
            defaultPackageInitializationService.init();
        }
        if (faucetPackageInitializationService != null) {
            //FIXME 这里没有正确保存 packageId 看看怎么回事儿
            faucetPackageInitializationService.init();
        }
    }
}
