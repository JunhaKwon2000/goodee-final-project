<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>근태</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" />
<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
</head>

<body class="g-sidenav-show bg-gray-100">
	<c:import url="/WEB-INF/views/common/sidebar.jsp"></c:import>

	<main
		class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
		<c:import url="/WEB-INF/views/common/nav.jsp"></c:import>
		<section class="border-radius-xl bg-white ms-2 mt-2 me-3"
			style="height: 92vh; overflow: hidden;">

			<div class="container-fluid">
				<div class="row  mt-3">
					<!-- 왼쪽 카드 영역 -->
					<div class="col-md-4">
						<!-- 이달 근태 현황 -->
						<div class="card mb-3">
							<div class="card-header">
								이상근태 현황 <span class="float-end"><small>${month }월</small></span>
							</div>

							<div class="card-body">
								<div class="row text-center">
									<div class="col">
										지각<br>
										<strong>${lateCount }</strong>
									</div>
									<div class="col">
										조퇴<br>
										<strong>${earlyLeaveCount }</strong>
									</div>
									<div class="col">
										결근<br>
										<strong>${absentCount }</strong>
									</div>
								</div>
							</div>
						</div>

						<!-- 연차 현황 -->
						<div class="card mb-3">
							<div class="card-header">연차 현황</div>
							<div class="card-body text-center">
								<div class="row">
									<div class="col">
										잔여<br>
										<strong>${staffDTO.staffRemainLeave - staffDTO.staffUsedLeave }</strong>
									</div>
									<div class="col">
										사용<br>
										<strong>${staffDTO.staffUsedLeave }</strong>
									</div>
									<div class="col">
										총 연차<br>
										<strong>${staffDTO.staffRemainLeave }</strong>
									</div>
								</div>
							</div>
						</div>

						<!-- 근로시간 현황 -->
						<div class="card">
							<div class="card-header d-flex justify-content-between">
								<div>근로시간 현황</div>
								
								<div class="d-flex align-content-center">
        							<a href="/attend?baseDate=${prevWeek}&month=${month}">
        								<span class="material-symbols-outlined">chevron_backward</span>
        							</a>
									<small class="text-center date-range"
	      									 style="display:inline-block; min-width: 150px;">
	       								&nbsp;${mondayStr }(월)<span class="me-2 ms-2">~</span>${sundayStr }(일)&nbsp;</small> 
        							<a href="/attend?baseDate=${nextWeek}&month=${month}">
        								<span class="material-symbols-outlined">chevron_forward</span>
        							</a>
								</div>
							</div>
							
							<div class="card-body">
								<p>- 주 근로시간 : 40h 00m</p>
								<p>- 누적 근로시간 : ${totalWorkTime}</p>
								<p>- 잔여 근로시간 : ${remainingWorkTime }</p>
								<p>- 연장 근로시간 : ${overtimeWorkTime eq null ? "00h 00m" : overtimeWorkTime}</p>
								
								<div class="work-progress mt-5 mb-5" style="margin-top:15px;">
								
								  <div class="progress" style="height: 10px; border-radius: 3px; background-color:#e9ecef;">
								
								    <!-- 주 근로시간 전체바 -->
								    <div class="progress-bar bg-light position-relative"
								         style="height:12px; width: 77%; border-top-left-radius:3px; border-bottom-left-radius:3px;">
								      
								      <!-- 실제 근로시간만큼 내부 채우기 -->
								      <div style="width: ${weekPercent}%; height: 100%; background-color: green; border-radius: inherit;"></div>
								      <span style="position:absolute; left:50%; transform:translateX(-50%); color:white;">40h</span>
								    </div>
								
								    <!-- 연장근로 전체바 -->
								    <div class="progress-bar bg-light position-relative"
								         style="height:12px; width: 23%; border-top-right-radius:3px; border-bottom-right-radius:3px;">
								      
								      <div style="width: ${overPercent}%; height: 100%; background-color: red; border-radius: inherit;"></div>
								      <span style="position:absolute; left:50%; transform:translateX(-50%); color:white;">+12h</span>
								    </div>
								
								  </div>
								</div>
							</div>
						</div>
						
					</div>

					<!-- 오른쪽 출퇴근 내역 -->
					<div class="col-md-8">
						<div class="card" style="height:674px; overflow: hidden;">
							<div class="card-header">
								<div>
								출퇴근 내역
								</div>
								<div>
								<form action="${pageContext.request.contextPath}/attend/monthly" method="get">
									<input type="hidden" name="baseDate" value="${monday }">
									<label for="year">년도</label>
									<select name="year" id="year">
										<c:forEach var="y" begin="2020" end="2030">
											<option value="${y}"
												<c:if test="${y == year}">selected</c:if>>${y}</option>
										</c:forEach>
									</select>
										<label for="month">월</label>
										<select name="month" id="month">
											<c:forEach var="m" begin="1" end="12">
												<option value="${m}"
													<c:if test="${m == month}">selected</c:if>>${m}월</option>
											</c:forEach>
										</select>

									<button type="submit"
										class="btn btn-sm btn-outline-secondary bg-gradient-dark text-white mt-2 me-3">조회</button>
								</form>
								</div>
								</div>

								<div class="card-body">
									<table class="table text-center align-middle" style="font-size:15px;">
										<thead>
											<tr>
												<th>날짜</th>
												<th>출근시간</th>
												<th>퇴근시간</th>
												<th>실제근로시간</th>
												<th>총근로시간</th>
												<th>출퇴근상태</th>
												<th>근무상태</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${attendances.content }" var="attend">
												<tr>
													<td>${attend.attendDate }</td>
													<td>${attend.attendIn eq null ? "--:--:--" : attend.formattedAttendIn}</td>
													<td>${attend.attendOut eq null ? "--:--:--" : attend.formattedAttendOut}</td>
													<td>${attend.workTime }</td>
													<td>${attend.totalWorkTime }</td>
													<c:set var="isEarlytime" value="false" scope="page" />
													<c:forEach items="${earlyList}" var="early">
													    <c:set var="earlyDateOnly" value="${fn:substring(early.earlyDtm, 0, 10)}" />
													    <c:if test="${attend.attendDate eq earlyDateOnly}">
													        <c:set var="isEarlytime" value="true" scope="page" />
													    </c:if>
													</c:forEach>
													
													<td>
													    <c:if test="${isEarlytime}">
													        ${fn:replace(attend.attendStatus, '조퇴(미승인)', '조퇴')}
													    </c:if>
													    <c:if test="${!isEarlytime}">
													        ${attend.attendStatus}
													    </c:if>
													</td>
													<td>
											            <c:set var="isOvertime" value="false" />
											            <c:forEach items="${overtimeList}" var="over">
											                <!-- overStart의 'yyyy-MM-dd' 부분만 추출 -->
											                <c:set var="overDateOnly" value="${fn:substring(over.overStart, 0, 10)}" />
											                <c:if test="${attend.attendDate eq overDateOnly}">
											                    <c:set var="isOvertime" value="true" />
											                </c:if>
											            </c:forEach>
											
											            <c:choose>
											                <c:when test="${isOvertime}">연장 근무</c:when>
											                <c:otherwise>-</c:otherwise>
											            </c:choose>
											        </td>
												</tr>
											</c:forEach>
										</tbody>
									</table>

									<c:if test="${ attendances.content.size() eq 0 }">
								        <div class="d-flex flex-column justify-content-center align-items-center mt-8">
	  	<img width="150" height="180" src="/images/nothing.png" />
	  	<h4 class="mt-5">조회 결과가 없습니다.</h4>
	  </div>
								    </c:if>
									<!-- 페이징 -->
									<c:if test="${attendances.content.size() gt 0 }">
										<nav>
											<ul class="pagination justify-content-center">
												<!-- 페이지 번호 -->
												<c:forEach var="i" begin="0"
													end="${attendances.totalPages - 1}">
													<li
														class="page-item ${i == attendances.number ? 'active' : ''}">
														<a class="page-link"
														href="?page=${i}&year=${year}&month=${month}">${i + 1}</a>
													</li>
												</c:forEach>
											</ul>
										</nav>
									</c:if>
								</div>
						</div>
					</div>
				</div>
			</div>
		</section>
	</main>
	<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
	<script src="/js/lost/list.js"></script>
	
	<script>
		document.querySelector("i[data-content='근태']").parentElement.classList
				.add("bg-gradient-dark", "text-white")
		document.querySelector("#navTitle").textContent = "근태"
	</script>
</body>

</html>