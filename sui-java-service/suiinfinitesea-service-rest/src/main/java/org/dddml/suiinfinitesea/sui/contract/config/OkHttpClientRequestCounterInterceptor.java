package org.dddml.suiinfinitesea.sui.contract.config;

import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;

public class OkHttpClientRequestCounterInterceptor implements Interceptor {
    // create a logger
    private static final Logger logger = LoggerFactory.getLogger(OkHttpClientRequestCounterInterceptor.class);

    private final AtomicInteger count = new AtomicInteger(0);
    private final AtomicLong lastTime = new AtomicLong(System.currentTimeMillis());

    @Override
    public Response intercept(Chain chain) throws IOException {
        Request request = chain.request();
        // System.out.println("Request URL: " + request.url());
        // System.out.println("Request Headers: " + request.headers());

        long currentTime = System.currentTimeMillis();
        long elapsedTime = currentTime - lastTime.get();

        if (elapsedTime >= 1000) {
            int currentCount = count.getAndSet(0);
            long reqPerSecond = currentCount / (elapsedTime / 1000);
            //System.out.println("Recent One Second Counter: " + reqPerSecond);
            logger.info(String.format("======== OkHttpClient requests per second: %d ========", reqPerSecond));
            lastTime.set(currentTime);
        }

        count.incrementAndGet();
        return chain.proceed(request);
    }
}