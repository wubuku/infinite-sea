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

    private final SuiPackageInitializationService commonPackageInitializationService;
    private final SuiPackageInitializationService defaultPackageInitializationService;

    @Autowired
    public SuiPackageInitializer(
            MoveObjectIdGeneratorObjectRepository moveObjectIdGeneratorObjectRepository,
            SuiPackageRepository suiPackageRepository,
            SuiJsonRpcClient suiJsonRpcClient,
            @Value("${sui.contract.package-publish-transactions.common}")
            String commonPackagePublishTransactionDigest,
            @Value("${sui.contract.package-publish-transactions.default}")
            String defaultPackagePublishTransactionDigest
    ) {
        this.commonPackageInitializationService = new SuiPackageInitializationService(
                moveObjectIdGeneratorObjectRepository,
                suiPackageRepository,
                suiJsonRpcClient,
                commonPackagePublishTransactionDigest,
                ContractConstants.COMMON_SUI_PACKAGE_NAME,
                ContractConstants::getCommonPackageIdGeneratorObjectTypes
        );
        this.defaultPackageInitializationService = new SuiPackageInitializationService(
                moveObjectIdGeneratorObjectRepository,
                suiPackageRepository,
                suiJsonRpcClient,
                defaultPackagePublishTransactionDigest,
                ContractConstants.DEFAULT_SUI_PACKAGE_NAME,
                ContractConstants::getDefaultPackageIdGeneratorObjectTypes
        );
    }

    @EventListener(ApplicationReadyEvent.class)
    public void init() {
        commonPackageInitializationService.init();
        defaultPackageInitializationService.init();
    }
}
