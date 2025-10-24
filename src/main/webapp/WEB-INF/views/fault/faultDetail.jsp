<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>어트랙션 고장 신고 목록</title>
	<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
	
	<style>
	  /* 테이블 밑줄 제거 */
	  .fault-info table {
	    border-collapse: collapse;
	  }
	
	  .fault-info th,
	  .fault-info td {
	    border: none !important;
	  }
	
	  .fault-info tr {
	    border-bottom: none !important;
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
			  <!--  -->
	          <div class="card my-4 mt-8 m-8">
				  <div class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 w-50">
				    <div class="bg-gradient-dark shadow-dark border-radius-lg pt-3 pb-2">
				      <h3 class="text-white text-capitalize text-center"> ${ fault.rideDTO.rideName } 고장 신고 기록 </h3>
				    </div>
				  </div>
			  
				  <div class="card-body mt-4">
					  <div class="row inspection-content">
					    
					    <!-- 왼쪽: 어트랙션 고장 신고 이미지 -->
						<div class="col-md-6 text-center ms-3" 
						     style="width:400px; height:400px; border:1px solid #ccc; display:flex; align-items:center; justify-content:center;">
						  <c:choose>
						    <c:when test="${not empty fault.faultAttachmentDTO}">
						      <img alt="고장 신고 이미지"
						           src="/file/fault/${fault.faultAttachmentDTO.attachmentDTO.savedName}"
						           style="width:100%; height:100%; object-fit:cover;">
						    </c:when>
						    <c:otherwise>
						      <span class="text-muted">등록된 이미지가 없습니다</span>
						    </c:otherwise>
						  </c:choose>
						</div>

					
					    <!-- 오른쪽: 상세 정보 -->
					    <div class="col-md-6 fault-info ms-3">
					      <table class="table">
					        <tr>
					          <th>어트랙션 코드</th>
					          <td>|&nbsp;&nbsp;${fault.rideDTO.rideName }(${ fault.rideDTO.rideCode })</td>
					        </tr>
					        <tr>
					          <th>어트랙션 기종</th>
					          <td>|&nbsp;&nbsp;${ fault.rideDTO.rideType }</td>
					        </tr>
					        <tr>
					         	<th>신고 제목</th>
					        	<td>|&nbsp;&nbsp;${ fault.faultTitle }</td>
					        </tr>
					        <tr>
					         	<th>신고 내용</th>
					        	<td style="word-wrap: break-word; overflow-wrap: break-word; white-space: normal;">|&nbsp;&nbsp;${ fault.faultContent }</td>
					        </tr>
					        <tr>
					          <th>담당자</th>
					          <td>|&nbsp;&nbsp;${ fault.staffDTO.staffName } (${ fault.staffDTO.staffCode })</td>
					        </tr>
							<tr>
					          <th>고장 신고 날짜</th>
					          <td>|&nbsp;&nbsp;${ fault.faultDate }</td>
					        </tr>
					        <tr>
					          <th>신고 상태</th>
					          <c:if test="${ fault.faultState eq 410 }"> 
					          	<td>|&nbsp;&nbsp;신고접수</td>
					          </c:if> 
 					          <c:if test="${ fault.faultState eq 411 }">
					          	<td>|&nbsp;&nbsp;담당자 배정</td>
					          </c:if>
					          <c:if test="${ fault.faultState eq 412 }">
					          	<td>|&nbsp;&nbsp;수리중</td>
					          </c:if>
					          <c:if test="${ fault.faultState eq 420 }">
					          	<td>|&nbsp;&nbsp;수리완료</td>
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
				      	<form action="${pageContext.request.contextPath }/fault/${ fault.faultNum }/update"
				      			method="get" style="display: inline;">
					        <button type="submit" 
					        		class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white me-3" 
					        		style="width:75px;">수정</button>
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
				
				
			  </div>
	        </div>
	  		</div>  

	    
	    </section>
    </div>
  </main>
	<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
	<script src="/js/fault/faultDetail.js"></script>
	<script>
		document.querySelector("i[data-content='어트랙션']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("i[data-content='고장 신고 목록']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("#navTitle").textContent = "고장 신고 목록"
	</script>
</body>

</html>