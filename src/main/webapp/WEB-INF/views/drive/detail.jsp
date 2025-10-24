<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>드라이브</title>
	
	<link rel="stylesheet" href="/css/drive/detail.css" />
	<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
</head>

<body class="g-sidenav-show bg-gray-100">
	<c:import url="/WEB-INF/views/common/sidebar.jsp"></c:import>

	<main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
		<c:import url="/WEB-INF/views/common/nav.jsp"></c:import>
		<div class="d-flex">
			<c:import url="/WEB-INF/views/drive/drive-sidebar.jsp"></c:import>
			<section class="border-radius-xl bg-white w-90 ms-2 mt-2 me-3 p-4">

				<!-- 툴바 -->
				<div class="d-flex align-items-center flex-wrap gap-2 mb-3">
				
				  <!-- 업로드 -->
				  <button type="button" class="btn btn-outline-secondary btn-sm d-flex align-items-center mb-0"
						   data-bs-toggle="modal" data-bs-target="#uploadModal">업로드</button>
				  
				  <!-- 새 문서 -->
<!-- 				  <button type="button" class="btn btn-outline-secondary btn-sm d-flex align-items-center mb-0">새 문서</button> -->
				  <!-- 파일 유형 -->
				  <div class="d-flex align-items-center gap-2">
				    <select class="form-select form-select-sm w-auto align-self-center rounded" id="fileTypeSelect" >
				      <option value="all" ${ empty pager.fileType ? "selected" : ""}>파일 유형: 선택</option>
				      <option value="doc" ${ pager.fileType eq 'doc' ? "selected" : ""}>문서</option>
				      <option value="image" ${ pager.fileType eq 'image' ? "selected" : "" }>이미지</option>
				      <option value="video" ${ pager.fileType eq 'video' ? "selected" : "" }>동영상</option>
				      <option value="audio" ${ pager.fileType eq 'audio' ? "selected" : "" }>오디오</option>
				    </select>
				  </div>
				
				  <!-- 다운로드 -->
				  <button type="button" class="btn btn-outline-secondary btn-sm d-flex align-items-center justify-content-center mb-0"
				          id="btnDownloadFile" onclick="downloadFile(${ driveDTO.driveNum })" disabled>
				    <span class="material-symbols-rounded">download</span>
				  </button>
				
				  <!-- 삭제 -->
				  <button type="button" class="btn btn-outline-danger btn-sm d-flex align-items-center justify-content-center mb-0"
				          id="btnDeleteFile" onclick="deleteFile(${ driveDTO.driveNum })" disabled>
				    <span class="material-symbols-rounded">delete</span>
				  </button>
				  
				  <!-- 검색 -->
				  <form action="/drive/${ driveDTO.driveNum }" class="ms-auto d-flex align-items-center gap-2" id="frmSearch">
				    <div class="ms-auto d-flex align-items-center">
					  <input type="text" id="searchInput" class="form-control form-control-sm me-1"
					         name="keyword" value="${ pager.keyword }" placeholder="파일명, 등록자 입력" style="width: 200px;">
					  <input type="hidden" id="fileType" name="fileType">
					  <button type="submit" class="btn btn-dark btn-sm mb-0" id="btnSearch">
					    <span class="material-symbols-rounded">search</span>
					  </button>
				    </div>
			      </form>
				</div>
					
				<div class="table-responsive">
				  <table class="table table-hover align-middle mb-0 table-figma drive-table" style="table-layout: fixed; width: 100%;">
				    <thead class="border-top">
				      <tr>
				        <th class="text-center" style="width:36px;"><input type="checkbox" id="checkAll"/></th>
				        <th>파일명</th>
				        <th style="width: 180px;" class="text-center">등록일</th>
				        <th style="width: 120px;" class="text-center">용량</th>
				        <th style="width: 120px;" class="text-center">확장자</th>
				        <th style="width: 140px;" class="text-center">등록자</th>
				      </tr>
				    </thead>
				    <tbody>
					  <c:choose>
					    <c:when test="${ not empty docList.content }">
					      <c:forEach items="${ docList.content }" var="doc" >
						        <tr>
						          <td class="text-center"><input type="checkbox" class="checkBoxes" value="${ doc.attachmentDTO.attachNum }" /></td>
						          <td><div class="text-truncate">${ doc.attachmentDTO.originName }</div></td>
						          <td class="text-center">${ doc.docDate }
						          <td class="text-center">${ doc.attachmentDTO.attachSizeDetail } </td>
						          <td class="text-center">${ doc.docContentType }</td>
						          <td class="text-center">${ doc.staffDTO.staffName }</td>
						        </tr>
					      </c:forEach>
					    </c:when>
					    <c:otherwise>
					      <!-- 데이터 없을 때만 중앙 정렬 -->
					      <tr>
					        <td colspan="6" class="border-0">
					          <div class="d-flex justify-content-center align-items-center text-secondary" style="height:60vh;">
					          	<i class="material-symbols-rounded opacity-5 fs-5">news</i>
					            등록된 파일이 없습니다.
					          </div>
					        </td>
					      </tr>
					    </c:otherwise>
					  </c:choose>
					</tbody>
				  </table>
				  
				  <div class="mt-2 d-flex justify-content-start ms-2">
				  	<span>총 ${ docList.content.size() }개</span>
				  </div>
				  	
				</div>
					
				  <c:if test="${ docList.content.size() gt 0 }">
					  <nav class="mt-4">
					    <ul class="pagination justify-content-center">
					      <c:if test="${ docList.hasPrevious() and pager.startPage gt 1 }">
					        <li class="page-item">
					          <a class="page-link border border-secondary rounded-0" 
					             href="?page=${ pager.startPage - 1 }&keyword=${ pager.keyword }">&lt;</a>
					        </li>
					      </c:if>
					
					      <c:forEach var="i" begin="${ pager.startPage }" end="${ pager.endPage }">
					        <li class="page-item ${ i == docList.number ? 'active' : '' }">
					          <a class="page-link border border-secondary ${ i == docList.number ? 'bg-dark text-white border-dark' : '' }" 
					             href="?page=${i}&keyword=${ pager.keyword }" style="border-radius: 7px !important">${i + 1}</a>
					        </li>
					      </c:forEach>
					
					      <c:if test="${ docList.hasNext() and pager.endPage + 1 ne docList.totalPages }">
					        <li class="page-item">
					          <a class="page-link border border-secondary rounded-0" 
					             href="?page=${ pager.endPage + 1 }&keyword=${ pager.keyword }">&gt;</a>
					        </li>
					      </c:if>
					    </ul>
					  </nav>
		 		  </c:if>
			</section>
		</div>
	</main>
	<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
	<c:import url="/WEB-INF/views/drive/upload-modal.jsp"></c:import>
	<script>
	document.querySelector("i[data-content='드라이브']").parentElement.classList.add("bg-gradient-dark", "text-white")
	document.querySelector("i[data-content='${ driveDTO.driveName }']").parentElement.parentElement.classList.add("bg-gradient-dark", "text-white", "rounded")
	document.querySelector("i[data-content='${ driveDTO.driveName }']").parentElement.classList.add("text-white")
	document.querySelector("#navTitle").textContent = "드라이브"
	</script>
	<script src="/js/drive/detail.js"></script>
</body>

</html>