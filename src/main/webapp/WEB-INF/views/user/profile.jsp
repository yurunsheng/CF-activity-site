<%@ page language="java"
	import="cloudfoundry.activity.domain.User,org.springframework.web.servlet.support.RequestContextUtils;"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../resources/css/bootstrap.css" rel="stylesheet">
<link href="../resources/css/bootstrap-responsive.css" rel="stylesheet">
<link href="../resources/css/bootstrap-datetimepicker.min.css"
	type="text/css" rel="stylesheet">
<link href="../resources/css/customized.css" rel="stylesheet">
<link rel="stylesheet" href="../resources/css/stylesheet.css">
<script type="text/javascript" src="../resources/js/jquery.js"></script>
<script src="../resources/js/bootstrap.js"></script>
<script src="../resources/js/bootstrap-datetimepicker.min.js"
	type="text/javascript"></script>
<script src="../resources/js/locales/bootstrap-datetimepicker.zh_CN.js"
	type="text/javascript" charset="UTF-8"></script>
<script src="../resources/js/advanced.js"></script>
<script src="../resources/js/wysihtml5-0.3.0.min.js"></script>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	User user = (User) request.getSession().getAttribute("user");
%>
<script type="text/javascript">
			var flag;
			function rmv(rmvid){
				flag=rmvid;
				document.getElementById("alertText").innerHTML="<fmt:message key='rmvActAlert'/>";
				document.getElementById("doRmvBtn").setAttribute("onclick","javascript:doRmv()");
			};
			function doRmv(){
				window.location.href='<%=basePath + "act/remove.do?id="%>'+flag;
			};
			function report(title,total){
				$("#reportHeader").text(title);
				$("#reportSummary").html('<fmt:message key="act.nofinished"><fmt:param value="'+total+'"></fmt:param></fmt:message>');
			}
