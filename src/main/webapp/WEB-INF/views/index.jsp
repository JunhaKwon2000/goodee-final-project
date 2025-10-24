<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>대시보드</title>
	
	<c:import url="/WEB-INF/views/common/header.jsp"></c:import>
	<style>
		.time-circle {
		  margin: 10px auto;
		  padding: 20px;
		  text-align: center;
		  border: 1px dashed #ccc;
		  border-radius: 50%;
		  width: 160px;
		  height: 160px;
		  display: flex;           /* flex로 변경 */
		  justify-content: center; /* 가운데 정렬 */
		  align-items: center;     /* 수직 중앙 정렬 */
		}
		
		.time-info {
		  text-align: center;
		  padding: 10px 0;
		}
	
		.times-row {
		  display: flex;
		  flex-direction: column; /* 세로로 나열 (한 줄에 두개면 row로 놔도됨) */
		  gap: 10px;
		  font-size: 12px;
		  line-height: 1.4;
		  width: 200px;
		}
		
		.button-row {
		  display: flex;
		  justify-content: center;
		  gap: 10px;
		}
		
		.button-row button {
		  padding: 8px 16px;
		  background-color: #1976d2;
		  border: none;
		  color: white;
		  border-radius: 4px;
		  cursor: pointer;
		}
		
		.dash-div {
		  overflow: auto;
		}
		
		.dash-div::-webkit-scrollbar {
		  display: none;
		}
		.fc-list-day-text { color: white; } 		
		.fc-list-day-cushion.fc-cell-shaded { background-color: #42424a; !important; }
		.my-event.type-2001.fc-list-event { background-color: #E67E22 !important; }
		.my-event.type-2002.fc-list-event { background-color: #2E86DE !important; }
		.my-event.type-2003.fc-list-event { background-color: #16A085 !important; }
		.fc-list-event-time { color: white; }
		.fc-list-event-title { color: white; }
 		.fc .fc-list-event.fc-event:hover { color: white }
		tr.fc-list-event:hover td {
		  background-color: inherit !important;
		  color: inherit !important;
		  box-shadow: none !important;
		  text-decoration: none !important;
		}
	</style>
</head>

<body class="g-sidenav-show bg-gray-100">
	<c:import url="/WEB-INF/views/common/sidebar.jsp"></c:import>
  
  <main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg">
    <c:import url="/WEB-INF/views/common/nav.jsp"></c:import>
    <section class="border-radius-xl bg-white ms-2 mt-2 me-3" style="height: 92vh; overflow: hidden scroll;">
    	<sec:authentication property="principal" var="staff" />
    
    	<article class="container col-10 gap-2 offset-1 d-flex justify-content-center align-items-center mt-5 p-1">
    		<div class="col-12 d-flex justify-content-start align-items-center" style="height: 10vh; border: 1px solid white; border-radius: 10px; box-shadow: 2px 2px 3px 3px grey;">
    			<div class="row">
	          <div class="col-auto">
	            <div class="position-relative">
	              <img width="80" height="80" style="object-fit: cover;" src="/file/staff/${ staff.staffAttachmentDTO.attachmentDTO.savedName }" alt="profile_image" class="border-radius-lg shadow-sm ms-2">
	            </div>
	          </div>
	          <div class="col-auto my-auto">
	            <div class="h-100">
	              <h5 class="mb-1">
	                ${ staff.staffName }
	              </h5>
	              <p class="mb-0 font-weight-normal text-sm">
	                ${ staff.jobDTO.jobDetail } / ${ staff.deptDTO.deptDetail }
	              </p>
	            </div>
	          </div>
	        </div>
    		</div>
    	</article>
    
	    <article class="container col-10 gap-2 offset-1 d-flex justify-content-center align-items-center mt-2">
	    	<div class="col-3" style="height: 35vh; border: 1px solid white; border-radius: 10px; box-shadow: 2px 2px 3px 3px grey;">
	    		<div class="time-info mt-2">
						<div class="time-circle">
							<div class="times-row">
								<span class="ms-2" style="width:100px;">출근: <span>${attendDTO.attendIn eq null ? "--:--:--" : attendDTO.formattedAttendIn}</span></span>
								<span class="ms-2" style="width:100px;">퇴근: <span>${attendDTO.attendOut eq null ? "--:--:--" : attendDTO.formattedAttendOut}</span></span>
							</div>
						</div>
						<div class="worktime mt-3">근무시간 : <span>${attendDTO.workTime eq null ? "미기록" : attendDTO.workTime}</span></div>
						<div class="button-row mt-2">
			  
							<c:choose>
								<c:when test="${attendDTO.attendIn eq null}">
									<form action="/attend/in" method="post">
										<button style="background-color:#1976d2;">출근</button>
									</form>
									<form action="/attend/out" method="post">
										<button disabled style="background-color:gray;">퇴근</button>
									</form>
								</c:when>
								
								<c:when test="${attendDTO.attendIn ne null and attendDTO.attendOut eq null}">
									<form action="/attend/in" method="post">
									<button disabled style="background-color:gray;">출근</button>
									</form>
									<form action="/attend/out" method="post">
									<button style="background-color:#1976d2;">퇴근</button>
									</form>
								</c:when>
								
								<c:otherwise>
									<form action="/attend/in" method="post">
									<button disabled style="background-color:gray;">출근</button>
									</form>
									<form action="/attend/out" method="post">
									<button disabled style="background-color:gray;">퇴근</button>
									</form>
								</c:otherwise>
							</c:choose>
						</div>
			     </div>
	    	</div>
	    	
	    	<div class="col-2 d-flex align-items-center justify-content-center" style="height: 35vh; border: 1px solid white; border-radius: 10px; box-shadow: 2px 2px 3px 3px grey;">
	    		<div id="weather-info" style="font-size:20px;">⏳ 불러오는 중...</div>
	    	</div>
	    	
	    	<div class="dash-div col-7 d-flex flex-column align-items-center justify-content-center" style="height: 35vh; border: 1px solid white; border-radius: 10px; box-shadow: 2px 2px 3px 3px grey;">
	    		<h4 class="mt-2" style="border-bottom: 1px solid #eee;">공지사항</h4>
          <c:if test="${ not empty noticeList }">
          	<div class="col-10 mt-2" style="min-height: 70%;">
          		<table class="table text-center">
		            <tr>
			            <td class="col-1">번호</td>
			            <td class="col-2">부서</td>
			            <td class="col-4">제목</td>
			            <td class="col-2">작성자</td>
			            <td class="col-2">작성일</td>
		            </tr>
		            
			          <c:forEach items="${noticeList}" var="notice">
			            <tr>
				            <td>${notice.noticeNum }</td>
				            <td>${notice.staffDTO.deptDTO.deptDetail }</td>
				            <td><a href="/notice/${ notice.noticeNum }">${ notice.noticeTitle }</a></td>
				            <td>${notice.staffDTO.staffName }</td>
				            <td>${notice.noticeDate }</td>
			            </tr>
			          </c:forEach>
				          
	          	</table>
			    	</div>
          </c:if>
          	
         	<c:if test="${ empty noticeList }">
         		<div class="d-flex flex-column justify-content-center align-items-center mt-2" style="min-height: 70%;">
					  	<img width="50" height="60" src="/images/nothing.png" />
					  	<span class="mt-5">정보가 없습니다.</span>
					  </div>
         	</c:if>
	    	</div>
	    </article>
	    
	    <article class="container col-10 gap-2 offset-1 d-flex justify-content-center align-items-center mt-2">
	    	<div class="dash-div col-3 d-flex flex-column align-items-center justify-content-center" style="height: 35vh; border: 1px solid white; border-radius: 10px; box-shadow: 2px 2px 3px 3px grey;">
	    		<h4 class="mt-2" style="border-bottom: 1px solid #eee;">어트랙션 운휴 현황</h4>
          <c:if test="${ not empty rides }">
          	<div class="col-10 mt-2" style="min-height: 70%;">
          		<table class="table text-center">
		            <tr>
		            	<td class="col-7">어트랙션</td>
		            	<td class="col-5">상태</td>
		            </tr>
		            
		          	<c:forEach items="${ rides }" var="ride">
			            <tr>
			            	<td>${ride.rideName }</td>
			            	<td>${ride.rideState eq 300 ? "운휴" : ride.rideState eq 400 ? "고장" : "점검"}</td>
			            </tr>
		          	</c:forEach>
		          	
		          </table>
			    	</div>
          </c:if>
          	
         	<c:if test="${ empty rides }">
         		<div class="d-flex flex-column justify-content-center align-items-center mt-2" style="min-height: 70%;">
					  	<img width="50" height="60" src="/images/nothing.png" />
					  	<span class="mt-5">정보가 없습니다.</span>
					  </div>
         	</c:if>
        </div>
        
        <div class="dash-div col-4 d-flex flex-column align-items-center justify-content-center" style="height: 35vh; border: 1px solid white; border-radius: 10px; box-shadow: 2px 2px 3px 3px grey;">
        	<h4 class="mt-2" style="border-bottom: 1px solid #eee;">오늘의 일정</h4>
        	<div id='calendar' class="mt-3" style="width: 90%;"></div>
        </div>
	    	
	    	<div class="dash-div col-5 d-flex flex-column align-items-center justify-content-center" style="height: 35vh; border: 1px solid white; border-radius: 10px; box-shadow: 2px 2px 3px 3px grey;">
	    		<h4 class="mt-2" style="border-bottom: 1px solid #eee;">내 결재 현황</h4>
          <c:if test="${ not empty approvalList }">
          	<div class="col-10 mt-2" style="min-height: 70%;">
          		<table class="table text-center">
		            <tr>
			            <td class="col-1">문서번호</td>
			            <td class="col-2">제목</td>
			            <td class="col-1">기안일</td>
			            <td class="col-1">결재순서</td>
		            </tr>
		            
		            <c:forEach items="${approvalList }" var="aprv">
		            
			            <tr>
				            <td>${aprv.aprvCode }</td>
				            <td><a href="/approval/${ aprv.aprvCode }" style="color: #737373;">${ aprv.aprvTitle }</a></td>
				            <td>${aprv.aprvDate }</td>
				            <td>${aprv.aprvCrnt } / ${aprv.aprvTotal }</td>
			            </tr>
			            
		            </c:forEach>
	          	</table>
			    	</div>
          </c:if>
          	
         	<c:if test="${ empty approvalList }">
         		<div class="d-flex flex-column justify-content-center align-items-center mt-2" style="min-height: 70%;">
					  	<img width="50" height="60" src="/images/nothing.png" />
					  	<span class="mt-5">정보가 없습니다.</span>
					  </div>
         	</c:if>
	    	</div>
	    </article>

    </section>
  </main>
	<c:import url="/WEB-INF/views/common/footer.jsp"></c:import>
	<script src="/js/weather/weather.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.19/index.global.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/dayjs@1/dayjs.min.js"></script>
	<script>
		document.querySelector("i[data-content='대시보드']").parentElement.classList.add("bg-gradient-dark", "text-white")
		document.querySelector("#navTitle").textContent = "대시보드"
	</script>
	<script>
		const calendarEl = document.getElementById("calendar");
		const calendarType = [2001, 2002, 2003]
		const calendar = new FullCalendar.Calendar(calendarEl, {
			 initialView: 'listDay',
			      locale: 'ko',
			    timezone: 'local',
			dayMaxEvents: true,
		      editable: false, // 드래그드롭, 잡아서 늘리기 가능 
			  expandRows: false, // 화면 높이에 맞게
			      height: '70%',
			 slotMinTime: "00:00:00",
			 slotMaxTime: "24:00:00",
			slotDuration: "01:00:00",
			  scrollTime: "00:00:00",
			  allDayText: '종일',
			nowIndicator: true, // 현재시간을 빨간 선으로 표시
			headerToolbar: false,
			eventClick: function(eventInfo) {},
			events: function(fetchInfo, successCallback, failureCallback) { // 일정 불러오기
				fetch(`/calendar/calList?calTypes=2001&calTypes=2002&calTypes=2003`, { method: 'GET' })
				.then(r => r.json())
				.then(cals => {
					if(!cals) return;
					const events = cals.map(cal => addInCalendar(cal))       // .filter(event => event !== null);
					console.log(events);
					successCallback(events); // 달력에 이벤트 반영
				})
				.catch(e => {
					console.error("이벤트 로딩 실패:", e);
					failureCallback(e);
				});
			}
		})
		calendar.render(); // 랜더링
		
		function addInCalendar(cal) {
			return {
				id: cal.calNum,              
				title: cal.calTitle,         
				allDay: cal.calIsAllDay,
				start: cal.calStart,         
				end: plusOneDay(cal),     
				backgroundColor: eventBgColor(cal.calType),
				borderColor: "transparent",
				classNames: ['my-event', 'type-' + cal.calType],
				editable : false,
				extendedProps: {
					calNum      : cal.calNum,
					calReg      : cal.calReg,
					calMod      : cal.calMod,
					calType     : cal.calType,
					calPlace    : cal.calPlace,
					calTitle    : cal.calTitle,
					calContent  : cal.calContent,
					calTypeName : cal.calTypeName,
					staffCode   : cal.staffDTO.staffCode,
					staffName   : cal.staffDTO.staffName,
					deptCode    : cal.staffDTO.deptDTO.deptCode,
					deptDetail  : cal.staffDTO.deptDTO.deptDetail
				}
			}
		}
		
		function plusOneDay(cal) {
			let modEndDate = cal.calEnd;
			
			if(cal.calIsAllDay) {
				modEndDate = dayjs(modEndDate).add(1, "day").toDate();
			}
			
			return modEndDate;
		}
		
		function eventBgColor(calType) {
			switch (calType) {
				case 2000 : return "red";
				case 2001 : return "#E67E22";
				case 2002 : return "#2E86DE";
				case 2003 : return "#16A085";
			}	
		}
	</script>
</body>

</html>