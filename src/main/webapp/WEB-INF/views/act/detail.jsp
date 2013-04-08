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
<link href="<%=basePath%>resources/css/bootstrap.css" rel="stylesheet">
<link href="<%=basePath%>resources/css/bootstrap-responsive.css"
	rel="stylesheet">
<link href="<%=basePath%>resources/css/customized.css" rel="stylesheet">
<style>
html,body {
	height: 100%;
}
.wysiwyg-color-black {
  color: black;
}

.wysiwyg-color-silver {
  color: silver;
}

.wysiwyg-color-gray {
  color: gray;
}

.wysiwyg-color-white {
  color: white;
}

.wysiwyg-color-maroon {
  color: maroon;
}

.wysiwyg-color-red {
  color: red;
}

.wysiwyg-color-purple {
  color: purple;
}

.wysiwyg-color-fuchsia {
  color: fuchsia;
}

.wysiwyg-color-green {
  color: green;
}

.wysiwyg-color-lime {
  color: lime;
}

.wysiwyg-color-olive {
  color: olive;
}

.wysiwyg-color-yellow {
  color: yellow;
}

.wysiwyg-color-navy {
  color: navy;
}

.wysiwyg-color-blue {
  color: blue;
}

.wysiwyg-color-teal {
  color: teal;
}

.wysiwyg-color-aqua {
  color: aqua;
}
</style>
<script type="text/javascript" src="<%=basePath%>resources/js/jquery.js"></script>
<script src="<%=basePath%>resources/js/bootstrap.js"></script>
<title>${ act.title }</title>
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

	<div id="alertModal" class="modal hide fade">
		<div class="alert fade in">
			<button type="button" class="close" data-dismiss="modal">&times;</button>
			<h4>&nbsp;</h4>
			<h4 id="alertContent" align="center"></h4>
			<h4>&nbsp;</h4>
		</div>
	</div>

	<div class="container-narrow">
		<h2 class="text-warning">${ act.title }</h2>
		<br>
		<div class="container-fluid">
			<div class="row-fluid">
				<h5 class="text-info span8">
					<span class="badge badge-warning"><i
						class="icon-map-marker icon-white"></i></span>${act.location} <br> <span
						class="badge badge-warning"><i class="icon-time icon-white"></i></span>
					<fmt:formatDate value="${act.startTime}"
						pattern="yyyy-M-d (EE) h:mma " />
					——
					<fmt:formatDate value="${act.endTime}"
						pattern="yyyy-M-d (EE) h:mma " />
					<br> <span class="badge badge-warning"><i
						class="icon-user icon-white"></i></span><fmt:message key="detail.capacity"/>:&nbsp;${act.capacity}&nbsp;<b
						class="muted">(&nbsp;<b id="total">${act.total}</b>&nbsp;<fmt:message key="detail.attended"/>)
					</b>
				</h5>
				<jsp:useBean id="now" class="java.util.Date"></jsp:useBean>
				<div class="span3 navbar navbar-static">
					<div class="dropdown" align="right">
						<br>
						<c:if test="${act.endTime lt now }">
							<button class="dropdown-toggle btn btn-large btn-success"
								data-toggle="dropdown" disabled>
								<i class="icon-ok icon-white"></i>&nbsp;<fmt:message key="detail.finished"/>
							</button>
						</c:if>
						<%-- <c:if test="${act.endTime ge now and act.startTime le now}">
							<button class="dropdown-toggle btn btn-large btn-info"
								data-toggle="dropdown" disabled>
								<fmt:message key="detail.ongoing"/>&nbsp;...</button>
						</c:if> --%>
						<c:if test="${act.endTime ge now }">
							<a class="dropdown-toggle btn btn-large btn-success"
								data-toggle="dropdown"><i class="icon-plus icon-white"></i>&nbsp;<fmt:message key="detail.join"/></a>
							<form id="partForm" class="navbar-form dropdown-menu pull-right"
								style="padding: 0">
								<div class="input-prepend" style="margin: 0">
									<span class="add-on"><i class="icon-envelope"></i></span> <input
										class="input-xlarge" id="email" name="email" type="email"
										placeholder="<fmt:message key="join.email"/>" required>
								</div>
								<div class="input-prepend" style="margin: 0">
									<span class="add-on"><i class="icon-globe"></i></span> <input
										class="input-xlarge" id="url" name="url" type="text"
										placeholder="<fmt:message key="join.url"/>" required>
								</div>
								<button id="joinbtn" type="submit" style="margin: 0"
									class="btn btn-block" data-loading-text="...">
									<i class="icon-ok"></i>
								</button>
							</form>
						</c:if>
					</div>

				</div>
			</div>
		</div>
		<br>
		<h4 class="text-info">
			<span class="badge badge-success"><i
				class="icon-star icon-white"></i></span><fmt:message key="detail.desc"/>：<br>
		</h4>
		<div class="well" style="padding-top:0px">
			<div style="font-size: 20px; line-height: 30px; padding: 15px">
				<p class="muted">${act.content}</p>
			</div>
			<div align="center">
				<img src="<%=basePath %>resources/img/${ act.id }" alt=""
					class="img-rounded">
			</div>
		</div>
	</div>
	<script>
		$("#partForm").submit(
				function() {
					var reg = /\.cloudfoundry\.com\/?($|[^\/])/;
					if (!reg.test($("#url").val())) {
						$("#url").val('<fmt:message key="join.urlInvalid"/>');
						$("#url").focus();
						return false;
					}
					
					$("#joinbtn").button('loading');
					$.ajax({
						url : "../${act.id}/participate.do",
						type : "POST",
						data : '{"email":"' + $("#email").val() + '","url":"'
								+ $("#url").val() + '"}',
						processData : false,
						dataType : "json",
						contentType : "application/json; charset=utf-8",
						success : function(data) {
							if(data.msg=="urlInvalid")
								$("#alertContent").text('<fmt:message key="join.urlInvalid"/>');
							else if(data.msg=="success"){
								$("#total").text(data.total);
								$("#alertContent").text('<fmt:message key="join.success"/>');
							}
							else if(data.msg=="repeat")
								$("#alertContent").text('<fmt:message key="join.repeat"/>');
							else if(data.msg=="full")
								$("#alertContent").text('<fmt:message key="join.full"/>');
							$("#alertModal").modal('show');
							$("#joinbtn").button('reset');
						},
						error : function() {
							$("#alertContent").text('<fmt:message key="join.error"/>');
							$("#alertModal").modal('show');
							$("#joinbtn").button('reset');
						}
					});
					return false;
				});
	</script>
</body>
</html>