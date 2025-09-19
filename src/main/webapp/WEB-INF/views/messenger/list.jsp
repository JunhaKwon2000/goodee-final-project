<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메신저</title>
<script src="https://cdn.jsdelivr.net/npm/stompjs/lib/stomp.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
</head>
<body>
	<h4>메신저</h4>
	<c:forEach items="${ room }" var="r">
		<form action="/msg/chat" method="post">
			<input type="hidden" name="chatRoomNum" value="${ r.chatRoomNum }">
			<button>${ r.chatRoomName }입장</button>
		</form>
	</c:forEach>
	<form action="/msg/create" method="get">
		<button>방 생성</button>
	</form>
</body>
</html>