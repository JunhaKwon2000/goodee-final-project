<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>전자결재</title>
	
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
			    
			      <li class="nav-item">
			        <a class="nav-link text-dark" href="/approval/draft">
			          <i class="material-symbols-rounded opacity-5 fs-5" data-content="기안 작성">fact_check</i>
			          <span class="nav-link-text ms-1 text-sm">기안 작성</span>
			        </a>
			      </li>
			      
			      <li class="nav-item">
			        <a class="nav-link text-dark" href="/approval?page=0">
			          <i class="material-symbols-rounded opacity-5 fs-5" data-content="내 결재함">fact_check</i>
			          <span class="nav-link-text ms-1 text-sm">내 결재함</span>
			        </a>
			      </li>
			      
			      <li class="nav-item">
			        <a class="nav-link text-dark" href="/approval/recept?page=0">
			          <i class="material-symbols-rounded opacity-5 fs-5" data-content="내 수신함">fact_check</i>
			          <span class="nav-link-text ms-1 text-sm">내 수신함</span>
			        </a>
			      </li>
			      
			      <li class="nav-item">
			        <a class="nav-link text-dark" onclick="openApprovalSign()">
			          <i class="material-symbols-rounded opacity-5 fs-5" data-content="서명 등록">fact_check</i>
			          <span class="nav-link-text ms-1 text-sm">서명 등록</span>
			        </a>
			      </li>
			      
			    </ul>
			  </div>
    	</aside>
	    <section class="border-radius-xl bg-white w-90 ms-2 mt-2 me-3" style="height: 92vh; overflow: hidden scroll;">
	    
		    <div class="mt-5">
	    		<div class="col-10 offset-1 d-flex justify-content-end">
	    			<div class="d-flex justify-content-end align-items-end">
    					<div class="input-group">
							  <input type="text" class="form-control" id="searchText" value="${ requestScope.search }" style="width: 200px; height: 30px; border-radius: 0.375rem 0 0 0.375rem !important;" >
							  <button class="btn bg-gradient-dark text-white p-0 m-0" type="button" onclick="movePage()" style="width: 50px; height: 30px;" >검색</button>
							</div>
	    			</div>
	    		</div>
	    	</div>
	    
		    <div class="mt-3" style="min-height: 500px;">
		    	<div class="col-10 offset-1">
		    		<table class="table text-center">
		    			<thead>
		    				<tr>
		    					<th class="col-1">문서번호</th>
		    					<th class="col-5">제목</th>
		    					<th class="col-1">기안자</th>
		    					<th class="col-1">부서</th>
		    					<th class="col-2">기안일</th>
		    					<th class="col-2">시행일</th>
		    				</tr>
		    			</thead>
		    			<tbody>
		    				
		    				<c:forEach var="aprv" items="${ approvalList.content }">
		    					<tr>
			    					<td>${ aprv.aprvCode }</td>
			    					<td><a href="/approval/${ aprv.aprvCode }" style="color: #737373;">${ aprv.aprvTitle }</a></td>
			    					<td>${ aprv.staffName }</td>
			    					<td>${ aprv.deptDetail }</td>
			    					<td>${ aprv.aprvDate }</td>
			    					<td>${ aprv.aprvExe }</td>
		    					</tr>
		    				</c:forEach>
		    				
		    			</tbody>
		    		</table>
		    	</div>
		    </div>
		    
		    <div class="d-flex justify-content-center aling-items-center">
		    	<nav aria-label="Page navigation example">
					  <ul class="pagination">
					    <c:if test="${ approvalList.number - 2 ge 0 }">
						    <li class="page-item">
						      <a class="page-link" onclick="movePage('${ approvalList.number - 2 }')" aria-label="Previous">
						        <span aria-hidden="true">&laquo;</span>
						      </a>
						    </li>
					    </c:if>
					    <c:if test="${ approvalList.hasPrevious() }">
						    <li class="page-item"><a class="page-link" onclick="movePage('${ approvalList.number - 1 }')">${ approvalList.number }</a></li>
					    </c:if>
					    <li class="page-item"><a class="page-link active" onclick="movePage('${ approvalList.number }')">${ approvalList.number + 1 }</a></li>
					    <c:if test="${ approvalList.hasNext() }">
						    <li class="page-item"><a class="page-link" onclick="movePage('${ approvalList.number + 1 }')">${ approvalList.number + 2 }</a></li>
					    </c:if>
					    <c:if test="${ approvalList.number + 2 le approvalList.totalPages - 1 }">
						    <li class="page-item">
						      <a class="page-link" onclick="movePage('${ approvalList.number + 2 }')" aria-label="Next">
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
	<script src="/js/approval/list.js"></script>
	<script>
		document.querySelector("i[data-content='전자결재']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("i[data-content='내 수신함']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("#navTitle").textContent = "내 수신함"
		
		function openApprovalSign() {
			window.open("/approval/sign", "_blank", "width=300, height=400, top=250, left=400, menubar=no, toolbar=no, location=no, status=no")
		}
	</script>
</body>

</html>