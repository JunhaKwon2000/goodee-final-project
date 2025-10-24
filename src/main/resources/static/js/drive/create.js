console.log('create_modal.js 연결')

let staffs = [];
let currentDept = null;

// 메인
const shareStaffs = document.querySelectorAll('.shareStaff');

// 공유 사원 모달
const btnShowModalShare = document.getElementById("btnShowModalShare");
const btnMoveToRight = document.getElementById('btnMoveToRight');              // 회원 추가
const selectedList = document.getElementById("selectedList");  // 추가된 회원
const saveBtn = document.getElementById('saveStaffBtn');       // 추가된 회원 저장
const deptBtn = document.querySelectorAll('.deptBtn');        // 부서 선택
const searchInput = document.getElementById('searchInput');    // 사원 검색
const checkAllStaff = document.getElementById("checkAllStaff");
const staffList = document.getElementById("staffList");
const btnClearList = document.getElementById("btnClearList");

/*
	드래그 이동
	jsp에 <script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script> 라이브러리 추가
	import한 modal.jsp 위에 위치시켜야함
*/
new Sortable(selectedList, {
	animation: 150,           // 드래그 애니메이션
	ghostClass: "drag-ghost", // 드래그 중인 요소 스타일
	chosenClass: "drag-chosen",
	dragClass: "dragging"
});

document.addEventListener('shown.bs.modal', function(e) { // shown.bs.modal 모달 창이 켜졌을때 실행
	if (e.target.id === 'shareModal') {
		fetch('/drive/staffList') // 사원 리스트 DB에서 조회
		.then(r => r.json())
		.then(r => {
			staffs = r; // 전역 변수에 저장
			staffs.sort((a, b) => a.jobDTO.jobCode - b.jobDTO.jobCode); // 직급별로 정렬
			staffs = staffs.filter(staff => staff.staffCode != loginStaffCode) // 본인 제외
			currentDept = staffs // 최초 선택된 부서는 전체로 초기화
			renderStaff(staffs); // 사원 리스트 랜더링
		})
		.catch(error => console.log('fetch에러', error))
	}
});

if(shareStaffs) {
	shareStaffs.forEach((tr) => {
		tr.querySelector('.remove-saved').addEventListener('click', () => {
				tr.remove(); 
		})		
	})	
}

// 모달창 닫히면 추가된 사원 목록 초기화
document.addEventListener("hidden.bs.modal", () => {
	selectedList.innerHTML = '';
	searchInput.value = '';
	const checkboxs = staffList.querySelectorAll('input[type="checkbox"]');
	checkboxs.forEach((chkbox) =>{
		chkbox.checked = false;
	})
	
	checkAllStaff.checked = false;
})

/* 모달창에 체크된 사원들 오른쪽으로 이동 */
btnMoveToRight.addEventListener('click', () => {
	const savedStaff = document.getElementById('savedStaff');

	// 체크되어있는 요소들을 가져옴
	const checkedInput = staffList.querySelectorAll('input[type="checkbox"]:checked');
	
	// 이미 추가되어있는 사원	
	const mainStaffCode = Array.from(savedStaff.querySelectorAll('input[type="hidden"')).map(input => input.value);
	
	// 중복 및 본인 추가 제외
	for (const check of checkedInput) {
		const staffCode = check.value;
		// 중복
		if (mainStaffCode.includes(staffCode)) {
			for(const chk of checkedInput) {
				chk.checked = false;				
			}
			Swal.fire({
		        text: "이미 추가된 사용자 입니다",
		        icon: "info",
		        confirmButtonColor: "#191919",
		        confirmButtonText: "확인"
	  	    });
			return;
		}
	}
 	
	// 체크된 사원들을 오른쪽으로 이동시킴
	checkedInput.forEach((check) => {
		const li = check.closest('li'); // chk.closest('li') 상위(부모)방향으로 이동하며 가장 가까운 li태그를 반환
		const text = li.querySelector('span').textContent // 사원 정보 태그 가져옴
		const staffCode = check.value; // StaffCode 가져옴 
		
		// 모달 오른쪽에 등록할 li 생성
		const newLi = document.createElement('li');
		newLi.className = 'list-group-item d-flex justify-content-between align-items-center';
		newLi.innerHTML = `<span data-staff-code="${staffCode}">${text}</span><button class="btn-close btn-close-white remove-btn" aria-label="Remove"></button>`;

		// 삭제 버튼 동작 추가		
		newLi.querySelector(`.remove-btn`).addEventListener('click', function () {
			newLi.remove();
		});
		
		// 추가된 리스트에 li 등록
		selectedList.appendChild(newLi);
		
		// 사원 리스트 체크박스 해제
		check.checked = false;
		
		// 전체 체크 박스 해제ㅐ
		checkAllStaff.checked = false;
	})
})

