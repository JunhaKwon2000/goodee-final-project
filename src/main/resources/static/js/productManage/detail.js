document.addEventListener("DOMContentLoaded", () => {
  const modalEl = document.getElementById('pmDetailModal');
  const pmDetailModal = new bootstrap.Modal(modalEl);
  const pmDetailTable = document.getElementById('pmDetailTable');
//  const pmDetailAttach = document.getElementById("pmDetailAttach");

  // 각 테이블 row에 클릭 이벤트 부여
  document.querySelectorAll("table tbody tr").forEach(row => {
    row.addEventListener("click", () => {
      const anchor = row.querySelector("a");
      const pmNum = anchor.getAttribute("href").split("/").pop();

      fetch(`/productManage/${pmNum}`)
        .then(res => res.json())
        .then(data => {
          console.log("📦 입출고내역 상세:", data);
		  const pmTypeStr = data.pmType == "80" ? "입고" : "출고";
          // 테이블
          pmDetailTable.innerHTML = `
            <tr><th>입출고번호</th><td>${data.pmNum}</td></tr>
            <tr><th>등록일자</th><td>${data.pmDate}</td></tr>
            <tr><th>작성자</th><td>${data.staffDTO ? data.staffDTO.staffName : undefined}</td></tr>
            <tr><th>물품타입</th><td>${data.productDTO && data.productDTO.productTypeDTO ? data.productDTO.productTypeDTO.productTypeName : undefined}</td></tr>
            <tr><th>물품명</th><td>${data.productDTO ? data.productDTO.productName : undefined} [${data.productDTO ? data.productDTO.productSpec : undefined}]</td></tr>
            <tr><th>구분</th><td>${pmTypeStr}</td></tr>
            <tr><th>등록수량</th><td>${data.pmAmount}</td></tr>
            <tr><th>잔여수량</th><td>${data.pmRemainAmount}</td></tr>
            <tr style="border-bottom: 1px solid #dee2e6;"><th>비고</th><td style="word-wrap: break-word; overflow-wrap: break-word; white-space: normal;">${data.pmNote}</td></tr>
          `;

          pmDetailModal.show();
        })
        .catch(err => {
          console.error("❌ 상세 정보 불러오기 실패:", err);
          alert("상세 정보를 불러오지 못했습니다.");
        });
    });
  });
});