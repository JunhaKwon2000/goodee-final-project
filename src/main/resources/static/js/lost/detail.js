document.addEventListener("DOMContentLoaded", () => {
  const modalEl = document.getElementById('lostDetailModal');
  const lostDetailModal = new bootstrap.Modal(modalEl);
  const lostDetailTable = document.getElementById('lostDetailTable');
  const lostDetailAttach = document.getElementById("lostDetailAttach");
  const buttonBox = document.getElementById("lostModalButtons");

  // 각 테이블 row에 클릭 이벤트 부여
  document.querySelectorAll("table tbody tr").forEach(row => {
    row.addEventListener("click", () => {
      const anchor = row.querySelector("a");
      const lostNum = anchor.getAttribute("href").split("/").pop();

      fetch(`/lost/${lostNum}`)
        .then(res => res.json())
        .then(data => {
          console.log("📦 분실물 상세:", data);

          // 이미지
		  lostDetailAttach.innerHTML =
			  data.lostAttachmentDTO &&
			  data.lostAttachmentDTO.attachmentDTO &&
			  data.lostAttachmentDTO.attachmentDTO.savedName
			    ? `<img width="300" height="300" style="object-fit: contain;" src="/file/lost/${data.lostAttachmentDTO.attachmentDTO.savedName}"/>`
			    : "";

          // 테이블
          lostDetailTable.innerHTML = `
            <tr><th>관리번호</th><td>${data.lostNum}</td></tr>
            <tr><th>등록일자</th><td>${data.lostDate}</td></tr>
            <tr><th>분실물명</th><td>${data.lostName}</td></tr>
            <tr><th>습득자 연락처</th><td>${data.lostFinder || ''} / ${data.lostFinderPhone || ''}</td></tr>
            <tr style="border-bottom: 1px solid #dee2e6;"><th>특이사항</th><td style="word-wrap: break-word; overflow-wrap: break-word; white-space: normal;">${data.lostNote || ''}</td></tr>
          `;

          // 로그인 사용자와 작성자 비교 후 버튼 표시
          const writerCode = data.staffDTO ? data.staffDTO.staffCode : undefined;
          console.log("👤 로그인:", loginStaffCode, "| 작성자:", writerCode);

          if (		  typeof loginStaffCode !== 'undefined' &&
		    typeof writerCode !== 'undefined' &&
		    String(loginStaffCode) === String(writerCode)) {
				buttonBox.classList.remove("d-none");
            buttonBox.style.display = "block";
            document.getElementById("lostUpdateBtn").onclick = () => {
              location.href = `/lost/${data.lostNum}/update`;
            };
            document.getElementById("lostDeleteForm").action = `/lost/${data.lostNum}/delete`;
          } else {
			buttonBox.classList.add("d-none");
            buttonBox.style.display = "none";
          }

          lostDetailModal.show();
        })
        .catch(err => {
          console.error("❌ 상세 정보 불러오기 실패:", err);
          alert("상세 정보를 불러오지 못했습니다.");
        });
    });
  });
});