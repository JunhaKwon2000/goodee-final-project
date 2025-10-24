<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>어트랙션 점검</title>
	
	<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
	
	<style>
		/* 테이블 마지막 줄 경계선 보정 */
		.table tbody tr:last-child td,
		.table tbody tr:last-child th {
			border-bottom: 1px solid #dee2e6;
		}
	 
 	  /* 모달창 css */
	 .my-cancel-btn {
	  background-color: #fff !important;   
	  color: #212529 !important;           
	  border: 1px solid #ccc !important;   
	  border-radius: 5px !important;       
	}
	
	.my-cancel-btn:hover {
	  background-color: #f8f9fa !important;
	}
	
	.btn {
		margin-bottom:1 !important;
	}
	</style>
</head>

<body class="g-sidenav-show bg-gray-100">
	<c:import url="/WEB-INF/views/common/sidebar.jsp"></c:import>
  
  <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
    <c:import url="/WEB-INF/views/common/nav.jsp"></c:import>
    <div class="d-flex">
    	<aside class="sidenav navbar navbar-vertical border-radius-lg ms-2 bg-white my-2 w-10 align-items-start" style="width: 200px !important; height: 92vh;">
    		<div class="w-100">
			    <ul class="navbar-nav">
			   		 <!-- 메뉴 개수만큼 추가 -->
			    	<c:import url="/WEB-INF/views/ride/ride-side-sidebar.jsp"></c:import>
			    </ul>
			  </div>
    	</aside>
    	
	    <section class="border-radius-xl bg-white w-90 ms-2 mt-2 me-3" style="height:92vh; overflow: hidden scroll;">
	    <div class="col-10 offset-1 mt-5">
	    <!-- 여기에 코드 작성 -->
    	<!-- 검색창 -->
		<form action="/inspection" class="mb-4">
		    <div class="d-flex justify-content-end">
		        <div class="d-flex">
		
		            <!-- 검색 조건 선택 -->
		            <!-- 선택했던 옵션이 검색 후에도 유지되도록 selected 속성 -->
		            <select class="form-select ps-2 py-0" name="searchType" id="searchType" style="width: 100px; height:30px; border-radius: 6px 0 0 6px;">
		                <option value="ride" ${searchType == 'ride' ? 'selected' : '' }>어트랙션</option>
		                <option value="type" ${searchType == 'type' ? 'selected' : '' }>점검유형</option>
		                <option value="result" ${searchType == 'result' ? 'selected' : '' }>점검결과</option>
		                <option value="staff" ${searchType == 'staff' ? 'selected' : '' }>담당자</option>
		            </select>
		
		            <!-- 검색어 입력 -->
		            <input type="text" class="form-control" placeholder="검색어를 입력해주세요." name="keyword" id="keywordInput" value="${pager.keyword}" style="width: 200px; height: 30px; border-radius: 0;">
		            
		            <!-- 점검유형 옵션 -->
		            <select class="form-select ps-2 py-0 d-none" name="keywordType" id="typeSelect" style="width: 200px; height:30px; border-radius: 0;">
		            	<option value="">-- 점검유형 --</option>
		            	<option value="401" ${pager.keyword == '401' ? 'selected' : '' }>긴급점검</option>
		            	<option value="501" ${pager.keyword == '501' ? 'selected' : '' }>일일점검</option>
		            	<option value="502" ${pager.keyword == '502' ? 'selected' : '' }>정기점검</option>
		            </select>
		            
		            <!-- 점검결과 옵션 -->
		            <select class="form-select ps-2 py-0 d-none" name="keywordResult" id="resultSelect" style="width: 200px; height:30px; border-radius: 0;">
	            		<option value="">-- 점검결과 --</option>
		            	<option value="201" ${pager.keyword == '201' ? 'selected' : '' }>정상</option>
		            	<option value="202" ${pager.keyword == '202' ? 'selected' : '' }>특이사항 있음</option>
		            	<option value="203" ${pager.keyword == '203' ? 'selected' : '' }>운영불가</option>
		            </select>
		
		            <!-- 검색 버튼 -->
		            <button class="btn bg-gradient-dark text-white py-0" type="submit" style="width: 60px; height: 30px; border-radius: 0 6px 6px 0;">검색</button>
		        </div>
		    </div>
		</form>
	    
		<table class="table table-hover align-middle text-center">
			<thead>
				<tr>
					<th scope="col">점검번호</th>
					<th scope="col">어트랙션</th>
					<th scope="col">점검유형</th>
					<th scope="col">점검결과</th>
					<th scope="col">담당자</th>
					<th scope="col">점검 시작일</th>
					<th scope="col">점검 종료일</th>
					<th scope="col">체크리스트</th>
					<th style="colspan:2;">수정/삭제</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${ inspection.content }" var="i">
					<tr>
						<td>${ i.isptNum }</td>
						<td scope="row">${ i.rideDTO.rideName }</td>
						<!-- 점검유형 -->						
						<c:if test="${ i.isptType eq 401 }">
							<td>긴급점검</td>
						</c:if>
						<c:if test="${ i.isptType eq 501 }">
							<td>일일점검</td>
						</c:if>
						<c:if test="${ i.isptType eq 502 }">
							<td>정기점검</td>
						</c:if>
						<!-- 점검결과 -->
						<c:if test="${ i.isptResult eq 201 }">
							<td>정상</td>
						</c:if>
						<c:if test="${ i.isptResult eq 202 }">
							<td>특이사항 있음</td>
						</c:if>
						<c:if test="${ i.isptResult eq 203 }">
							<td>운영불가</td>
						</c:if>
						<td>${ i.staffDTO.staffName }</td>
						
						<td>${ i.isptStart }</td>
						<td>${ i.isptEnd }</td>
						<!--  체크리스트 -->
						<td>
						  <a href="/inspection/${ i.inspectionAttachmentDTO.attachmentDTO.attachNum }/download"
						     style="color:#1900F8; text-decoration:none;">
						     다운로드
						  </a>
						</td>
						<td colspan="2" style="padding: 0; vertical-align: middle;">
						  <div style="display: flex; align-items: center; justify-content: center; gap: 10px;">
						    <form action="${pageContext.request.contextPath }/inspection/${i.isptNum}/update"
						          method="get"">
						      <button type="submit" 
						              class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white"
						              style="width: 50px; height: 32px; padding: 0; margin:1px 0 !important;">수정</button>
						    </form>
						    <button type="button" 
						            class="btn btn-sm btn-outline-secondary"
						            style="width: 50px; height: 32px; padding: 0;  margin-bottom:0 !important;"
						            onclick="deleteInspection('${ i.isptNum }')">삭제</button>
						  </div>
						</td>

					</tr>
				</c:forEach>
			</tbody>
		</table>

		<!-- 페이지네이션 -->
		<c:if test="${ inspection.content.size() gt 0 }">
		<nav>
			<ul class="pagination justify-content-center">
				<c:if test="${ inspection.hasPrevious() and pager.startPage gt 1 }">
					<li class="page-item">
						<a class="page-link" href="?page=${ pager.startPage - 1 }&keyword=${ pager.keyword }">&lt;</a>
					</li>
				</c:if>
				
				<c:forEach var="i" begin="${ pager.startPage }" end="${ pager.endPage }">
					<li class="page-item ${ i == inspection.number ? 'active' : '' }">
						<a class="page-link" href="?page=${i}&keyword=${ pager.keyword }">${i + 1}</a>
					</li>
				</c:forEach>
				
				<c:if test="${ inspection.hasNext() and pager.endPage + 1 ne inspection.totalPages }">
					<li class="page-item">
						<a class="page-link" href="?page=${ pager.endPage + 1 }&keyword=${ pager.keyword }">&gt;</a>
					</li>
				</c:if>
			</ul>
		</nav>
    	</c:if>
		
	  <!-- 검색 결과 없음 -->
	  <c:if test="${ totalInspection eq 0 }">
		  <div class="d-flex flex-column justify-content-center align-items-center mt-8">
		  	<img width="150" height="180" src="/images/nothing.png" />
		  	<h4 class="mt-5">검색 결과가 없습니다.</h4>
		  </div>
	  </c:if>
		
   	  <!-- 어트랙션 점검 기록 등록 -->
   	  <!-- 로그인 사용자 정보 꺼내기 -->
   	  <sec:authorize access="isAuthenticated()">
      <sec:authentication property="principal" var="staff" />
	  
	  <!-- 시설부서(deptCode == 1003)일 때만 등록 버튼 보이기 -->
      <c:if test="${staff.deptDTO.deptCode eq 1003}">
        <div class="text-end mt-4 me-4">
          <a href="${pageContext.request.contextPath}/inspection/write "
             class="btn btn-primary btn-sm btn-outline-secondary bg-gradient-dark text-white me-3"
             style="width:75px;">등록</a>
        </div>
      </c:if>
      
      </sec:authorize>
	  
	    </div>
	    </section>
    </div>
  </main>
	<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
	<script src="/js/inspection/inspectionList.js"></script>
	<script src="/js/inspection/inspectionDetail.js"></script>
	<script>
		document.querySelector("i[data-content='어트랙션']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("i[data-content='어트랙션 점검']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("#navTitle").textContent = "어트랙션 점검"
	</script>
</body>

</html>