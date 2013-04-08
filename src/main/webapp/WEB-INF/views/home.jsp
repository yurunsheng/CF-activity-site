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
			<div class="pull-right" style="margin-right: 10px"><small><a class="muted" href="?lang=en">&nbsp;English</a><br><a class="muted" href="?lang=zh_CN">简体中文</a></small></div>
			<div class="container-narrow">
				<a class="brand" href="<%=basePath%>">Cloud Foundry Logo</a>
				<div class="nav-collapse collapse">
					<ul class="nav nav-pills">
						<li><a href="<%=basePath%>"><fmt:message key="home"/></a></li>
						<li><a href="<%=basePath + "act/list/1?q="%>"><fmt:message key="allActs"/></a></li>
						<li>
							<form action="<%=basePath + "act/list/1"%>" method="get" class="form-search" style="margin-left: 30px">
								<div class="input-append">
									<input name="q" type="text" class="search-query" placeholder="<fmt:message key="searchbarPlaceholder"/>">
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
						data-target="#loginModal" data-remote="<%=basePath%>login"> <i
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

	<jsp:useBean id="now" class="java.util.Date"></jsp:useBean>
	<div id="myCarousel" class="carousel slide container-narrow">
		<div class="carousel-inner">
			<c:forEach var="curAct" items="${homeActs}" varStatus="p">
				<div <c:choose><c:when test="${ p.first }">class="item active"</c:when><c:otherwise>class="item"</c:otherwise></c:choose>>
					<img src="resources/img/${ curAct.id }" alt="" class="img-rounded">
					<div class="form-signin form-home">
						<div class="input-prepend">
							<span class="add-on"><i class="icon-envelope"></i></span> 
							<input rel="tooltip" onclick="javascript:$(this).tooltip('hide');" class="input-block-level text-success" id="email${p.count}" type="email"
								placeholder="<fmt:message key="join.email"/>" required>
						</div>
						<div class="input-prepend">
							<span class="add-on"><i class="icon-globe"></i></span> <input
								rel="tooltip" onclick="javascript:$(this).tooltip('hide');" 
								class="input-block-level" id="url${p.count}" type="text"
								placeholder="<fmt:message key="join.url"/>" required>
						</div>
						<input type="hidden" id="id${p.count}" value="${curAct.id}">
						<button id="joinbtn${p.count}" onclick="submit(${p.count})"
							class="btn btn-success btn-large pull-right"
							data-loading-text="<fmt:message key="processing"/>">
							<fmt:message key="join" />
						</button>
					</div>
					<div class="carousel-caption">
						<h4>
							<a style="color: white"
								href="<%=basePath %>act/detail/${curAct.id}">${ curAct.title }</a>
						</h4>
						<h5 class="muted">
							<span class="badge badge-important"><i
								class="icon-star-empty icon-white"></i></span>
							<c:choose>
								<c:when test="${ fn:length(curAct.content)>120 }">${ fn:substring(curAct.content,0,117) }...</c:when>
								<c:otherwise>${ curAct.content }</c:otherwise>
							</c:choose>
							<br>
							<span class="badge badge-info"><i
								class="icon-map-marker icon-white"></i></span>${ curAct.location } <br>
							<span class="badge badge-success"><i
								class="icon-time icon-white"></i></span>
							<fmt:formatDate value="${curAct.startTime}"
								pattern="(zzzz) HH:mm yyyy-MM-dd" />
							~
							<fmt:formatDate value="${ curAct.endTime }"
								pattern="(zzzz) HH:mm yyyy-MM-dd" />
						</h5>
					</div>
				</div>
			</c:forEach>
		</div>
		<c:if test="${fn:length(homeActs)>1}">
			<a class="left carousel-control" href="#myCarousel" data-slide="prev">&lsaquo;</a>
			<a class="right carousel-control" href="#myCarousel" data-slide="next">&rsaquo;</a>
		</c:if>
	</div>
	<div id="alertModal" class="modal hide fade">
		<div class="alert fade in">
			<button type="button" class="close" data-dismiss="modal">&times;</button>
			<h4 id="alertContent"></h4>
		</div>
	</div>
</body>
<script>
	$(document).ready(function(){
		for(var a=1;a<=${fn:length(homeActs)};a++){
			$('#email'+a).tooltip({
				title: '<h5>&nbsp;<fmt:message key="join.emailInvalid"/>&nbsp;</h5>',
				trigger: 'manual',
				html: 'true',
				placement: 'bottom'
			});
			$('#url'+a).tooltip({
				title: '<h5>&nbsp;<fmt:message key="join.urlInvalid"/>&nbsp;</h5>',
				trigger: 'manual',
				html: 'true',
				placement: 'bottom'
			});
		}
	})
	function submit(i) {
		var id = $("#id"+i).val();
		var eml = document.getElementById("email"+i);
		if(!eml.checkValidity()){
			$('#email' + i).focus();
			$('#email'+i).tooltip('show');
			return;
		}
		var reg = /\.cloudfoundry\.com\/?($|[^\/])/;
		if (!reg.test($("#url" + i).val())) {
			$("#url" + i).focus();
			$('#url'+i).tooltip('show');
			return;
		}

		$("#joinbtn" + i).button('loading');
		$.ajax({
			url : "act/"+id+"/participate.do",
			type : "POST",
			data : '{"email":"' + $("#email" + i).val() + '","url":"'
					+ $("#url" + i).val() + '"}',
			processData : false,
			dataType : "json",
			contentType : "application/json; charset=utf-8",
			success : function(data) {
				if(data.msg=="urlInvalid")
					$("#alertContent").text('<fmt:message key="join.urlInvalid"/>');
				else if(data.msg=="success")
					$("#alertContent").text('<fmt:message key="join.success"/>');
				else if(data.msg=="repeat")
					$("#alertContent").text('<fmt:message key="join.repeat"/>');
				else if(data.msg=="full")
					$("#alertContent").text('<fmt:message key="join.full"/>');
				$("#alertModal").modal('show');
				$("#joinbtn" + i).button('reset');
			},
			error : function() {
				$("#alertContent").text('<fmt:message key="join.error"/>');
				$("#alertModal").modal('show');
				$("#joinbtn").button('reset');
			}
		});
	};
</script>
</html>