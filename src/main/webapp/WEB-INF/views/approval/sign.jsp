<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>서명 등록</title>
	
	<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
</head>

<body class="g-sidenav-show bg-gray-100 d-flex justify-content-center align-items-center" style="width: 300px; height: 400px; overflow: hidden; background-color: white !important;">
	<sec:authentication property="principal" var="staff" />

	<form id="signForm">
		<div class="d-flex flex-column justify-content-center align-items-center">
			<div>
				<label for="attach">
	 				<img id="preview" width="250" height="250" style="object-fit: cover;" <c:if test="${ not empty staff.staffSignDTO }">src="/file/sign/${ staff.staffSignDTO.attachmentDTO.savedName }"</c:if> class="border border-1 border-dark p-1" />
				</label>
				<input type="file" class="d-none" id="attach" name="attach" />
			</div>
			
			<div class="form-group row mt-5 d-flex justify-content-center align-items-center">
 				<button type="button" class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white me-3" onclick="changeSign()" style="width: 100px;">${ empty staff.staffSignDTO ? "등록" : "수정" }</button>
 				<button type="button" class="btn btn-sm btn-outline-secondary" onclick="window.close()" style="width: 100px;">취소</button>
 			</div> 
		</div>
	</form>

	
	
	
	
	
	<!-- Popper.js -->
	<script src="https://unpkg.com/@popperjs/core@2"></script>
	
	<!-- Bootstrap 5.3.8 -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
	
	<!-- SweetAlert 2 -->
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.23.0/dist/sweetalert2.all.min.js"></script>
	
	<!-- Template JS -->
	<script src="/js/material-dashboard.js"></script>
	
	<script src="/js/approval/sign.js"></script>
</body>

</html>