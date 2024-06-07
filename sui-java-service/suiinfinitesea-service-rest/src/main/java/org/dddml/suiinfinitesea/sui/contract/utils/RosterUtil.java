package org.dddml.suiinfinitesea.sui.contract.utils;

import org.dddml.suiinfinitesea.sui.contract.Roster;

import java.math.BigInteger;

public class RosterUtil {
    public static final byte AT_ANCHOR = 0;
    public static final byte UNDERWAY = 1;
    public static final byte IN_BATTLE = 2;
    public static final byte DESTROYED = 3;

    public static final BigInteger ENERGY_AMOUNT_PER_SECOND_PER_SHIP = BigInteger.valueOf(1388889);

    private RosterUtil() {
    }

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
        long[] speed = SpeedUtil.speedPropertyToCoordinateUnitsPerSecond(roster_speed);
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

    public static long calculateTotalTime(Long[] origin, Long[] destination, long speed_property) {
        BigInteger distance = DirectRouteUtil.getDistance(origin, destination);
        long[] speed = SpeedUtil.speedPropertyToCoordinateUnitsPerSecond(speed_property);
        return distance.multiply(BigInteger.valueOf(speed[1]))
                .divide(BigInteger.valueOf(speed[0])).longValue();
    }

    public static BigInteger calculateEnergyCost(Long[] origin, Long[] destination, long speed_property, long ship_count) {
        long total_time = calculateTotalTime(origin, destination, speed_property);
        return
                BigInteger.valueOf(total_time).multiply(BigInteger.valueOf(ship_count))
                        .multiply(ENERGY_AMOUNT_PER_SECOND_PER_SHIP);
    }

    public static BigInteger[] calculateTotalTimeAndEnergyCost(Long[] origin, Long[] destination, long speed_property, long ship_count) {
        long total_time = calculateTotalTime(origin, destination, speed_property);
        return new BigInteger[]{
                BigInteger.valueOf(total_time),
                BigInteger.valueOf(total_time).multiply(BigInteger.valueOf(ship_count))
                        .multiply(ENERGY_AMOUNT_PER_SECOND_PER_SHIP)
        };
    }
}
