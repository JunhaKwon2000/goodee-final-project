<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>${empty lostDTO.lostNum ? "분실물 등록" : "분실물 수정" }</title>
	<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
	
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
      width: 90%;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 6px;
      font-size: 14px;
    }

    .form-group input[type="file"] {
      padding: 5px;
    }
	</style>
	
</head>

<body class="g-sidenav-show bg-gray-100">
	<c:import url="/WEB-INF/views/common/sidebar.jsp"></c:import>
  
  <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
    <c:import url="/WEB-INF/views/common/nav.jsp"></c:import>
    <section class="border-radius-xl bg-white ms-2 mt-2 me-3" style="height: 92vh; overflow: hidden;">
    
	      <form:form method="post" modelAttribute="lostDTO" enctype="multipart/form-data" class="d-flex flex-column mt-6" style="gap: 80px;">
	    <div class="col-6 offset-3">
	    
	      <h4 class="text-center mt-5 mb-5">${empty lostDTO.lostNum ? "분실물 등록" : "분실물 수정" }</h4>
		           
			<div class="d-flex justify-content-between" >

	        <div style="flex: 1;">
		        <div class="form-group">
		          <label for="attach">사진첨부<span class="text-danger"> *</span></label>
		        	<img id="preview" width="370" height="370" style="object-fit: contain;" <c:if test="${ not empty lostDTO.lostNum }">src="/file/lost/${ lostDTO.lostAttachmentDTO.attachmentDTO.savedName }"</c:if> />
		        </div>
		        
		        <div class="form-group">
		          <input type="file" id="attach" name="attach">
		          <c:if test="${not empty fileErrorMsg }"><div id="fileMsg"><small style="color: #F44335;">${fileErrorMsg }</small></div></c:if>
		        </div>
	        </div>
	        
	        <div style="flex: 1; display: flex; flex-direction: column; justify-content: center; height: 450px;">
		        <div class="form-group">
		          <form:label path="lostName">분실물명<span class="text-danger"> *</span></form:label>
		          <form:input path="lostName" cssClass="form-control"/>
		          <form:errors path="lostName" cssClass="text-danger small"></form:errors>
		        </div>
		        
		        <div class="form-group">
		          <form:label path="lostFinder">습득자</form:label>
		          <form:input path="lostFinder" cssClass="form-control"/>
		          <form:errors path="lostFinder"></form:errors>
		        </div>
		        
		        <div class="form-group">
		          <form:label path="lostFinderPhone">습득자 연락처</form:label>
		          <form:input path="lostFinderPhone" cssClass="form-control" placeholder="ex) 010-1234-5678" />
		          <form:errors path="lostFinderPhone" cssClass="text-danger small"></form:errors>
		        </div>
		        
		        <div class="form-group">
		          <form:label path="lostNote">특이사항</form:label>
		          <textarea class="form-control" id="lostNote" name="lostNote" rows="3" style="width: 90%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; resize:none;" placeholder="ex)  습득날짜 또는 습득장소">${lostDTO.lostNote }</textarea>
		          <form:errors path="lostNote"></form:errors>
		        </div>
	        </div>
		    </div>
		    
	        <div class="mt-4 d-flex justify-content-center gap-3">
		        <button type="submit" class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white me-3" style="width: 100px;">${ empty lostDTO.lostNum ? "등록" : "수정" }</button>
		        <button type="button" class="btn btn-sm btn-outline-secondary" onclick="location.href='/lost'" style="width: 100px;">취소</button>
	        </div>
	      </div>
	      </form:form>
    
    </section>
  </main>
	<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
	<script src="/js/lost/write.js"></script>
	<script>
		document.querySelector("i[data-content='분실물']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("#navTitle").textContent = "분실물"
	</script>
</body>

</html>