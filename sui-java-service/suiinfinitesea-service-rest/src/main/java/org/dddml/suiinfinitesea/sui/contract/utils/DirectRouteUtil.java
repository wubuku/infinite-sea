package org.dddml.suiinfinitesea.sui.contract.utils;


import java.math.BigInteger;

public class DirectRouteUtil {
    private DirectRouteUtil() {
    }

    // Get distance between two points
    public static BigInteger getDistance(Long[] origin, Long[] destination) {
        Long o_x = origin[0];
        Long o_y = origin[1];
        Long d_x = destination[0];
        Long d_y = destination[1];
        Long x_diff = o_x > d_x ? o_x - d_x : d_x - o_x;
        Long y_diff = o_y > d_y ? o_y - d_y : d_y - o_y;
        return BigInteger.valueOf(Math.round(Math.sqrt((x_diff * x_diff + y_diff * y_diff))));
    }

    public static Long[] calculateCurrentLocation(
            Long[] origin,
            Long[] destination,
            Long speed_numerator,
            Long speed_denominator,
            Long elapsed_time
    ) {
        Long o_x = origin[0];
        Long o_y = origin[1];
        Long d_x = destination[0];
        Long d_y = destination[1];
        boolean x_diff_sign = o_x > d_x;
        boolean y_diff_sign = o_y > d_y;
        Long x_diff = x_diff_sign ? o_x - d_x : d_x - o_x;
        Long y_diff = y_diff_sign ? o_y - d_y : d_y - o_y;
        BigInteger total_distance = BigInteger.valueOf(Math.round(Math.sqrt((x_diff * x_diff + y_diff * y_diff))));
        BigInteger total_time = total_distance.multiply(BigInteger.valueOf(speed_denominator)).divide(BigInteger.valueOf(speed_numerator));
        if (BigInteger.valueOf(elapsed_time).compareTo(total_time) >= 0) {
            return destination;
        }
        long c_x = x_diff_sign
                ? o_x - x_diff * elapsed_time / total_time.longValue()
                : o_x + x_diff * elapsed_time / total_time.longValue();
        long c_y = y_diff_sign
                ? o_y - y_diff * elapsed_time / total_time.longValue()
                : o_y + y_diff * elapsed_time / total_time.longValue();
        return new Long[]{c_x, c_y};
    }
}
