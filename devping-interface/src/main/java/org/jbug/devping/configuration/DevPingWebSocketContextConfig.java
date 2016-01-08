package org.jbug.devping.configuration;

import org.jbug.devping.interfaces.ws.CSWebSocketHandler;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

/**
 * Created by jhouse on 10/9/14.
 */
@Configuration
@EnableWebSocket
@ComponentScan(basePackages="org.jbug.devping.interfaces.ws")
public class DevPingWebSocketContextConfig implements WebSocketConfigurer {

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        // WebSocket을 /echo 에 연결합니다.
        registry.addHandler(echoHandler(), "/devpingWS")
        .addInterceptors(new org.jbug.devping.interfaces.ws.SessionInterceptor());

        // SocketJS 지원 url을 /socketjs/echo에 연결합니다.
        registry.addHandler(echoHandler(), "/socketjs/devpingWS").withSockJS()
        .setInterceptors(new org.jbug.devping.interfaces.ws.SessionInterceptor());
    }

    @Bean
    public WebSocketHandler echoHandler() {
        return new CSWebSocketHandler();
    }
}
