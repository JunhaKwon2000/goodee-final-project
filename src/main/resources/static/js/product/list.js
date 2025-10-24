function movePage(page) {
	if (page == null) page = 0
	const search = document.querySelector("#searchText").value
	
	if (search != null && search != "") {
		location.href = `/product?page=${page}&search=${search}`		
	} else {
		location.href = `/product?page=${page}`
	}
}

function downloadExcel() {
    const search = document.querySelector("#searchText").value.trim();
	
    // 파라미터 구성
    let url = `/product/excel?`;

    if (search) url += `search=${encodeURIComponent(search)}&`;

    // 마지막 & 제거
    url = url.replace(/&$/, "");

    // 엑셀 다운로드 이동
    location.href = url;
}