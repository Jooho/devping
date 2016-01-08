//devPingApp.controller('customerList', ['MyService', function(MyService){
//	$scope.customers = MyService.getCustomers();
//}]);

devPingApp.controller('PingPongController', function($scope, $interval, pingPongService){
	init();
	function init(){
//get user info - require login part
		$scope.user = {
			id: 'guest',
			pong: 0
		};
		$scope.myRoomList = [];
		$scope.chatList = {};
		$scope.userList = {};
		$scope.channelId;
		$scope.pongCount = 0;
		$scope.chatInputChecked = false;
		$scope.tagListChecked = false;

	};
	$scope.traceTagName = function() {
		$scope.tagListChecked = false;
		var tagArray = $scope.pingTags.split(',');
		var tag = tagArray[tagArray.length-1].replace(/(^\s*)|(\s*$)/g, "");
		if(tag != null && tag != ''){
			pingPongService.selectTags({
				func: "tag_prefix",
				prefix: tag
			}).then(
				function(payload) {
					$scope.tagList = payload.tagList;
				},
				function(errorPayload) {
					console.log(errorPayload);
				});
		}
		$scope.tagListChecked = ( $scope.tagList != 0 ); 
	};
	
	$scope.clickTag = function(tag) {
		$scope.tagListChecked = false;
		var tagArray = $scope.pingTags.split(',');
		tagArray[tagArray.length-1] = tag;
		$scope.pingTags = tagArray.join(',');
	};
	
	$scope.searchUser = function() {
		var tagArray = $scope.pingTags.split(',');
		for(var i=0, j=tagArray.length; i<j; i++){
			tagArray[i] = tagArray[i].replace(/(^\s*)|(\s*$)/g, "");
		}
		pingPongService.searchUser({
			func: "tag_people_with_tags",
			tagList: tagArray
		}).then(
			function(payload) {
				$scope.userIdsWithTag = payload.userIdsWithTag;
				$scope.totalMembers = payload.totalMembers;
			},
			function(errorPayload) {
				console.log(errorPayload);
			});
	};
	
	$scope.ping = function() {
//set user info
		console.log({
			func: "ping_to_server",
			userIdsWithTag: $scope.userIdsWithTag,
			userId: 'ljhiyh',
			nickName: 'ljhiyh',
			question: $scope.pingQuestion
		});
		
		pingPongService.ping({
			func: "ping_to_server",
			userIdsWithTag: $scope.userIdsWithTag,
			userId: $scope.userId,
			nickName: 'ljhiyh',
			question: $scope.pingQuestion
		}).then(
			function(payload) {
				//create room
				$scope.channelId = payload.channelId;
				$scope.chatList[payload.channelId] = [];
				$scope.userList[payload.channelId] = $scope.userIdsWithTag;
				var dt = new Date();
				var room = {
					channelId: payload.channelId,
					time: dt.getFullYear() + '-' + (dt.getMonth()+1) + '-' + dt.getDate()
						+ ' ' + dt.getHours() + ':' + dt.getMinutes() + ':' + dt.getSeconds(),
					tagList: $scope.pingTags,
					pingCountdown : 30
				};
				room.intervalPingCountdown = $interval(function(){
					room.pingCountdown--;
//if someone connect this room, stop countdown.
					if(room.pingCountdown == 0)
						$scope.removeDevpinRoom(room.channelId);
				}, 1000, 30);
				//make room
				$scope.myRoomList.push(room);
			},
			function(errorPayload) {
				console.log(errorPayload);
			});
		//visible input box
		$scope.chatInputChecked = true;
	};
	
	$scope.changeRoom = function(channelId){
		$scope.channelId = channelId;
	};
	
	$scope.sendMessage = function(){
		//create message
		//send message
		//input message to chat frame
//		$scope.chatList[$scope.channelId].push(message);
	};
	
	$scope.pong = function(){
		pingPongService.pong($scope.user.id);
	};
	
	$scope.removeDevpinRoom = function(channelId){
		for(var i=0,j=$scope.myRoomList.length;i<j;i++){
			var room =  $scope.myRoomList[i];
			if(room.channelId == channelId){
				$interval.cancel(room.intervalPingCountdown);
				$scope.myRoomList.splice(i, 1);
				break;
			}
		}
		delete $scope.chatList[channelId];
		delete $scope.userList[channelId];
		if($scope.channelId == channelId){
			$scope.channelId = undefined;
			$scope.chatInputChecked = false;
		}
	};


});
