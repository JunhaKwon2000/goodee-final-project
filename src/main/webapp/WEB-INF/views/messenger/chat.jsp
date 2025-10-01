<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메신저</title>
<script src="https://cdn.jsdelivr.net/npm/stompjs/lib/stomp.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
<link href="/css/messenger/chat.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
</head>
<body>
	<h2>메신저</h2>
	<div class="chat-top-group">
		<div><a href="/msg/room">채팅방 목록</a></div>
		<div>
			<span id="addMemeber" class="material-icons" style="cursor: pointer;">person_add</span>
			<span id="chat-leave" class="material-icons" style="cursor: pointer;">logout</span>
		</div>
	</div>
	<sec:authorize access="isAuthenticated()">
		<sec:authentication property="principal" var="staff" />
		<input type="hidden" id="messageSender" value="${ staff.staffCode }">
		<input type="hidden" id="messageSenderName" value="${ staff.staffName }">
		<input type="hidden" id="next" value="${ next }">
		<input type="hidden" id="page" value="0">
	</sec:authorize>
	<input type="hidden" id="chatRoomNum" value="${ chatRoomNum }">
	<div id="messages">
		<c:forEach items="${ chat }" var="c">
		    <c:if test="${ c.chatBodyType eq 'SEND' }">
		      	<div class="chat-message <c:if test='${ c.staffCode eq staff.staffCode }'>me</c:if>">
		        	<div class="chat-sender">${ c.staffName }</div>
		        	<div class="chat-text-wrapper">
		            	<div class="chat-text">${ c.chatBodyContent }</div>
		            	<div class="chat-meta">
				            <div class="chat-date-inline">${ c.chatDate }</div>
				            <div class="chat-time">${ c.chatTime }</div>
		            	</div>
		        	</div>
		      	</div>
		    </c:if>
	    	<c:if test="${ c.chatBodyType eq 'NEW' }">
	    		<div class="chat-read-divider">${ c.chatBodyContent }</div>
	    	</c:if>
		</c:forEach>
	</div>
	<div class="message-container-chat">
	    <textarea rows="3" cols="30" id="messageInput" placeholder="메시지를 입력해 주세요."></textarea>
	    <div class="button-wrapper">
	        <button id="sendButton">전송</button>
	    </div>
	</div>

	
	<!-- 멤버 추가 모달 -->
	<div id="addMemberModal">
		<div id="addMemberModalInternal">
			<h3>멤버 초대</h3>
			<div id="selectedMembers"></div>
			<div id="memberList"></div>
			<div style="text-align:right; margin-top:10px;">
				<button id="closeModal">취소</button>
				<button id="addMembers">추가</button>
			</div>
		</div>
	</div>
	<script type="text/javascript" src="/js/messenger/connect.js"></script>
</body>
</html>