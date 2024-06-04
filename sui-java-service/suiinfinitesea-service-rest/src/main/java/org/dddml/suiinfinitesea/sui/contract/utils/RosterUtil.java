package org.dddml.suiinfinitesea.sui.contract.utils;

import org.dddml.suiinfinitesea.sui.contract.Roster;
import org.jetbrains.annotations.NotNull;

import java.math.BigInteger;

public class RosterUtil {
    public static final byte AT_ANCHOR = 0;
    public static final byte UNDERWAY = 1;
    public static final byte IN_BATTLE = 2;
    public static final byte DESTROYED = 3;

    private RosterUtil() {
    }

    /*
    /// Return current location of the roster, the now time and the new status of the roster.
    public fun calculate_current_location(roster: &Roster, clock: &Clock): (Coordinates, u64, u8) {
        let old_status = roster::status(roster);
        let target_coordinates_o = roster::target_coordinates(roster);
        assert!(roster_status::underway() == old_status, EInvalidRosterStatus);
        assert!(option::is_some(&target_coordinates_o), ETargetCoordinatesNotSet);

        let target_coordinates = option::extract(&mut target_coordinates_o);
        let updated_coordinates = roster::updated_coordinates(roster);
        let coordinates_updated_at = roster::coordinates_updated_at(roster);
        let new_status = old_status;
        let (speed_numerator, speed_denominator) = speed_util::speed_to_coordinate_units_per_second(
            roster::speed(roster)
        );
        let now_time = clock::timestamp_ms(clock) / 1000;
        assert!(now_time >= coordinates_updated_at, EInvalidRoasterUpdateTime);
        let elapsed_time = now_time - coordinates_updated_at;
        updated_coordinates = direct_route_util::calculate_current_location(
            updated_coordinates, target_coordinates,
            speed_numerator, speed_denominator, elapsed_time
        );
        if (target_coordinates == updated_coordinates) {
            new_status = roster_status::at_anchor();
        };
        coordinates_updated_at = now_time;
        (updated_coordinates, coordinates_updated_at, new_status)
    }
     */

    public static Long[] calculateCurrentLocation(Roster roster, Long now_time) {
        byte old_status = roster.getStatus().byteValue();
        if (roster.getTargetCoordinates() == null) {
            throw new IllegalArgumentException("Target coordinates not set");
        }
        Long[] updated_coordinates = new Long[]{roster.getUpdatedCoordinates().getFields().getX(), roster.getUpdatedCoordinates().getFields().getY()};
        BigInteger coordinates_updated_at = roster.getCoordinatesUpdatedAt();
        Long[] target_coordinates = new Long[]{roster.getTargetCoordinates().getFields().getX(), roster.getTargetCoordinates().getFields().getY()};
        long roster_speed = roster.getSpeed();
        return calculateCurrentLocation(old_status,
                updated_coordinates, coordinates_updated_at.longValue(),
                target_coordinates, roster_speed, now_time
        );
    }

    public static Long[] calculateCurrentLocation(
            byte status,
            Long[] updated_coordinates,
            Long coordinates_updated_at,
            Long[] target_coordinates,
            long roster_speed,
            Long now_time
    ) {
        if (status != UNDERWAY) {
            throw new IllegalArgumentException("Invalid roster status");
        }
        byte new_status = status;
        long elapsed_time = now_time == null
                ? (System.currentTimeMillis() / 1000) - coordinates_updated_at
                : now_time - coordinates_updated_at;
        long[] speed = SpeedUtil.speedToCoordinateUnitsPerSecond(roster_speed);
        updated_coordinates = DirectRouteUtil.calculateCurrentLocation(
                updated_coordinates,
                target_coordinates,
                speed[0], speed[1], elapsed_time
        );
        if (target_coordinates[0].equals(updated_coordinates[0]) && target_coordinates[1].equals(updated_coordinates[1])) {
            new_status = AT_ANCHOR;
        }
        return new Long[]{
                updated_coordinates[0], updated_coordinates[1],
                (long) new_status
        };
    }
}
