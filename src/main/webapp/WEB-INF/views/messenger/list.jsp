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
	<h4>채팅방</h4>
	<c:forEach items="${ room }" var="r">
		<form action="/msg/chat" method="post">
			<input type="hidden" name="chatRoomNum" value="${ r.chatRoomNum }">
			<button>${ r.chatRoomName }입장</button>
		</form>
	</c:forEach>
	<hr>
	<form action="/msg/create" method="get">
		<button>방 생성</button>
	</form>
	<div>
		<a href="/msg">멤버</a>
	</div>
	<script>	
	    const rooms = [
	        <c:forEach var="room" items="${ room }" varStatus="status">
	            ${ room.chatRoomNum }<c:if test="${ !status.last }">,</c:if>
	        </c:forEach>
	    ];
	    setInterval(() => {
	        fetch("/msg/unread/count", {
	            method: "POST",
	            headers: {"Content-Type": "application/json"},
	            body: JSON.stringify(rooms)
	        })
	        .then(res => res.json())
	        .then(data => {
	            // data = { 101: 3, 102: 0, 103: 5 }
/* 	            for (const roomId in data) {
	                const badge = document.querySelector(`#unread-count-${roomId}`);
	                if (badge) {
	                    badge.innerText = data[roomId];
	                }
	            } */
	        })
	        .catch(err => console.error(err));
	    }, 5000);
</script>
</body>
</html>