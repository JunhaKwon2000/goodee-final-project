<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>주소록</title>
	<style type="text/css">
		.sidenav .nav-link {
  white-space: nowrap; /* 줄바꿈 방지 */
}
	</style>
	<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
</head>

<body class="g-sidenav-show bg-gray-100">
	<c:import url="/WEB-INF/views/common/sidebar.jsp"></c:import>

  <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
    <c:import url="/WEB-INF/views/common/nav.jsp"></c:import>
    <div class="d-flex">
    <c:import url="/WEB-INF/views/address/address-sidebar.jsp"></c:import>

	    <section class="flex-grow-1 border-radius-xl bg-white ms-2 mt-2 me-3" style="height: 92vh ; overflow: auto;">


	    <div class="mt-3" style="min-height: 500px;">
		    	<div class="col-10 offset-1">
				    <div class="d-flex justify-content-between align-items-end mt-4 mb-4">
		    		<div>총 &nbsp;${addressList.totalElements } 건</div>
						<div class="input-group w-25">
							<input type="text" class="form-control" id="searchText" value="${ requestScope.search }" style="width: 200px; height: 30px; border-radius: 0.375rem 0 0 0.375rem !important;" >
							<button class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white p-0 m-0" type="button" onclick="movePage()" style="width: 50px; height: 30px;" >검색</button>
						</div>
					</div>
		    		<table class="table table-hover text-center">
		    			<thead>
		    				<tr>
		    					<th class="col-1">사원번호</th>
		    					<th class="col-1">이름</th>
		    					<th class="col-1">부서</th>
		    					<th class="col-1">직위</th>
		    					<th class="col-2">연락처</th>
		    					<th class="col-2">이메일</th>
		    				</tr>
		    			</thead>
		    			
		    			<tbody>
		    				<c:forEach var="address" items="${ addressList.content }">
		    					<tr>
			    					<td>${ address.staffCode }</td>
			    					<td>${ address.staffName }</td>
			    					<td>${ address.deptDTO.deptDetail}</td>
			    					<td>${ address.jobDTO.jobDetail }</td>
			    					<td>${ address.staffPhone }</td>
			    					<td>${ address.staffEmail }</td>
		    					</tr>
		    				</c:forEach>
		    			</tbody>
		    		</table>
		    		
				    <c:if test="${ addressList.totalElements eq 0 }">
					     <div class="alert alert-secondary text-center" style="color: white;">검색된 결과가 없습니다.</div>
					</c:if>
			
		    	</div>
		    </div>

	    <div class="d-flex justify-content-center aling-items-center">
			    	<nav aria-label="Page navigation example">
						  <ul class="pagination">
						    <c:if test="${ addressList.number - 2 ge 0 }">
							    <li class="page-item">
							      <a class="page-link" onclick="movePage('${ addressList.number - 2 }')" aria-label="Previous">
							        <span aria-hidden="true">&laquo;</span>
							      </a>
							    </li>
						    </c:if>
						    <c:if test="${ addressList.hasPrevious() }">
							    <li class="page-item"><a class="page-link" onclick="movePage('${ addressList.number - 1 }')">${ addressList.number }</a></li>
						    </c:if>
						    <li class="page-item"><a class="page-link active" onclick="movePage('${ addressList.number }')">${ addressList.number + 1 }</a></li>
						    <c:if test="${ addressList.hasNext() }">
							    <li class="page-item"><a class="page-link" onclick="movePage('${ addressList.number + 1 }')">${ addressList.number + 2 }</a></li>
						    </c:if>
						    <c:if test="${ addressList.number + 2 le addressList.totalPages - 1 }">
							    <li class="page-item">
							      <a class="page-link" onclick="movePage('${ addressList.number + 2 }')" aria-label="Next">
							        <span aria-hidden="true">&raquo;</span>
							      </a>
							    </li>
						    </c:if>
						  </ul>
						</nav>
			    </div>

	    </section>
    </div>
  </main>
	<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
	<script src="/js/address/list.js"></script>
	<script>
		document.querySelector("i[data-content='주소록']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("i[data-content='${ deptSelected }']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("#navTitle").textContent = "주소록"
	</script>
</body>