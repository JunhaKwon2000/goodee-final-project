<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
</head>

<body class="g-sidenav-show bg-gray-100">
	<c:import url="/WEB-INF/views/common/sidebar.jsp"></c:import>
  
  <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
    <c:import url="/WEB-INF/views/common/nav.jsp"></c:import>
    <div class="d-flex">
    	<aside class="sidenav navbar navbar-vertical border-radius-lg ms-2 bg-white my-2 w-10 align-items-start" style="height: 92vh;">
    		<div class="w-100">
			    <ul class="navbar-nav">
			    
			      <li class="nav-item">
			        <a class="nav-link text-dark" href="/staff/regist">
			          <i class="material-symbols-rounded opacity-5 fs-5" data-content="사원 등록">diversity_3</i>
			          <span class="nav-link-text ms-1 text-sm">사원 등록</span>
			        </a>
			      </li>
			      
			      <li class="nav-item">
			        <a class="nav-link text-dark" href="/staff">
			          <i class="material-symbols-rounded opacity-5 fs-5" data-content="사원 조회">diversity_3</i>
			          <span class="nav-link-text ms-1 text-sm">사원 조회</span>
			        </a>
			      </li>
			      
			      <li class="nav-item">
			        <a class="nav-link text-dark" href="#">
			          <i class="material-symbols-rounded opacity-5 fs-5" data-content="연차 현황">diversity_3</i>
			          <span class="nav-link-text ms-1 text-sm">연차 현황</span>
			        </a>
			      </li>
			      
			      <li class="nav-item">
			        <a class="nav-link text-dark" href="#">
			          <i class="material-symbols-rounded opacity-5 fs-5" data-content="퇴사자 조회">diversity_3</i>
			          <span class="nav-link-text ms-1 text-sm">퇴사자 조회</span>
			        </a>
			      </li>
			      
			      <li class="nav-item">
			        <a class="nav-link text-dark" href="#">
			          <i class="material-symbols-rounded opacity-5 fs-5" data-content="휴가 사용 내역">diversity_3</i>
			          <span class="nav-link-text ms-1 text-sm">휴가 사용 내역</span>
			        </a>
			      </li>
			      
			      <li class="nav-item">
			        <a class="nav-link text-dark" href="#">
			          <i class="material-symbols-rounded opacity-5 fs-5" data-content="연장근무 내역">diversity_3</i>
			          <span class="nav-link-text ms-1 text-sm">연장근무 내역</span>
			        </a>
			      </li>
			      
			      <li class="nav-item">
			        <a class="nav-link text-dark" href="#">
			          <i class="material-symbols-rounded opacity-5 fs-5" data-content="조기 퇴근 내역">diversity_3</i>
			          <span class="nav-link-text ms-1 text-sm">조기 퇴근 내역</span>
			        </a>
			      </li>
			      
			    </ul>
			  </div>
    	</aside>
	    <section class="border-radius-xl bg-white w-90 ms-2 mt-2 me-3" style="height: 92vh; overflow: hidden scroll;">
	    	<div class="mt-5">
	    		<div class="col-8 offset-2 d-flex gap-2">
	    			<div class="col-2 rounded" style="border: 1px solid #686868; height: 100px; box-shadow: 2px 2px 5px gray;">
	    				<p class="text-start ms-3 mt-2 mb-0" style="color: #686868; font-weight: 700;">정원</p>
	    				<p class="text-end me-3 mt-2" style="color: #686868; font-weight: 700; font-size: 35px;">35</p>
	    			</div>
	    			
	    			<div class="col-2 rounded" style="border: 1px solid #686868; height: 100px; box-shadow: 2px 2px 5px gray;">
	    				<p class="text-start ms-3 mt-2 mb-0" style="color: #686868; font-weight: 700;">근무</p>
	    				<p class="text-end me-3 mt-2" style="color: #686868; font-weight: 700; font-size: 35px;">35</p>
	    			</div>
	    			
	    			<div class="col-2 rounded" style="border: 1px solid #686868; height: 100px; box-shadow: 2px 2px 5px gray;">
	    				<p class="text-start ms-3 mt-2 mb-0" style="color: #686868; font-weight: 700;">연차</p>
	    				<p class="text-end me-3 mt-2" style="color: #686868; font-weight: 700; font-size: 35px;">35</p>
	    			</div>
	    			
	    			<div class="col-2 rounded" style="border: 1px solid #686868; height: 100px; box-shadow: 2px 2px 5px gray;">
	    				<p class="text-start ms-3 mt-2 mb-0" style="color: #686868; font-weight: 700;">결근</p>
	    				<p class="text-end me-3 mt-2" style="color: #686868; font-weight: 700; font-size: 35px;">35</p>
	    			</div>
	    			
	    			<div class="col-4">
	    				
	    			</div>
	    		</div>
	    	</div>
	    
		    <div class="mt-3">
		    	<div class="col-8 offset-2">
		    		<table class="table text-center">
		    			<thead>
		    				<tr>
		    					<th class="col-2">사원번호</th>
		    					<th class="col-2">이름</th>
		    					<th class="col-2">부서</th>
		    					<th class="col-1">직위</th>
		    					<th class="col-3">연락처</th>
		    					<th class="col-2">상태</th>
		    				</tr>
		    			</thead>
		    			<tbody>
		    				
		    				<c:forEach var="staff" items="${ staffList.content }">
		    					<tr>
			    					<td>${ staff.staffCode }</td>
			    					<td><a href="/staff/${ staff.staffCode }" style="color: #737373;">${ staff.staffName }</a></td>
			    					<td>${ staff.deptDTO.deptDetail }</td>
			    					<td>${ staff.jobDTO.jobDetail }</td>
			    					<td>${ staff.staffPhone }</td>
			    					<td></td>
		    					</tr>
		    				</c:forEach>
		    				
		    			</tbody>
		    		</table>
		    	</div>
		    </div>
		    
		    
	    
	    </section>
    </div>
  </main>
	<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
	<script>
		document.querySelector("i[data-content='사원']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("i[data-content='사원 조회']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("#navTitle").textContent = "사원 조회"
	</script>
</body>

</html>