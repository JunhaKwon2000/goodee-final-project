function movePage(page) {
    if (page == null) page = 0;

    const search = document.querySelector("#searchText").value.trim();
    const startDateValue = document.querySelector("#startDate").value;
    const endDateValue = document.querySelector("#endDate").value;

    const startDate = new Date(startDateValue);
    const endDate = new Date(endDateValue);

    if (startDateValue && endDateValue && startDate > endDate) {
        Swal.fire({
            text: "시작일은 종료일보다 클 수 없습니다.",
            icon: "warning",
            showCancelButton: false,
            confirmButtonColor: "#191919",
            confirmButtonText: "확인"
        });
        return;
    }

    let url = `/lost?page=${page}`;

    if (search) url += `&search=${encodeURIComponent(search)}`;
    if (startDateValue) url += `&startDate=${startDateValue}`;
    if (endDateValue) url += `&endDate=${endDateValue}`;

    location.href = url;
}

function downloadExcel() {
    const search = document.querySelector("#searchText").value.trim();
    const startDateValue = document.querySelector("#startDate").value;
    const endDateValue = document.querySelector("#endDate").value;

    // 날짜 유효성 검사
    const startDate = new Date(startDateValue);
    const endDate = new Date(endDateValue);
	
    if (startDateValue && endDateValue && startDate > endDate) {
        Swal.fire({
            text: "시작일은 종료일보다 클 수 없습니다.",
            icon: "warning",
            confirmButtonColor: "#191919",
            confirmButtonText: "확인"
        });
        return;
    }
	
    // 파라미터 구성
    let url = `/lost/excel?`;

    if (search) url += `search=${encodeURIComponent(search)}&`;
    if (startDateValue) url += `startDate=${startDateValue}&`;
    if (endDateValue) url += `endDate=${endDateValue}&`;

    // 마지막 & 제거
    url = url.replace(/&$/, "");

    // 엑셀 다운로드 이동
    location.href = url;
}