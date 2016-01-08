<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <title></title>
    <%--<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/social-buttons-3.css"/>--%>
</head>
<body>
<div class="page-header">
    <h1>login</h1>
</div>
    <div class="panel panel-default">
        <div class="panel-body">
            <h2>login</h2>
            <c:if test="${param.error eq 'bad_credentials'}">
                <div class="alert alert-danger alert-dismissable">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    fail
                </div>
            </c:if>
            <form action="/authenticate" method="POST" >
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="row">
                    <div id="form-group-email" class="form-group col-lg-4">
                        <label class="control-label" for="user-email">email:</label>
                        <input id="user-email" name="username" type="text" class="form-control"/>
                    </div>
                </div>

                <div class="row">
                    <div id="form-group-password" class="form-group col-lg-4">
                        <label class="control-label" for="user-password">password:</label>
                        <input id="user-password" name="password" type="password" class="form-control"/>
                    </div>
                </div>
                <div class="row">
                    <div class="form-group col-lg-4">
                        <input type="submit" class="btn btn-default" value="submit"/>
                    </div>
                </div>
            </form>
            <div class="row">
                <div class="form-group col-lg-4">
                    <a href="/register">reg</a>
                </div>
            </div>
        </div>
    </div>
    <div class="panel panel-default">
        <div class="panel-body">
            <h2>social sign in</h2>
            <div class="row social-button-3social-button-row">
                <div class="col-lg-4">
                    <form id="facebook" action="/auth/facebook" method="POST">
                        <input type="hidden" name="scope" value="email" />
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn btn-lg btn-facebook"><i class="fa fa-facebook-plus"></i> | Sign Up with Facebook</button></a><br />
                    </form>
                </div>
            </div>
            <div class="row social-button-row">
                <div class="col-lg-4">
                    <a href="/auth/twitter"><button class="btn btn-twitter"><i class="icon-twitter"></i> | twitter</button></a>
                </div>
            </div>
            <div class="row social-button-row">
                <div class="col-lg-4">
                    <form id="google" action="/auth/google" method="POST">
                        <input type="hidden" name="scope" value="openid profile email" />
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="hidden" name="redirect_uri" value="http://devping.com:8080/auth/google"/>
                        <button type="submit" class="btn btn-lg btn-google"><i class="fa fa-google-plus"></i> | Sign Up with Google</button></a><br />
                    </form>
                    <%--<a href="/auth/google"><button class="btn btn-twitter"><i class="icon-twitter"></i> | google</button></a>--%>
                </div>
            </div>
        </div>
    </div>
<sec:authorize access="isAuthenticated()">
    <p>help</p>
</sec:authorize>
</body>
</html>