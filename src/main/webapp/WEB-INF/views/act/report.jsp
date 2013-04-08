<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!-- 本页内容作为profile.jsp页面中的modal data-remote显示，若写成完整的html文档，会产生的问题是：每次modal的显示都会叠加一个新的backdrop，且collapse控件显示不正常 -->
	<table class="table table-striped table-bordered">
		<thead>
			<tr>
				<th>#</th>
				<th>Email</th>
				<th>App URL</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="curPart" items="${parts}" varStatus="p">
				<tr class="muted">
					<td>${p.count}</td>
					<td>${curPart.email}</td>
					<td>${curPart.url}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>