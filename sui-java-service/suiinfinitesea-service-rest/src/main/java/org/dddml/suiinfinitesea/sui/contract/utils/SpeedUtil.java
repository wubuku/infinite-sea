package org.dddml.suiinfinitesea.sui.contract.utils;

public class SpeedUtil {
    private SpeedUtil() {
    }

    // Convert the speed value to "coordinate units / second".
    public static long[] speedToCoordinateUnitsPerSecond(long speed) {
        //todo speed_to_coordinate_units_per_second
        return new long[]{speed, 1};
    }
}
