<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅방 생성</title>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<!-- Material Icons -->
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link href="/css/messenger/create.css" rel="stylesheet">
</head>
<body>
    <div class="create-room-container">
        <!-- 멤버 리스트 -->
        <div class="member-list">
        	<a class="anchor" href="/msg/room/all">채팅 목록</a>
            <h3>그룹 채팅방 생성</h3>
            <sec:authorize access="isAuthenticated()">
				<sec:authentication property="principal" var="logged" />
				<input type="hidden" id="logged" value="${ logged.staffCode }">
			</sec:authorize>
			<form:form action="/msg/create" method="post" id="form" modelAttribute="chatRoomDTO">
			    <label for="chatRoomName">채팅방 이름</label>
			    <input type="text" name="chatRoomName" id="chatRoomName" placeholder="방 이름을 입력해주세요" autocomplete="off">
			    <form:errors path="chatRoomName"></form:errors>
			    <input type="hidden" id="addedStaff" name="addedStaff">
			</form:form>
			<!-- 검색을 했을 때 추가한 멤버가 같이 이동이 되지 않아서 고민좀 해봐야할 듯 -->
<%-- 	    	<form action="/msg/create" method="get">
	    		<label for="search" id="search-label">초대할 멤버 선택</label>
		    	<input type="text" placeholder="이름을 입력하세요" name="keyword" value="${ keyword }" class="search-input" id="search">
		    	<button class="search-btn">검색</button>
	    	</form> --%>
			<div class="scroll-members">
			
			<c:forEach items="${ dept }" var="d">
				<c:if test="${ d.deptCode eq 1000 }">
		        	<div class="section-title">임원(${ d.deptGroup })</div>			
				</c:if>
			</c:forEach>
            <c:forEach items="${ staff }" var="m">
            <c:if test="${ m.deptDTO.deptName eq 'ROLE_HQ' }">
                <div class="member-item">
                    <div class="member-info">
                        <img src="/file/staff/${ m.staffAttachmentDTO.attachmentDTO.savedName }" alt="">
                        <div>
                            <div class="member-name">${ m.staffName }</div>
                            <div class="member-role">${ m.jobDTO.jobDetail }</div>
                        </div>
                    </div>
                    <input type="checkbox" value="${ m.staffCode }" data-name="${ m.staffName }" data-img="/file/staff/${ m.staffAttachmentDTO.attachmentDTO.savedName }">
                </div>
            </c:if>
            </c:forEach>
            
   			<c:forEach items="${ dept }" var="d">
				<c:if test="${ d.deptCode eq 1001 }">
		        	<div class="section-title">인사팀(${ d.deptGroup })</div>			
				</c:if>
			</c:forEach>
            <c:forEach items="${ staff }" var="m">
            <c:if test="${ m.deptDTO.deptName eq 'ROLE_HR' }">
                <div class="member-item">
                    <div class="member-info">
                        <img src="/file/staff/${ m.staffAttachmentDTO.attachmentDTO.savedName }" alt="">
                        <div>
                            <div class="member-name">${ m.staffName }</div>
                            <div class="member-role">${ m.jobDTO.jobDetail }</div>
                        </div>
                    </div>
                    <input type="checkbox" value="${ m.staffCode }" data-name="${ m.staffName }" data-img="/file/staff/${ m.staffAttachmentDTO.attachmentDTO.savedName }">
                </div>
            </c:if>
            </c:forEach>
            
       		<c:forEach items="${ dept }" var="d">
				<c:if test="${ d.deptCode eq 1002 }">
		        	<div class="section-title">운영팀(${ d.deptGroup })</div>			
				</c:if>
			</c:forEach>
            <c:forEach items="${ staff }" var="m">
            <c:if test="${ m.deptDTO.deptName eq 'ROLE_OP' }">
                <div class="member-item">
                    <div class="member-info">
                        <img src="/file/staff/${ m.staffAttachmentDTO.attachmentDTO.savedName }" alt="">
                        <div>
                            <div class="member-name">${ m.staffName }</div>
                            <div class="member-role">${ m.jobDTO.jobDetail }</div>
                        </div>
                    </div>
                    <input type="checkbox" value="${ m.staffCode }" data-name="${ m.staffName }" data-img="/file/staff/${ m.staffAttachmentDTO.attachmentDTO.savedName }">
                </div>
            </c:if>
            </c:forEach>
            
       		<c:forEach items="${ dept }" var="d">
				<c:if test="${ d.deptCode eq 1003 }">
		        	<div class="section-title">시설팀(${ d.deptGroup })</div>			
				</c:if>
			</c:forEach>
            <c:forEach items="${ staff }" var="m">
            <c:if test="${ m.deptDTO.deptName eq 'ROLE_FA' }">
                <div class="member-item">
                    <div class="member-info">
                        <img src="/file/staff/${ m.staffAttachmentDTO.attachmentDTO.savedName }" alt="">
                        <div>
                            <div class="member-name">${ m.staffName }</div>
                            <div class="member-role">${ m.jobDTO.jobDetail }</div>
                        </div>
                    </div>
                    <input type="checkbox" value="${ m.staffCode }" data-name="${ m.staffName }" data-img="/file/staff/${ m.staffAttachmentDTO.attachmentDTO.savedName }">
                </div>
            </c:if>
            </c:forEach>
        </div>
        </div>

		<!-- 선택된 멤버 -->
		<div class="selected-list">
		    <div class="selected-title">
		        <span class="selected-number">0</span>명 선택
		        <span class="anchor clear-all">클리어</span>
		    </div>
		</div>
    </div>

    <!-- 하단 버튼 -->
    <div class="footer">
        <button id="createRoom">생성</button>
    </div>
    <script type="text/javascript" src="/js/messenger/create.js"></script>
</body>
</html>