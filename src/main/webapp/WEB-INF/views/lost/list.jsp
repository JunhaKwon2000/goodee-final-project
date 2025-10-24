<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>

<style>
	
	table tbody tr:hover {
		cursor: pointer;
    }
	.pagination li:hover {
		cursor: pointer;
    }
	
</style>

<head>
	<meta charset="UTF-8">
	<title>분실물</title>
	
	<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
</head>

<body class="g-sidenav-show bg-gray-100">
	<c:import url="/WEB-INF/views/common/sidebar.jsp"></c:import>
  
  <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
    <c:import url="/WEB-INF/views/common/nav.jsp"></c:import>
    <section class="border-radius-xl bg-white ms-2 mt-2 me-3" style="height: 92vh; overflow: hidden scroll;">
    
    <div class="mt-3" style="min-height: 500px;">
    	<div class="col-10 offset-1">
		    <div class="d-flex justify-content-between align-items-end mt-4 mb-4">
		   		<div>총 &nbsp;${lostList.totalElements } 건</div>
		   		
				<div class="d-flex align-items-center">
				
					<div class="col-auto">
				      <input type="date" name="startDate" id="startDate" class="form-control" value="${startDate}" style="width: 150px;">
				    </div>
				    <div>~</div>
				    <div class="col-auto me-2">
				      <input type="date" name="endDate" id="endDate" class="form-control" value="${endDate}" style="width: 150px;">
				    </div>
				    
					<div class="input-group" style="width: 250px;">
						<input type="text" class="form-control" id="searchText" value="${ requestScope.search }" placeholder="분실물명 또는 작성자" style="width: 200px; height: 30px; border-radius: 0.375rem 0 0 0.375rem !important;" >
						<button class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white p-0 m-0" type="button" onclick="movePage()" style="width: 50px; height: 30px;" >검색</button>
					</div>
					
				</div>
			</div>
    		<table class="table table-hover text-center">
    			<thead>
    				<tr>
    					<th class="col-1">관리번호</th>
    					<th class="col-3">분실물명</th>
    					<th class="col-1">작성자</th>
    					<th class="col-1">연락처</th>
    					<th class="col-1">등록일자</th>
    				</tr>
    			</thead>
    			<tbody>
    				
    				<c:forEach var="lost" items="${ lostList.content }">
    					<tr>
	    					<td>${ lost.lostNum }</td>
	    					<td><a data-bs-toggle="modal" data-bs-target="#lostDetailModal" href="/lost/${ lost.lostNum }" style="color: #737373;">${ lost.lostName }</a></td>
	    					<td>${ lost.staffDTO.staffName }</td>
	    					<td>${ lost.staffDTO.staffPhone }</td>
	    					<td>${ lost.lostDate }</td>
    					</tr>
    				</c:forEach>
    				
    			</tbody>
    		</table>
    
		     <c:if test="${ lostList.totalElements eq 0 }">
		        <div class="d-flex flex-column justify-content-center align-items-center mt-8">
	  	<img width="150" height="180" src="/images/nothing.png" />
	  	<h4 class="mt-5">검색 결과가 없습니다.</h4>
	  </div>
		    </c:if>
    	
	    	<div class="d-flex justify-content-center aling-items-center">
	   			<c:if test="${lostList.content.size() gt 0}">
			    	<nav aria-label="Page navigation example">
					  <ul class="pagination">
					    <c:if test="${ lostList.number - 2 ge 0 }">
						    <li class="page-item">
						      <a class="page-link" onclick="movePage('${ lostList.number - 2 }')" aria-label="Previous">
						        <span aria-hidden="true">&laquo;</span>
						      </a>
						    </li>
					    </c:if>
					    <c:if test="${ lostList.hasPrevious() }">
						    <li class="page-item"><a class="page-link" onclick="movePage('${ lostList.number - 1 }')">${ lostList.number }</a></li>
					    </c:if>
					    <li class="page-item"><a class="page-link active" onclick="movePage('${ lostList.number }')">${ lostList.number + 1 }</a></li>
					    <c:if test="${ lostList.hasNext() }">
						    <li class="page-item"><a class="page-link" onclick="movePage('${ lostList.number + 1 }')">${ lostList.number + 2 }</a></li>
					    </c:if>
					    <c:if test="${ lostList.number + 2 le lostList.totalPages - 1 }">
						    <li class="page-item">
						      <a class="page-link" onclick="movePage('${ lostList.number + 2 }')" aria-label="Next">
						        <span aria-hidden="true">&raquo;</span>
						      </a>
						    </li>
					    </c:if>
					  </ul>
					</nav>
				</c:if>
		    </div>
				
			<c:if test="${staffDTO.deptDTO.deptCode eq 1002}">	
				<div class="d-flex justify-content-end aling-items-end">
					<div>
			    		<button onclick="location.href='/lost/write'" class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white me-3">등록</button>
		   			</div>
		   			<button class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white ms-2"
					        onclick="downloadExcel()">
					    Excel
					</button>
				</div>
			</c:if>
    	</div>
    </div>
		    
	<!-- 모달창 내용 -->
	<div class="modal fade" id="lostDetailModal" tabindex="-1" aria-hidden="true">	    
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">분실물 상세</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				
				<div class="modal-body">
					<div class="text-center mb-3" id="lostDetailAttach">
					
					</div>
					<div class="d-flex justify-content-center">
						<table class="text-start table" style="width: 80%;">
							
							<tbody id="lostDetailTable">
							
							</tbody>
						</table>
					</div>
					
					<div class="mt-4 d-flex justify-content-center gap-1 d-none" id="lostModalButtons" style="display: none;">
						<button id="lostUpdateBtn" class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white me-3">수정</button>
  						<form id="lostDeleteForm" method="post">
						    <button type="submit" class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white me-3">삭제</button>
						</form>
					</div>
					
				</div>
			</div>
		</div>
	</div>
    </section>
  </main>
	<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
	<script src="/js/lost/list.js"></script>
	<script src="/js/lost/detail.js"></script>
	<script>
		document.querySelector("i[data-content='분실물']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("#navTitle").textContent = "분실물"
	</script>
	<script>
	const loginStaffCode = "${staffDTO.staffCode}";
	</script>
</body>

</html>