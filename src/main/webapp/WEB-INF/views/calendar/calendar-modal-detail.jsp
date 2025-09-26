<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 상세보기 모달 -->
<div class="modal fade" id="eventDetailModal" tabindex="-1" aria-labelledby="viewEventTitle" aria-hidden="true">
  <!-- 가운데 정렬 + 내부 스크롤 -->
  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content rounded-4">
      <!-- 헤더 -->
      <div class="modal-header border-0">
        <h5 class="modal-title fw-semibold" id="viewEventTitle">월간 팀장 회의</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>

      <!-- 바디 -->
      <div class="modal-body pt-0">
        <!-- 날짜 -->
        <div class="mb-3">
          <div class="text-secondary" id="viewEventDate">2025-09-11 (목)</div>
        </div>

        <!-- 타입 -->
        <div class="d-flex align-items-center gap-2 mb-3">
          <!-- 타입 점: Bootstrap 배경색 유틸로 표시 -->
          <span class="d-inline-block rounded-circle bg-primary" style="width:12px;height:12px;" aria-hidden="true"></span>
          <span class="text-secondary" id="viewEventTypeText">사내 일정</span>
        </div>

        <!-- 내용 -->
        <div class="mb-4">
          <div class="text-secondary mb-2">내용</div>
          <!-- 회색 느낌: Bootstrap 배경 유틸 + 비활성 폼 -->
          <textarea id="viewEventContent"
                    class="form-control bg-body-tertiary border-0 text-body"
                    rows="4" style="resize: none;" readonly>월간 팀장 회의</textarea>
        </div>

        <!-- 등록자/일시 -->
        <div class="d-flex justify-content-between align-items-center">
          <div class="d-flex align-items-center gap-2">
            <span class="text-secondary">등록자</span>
            <span class="material-symbols-rounded align-middle">person</span>
            <span id="viewEventWriter">박요한</span>
          </div>
          <div class="text-secondary" id="viewEventCreatedAt">2025-08-31 12:28</div>
        </div>
      </div>

      <!-- 푸터 -->
      <div class="modal-footer border-0 justify-content-end gap-2">
        <button type="button" class="btn btn-outline-secondary btn-sm d-flex align-items-center gap-1" id="btnEditEvent">
          <span class="material-symbols-rounded fs-6">edit</span>
          <span class="d-none d-sm-inline">수정</span>
        </button>
        <button type="button" class="btn btn-outline-secondary btn-sm d-flex align-items-center gap-1" id="btnDeleteEvent">
          <span class="material-symbols-rounded fs-6">delete</span>
          <span class="d-none d-sm-inline">삭제</span>
        </button>
      </div>
    </div>
  </div>
</div>
