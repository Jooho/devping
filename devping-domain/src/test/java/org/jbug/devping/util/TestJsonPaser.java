package org.jbug.devping.util;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.junit.Assert;
import org.junit.Test;

import java.io.File;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;

/**
 * Created by jhouse on 10/3/14.
 */
public class TestJsonPaser {
    final String TEST_DATA_FILE = "/Users/jhouse/dev/git/devping/devping-domain/src/test/resources/channel/PING_SERVER_REQEUST.json";

    @Test
    public void testPaser() throws Exception {
        String[] expectedUserList ={"jooho","redhat"};
        int count =0;
        JSONParser parser = new JSONParser();

        Object obj = parser.parse(new FileReader(new File(TEST_DATA_FILE)));
        JSONObject jsonObject = (JSONObject) obj;

        String name = (String) jsonObject.get("userId");
        Assert.assertEquals("ljhiyh", name);

        String timeString = (String) jsonObject.get("time");
        SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date time = transFormat.parse(timeString);

        // loop array
        JSONArray userIdsWithTagList = (JSONArray) jsonObject.get("userIdsWithTag");

        Iterator<JSONObject> driveIterator = userIdsWithTagList.iterator();
        while (driveIterator.hasNext()) {
            Assert.assertEquals(expectedUserList[count++], driveIterator.next().get("userId"));
        }
    }

    @Test
    public void TestStringToObject() throws Exception{
        String stringJson= "{ \"userId\": \"ljhiyh\",\n" +
                "    \"nickName\": \"트레이닝맨\",\n" +
                "    \"question\": \"MQTT 구현하자\",\n" +
                "    \"channelId\": \"ljhiyh/chat/12345\",\n" +
                "    \"date\": \"2014-10-04 13:55:29 +0100\"\n" +
                "}";
        JSONParser parser = new JSONParser();

        Object obj = parser.parse(stringJson);
        JSONObject jsonObject = (JSONObject) obj;

        String name = (String) jsonObject.get("userId");
        Assert.assertEquals("ljhiyh", name);
    }

    public void TestCSCommandFasade() throws Exception {
        JSONParser parser = new JSONParser();
        Object obj = parser.parse(new FileReader(new File(TEST_DATA_FILE)));

        JSONObject jsonObjectFromServlet = (JSONObject) obj;

        String func = "ping";
//        String func = jsonObjectFromServlet.get("func");

        switch(func) {
            case "ping":
                //PingProcess.execute();
                //PingChannelMgmtCommand.execute();
//                channelIdWithUsers = TagCache.get(channelId);
//                if(channelIdWithUsers == null)
//                    new userList;
//                TagCache.put(channelId, userList);

                //PingRequestCoammand.execute();
                //보내는 방식 Websocket,Device

                //ReturnResponseCommand().execute ==> json형식으로 리턴 메시지 작성.
        }

    }


    @Test
    public void deleteDB() throws Exception {

        String myDriver="com.mysql.jdbc.Driver";
        String myUrl="jdbc:mysql://128.199.145.31/devping";
        Class.forName(myDriver);
        Connection conn = DriverManager.getConnection(myUrl,"devping","devping");

        java.sql.Statement stmt = null;
        String query1 = "delete from UserConnection";
        String query2 = "delete from user_accounts";
        stmt = conn.createStatement();
         stmt.execute(query1);
         stmt.execute(query2);


    }


    @Test
    public void selectDB() throws Exception {

        String myDriver="com.mysql.jdbc.Driver";
        String myUrl="jdbc:mysql://128.199.145.31/devping";
        Class.forName(myDriver);
        Connection conn = DriverManager.getConnection(myUrl,"devping","devping");

        java.sql.Statement stmt = null;
        String query1 = "select * from UserConnection";
        String query2 = "select * from user_accounts";
        stmt = conn.createStatement();
        ResultSet rs1= stmt.executeQuery(query1);
        ResultSet rs2 = stmt.executeQuery(query2);



    }

}
