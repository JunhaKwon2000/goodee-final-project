<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>어트랙션</title>
	<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
	
	<style>
	/* 테이블 밑줄 제거 */
	  .ride-info table {
	    border-collapse: collapse; /* 기본 여백 제거 */
	  }
	
	  .ride-info th,
	  .ride-info td {
	    border: none !important; /* 밑줄(테두리) 제거 */
	  }
	
	  .ride-info tr {
	    border-bottom: none !important; /* 각 행 밑줄 제거 */
	  }
	  
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
	    <div class="row">
        <div class="col-10">
		  <!-- 레일형 / 고속형 어트랙션 -->
          <div class="card my-4 mt-8 m-8">
			  <div class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 w-50">
			    <div class="bg-gradient-dark shadow-dark border-radius-lg pt-3 pb-2">
			      <h3 class="text-white text-capitalize text-center"> ${ride.rideName } </h3>
			    </div>
			  </div>
		  
			  <div class="card-body mt-4">
				  <div class="row ride-content">
				    
				    <!-- 왼쪽: 어트랙션 이미지 -->
				    <div class="col-md-6 text-center p-0 ms-3" style="width: 400px; height: 400px; border: 1px solid black; overflow: hidden;">
				      <img width="400" height="400" alt="" 
				           src="/file/ride/${ ride.rideAttachmentDTO.attachmentDTO.savedName }" 
				           style="object-fit:cover;">
				    </div>
				
				    <!-- 오른쪽: 상세 정보 -->
				    <div class="col-md-6 ride-info ms-3">
				      <table class="table">
				        <tr>
				          <th>어트랙션 코드  </th>
				          <td>|&nbsp;&nbsp;${ride.rideCode}</td>
				        </tr>
				        <tr>
				          <th>담당자</th>
				          <td>|&nbsp;&nbsp;${ride.staffDTO.staffName} (${ride.staffDTO.staffCode})</td>
				        </tr>
				        <tr>
				          <th>어트랙션 기종</th>
				          <td>|&nbsp;&nbsp;${ride.rideType}</td>
				        </tr>
				        <tr>
				          <th>탑승인원</th>
				          <td>|&nbsp;&nbsp;${ride.rideCapacity}</td>
				        </tr>
				        <tr>
				          <th>운행시간</th>
				          <td>|&nbsp;&nbsp;${ride.rideDuration}</td>
				        </tr>
				        <tr>
				          <th>이용정보</th>
				          <td>|&nbsp;&nbsp;${ride.rideRule}</td>
				        </tr>
				        <tr>
				          <th>어트랙션 설명</th>
				          <td>|&nbsp;&nbsp;${ride.rideInfo}</td>
				        </tr>
				        <tr>
				          <th>개장일</th>
				          <td>|&nbsp;&nbsp;${ride.rideDate}</td>
				        </tr>
				        <tr>
				          <th>운행상태</th>
				          <c:if test="${ ride.rideState eq 200 }">
							<td>|&nbsp;&nbsp;운영(${ride.rideState })</td>
						  </c:if>
						  <c:if test="${ ride.rideState eq 300 }">
							<td>|&nbsp;&nbsp;운휴(${ride.rideState })</td>
						  </c:if>
						  <c:if test="${ ride.rideState eq 400 }">
							<td>|&nbsp;&nbsp;고장(${ride.rideState })</td>
						  </c:if>
						  <c:if test="${ ride.rideState eq 500 }">
							<td>|&nbsp;&nbsp;점검(${ride.rideState })</td>
						  </c:if>
				        </tr>
				      </table>
				    </div>
				  </div>
			</div>
			
			<!-- 버튼 --><!-- 로그인 사용자 정보 꺼내기 -->
			<sec:authorize access="isAuthenticated()">
			<sec:authentication property="principal" var="staff" />
			
			<!-- 시설부서(deptCode == 1003)일 때만 등록 버튼 보이기 -->
			<c:if test="${staff.deptDTO.deptCode eq 1003}">
			    <div class="form-group row my-3 text-end">
			      <div class="col-sm-11">
			      	<!-- 수정 버튼 -> add 페이지로가는데 입력된 정보 가지고 감 -->
			      	<form action="${pageContext.request.contextPath }/ride/${ride.rideCode}/update"
			      			method="get" style="display: inline;">
				        <button type="submit" 
				        		class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white me-3" 
				        		style="width: 75px; font-size:15px;">수정</button>
			        </form>
			        <!-- 삭제 버튼 -->
			        <button type="button" 
			                class="btn btn-sm btn-outline-secondary" 
			                style="width: 75px; font-size:15px;"
			                onclick="ridedelete('${ ride.rideCode }')">삭제</button>
			      </div>
			    </div>
		    </c:if>
		    </sec:authorize>
			
			
		  </div>
        </div>
	  </div>  
	    
	    </section>
    </div>
  </main>
	<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
	<script src="/js/ride/rideDetail.js"></script>
	<script>
		document.querySelector("i[data-content='어트랙션']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("i[data-content='어트랙션 목록']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("#navTitle").textContent = "어트랙션 목록"
	</script>
</body>

</html>