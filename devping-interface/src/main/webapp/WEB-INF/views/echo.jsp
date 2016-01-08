
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.jbug.devping.domain.UserVo" %>
<html>
<head>
    <title>WebSocket/SockJS Echo Sample (Adapted from Tomcat's echo sample)</title>
    <style type="text/css">
        #connect-container {
            float: left;
            width: 400px
        }

        #connect-container div {
            padding: 5px;
        }

        #console-container {
            float: left;
            margin-left: 15px;
            width: 400px;
        }

        #console {
            border: 1px solid #CCCCCC;
            border-right-color: #999999;
            border-bottom-color: #999999;
            height: 170px;
            overflow-y: scroll;
            padding: 5px;
            width: 100%;
        }

        #console p {
            padding: 0;
            margin: 0;
        }

        #unit-test-container {
            float: left;
            margin-left: 15px;
            width: 400px;
        }
    </style>

    <script src="http://cdn.sockjs.org/sockjs-0.3.min.js"></script>
    <script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>

    <script type="text/javascript">
        var ws = null;
        var url = null;
        var transports = [];

        function setConnected(connected) {
            document.getElementById('connect').disabled = connected;
            document.getElementById('disconnect').disabled = !connected;
            document.getElementById('echo').disabled = !connected;
        }

        function connect() {
            if (!url) {
                alert('Select whether to use W3C WebSocket or SockJS');
                return;
            }

            ws = (url.indexOf('socketjs') != -1) ? 
                new SockJS(url, undefined, {protocols_whitelist: transports}) : new WebSocket(url);

            ws.onopen = function () {
                setConnected(true);
                log('Info: connection opened.');
            };
            ws.onmessage = function (event) {
                log('Received: ' + event.data);
            };
            ws.onclose = function (event) {
                setConnected(false);
                log('Info: connection closed.');
                log(event);
            };
        }

        function disconnect() {
            if (ws != null) {
                ws.close();
                ws = null;
            }
            setConnected(false);
        }

        function echo() {
            if (ws != null) {
                var message = document.getElementById('message').value;
                log('Sent: ' + message);
                ws.send(message);
            } else {
                alert('connection not established, please connect.');
            }
        }

        function updateUrl(urlPath) {
            if (urlPath.indexOf('socketjs') != -1) {
                url = urlPath;
                document.getElementById('sockJsTransportSelect').style.visibility = 'visible';
            }
            else {
              if (window.location.protocol == 'http:') {
                  url = 'ws://' + window.location.host + urlPath;
              } else {
                  url = 'wss://' + window.location.host + urlPath;
              }
              document.getElementById('sockJsTransportSelect').style.visibility = 'hidden';
            }
        }

        function updateTransport(transport) {
          transports = (transport == 'all') ?  [] : [transport];
        }
        
        function log(message) {
            var console = document.getElementById('console');
            var p = document.createElement('p');
            p.style.wordWrap = 'break-word';
            p.appendChild(document.createTextNode(message));
            console.appendChild(p);
            while (console.childNodes.length > 25) {
                console.removeChild(console.firstChild);
            }
            console.scrollTop = console.scrollHeight;
        }
        function clear() {
            $('#message').html('');
        }


///////Test ajax

        function ajaxTest() {
            jQuery.ajax({
                type:"POST",
                url:"../cs/tagPrefix",
                data : JSON.stringify(tagPrefixData),
                dataType:"JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
                success : function(data) {
                    // 통신이 성공적으로 이루어졌을 때 이 함수를 타게 된다.
                    // TODO
                    alert("success")
                },
                complete : function(data) {
                    // 통신이 실패했어도 완료가 되었을 때 이 함수를 타게 된다.
                    // TODO
                    alert("Complete")
                },
                error : function(xhr, status, error) {
                    alert("에러발생");
                }
            });
        }
        //    function createJSON() {
        //        jsonObj = [];
        //
        //        userIdsWithTag=[];
        //
        //        user1 = {};
        //        user1["userId"] = "jooho";
        //        user1["nickName"] = "Client1";
        //
        //        user2 = {};
        //        user2["userId"] = "redhat";
        //        user2["nickName"] = "Client2";
        //
        //        userIdsWithTag.push(user1);
        //        userIdsWithTag.push(user2);
        //
        //        jsonObj.push(userIdsWithTag);
        //
        //        jsonObj.put("userId",$("#PingRequestId").val());
        //        jsonObj.put("nickName","트레이닝맨");
        //        jsonObj.put("question" , "MQTT 구현하자");
        //        jsonObj.put("channelId","ljhiyh/chat/12345");
        //        jsonObj.put( "time" , "2014-10-04 13:55:29 +0100");
        //
        //        jsonString = JSON.stringify(jsonObj);
        //
        //
        //        console.log(jsonString);
        //    }

        var pingData= {
            "userIdsWithTag" : [
                { "userId" : "jooho" , "nickName" : "Client1"},
                { "userId" : "redhat" , "nickName" : "Client2"}
            ],
            "userId" : "ljhiyh",
            "nickName" : "트레이닝맨",
            "question" : "MQTT 구현하자",
            "channelId" : "ljhiyh/chat/12345",
            "time" : "2014-10-04 13:55:29 +0100"
        };

        var tagPrefixData =    {
            "prefix" : "ja"
        };

    </script>
</head>
<body>
<div>
    <div id="connect-container">
        <input id="radio1" type="radio" name="group1" onclick="updateUrl('/echo');">
            <label for="radio1">W3C WebSocket</label>
        <br>
        <input id="radio2" type="radio" name="group1" onclick="updateUrl('/socketjs/echo');">
            <label for="radio2">SockJS</label>
        <div id="sockJsTransportSelect" style="visibility:hidden;">
            <span>SockJS transport:</span>
            <select onchange="updateTransport(this.value)">
              <option value="all">all</option>
              <option value="websocket">websocket</option>
              <option value="xhr-polling">xhr-polling</option>
              <option value="jsonp-polling">jsonp-polling</option>
              <option value="xhr-streaming">xhr-streaming</option>
              <option value="iframe-eventsource">iframe-eventsource</option>
              <option value="iframe-htmlfile">iframe-htmlfile</option>
            </select>
        </div>
        <div>
            <button id="connect" onclick="connect();">Connect</button>
            <button id="disconnect" disabled="disabled" onclick="disconnect();">Disconnect</button>
        </div>
        <div>
            <textarea id="message" style="width: 350px">Here is a message!</textarea>
        </div>
        <div>
            <button id="echo" onclick="echo();" disabled="disabled">Echo message</button>
        </div>
    </div>
    <div id="console-container">
        <div id="console"></div>
    </div>

    <div id="unit-test-container">
    <c:if test="${sessionScope.userVo != null}">${sessionScope.userVo.userId} is logined. </c:if>

    <form method="post" action="./login">
         <input type="submit" value="login"/>
    </form>

    <h3>Ping 요청</h3>
        PingRequester : <input type="text" value="pingRequester"/> </br>
        Ping을 받을 사람 : <input type="text" value="pingReceiver/>

    <table>
        <tr>
            <td colspan="2">
                <input type="button" value="Ping" onclick="javascript:ajaxTest();"/>
            </td>
        </tr>
    </table>
    </div>
</div>
</body>
</html>