</script>
<title><fmt:message key="profile" /></title>
</head>
<body>

	<div id="alert" class="modal hide fade">
		<div class="alert alert-block alert-error fade in">
			<button type="button" class="close" data-dismiss="modal">&times;</button>
			<h4>&nbsp;</h4>
			<h4 id="alertText"></h4>
			<h4>&nbsp;</h4>
			<button id="doRmvBtn" class="btn btn-danger pull-right"
				style="margin-bottom: 10px">
				<fmt:message key="dormv" />
			</button>
		</div>
	</div>
	<div id="alertModal" class="modal hide fade">
		<div id="alertDiv" class="alert fade in">
			<button type="button" class="close" data-dismiss="modal">&times;</button>
			<h4 id="alertContent">
				<strong><fmt:message key="act.noupdate" /></strong>
			</h4>
		</div>
	</div>
	<div id="reportWin" class="modal hide fade">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal">&times;</button>
			<h3 id="reportHeader" class="text-warning"></h3>
		</div>
		<div class="modal-body"></div>
		<div id="reportFooter" class="modal-footer">
			<label id="reportSummary" style="display: inline"
				class="text-info pull-left"></label>
			<button class="btn btn-primary pull-right" data-target="#">
				<fmt:message key="act.report" />
			</button>
		</div>
	</div>

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
						<li><a href="<%=basePath%>"><fmt:message key="home" /></a></li>
						<li><a href="<%=basePath + "act/list/1?q="%>"><fmt:message
									key="allActs" /></a></li>
						<li>
							<form action="<%=basePath + "act/list/1"%>" method="get"
								class="form-search" style="margin-left: 30px">
								<div class="input-append">
									<input name="q" type="text" class="search-query"
										placeholder="<fmt:message key="searchbarPlaceholder"/>">
									<button type="submit" class="btn">
										<i class="icon-search"></i>
									</button>
								</div>
							</form>
						</li>
					</ul>
					<div class="btn-group pull-right">
						<a id="nav_name" class="btn btn-success"
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
									class="icon-tags"></i> <fmt:message key="act.myActs" /></a></li>
							<li class="divider"></li>
							<li><a
								href="<%=basePath + "user/" + user.getId() + "?pos=create"%>"><i
									class="icon-edit"></i> <fmt:message key="act.create" /></a></li>
							<li class="divider"></li>
							<li><a
								href="<%=basePath + "user/" + user.getId() + "?pos=profile"%>"><i
									class="icon-wrench"></i> <fmt:message key="profile" /></a></li>
							<li class="divider"></li>
							<li><a
								href="<%=basePath + "logout?user=" + user.getName()%>"><i
									class="icon-off"></i> <fmt:message key="signOut" /></a></li>
						</ul>
					</div>
				</div>
				<!--/.nav-collapse -->
			</div>
		</div>
	</div>

	<c:if test="${ info == 'created' }">
		<div class="alert alert-success">
			<i class="icon-ok-sign"></i>
			<fmt:message key="act.create.ok" />
		</div>
	</c:if>
	<c:if test="${ info == 'updated' }">
		<div class="alert alert-success">
			<i class="icon-ok-sign"></i>
			<fmt:message key="act.update.ok" />
		</div>
	</c:if>
	<c:if test="${ info == 'fail' }">
		<div class="alert alert-error">
			<i class="icon-remove-sign"></i>
			<fmt:message key="act.fail" />
		</div>
	</c:if>

	<div class="well container-narrow"
		style="padding-left: 15px; padding-right: 15px">
		<h3>
			<strong id="head_name" class="inline"><%=user.getName()%></strong>
			<%
				if (user.getLevel() == User.LEVEL_ADMIN) {
			%>
			&nbsp;<small><a href="javascript:admin()"><fmt:message
						key="account.manage" /></a></small>
			<%
				}
			%>
		</h3>
		<%
			if (user.getLevel() == User.LEVEL_ADMIN) {
		%>
		<div id="adminSection" class="alert fade in">
			<a class="close" onclick="$('#adminSection').hide();">&times;</a>
			<table id="userTable" class="table table-bordered">
				<thead>
					<tr>
						<td colspan="5"><blockquote>
								<p>
									<fmt:message key="account.tip.all" />
								</p>
							</blockquote></td>
					</tr>
					<tr>
						<th>Email</th>
						<th><fmt:message key="account.name" /></th>
						<th><fmt:message key="account.pswd" /></th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="curUser" items="${allUsers}">
						<tr class="muted">
							<td>${curUser.email}</td>
							<td>${curUser.name}</td>
							<td>${curUser.password}</td>
							<td class="actionCell"><button class="btn btn-link"
									onclick="javascript:rmvUser(this,'${curUser.id}')">
									<fmt:message key='account.rmv' />
								</button></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<form id="createUserForm">
				<table class="table table-bordered">
					<tr class="success">
						<td colspan="3"><blockquote>
								<p class="text-success">
									<fmt:message key="account.tip.create" />
								</p>
							</blockquote></td>
					</tr>
					<tr class="success">
						<td class="newAccountCell"><input id="newAccountEmail"
							class="input-block-level newAccountText" type="email"
							placeholder="<fmt:message key='account.newEmail'/>" required></td>
						<td class="newAccountCell"><input id="newAccountName"
							class="input-block-level newAccountText" type="text"
							placeholder="<fmt:message key='account.newName'/>" required></td>
						<td class="actionCell"><button class="btn btn-link"
								type=submit>
								<fmt:message key="create" />
							</button>
							<button class="btn btn-link" type="reset">
								<fmt:message key="reset" />
							</button></td>
					</tr>
					<tr class="success">
						<td colspan="3"><p class="text-success tipText pull-right">
								<fmt:message key="account.tip.password" />
							</p></td>
					</tr>
				</table>
			</form>
		</div>
		<script type="text/javascript">
			var rowObj;
			var rmvUserId;
			$("#createUserForm").submit(
					function() {
						$.ajax({
							url : "create",
							type : "POST",
							data : "email=" + $("#newAccountEmail").val() + "&name=" + $("#newAccountName").val(),
							/* 这种传参数格式的data，不要指定dataType、contentType。后台controller才能以@RequestParam形式接收data */
							success : function(data) {
								if (data.result == 'success') {
									var row = document.getElementById("userTable").insertRow(2);
									row.className="muted";
									for(var i=0;i<4;i++)
										row.insertCell(i);
									row.cells[0].innerText=document.getElementById("newAccountEmail").value;
									row.cells[1].innerText=document.getElementById("newAccountName").value;
									row.cells[3].className="actionCell";
									row.cells[3].innerHTML="<button class=\"btn btn-link\" onclick=\"javascript:rmvUser(this,'"+data.id+"')\"><fmt:message key='account.rmv'/></button>";
									document.getElementById("createUserForm").reset();
								} else if(data.result == 'repeated') {
									$("#alertDiv").removeClass().addClass("alert alert-error fade in");
									document.getElementById("alertContent").innerText="<fmt:message key='account.tip.repeated'/>";
									$('#alertModal').modal('show');
								}
							},
							error : function() {
								
							}
						});
						return false;
					}
				);
			function admin(){
				$("#adminSection").show();
			}
			function rmvUser(r,uid){
				rowObj = r;
				rmvUserId = uid;
				document.getElementById("alertText").innerHTML="<fmt:message key='rmvUserAlert'/>";
				document.getElementById("doRmvBtn").setAttribute("onclick","javascript:doRmvUser();");
				$('#alert').modal('show');
			}
			function doRmvUser(){
				$.ajax({
					url : "delete",
					type : "POST",
					data: "id=" + rmvUserId,
					/* 这种传参数格式的data，不要指定dataType、contentType。后台controller才能以@RequestParam形式接收data */
					success : function(data) {
						if (data.result == 'success'){
							$('#alert').modal('hide');
							document.getElementById('userTable').deleteRow(rowObj.parentNode.parentNode.rowIndex);
						}
					}
				});
			}
		</script>
		<%
			}
		%>
		<ul class="nav nav-tabs">
			<li <c:if test="${ pos=='mine' }">class="active"</c:if>><a
				href="<%=basePath + "user/" + user.getId()%>?pos=mine"><fmt:message
						key="act.myActs" />&nbsp;<span class="label label-info">${fn:length(myActs)}</span></a></li>
			<li <c:if test="${ pos=='create' }">class="active"</c:if>><a
				href="<%=basePath + "user/" + user.getId()%>?pos=create"><fmt:message
						key="act.create" /></a></li>
			<li <c:if test="${ pos=='profile' }">class="active"</c:if>><a
				href="<%=basePath + "user/" + user.getId()%>?pos=profile"><fmt:message
						key="profile" /></a></li>
		</ul>

		<jsp:useBean id="now" class="java.util.Date"></jsp:useBean>

		<div class="tab-content">

			<!-- my activities list -->
			<div <c:if test="${ pos=='mine' }">class="tab-pane active"</c:if>
				<c:if test="${ pos!='mine' }">class="tab-pane"</c:if> id="mine">
				<div class="accordion" id="myActsList">
					<c:forEach var="curAct" items="${ myActs }" varStatus="p">
						<div class="accordion-group">
							<div id="head" class="accordion-heading">
								<button class="btn btn-warning data-toggle"
									data-toggle="collapse" data-parent="#myActsList"
									data-target="#collapse${ p.count }">${ curAct.title }</button>
								<div class="pull-right">
									<c:choose>
										<c:when test="${curAct.endTime lt now}">
											<span class="label" style="margin-right: 5px"> <fmt:message
													key="act.finished">
													<fmt:param value="${curAct.total}">
													</fmt:param>
												</fmt:message>
											</span>
										</c:when>
										<c:otherwise>
											<span class="label" style="margin-right: 5px"> <fmt:message
													key="act.nofinished">
													<fmt:param value="${curAct.total}">
													</fmt:param>
												</fmt:message>
											</span>
											<div class="btn-group" data-toggle="buttons-radio">
												<a class="btn" href="javascript:enableUForm(${p.count});"><i
													class="icon-pencil"></i></a> <a class="btn"
													href="javascript:disableUForm(${p.count});"><i
													class="icon-ban-circle"></i></a>
											</div>
										</c:otherwise>
									</c:choose>

									<a class="btn" data-toggle="modal"
										onclick="javascript:rmv('${curAct.id}')" data-target="#alert"><i
										class="icon-trash"></i></a> <a class="btn" data-toggle="modal"
										data-target="#reportWin"
										data-remote="../act/report/${curAct.id}"
										onclick="javascript:report('${curAct.title}','${curAct.total}')"><i
										class="icon-share-alt"></i></a>
								</div>
							</div>

							<div id="collapse${ p.count }" class="accordion-body collapse"
								style="height: 0px;">
								<div class="accordion-inner">
									<form id="updateActForm${p.count}" class="form-horizontal"
										action="../act/update.do/${curAct.id}" method="post"
										enctype="multipart/form-data"
										onsubmit="return updateAct(${p.count});">
										<div class="control-group">
											<label class="control-label" for="title"><fmt:message
													key="act.title" /></label>
											<div class="controls">
												<input id="utitle" disabled="disabled" class="input-xxlarge"
													type="text" name="title" value="${ curAct.title }" required>
											</div>
										</div>
										<div class="control-group">
											<label class="control-label"><fmt:message
													key="act.content" /></label>
											<div class="controls">
												<div id="wysihtml5-editor-toolbar${p.count}"
													class="wysihtml5-toolbar">
													<header>
														<ul class="commands">
															<li data-wysihtml5-command="bold"
																title="Make text bold" class="command"></li>
															<li data-wysihtml5-command="italic"
																title="Make text italic" class="command"></li>
															<li data-wysihtml5-command="insertUnorderedList"
																title="Insert an unordered list" class="command"></li>
															<li data-wysihtml5-command="insertOrderedList"
																title="Insert an ordered list" class="command"></li>
															<li data-wysihtml5-command="createLink"
																title="Insert a link" class="command"></li>
															<li data-wysihtml5-command="formatBlock"
																data-wysihtml5-command-value="h1"
																title="Insert headline 1" class="command"></li>
															<li data-wysihtml5-command="formatBlock"
																data-wysihtml5-command-value="h2"
																title="Insert headline 2" class="command"></li>
															<li data-wysihtml5-command-group="foreColor"
																class="fore-color" title="Color the selected text"
																class="command">
																<ul>
																	<li data-wysihtml5-command="foreColor"
																		data-wysihtml5-command-value="silver"></li>
																	<li data-wysihtml5-command="foreColor"
																		data-wysihtml5-command-value="gray"></li>
																	<li data-wysihtml5-command="foreColor"
																		data-wysihtml5-command-value="maroon"></li>
																	<li data-wysihtml5-command="foreColor"
																		data-wysihtml5-command-value="red"></li>
																	<li data-wysihtml5-command="foreColor"
																		data-wysihtml5-command-value="purple"></li>
																	<li data-wysihtml5-command="foreColor"
																		data-wysihtml5-command-value="green"></li>
																	<li data-wysihtml5-command="foreColor"
																		data-wysihtml5-command-value="olive"></li>
																	<li data-wysihtml5-command="foreColor"
																		data-wysihtml5-command-value="navy"></li>
																	<li data-wysihtml5-command="foreColor"
																		data-wysihtml5-command-value="blue"></li>
																</ul>
															</li>
														</ul>
													</header>
													<div data-wysihtml5-dialog="createLink"
														style="display: none;">
														Link: <input data-wysihtml5-dialog-field="href"
															value="http://"> <a
															data-wysihtml5-dialog-action="save">OK</a>&nbsp;<a
															data-wysihtml5-dialog-action="cancel">Cancel</a>
													</div>
												</div>
												<textarea id="ucontent${p.count}" rows="20"
													style="width: 77%" name="content">${ curAct.content }</textarea>
											</div>
										</div>
										<div class="control-group">
											<label class="control-label" for="location"><fmt:message
													key="act.location" /></label>
											<div class="controls">
												<input id="ulocation" disabled="disabled"
													class="input-xxlarge" type="text" name="location"
													value="${ curAct.location }" required>
											</div>
										</div>
										<div class="control-group">
											<label class="control-label" for="capacity"><fmt:message
													key="act.capacity" /></label>
											<div class="controls">
												<input id="ucapacity${p.count}" disabled="disabled"
													class="input-mini" type="number" name="capacity"
													value="${ curAct.capacity }" min="${curAct.total }"
													required>
											</div>
										</div>
										<div class="control-group">
											<label class="control-label" for="ustart"><fmt:message
													key="act.start" /></label>
											<div class="controls">
												<div class="input-append date" id="ustart${p.count}">
													<input id="us_time" disabled="disabled" class="span2"
														type="text" name="s_time"
														value="<fmt:formatDate value='${curAct.startTime}'
										pattern='yyyy-MM-dd HH:mm:00' />"
														required> <span id="us_picker${p.count}"
														class="add-on" style="visibility: hidden"><i
														class="icon-calendar"></i></span>
												</div>
											</div>
										</div>
										<div class="control-group">
											<label class="control-label" for="uend"><fmt:message
													key="act.end" /></label>
											<div class="controls ">
												<div class="input-append date" id="uend${p.count}">
													<input id="ue_time" disabled="disabled" class="span2"
														type="text" name="e_time"
														value="<fmt:formatDate value='${curAct.endTime}'
										pattern='yyyy-MM-dd HH:mm:00' />"
														required> <span id="ue_picker${p.count}"
														class="add-on" style="visibility: hidden"><i
														class="icon-calendar"></i></span>
												</div>
											</div>
										</div>
										<div class="control-group">
											<label class="control-label" for="banner"><fmt:message
													key="act.image" /></label>
											<div class="controls">
												<div class="fileupload fileupload-new"
													data-provides="fileupload">
													<div class="fileupload-new thumbnail"
														style="width: 200px; height: 150px;">
														<img src="<%=basePath%>resources/img/${ curAct.id }" />
													</div>
													<div class="fileupload-preview fileupload-exists thumbnail"
														style="max-width: 200px; max-height: 150px; line-height: 20px;"></div>
													<div>
														<span class="btn btn-file"><span
															class="fileupload-new"><fmt:message
																	key="act.selectfile" /></span><span class="fileupload-exists"><fmt:message
																	key="act.changefile" /></span> <input type="file" id="ufile"
															disabled="disabled" name="file" accept="image/*" /></span> <a
															href="#" class="btn fileupload-exists"
															data-dismiss="fileupload"><fmt:message
																key="act.removefile" /></a>
													</div>
												</div>
												<!-- <input type="file" name="file" accept="image/*"> -->
											</div>
										</div>
										<div id="ufooter${p.count}" class="modal-footer" hidden="true">
											<input type="reset" class="btn"
												value="<fmt:message key="cancel"/>"> <input
												type="submit" class="btn btn-primary"
												value="<fmt:message key="change"/>"
												style="margin-right: 40px;">
										</div>
									</form>
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
			</div>
			<script type="text/javascript">
				$(document).ready(function(){
					$('#alertModal').modal({
						backdrop: false,
						show: false
					});
					$('#adminSection').hide();
				})
				var editors=new Array(${fn:length(myActs)});
				for(var i=1;i<=editors.length;i++){
					editors[i-1] = new wysihtml5.Editor("ucontent"+i, {
				        toolbar:     "wysihtml5-editor-toolbar"+i,
				        stylesheets: ["../resources/css/editor.css"],
				        parserRules: wysihtml5ParserRules
				 	});
				    editors[i-1].on("load", function() {
				        var h1 = this.composer.element.querySelector("h1");
				        if (h1) {
				        	this.composer.selection.selectNode(h1);
				        }
				        this.textareaElement.disabled = true;
					    this.composer.disable();
					    this.toolbar.commandsDisabled = true;
					});
				}
				//this method is to force the modal's reloading each time it popups
				$('#reportWin').on('hidden', function() {
				    $(this).data('modal').$element.removeData();
				})
				function initUPicker(num){
					$("#ustart"+num).datetimepicker({
						format : "yyyy-MM-dd hh:mm:00",
						language : '<%=RequestContextUtils.getLocale(request)%>'
					});
					$("#uend"+num).datetimepicker({
						format : "yyyy-MM-dd hh:mm:00",
						language : "<%=RequestContextUtils.getLocale(request)%>"
					});
				}
				function enableUForm(num){
					var formid = 'updateActForm'+num;
					initUPicker(num);
					editors[num-1].textareaElement.disabled = false;
			        editors[num-1].composer.enable();
			        editors[num-1].toolbar.commandsDisabled = false;
			        document.getElementById("wysihtml5-editor-toolbar"+num).style.display="";
					for(var i=0;i<document.getElementById(formid).elements.length;i++){
						document.getElementById(formid).elements[i].disabled=false;
					}
					document.getElementById("us_picker"+num).style.visibility="visible";
					document.getElementById("ue_picker"+num).style.visibility="visible";
					document.getElementById("ufooter"+num).hidden=false;
				};
				function disableUForm(num){
					var formid = 'updateActForm'+num;
					document.getElementById(formid).reset();
					for(var i=0;i<document.getElementById(formid).elements.length;i++){
						document.getElementById(formid).elements[i].disabled=true;
					}
					editors[num-1].textareaElement.disabled = true;
				    editors[num-1].composer.disable();
				    editors[num-1].toolbar.commandsDisabled = true;
			        document.getElementById("wysihtml5-editor-toolbar"+num).style.display="none";
					document.getElementById("us_picker"+num).style.visibility="hidden";
					document.getElementById("ue_picker"+num).style.visibility="hidden";
					document.getElementById("ufooter"+num).hidden=true;
				};
				function updateAct(num) {
					if(!isUpdated(num))
						return false;
					var sd = $(document.getElementById("ustart"+num)).data(
							'datetimepicker');
					var ed = $(document.getElementById("uend"+num)).data(
							'datetimepicker');
					if (sd.getLocalDate().getTime() >= ed
							.getLocalDate()
							.getTime()) {
						$("#alertDiv").removeClass().addClass("alert alert-error fade in");
						document.getElementById("alertContent").innerText="<fmt:message key="act.timeInvalid"/>";
						$('#alertModal').modal('show');
						ed.setLocalDate(sd.getLocalDate());
						return false;
					}
				};
				function isUpdated(num){
					var theForm = document.getElementById("updateActForm"+num);
					for(var i=0;i<theForm.elements.length;i++){
						if(theForm.elements[i].value!=theForm.elements[i].defaultValue)
							return true;
					}
					$('#alertModal').modal('show');
					return false;
				}
			</script>

			<!-- creation form -->
			<div <c:if test="${ pos=='create' }">class="tab-pane active"</c:if>
				<c:if test="${ pos!='create' }">class="tab-pane"</c:if> id="create">
				<form id="newActForm" class="form-horizontal"
					action="../act/create.do" method="post"
					enctype="multipart/form-data" onsubmit="return createAct();">
					<div class="control-group warning">
						<label class="control-label" for="title"><fmt:message
								key="act.title" /></label>
						<div class="controls">
							<input class="input-xxlarge" type="text" name="title" required>
						</div>
					</div>
					<div class="control-group warning">
						<label class="control-label" for="content"><fmt:message
								key="act.content" /></label>
						<div class="controls">
							<div id="wysihtml5-editor-toolbar" class="wysihtml5-toolbar">
								<header>
									<ul class="commands">
										<li data-wysihtml5-command="bold"
											title="Make text bold" class="command"></li>
										<li data-wysihtml5-command="italic"
											title="Make text italic" class="command"></li>
										<li data-wysihtml5-command="insertUnorderedList"
											title="Insert an unordered list" class="command"></li>
										<li data-wysihtml5-command="insertOrderedList"
											title="Insert an ordered list" class="command"></li>
										<li data-wysihtml5-command="createLink" title="Insert a link"
											class="command"></li>
										<li data-wysihtml5-command="formatBlock"
											data-wysihtml5-command-value="h1" title="Insert headline 1"
											class="command"></li>
										<li data-wysihtml5-command="formatBlock"
											data-wysihtml5-command-value="h2" title="Insert headline 2"
											class="command"></li>
										<li data-wysihtml5-command-group="foreColor"
											class="fore-color" title="Color the selected text"
											class="command">
											<ul>
												<li data-wysihtml5-command="foreColor"
													data-wysihtml5-command-value="silver"></li>
												<li data-wysihtml5-command="foreColor"
													data-wysihtml5-command-value="gray"></li>
												<li data-wysihtml5-command="foreColor"
													data-wysihtml5-command-value="maroon"></li>
												<li data-wysihtml5-command="foreColor"
													data-wysihtml5-command-value="red"></li>
												<li data-wysihtml5-command="foreColor"
													data-wysihtml5-command-value="purple"></li>
												<li data-wysihtml5-command="foreColor"
													data-wysihtml5-command-value="green"></li>
												<li data-wysihtml5-command="foreColor"
													data-wysihtml5-command-value="olive"></li>
												<li data-wysihtml5-command="foreColor"
													data-wysihtml5-command-value="navy"></li>
												<li data-wysihtml5-command="foreColor"
													data-wysihtml5-command-value="blue"></li>
											</ul>
										</li>
									</ul>
								</header>
								<div data-wysihtml5-dialog="createLink" style="display: none;">
									Link: <input data-wysihtml5-dialog-field="href" value="http://">
									<a data-wysihtml5-dialog-action="save">OK</a>&nbsp;<a
										data-wysihtml5-dialog-action="cancel">Cancel</a>
								</div>
							</div>
							<textarea id="content" rows="20" style="width: 74%"
								name="content" required></textarea>
						</div>
					</div>
					<div class="control-group warning">
						<label class="control-label" for="location"><fmt:message
								key="act.location" /></label>
						<div class="controls">
							<input class="input-xxlarge" type="text" name="location" required>
						</div>
					</div>
					<div class="control-group warning">
						<label class="control-label" for="capacity"><fmt:message
								key="act.capacity" /></label>
						<div class="controls">
							<input id="capacity" class="input-mini" type="number"
								name="capacity" required> <span class="help-inline"><fmt:message
									key="act.tip.capacity" /></span>
						</div>
					</div>
					<div class="control-group warning">
						<label class="control-label" for="startInput"><fmt:message
								key="act.start" /></label>
						<div class="controls">
							<div class="input-append date" id="start">
								<input id="startInput" class="span2" type="text" name="s_time"
									required> <span class="add-on"><i
									class="icon-calendar"></i></span>
							</div>
							<span class="help-inline"><fmt:message key="act.tip.time" /></span>
						</div>
					</div>
					<div class="control-group warning">
						<label class="control-label" for="end"><fmt:message
								key="act.end" /></label>
						<div class="controls ">
							<div class="input-append date" id="end">
								<input class="span2" type="text" name="e_time" required>
								<span class="add-on"><i class="icon-calendar"></i></span>
							</div>
						</div>
					</div>
					<div class="control-group warning">
						<label class="control-label" for="banner"><fmt:message
								key="act.image" /></label>
						<div class="controls">
							<div class="fileupload fileupload-new" data-provides="fileupload">
								<div class="fileupload-new thumbnail"
									style="width: 200px; height: 150px;">
									<img src="../resources/img/noImg.gif" />
								</div>
								<div class="fileupload-preview fileupload-exists thumbnail"
									style="max-width: 200px; max-height: 150px; line-height: 20px;"></div>
								<div>
									<span class="btn btn-file"><span class="fileupload-new"><fmt:message
												key="act.selectfile" /></span><span class="fileupload-exists"><fmt:message
												key="act.changefile" /></span> <input type="file" name="file"
										accept="image/*" /></span> <a href="#" class="btn fileupload-exists"
										data-dismiss="fileupload"><fmt:message
											key="act.removefile" /></a>
								</div>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<input type="reset" class="btn" value="<fmt:message key="reset"/>">
						<input type="submit" class="btn btn-primary"
							value="<fmt:message key="create"/>" style="margin-right: 40px;">
					</div>
					<script type="text/javascript">
						$('#start').datetimepicker({
							format : "yyyy-MM-dd hh:mm:00",
							language : "<%=RequestContextUtils.getLocale(request)%>"
						});
						$('#end').datetimepicker({
							format : "yyyy-MM-dd hh:mm:00",
							language : "<%=RequestContextUtils.getLocale(request)%>"
						});
						var editor = new wysihtml5.Editor("content", {
					        toolbar:     "wysihtml5-editor-toolbar",
					        stylesheets: ["../resources/css/editor.css"],
					        parserRules: wysihtml5ParserRules
					 	});
					    editor.on("load", function() {
					        var h1 = this.composer.element.querySelector("h1");
					        if (h1) {
					        	this.composer.selection.selectNode(h1);
					        }
						});
						function createAct() {
							var sd = $('#start').data('datetimepicker');
							var ed = $('#end').data('datetimepicker');
							if (sd.getLocalDate().getTime() >= ed
									.getLocalDate().getTime()) {
								$("#alertDiv").removeClass().addClass("alert alert-error fade in");
								$("#alertContent").text('<fmt:message key="act.timeInvalid"/>');
								$('#alertModal').modal('show');
								ed.setLocalDate(sd.getLocalDate());
								return false;
							}
						}
					</script>
				</form>
			</div>

			<!-- profile setting -->
			<div id="profile"
				<c:if test="${ pos=='profile' }">class="tab-pane active"</c:if>
				<c:if test="${ pos!='profile' }">class="tab-pane"</c:if>>
				<form id="profileForm" class="form-horizontal">
					<fieldset>
						<div class="control-group">
							<label class="control-label">Email:</label>
							<div class="controls">
								<p class="copy"><%=user.getEmail()%></p>
							</div>
						</div>
						<div class="control-group warning">
							<label class="control-label" for="nm"><fmt:message
									key="profile.name" /></label>
							<div class="controls">
								<input id="nm" name="u_name" type="text" class="input-large"
									value="<%=user.getName()%>" required>
							</div>
						</div>
						<div class="control-group warning">
							<label class="control-label" for="op"><fmt:message
									key="profile.oldpswd" /></label>
							<div class="controls">
								<input id="op" name="old_pswd" type="password"
									class="input-large" required>
							</div>
						</div>
						<div class="control-group warning">
							<label class="control-label" for="np"><fmt:message
									key="profile.newpswd" /></label>
							<div class="controls">
								<input id="np" name="new_pswd" type="password"
									class="input-large">
							</div>
						</div>
						<div class="control-group warning">
							<label class="control-label" for="cp"><fmt:message
									key="profile.cnfmpswd" /></label>
							<div class="controls">
								<input id="cp" name="cnfm_pswd" type="password"
									class="input-large">
							</div>
						</div>
						<div class="control-group">
							<div class="controls">
								<button class="btn btn-success" type="button" onclick="update()">
									<fmt:message key="change" />
								</button>
								<button class="btn" type="reset" id="rst">
									<fmt:message key="cancel" />
								</button>
							</div>
						</div>

					</fieldset>
				</form>

			</div>
			<script>
				function check(){
					if($('#op').val()!='<%=user.getPassword()%>'){
						$("#alertDiv").removeClass().addClass("alert alert-error fade in");
						$("#alertContent").text('<fmt:message key="profile.pswdInvalid"/>');
					}
					else if($('#np').val()=='' && $('#cp').val()=='')
						if($('#nm').val() == $('#nm').prop('defaultValue')){
							$("#alertDiv").removeClass().addClass("alert fade in");
							$('#alertContent').text('<fmt:message key="profile.noupdate"/>');	
						}
						else return true;
					else if($('#np').val()!=$('#cp').val()){
						$("#alertDiv").removeClass().addClass("alert alert-error fade in");
						$('#alertContent').text('<fmt:message key="profile.pswddisacc"/>');
					}
					else return true;
					$('#alertModal').modal('show');
					return false;
				}
				function update(){
					if(check()){
						$.ajax({
							url : "update/<%=user.getId()%>",
							type : "POST",
							data: "u_name=" + $("#nm").val() + "&cnfm_pswd=" + $("#cp").val(),
							/* 这种传参数格式的data，不要指定dataType、contentType。后台controller才能以@RequestParam形式接收data */
							success : function(result) {
								if (result == 'success'){
									$('#nm').prop('defaultValue',$('#nm').val());
									$("#head_name").text($("#nm").val());
									$("#nav_name").html('<i class="icon-user icon-white"></i> '+$("#nm").val());
									$("#rst").trigger('click');	
									$("#alertDiv").removeClass().addClass("alert alert-success fade in");
									$("#alertContent").text('<fmt:message key="profilel.update.success"/>');
								}
								else{
									$("#alertDiv").removeClass().addClass("alert alert-error fade in");
									$("#alertContent").text('<fmt:message key="profilel.update.fail"/>');
								}
								$('#alertModal').modal('show');
							},
							error : function() {
								$("#alertDiv").removeClass().addClass("alert alert-error fade in");
								$("#alertContent").text('<fmt:message key="profilel.update.fail"/>');
								$('#alertModal').modal('show');
							}
						});
					}
				}
			</script>
		</div>

	</div>

</body>
</html>