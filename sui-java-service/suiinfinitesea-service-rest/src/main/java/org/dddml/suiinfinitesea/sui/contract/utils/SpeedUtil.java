package org.dddml.suiinfinitesea.sui.contract.utils;

public class SpeedUtil {
    public static final long STANDARD_SPEED_NUMERATOR = 5892;
    public static final long STANDARD_SPEED_DENOMINATOR = 1000;
    public static final long SPEED_NUMERATOR_DELTA = 589;
    private SpeedUtil() {
    }

    // Convert the speed value to "coordinate units / second".
    public static long[] speedPropertyToCoordinateUnitsPerSecond(long speed_property) {
        long numerator = STANDARD_SPEED_NUMERATOR;
        if (speed_property < 5) {
            numerator = numerator - SPEED_NUMERATOR_DELTA * (5 - speed_property);
        } else {
            numerator = numerator + SPEED_NUMERATOR_DELTA * (speed_property - 5);
        }
        return new long[]{numerator, STANDARD_SPEED_DENOMINATOR};
    }
}
