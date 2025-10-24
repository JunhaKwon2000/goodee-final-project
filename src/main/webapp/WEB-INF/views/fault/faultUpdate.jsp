<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>어트랙션 고장 신고</title>
	<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
	
	<style>
	  /* 모달창 css */
	  .my-cancel-btn {
	  background-color: #fff !important;   
	  color: #212529 !important;           
	  border: 1px solid #ccc !important;   
	  border-radius: 5px !important;       
	}
	
	.my-cancel-btn:hover {
	  background-color: #f8f9fa !important;
	}
	</style>
	
</head>

<body class="g-sidenav-show bg-gray-100">
	<c:import url="/WEB-INF/views/common/sidebar.jsp"></c:import>
  
  <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
    <c:import url="/WEB-INF/views/common/nav.jsp"></c:import>
    <div class="d-flex">
    	<aside class="sidenav navbar navbar-vertical border-radius-lg ms-2 bg-white my-2 w-10 align-items-start" style="width: 200px !important; height: 92vh;">
    		<div class="w-100">
			    <ul class="navbar-nav">
			      <!-- 메뉴 개수만큼 추가 -->
		    	  <c:import url="/WEB-INF/views/ride/ride-side-sidebar.jsp"></c:import>
			    </ul>
			  </div>
    	</aside>
	    <section class="border-radius-xl bg-white w-90 ms-2 mt-2 me-3" style="height: 92vh; overflow: hidden scroll;">
	    
		    <!-- 여기에 코드 작성 -->
			<form:form method="post"
						modelAttribute="faultDTO"
						enctype="multipart/form-data"
						class="container col-8"
						style="margin-top:70px;"
						action="${pageContext.request.contextPath }/fault/${ faultDTO.faultNum }/update">
						
			<!-- PK (필수) -->
			<form:hidden path="faultNum"/>
						
			<!-- 어트랙션 코드 (수정불가 → hidden으로 유지) -->
			<div class="form-group row mb-3">
			  <form:label path="rideDTO.rideCode" class="col-sm-4 col-form-label text-start">어트랙션</form:label>
			  <div class="col-sm-5">
			    <div>${faultDTO.rideDTO.rideName}(${faultDTO.rideDTO.rideCode})</div>
			    <form:hidden path="rideDTO.rideCode"/>
			  </div>
			</div>
			
			<!-- 신고 제목 -->
			<div class="form-group row mb-3">
			  <form:label path="faultTitle" class="col-sm-4 col-form-label text-start">신고 제목</form:label>
			  <div class="col-sm-5">
			 	 <div>${faultDTO.faultTitle}</div>
			 	 <form:hidden path="faultTitle"/>
			  </div>
			</div>
			
			<!-- 신고 내용 -->
			<div class="form-group row mb-3">
			  <form:label path="faultContent" class="col-sm-4 col-form-label text-start">신고 내용</form:label>
			  <div class="col-sm-5">
		  		<div>${faultDTO.faultContent}</div>
		  		<form:hidden path="faultContent"/>
			  </div>
			</div>
			
			<!-- 신고 날짜 -->
			<div class="form-group row mb-3">
			  <form:label path="faultDate" class="col-sm-4 col-form-label text-start">신고 날짜</form:label>
			  <div class="col-sm-5">
			    <form:input path="faultDate" type="date" cssClass="form-control"/>
			  </div>
			</div>
			
			<!-- 담당자 -->
			<div class="form-group row mb-3">
			  <form:label path="staffDTO.staffCode" class="col-sm-4 col-form-label text-start">담당자</form:label>
			  <div class="col-sm-5">
			    <form:select path="staffDTO.staffCode" cssClass="form-select">
			      <form:option value="">-- 담당자를 선택하세요 --</form:option>
			      <c:forEach var="staff" items="${staffList}">
			        <form:option value="${staff.staffCode}">${staff.staffName} (${staff.staffCode})</form:option>
			      </c:forEach>
			    </form:select>
			  </div>
			</div>
			
			<!-- 신고 상태 -->
			<div class="form-group row mb-3">
			  <form:label path="faultState" class="col-sm-4 col-form-label text-start">신고상태</form:label>
			  <div class="col-sm-5">
			    <form:select path="faultState" cssClass="form-select">
			      <form:option value="">-- 신고상태를 선택하세요 --</form:option>
			      <form:option value="410">신고접수</form:option>
			      <form:option value="411">담당자 배정</form:option>
			      <form:option value="412">수리중</form:option>
			      <form:option value="420">수리완료</form:option>
			    </form:select>
			  </div>
			</div>

			
			<!-- 사진첨부 -->
			<div class="form-group row mb-3">
			  <form:label path="" class="col-sm-4 col-form-label text-start">첨부파일</form:label>
			  <div class="col-sm-5">
			
			    <c:choose>
			      <c:when test="${not empty faultDTO.faultAttachmentDTO}">
			        <!-- 기존 파일 존재 여부 -->
			        <input type="hidden" id="hasExistingFile" value="true"/>
			        <div id="preview-box" style="width:200px; height:200px; border:1px solid #000; display:flex; align-items:center; justify-content:center;">
			          <img id="preview"
			               src="/file/fault/${faultDTO.faultAttachmentDTO.attachmentDTO.savedName}"
			               style="object-fit:cover; width:100%; height:100%;" 
			               class="border border-1 border-dark p-1"/>
			        </div>
			      </c:when>
			
			      <c:otherwise>
			        <input type="hidden" id="hasExistingFile" value="false"/>
			        <div id="preview-box" style="width:200px; height:200px; border:1px solid #000; display:flex; align-items:center; justify-content:center;">
			          <span id="noImageText" class="text-muted">등록된 이미지가 없습니다</span>
			          <img id="preview" style="display:none; object-fit:cover; width:100%; height:100%;" 
			               class="border border-1 border-dark p-1"/>
			        </div>
			      </c:otherwise>
			    </c:choose>
			
			    <!-- 파일 선택 버튼 -->
			    <label for="attach">
			      <div class="btn btn-outline-secondary px-2 py-0 m-auto mt-2">어트랙션 고장 신고 사진 등록</div>
			    </label>
			    <input type="file" class="d-none" id="attach" name="attach"/>
			  </div>
			</div>

			
			<!-- 버튼 --><!-- 로그인 사용자 정보 꺼내기 -->
	 			<sec:authorize access="isAuthenticated()">
				<sec:authentication property="principal" var="staff" />
				
				<!-- 시설부서(deptCode == 1003)일 때만 등록 버튼 보이기 -->
				<c:if test="${staff.deptDTO.deptCode eq 1003}">
				    <div class="form-group row mt-4 text-end">
				      <div class="col-sm-9">
				      	<!-- 수정 버튼 -> add 페이지로가는데 입력된 정보 가지고 감 -->
				      	<form action="${pageContext.request.contextPath }/fault/${fault.isptNum}/update"
				      			method="get" style="display: inline;">
					        <button type="submit" 
					        		class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white me-3" 
					        		style="width: 75px;">수정</button>
				        </form>
				        <!-- 삭제 버튼 -->
				        <button type="button" 
				                class="btn btn-sm btn-outline-secondary" 
				                style="width: 75px;"
				                onclick="deleteFault('${ fault.faultNum }')">삭제</button>
				      </div>
				    </div>
			    </c:if>
			    </sec:authorize>                
			
			</form:form>


	    </section>
    </div>
  </main>
	<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
	<script src="/js/fault/faultWrite.js"></script>
	<script>
		document.querySelector("i[data-content='어트랙션']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("i[data-content='고장 신고 목록']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("#navTitle").textContent = "고장 신고 목록"
	</script>
</body>

</html>