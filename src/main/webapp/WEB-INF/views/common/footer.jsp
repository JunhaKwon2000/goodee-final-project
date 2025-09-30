<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<!DOCTYPE html>

<!-- Messenger -->
<div class="fixed-plugin" onclick="openMessenger()">
  <a class="fixed-plugin-button text-dark position-fixed px-3 py-2">
    <i class="material-symbols-rounded py-2">sms</i>
  </a>
</div>
<div class="fixed-plugin" onclick="openFault()">
  <a class="fixed-plugin-button text-dark position-fixed px-3 py-2"  style="bottom: 98px !important;">
    <i class="material-symbols-rounded py-2">build_circle</i>
  </a>
</div>

<!-- Popper.js -->
<script src="https://unpkg.com/@popperjs/core@2"></script>

<!-- Bootstrap 5.3.8 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>

<!-- Perfect Scrollbar -->
<script src="/js/perfect-scrollbar.min.js"></script>

<!-- SweetAlert 2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.23.0/dist/sweetalert2.all.min.js"></script>

<!-- Template JS -->
<script src="/js/material-dashboard.js"></script>

<script>
  function openMessenger() {
    window.open(
      "/msg",
      "MessengerWindow",
      "width=400,height=500,resizable=no,scrollbars=yes"
    );
  }
  function openFault() {
	    window.open(
	      "/fault/write",
	      "FaultWindow",
	      "width=400,height=500,resizable=no,scrollbars=yes"
	    );
	  }
</script>
