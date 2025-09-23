<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<style type="text/css">
aside.sidenav {
  width: 225px !important;   /* 원하는 값 (180~220px 정도 추천) */
  min-width: 200px !important;
  max-width: 200px !important;
}
	
	</style>
	<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
</head>

<body class="g-sidenav-show bg-gray-100">
	<c:import url="/WEB-INF/views/common/sidebar.jsp"></c:import>
  
  <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
    <c:import url="/WEB-INF/views/common/nav.jsp"></c:import>
    <div class="d-flex">
    <aside class="sidenav navbar navbar-vertical border-radius-lg ms-2 bg-white my-2 w-10 align-items-start" style="width: 200px; height: 92vh;">
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
	    
	    <div class="d-flex justify-content-end align-items-end">
			<div class="input-group">
				<input type="text" class="form-control" id="searchText" value="${ requestScope.search }" style="width: 200px; height: 30px; border-radius: 0.375rem 0 0 0.375rem !important;" >
				<button class="btn btn-outline-secondary p-0 m-0" type="button" onclick="movePage()" style="width: 50px; height: 30px;" >검색</button>
			</div>
		</div>
		
	    <div class="mt-3" style="min-height: 500px;">
			    	<div class="col-10 offset-1">
			    		<table class="table text-center">
			    			<thead>
			    				<tr>
			    					<th class="col-1">번호</th>
			    					<th class="col-2">등록일자</th>
			    					<th class="col-2">물품번호</th>
			    					<th class="col-2">물품타입</th>
			    					<th class="col-2">물품명</th>
			    					<th class="col-1">수량</th>
			    					<th class="col-1">재고</th>
			    					<th class="col-2">작성자</th>
			    				</tr>
			    			</thead>
			    			<tbody>
			    				
			    				<c:forEach var="product" items="${ productList.content }">
			    					<tr>
				    					<td>${ product.productCode }</td>
				    					<td><a href="/product/${ product.productCode }" style="color: #737373;">${ product.lostName }</a></td>
				    					<td>${ product.staffDTO.productName }</td>
				    					<td>${ product.productAmount }</td>
			    					</tr>
			    				</c:forEach>
			    				
			    			</tbody>
			    		</table>
			    	</div>
			    </div>
			    
			    <c:if test="${ totalProduct eq 0 }">
					<div>검색된 결과가 없습니다.</div>
				</c:if>
			    
	    <div class="d-flex justify-content-center aling-items-center">
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
			    </div>
				
			    <button class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white me-3" onclick="location.href='/productManage/write'">입출고등록</button>
	    </section>
    </div>
  </main>
	<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
	<script src="/js/product/list.js"></script>
	<script>
		document.querySelector("i[data-content='재고']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("i[data-content='물품관리대장']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("#navTitle").textContent = "재고"
	</script>
</body>

</html>