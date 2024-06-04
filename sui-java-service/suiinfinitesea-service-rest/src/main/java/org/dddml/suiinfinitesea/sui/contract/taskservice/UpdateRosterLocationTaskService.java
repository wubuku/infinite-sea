package org.dddml.suiinfinitesea.sui.contract.taskservice;

import org.dddml.suiinfinitesea.domain.Coordinates;
import org.dddml.suiinfinitesea.domain.roster.RosterStateQueryRepository;
import org.dddml.suiinfinitesea.domain.rosterlocation.RosterLocationState;
import org.dddml.suiinfinitesea.domain.rosterlocation.RosterLocationStateRepository;
import org.dddml.suiinfinitesea.sui.contract.utils.RosterUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;

@Service
public class UpdateRosterLocationTaskService {
    @Autowired
    private RosterStateQueryRepository rosterStateQueryRepository;

    @Autowired
    private RosterLocationStateRepository rosterLocationStateRepository;


    @Scheduled(fixedDelayString = "${sui.contract.update-all-roster-locations.fixed-delay:5000}")
    @Transactional
    public void updateAllPlayerStates() {
        rosterStateQueryRepository.getAll(0, Integer.MAX_VALUE).forEach(s -> {
            String objectId = s.getId_();
            if (s.getTargetCoordinates() == null ||
                    s.getTargetCoordinates().getX() == null ||
                    s.getTargetCoordinates().getY() == null ||
                    s.getStatus() == null || s.getStatus() != RosterUtil.UNDERWAY ||
                    s.getSpeed() == null ||
                    s.getUpdatedCoordinates() == null ||
                    s.getUpdatedCoordinates().getX() == null ||
                    s.getUpdatedCoordinates().getY() == null ||
                    s.getCoordinatesUpdatedAt() == null
            ) {
                return;
            }
            Long[] updated = RosterUtil.calculateCurrentLocation(
                    s.getStatus().byteValue(),
                    new Long[]{s.getUpdatedCoordinates().getX(), s.getUpdatedCoordinates().getY()},
                    s.getCoordinatesUpdatedAt().longValue(),
                    new Long[]{s.getTargetCoordinates().getX(), s.getTargetCoordinates().getY()},
                    s.getSpeed(),
                    null
            );
            long coordinates_x = updated[0];
            long coordinates_y = updated[1];
            byte status = updated[2].byteValue();

            RosterLocationState.MutableRosterLocationState rosterLocationState = (RosterLocationState.MutableRosterLocationState)
                    rosterLocationStateRepository.get(objectId, false);
            rosterLocationState.setCoordinates(new Coordinates(coordinates_x, coordinates_y));
            rosterLocationState.setStatus((int) status);
            rosterLocationState.setUpdatedAt(new Date());
            rosterLocationStateRepository.merge(rosterLocationState);
        });
    }
}
