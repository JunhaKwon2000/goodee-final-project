<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>재고</title>
	<style type="text/css">
		.sidenav .nav-link {
		  white-space: nowrap; /* 줄바꿈 방지 */
		}

		table tbody tr:hover {
			cursor: pointer;
	    }
		.pagination li:hover {
			cursor: pointer;
	    }
	
	</style>
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
			        <a class="nav-link text-dark" href="/product">
			          <i class="material-symbols-rounded opacity-5 fs-5" data-content="물품 리스트">remove_shopping_cart</i>
			          <span class="nav-link-text ms-1 text-sm">물품 리스트</span>
			        </a>
			      </li>

			      <li class="nav-item">
			        <a class="nav-link text-dark" href="/productManage">
			          <i class="material-symbols-rounded opacity-5 fs-5" data-content="물품관리대장">remove_shopping_cart</i>
			          <span class="nav-link-text ms-1 text-sm">물품관리대장</span>
			        </a>
			      </li>

			    </ul>
			  </div>
    	</aside>

	    <section class="flex-grow-1 border-radius-xl bg-white ms-2 mt-2 me-3" style="height: 92vh ; overflow: auto;">

	    <div class="mt-3" style="min-height: 500px;">
	    	<div class="col-10 offset-1">
			    <div class="d-flex justify-content-between align-items-end mt-4 mb-4">
		    		<div>총 &nbsp;${productList.totalElements } 건</div>
					<div class="input-group w-25">
						<input type="text" class="form-control" id="searchText" value="${ requestScope.search }" style="width: 200px; height: 30px; border-radius: 0.375rem 0 0 0.375rem !important;" >
						<button class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white p-0 m-0" type="button" onclick="movePage()" style="width: 50px; height: 30px;" >검색</button>
					</div>
				</div>
	    		<table class="table table-hover text-center">
	    			<thead>
	    				<tr>
	    					<th class="col-1">물품번호</th>
	    					<th class="col-2">물품타입</th>
	    					<th class="col-2">물품명</th>
	    					<th class="col-2">규격</th>
	    					<th class="col-1">재고수량</th>
	    				</tr>
	    			</thead>
	    			<tbody>

	    				<c:forEach var="product" items="${ productList.content }">
	    					<tr>
		    					<td>${ product.productCode }</td>
		    					<td>${ product.productTypeDTO.productTypeName}</td>
		    					<td><a data-bs-toggle="modal" data-bs-target="#productDetailModal" href="/product/${ product.productCode }" style="color: #737373;">${ product.productName }</a></td>
		    					<td>${ product.productSpec}</td>
		    					<td><fmt:formatNumber value="${ product.productAmount }" type="number" /></td>
	    					</tr>
	    				</c:forEach>

	    			</tbody>
	    		</table>
	    		
			    <c:if test="${ productList.totalElements eq 0 }">
					<div class="d-flex flex-column justify-content-center align-items-center mt-8">
	  	<img width="150" height="180" src="/images/nothing.png" />
	  	<h4 class="mt-5">검색 결과가 없습니다.</h4>
	  </div>
				</c:if>
				
			    <div class="d-flex justify-content-center aling-items-center">
			    	<c:if test="${productList.content.size() gt 0}">
				    	<nav aria-label="Page navigation example">
						  <ul class="pagination">
						    <c:if test="${ productList.number - 2 ge 0 }">
							    <li class="page-item">
							      <a class="page-link" onclick="movePage('${ productList.number - 2 }')" aria-label="Previous">
							        <span aria-hidden="true">&laquo;</span>
							      </a>
							    </li>
						    </c:if>
						    <c:if test="${ productList.hasPrevious() }">
							    <li class="page-item"><a class="page-link" onclick="movePage('${ productList.number - 1 }')">${ productList.number }</a></li>
						    </c:if>
						    <li class="page-item"><a class="page-link active" onclick="movePage('${ productList.number }')">${ productList.number + 1 }</a></li>
						    <c:if test="${ productList.hasNext() }">
							    <li class="page-item"><a class="page-link" onclick="movePage('${ productList.number + 1 }')">${ productList.number + 2 }</a></li>
						    </c:if>
						    <c:if test="${ productList.number + 2 le productList.totalPages - 1 }">
							    <li class="page-item">
							      <a class="page-link" onclick="movePage('${ productList.number + 2 }')" aria-label="Next">
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
					    <button onclick="location.href='/product/write'" class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white me-3">등록</button>
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
		<div class="modal fade" id="productDetailModal" tabindex="-1" aria-hidden="true">	    
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">물품 상세</h4>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					
					<div class="modal-body">
						<div class="text-center mb-3" id="productDetailAttach">
						
						</div>
						<div class="d-flex justify-content-center">
							<table class="text-start table">
								
								<tbody id="productDetailTable">
								
								</tbody>
							</table>
						</div>
						
						<div class="mt-4 d-flex justify-content-center gap-1" id="productModalButtons">
							<button id="productUpdateBtn" class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white me-3">수정</button>
	  						<form id="productDeleteForm" method="post">
							    <button type="submit" class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white me-3">삭제</button>
							</form>
						</div>
						
					</div>
				</div>
			</div>
		</div>

	    </section>
    </div>
  </main>
	<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
	<script src="/js/product/list.js"></script>
	<script src="/js/product/detail.js"></script>
	<script>
		document.querySelector("i[data-content='재고']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("i[data-content='물품 리스트']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("#navTitle").textContent = "물품 리스트"
	</script>
	<script>
	const loginStaffCode = "${staffDTO.staffCode}";
	console.log(loginStaffCode);
	</script>
</body>