<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<script>
	$("#loginForm").submit(
			function() {
				$("#loginbtn").button('loading');
				$.ajax({
					url : "<%=basePath%>login",
					type : "POST",
					data : "email=" + $("#u_email").val() + "&pswd=" + $("#u_pswd").val(),
					/* 这种传参数格式的data，不要指定dataType、contentType。后台controller才能以@RequestParam形式接收data */
					success : function(data) {
						if (data.result == 'success') {
							$("#log_info").attr("class","text-success");
							$("#log_info").html('<spring:message code="signin.success"/>');
							setTimeout("window.location.reload(true);",3000);
						} else {
							$("#log_info").html('<spring:message code="signin.fail"/>');
							$("#loginbtn").button('reset');
						}
					},
					error : function() {
						$("#log_info").html('<spring:message code="signin.error"/>');
						$("#loginbtn").button('reset');
					}
				});
				return false;
			}
		);
</script>
<form id="loginForm" class="form-signin">
	<input id="u_email" type="email" class="input-block-level"
		placeholder="<spring:message code="signin.email"/>" required>
	<input id="u_pswd" type="password" class="input-block-level"
		placeholder="<spring:message code="signin.password"/>">
	<div>
		<label id="log_info" class="text-error"></label>
	</div>
	<button id="loginbtn" type="submit" class="btn btn-primary pull-right"
		data-loading-text="<spring:message code="processing"/>">
		<spring:message code="signIn" />
	</button>
</form>