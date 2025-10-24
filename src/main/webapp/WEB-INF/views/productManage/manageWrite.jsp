<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>입출고 등록</title>
<style type="text/css">

.form-group {
	margin-bottom: 20px;
	text-align: left;
}

.form-group label {
	display: block;
	margin-bottom: 8px;
	font-weight: 500;
	font-size: 14px;
}

.form-group input[type="text"], .form-group input[type="file"] {
	width: 100%;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 6px;
	font-size: 14px;
}

.form-group input[type="file"] {
	padding: 4px;
}

aside.sidenav {
	width: 200px !important; /* 원하는 값 (180~220px 정도 추천) */
	min-width: 200px !important;
	max-width: 200px !important;
}
</style>
<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
</head>

<body class="g-sidenav-show bg-gray-100">
	<c:import url="/WEB-INF/views/common/sidebar.jsp"></c:import>

	<main
		class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
		<c:import url="/WEB-INF/views/common/nav.jsp"></c:import>

		<div class="d-flex">
			<aside
				class="sidenav navbar navbar-vertical border-radius-lg ms-2 bg-white my-2 w-10 align-items-start"
				style="width: 200px; height: 92vh;">
				<div class="w-100">
					<ul class="navbar-nav">

						<li class="nav-item"><a class="nav-link text-dark"
							href="/product"> <i
								class="material-symbols-rounded opacity-5 fs-5"
								data-content="물품 리스트">remove_shopping_cart</i> <span
								class="nav-link-text ms-1 text-sm">물품 리스트</span>
						</a></li>

						<li class="nav-item"><a class="nav-link text-dark"
							href="/productManage"> <i
								class="material-symbols-rounded opacity-5 fs-5"
								data-content="물품관리대장">remove_shopping_cart</i> <span
								class="nav-link-text ms-1 text-sm">물품관리대장</span>
						</a></li>

					</ul>
				</div>
			</aside>

			<section class="border-radius-xl bg-white ms-2 mt-2 me-3" style="height: 92vh; width: 100%; overflow: hidden;">
			
					<form:form method="post" modelAttribute="productManageDTO" enctype="multipart/form-data" class="d-flex flex-column mt-6" style="gap: 80px;">
				<div class="col-6 offset-3">
					<h4 class="text-center mt-5 mb-5">입출고 등록</h4>
						<div class="d-flex justify-content-between" style="gap: 50px;" >
							<div class="w-50">
								<label for="product">품목선택<span class="text-danger"> *</span></label>
								<div style="flex: 1; display: flex; flex-direction: column; justify-content: center; height: 400px; border: 1px solid lightgray; border-radius: 20px; padding:10px;">
									<div class="form-group mt-4">
										<label for="productCode">물품번호</label>
										<input type="text" id="productCode" name="productCode" value="${productManageDTO.productDTO.productCode }" readonly required placeholder="물품을 검색해주세요.">
									</div>
											
										<input type="hidden" name="productTypeDTO.productTypeCode" value="${productManageDTO.productDTO.productTypeDTO.productTypeCode }"/>
										
									<div class="form-group">
										<label for="productTypeName">물품타입</label>
										<input type="text" id="productTypeName" name="productTypeDTO.productTypeName" value="${productManageDTO.productDTO.productTypeDTO.productTypeName }" readonly required placeholder="물품을 검색해주세요.">
									</div>
											 
									<div class="form-group">
										<label for="productName">물품명</label>
										<input type="text" id="productName" name="productName" value="${productManageDTO.productDTO.productName }" readonly required placeholder="물품을 검색해주세요.">
									</div>
										
									<div class="form-group">
										<label for="productSpec">규격</label>
										<input type="text" id="productSpec" name="productSpec" value="${productManageDTO.productDTO.productSpec }" readonly required placeholder="물품을 검색해주세요.">
									</div>
								</div>
								<c:if test="${not empty productCodeMsg }"><div class="mt-1" id="productCodeMsg"><small style="color: #F44335;">&nbsp;${productCodeMsg }</small></div></c:if>
							</div>
							
							<div style="flex: 1; display: flex; flex-direction: column; justify-content: center; height: 450px;">
								<div class="d-flex flex-column justify-content-between" style="gap:20px;">
								<div>
									<button type="button" class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white me-3"	data-bs-toggle="modal" data-bs-target="#productModal"
										style="height:40px; width:140px;">물품검색</button>
								</div>
								
								<div>
								<div class="form-group">
									<label>유형<span class="text-danger"> *</span></label>
									<div class="radio-group d-flex justify-content-start" style="gap: 15px;" >
										<label style="font-size: 16px;">
								            <input type="radio" name="pmType" value="80" checked> 입고
								        </label> 
										<label style="font-size: 16px;">
											<input type="radio"	name="pmType" value="90"> 출고
										</label>
									</div>
								</div>
		
								<div class="form-group">
									<form:label path="pmAmount">수량<span class="text-danger"> *</span></form:label>
									<input type="number" name="pmAmount" id="pmAmount" class="form-control" value="${pmAmount }" style="height: 45px;"/>
		  							<form:errors path="pmAmount" cssClass="text-danger small"></form:errors>
	  							<c:if test="${not empty pmAmountMsg }"><div class="mt-1" id="pmAmountMsg"><small style="color: #F44335;">&nbsp;${pmAmountMsg }</small></div></c:if>
								</div>
								
								<div class="form-group">
									<form:label path="pmNote">비고<span class="text-danger"> *</span></form:label>
									<form:input path="pmNote" cssClass="form-control" placeholder="ex) 정기 재고 보충분 입고"/>
		  							<form:errors path="pmNote" cssClass="text-danger small"></form:errors>
								</div>
								
								</div>
								</div>
							</div>
						</div>

						<div class="mt-6 d-flex justify-content-center gap-3">
							<button type="submit"
								class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white me-3"
								style="width: 100px;">등록</button>
							<button type="button" class="btn btn-sm btn-outline-secondary"
								onclick="location.href='/productManage'" style="width: 100px;">취소</button>
						</div>
					</div>
					</form:form>

				<!-- 모달창 내용 -->
				<div class="modal fade" id="productModal" tabindex="-1"
					aria-hidden="true">
					<div class="modal-dialog modal-xl">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title">물품 목록</h5>
								<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>
							
							<div class="modal-body" style="max-height: 700px; overflow-y: auto;">
								<div class="d-flex justify-content-end align-items-end">
									<div class="input-group" style="width: 30%;">
										<input type="text" class="form-control" id="searchInput" placeholder="검색어를 입력하세요." style="height:40px; border-radius: 0.375rem 0 0 0.375rem !important;" >
									</div>
								</div>
								
								<table class="table">
									<thead>
										<tr>
											<th style="text-align:center;">물품번호</th>
											<th>물품타입</th>
											<th>물품명</th>
											<th>규격</th>
											<th style="text-align:center;">재고수량</th>
											<th style="text-align:center;">선택</th>
										</tr>
									</thead>
									<tbody id="productTable">
									
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>

			</section>
		</div>
	</main>
	<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
	<script src="/js/productManage/write.js"></script>
	<script>
		document.querySelector("i[data-content='재고']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("i[data-content='물품관리대장']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("#navTitle").textContent = "물품관리대장"
	</script>
</body>


</html>