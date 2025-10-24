<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>어트랙션</title>
	
	<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
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
        <div class="col-12">
		  <!-- 레일형 / 고속형 어트랙션 -->
          <div class="card my-4 mt-6 m-8">
			  <div class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 w-25">
			    <div class="bg-gradient-dark shadow-dark border-radius-lg pt-3 pb-2 ">
			      <h4 class="text-white text-capitalize text-center">레일형 어트랙션</h4>
			    </div>
			  </div>
		  
			  <div class="card-body">
			    <div class="row">
			      <c:forEach var="ride" items="${railRides}">
			        <div class="col-md-4 col-sm-6 mb-4 text-center">
			          <!-- DB에서 불러온 이미지 -->
			          <a href="${pageContext.request.contextPath }/ride/${ride.rideCode}">
			          <img alt="${ride.rideName}"
		         			src="/file/ride/${ ride.rideAttachmentDTO.attachmentDTO.savedName }"	
			               style="width:300px; height:300px; object-fit:cover; border-radius:8px;">
			          <!-- 어트랙션 이름 -> 클릭 시 상세페이지로 이동 -->
			          <div class="ride-name mt-2" style="font-size:20px;">
			          		${ride.rideName }
			          	</a>
			          </div>
			        </div>
			      </c:forEach>
			    </div>
			  </div>
		  </div>
		  
		  <!-- 회전형 어트랙션 -->
          <div class="card my-4 mt-6 m-8">
			  <div class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 w-25">
			    <div class="bg-gradient-dark shadow-dark border-radius-lg pt-3 pb-2">
			      <h4 class="text-white text-capitalize text-center">회전형 어트랙션</h4>
			    </div>
			  </div>
		  
			  <div class="card-body">
			    <div class="row">
			      <c:forEach var="ride" items="${rotationRides}">
			        <div class="col-md-4 col-sm-6 mb-4 text-center">
			          <!-- DB에서 불러온 이미지 -->
			          <a href="${pageContext.request.contextPath }/ride/${ride.rideCode}">
			          <img alt="${ride.rideName}"
		         			src="/file/ride/${ ride.rideAttachmentDTO.attachmentDTO.savedName }"	
			               style="width:300px; height:300px; object-fit:cover; border-radius:8px;">
			          <!-- 어트랙션 이름 -> 클릭 시 상세페이지로 이동 -->
			          <div class="ride-name mt-2" style="font-size:20px;">
			          		${ride.rideName }
			          	</a>
			          </div>
			        </div>
			      </c:forEach>
			    </div>
			  </div>
		  </div>
		  
		  <!-- 수상형 어트랙션 -->
          <div class="card my-4 mt-6 m-8">
			  <div class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 w-25">
			    <div class="bg-gradient-dark shadow-dark border-radius-lg pt-3 pb-2">
			      <h4 class="text-white text-capitalize text-center">수상형 어트랙션</h4>
			    </div>
			  </div>
		  
			  <div class="card-body">
			    <div class="row">
			      <c:forEach var="ride" items="${waterRides}">
			        <div class="col-md-4 col-sm-6 mb-4 text-center">
			          <!-- DB에서 불러온 이미지 -->
		          	  <a href="${pageContext.request.contextPath }/ride/${ride.rideCode}">
			          <img alt="${ride.rideName}"
		         			src="/file/ride/${ ride.rideAttachmentDTO.attachmentDTO.savedName }"	
			               style="width:300px; height:300px; object-fit:cover; border-radius:8px;">
			          <!-- 어트랙션 이름 -> 클릭 시 상세페이지로 이동 -->
			          <div class="ride-name mt-2" style="font-size:20px;">
			          		${ride.rideName }
			          	</a>
			          </div>
			        </div>
			      </c:forEach>
			    </div>
			  </div>
		  </div>
		  
		  <!-- 관람형 어트랙션 -->
          <div class="card my-4 mt-6 m-8">
			  <div class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 w-25">
			    <div class="bg-gradient-dark shadow-dark border-radius-lg pt-3 pb-2">
			      <h4 class="text-white text-capitalize text-center">관람형 어트랙션</h4>
			    </div>
			  </div>
		  
			  <div class="card-body">
			    <div class="row">
			      <c:forEach var="ride" items="${viewRides}">
			        <div class="col-md-4 col-sm-6 mb-4 text-center">
			          <!-- DB에서 불러온 이미지 -->
			          <a href="${pageContext.request.contextPath }/ride/${ride.rideCode}">
			          <img alt="${ride.rideName}"
		         			src="/file/ride/${ ride.rideAttachmentDTO.attachmentDTO.savedName }"	
			               style="width:300px; height:300px; object-fit:cover; border-radius:8px;">
			          <!-- 어트랙션 이름 -> 클릭 시 상세페이지로 이동 -->
			          <div class="ride-name mt-2" style="font-size:20px;">
			          		${ride.rideName }
			          	</a>
			          </div>
			        </div>
			      </c:forEach>
			    </div>
			  </div>
		  </div>
		  
		  <!-- 어린이 어트랙션 -->
          <div class="card my-4 mt-6 m-8">
			  <div class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 w-25">
			    <div class="bg-gradient-dark shadow-dark border-radius-lg pt-3 pb-2">
			      <h4 class="text-white text-capitalize text-center">어린이 어트랙션</h4>
			    </div>
			  </div>
		  
			  <div class="card-body">
			    <div class="row">
			      <c:forEach var="ride" items="${kidsRides}">
			        <div class="col-md-4 col-sm-6 mb-4 text-center">
			          <!-- DB에서 불러온 이미지 -->
			          <a href="${pageContext.request.contextPath }/ride/${ride.rideCode}">
			          <img alt="${ride.rideName}"
		         			src="/file/ride/${ ride.rideAttachmentDTO.attachmentDTO.savedName }"	
			               style="width:300px; height:300px; object-fit:cover; border-radius:8px;">
			          <!-- 어트랙션 이름 -> 클릭 시 상세페이지로 이동 -->
			          <div class="ride-name mt-2" style="font-size:20px;">
			          		${ride.rideName }
			          	</a>
			          </div>
			        </div>
			      </c:forEach>
			    </div>
			  </div>
		  </div>
    
		    
		  <!-- 로그인 사용자 정보 꺼내기 -->
		  <sec:authorize access="isAuthenticated()">
	     	  <sec:authentication property="principal" var="staff" />
			  
			  <!-- 시설부서(deptCode == 1003)일 때만 등록 버튼 보이기 -->
		      <c:if test="${staff.deptDTO.deptCode eq 1003}">
		        <div class="text-end me-8" style="margin-top:50px; margin-bottom:30px;">
		          <a href="${pageContext.request.contextPath}/ride/add"
		             class="btn btn-primary btn-sm btn-outline-secondary bg-gradient-dark text-white me-3"
		             style="width: 75px; font-size:15px;">등록</a>
		        </div>
		      </c:if>
		  </sec:authorize>
        </div>
     </div>
	    
	    </section>
    </div>
  </main>
	<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
	<script>
		document.querySelector("i[data-content='어트랙션']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("i[data-content='어트랙션 목록']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("#navTitle").textContent = "어트랙션 목록"
	</script>
</body>

</html>