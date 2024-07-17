// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.sui.contract.taskservice;

import org.dddml.suiinfinitesea.domain.avatar.AbstractAvatarEvent;
import org.dddml.suiinfinitesea.sui.contract.repository.*;
import org.dddml.suiinfinitesea.sui.contract.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UpdateAvatarStateTaskService {

    @Autowired
    private SuiAvatarService suiAvatarService;

    @Autowired
    private AvatarEventRepository avatarEventRepository;

    @Autowired
    private AvatarEventService avatarEventService;

    @Scheduled(fixedDelayString = "${sui.contract.update-avatar-states.fixed-delay:5000}")
    @Transactional
    public void updateAvatarStates() {
        AbstractAvatarEvent e = avatarEventRepository.findFirstByEventStatusIsNull();
        if (e != null) {
            String objectId = e.getId();
            if (AvatarEventService.isDeletionCommand(e)) {
                suiAvatarService.deleteAvatar(objectId);
            } else {
                suiAvatarService.updateAvatarState(objectId);
            }
            avatarEventService.updateStatusToProcessed(e);
        }
    }
}