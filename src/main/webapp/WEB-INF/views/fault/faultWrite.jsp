<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>어트랙션 고장 신고</title>
	<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
	
	<!-- Bootstrap 5.3.8 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
	
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
  <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
 		<nav class="navbar navbar-main navbar-expand-lg px-0 mx-3 shadow-none border-radius-xl bg-white ms-2 mt-2" style="height:50px;" id="navbarBlur" >
 			<div>
				<h5 class="mb-0 ms-3" id="navTitle" style="font-weight:bold;">어트랙션 고장 신고</h5> 			
 			</div>
 		</nav>
 		
 		
 		
	    <section class="border-radius-xl bg-white w-92 ms-2 mt-2 me-3 ps-3 pe-3" style="height: 440px;">
	    
		    <!-- 여기에 코드 작성 -->
			<form:form id="faultForm"
						method="post"
						modelAttribute="faultDTO"
						enctype="multipart/form-data"
						action="${pageContext.request.contextPath }/fault/write">
						
			<!-- 어트랙션 코드 -->
			<div class="form-group row mb-3">
			  <form:label path="rideDTO.rideCode" class="col-sm-4 col-form-label text-start">어트랙션</form:label>
			  <div class="col-sm-5">
			    <form:select path="rideDTO.rideCode" cssClass="form-select">
			      <form:option value="">-- 어트랙션을 선택하세요 --</form:option>
			      <c:forEach var="ride" items="${rideList}">
			        <form:option value="${ride.rideCode}">${ride.rideName} (${ride.rideCode})</form:option>
			      </c:forEach>
			    </form:select>
			  </div>
			</div>
			
			<!-- 신고 제목 -->
			<div class="form-group row mb-3">
				<form:label path="faultTitle" class="col-sm-4 col-form-label text-start">신고 제목</form:label>
				<div class="col-sm-5">
					<form:input path="faultTitle" cssClass="form-control" placeholder="신고 제목을 입력하세요."/>
				</div>
			</div>
			
			<!-- 신고 내용 -->
			<div class="form-group row mb-3">
				<form:label path="faultContent" class="col-sm-4 col-form-label text-start">신고 내용</form:label>
				<div class="col-sm-5">
					<form:textarea path="faultContent" cssClass="form-control" style="resize:none;" placeholder="신고 내용을 입력하세요."/>
				</div>
			</div>
			
			<!-- 신고 날짜 -->
			<div class="form-group row mb-3">
			  <form:label path="faultDate" class="col-sm-4 col-form-label text-start">신고 날짜</form:label>
			  <div class="col-sm-5">
			    <form:input path="faultDate" type="date" cssClass="form-control"/>
			  </div>
			</div>
			
			<!-- 등록 버튼 -->
			<button type="submit" class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white" 
			        style="width:75px; float: right;">등록	</button>
			</form:form>

	    </section>
    </div>
  </main>
	<script src="/js/fault/faultWrite.js"></script>
	
	<!-- SweetAlert2 -->
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	
	<!-- Bootstrap 5.3.8 -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
	


</html>