<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>드라이브추가</title>
	
	<link rel="stylesheet" href="/css/drive/create.css" />
	<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
</head>

<body class="g-sidenav-show bg-gray-100">
	<c:import url="/WEB-INF/views/common/sidebar.jsp"></c:import>

	<main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
		<c:import url="/WEB-INF/views/common/nav.jsp"></c:import>
		<div class="d-flex">
			<c:import url="/WEB-INF/views/drive/drive-sidebar.jsp"></c:import>
			<section class="border-radius-xl bg-white w-90 ms-2 mt-2 me-3" style="height: 92vh; overflow: hidden scroll;">

				<!-- 여기에 메인 컨텐츠 작성 -->
				<div class="p-6">
					<form:form method="post" modelAttribute="driveDTO">
						<div class="d-flex align-items-center gap-1 w-50">
							<form:label path="driveName" cssClass="ms-0 me-1 mb-0 fs-6">드라이브 이름 : </form:label>
							<form:input path="driveName" cssClass="form-control w-auto" value=""/>
						</div>
						<div>
							<form:errors path="driveName" cssClass="text-danger small"></form:errors>
						</div>
						<div class="mt-1 d-flex align-items-center">
							<span class="fs-6">드라이브 공유 : </span>
							<button type="button" class="btn btn-outline-secondary p-1 rounded ms-2 mt-3" 
								id="btnShowModalShare" data-bs-toggle="modal" data-bs-target="#shareModal">
								<i class="material-symbols-rounded opacity-5 fs-5">group_add</i>
							</button>
						</div>
						<table class="col-6 offset-md-1 table w-50 mb-4">
							<thead>
								<tr>
									<th scope="col" colspan="3" class="text-center">추가된 사용자</th>
									<th scope="col" class="text-center">직급</th>
									<th scope="col" class="text-center">소속</th>
								</tr>
							</thead>
							<tbody class="table-group-divider text-center" id="savedStaff">
								<!-- 추가된 사용자 -->
								<c:if test="${ not empty driveDTO and driveDTO.driveEnabled }">
									<c:forEach items="${ driveDTO.driveShareDTOs }" var="driveShareDTO" varStatus="vs">
										<tr class="shareStaff">
											<th scope="row">
												<button type="button" class="btn-close btn-close-white remove-saved" aria-label="Remove"></button>
												<input type="hidden" name="driveShareDTOs[${ vs.index }].staffDTO.staffCode" value="${ driveShareDTO.staffDTO.staffCode }">
											</th>
											<td><i class="material-symbols-rounded opacity-5 fs-5">contacts_product</i></td>
											<td>${ driveShareDTO.staffDTO.staffName }</td>
											<td>${ driveShareDTO.staffDTO.jobDTO.jobDetail }</td>
											<td>${ driveShareDTO.staffDTO.deptDTO.deptDetail }</td>
										</tr>
									</c:forEach>
								</c:if>
								
							</tbody>
						</table>
						<div class="d-flex">
							<div class="col-6 offset-md-1">
								<button class="btn btn-outline-secondary bg-gradient-dark btn-drive-save">저장</button>
								<button type="button" class="btn btn-outline-secondary" onclick="history.back()">취소</button>
							</div>
							<div>
								<c:if test="${ not empty driveDTO.driveNum and driveDTO.driveEnabled }">
									<button type="button" class="btn btn-outline-danger" onclick="deleteDrive(${ driveDTO.driveNum }, ${ driveDTO.driveDefaultNum })">드라이브 삭제</button>
								</c:if>
								<c:if test="${ not empty driveDTO.driveNum and not driveDTO.driveEnabled }">
									<button type="button" class="btn btn-outline-danger" onclick="restoreDrive(${ driveDTO.driveNum }, ${ driveDTO.driveDefaultNum })">드라이브 복원</button>
								</c:if>
							</div>							
						</div>
					</form:form>
				</div>

			</section>
		</div>
	</main>
	<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
	<c:import url="/WEB-INF/views/drive/share-modal.jsp"></c:import>
	<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
	<script>
	const loginStaffCode = ${ staffDTO.staffCode }
	let lastIndexOfStaffList = ${empty driveDTO.driveShareDTOs ? 0 : fn:length(driveDTO.driveShareDTOs)};
	document.querySelector("#navTitle").textContent = "드라이브"
	document.querySelector("i[data-content='드라이브']").parentElement.classList.add("bg-gradient-dark", "text-white")
	</script>
	
	<c:if test="${not empty driveDTO.driveNum}">
	<script>
	document.querySelector("i[data-content='${ driveDTO.driveName }']").parentElement.classList.add("text-white")
	document.querySelector("i[data-content='${driveDTO.driveName}']").parentElement.classList.add("bg-gradient-dark", "text-white")
	document.querySelector("i[data-content='${ driveDTO.driveName }']").parentElement.parentElement.classList.add("bg-gradient-dark", "text-white", "rounded")
	</script>
	</c:if>
	<script src="/js/drive/create.js"></script>
</body>

</html>