btnClearList.addEventListener("click", () => {
	selectedList.innerHTML = "";
})

checkAllStaff.addEventListener("click", () => {
	const checkboxs = staffList.querySelectorAll('input[type="checkbox"]');
	
	if(checkAllStaff.checked) {
		checkboxs.forEach(function (chkBox){
			chkBox.checked = checkAllStaff.checked;
		})
	} else {
		checkboxs.forEach(function (chkBox){
			chkBox.checked = checkAllStaff.checked;
		})
	}
})

/* 추가된 사원 저장(메인 컨텐츠에 추가) */
saveBtn.addEventListener('click', () => {
	const savedStaff = document.getElementById('savedStaff'); // tbody의 id
	
	// 요소 확인용 안전장치
	if(!savedStaff) {
		console.log('savedStaff 태그 없음')
		return;
	}
	
	// span에 저장된 data-staff-code를 가져오기 위함
	const spans = selectedList.querySelectorAll('span')
	
	spans.forEach((span) => {
		const staffCode = span.getAttribute('data-staff-code');
		
		const staff = staffs.find(s => s.staffCode == staffCode)
		// 반환된값이 없다면 종료
		if(!staff) return;
		
		// tr생성
		const tr = document.createElement('tr');
		tr.innerHTML = `
				<th scope="row">
				<button type="button" class="btn-close btn-close-white remove-saved" aria-label="Remove"></button>
				<input type="hidden" name="driveShareDTOs[${lastIndexOfStaffList}].staffDTO.staffCode" value="${staff.staffCode}">
				</th>
				<td><i class="material-symbols-rounded opacity-5 fs-5">contacts_product</i></td>
				<td>${staff.staffName}</td>
				<td>${staff.jobDTO.jobDetail}</td>
				<td>${staff.deptDTO.deptDetail}</td>`
				;
				
		lastIndexOfStaffList++;
		// 생성한 태그에 click이벤트 연결
		tr.querySelector('.remove-saved').addEventListener('click', () => {
			tr.remove(); 
		})		
		
		// 메인 컨텐츠에 추가
		savedStaff.appendChild(tr);
	})
	
	// 저장 후 모달 숨김 처리 및 추가된 사원 초기화
	const modalEl = document.getElementById('shareModal');
	const modal = bootstrap.Modal.getInstance(modalEl);
	if(modal) modal.hide();
	selectedList.innerHTML = '';
	
})

/* 부서 선택 */
deptBtn.forEach(d => {
	d.addEventListener('click', function(e){
		checkAllStaff.checked = false;
		const allStaffCheckboxName = document.getElementById("allStaffCheckboxName");
		
		searchInput.value = ''; // 부서 변경시 검색란 초기화
		const deptName = e.target.getAttribute('data-team'); // 버튼에 저장된 data-team 가져옴
		allStaffCheckboxName.textContent = deptName + " 전체";
		
		if(deptName == '전체') { // '전체' 일때만 모든 사원 출력
			allStaffCheckboxName.textContent = "전체";
			currentDept = staffs
			renderStaff(currentDept);
			return;
		}
		const DeptStaff = staffs.filter(s => s.deptDTO.deptDetail == deptName); // 부서에 해당하는 사원 필터링
		currentDept = DeptStaff.sort((a, b) => a.jobDTO.jobCode - b.jobDTO.jobCode); // 현재 부서 설정
		renderStaff(currentDept);
	})
})

/* 검색 - input이벤트 =  value값이 변경될때마다 감지 */
searchInput.addEventListener('input', (e) => {
	const keyword = e.target.value;
	
	// 현재 선택된 부서에서 이름,직급을 키워드로 검색 후 반환
	const filteredStaff = currentDept.filter(s => 
		s.staffName.includes(keyword) ||
		s.jobDTO.jobDetail.includes(keyword)
	);
	renderStaff(filteredStaff); // 결과물 랜더링
})


/* 모달창 사원 목록 랜더링 (매개변수 : 랜더링할 리스트) */
function renderStaff(list) {
	if(!staffList) return; // 태그확인 안전장치	
	
	staffList.innerHTML = ''; // 사원목록 초기화
	list.forEach(staff => {
		
		// li 태그 생성
		const li = document.createElement('li');
		li.className = 'list-group-item d-flex align-items-center'
		li.innerHTML = `<input type="checkbox" class="me-2" value="${staff.staffCode}">
		      <span>${staff.staffName}(${staff.jobDTO.jobDetail}) ${staff.deptDTO.deptDetail}</span>`;
	
		// 사원목록에 추가
		staffList.appendChild(li);
	})
	
	const staffListchkBoxes = staffList.querySelectorAll('input[type="checkbox"]');
	
	staffListchkBoxes.forEach(function (staffChkBox) {
		staffChkBox.addEventListener("click", () => {
			console.log("실행됨")
			const isAllchecked = Array.from(staffListchkBoxes).every(chkBox => chkBox.checked)
			checkAllStaff.checked = isAllchecked;
			const isAnyChecked = Array.from(staffListchkBoxes).some(chkBox => chkBox.checked)
			btnMoveToRight.disabled = !isAnyChecked;
		})
	})
	    
}

