package org.dddml.suiinfinitesea.sui.contract.config;

import com.github.wubuku.sui.utils.SuiJsonRpcClient;
import okhttp3.OkHttpClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.net.MalformedURLException;

@Configuration
public class SuiJsonRpcConfig {
    @Value("${sui.contract.jsonrpc.url}")
    private String jsonRpcUrl;

    @Bean
    public SuiJsonRpcClient suiJsonRpcClient() throws MalformedURLException {
        OkHttpClient httpClient = new OkHttpClient.Builder()
                .readTimeout(20, java.util.concurrent.TimeUnit.SECONDS)
                .addInterceptor(new OkHttpClientRequestCounterInterceptor())
                .build();
        return new SuiJsonRpcClient(jsonRpcUrl, httpClient);
    }
}
