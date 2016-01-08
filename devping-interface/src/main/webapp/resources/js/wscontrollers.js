devPingApp.controller('WebsocketController', function($scope){

    $scope.init= function(){
       $scope.connect();
    };

    $scope.connect = function(){
        var ws = null;
        var url = 'ws://' + window.location.host + "/devpingWS";

       ws = (url.indexOf('socketjs') != -1) ?
            new SockJS(url, undefined, {protocols_whitelist: transports}) : new WebSocket(url);

        ws.onopen = function () {
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
    };

    $scope.disconnect = function() {
        if (ws != null) {
            ws.close();
            ws = null;
        }
        setConnected(false);
    };

    $scope.echo = function() {
        if (ws != null) {
            var message = document.getElementById('message').value;
            log('Sent: ' + message);
            ws.send(message);
        } else {
            alert('connection not established, please connect.');
        }
    };

    function log(message) {
        console.log(message);
    }

});

