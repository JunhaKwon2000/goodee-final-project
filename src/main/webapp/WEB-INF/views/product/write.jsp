<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>${empty productDTO.productCode ? "품목 등록" : "품목 수정" }</title>
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
	
    .form-group input[type="text"],
    .form-group input[type="file"] {
      width: 80%;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 6px;
      font-size: 14px;
    }

    .form-group input[type="file"] {
      padding: 4px;
    }

    aside.sidenav {
	width: 200px !important;   /* 원하는 값 (180~220px 정도 추천) */
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
    
    <section class="border-radius-xl bg-white ms-2 mt-2 me-3" style="height: 92vh; width: 100%; overflow: hidden;">

		<form:form method="post" modelAttribute="productDTO" enctype="multipart/form-data" class="d-flex flex-column mt-6" style="gap: 80px;">
		<div class="col-6 offset-3">

      <h4 class="text-center mt-5 mb-5">${empty productDTO.productCode ? "물품 등록" : "물품 수정" }</h4>
      	<div class="d-flex justify-content-between" >
      	
      	<div style="flex: 1;">
			<div class="form-group">
	          <label for="attach">사진첨부<span class="text-danger"> *</span></label>
	        	<img id="preview" width="300" height="300" style="object-fit: contain;" <c:if test="${ not empty productDTO.productCode }">src="/file/product/${ productDTO.productAttachmentDTO.attachmentDTO.savedName }"</c:if> />
	        </div>
	        
	        <div class="form-group">
	          <input type="file" id="attach" name="attach">
	          <c:if test="${not empty fileErrorMsg }"><div id="fileMsg"><small style="color: #F44335;">${fileErrorMsg }</small></div></c:if>
	        </div>
        </div>
        
        <div style="flex: 1; display: flex; flex-direction: column; justify-content: center; height: 350px;">
        <div class="form-group">
        	<form:label path="productTypeDTO.productTypeCode">물품 타입<span class="text-danger"> *</span></form:label>
			<form:select path="productTypeDTO.productTypeCode"
			             items="${productTypeList}"
			             itemValue="productTypeCode"
			             itemLabel="productTypeName"
			             cssClass="form-select"
			             style="width:80%; height:44px;">
			</form:select>
			<c:if test="${not empty productTypeErrorMsg }"><div><small style="color: #F44335;">${productTypeErrorMsg }</small></div></c:if>
        </div>
			
		<div class="form-group">
		  <form:label path="productName">물품명<span class="text-danger"> *</span></form:label>
		  <form:input path="productName" cssClass="form-control"/>
		  <form:errors path="productName" cssClass="text-danger small"></form:errors>
		</div>
		
		<c:if test="${not empty productDTO.productAmount }">
			<input type="hidden" name="productAmount" value="${productDTO.productAmount }">
		</c:if>
		
		<div class="form-group">
		  <form:label path="productSpec">규격<span class="text-danger"> *</span></form:label>
		  <form:input path="productSpec" cssClass="form-control" placeholder="ex) 140mm/100ea/흰색"/>
		  <form:errors path="productSpec" cssClass="text-danger small"></form:errors>
		</div>

      </div>
      </div>

		<div class="mt-4 d-flex justify-content-center gap-3">
	        <button type="submit" class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white me-3" style="width: 100px;">${ empty productDTO.productCode ? "등록" : "수정" }</button>
	        <button type="button" class="btn btn-sm btn-outline-secondary" onclick="location.href='/product'" style="width: 100px;">취소</button>
	    </div>
      </div>
		</form:form>
		
    </section>
    </div>
  </main>
	<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
	<script src="/js/product/write.js"></script>
	<script>
		document.querySelector("i[data-content='재고']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("i[data-content='물품 리스트']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("#navTitle").textContent = "물품 리스트"
	</script>
</body>