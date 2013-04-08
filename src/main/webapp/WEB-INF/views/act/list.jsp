<%@ page language="java"
	import="cloudfoundry.activity.domain.User"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
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
</style>
<script type="text/javascript" src="<%=basePath%>resources/js/jquery.js"></script>
<script src="<%=basePath%>resources/js/bootstrap.min.js"></script>

<title>Cloud Foundry</title>
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

	<div class="container-narrow">
		<c:forEach var="curAct" items="${ curPage.content }">
			<div class='row'>
				<div class="well-small">
					<div class='row-fluid'>
						<div class="span4">
							<div class='thumbnail' style="width: 280px; height: 200px">
								<img src="<%=basePath %>resources/img/${ curAct.id }"
									alt='${ curAct.title }' style="width: 280px; height: 200px"/>
							</div>
						</div>
						<div class="span8">
							<h3>
								<strong><a href="<%=basePath%>act/detail/${curAct.id}">${
									curAct.title }</a></strong>
							</h3>
							<p class="muted" style="height:80px;overflow:hidden">
								${curAct.content}
							</p>
							<h6 class="text-info">
								<strong><span class="badge badge-warning"><i
										class="icon-map-marker icon-white"></i></span>${ curAct.location }</strong>
							<br>
								<strong><span class="badge badge-warning"><i
										class="icon-time icon-white"></i></span>
								<fmt:formatDate value="${curAct.startTime}"
									pattern="yyyy-M-d (EE) h:mma" /></strong>
							</h6>
						</div>
					</div>
				</div>
			</div>
		</c:forEach>
		<div class="pagination" align="right">
			<ul>
				<li><span class="text-warning"> <fmt:message key="page">
							<fmt:param value="${curPage.number*curPage.size+1}"></fmt:param>
							<fmt:param
								value="${curPage.number*curPage.size+curPage.numberOfElements}"></fmt:param>
							<fmt:param value="${curPage.totalElements}"></fmt:param>
						</fmt:message></span></li>
			</ul>
			&nbsp;&nbsp;&nbsp;
			<ul>
				<c:if test="${curPage.number==0}"><li class="disabled"><span>«</span></li></c:if>
				<c:if test="${curPage.number!=0}"><li><a href="1?q=${q}">«</a></li></c:if>
				<c:forEach var="i" begin="1" end="${ curPage.totalPages }">
					<c:if test="${curPage.number==i-1}"><li class="active"><span>${i}</span></li></c:if>
					<c:if test="${curPage.number!=i-1}"><li><a href="${i}?q=${q}">${i}</a></li></c:if>
				</c:forEach>
				<c:if test="${curPage.number==curPage.totalPages-1}"><li class="disabled"><span>»</span></li></c:if>
				<c:if test="${curPage.number!=curPage.totalPages-1}"><li><a href="${curPage.totalPages}?q=${q}">»</a></li></c:if>
			</ul>
		</div>
	</div>
	
	<!-- <div id="footer">
		<div class="container">
			<div class='row container-narrow' style="padding-top:20px">
				<div class='prepend-1 span-6'>
					<p>
						<a href='http://cndocs.cloudfoundry.com/faq.html' target='_blank'>问题</a>
						| <a href='http://forum.csdn.net/slist/cloudfoundry'
							target='_blank'>论坛</a> | <a
							href='http://cnblog.cloudfoundry.com/' target='_blank'>博客</a> | <a
							href='http://www.cloudfoundry.com/jobs' target='_blank'>工作</a> |
						<a href='http://www.cloudfoundry.com/legal' target='_blank'>法律</a>
						| <a href='http://www.cloudfoundry.com/terms' target='_blank'>条款</a>
						| <a href='http://www.vmware.com/help/privacy.html'
							target='_blank'>隐私</a>
					</p>
				</div>
				<div class='span-5 pull-right'>
					<p>
						Copyright &copy;
						<script type='text/javascript'>
							//         
							var d = new Date();
							document.write(d.getFullYear());
							//
						</script>
						VMware, Inc. All rights reserved.
					</p>
				</div>
			</div>
		</div>
	</div> -->

</body>
</html>