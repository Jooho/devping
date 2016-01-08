<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page session="false" %>
<!DOCTYPE HTML>
<html lang="ko" data-ng-app="devPingApp">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>DevPing</title>
	<link href="<c:url value="/resources/css/bootstrap.min.css"/>" rel="stylesheet" media="screen"/>
	<link href="<c:url value="/resources/css/styles.css"/>" rel="stylesheet" />
	<!--[if lt IE 9]>
	<script src="/resources/lib/respond.min.js"></script>
	<![endif]-->
	<style>[touch-action="none"]{ -ms-touch-action: none; touch-action: none; }[touch-action="pan-x"]{ -ms-touch-action: pan-x; touch-action: pan-x; }[touch-action="pan-y"]{ -ms-touch-action: pan-y; touch-action: pan-y; }[touch-action="scroll"],[touch-action="pan-x pan-y"],[touch-action="pan-y pan-x"]{ -ms-touch-action: pan-x pan-y; touch-action: pan-x pan-y; }</style>
</head>
<body>
	<header class="navbar navbar-inverse navbar-fixed-top bs-docs-nav" data-role="banner">
		<div class="container">
			<div class="navbar-header">
				<button class="navbar-toggle" type="button" data-toggle="collapse" data-target=".bs-navbar-collapse">
					<span class="sr-only">Toggle navigation</span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<a href="main" class="logo">DevPing</a>
                <form action="/logout" method="post">
                    <input type="submit" value="Log out" />
                </form>
			</div>
		</div>
	</header>
    <!-- Websocket Connection Controller-->
    <div data-ng-controller="WebsocketController" ng-init="init()" ></div>

	<!-- Callout for the old docs link -->
	<div class="container"
		data-ng-controller="PingPongController">
     <div ng-init="userId = '${userId}';"></div>
            angular  =  {{userId}}
		<div class="row jb-c-content">
			<aside class="col-md-2 jb-c-content">
				<div class="jb-c-box" style="height: 100px;">
					<button data-toggle="modal" data-target="#pingModal">
						<span>PING</span>
					</button>
					<div>
						<button data-toggle="modal" data-target="#pongModal">
							<span>PONG</span>
							<span>{{ pongCount }}</span>
						</button>
					</div>
				</div>
				<div class="jb-c-box" style="height: 100%;width: 100%;margin-top: -100px;padding-top: 105px;">
					<div class="jb-c-content jb-c-rbox">
						<ul>
							<li class="jb-c-roomlist"
								data-ng-repeat="room in myRoomList | orderBy:'time':reverse=true"
								data-ng-class="{'active': room.channelId == channelId}">
								<div data-ng-click="changeRoom(room.channelId)">
									<span class="badge jb-c-bg-important pull-left">{{ room.pingCountdown }}</span>
									<span class="jb-c-roomname">{{ room.tagList }}</span>
									<button type="button" class="close pull-right"
										data-ng-click="removeDevpinRoom(room.channelId)">×</button>
								</div>
							</li>
						</ul>
					</div>
				</div>
			</aside>
			<div class="col-md-10 jb-c-content" data-role="main">
				<div class="row jb-c-content">
					<section class="col-md-10 jb-c-content jb-c-box">
						<div class="jb-c-content jb-c-rbox" style="margin-bottom: -45px;padding-bottom: 50px;">
							<ul>
								<li data-ng-repeat="chat in chatList[channelId] | orderBy:'time'">
									<div class="first-part odd">{{ chat.user }}</div>
									<div class="second-part">{{ chat.content }}</div>
									<div class="third-part">{{ chat.time }}</div>
								</li>
							</ul>
						</div>
						<footer style="height: 45px;padding: 5px 5px 0 5px;">
							<div class="input-group"
								data-ng-show="chatInputChecked">
								<input type="text" class="form-control" autofocus="autofocus"
									data-ng-model="myMessage">
								<span class="input-group-btn">
									<button class="btn btn-danger" type="button"
										data-ng-click="sendMessage()">Send</button>
								</span>
							</div>
						</footer>
					</section>
					<aside class="col-md-2 jb-c-content jb-c-box">
						<div class="jb-c-content jb-c-rbox">
							<ul>
								<li data-ng-repeat="user in userList[channelId]">
									{{ user }}
								</li>
							</ul>
						</div>
					</aside>
				</div>
			</div>
		</div>
		<!-- Modal -->
		<div class="modal fade" id="pingModal" tabindex="-1" data-role="dialog"
			data-aria-labelledby="pingModalLabel" data-aria-hidden="true" data-backdrop="static">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span data-aria-hidden="true">&times;</span><span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title" id="pingModalLabel">Ping</h4>
					</div>
					<div class="modal-body">
						<div>
							<label for="tag-group">tag</label>
						</div>
						<div class="jb-c-tag-input">
							<div class="row">
								<div class="col-lg-10">
									<input class="form-control input-lg" id="tag-group" type="text" placeholder="C, C++, java..."
										data-ng-model="pingTags"
										data-ng-change="traceTagName()">
									<div class="jb-c-tag-list"
										data-ng-show="tagListChecked">
										<ul>
											<li data-ng-repeat="tag in tagList">
												<span data-ng-click="clickTag(tag)">{{ tag }}</span>
											</li>
										</ul>
									</div>
								</div>
								<div class="col-lg-2">
									<button type="button" class="btn btn-lg btn-primary pull-right"
										data-ng-click="searchUser()">선택</button>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-lg-3">
								<ul class="jb-c-tag-user-list">
									<li data-ng-repeat="user in userIdsWithTag">
										<div class="input-group">
											<span class="input-group-addon">
												<input type="checkbox">
											</span>
											<div class="form-control">
												{{ user }}
											</div>
										</div>
									</li>
								</ul>
							</div>
							<div class="col-lg-9">
								<textarea class="form-control" rows="10"
									data-ng-model="pingQuestion"></textarea>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						<button type="button" class="btn btn-primary" data-dismiss="modal"
							data-ng-click="ping($event)">Ping</button>
					</div>
				</div>
			</div>
		</div>
		<div class="modal fade" id="pongModal" tabindex="-1" data-role="dialog"
			data-aria-labelledby="pongModalLabel" data-aria-hidden="true" data-backdrop="static">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span data-aria-hidden="true">&times;</span><span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title" id="pongModalLabel">Pong</h4>
					</div>
					<div class="modal-body">
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						<button type="button" class="btn btn-primary">Pong</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Vendor Libs: jQuery only used for Bootstrap functionality -->
	<script src="<c:url value="/resources/lib/angular.min.js"/>"></script>
	<script src="<c:url value="/resources/lib/angular-route.min.js"/>"></script>
	<script src="<c:url value="/resources/lib/jquery.min.js"/>"></script>
	<!-- UI Libs -->
	<script src="<c:url value="/resources/lib/bootstrap.min.js"/>"></script>
	<!-- App libs -->
	<script src="<c:url value="/resources/js/app.js"/>"></script>
	<script src="<c:url value="/resources/js/controllers.js"/>"></script>
    <script src="<c:url value="/resources/js/wscontrollers.js"/>"></script>
	<script src="<c:url value="/resources/js/services.js"/>"></script>
</body>
</html>