function deleteDrive(driveNum, driveDefaultNum) {
	if(driveDefaultNum != null) {
		Swal.fire({
	        text: "기본드라이브는 삭제할 수 없습니다!",
	        icon: "error",
	        confirmButtonColor: "#191919",
	        confirmButtonText: "확인"
  	    });
		return;
	}	
	
	Swal.fire({
	   title: "정말 삭제하시겠습니까?",
	   text: '삭제된 드라이브는 복구되지 않습니다.',
	   icon: "error",
	   showCancelButton: true,
	   confirmButtonColor: "#191919",
	   cancelButtonColor: "#FFFFFF",
	   confirmButtonText: "삭제",
	   cancelButtonText: "취소",
	   customClass: {
	       cancelButton: 'my-cancel-btn'
	     }
	}).then((result) => {
		if (!result.isConfirmed) {
	 	return;
		}
	
		let params = new URLSearchParams();	
		params.append('driveNum', driveNum);
		
		fetch('/drive/delete', {
			method : 'post',
			body: params
		})
		.then(r => r.json())
		.then(r => {
			if(r != null) {
				Swal.fire({
			        text: "드라이브 삭제 완료",
			        icon: "success",
			        confirmButtonColor: "#191919",
			        confirmButtonText: "확인"
		  	    })
				.then((result) => {
					if(result) location.href="/drive"
				})		
			}
		})
		.catch(e => {
			console.log("실패", e)
		});
	});
}

function restoreDrive(driveNum) {
	Swal.fire({
		text: '드라이브를 복원하시겠습니까?',
		icon: "question",
		showCancelButton: true,
		confirmButtonColor: "#191919",
		cancelButtonColor: "#FFFFFF",
		confirmButtonText: "삭제",
		cancelButtonText: "취소",
		customClass: {
			cancelButton: 'my-cancel-btn'
		}
	}).then((result) => {
		if (!result.isConfirmed) {
			return;
		}

		let params = new URLSearchParams();
		params.append('driveNum', driveNum);

		fetch('/drive/restore', {
			method: 'post',
			body: params
		})
			.then(r => r.json())
			.then(r => {
				if (r != null) {
					Swal.fire({
						text: "드라이브 복원 완료",
						icon: "success",
						confirmButtonColor: "#191919",
						confirmButtonText: "확인"
					})
						.then((result) => {
							if (result) location.href = "/drive"
						})
				}
			})
			.catch(e => {
				console.log("실패", e)
			});
	});
}


/* 사이드바 유지 */
window.addEventListener("load", () => {
  const COLLAPSE_KEY = "openDriveCollapses";

  // localStorage 초기화 (최초 1회만)
  let opened = JSON.parse(localStorage.getItem(COLLAPSE_KEY));

  if (!opened) {
    // 최초 접근 시에만 기본 드라이브 2개를 저장
    opened = [...DEFAULT_OPEN];
    localStorage.setItem(COLLAPSE_KEY, JSON.stringify(opened));
  }

  // collapse 열리고 닫힐 때 localStorage 갱신
  document.querySelectorAll('.collapse').forEach(collapse => {
    collapse.addEventListener('show.bs.collapse', () => {
      let openedNow = JSON.parse(localStorage.getItem(COLLAPSE_KEY)) || [];
      if (!openedNow.includes(collapse.id)) {
        openedNow.push(collapse.id);
        localStorage.setItem(COLLAPSE_KEY, JSON.stringify(openedNow));
      }
    });

    collapse.addEventListener('hide.bs.collapse', () => {
      let openedNow = JSON.parse(localStorage.getItem(COLLAPSE_KEY)) || [];
      openedNow = openedNow.filter(id => id !== collapse.id);
      localStorage.setItem(COLLAPSE_KEY, JSON.stringify(openedNow));
    });
  });

  // 페이지 로드 시 localStorage 기준으로 표시
  const openedFinal = JSON.parse(localStorage.getItem(COLLAPSE_KEY)) || [];
  document.querySelectorAll('.collapse').forEach(collapse => {
    if (openedFinal.includes(collapse.id)) {
      collapse.classList.add('show');   // 애니메이션 없이 즉시 표시
    } else {
      collapse.classList.remove('show');
    }
  });
});