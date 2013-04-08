<%@ page language="java"
	import="cloudfoundry.activity.domain.User"
	contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html >
<html>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="<%=basePath%>resources/css/bootstrap.css" rel="stylesheet">
<link href="<%=basePath%>resources/css/bootstrap-responsive.css"
	rel="stylesheet">
<link href="<%=basePath%>resources/css/customized.css" rel="stylesheet">

<script type="text/javascript" src="<%=basePath%>resources/js/jquery.js"></script>
<script src="<%=basePath%>resources/js/bootstrap.js"></script>
<title>Cloud Foundry Activity</title>
</head>
<%
	User user = (User) request.getSession().getAttribute("user");
%>
<body>
	<div class="navbar navbar-inverse navbar-fixed-top">
		<div class="navbar-inner">
			<a class="btn btn-navbar" data-toggle="collapse"
				data-target=".nav-collapse"> <span class="icon-bar"></span> <span
				class="icon-bar"></span> <span class="icon-bar"></span>
			</a>
			<div class="container-narrow">
				<a class="brand" href="<%=basePath%>">Cloud Foundry活动Logo</a>
				<div class="nav-collapse collapse">
					<ul class="nav nav-pills">
						<li><a href="<%=basePath%>"><fmt:message key="home"/></a></li>
						<li><a href="<%=basePath + "act/list/1"%>"><fmt:message key="allActs"/></a></li>
						<li>
							<form class="form-search" style="margin-left: 30px">
								<div class="input-append">
									<input type="text" class="search-query" placeholder="<fmt:message key="searchbarPlaceholder"/>">
									<button type="submit" class="btn">
										<i class="icon-search"></i>
									</button>
								</div>
							</form>
						</li>
					</ul>
					<%
						if (user != null) {
					%>
					<div class="btn-group pull-right">
						<a class="btn btn-success"
							href="<%=basePath + "user/" + user.getId() + "?pos=mine"%>">
							<i class="icon-user icon-white"></i> <%=user.getName()%>
						</a>
						<button class="btn btn-success dropdown-toggle"
							data-toggle="dropdown">
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu">
							<li><a
								href="<%=basePath + "user/" + user.getId() + "?pos=mine"%>"><i
									class="icon-tags"></i> <fmt:message key="act.myActs"/></a></li>
							<li class="divider"></li>
							<li><a
								href="<%=basePath + "user/" + user.getId() + "?pos=create"%>"><i
									class="icon-edit"></i> <fmt:message key="act.create"/></a></li>
							<li class="divider"></li>
							<li><a
								href="<%=basePath + "user/" + user.getId() + "?pos=profile"%>"><i
									class="icon-wrench"></i> <fmt:message key="profile"/></a></li>
							<li class="divider"></li>
							<li><a
								href="<%=basePath + "logout?user=" + user.getName()%>"><i
									class="icon-off"></i> <fmt:message key="signOut"/></a></li>
						</ul>
					</div>
					<%
						} else {
					%>
					<a class="btn pull-right" data-toggle="modal"
						data-target="#loginModal" data-remote="login"> <i
						class="icon-user"></i> <fmt:message key="signIn"/>
					</a>
					<%
						}
					%>
				</div>
			</div>
		</div>
	</div>

	<%
		if (user == null) { //The modal div must not be inside the navbar div
	%>
	<div id="loginModal" class="modal signin-modal hide fade" tabindex="-1">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal">×</button>
			<h3 class="form-signin-heading text-warning"><fmt:message key="signin.title"/></h3>
		</div>
		<div class="modal-body"></div>
	</div>
	<%
		}
	%>

	<h1>警告：禁止越权操作！</h1>
</body>
</html>