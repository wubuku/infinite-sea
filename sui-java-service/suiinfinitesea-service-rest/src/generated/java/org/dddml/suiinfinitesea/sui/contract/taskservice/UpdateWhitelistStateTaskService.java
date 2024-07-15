// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.taskservice;

import org.dddml.suiinfinitesea.domain.whitelist.AbstractWhitelistEvent;
import org.dddml.suiinfinitesea.sui.contract.repository.*;
import org.dddml.suiinfinitesea.sui.contract.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UpdateWhitelistStateTaskService {

    @Autowired
    private SuiWhitelistService suiWhitelistService;

    @Autowired
    private WhitelistEventRepository whitelistEventRepository;

    @Autowired
    private WhitelistEventService whitelistEventService;

    @Scheduled(fixedDelayString = "${sui.contract.update-whitelist-states.fixed-delay:5000}")
    @Transactional
    public void updateWhitelistStates() {
        AbstractWhitelistEvent e = whitelistEventRepository.findFirstByEventStatusIsNull();
        if (e != null) {
            String objectId = e.getId();
            suiWhitelistService.updateWhitelistState(objectId);
            whitelistEventService.updateStatusToProcessed(e);
        }
    }
}
