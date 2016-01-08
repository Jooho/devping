package org.jbug.devping.channel;

import org.jbug.devping.service.WSSessionManagerService;
import org.jbug.devping.vo.PingToServerRequsetVo;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import java.io.IOException;
import java.util.Date;

/**
 * Created by jhouse on 10/12/14.
 */
public class PingClientRequestCmd implements Commander{

    WSSessionManagerService wsSessionManagerService = new WSSessionManagerService();

    PingToServerRequsetVo pingToServerRequsetVo =null;
    String pongUser ;
    String channelId ;
    WebSocketSession webSocketSession;

    public PingClientRequestCmd(PingToServerRequsetVo pingToServerRequsetVo,String pongUser, String channelId) {
        this.pingToServerRequsetVo=pingToServerRequsetVo;
        this.pongUser = pongUser;
        this.channelId = channelId;
        webSocketSession = wsSessionManagerService.get(pongUser);
    }

    @Override
    public void execute() {
        JSONObject pingJsonObject = new JSONObject();

        JSONArray pingUserArray = new JSONArray();
        JSONObject pingUserId = new JSONObject();
        JSONObject pingUserNickName = new JSONObject();

        pingUserId.put("userId",pingToServerRequsetVo.getUserId());
        pingUserNickName.put("nickName",pingToServerRequsetVo.getNickName());
        pingUserArray.add(pingUserId);

        JSONArray pongUserArray = new JSONArray();
        JSONObject pongUserId = new JSONObject();

        pongUserId.put("userId",pongUser);
        pongUserArray.add(pongUserId);

        pingJsonObject.put("func", "pingToClient");
        pingJsonObject.put("pingUser",pingUserArray);
        pingJsonObject.put("pongUser",pongUserArray);
        pingJsonObject.put("question",pingToServerRequsetVo.getQuestion());
        pingJsonObject.put("channelId",channelId);
        pingJsonObject.put("date",(new Date().toString()));

        try {
            webSocketSession.sendMessage(new TextMessage(pingJsonObject.toJSONString()));
        } catch (IOException e) {
            System.out.println("The user websocket is disconnected");
            e.printStackTrace();

            //to-do
            //throw DevpingException("websocket is not disconnected" ,e);
        }

        System.out.println(pingJsonObject.toJSONString());
    }


}
